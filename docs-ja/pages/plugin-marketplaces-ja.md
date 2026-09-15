> ## Documentation Index
> Fetch the complete documentation index at: https://code.claude.com/docs/llms.txt
> Use this file to discover all available pages before exploring further.

# プラグインマーケットプレイスの作成と配布

> Claude Code 拡張機能を配布するためのプラグインマーケットプレイスを構築およびホストします。

**プラグインマーケットプレイス**は、他のユーザーにプラグインを配布できるカタログです。マーケットプレイスは、一元化された検出、バージョン追跡、自動更新、および複数のソースタイプ（Git リポジトリ、ローカルパスなど）のサポートを提供します。このガイドでは、チームやコミュニティとプラグインを共有するための独自のマーケットプレイスを作成する方法を説明します。

既存のマーケットプレイスからプラグインをインストールしたいですか？[既成プラグインの検出とインストール](/docs/ja/discover-plugins)を参照してください。

<h2 id="overview">
  概要
</h2>

マーケットプレイスの作成と配布には、以下が含まれます。

1. **プラグインの作成**：skills、agents、hooks、MCP サーバー、または LSP サーバーを使用して 1 つ以上のプラグインを構築します。このガイドでは、配布するプラグインが既にあることを前提としています。プラグインの作成方法の詳細については、[プラグインの作成](/docs/ja/plugins)を参照してください。
2. **マーケットプレイスファイルの作成**：プラグインとその場所を一覧表示する `marketplace.json` を定義します。[マーケットプレイスファイルの作成](#create-the-marketplace-file)を参照してください。
3. **マーケットプレイスのホスト**：GitHub、GitLab、または別の Git ホストにプッシュします。[マーケットプレイスのホストと配布](#host-and-distribute-marketplaces)を参照してください。
4. **ユーザーと共有**：ユーザーが `/plugin marketplace add` でマーケットプレイスを追加し、個別のプラグインをインストールします。[プラグインの検出とインストール](/docs/ja/discover-plugins)を参照してください。

マーケットプレイスがライブになったら、リポジトリに変更をプッシュして更新できます。ユーザーは `/plugin marketplace update` でローカルコピーを更新します。

<h2 id="walkthrough-create-a-local-marketplace">
  チュートリアル：ローカルマーケットプレイスの作成
</h2>

この例では、1 つのプラグイン（コードレビュー用の `quality-review` skill）を含むマーケットプレイスを作成します。ディレクトリ構造を作成し、skill を追加し、プラグインマニフェストとマーケットプレイスカタログを作成してから、インストールしてテストします。

<Steps>
  <Step title="ディレクトリ構造の作成">
    ```bash theme={null}
    mkdir -p my-marketplace/.claude-plugin
    mkdir -p my-marketplace/plugins/quality-review-plugin/.claude-plugin
    mkdir -p my-marketplace/plugins/quality-review-plugin/skills/quality-review
    ```
  </Step>

  <Step title="skill の作成">
    `quality-review` skill が何をするかを定義する `SKILL.md` ファイルを作成します。

    ```markdown my-marketplace/plugins/quality-review-plugin/skills/quality-review/SKILL.md theme={null}
    ---
    description: Review code for bugs, security, and performance
    ---

    Review the code I've selected or the recent changes for:
    - Potential bugs or edge cases
    - Security concerns
    - Performance issues
    - Readability improvements

    Be concise and actionable.
    ```
  </Step>

  <Step title="プラグインマニフェストの作成">
    プラグインを説明する `plugin.json` ファイルを作成します。マニフェストは `.claude-plugin/` ディレクトリに配置されます。

    ```json my-marketplace/plugins/quality-review-plugin/.claude-plugin/plugin.json theme={null}
    {
      "name": "quality-review-plugin",
      "description": "Adds a quality-review skill for quick code reviews",
      "version": "1.0.0",
      "author": {
        "name": "Your Name"
      }
    }
    ```

    <Note>
      `version` を設定すると、ユーザーはこのフィールドを変更した場合にのみ更新を受け取ります。そのため、リリースのたびにバージョンを上げてください。[`command` ソース](#command-sources)を持つプラグインはこのフィールドでピン留めされません。`version` を省略した場合、バージョンは[バージョン管理](/docs/ja/plugins-reference#version-management)の次のソースから取得されます。
    </Note>
  </Step>

  <Step title="マーケットプレイスファイルの作成">
    プラグインを一覧表示するマーケットプレイスカタログを作成します。

    ```json my-marketplace/.claude-plugin/marketplace.json theme={null}
    {
      "name": "my-plugins",
      "owner": {
        "name": "Your Name"
      },
      "plugins": [
        {
          "name": "quality-review-plugin",
          "source": "./plugins/quality-review-plugin",
          "description": "Adds a quality-review skill for quick code reviews"
        }
      ]
    }
    ```
  </Step>

  <Step title="追加とインストール">
    `my-marketplace` を含むディレクトリから Claude Code を起動し、以下のコマンドを実行します。install コマンドはプラグイン詳細ビューを開き、インストールスコープを選択してインストールを確認します。インストール概要を確認します。`Run /reload-plugins to activate.` と報告される場合は、[プラグイン変更の再起動なしでの適用](/docs/ja/discover-plugins#apply-plugin-changes-without-restarting)を参照してください。

    ```shell theme={null}
    /plugin marketplace add ./my-marketplace
    /plugin install quality-review-plugin@my-plugins
    ```
  </Step>

  <Step title="試してみる">
    エディタでコードを選択し、新しい skill を実行します。プラグイン skill はプラグイン名でネームスペース化されます。

    ```shell theme={null}
    /quality-review-plugin:quality-review
    ```
  </Step>
</Steps>

プラグインが実行できることの詳細（hooks、agents、MCP サーバー、LSP サーバーを含む）については、[プラグイン](/docs/ja/plugins)を参照してください。

<Note>
  **プラグインのインストール方法**：ユーザーがプラグインをインストールすると、Claude Code はプラグインディレクトリをキャッシュロケーションにコピーします。ただし、[link mode](#copy-mode-and-link-mode) の [`command` ソース](#command-sources)は代わりに使用されます。コピーされたプラグインは、`../shared-utils` のようなパスを使用してプラグインディレクトリの外部のファイルを参照できません。これらのファイルはコピーされないためです。

  プラグイン間でファイルを共有する必要がある場合は、symlinks を使用します。詳細については、[プラグインキャッシングとファイル解決](/docs/ja/plugins-reference#plugin-caching-and-file-resolution)を参照してください。
</Note>

<h2 id="create-the-marketplace-file">
  マーケットプレイスファイルの作成
</h2>

リポジトリルートに `.claude-plugin/marketplace.json` を作成します。このファイルは、マーケットプレイスの名前、所有者情報、およびソースを含むプラグインのリストを定義します。

各プラグインエントリには、最低限 `name` と `source`（Claude Code がどこから取得するかを指定）が必要です。利用可能なすべてのフィールドについては、以下の[完全なスキーマ](#marketplace-schema)を参照してください。

```json theme={null}
{
  "name": "company-tools",
  "owner": {
    "name": "DevTools Team",
    "email": "devtools@example.com"
  },
  "plugins": [
    {
      "name": "code-formatter",
      "source": "./plugins/formatter",
      "description": "Automatic code formatting on save",
      "version": "2.1.0",
      "author": {
        "name": "DevTools Team"
      }
    },
    {
      "name": "deployment-tools",
      "source": {
        "source": "github",
        "repo": "company/deploy-plugin"
      },
      "description": "Deployment automation tools"
    }
  ]
}
```

<h2 id="marketplace-schema">
  マーケットプレイススキーマ
</h2>

<h3 id="required-fields">
  必須フィールド
</h3>

| フィールド     | タイプ    | 説明                                                                                                                                                                                                                                                                                                                                                  | 例              |
| :-------- | :----- | :-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | :------------- |
| `name`    | string | ケバブケースのマーケットプレイス識別子。スペース、制御文字、双方向フォーマット文字は含まれません。これは公開向けです。ユーザーはプラグインをインストールするときに表示されます（例：`/plugin install my-tool@your-marketplace`）。各ユーザーは、マーケットプレイス名ごとに 1 つのマーケットプレイスのみを登録できます。同じ名前の 2 番目のマーケットプレイスを追加すると、Claude Code は最初のマーケットプレイスを置き換えます。1 つのマーケットプレイス名の下に複数のプラグインを公開するには、すべてを [単一の `marketplace.json`](#create-the-marketplace-file) にリストします。 | `"acme-tools"` |
| `owner`   | object | マーケットプレイスメンテナー情報（[以下のフィールドを参照](#owner-fields)）                                                                                                                                                                                                                                                                                                      |                |
| `plugins` | array  | 利用可能なプラグインのリスト                                                                                                                                                                                                                                                                                                                                      | 以下を参照          |

<Note>
  **予約名**：以下のマーケットプレイス名は Anthropic の公式使用のために予約されており、サードパーティのマーケットプレイスでは使用できません：`claude-code-marketplace`、`claude-code-plugins`、`claude-plugins-official`、`claude-plugins-community`、`claude-community`、`anthropic-marketplace`、`anthropic-plugins`、`agent-skills`、`anthropic-agent-skills`、`knowledge-work-plugins`、`life-sciences`、`claude-for-legal`、`claude-for-financial-services`、`financial-services-plugins`、`first-party-plugins`、`claude-tag-plugins`、`healthcare`。公式マーケットプレイスになりすましている名前（`official-claude-plugins` や `anthropic-plugins-v2` など）もブロックされています。これらの名前を予約することで、サードパーティのマーケットプレイスが Anthropic 公開ソースとして自らを提示することを防ぎます。

  Claude Code は、マーケットプレイスを追加するときだけでなく、マーケットプレイスをロードするたびに予約名を再チェックします。これらの名前の 1 つの下に登録されていたマーケットプレイスが、その名前が予約されるようになると、ロードが停止し、[信頼できないソースから登録されている](/docs/ja/errors#marketplace-is-registered-from-an-untrusted-source)ことを報告します。そのマーケットプレイスを削除し、公式 Anthropic ソースから再度追加してください。新しく予約された名前の影響を受けるサードパーティのマーケットプレイスは、別の名前の下で再度追加するとすぐにロードされます。v2.1.205 より前では、`first-party-plugins` と `healthcare` は予約されておらず、予約名の下に既に登録されているマーケットプレイスはロードされ続けていました。v2.1.265 より前では、`claude-tag-plugins` は予約されていませんでした。
</Note>

<h3 id="owner-fields">
  所有者フィールド
</h3>

| フィールド   | タイプ    | 必須  | 説明                              |
| :------ | :----- | :-- | :------------------------------ |
| `name`  | string | はい  | メンテナーまたはチームの名前                  |
| `email` | string | いいえ | メンテナーの連絡先メール                    |
| `url`   | string | いいえ | ウェブサイト、GitHub プロフィール、または組織の URL |

<h3 id="optional-fields">
  オプションフィールド
</h3>

| フィールド                                 | タイプ    | 説明                                                                                                                                                                                                   |
| :------------------------------------ | :----- | :--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `$schema`                             | string | エディターのオートコンプリートと検証用の JSON Schema URL。Claude Code はロード時にこのフィールドを無視します。                                                                                                                                |
| `description`                         | string | マーケットプレイスの簡潔な説明                                                                                                                                                                                      |
| `version`                             | string | マーケットプレイスマニフェストバージョン                                                                                                                                                                                 |
| `metadata.pluginRoot`                 | string | Claude Code が裸のプラグインソース名を解決するディレクトリ。[相対パス](#relative-paths)を参照してください。Claude Code v2.1.239 以降が必要です。                                                                                                   |
| `allowCrossMarketplaceDependenciesOn` | array  | このマーケットプレイス内のプラグインが依存する可能性のある他のマーケットプレイス。ここにリストされていないマーケットプレイスからの依存関係はインストール時にブロックされます。[別のマーケットプレイスからプラグインに依存する](/docs/ja/plugin-dependencies#depend-on-a-plugin-from-another-marketplace)を参照してください。      |
| `renames`                             | object | プラグインの以前の `name` から現在の名前へのマッピング、またはプラグインが削除された場合は `null`。マーケットプレイス内のエントリの名前を変更または削除するときに、既存ユーザーが自動的に移行できるようにします。[プラグインの名前変更または削除](#rename-or-remove-a-plugin)を参照してください。Claude Code v2.1.193 以降が必要です。 |

`description` と `version` は後方互換性のため `metadata` の下でも受け入れられます。

<h2 id="plugin-entries">
  プラグインエントリ
</h2>

`plugins` 配列内の各プラグインエントリは、プラグインとその場所を説明します。[プラグインマニフェストスキーマ](/docs/ja/plugins-reference#plugin-manifest-schema)のフィールド（`description`、`version`、`author`、`commands`、`hooks` など）を含めることができます。さらに、これらのマーケットプレイス固有のフィールド：`source`、`category`、`tags`、`strict`、`relevance`、`headers`、および `headersHelper` があります。

<h3 id="required-fields-2">
  必須フィールド
</h3>

| フィールド    | タイプ            | 説明                                                                                                                     |
| :------- | :------------- | :--------------------------------------------------------------------------------------------------------------------- |
| `name`   | string         | ケバブケースのプラグイン識別子。スペース、制御文字、双方向フォーマット文字は含まれません。これは公開向けです。ユーザーはインストール時に表示されます（例：`/plugin install my-plugin@marketplace`）。 |
| `source` | string\|object | プラグインを取得する場所（以下の[プラグインソース](#plugin-sources)を参照）                                                                        |

<h3 id="optional-plugin-fields">
  オプションプラグインフィールド
</h3>

**標準メタデータフィールド：**

| フィールド            | タイプ     | 説明                                                                                                                                                                                                                                     |
| :--------------- | :------ | :------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `displayName`    | string  | UI サーフェスに表示される人間が読める名前。エントリもプラグインの `plugin.json` も設定しない場合、ユーザーはプラグインの `name` を表示されます。スペースと任意の大文字小文字を含めることができます。名前空間指定またはルックアップには使用されません。                                                                                               |
| `description`    | string  | プラグインの簡潔な説明                                                                                                                                                                                                                            |
| `version`        | string  | プラグインバージョン。設定されている場合（ここまたは `plugin.json` で）、プラグインはこの文字列にピン留めされ、ユーザーは変更時にのみ更新を受け取ります。[コマンドソース](#command-sources)を持つプラグインは、どちらのフィールドでもピン留めされません。どちらにも設定されていない場合、バージョンは[バージョン管理](/docs/ja/plugins-reference#version-management)の次のソースから取得されます。 |
| `author`         | object  | プラグイン作成者情報（`name` は必須、`email` と `url` はオプション）                                                                                                                                                                                          |
| `homepage`       | string  | プラグインホームページまたはドキュメント URL                                                                                                                                                                                                               |
| `repository`     | string  | ソースコードリポジトリ URL                                                                                                                                                                                                                        |
| `license`        | string  | SPDX ライセンス識別子（例：MIT、Apache-2.0）                                                                                                                                                                                                        |
| `keywords`       | array   | プラグイン検出と分類用のタグ                                                                                                                                                                                                                         |
| `metadata`       | object  | エンタイトルメントやカタログデータなど、独自のフィールド用のフリーフォームオブジェクト。Claude Code はこれを読みません。v2.1.222 より前では、`claude plugin validate` はキーを認識されないフィールドとして報告していました。                                                                                                  |
| `category`       | string  | 整理用のプラグインカテゴリ                                                                                                                                                                                                                          |
| `tags`           | array   | 検索可能性用のタグ                                                                                                                                                                                                                              |
| `strict`         | boolean | `plugin.json` がコンポーネント定義の権限であるかどうかを制御します（デフォルト：true）。以下の[厳密モード](#strict-mode)を参照してください。                                                                                                                                                |
| `relevance`      | object  | Claude Code がこのプラグインをユーザーに提案するタイミングを示すシグナル。管理者が管理設定でホワイトリストに登録したマーケットプレイスに対してのみ有効になります。[組織向けプラグインの推奨](/docs/ja/plugin-relevance)を参照してください。                                                                                                  |
| `defaultEnabled` | boolean | プラグインがインストール後に有効になるかどうか（デフォルト：true）。ユーザーがオプトインするまでプラグインを無効にしてインストールする場合は `false` に設定します。プラグインの `plugin.json` 内の同じフィールドより優先されます。[デフォルト有効化](/docs/ja/plugins-reference#default-enablement)を参照してください。                                          |

**コンポーネント設定フィールド：**

| フィールド        | タイプ            | 説明                                         |
| :----------- | :------------- | :----------------------------------------- |
| `skills`     | string\|array  | `<name>/SKILL.md` を含む skill ディレクトリへのカスタムパス |
| `commands`   | string\|array  | フラットな `.md` skill ファイルまたはディレクトリへのカスタムパス    |
| `agents`     | string\|array  | agent ファイルへのカスタムパス                         |
| `hooks`      | string\|object | カスタム hooks 設定または hooks ファイルへのパス            |
| `mcpServers` | string\|object | MCP サーバー設定または MCP 設定ファイルへのパス               |
| `lspServers` | string\|object | LSP サーバー設定または LSP 設定ファイルへのパス               |

**アーカイブ認証フィールド：**

エントリが認証情報を必要とするサーバー上の[`archive` ソース](#zip-archives)を持つ場合、これらを設定します。

| フィールド           | タイプ    | 説明                                                                                                                                                                                                                        |
| :-------------- | :----- | :------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| `headers`       | object | Claude Code がこのエントリのアーカイブをダウンロードするときに送信する HTTP ヘッダー。マーケットプレイスの同じ名前のヘッダーをオーバーライドします。Claude Code v2.1.238 以降が必要です。                                                                                                          |
| `headersHelper` | string | このエントリのアーカイブダウンロード用の HTTP ヘッダーを 1 つの JSON オブジェクトとして出力するコマンド。有効期限が切れる認証情報用です。[アーカイブダウンロードの認証](#authenticate-archive-downloads)を参照してください。エントリは [`"strict": false`](#strict-mode) も設定する必要があります。Claude Code v2.1.238 以降が必要です。 |

<h2 id="plugin-sources">
  プラグインソース
</h2>

プラグインソースは、Claude Code にマーケットプレイスにリストされた各プラグインをどこから取得するかを指示します。これらは `marketplace.json` の各プラグインエントリの `source` フィールドで設定されます。

Claude Code は、インストール済みの各プラグインをローカルバージョン管理されたプラグインキャッシュ（`~/.claude/plugins/cache`）にコピーします。ただし、[リンクモードの `command` ソース](#copy-mode-and-link-mode)は例外で、Claude Code はこれをその場で使用します。Claude Code はまた、[プラグインの対象となる Node.js パッケージ依存関係](/docs/ja/plugins-reference#node-js-package-dependencies)をキャッシュされたコピーにインストールします。

| ソース          | タイプ                         | フィールド                              | 注記                                                                                                                                                                                |
| ------------ | --------------------------- | ---------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| 相対パス         | `string`（例：`"./my-plugin"`） | なし                                 | マーケットプレイスリポジトリ内のローカルディレクトリ。`./` で始まる必要があります。ただし、[`metadata.pluginRoot` の下に裸の名前を記述する](#relative-paths)場合は除きます。Claude Code はパス を `.claude-plugin/` ディレクトリではなく、マーケットプレイスルートを基準に解決します |
| `github`     | object                      | `repo`, `ref?`, `sha?`             |                                                                                                                                                                                   |
| `url`        | object                      | `url`, `ref?`, `sha?`              | Git URL ソース                                                                                                                                                                       |
| `git-subdir` | object                      | `url`, `path`, `ref?`, `sha?`      | git リポジトリ内のサブディレクトリ。スパース部分クローンを使用して、モノレポの帯域幅を最小化します                                                                                                                               |
| `npm`        | object                      | `package`, `version?`, `registry?` | `npm install` でインストール                                                                                                                                                             |
| `archive`    | object                      | `url`, `sha256?`                   | HTTPS でダウンロードされた zip アーカイブ。ユーザーのマシンに git や npm がなくても動作します。Claude Code v2.1.224 以降が必要です                                                                                            |
| `command`    | object                      | `command`, `timeout?`, `mode?`     | ローカルコマンドを実行して生成されたプラグインディレクトリ。セッションごとに 1 回再実行して変更を反映します。Claude Code v2.1.229 以降が必要です                                                                                              |

<Note>
  **マーケットプレイスソースとプラグインソース**: これらは異なる概念で、異なるものを制御します。

  * **マーケットプレイスソース**: `marketplace.json` カタログ自体をどこから取得するか。ユーザーが `/plugin marketplace add` を実行するか、`extraKnownMarketplaces` 設定で設定されます。Git ベースのマーケットプレイスソースは `ref`（ブランチ/タグ）をサポートしますが、`sha` はサポートしません。
  * **プラグインソース**: マーケットプレイスにリストされた個別プラグインをどこから取得するか。`marketplace.json` 内の各プラグインエントリの `source` フィールドで設定されます。Git ベースのプラグインソースは `ref`（ブランチ/タグ）と `sha`（正確なコミット）の両方をサポートします。

  例えば、`acme-corp/plugin-catalog`（マーケットプレイスソース）でホストされているマーケットプレイスは、`acme-corp/code-formatter`（プラグインソース）から取得されたプラグインをリストできます。マーケットプレイスソースとプラグインソースは異なるリポジトリを指し、独立して固定されます。
</Note>

以下の Git ベースのソースタイプは `github`、`url`、および `git-subdir` です。`ref` と `sha` の両方が設定されている場合、`sha` が有効なピンになります。Claude Code はピンされたコミットを直接フェッチしてチェックアウトします。

GitHub、GitLab、Bitbucket を含むほとんどの git ホストでは、ブランチまたはタグが `ref` で指定されていても、その後アップストリームで削除されていても、コミットがリポジトリから到達可能である限り、インストールは成功します。AWS CodeCommit などの一部のサーバーは、SHA でコミットをフェッチすることをサポートしていません。これらのサーバーでは、`ref` が存在し、ピンされたコミットがそこから到達可能である必要があります。

**組織設定 > プラグイン** を通じてプラグインを配布する場合、一部のソースタイプのみが許可されます。[組織設定を通じた配布](#distribute-through-organization-settings)を参照してください。

<h3 id="relative-paths">
  相対パス
</h3>

同じリポジトリ内のプラグインの場合、`./` で始まるパスを使用します：

```json theme={null}
{
  "name": "my-plugin",
  "source": "./plugins/my-plugin"
}
```

パスはマーケットプレイスルート（`.claude-plugin/` を含むディレクトリ）を基準に解決されます。上記の例では、`marketplace.json` が `<repo>/.claude-plugin/marketplace.json` にあっても、`./plugins/my-plugin` は `<repo>/plugins/my-plugin` を指します。マーケットプレイスルートの外のパスを参照するために `../` を使用しないでください。macOS と Linux では、Claude Code は先頭の `./` より後のどこかにバックスラッシュがあるエントリパスを拒否するため、すべてのプラットフォームで区切り文字を `/` として記述してください。

裸の名前は、`"formatter"` のように `/` を含まない単一のディレクトリ名です。`./` パスの代わりに裸の名前を記述するには、[`metadata.pluginRoot`](#optional-fields) をそれらが解決されるディレクトリに設定します。`"pluginRoot": "./plugins"` の場合、Claude Code は `"source": "formatter"` を `./plugins/formatter` に解決します。Claude Code v2.1.239 以降が必要です。

`metadata.pluginRoot` 自体はマーケットプレイス内の相対パスである必要があります。Claude Code は既に `./` で始まるソースに対しては無視します。`team-a/formatter` のように `/` を含むソースは裸の名前ではなく、`metadata.pluginRoot` が設定されていても `./` プレフィックスが必要です。

<Note>
  Claude Code は相対パスをマーケットプレイスのローカルコピーに対して解決するため、ユーザーが git ソースまたはローカルディレクトリからマーケットプレイスを追加する場合に機能します。ユーザーが `marketplace.json` ファイルへの直接 URL を使用してマーケットプレイスを追加する場合、Claude Code はそのファイルのみをダウンロードするため、相対パスは解決されません。URL ベースの配布の場合は、代わりに他の[プラグインソース](#plugin-sources)を使用してください。詳細は[トラブルシューティング](#plugins-with-relative-paths-fail-in-url-based-marketplaces)を参照してください。
</Note>

<h3 id="github-repositories">
  GitHub リポジトリ
</h3>

```json theme={null}
{
  "name": "github-plugin",
  "source": {
    "source": "github",
    "repo": "owner/plugin-repo"
  }
}
```

特定のブランチ、タグ、またはコミットにピンできます：

```json theme={null}
{
  "name": "github-plugin",
  "source": {
    "source": "github",
    "repo": "owner/plugin-repo",
    "ref": "v2.0.0",
    "sha": "a1b2c3d4e5f6a7b8c9d0e1f2a3b4c5d6e7f8a9b0"
  }
}
```

| フィールド  | タイプ    | 説明                                            |
| :----- | :----- | :-------------------------------------------- |
| `repo` | string | 必須。`owner/repo` 形式の GitHub リポジトリ              |
| `ref`  | string | オプション。Git ブランチまたはタグ（デフォルトはリポジトリのデフォルトブランチ）    |
| `sha`  | string | オプション。正確なバージョンにピンするための 40 文字の完全な git コミット SHA |

<h3 id="git-repositories">
  Git リポジトリ
</h3>

```json theme={null}
{
  "name": "git-plugin",
  "source": {
    "source": "url",
    "url": "https://gitlab.com/team/plugin.git"
  }
}
```

特定のブランチ、タグ、またはコミットにピンできます：

```json theme={null}
{
  "name": "git-plugin",
  "source": {
    "source": "url",
    "url": "https://gitlab.com/team/plugin.git",
    "ref": "main",
    "sha": "a1b2c3d4e5f6a7b8c9d0e1f2a3b4c5d6e7f8a9b0"
  }
}
```

| フィールド | タイプ    | 説明                                                                                                                    |
| :---- | :----- | :-------------------------------------------------------------------------------------------------------------------- |
| `url` | string | 必須。完全な git リポジトリ URL（`https://` または `git@`）。`.git` サフィックスはオプションなので、サフィックスのない Azure DevOps と AWS CodeCommit URL が機能します |
| `ref` | string | オプション。Git ブランチまたはタグ（デフォルトはリポジトリのデフォルトブランチ）                                                                            |
| `sha` | string | オプション。正確なバージョンにピンするための 40 文字の完全な git コミット SHA                                                                         |

<h3 id="git-subdirectories">
  Git サブディレクトリ
</h3>

`git-subdir` を使用して、git リポジトリのサブディレクトリ内にあるプラグインを指します。Claude Code はスパース部分クローンを使用してサブディレクトリのみをフェッチし、大規模なモノレポの帯域幅を最小化します。

```json theme={null}
{
  "name": "my-plugin",
  "source": {
    "source": "git-subdir",
    "url": "https://github.com/acme-corp/monorepo.git",
    "path": "tools/claude-plugin"
  }
}
```

特定のブランチ、タグ、またはコミットにピンできます：

```json theme={null}
{
  "name": "my-plugin",
  "source": {
    "source": "git-subdir",
    "url": "https://github.com/acme-corp/monorepo.git",
    "path": "tools/claude-plugin",
    "ref": "v2.0.0",
    "sha": "a1b2c3d4e5f6a7b8c9d0e1f2a3b4c5d6e7f8a9b0"
  }
}
```

`url` フィールドは GitHub ショートハンド（`owner/repo`）または SSH URL（`git@github.com:owner/repo.git`）も受け入れます。

| フィールド  | タイプ    | 説明                                                       |
| :----- | :----- | :------------------------------------------------------- |
| `url`  | string | 必須。Git リポジトリ URL、GitHub `owner/repo` ショートハンド、または SSH URL |
| `path` | string | 必須。プラグインを含むリポジトリ内のサブディレクトリパス（例：`"tools/claude-plugin"`）  |
| `ref`  | string | オプション。Git ブランチまたはタグ（デフォルトはリポジトリのデフォルトブランチ）               |
| `sha`  | string | オプション。正確なバージョンにピンするための 40 文字の完全な git コミット SHA            |

<h3 id="npm-packages">
  npm パッケージ
</h3>

npm パッケージとして配布されるプラグインは `npm install` を使用してインストールされます。これは公開 npm レジストリまたはチームがホストするプライベートレジストリ上の任意のパッケージで機能します。

```json theme={null}
{
  "name": "my-npm-plugin",
  "source": {
    "source": "npm",
    "package": "@acme/claude-plugin"
  }
}
```

特定のバージョンにピンするには、`version` フィールドを追加します：

```json theme={null}
{
  "name": "my-npm-plugin",
  "source": {
    "source": "npm",
    "package": "@acme/claude-plugin",
    "version": "2.1.0"
  }
}
```

プライベートまたは内部レジストリからインストールするには、`registry` フィールドを追加します：

```json theme={null}
{
  "name": "my-npm-plugin",
  "source": {
    "source": "npm",
    "package": "@acme/claude-plugin",
    "version": "^2.0.0",
    "registry": "https://npm.example.com"
  }
}
```

| フィールド      | タイプ    | 説明                                                           |
| :--------- | :----- | :----------------------------------------------------------- |
| `package`  | string | 必須。パッケージ名またはスコープ付きパッケージ（例：`@org/plugin`）                     |
| `version`  | string | オプション。バージョンまたはバージョン範囲（例：`2.1.0`、`^2.0.0`、`~1.5.0`）           |
| `registry` | string | オプション。カスタム npm レジストリ URL。デフォルトはシステム npm レジストリ（通常は npmjs.org） |

<h3 id="zip-archives">
  Zip アーカイブ
</h3>

`archive` を使用して、Claude Code が HTTPS でダウンロードする zip ファイルとしてプラグインを配布します。これにより、ユーザーのマシンに git や npm がなくてもインストールが機能します。S3 バケット、Artifactory 汎用リポジトリ、nginx などの静的ファイルサーバーまたはアーティファクトリポジトリでファイルをホストします。Claude Code v2.1.224 以降が必要です。v2.1.120 から v2.1.223 では、プラグインのインストールが `This plugin uses a source type your Claude Code version does not support. Update Claude Code and try again.` で失敗します。より古いバージョンでは、`archive` エントリを含むマーケットプレイス全体がロードに失敗します。

このエントリはアーティファクトサーバー上の zip ファイルからプラグインをインストールします：

```json theme={null}
{
  "name": "my-plugin",
  "source": {
    "source": "archive",
    "url": "https://artifacts.example.com/claude-plugins/my-plugin-2.1.0.zip"
  }
}
```

zip を構築するときは、プラグインのコンテンツを直接 zip するか、プラグインフォルダ自体を zip できます。Claude Code はアーカイブの最上部で `.claude-plugin/` を探し、次に単一の最上位フォルダ内を探すため、両方のレイアウトがインストールされます：

```text theme={null}
my-plugin.zip          my-plugin.zip
├── .claude-plugin/    └── my-plugin/
│   └── plugin.json        ├── .claude-plugin/
└── commands/              │   └── plugin.json
                           └── commands/
```

Claude Code は 1 フォルダより深く探さないため、さらに下にネストされたプラグインはインストールに失敗します。Claude Code は 256 MiB より大きいアーカイブを拒否します。

正確なファイルにピンするには、アーカイブのダイジェストを含む `sha256` フィールドを追加します：

```json theme={null}
{
  "name": "my-plugin",
  "source": {
    "source": "archive",
    "url": "https://artifacts.example.com/claude-plugins/my-plugin-2.1.0.zip",
    "sha256": "6bfa50e3d2e00c052b46abe51fff89346ac803e45771f76dcf6df1ab74cca5e1"
  }
}
```

ダウンロードされたファイルがピンと一致しない場合、Claude Code はインストールを拒否し、[`Plugin archive integrity check failed`](/docs/ja/errors#plugin-archive-integrity-check-failed) を報告します。

アーカイブソースはこれらのフィールドを受け入れます：

| フィールド    | タイプ    | 説明                                                                                                                                                     |
| :------- | :----- | :----------------------------------------------------------------------------------------------------------------------------------------------------- |
| `url`    | string | 必須。zip アーカイブの HTTPS URL。Claude Code は `http://` URL、ループバック、リンクローカル、クラウドメタデータホストを拒否します。すべてのリダイレクトホップが同じルールを満たす必要があります。そうでない場合、Claude Code はダウンロードを拒否します |
| `sha256` | string | オプション。アーカイブの SHA-256 ダイジェスト（64 文字の 16 進数、大文字または小文字）。Claude Code はすべてのダウンロードに対してこれを検証し、不一致の場合はインストールを拒否します                                              |

`sha256` ダイジェストは、`plugin.json` またはマーケットプレイスエントリが宣言していない場合、プラグインのバージョンとしても機能します。[バージョン管理](/docs/ja/plugins-reference#version-management)を参照してください。`version` を宣言する場合、そのバージョン文字列が更新シグナルになるため、zip とそのダイジェストを変更した後、バージョンもバンプしてください。そうしないと、ユーザーはキャッシュされたコピーを保持し続けます。

<h4 id="authenticate-archive-downloads">
  アーカイブダウンロードの認証
</h4>

プライベートレジストリからのダウンロードなど、アーカイブダウンロードを認証するには、Claude Code が送信する HTTP ヘッダーを設定します。マーケットプレイスを登録した `url` ソース（[`extraKnownMarketplaces`](/docs/ja/settings-reference#extraknownmarketplaces) エントリなど）で `headers` を設定します。Claude Code v2.1.238 以降では、プラグインのエントリで `source` の隣に設定できます。

`headers` に入れる値が短命の場合（レジストリがリクエストで生成するトークンなど）、代わりに同じ場所に `headersHelper` コマンドを設定します。Claude Code はコマンドを実行し、それが出力する JSON オブジェクトをその場所のヘッダーとして送信します。Claude Code v2.1.238 以降が必要です。

選択した場所は、どのダウンロードがヘッダーを取得し、Claude Code がコマンドをいつ実行するかを決定します：

| 場所                  | ヘッダーを取得するダウンロード                                  | Claude Code が `headersHelper` をそこで実行する時期                                                              |
| :------------------ | :----------------------------------------------- | :---------------------------------------------------------------------------------------------------- |
| マーケットプレイス `url` ソース | マーケットプレイス URL のオリジン上のアーカイブダウンロード（同じスキーム、ホスト、ポート） | マーケットプレイスの `marketplace.json` の各フェッチの前と、そのオリジン上の各アーカイブダウンロードの前。Claude Code は 1 回の実行の出力を最大 60 秒間再利用します |
| プラグインエントリ           | そのエントリのダウンロードのみ                                  | ユーザーがそのプラグインを単独でインストールまたは更新し、[コマンドを受け入れる](#how-users-accept-a-headershelper-command)場合のみ              |

両方の場所が同じ名前のヘッダーを設定する場合、Claude Code はエントリの値を送信します。1 つの場所内で、コマンドが出力するヘッダーは同じ名前のリストされたヘッダーをオーバーライドします。

<h5 id="add-a-headershelper-to-a-plugin-entry">
  プラグインエントリに headersHelper を追加
</h5>

このエントリは `headersHelper` を `source` の隣に設定します。また、`"strict": false` を設定します。これは Claude Code が `headersHelper` を設定する `marketplace.json` エントリに必要です。[`"strict": false`](#strict-mode) では、マーケットプレイスエントリはプラグインの完全な定義なので、ユーザーはコマンドを受け入れる前にプラグインに含まれるものを確認できます：

```json theme={null}
{
  "name": "my-plugin",
  "description": "Formatting commands for internal services",
  "strict": false,
  "commands": "./commands",
  "source": {
    "source": "archive",
    "url": "https://registry.example.com/plugins/my-plugin-2.1.0.zip"
  },
  "headersHelper": "/opt/bin/mint-registry-token.sh"
}
```

エントリを確認するには、`claude plugin install my-plugin@your-marketplace` を実行します。Claude Code はコマンドとアーカイブ URL を表示し、受け入れた後に zip をダウンロードします。

v2.1.238 より前では、Claude Code はエントリのアーカイブを `headers` または `headersHelper` なしでダウンロードしたため、それらに依存するインストールは `HTTP 401 while downloading plugin archive from` で失敗し、その後に URL が続き、レジストリのステータスコードが 401 の代わりに表示されました。

<h4 id="write-the-headershelper-command">
  headersHelper コマンドを記述
</h4>

マーケットプレイスの `url` ソースまたはプラグインエントリで `headersHelper` を設定するかどうかに関わらず、コマンドがこれらの要件を満たすように記述します：

* **コマンドテキスト**: 最大 500 文字の印字可能 ASCII、4 文字以上の連続スペースなし。
* **出力**: ヘッダー名と文字列値の 1 つの JSON オブジェクトを stdout に出力し、10 秒以内に終了コード 0 で終了します。
* **シェルと作業ディレクトリ**: Claude Code はコマンドを `sh` または Windows では `cmd.exe` を通じて実行し、設定ディレクトリ（`~/.claude` または [`CLAUDE_CONFIG_DIR`](/docs/ja/env-vars#variables)）から実行します。相対パスはそのディレクトリに対して解決されるため（ユーザーのプロジェクトではなく）、絶対パスまたは `PATH` 上のコマンドを指定してください。
* **Claude Code が削除する変数**: `marketplace.json` エントリまたはプロジェクトの `.claude/settings.json` または `.claude/settings.local.json` で設定されたコマンドの環境から、Claude Code は `TOKEN`、`SECRET`、`KEY`、`AUTH` などの単語を含む名前を持つすべての変数を削除します（`ANTHROPIC_API_KEY` を含む）。Claude Code はこの削除をユーザー設定、`--settings` ファイル、または管理設定で設定されたコマンドには適用しません。
* **Claude Code が設定する変数**: `url` ソースのコマンドの場合は `CLAUDE_CODE_MARKETPLACE_URL` と `CLAUDE_CODE_MARKETPLACE_NAME`、エントリのコマンドの場合は `CLAUDE_CODE_PLUGIN_NAME` と `CLAUDE_CODE_PLUGIN_ARCHIVE_URL`。`CLAUDE_CODE_MARKETPLACE_NAME` は、ユーザーが URL でマーケットプレイスを追加した後の最初のフェッチでは設定されません。そのフェッチが名前を提供するためです。

ベアラートークンを生成するコマンドは、次のようなオブジェクトを出力します：

```json theme={null}
{"Authorization": "Bearer eyJhbGciOiJSUzI1NiJ9"}
```

<h4 id="when-claude-code-skips-a-headershelper-command-or-drops-its-output">
  Claude Code が headersHelper コマンドをスキップするか、その出力をドロップする場合
</h4>

Claude Code は `headersHelper` コマンドを実行しないか、これらの状況で `headers` または コマンドの出力から来たヘッダーをドロップします：

* **コマンド失敗**: コマンドが 0 以外で終了する、10 秒を超えて実行される、または JSON 文字列値のオブジェクト以外を出力する場合、Claude Code はそれが実行されたフェッチまたはダウンロードを実行しません。
* **マーケットプレイス URL が `https://` で始まらない**: Claude Code はその `url` ソースのコマンドを実行せず、`headers` フィールドにリストされたヘッダーのみを送信します。
* **リダイレクトがオリジンを離れる**: ダウンロードがアーカイブ URL のオリジンからリダイレクトされる場合、Claude Code はマーケットプレイス `url` ソースとプラグインエントリの両方の `headers` 値とコマンド出力をドロップします。
* **エントリがルーティングまたはアイデンティティヘッダーを設定**: Claude Code は `Host`、`Cookie`、`X-Forwarded-*` などのリクエストルーティングおよびクライアントアイデンティティ名をエントリの `headers` とコマンド出力からドロップし、`Authorization` などの認証名を保持します。Claude Code はすべての `marketplace.json` エントリをこの方法でフィルタリングし、[インライン設定エントリ](/docs/ja/settings-reference#extraknownmarketplaces)はそれを宣言するファイルに応じて。
* **`--add-dir` ディレクトリの設定で設定されたコマンド**: Claude Code はそれを無視し、`url` ソースと[インラインプラグインエントリ](/docs/ja/settings-reference#extraknownmarketplaces)の両方で、そのファイルの `headers` のみを送信します。
* **管理設定がコマンドをブロック**: [`disableCommandPluginSources`](/docs/ja/settings-reference#disablecommandpluginsources) を `true` に設定すると `headersHelper` コマンドがブロックされ、[`allowManagedHooksOnly`](/docs/ja/settings-reference#allowmanagedhooksonly) も `disableCommandPluginSources` が明示的に `false` でない限りそれらをブロックします。どちらのブロックでも、Claude Code は管理設定自体が宣言するマーケットプレイスのコマンドを実行します。

<h4 id="how-users-accept-a-headershelper-command">
  ユーザーが headersHelper コマンドを受け入れる方法
</h4>

ユーザーはプラグインエントリのコマンドを、そのプラグインを単独でインストールまたは更新するたびに受け入れます。これは `/plugin` のプラグイン自体のビューから、または `claude plugin install` または `claude plugin update` で行われます。Claude Code はコマンドとアーカイブ URL を表示し、ユーザーが受け入れた後にのみコマンドを実行します。非対話型シェルでは、[`--yes`](/docs/ja/plugins-reference#plugin-install) を `claude plugin install` または `claude plugin update` に渡して受け入れます。

Claude Code は表示したコマンドのみを実行し、表示したアーカイブ URL に対してのみ実行します。その間にエントリのコマンドまたはアーカイブ URL が変更された場合、Claude Code はインストールまたは更新を拒否します。クエリ文字列のみの変更はカウントされません。

<h5 id="installs-and-updates-that-refuse-the-command-instead-of-asking">
  コマンドを要求する代わりに拒否するインストールと更新
</h5>

単一プラグインのインストールまたは更新以外の操作では、Claude Code はエントリのコマンドを実行せず、そのアーカイブをダウンロードしないため、プラグインはインストール済みバージョンのままか、インストールされていないままです。ユーザーが見るものは操作によって異なります：

* **複数のプラグインを一度にインストール、プラグイン提案からインストール、または別のプラグインの依存関係としてインストール**: Claude Code はコマンドを持つプラグインを拒否し、ユーザーをそのプラグインの `/plugin` 内の独自のビューに指します。一括インストール内の他のプラグインはまだインストールされます。拒否されたプラグインに依存するプラグインは、ユーザーが拒否されたプラグインを単独でインストールするまでインストールに失敗します。
* **バックグラウンド自動更新、またはアーカイブがダウンロードされたことのないプラグインのセッション開始**: Claude Code は `/plugin` エラータブにプラグインをリストして、ユーザーが手動でインストールまたは更新することを知らせます。インストール済みバージョンをまだ宣伝している自動更新は何もリストしません。

<h5 id="when-a-marketplace-url-source’s-command-runs">
  マーケットプレイス `url` ソースのコマンドが実行される時期
</h5>

マーケットプレイス `url` ソースの `headersHelper` は、マーケットプレイスが公開するカタログではなく、[`extraKnownMarketplaces`](/docs/ja/settings-reference#extraknownmarketplaces) エントリなどの設定ファイルで宣言されるため、Claude Code は各インストールまたは更新でユーザーに受け入れを求めません。それを宣言する設定ファイルが Claude Code がいつそれを実行するかを決定します：

| 設定ファイル                                                            | Claude Code がコマンドを実行する時期                                                                                                                               |
| :---------------------------------------------------------------- | :----------------------------------------------------------------------------------------------------------------------------------------------------- |
| ユーザー設定、`--settings` ファイル、またはマシン上の管理設定ファイル                         | バックグラウンドマーケットプレイス更新を含め、要求なし                                                                                                                            |
| プロジェクトの `.claude/settings.json` または `.claude/settings.local.json` | ユーザーがそのフォルダ自体の[ワークスペーストラストダイアログ](/docs/ja/permissions#what-runs-before-you-trust-a-folder)を受け入れた後のみ。`-p` または SDK セッションはそれとしてカウントされず、親フォルダに付与された信頼もカウントされません |
| サーバー管理設定                                                          | ユーザーが[セキュリティ承認ダイアログ](/docs/ja/server-managed-settings#security-approval-dialogs)で配信された設定を承認した後のみ                                                            |

`-p` または SDK セッションでは、Claude Code はセキュリティ承認ダイアログを表示できません。他の配信された設定を適用しますが、マーケットプレイスフェッチと、コマンドが必要なアーカイブダウンロードは、ユーザーが対話型セッションで承認するまで失敗します。

これらのファイルの[インラインプラグインエントリ](/docs/ja/settings-reference#extraknownmarketplaces)の場合、Claude Code はそのファイル内のマーケットプレイスレベルのコマンドと同じフォルダ信頼または設定承認を要求し、ユーザーは各インストールまたは更新でエントリのコマンドも受け入れます。

<h3 id="command-sources">
  コマンドソース
</h3>

ローカルにインストールされたツールがプラグインディレクトリを生成する場合（現在選択されているツールチェーンのプラグインをレンダリングする IDE など）に `command` を使用します。Claude Code はユーザーがプラグインをインストールするときにコマンドを実行し、セッションごとに 1 回バックグラウンドで再実行するため、ユーザーは再インストールなしでツールの変更された出力を取得します。Claude Code v2.1.229 以降が必要です。v2.1.120 から v2.1.228 では、プラグインのインストールが `This plugin uses a source type your Claude Code version does not support. Update Claude Code and try again.` で失敗し、より古いバージョンではマーケットプレイス全体がロードに失敗します。

このエントリはツールが出力するディレクトリからプラグインをインストールします：

```json theme={null}
{
  "name": "my-plugin",
  "source": {
    "source": "command",
    "command": "my-tool claude-plugin-path"
  }
}
```

Claude Code はプラットフォームシェル（macOS と Linux では `sh`、Windows では `cmd.exe`）を通じてコマンドを実行し、ユーザーのホームディレクトリから実行します。コマンドは stdout に正確に 1 行を出力し、終了コード 0 で終了する必要があります。その行は、コマンドが終了するまでに完全なプラグインを含むディレクトリの絶対パスであり、パスは実行間で変更される可能性があります。

Claude Code は `timeout` 秒より長く実行されるコマンドを停止し、インストールまたは更新は失敗します。Claude Code はこれらの場合にも出力されたパスを拒否し、インストールまたは更新は同じ方法で失敗します：

* ディレクトリの最上部にプラグインコンテンツがない（`.claude-plugin/` ディレクトリ、または `skills/`、`commands/`、`agents/`、`hooks/` ディレクトリなど）
* ディレクトリは Claude Code が開始されたディレクトリ、またはその親の 1 つ
* Windows では、パスは UNC パス

コマンドソースはこれらのフィールドを受け入れます：

| フィールド     | タイプ    | 説明                                                                                                                                     |
| :-------- | :----- | :------------------------------------------------------------------------------------------------------------------------------------- |
| `command` | string | 必須。プラグインディレクトリの絶対パスを stdout の単一行として出力し、0 で終了するシェルコマンド。ユーザーが受け入れるよう求められるコマンド全体を確認できるように、印字可能 ASCII で最大 500 文字、4 文字以上の連続スペースなし           |
| `timeout` | number | オプション。コマンドを待つ秒数（デフォルト：60、最大：600）                                                                                                       |
| `mode`    | string | オプション。`"copy"`（デフォルト）は出力されたディレクトリをプラグインキャッシュにコピーします。`"link"` は出力されたディレクトリをその場で使用します。[コピーモードとリンクモード](#copy-mode-and-link-mode)を参照してください |

<h4 id="copy-mode-and-link-mode">
  コピーモードとリンクモード
</h4>

デフォルトの `"mode": "copy"` では、Claude Code は出力されたディレクトリをバージョン管理されたプラグインキャッシュにコピーし、ディレクトリのコンテンツのハッシュから[プラグインバージョン](/docs/ja/plugins-reference#version-management)を導出します。ツールはコマンドが終了した後にディレクトリを削除または上書きでき、同じコンテンツを生成する再実行は最新とカウントされます。Claude Code は 256 MiB より大きいディレクトリまたは 20,000 を超えるエントリを含むディレクトリのインストールを拒否します。

大規模なプラグインディレクトリ（レンダリングされた SDK エクスポートなど）をコピーしてはいけない場合は、`"mode": "link"` を設定します。Claude Code は出力されたディレクトリの各最上位エントリへのリンクでプラグインのキャッシュエントリを埋め、ファイルをその場で使用するため、何もコピーされず、ファイルコンテンツはハッシュされず、サイズ制限は適用されません。最上位エントリが出力されたディレクトリの外を指すシンボリックリンクの場合、インストールは失敗します。Claude Code はリンクモードプラグインの[Node.js パッケージ依存関係インストール](/docs/ja/plugins-reference#node-js-package-dependencies)もスキップするため、プラグインが必要とする `node_modules` を既に含むディレクトリを出力します。

プラグインがインストール状態を保つ限り、出力されたディレクトリをその場に保ちます。Claude Code はすべての起動でそれらのリンクを通じてプラグインをロードするためです。Claude Code は[プラグインバージョン](/docs/ja/plugins-reference#version-management)を出力されたディレクトリの実パスとその最上位エントリから導出し、内部のファイルからではないため、新しいコンテンツを通知するために異なるパスを出力します。出力されたディレクトリまたはその下のどこかで開始されたセッションでは、Claude Code はプラグインをロードしません。

Claude Code は Windows でリンクモードをサポートしておらず、そこでリンクモードプラグインのインストールを拒否します。代わりに `"mode": "copy"` を宣言します。

<h4 id="how-users-accept-the-command">
  ユーザーがコマンドを受け入れる方法
</h4>

Claude Code はユーザーのマシンでコマンドを実行するため、すべての実行をユーザーの明示的な受け入れにバインドします：

* ユーザーが `/plugin` のプラグインの詳細画面からプラグインをインストールするか、対話型ターミナルで `claude plugin install` または `claude plugin update` でインストールまたは更新する場合、Claude Code は最初に正確なコマンド文字列を表示し、そのインストールの受け入れられたコマンドを記録します。同じコマンドの受け入れで進行できる `claude plugin update` は何も表示しません。プロビジョニングスクリプトなどの非対話型シェルでは、`claude plugin install` または `claude plugin update` に `--yes` を渡してコマンドを受け入れます。
* 他のすべてのパスはユーザーが既に受け入れたコマンドのみを実行します。これには `/plugin` から開始された更新と、[コマンドが再実行される場合](#when-claude-code-re-runs-the-command)のバックグラウンド実行が含まれます。何も受け入れられていない場合、Claude Code はコマンドの実行を拒否し、ユーザーにそれを確認する方法を指示します。Claude Code は別のプラグインの依存関係としてコマンドソースプラグインをインストールしないため、ユーザーは最初にそれを自分でインストールします。
* エントリの `command` を変更するか、その `mode` を切り替える場合、ユーザーは既に持っているバージョンを保持し、Claude Code はコマンドの再実行を停止します。対話型セッションでは、`/plugin` エラータブは新しいコマンドを表示し、ユーザーが `claude plugin update <plugin>@<marketplace>` を実行して確認して受け入れるまで表示されます。

管理者は管理設定 [`disableCommandPluginSources`](/docs/ja/settings-reference#disablecommandpluginsources) を使用して、組織全体でコマンドソースをブロックできます。組織が [`allowManagedHooksOnly`](/docs/ja/settings-reference#allowmanagedhooksonly) を設定する場合、Claude Code はデフォルトでコマンドソースをブロックします。

<h4 id="when-claude-code-re-runs-the-command">
  Claude Code がコマンドを再実行する場合
</h4>

出力されたディレクトリはコマンドが実行された時点でのツールの状態を反映するため、Claude Code はこれらの時間にコマンドを再実行します：

* ユーザーがプラグインをインストールまたは更新するたびに
* セッションごとに 1 回、有効な各コマンドソースプラグインに対して、セッション開始直後にバックグラウンドで。この実行はマーケットプレイス自動更新を通じて行われないため、マーケットプレイスの[自動更新設定](/docs/ja/discover-plugins#configure-auto-updates)に依存しません
* 起動時または `/reload-plugins` で、有効なプラグインのインストール済みバージョンがプラグインキャッシュから欠落している場合

ユーザーが [`CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC`](/docs/ja/env-vars) を設定する場合、Claude Code は 2 つのバックグラウンド実行をスキップします。明示的なインストールと更新は、その変数が設定されていてもコマンドを実行します。

コマンドのハッシュされた出力が変更された場合、Claude Code は結果を新しいバージョンとしてインストールし、実行中の対話型セッションでそれをリロードし、[`/reload-plugins` が切り替わるのと同じコンポーネント](/docs/ja/plugins-reference#environment-variables)を切り替えます。ユーザーはプラグインがリロードされたという通知を見ます。その場でリロードするとセッションのプロンプトキャッシュが無効になる場合、Claude Code は代わりにユーザーに `/reload-plugins` を実行するよう促し、[キャッシュコストについて警告し、`--force` で再実行すると適用されます](/docs/ja/prompt-caching#enabling-or-disabling-a-plugin)。

<h3 id="advanced-plugin-entries">
  高度なプラグインエントリ
</h3>

この例は、コマンド、エージェント、フック、MCP サーバーのカスタムパスを含む、多くのオプションフィールドを使用するプラグインエントリを示しています：

```json theme={null}
{
  "name": "enterprise-tools",
  "source": {
    "source": "github",
    "repo": "company/enterprise-plugin"
  },
  "description": "Enterprise workflow automation tools",
  "version": "2.1.0",
  "author": {
    "name": "Enterprise Team",
    "email": "enterprise@example.com"
  },
  "homepage": "https://docs.example.com/plugins/enterprise-tools",
  "repository": "https://github.com/company/enterprise-plugin",
  "license": "MIT",
  "keywords": ["enterprise", "workflow", "automation"],
  "category": "productivity",
  "commands": [
    "./commands/core/",
    "./commands/enterprise/",
    "./commands/experimental/preview.md"
  ],
  "agents": ["./agents/security-reviewer.md", "./agents/compliance-checker.md"],
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Write|Edit",
        "hooks": [
          {
            "type": "command",
            "command": "${CLAUDE_PLUGIN_ROOT}/scripts/validate.sh"
          }
        ]
      }
    ]
  },
  "mcpServers": {
    "enterprise-db": {
      "command": "${CLAUDE_PLUGIN_ROOT}/servers/db-server",
      "args": ["--config", "${CLAUDE_PLUGIN_ROOT}/config.json"]
    }
  },
  "strict": false
}
```

注意すべき重要な点：

* **`commands` と `agents`**: 複数のディレクトリまたは個別のファイルを指定できます。パスはプラグインルートを基準にしており、その内部に留まる必要があります。
  * Claude Code は、`./../shared.md` のようにプラグインディレクトリの外に解決されるパスを [`path escapes plugin directory`](/docs/ja/errors#path-escapes-plugin-directory) エラーで拒否し、そのコンポーネントなしでプラグインをロードします
* **`${CLAUDE_PLUGIN_ROOT}`**: フックコマンドと MCP サーバー設定でこの変数を使用して、プラグインのインストールディレクトリ内のファイルを参照します。
  * サーバータイプごとにどの設定フィールドがそれを置換するかについては、[置換テーブル](/docs/ja/plugins-reference#environment-variables)を参照してください
  * プラグイン更新を生き残るべき依存関係または状態の場合は、代わりに [`${CLAUDE_PLUGIN_DATA}`](/docs/ja/plugins-reference#persistent-data-directory) を使用します
* **`strict: false`**: これが false に設定されているため、プラグインは独自の `plugin.json` を必要としません。マーケットプレイスエントリがすべてを定義します。[厳密モード](#strict-mode)を参照してください。

デフォルトでは、プラグインのスキルはそのソースの下の `skills/` ディレクトリからロードされます。`skills` フィールドにリストされたパスはそのスキャンに追加されます：

```json theme={null}
"skills": ["./skills/", "./extra-skills/"]
```

複数のプラグインエントリがマーケットプレイスルート（`source: "./"`) で 1 つの `skills/` フォルダを共有する場合、各エントリが独自のスキルのみをロードするように特定のサブディレクトリをリストします：

```json theme={null}
"source": "./",
"skills": ["./skills/code-review", "./skills/docs"]
```

マーケットプレイスルート `source` では、リストされたパスはそのエントリの完全なセットであり、共有 `skills/` フォルダ内の他のディレクトリはロードされません。`./skills/` 自体またはプラグインルートをリストすると、完全なスキャンが保持されます。リストされたパスが存在しない場合、デフォルトスキャンが代わりに実行されます。

<h3 id="strict-mode">
  厳密モード
</h3>

`strict` フィールドは、`plugin.json` がコンポーネント定義（スキル、エージェント、フック、MCP サーバー、出力スタイル）の権限であるかどうかを制御します。

| 値             | 動作                                                                                     |
| :------------ | :------------------------------------------------------------------------------------- |
| `true`（デフォルト） | `plugin.json` が権限です。マーケットプレイスエントリは追加のコンポーネントで補足でき、両方のソースがマージされます。                      |
| `false`       | マーケットプレイスエントリが完全な定義です。プラグインにコンポーネントを宣言する `plugin.json` もある場合、それは競合であり、プラグインはロードに失敗します。 |

**各モードを使用する場合：**

* **`strict: true`**: プラグインは独自の `plugin.json` を持ち、独自のコンポーネントを管理します。マーケットプレイスエントリは上に追加のスキルまたはフックを追加できます。これはデフォルトであり、ほとんどのプラグインで機能します。
* **`strict: false`**: マーケットプレイスオペレーターが完全な制御を望みます。プラグインリポジトリは生ファイルを提供し、マーケットプレイスエントリはプラグイン作成者の意図と異なる方法でプラグインのコンポーネントを再構成またはキュレートする場合に便利です。

<h2 id="host-and-distribute-marketplaces">
  マーケットプレイスのホストと配布
</h2>

<h3 id="host-on-github-recommended">
  GitHub でホスト（推奨）
</h3>

GitHub はマーケットプレイスをホストして配布するための推奨される方法です。

1. **リポジトリを作成**：マーケットプレイス用の新しいリポジトリを設定します
2. **マーケットプレイスファイルを追加**：プラグイン定義を含む `.claude-plugin/marketplace.json` を作成します
3. **チームと共有**：ユーザーが `/plugin marketplace add owner/repo` でマーケットプレイスを追加します

**メリット**：組み込みバージョン管理、問題追跡、チームコラボレーション機能。

<h3 id="host-on-other-git-services">
  他の Git サービスでホスト
</h3>

GitLab、Bitbucket、自己ホスト型サーバーなど、任意の Git ホスティングサービスが機能します。ユーザーは完全なリポジトリ URL で追加します。

```shell theme={null}
/plugin marketplace add https://gitlab.com/company/plugins.git
```

<h3 id="private-repositories">
  プライベートリポジトリ
</h3>

Claude Code はプライベートリポジトリからプラグインをインストールすることをサポートしています。[**Organization settings > Plugins**](https://claude.ai/admin-settings/plugins) を通じてマーケットプレイスを配布する場合、Git 認証情報は関係ありません。organization sync は Claude GitHub App または組織の GitHub Enterprise App を通じてマーケットプレイスリポジトリを読み込み、認証できないプラグインソースは公開である必要があります。完全なルールについては、[organization settings を通じた配布](#distribute-through-organization-settings)を参照してください。

<h4 id="commands-you-run">
  実行するコマンド
</h4>

`/plugin marketplace add`、`/plugin install`、`/plugin update`、または `/plugin marketplace update` を実行すると、Claude Code は既存の Git 認証情報ヘルパーを使用するため、`gh auth login`、macOS キーチェーン、または `git-credential-store` 経由の HTTPS アクセスはターミナルと同じように機能します。SSH アクセスは、ホストが既に `known_hosts` ファイルにあり、キーが `ssh-agent` に読み込まれている限り機能します。Claude Code はホストフィンガープリントとキーパスフレーズの対話的な SSH プロンプトを抑制するためです。GitHub の `owner/repo` ショートハンドソースはデフォルトで SSH 経由でクローンされます。代わりに HTTPS 経由でクローンするには、[`CLAUDE_CODE_PLUGIN_PREFER_HTTPS=1`](/docs/ja/env-vars#variables) を設定します。

<h4 id="background-auto-updates">
  バックグラウンド自動更新
</h4>

デフォルトでは、バックグラウンドリフレッシュは `git pull` の Git 認証情報ヘルパーを無効にするため、ヘルパーが設定されている場合でも、プルは HTTPS 経由でプライベートリポジトリに認証できません。SSH リモートは影響を受けません。`ssh-agent` に読み込まれたキーは、手動操作と同じ方法でバックグラウンドプルを認証します。バックグラウンドプルが失敗すると、Claude Code はマーケットプレイスをゼロから再クローンすることにフォールバックします。再クローンは保存された Git 認証情報を使用しますが、大規模なリポジトリでは[タイムアウトする可能性があります](#git-operations-time-out)ため、プライベートマーケットプレイスの自動更新は断続的に失敗する可能性があります。

2 つの設定により、プライベートマーケットプレイスは予測可能に動作します。

* `CLAUDE_CODE_PLUGIN_KEEP_MARKETPLACE_ON_FAILURE=1` を設定して、バックグラウンドプルが失敗したときに削除して再クローンする代わりに、既存のクローンを保持します。プラグインは最後に同期された状態から機能し続け、`/plugin marketplace update` での手動更新は引き続き認証情報でプルします。
* Git 認証情報ヘルパーを設定します。例えば GitHub の場合は `gh auth setup-git` を使用して、再クローンフォールバックがプロンプトなしで認証できるようにします。

環境に `GITHUB_TOKEN` などのプロバイダートークンを設定しても、それ自体ではバックグラウンド認証は有効になりません。トークンは設定された認証情報ヘルパー（例えば `gh` CLI のヘルパー）を通じてのみ有効になります。これは `GH_TOKEN` と `GITHUB_TOKEN` を読み込みます。

バックグラウンドプル自体が HTTPS 経由で認証するようにするには、グローバル Git URL リライトを設定します。リライトはトークンをリモート URL に埋め込むため、バックグラウンドプルが認証情報ヘルパーを無効にしても有効になり、成功したプルは再クローンフォールバックをスキップします。次の例は、マーケットプレイスリポジトリの URL をアクセストークンを含むようにリライトします。

```bash theme={null}
git config --global url."https://x-access-token:YOUR_TOKEN@github.com/acme-corp/plugins".insteadOf "https://github.com/acme-corp/plugins"
```

リライトをマーケットプレイスリポジトリまたは組織パスにスコープします。ベースがホストのみのリライトは、マシン上のそのホストへのすべてのフェッチとプッシュに適用され、自分のリポジトリへのプッシュを含む通常の認証情報をオーバーライドします。

各プロバイダーはリライトされた URL で異なるユーザー名を期待し、同じパススコープがすべてのプロバイダーに適用されます。自己ホスト型サーバーの場合、ホスト名をサーバーのホスト名に置き換えます。

| プロバイダー    | リライトされた URL フォーム                                                  |
| :-------- | :---------------------------------------------------------------- |
| GitHub    | `https://x-access-token:YOUR_TOKEN@github.com/acme-corp/plugins`  |
| GitLab    | `https://oauth2:YOUR_TOKEN@gitlab.com/acme-corp/plugins`          |
| Bitbucket | `https://x-token-auth:YOUR_TOKEN@bitbucket.org/acme-corp/plugins` |

リライトはトークンを gitconfig にプレーンテキストで保存するため、マーケットプレイスリポジトリへの読み取り専用アクセス権を持つトークンを使用します。

<Note>
  CI/CD 環境では、プライベートリポジトリからプラグインをインストールする前に Git 認証情報ヘルパーを設定します。GitHub Actions では、マーケットプレイスリポジトリへの読み取りアクセス権を持つトークンを `GH_TOKEN` としてエクスポートしてから、`gh auth setup-git` を実行します。デフォルトワークフロートークンはワークフロー自身のリポジトリにのみアクセスできるため、別のリポジトリ内のプライベートマーケットプレイスには個人用アクセストークンまたはアプリトークンが必要です。パイプラインで設定されたグローバル URL リライトもバックグラウンドプルを直接認証します。
</Note>

<h3 id="distribute-through-organization-settings">
  organization settings を通じた配布
</h3>

Team または Enterprise プランで [**Organization settings > Plugins**](https://claude.ai/admin-settings/plugins) を通じてプラグインを配布する場合、これらのソースルールが適用されます。

* マーケットプレイスリポジトリはプライベートまたは内部である必要があります。organization sync は Claude GitHub App または組織の GitHub Enterprise App を通じてそれを読み込みます。
* 各プラグインソースは `github`、`url`、`git-subdir` 型、または `./` で始まる[相対パス](#relative-paths)である必要があります。`metadata.pluginRoot` の下に裸の名前でプラグインをリストすると、organization sync はそれをサポートされていないソースとして拒否するため、`./plugins/deploy-tools` などのパスを書き出します。
* プラグインソースは 2 つの場合にプライベートにできます。
  * マーケットプレイスリポジトリの所有者を共有する github.com ソース
  * GHE App がリポジトリにインストールされている組織の GitHub Enterprise ホスト上のソース
* organization sync は他のすべてのソースを認証情報なしで取得するため、別の所有者の下の github.com リポジトリと GitLab や Bitbucket などの他のホスト上のリポジトリは公開である必要があります。

管理ワークフローについては、[組織のプラグインを管理する](https://support.claude.com/en/articles/13837433)を参照してください。

プライベートプラグインを含めるには、プラグインフォルダをマーケットプレイスリポジトリ内に配置し、[相対パス](#relative-paths)で参照します。organization sync は配布中に各プラグインをパッケージ化するため、ユーザーは別のソースリポジトリへのアクセスを必要としません。

例えば、この `marketplace.json` プラグインエントリは、マーケットプレイスリポジトリの `plugins/deploy-tools` にコミットしたプラグインを参照します。

```json theme={null}
{
  "name": "deploy-tools",
  "source": "./plugins/deploy-tools"
}
```

<h4 id="keep-executables-out-of-the-top-level-bin-directory">
  トップレベルの bin ディレクトリから実行可能ファイルを除外する
</h4>

organization settings を通じて配布するプラグインにトップレベルの `bin/` ディレクトリを含めないでください。claude.ai はマーケットプレイス sync または直接アップロードで到着するかどうかに関わらず、そのようなプラグインを拒否します。

* **マーケットプレイス sync**：organization sync はそのプラグインを拒否し、マーケットプレイスの残りを同期します。エラーメッセージは `Plugin contains a top-level bin/ directory` で始まります。
* **直接アップロード**：[**Organization settings > Plugins**](https://claude.ai/admin-settings/plugins) でプラグインをアップロードする場合、claude.ai は同じメッセージでアップロードを拒否します。

実行可能ファイルを `scripts/` などの別のディレクトリに保持し、[skills、hooks、または MCP サーバー設定](/docs/ja/plugins-reference#environment-variables)から `${CLAUDE_PLUGIN_ROOT}/scripts/<name>` として参照します。

<h3 id="require-marketplaces-for-your-team">
  チーム向けマーケットプレイスの要求
</h3>

リポジトリを設定して、チームメンバーが[プロジェクトフォルダを信頼](/docs/ja/permissions#what-runs-before-you-trust-a-folder)するときに Claude Code がマーケットプレイスを追加するようにできます。別のプロンプトはありません。マーケットプレイスを `.claude/settings.json` に追加します。

```json theme={null}
{
  "extraKnownMarketplaces": {
    "company-tools": {
      "source": {
        "source": "github",
        "repo": "your-org/claude-plugins"
      }
    }
  }
}
```

デフォルトで有効にするプラグインを指定することもできます。

```json theme={null}
{
  "enabledPlugins": {
    "code-formatter@company-tools": true,
    "deployment-tools@company-tools": true
  }
}
```

完全な設定オプションについては、[プラグイン設定](/docs/ja/settings-reference#plugin-settings)を参照してください。

<Note>
  ローカル `directory` または `file` ソースを相対パスで使用する場合、パスはリポジトリのメインチェックアウトに対して解決されます。Git worktrees から Claude Code を実行する場合、パスはメインチェックアウトを指し続けるため、すべての worktrees は同じマーケットプレイスロケーションを共有します。マーケットプレイス状態は、プロジェクトごとではなく、ユーザーごとに 1 回 `~/.claude/plugins/known_marketplaces.json` に保存されます。
</Note>

<h3 id="pre-populate-plugins-for-containers">
  コンテナ用にプラグインを事前入力する
</h3>

コンテナイメージと CI 環境の場合、ビルド時にプラグインディレクトリを事前入力して、Claude Code が実行時にクローンすることなく、マーケットプレイスとプラグインが既に利用可能な状態で起動するようにできます。`CLAUDE_CODE_PLUGIN_SEED_DIR` 環境変数をこのディレクトリを指すように設定します。

複数のシードディレクトリをレイヤーするには、Unix では `:` で、Windows では `;` でパスを区切ります。Claude Code は各ディレクトリを順番に検索し、特定のマーケットプレイスまたはプラグインキャッシュを含む最初のシードが優先されます。

シードディレクトリは `~/.claude/plugins` の構造をミラーリングします。

```
$CLAUDE_CODE_PLUGIN_SEED_DIR/
  known_marketplaces.json
  marketplaces/<name>/...
  cache/<marketplace>/<plugin>/<version>/...
```

シードディレクトリを構築するには、イメージビルド中に Claude Code を 1 回実行し、必要なプラグインをインストールしてから、結果の `~/.claude/plugins` ディレクトリをイメージにコピーして、`CLAUDE_CODE_PLUGIN_SEED_DIR` をそれを指すように設定します。

コピーステップをスキップするには、ビルド中に `CLAUDE_CODE_PLUGIN_CACHE_DIR` をターゲットシードパスに設定して、プラグインが直接そこにインストールされるようにします。

```bash theme={null}
CLAUDE_CODE_PLUGIN_CACHE_DIR=/opt/claude-seed claude plugin marketplace add your-org/plugins
CLAUDE_CODE_PLUGIN_CACHE_DIR=/opt/claude-seed claude plugin install my-tool@your-plugins
```

その後、コンテナのランタイム環境で `CLAUDE_CODE_PLUGIN_SEED_DIR=/opt/claude-seed` を設定して、Claude Code が起動時にシードから読み込むようにします。

起動時に、Claude Code はシードの `known_marketplaces.json` にあるマーケットプレイスをプライマリ設定に登録し、`cache/` の下にあるプラグインキャッシュを再クローンせずに使用します。これは対話モードと `-p` フラグを使用した非対話モードの両方で機能します。

動作の詳細：

* **読み取り専用**：シードディレクトリは書き込まれません。読み取り専用ファイルシステムで git pull が失敗するため、シードマーケットプレイスの自動更新は無効になります。
* **シードエントリが優先**：シードで宣言されたマーケットプレイスは、起動時にユーザー設定の一致するエントリを上書きします。シードプラグインをオプトアウトするには、マーケットプレイスを削除するのではなく `/plugin disable` を使用します。
* **パス解決**：Claude Code はシードの JSON に保存されているパスを信頼するのではなく、実行時に `$CLAUDE_CODE_PLUGIN_SEED_DIR/marketplaces/<name>/` をプローブしてマーケットプレイスコンテンツを見つけます。これは、シードがビルド時と異なるパスにマウントされている場合でも、シードが正しく機能することを意味します。
* **変更がブロックされます**：シードで管理されているマーケットプレイスに対して `/plugin marketplace remove` または `/plugin marketplace update` を実行すると、管理者にシードイメージを更新するよう指示するガイダンスで失敗します。
* **設定と構成**：`extraKnownMarketplaces` または `enabledPlugins` がシードに既に存在するマーケットプレイスを宣言している場合、Claude Code はクローンする代わりにシードコピーを使用します。

<h3 id="managed-marketplace-restrictions">
  管理マーケットプレイスの制限
</h3>

プラグインソースを厳密に制御する必要がある組織の場合、管理者は管理設定の [`strictKnownMarketplaces`](/docs/ja/settings-reference#strictknownmarketplaces) 設定を使用して、ユーザーが追加できるプラグインマーケットプレイスを制限できます。また、単一実行のために CLI フラグをサイドロードするプラグイン、エージェント、MCP サーバーを拒否するには、[`disableSideloadFlags`](/docs/ja/settings-reference#disablesideloadflags) と組み合わせます。コンテキストインストール提案として表示できるマーケットプレイスのプラグインをホワイトリストに登録するには、[`pluginSuggestionMarketplaces`](/docs/ja/settings-reference#pluginsuggestionmarketplaces) を設定します。

`strictKnownMarketplaces` はプラグインが来るマーケットプレイスと一致し、その中のエントリではないため、ユーザーは許可されたマーケットプレイスから[`command` ソース](#command-sources)を持つプラグインをインストールできます。command ソースもブロックするには、[`disableCommandPluginSources`](/docs/ja/settings-reference#disablecommandpluginsources) を設定します。

`strictKnownMarketplaces` が管理設定で設定されている場合、制限動作は値によって異なります。

| 値          | 動作                                                          |
| ---------- | ----------------------------------------------------------- |
| 未定義（デフォルト） | 制限なし。ユーザーは任意のマーケットプレイスを追加できます                               |
| 空配列 `[]`   | 完全なロックダウン。公式 Anthropic マーケットプレイスを含むすべてのマーケットプレイスソースをブロックします |
| ソースのリスト    | ホワイトリスト強制。ユーザーはエントリと一致するマーケットプレイスのみを追加できます                  |

<h4 id="common-configurations">
  一般的な設定
</h4>

公式 Anthropic マーケットプレイスを含むすべてのマーケットプレイス追加を無効にする：

```json theme={null}
{
  "strictKnownMarketplaces": []
}
```

公式 Anthropic マーケットプレイスのみを許可します。単一リポジトリエントリのマッチングは正確であるため、このエントリは同じリポジトリの `ref` または `path` バリアントをカバーしません。

```json theme={null}
{
  "strictKnownMarketplaces": [
    {
      "source": "github",
      "repo": "anthropics/claude-plugins-official"
    }
  ]
}
```

このエントリを使用すると、Claude Code は既に登録されている公式マーケットプレイスを利用可能に保ち、新しいマシンでは Claude Code を対話的に初めて起動するときにマーケットプレイスを自動的に登録します。

自動登録はすべてのマシンをカバーしていません。最も一般的に見落とされるのは：

* マシンの最初の対話的な起動前に実行される非対話環境。
* Claude Code が既に対話的に実行されているマシン。空配列ロックダウンなど、マーケットプレイスをブロックしたポリシーの下。Claude Code はブロックされた試みを記録し、ポリシーが変更された後は再試行しません。

これらのマシンでは、マーケットプレイスを同じ `managed-settings.json` の [`extraKnownMarketplaces`](/docs/ja/settings-reference#extraknownmarketplaces) に追加して Claude Code が自動的に登録するようにするか、`claude plugin marketplace add anthropics/claude-plugins-official` を実行します。

特定のマーケットプレイスのみを許可する：

```json theme={null}
{
  "strictKnownMarketplaces": [
    {
      "source": "github",
      "repo": "acme-corp/approved-plugins"
    },
    {
      "source": "github",
      "repo": "acme-corp/security-tools",
      "ref": "v2.0"
    },
    {
      "source": "url",
      "url": "https://plugins.example.com/marketplace.json"
    }
  ]
}
```

[owner-wildcard](/docs/ja/settings-reference#owner-wildcards) エントリを使用して GitHub 組織の下のすべてのマーケットプレイスリポジトリを許可します。owner wildcards には Claude Code v2.1.223 以降が必要です。

```json theme={null}
{
  "strictKnownMarketplaces": [
    {
      "source": "github",
      "repo": "acme-corp/*"
    }
  ]
}
```

ホストの正規表現パターンマッチングを使用して、内部 Git サーバーからのすべてのマーケットプレイスを許可する。これは [GitHub Enterprise Server](/docs/ja/github-enterprise-server#plugin-marketplaces-on-ghes) または自己ホスト型 GitLab インスタンスの推奨アプローチです。

```json theme={null}
{
  "strictKnownMarketplaces": [
    {
      "source": "hostPattern",
      "hostPattern": "^github\\.example\\.com$"
    }
  ]
}
```

パスの正規表現パターンマッチングを使用して、特定のディレクトリからのファイルシステムベースのマーケットプレイスを許可する：

```json theme={null}
{
  "strictKnownMarketplaces": [
    {
      "source": "pathPattern",
      "pathPattern": "^/opt/approved/"
    }
  ]
}
```

`pathPattern` として `".*"` を使用して、ネットワークソースを `hostPattern` で制御しながら、任意のファイルシステムパスを許可します。

<Note>
  `strictKnownMarketplaces` はユーザーが追加できるものを制限しますが、マーケットプレイスを自動的に登録しません。許可されたマーケットプレイスをユーザーが自動的に利用できるようにするには、同じ `managed-settings.json` で [`extraKnownMarketplaces`](/docs/ja/settings-reference#extraknownmarketplaces) に追加します。

  公式 Anthropic マーケットプレイスは、Claude Code が自動的に登録する唯一のマーケットプレイスであり、ホワイトリストがそれを許可する場合のみです。自動登録は非対話環境やマシンなど、一部のマシンも見落とします。これらのマシンをカバーするには、公式マーケットプレイスを `extraKnownMarketplaces` にも追加します。2 つの設定を並べて表示するには、[`strictKnownMarketplaces` リファレンス](/docs/ja/settings-reference#strictknownmarketplaces)を参照してください。
</Note>

<h4 id="how-restrictions-work">
  制限の仕組み
</h4>

制限はネットワークまたはファイルシステム操作の前にチェックされます。チェックはマーケットプレイス追加時およびプラグインのインストール、更新、リフレッシュ、自動更新時に実行されます。マーケットプレイスがポリシー設定前に追加され、そのソースがホワイトリストと一致しなくなった場合、Claude Code はそこからプラグインをインストールまたは更新することを拒否します。同じ強制が `blockedMarketplaces` に適用されます。

GitHub 所有者の下のすべてのマーケットプレイスリポジトリをブロックするには、`blockedMarketplaces` エントリで owner-wildcard フォームを使用します。`{ "source": "github", "repo": "untrusted-org/*" }`。Claude Code v2.1.223 以降が必要です。マッチングルールについては、ブロックリストとホワイトリストの間で異なり、[Owner wildcards](/docs/ja/settings-reference#owner-wildcards) を参照してください。

ユーザーが Claude Code が[フェッチするのではなくクローンする](ja/discover-plugins#add-from-other-git-hosts) `https://` リポジトリ URL を追加する場合、例えば裸の `github.com` または `gitlab.com` リポジトリ URL、Claude Code は `blockedMarketplaces` の `url` エントリに対してもチェックします。Claude Code はエントリが同じ URL を名付ける場合、追加をブロックします。その比較では、Claude Code は `.git` サフィックスと、ユーザーが `#` の後に追加する任意の ref を無視します。Claude Code v2.1.232 以降が必要です。v2.1.232 より前では、Claude Code は `url` エントリをホストされた `marketplace.json` ファイルとしてフェッチした URL に対してのみマッチしました。

ホワイトリストはほとんどのソースタイプに対して正確なマッチングを使用します。owner-wildcard `github` エントリを除きます。マーケットプレイスが許可されるには、指定されたすべてのフィールドが一致する必要があります。

* GitHub ソースの場合：`repo` は必須で、1 つのリポジトリを名付けるか、owner-wildcard フォーム `owner/*` を使用してその所有者の下のすべてのリポジトリをカバーします。wildcard エントリがマッチする方法については、大文字小文字ルールを含め、[Owner wildcards](/docs/ja/settings-reference#owner-wildcards) を参照してください。単一リポジトリエントリの場合、`ref` は正確に一致するか、マーケットプレイスソースとホワイトリストエントリの両方に存在しない必要があり、同じルールが `path` に適用されます。
* URL ソースの場合：完全な URL が正確に一致する必要があります
* `hostPattern` ソースの場合：マーケットプレイスホストが正規表現パターンと照合されます
* `pathPattern` ソースの場合：マーケットプレイスのファイルシステムパスが正規表現パターンと照合されます

ホワイトリストの正確なマッチングは、末尾のスラッシュ、`.git` サフィックス、または `ssh://` と `https://` スキームのみが異なる URL を異なる値として扱います。組織のマーケットプレイスが複数の URL フォームでクローンできる場合、リテラル URL よりも `hostPattern` エントリを優先して、`https://`、`ssh://`、および `user@host:path` フォームがすべてマッチするようにします。

`strictKnownMarketplaces` は[管理設定](/docs/ja/managed-settings)で設定されるため、個別のユーザーとプロジェクト設定はこれらの制限をオーバーライドできません。

完全な設定詳細（サポートされているすべてのソースタイプと `extraKnownMarketplaces` との比較を含む）については、[strictKnownMarketplaces リファレンス](/docs/ja/settings-reference#strictknownmarketplaces)を参照してください。

<h3 id="version-resolution-and-release-channels">
  バージョン解決とリリースチャネル
</h3>

プラグインバージョンはキャッシュパスと更新検出を決定します。解決されたバージョンがユーザーが既に持っているものと一致する場合、`/plugin update` と自動更新はプラグインをスキップします。Git ベースのソースの場合、`version` を省略すると、Claude Code はソースの解決されたコミット SHA を使用するため、ユーザーはそのコミットが変更されるたびに更新を取得します。これは内部または積極的に開発されているプラグインの最も簡単なセットアップです。完全な解決順序（`archive` ソースを含む）については、[バージョン管理](/docs/ja/plugins-reference#version-management)を参照してください。

<Warning>
  `version` を設定するとプラグインがピンされます。[`command`](#command-sources) を除くすべてのソースタイプの場合。`command` のバージョンは常にコマンドが生成したもののハッシュを含みます。`plugin.json` が `"version": "1.0.0"` を宣言している場合、その文字列を変更せずに新しいコミットをプッシュしても、Claude Code が同じバージョンを見て、キャッシュされたコピーを保持するため、既存のユーザーには何も起こりません。すべてのリリースでフィールドをバンプするか、解決されたバージョンにフォールバックするために省略します。

  `plugin.json` とマーケットプレイスエントリの両方で `version` を設定することを避けてください。`plugin.json` の値は常に無言で優先されるため、古いマニフェストバージョンが `marketplace.json` で設定したバージョンをマスクできます。
</Warning>

<h4 id="set-up-release-channels">
  リリースチャネルの設定
</h4>

プラグインの「安定」と「最新」リリースチャネルをサポートするには、同じリポジトリの異なる ref または SHA を指す 2 つのマーケットプレイスを設定できます。その後、管理設定を通じて 2 つの方法で各ユーザーグループに独自のマーケットプレイスを提供できます。

* [endpoint-managed settings](/docs/ja/managed-settings#delivery-mechanisms)（管理設定ファイルまたは MDM プロファイルなど）を各グループのデバイスに展開します。[Claude Code が管理ソースを組み合わせる方法](/docs/ja/managed-settings#precedence-within-the-managed-tier)は、グループごとのファイルまたはプロファイルがグループ全体のソースも持つデバイスに適用されるかどうかを示します。
* グループごとに 1 つの [Claude apps gateway policy](/docs/ja/claude-apps-gateway-config#managed) を定義します。ゲートウェイは一致ルールが適切なユーザーの最初のポリシーを適用するため、各ユーザーが自分のグループのポリシーに到達するようにポリシーを順序付けます。グループポリシーの `extraKnownMarketplaces` はキャッチオールポリシーのマップを置き換えるのではなく、マージするため、グループが必要とするすべてのマーケットプレイスをグループのポリシーにリストします。チャネルマーケットプレイスのみではなく。

管理コンソールからのサーバー管理設定は[組織内のすべてのユーザーに適用](/docs/ja/server-managed-settings#current-limitations)されるため、グループごとの割り当てを実行できません。

<Warning>
  各チャネルは異なるバージョンに解決される必要があります。明示的なバージョンを使用する場合、`plugin.json` は各ピンされた ref で異なる `version` を宣言する必要があります。`version` を省略する場合、異なるコミット SHA が既にチャネルを区別しています。2 つの ref が同じバージョン文字列に解決される場合、Claude Code はそれらを同一として扱い、更新をスキップします。
</Warning>

<h5 id="example">
  例
</h5>

```json theme={null}
{
  "name": "stable-tools",
  "plugins": [
    {
      "name": "code-formatter",
      "source": {
        "source": "github",
        "repo": "acme-corp/code-formatter",
        "ref": "stable"
      }
    }
  ]
}
```

```json theme={null}
{
  "name": "latest-tools",
  "plugins": [
    {
      "name": "code-formatter",
      "source": {
        "source": "github",
        "repo": "acme-corp/code-formatter",
        "ref": "latest"
      }
    }
  ]
}
```

<h5 id="assign-channels-to-user-groups">
  チャネルをユーザーグループに割り当てる
</h5>

[リリースチャネルの設定](#set-up-release-channels)の下で説明されているグループごとの endpoint-managed settings またはゲートウェイポリシーを通じて、各マーケットプレイスを適切なユーザーグループに割り当てます。例えば、安定グループは以下を受け取ります。

```json theme={null}
{
  "extraKnownMarketplaces": {
    "stable-tools": {
      "source": {
        "source": "github",
        "repo": "acme-corp/stable-tools"
      }
    }
  }
}
```

早期アクセスグループは代わりに `latest-tools` を受け取ります。

```json theme={null}
{
  "extraKnownMarketplaces": {
    "latest-tools": {
      "source": {
        "source": "github",
        "repo": "acme-corp/latest-tools"
      }
    }
  }
}
```

<h4 id="pin-dependency-versions">
  プラグイン依存関係バージョンをピンする
</h4>

プラグインは依存関係を semver 範囲に制限して、依存関係の更新が依存プラグインを破壊しないようにできます。`{plugin-name}--v{version}` Git タグ規約、範囲構文、および同じ依存関係に対する複数の制約がどのように組み合わされるかについては、[プラグイン依存関係バージョンを制限する](/docs/ja/plugin-dependencies)を参照してください。

<h3 id="rename-or-remove-a-plugin">
  プラグインの名前変更または削除
</h3>

プラグインの `name` はその安定識別子です。ユーザーは `enabledPlugins`、`pluginConfigs`、および `/plugin install` コマンドでそれを参照するため、それを変更するとすべての既存インストールが破壊されます。UI に表示されるラベルを既存インストールを破壊することなく変更するには、[`displayName`](#optional-plugin-fields) を設定して `name` を変更しないままにします。

プラグインの `name` を変更する必要がある場合、または `plugins` 配列からプラグインを削除する場合は、既存ユーザーが `plugin-not-found` エラーを見る代わりに移行するように、トップレベルの `renames` エントリを追加します。自動移行には Claude Code v2.1.193 以降が必要です。各前の名前を現在の名前にマップするか、プラグインが存在しなくなった場合は `null` にマップします。次の例は `formatter` を `code-formatter` に名前変更し、`legacy-linter` が削除されたことを記録します。

```json theme={null}
{
  "name": "acme-tools",
  "owner": { "name": "Acme" },
  "plugins": [
    { "name": "code-formatter", "source": "./plugins/code-formatter" }
  ],
  "renames": {
    "formatter": "code-formatter",
    "legacy-linter": null
  }
}
```

ユーザーが古い名前がまだ設定に含まれた状態で Claude Code を起動すると、Claude Code は `renames` マップに従います。

* エントリが新しい名前を指している場合、Claude Code はプラグインを新しい名前で読み込み、`Renamed to "code-formatter" in the "acme-tools" marketplace` などの 1 行の通知を表示します。その後、ユーザー、プロジェクト、ローカル設定スコープの `enabledPlugins` と `pluginConfigs` の両方で古いキーを新しいキーに書き直すため、通知は 1 回表示されます。
* `null` エントリの場合、Claude Code は古いキーを削除し、通知はプラグインがマーケットプレイスから削除されたことを報告します。
* 名前変更されたプラグインが `github` または `npm` などのリモートソースを使用する場合、Claude Code は名前変更後に `plugin-cache-miss` を報告し、ユーザーは新しい名前で取得するために 1 回 `/plugin install` を実行する必要があります。

`renames` を追加のみの履歴として扱う：すべてのユーザーが移行することを期待した後でも、古いエントリを所定の位置に保持します。Claude Code はチェーンに従うため、後で `code-formatter` を `formatter-pro` に名前変更する場合は、最初のエントリを編集するのではなく、2 番目のエントリを追加します。元の `formatter` がまだ有効になっているユーザーは、両方のエントリを通じて `formatter-pro` に解決されます。

マップを編集した後、`claude plugin validate .` を実行します。チェーンがサイクルを形成したり、`null` または `plugins` にリストされている名前で終了しないエントリを拒否します。

<Note>
  管理設定とポリシー設定は Claude Code に対して読み取り専用であるため、そこで有効になっているプラグインは自動的に書き直すことができません。名前変更されたプラグインは各セッションで読み込まれ続けますが、管理者が管理設定ファイルの `enabledPlugins` を新しい名前を使用するように更新するまで、名前変更通知は繰り返されます。同じことが `--add-dir` などの他の読み取り専用ソースを通じて有効になっているプラグインに適用されます。
</Note>

以前のバージョンの Claude Code は `renames` フィールドを無視し、古い名前に対して `plugin-not-found` を報告します。

<h2 id="validation-and-testing">
  検証とテスト
</h2>

マーケットプレイスを共有する前にテストしてください。検証はファイル構造をチェックします。プラグインが現実的なプロンプトで Claude の動作を変更するかどうかをテストするには、新しいバージョンを公開する前に [`claude plugin eval`](/docs/ja/plugin-evals) を使用してその eval スイートを実行してください。

マーケットプレイスディレクトリから JSON 構文を検証します：

```bash theme={null}
claude plugin validate .
```

または Claude Code 内から：

```shell theme={null}
/plugin validate .
```

テスト用にマーケットプレイスを追加します：

```shell theme={null}
/plugin marketplace add ./path/to/marketplace
```

すべてが機能することを確認するためにテストプラグインをインストールします：

```shell theme={null}
/plugin install test-plugin@marketplace-name
```

完全なプラグインテストワークフローについては、[プラグインをローカルでテスト](/docs/ja/plugins#test-your-plugins-locally)を参照してください。技術的なトラブルシューティングについては、[プラグインリファレンス](/docs/ja/plugins-reference)を参照してください。

<h2 id="manage-marketplaces-from-the-cli">
  CLI からマーケットプレイスを管理する
</h2>

Claude Code は、スクリプトと自動化のための非対話的な `claude plugin marketplace` サブコマンドを提供します。これらは、対話的なセッション内で利用可能な `/plugin marketplace` コマンドと同等です。

<h3 id="plugin-marketplace-add">
  プラグインマーケットプレイス追加
</h3>

GitHub リポジトリ、Git URL、リモート URL、またはローカルパスからマーケットプレイスを追加します。

```bash theme={null}
claude plugin marketplace add <source> [options]
```

**引数：**

* `<source>`：GitHub `owner/repo` ショートハンド、Git URL、`marketplace.json` ファイルへのリモート URL、またはローカルディレクトリパス。ブランチまたはタグに固定するには、GitHub ショートハンドに `@ref` を追加するか、Git URL に `#ref` を追加します

URL はスキームを含める必要があります。Claude Code v2.1.196 以降、`gitlab.example.com/team/plugins` のようにスキームなしで入力されたホストは、無効な `owner/repo` ショートハンドとして拒否され、エラーメッセージは `https://` を追加するか、ローカルパスに `./` を使用するよう指示します。以前のバージョンでは、これを GitHub リポジトリパスとして誤読し、GitHub の見つからないエラーでクローン時に失敗します。

**オプション：**

| オプション                 | 説明                                                                                                                         | デフォルト  |
| :-------------------- | :------------------------------------------------------------------------------------------------------------------------- | :----- |
| `--scope <scope>`     | マーケットプレイスを宣言する場所：`user`、`project`、または `local`。[プラグインインストールスコープ](/docs/ja/plugins-reference#plugin-installation-scopes)を参照してください | `user` |
| `--sparse <paths...>` | Git スパースチェックアウト経由で特定のディレクトリにチェックアウトを制限します。モノレポに便利です                                                                        |        |

GitHub から `owner/repo` ショートハンドを使用してマーケットプレイスを追加します。

```bash theme={null}
claude plugin marketplace add acme-corp/claude-plugins
```

`@ref` を使用して特定のブランチまたはタグに固定します。

```bash theme={null}
claude plugin marketplace add acme-corp/claude-plugins@v2.0
```

非 GitHub ホスト上の Git URL から追加します。

```bash theme={null}
claude plugin marketplace add https://gitlab.example.com/team/plugins.git
```

`marketplace.json` ファイルを直接提供するリモート URL から追加します。

```bash theme={null}
claude plugin marketplace add https://example.com/marketplace.json
```

テスト用にローカルディレクトリから追加します。

```bash theme={null}
claude plugin marketplace add ./my-marketplace
```

マーケットプレイスをプロジェクトスコープで宣言して、`.claude/settings.json` 経由でチームと共有します。

```bash theme={null}
claude plugin marketplace add acme-corp/claude-plugins --scope project
```

モノレポの場合、プラグインコンテンツを含むディレクトリにチェックアウトを制限します。

```bash theme={null}
claude plugin marketplace add acme-corp/monorepo --sparse .claude-plugin plugins
```

<h3 id="plugin-marketplace-list">
  プラグインマーケットプレイスリスト
</h3>

設定されたすべてのマーケットプレイスをリストします。

```bash theme={null}
claude plugin marketplace list [options]
```

**オプション：**

| オプション    | 説明         |
| :------- | :--------- |
| `--json` | JSON として出力 |

`--json` を使用すると、各エントリには `name`、`source`、マーケットプレイスが保存されているローカルキャッシュパスを含む `installLocation` フィールド、およびソース固有のフィールドが含まれます：GitHub ソースの場合は `repo`、Git および URL ソースの場合は `url`、ローカルソースの場合は `path`。GitHub および Git ソースには、マーケットプレイスが固定されたブランチまたはタグで追加された場合、`ref` フィールドも含まれます。

<h3 id="plugin-marketplace-remove">
  プラグインマーケットプレイス削除
</h3>

設定されたマーケットプレイスを削除します。エイリアス `rm` も受け入れられます。

```bash theme={null}
claude plugin marketplace remove <name> [options]
```

**引数：**

* `<name>`：削除するマーケットプレイス名。`claude plugin marketplace list` で表示されます。これは渡したソースではなく、`marketplace.json` の `name` です

**オプション：**

| オプション             | 説明                                                                                                                                                                                                                                                          | デフォルト      |
| :---------------- | :---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | :--------- |
| `--scope <scope>` | 削除を単一の設定スコープに制限します：`user`、`project`、または `local`。[プラグインインストールスコープ](/docs/ja/plugins-reference#plugin-installation-scopes)を参照してください。省略した場合、宣言はすべての編集可能なスコープから削除されます。指定した場合、そのスコープの宣言のみが削除されます。マーケットプレイスが別のスコープで引き続き宣言されている場合、共有状態、キャッシュ、およびインストール済みプラグインデータは保持されます | （すべてのスコープ） |

<Warning>
  マーケットプレイスを最後に残ったスコープから削除すると、そこからインストールしたプラグインもアンインストールされます。インストール済みプラグインを失わずにマーケットプレイスを更新するには、`claude plugin marketplace update` を使用してください。
</Warning>

<h3 id="plugin-marketplace-update">
  プラグインマーケットプレイス更新
</h3>

マーケットプレイスをソースから更新して、新しいプラグインとバージョン変更を取得します。ブランチまたはタグ `ref` で追加されたマーケットプレイスは、リポジトリのデフォルトブランチではなく、その ref の最新コミットに更新されます。

```bash theme={null}
claude plugin marketplace update [name]
```

**引数：**

* `[name]`：更新するマーケットプレイス名。`claude plugin marketplace list` で表示されます。省略した場合はすべてのマーケットプレイスを更新します

`remove` と `update` の両方は、読み取り専用のシード管理マーケットプレイスに対して実行すると失敗します。すべてのマーケットプレイスを更新する場合、シード管理エントリはスキップされ、他のマーケットプレイスは引き続き更新されます。シード提供プラグインを変更するには、管理者にシードイメージを更新するよう依頼してください。[コンテナ用にプラグインを事前入力する](#pre-populate-plugins-for-containers)を参照してください。

<h2 id="troubleshooting">
  トラブルシューティング
</h2>

<h3 id="marketplace-not-loading">
  マーケットプレイスが読み込まれない
</h3>

**症状**: マーケットプレイスを追加できない、またはそこからプラグインが見えない

**解決策**:

* マーケットプレイス URL がアクセス可能であることを確認してください
* `.claude-plugin/marketplace.json` が指定されたパスに存在することを確認してください
* `claude plugin validate .` または `/plugin validate .` をマーケットプレイスディレクトリから実行して JSON 構文が有効であることを確認してください。スキル、エージェント、コマンドのフロントマターを確認するには、[マニフェストなしでプラグインまたはディレクトリを検証する](#validate-a-plugin-or-a-directory-without-a-manifest)を参照してください
* プライベートリポジトリの場合は、アクセス権限があることを確認してください

<h3 id="marketplace-validation-errors">
  マーケットプレイス検証エラー
</h3>

マーケットプレイスディレクトリから `claude plugin validate .` または `/plugin validate .` を実行して、問題がないか確認してください。マーケットプレイスディレクトリを指定すると、バリデーターは `marketplace.json` のスキーマエラー、重複するプラグイン名、ソースパストラバーサルをチェックします。`source` がローカルパスである各エントリについて、そのプラグイン自体の `plugin.json` も検証し、エントリの `version` が `plugin.json` のものと一致しない場合に警告します。プラグインの `plugin.json` で見つかった問題には、エントリインデックスが `plugins[2] plugin.json →` の形式で付与されます。

Claude Code v2.1.196 以降、エントリごとのパスは以下も実行します:

* `source` が `.` であるプラグインを含める
* `marketplace.json` が `.claude-plugin` ディレクトリの外にある場合に実行し、ソースをファイル自体のディレクトリに対して解決する
* ファイルの別の部分にスキーマエラーがある場合でも、各エントリの問題を報告する

以前のバージョンではマーケットプレイスルートのプラグインをスキップし、`.claude-plugin/marketplace.json` からのみ下降します。

マーケットプレイスディレクトリから、Claude Code はプラグインのスキル、エージェント、コマンド、またはフックファイルを開きません。これらのファイルのエラーを見つけるには、[マニフェストなしでプラグインまたはディレクトリを検証する](#validate-a-plugin-or-a-directory-without-a-manifest)を参照してください。以下の表は、マーケットプレイスディレクトリからの最も一般的なエラーと、それぞれの原因と修正方法を示しています:

| エラー                                                                                                      | 原因                                                                                                  | 解決策                                                                                                                          |
| :------------------------------------------------------------------------------------------------------- | :-------------------------------------------------------------------------------------------------- | :--------------------------------------------------------------------------------------------------------------------------- |
| `No manifest found in directory. Expected .claude-plugin/marketplace.json or .claude-plugin/plugin.json` | 指定したディレクトリに `.claude-plugin/marketplace.json` または `plugin.json` がなく、チェックするスキル、エージェント、またはコマンドファイルもない | マーケットプレイスルートから実行するか、必須フィールドを含む `.claude-plugin/marketplace.json` を作成してください                                                   |
| `Invalid JSON syntax: Unexpected token...`                                                               | marketplace.json の JSON 構文エラー                                                                       | 不足しているコンマ、余分なコンマ、またはクォートされていない文字列がないか確認してください                                                                                |
| `Duplicate plugin name "x" found in marketplace`                                                         | 2 つのプラグインが同じ名前を共有している                                                                               | 各プラグインに一意の `name` 値を付与してください                                                                                                 |
| `plugins[0].source: Path contains ".."`                                                                  | ソースパスに `..` が含まれている                                                                                 | マーケットプレイスルートに対する相対パスを使用し、`..` を含めないでください。[相対パス](#relative-paths)を参照してください                                                    |
| `Marketplace name cannot contain control or bidirectional-formatting characters`                         | マーケットプレイス `name` に Unicode 双方向フォーマット文字またはエスケープや改行などの制御文字が含まれている                                     | 名前から文字を削除してください。v2.1.247 より前では、これらの文字は `Marketplace name impersonates an official Anthropic/Claude marketplace` エラーを生成していました |
| `Plugin name cannot contain control or bidirectional-formatting characters`                              | プラグイン `name` に Unicode 双方向フォーマット文字またはエスケープや改行などの制御文字が含まれている                                         | 名前から文字を削除してください。v2.1.247 より前では、Claude Code はこのチェックを実行していませんでした                                                               |

**警告** (ブロッキングなし):

* `Marketplace has no plugins defined`: `plugins` 配列に少なくとも 1 つのプラグインを追加してください
* `No marketplace description provided`: ユーザーがマーケットプレイスを理解するのに役立つよう、トップレベルの `description` を追加してください
* `Plugin name "x" is not kebab-case`: 小文字、数字、ハイフンのみを使用して名前を変更してください（例: `my-plugin`）。Claude Code は他の形式を受け入れますが、claude.ai マーケットプレイス同期はそれらを拒否します。
* `Marketplace name "x" is reserved in Claude Desktop`: マーケットプレイスが `org`、`org-provisioned`、または `unknown` という名前である（大文字小文字は問わない）。Claude Code はこれらの名前を受け入れますが、Claude Desktop の管理マーケットプレイス同期はマーケットプレイス全体を拒否します。マーケットプレイスの名前を変更してください。v2.1.221 より前では、`claude plugin validate` はこのチェックを実行していませんでした。
* `Marketplace name "x" is not accepted by Claude Desktop` または `Plugin name "x" is not accepted by Claude Desktop`: Claude Desktop は、文字、数字、`.`、`_`、`-` で構成され、文字または数字で始まる最大 128 文字の名前を受け入れます。Claude Code は他の形式を受け入れますが、Claude Desktop の管理マーケットプレイス同期は名前チェックに失敗したマーケットプレイスを拒否し、名前チェックに失敗したプラグインエントリを静かにドロップします。マーケットプレイスまたはプラグインの名前を変更してください。v2.1.221 より前では、`claude plugin validate` はこれらのチェックを実行していませんでした。

<h4 id="validate-a-plugin-or-a-directory-without-a-manifest">
  マニフェストなしでプラグインまたはディレクトリを検証する
</h4>

フロントマターが解析されないスキル、エージェント、コマンドファイルを見つけるには、`claude plugin validate` を実行し、それらを保持するディレクトリを指定してください。Claude Code は指定したディレクトリの外を見ません。`plugin.json` を持つプラグインに対する 1 つを除くすべての実行には、Claude Code v2.1.233 以降が必要です。

<h5 id="pick-the-directory-to-name">
  指定するディレクトリを選択する
</h5>

Claude Code は、指定したディレクトリに応じて異なるファイルをチェックします。最初の列で確認したいものを見つけ、その行のコマンドを実行してください:

| 確認対象                                                       | 実行                                                                                  | Claude Code がチェックする内容                                                                                                |
| :--------------------------------------------------------- | :---------------------------------------------------------------------------------- | :------------------------------------------------------------------------------------------------------------------- |
| `plugin.json` を持つプラグイン                                     | `claude plugin validate ./plugins/my-plugin`                                        | `plugin.json`、`hooks/hooks.json`、およびプラグインルートの `skills`、`agents`、`commands` ディレクトリ                                    |
| スキル、エージェント、またはコマンドの 1 つのディレクトリ（`plugin.json` がまだないプラグインなど） | `claude plugin validate .claude/skills`、`~/.claude/agents`、または `./my-plugin/agents` | そのディレクトリ内のすべてのスキル、エージェント、またはコマンドファイル                                                                                 |
| スキルがルート `SKILL.md` であるフォルダ                                 | `claude plugin validate ./skills`（フォルダを保持する `skills` ディレクトリを指定）                     | 各フォルダのルート `SKILL.md`。保持するディレクトリは `skills` という名前である必要があります。`plugins/` などの別の名前の下のフォルダには、ルート `SKILL.md` をチェックする実行がありません |
| プロジェクトの 3 つのディレクトリを一度に                                     | `claude plugin validate .claude`、またはマニフェスト `.claude-plugin/` がないプロジェクトルート           | `.claude/skills`、`.claude/agents`、`.claude/commands`                                                                 |
| ユーザーレベルディレクトリ                                              | `claude plugin validate ~/.claude`                                                  | `~/.claude/skills`、`~/.claude/agents`、`~/.claude/commands`                                                           |

<h5 id="check-a-plugin-whose-skill-is-its-root-skill-md">
  スキルがルート `SKILL.md` であるプラグインをチェックする
</h5>

プラグインディレクトリに対して `claude plugin validate` を実行すると、Claude Code はプラグインルートの `SKILL.md` をチェックしません。プラグインが `skills` という名前のディレクトリにある場合は、コマンドを 2 回実行してください:

* その `skills` ディレクトリを指定して、プラグインのルート `SKILL.md` をチェックしてください。
* プラグインディレクトリを指定して、残りをチェックしてください。

プラグインが `plugins/` などの別の名前の下にある場合、`skills` ディレクトリの実行は利用できず、ルート `SKILL.md` をチェックする実行がありません。

<h5 id="check-files-behind-symlinks">
  シンボリックリンクの背後にあるファイルをチェックする
</h5>

`claude plugin validate` を実行すると、Claude Code は指定したディレクトリ内のシンボリックリンクをフォローしません。リンクがどこにあるかによって、実行内容が異なります:

* **プラグインまたは `.claude` ルートの下にリンクされた `skills`、`agents`、または `commands` ディレクトリ**: Claude Code は、その中のものが何も読まれなかったことを警告します。
* **`skills`、`agents`、または `commands` ディレクトリ内のリンクされたエントリ**: Claude Code はそれをスキップし、ディレクトリごとにスキップしたエントリの数をセッションが読み込むことを警告します。
* **指定した `skills`、`agents`、または `commands` ディレクトリ自体がシンボリックリンク、またはその親 `.claude` ディレクトリがシンボリックリンク**: Claude Code はエラーを報告し、その中のものをチェックしません。代わりに実際のディレクトリを指定してください。

2 つのスキルケースでは、実行は警告付きで成功します。リンクされたファイルをチェックするには、再度実行し、それらを直接保持するディレクトリを指定してください:

* **`skills` ディレクトリが[兄弟プラグインのスキルにリンク](/docs/ja/plugins-reference#share-files-within-a-marketplace-with-symlinks)しているプラグイン**: 兄弟プラグインのディレクトリを指定してください。
* **`~/.claude/skills` または `.claude/skills` の[シンボリックリンクされたスキルエントリ](/docs/ja/skills#where-skills-live)**: Claude Code はセッションでエントリをフォローします。チェックするには、実際のフォルダを保持する `skills` という名前のディレクトリを指定してください。

<h5 id="read-the-validation-results">
  検証結果を読む
</h5>

クリーンな実行は `Validation passed` で終了します。

`No manifest found in directory` は、Claude Code がそこに `plugin.json` または `marketplace.json` を見つけず、その下で調査するディレクトリにスキル、エージェント、またはコマンドファイルがないことを意味します。代わりに、ファイルを保持する `skills`、`agents`、または `commands` ディレクトリを指定してください。

Claude Code がこれらの実行から報告する 2 つのエラーと、それぞれの修正方法:

* `YAML frontmatter failed to parse: ...`: スキル、エージェント、またはコマンドファイルのフロントマターブロック内の YAML を修正してください。修正するまで、セッションはそのファイルからフロントマターフィールドを読み込みません
* `Invalid JSON syntax: ...` on `hooks/hooks.json`: JSON 構文を修正してください。修正するまで、セッションはそのファイルのフックなしでプラグインを読み込みます。Claude Code はこのエラーをプラグイン実行でのみ報告します

プラグイン実行では、Claude Code はプラグインルートの `CLAUDE.md` についても警告します。`plugin.json` の[コンポーネントパスフィールド](/docs/ja/plugins-reference#component-path-fields)を通じて設定したパスについては、Claude Code は各パスが存在することをチェックしますが、そこのファイルは読み込みません。

<h3 id="plugin-installation-failures">
  プラグインインストール失敗
</h3>

**症状**: マーケットプレイスは表示されるがプラグインのインストールが失敗する

**解決策**:

* プラグインソース URL がアクセス可能であることを確認してください
* プラグインディレクトリに必須ファイルが含まれていることを確認してください
* GitHub ソースの場合は、リポジトリがパブリックであるか、アクセス権限があることを確認してください
* プラグインソースを手動でテストしてクローン/ダウンロードしてください
* ソースが `ref` と `sha` の両方をピンしている場合、削除されたアップストリームブランチまたはタグは、GitHub、GitLab、Bitbucket を含むほとんどの git ホストでのインストールをブロックしません。AWS CodeCommit などの SHA でのコミット取得をサポートしないサーバーでは、`ref` は依然として存在する必要があり、ピンされたコミットはそこから到達可能である必要があります。インストールが依然として失敗する場合は、ピンされたコミットがリポジトリに依然として存在することを確認してください

<h3 id="private-repository-authentication-fails">
  プライベートリポジトリ認証失敗
</h3>

**症状**: プライベートリポジトリからプラグインをインストールするときに認証エラーが発生する

**解決策**:

手動インストールと更新の場合:

* git プロバイダーで認証されていることを確認してください（例: GitHub の場合は `gh auth status` を実行）
* 認証情報ヘルパーが設定されていることを確認してください: `git config --global credential.helper`
* `git ls-remote <marketplace-url>` を実行して、git が単独で認証できるかテストしてください。git がユーザー名またはパスワードを要求する場合は、最初に認証情報を保存してください: GitHub over HTTPS の場合は `gh auth setup-git` を実行し、SSH リモートの場合はキーを `ssh-agent` に読み込んでください

バックグラウンド自動更新の場合:

* デフォルトでは、バックグラウンド更新はプルの git 認証情報ヘルパーを無効にするため、プルは HTTPS で認証できません。`ssh-agent` に読み込まれたキーを持つ SSH リモートは依然として認証します。失敗したプルは最初からの再クローンをトリガーし、保存された認証情報を使用しますが、大規模なリポジトリでタイムアウトする可能性があります
* `CLAUDE_CODE_PLUGIN_KEEP_MARKETPLACE_ON_FAILURE=1` を設定して、バックグラウンドプルが失敗したときに既存のクローンを保持してください
* git 認証情報ヘルパー（例: `gh auth setup-git`）を設定して、再クローンフォールバックが認証できるようにしてください
* 大規模なリポジトリで再クローンがタイムアウトする場合は、[`CLAUDE_CODE_PLUGIN_GIT_TIMEOUT_MS`](#git-operations-time-out) で制限を増やしてください
* マーケットプレイスリポジトリにスコープされた[git URL 書き換え](#private-repositories)を設定して、バックグラウンドプルが直接認証するようにしてください
* または、認証情報を使用する `/plugin marketplace update <name>` でプライベートマーケットプレイスを手動で更新してください

<h3 id="marketplace-updates-fail-in-offline-environments">
  オフライン環境でマーケットプレイス更新が失敗する
</h3>

**症状**: マーケットプレイス `git pull` がバックグラウンドで失敗し、Claude Code が成功できない再クローンを繰り返し試みる。

**原因**: デフォルトでは、`git pull` が失敗すると、Claude Code は最初からの再クローンを試みます。オフラインまたはエアギャップ環境では、再クローンは同じ方法で失敗し、その後の前のキャッシュの復元はベストエフォートです。更新はスタートアップ後にバックグラウンドで実行されるため、スタートアップは遅延しませんが、各セッションは失敗した試みを繰り返し、各 git 操作は[120 秒のタイムアウト](#git-operations-time-out)を待つことができます。

**解決策**: `CLAUDE_CODE_PLUGIN_KEEP_MARKETPLACE_ON_FAILURE=1` を設定して、プルが失敗したときに再クローン試行をスキップし、既存のキャッシュを使用し続けてください:

```bash theme={null}
export CLAUDE_CODE_PLUGIN_KEEP_MARKETPLACE_ON_FAILURE=1
```

リポジトリが到達不可能になる完全オフラインデプロイメントの場合は、代わりに[`CLAUDE_CODE_PLUGIN_SEED_DIR`](#pre-populate-plugins-for-containers)を使用してビルド時にプラグインディレクトリを事前入力してください。

<h3 id="git-operations-time-out">
  Git 操作がタイムアウトする
</h3>

**症状**: プラグインのインストールまたはマーケットプレイスの更新が「Git clone timed out after 120s」または「Git pull timed out after 120s」などのタイムアウトエラーで失敗する。

**原因**: Claude Code は、プラグインリポジトリのクローンやマーケットプレイスの更新のプルを含むすべての git 操作に 120 秒のタイムアウトを使用します。大規模なリポジトリまたは遅いネットワーク接続はこの制限を超える可能性があります。

**解決策**: `CLAUDE_CODE_PLUGIN_GIT_TIMEOUT_MS` 環境変数を使用してタイムアウトを増やしてください。値はミリ秒単位です:

```bash theme={null}
export CLAUDE_CODE_PLUGIN_GIT_TIMEOUT_MS=300000  # 5 minutes
```

<h3 id="plugins-with-relative-paths-fail-in-url-based-marketplaces">
  URL ベースのマーケットプレイスで相対パスを持つプラグインが失敗する
</h3>

**症状**: `https://example.com/marketplace.json` などの URL を通じてマーケットプレイスを追加しましたが、`"./plugins/my-plugin"` などの相対パスソースを持つプラグインが `its marketplace entry path does not stay inside the marketplace directory` でインストールに失敗します。既にインストールされているプラグインは `Plugin source path refused` で読み込みに失敗します。両方のメッセージに[エラーリファレンスエントリ](/docs/ja/errors#marketplace-entry-path-does-not-stay-inside-the-marketplace-directory)があります。

**原因**: URL ベースのマーケットプレイスを追加すると、`marketplace.json` ファイル自体のみがダウンロードされ、Claude Code はそのサーバーから相対パスでプラグインファイルをフェッチしません。マーケットプレイスエントリの相対パスは、ダウンロードされなかったリモートサーバー上のファイルを参照します。

**解決策**:

* **外部ソースを使用**: プラグインエントリを相対パス以外の任意の[プラグインソース](#plugin-sources)に変更してください:
  ```json theme={null}
  { "name": "my-plugin", "source": { "source": "github", "repo": "owner/repo" } }
  ```
* **Git ベースのマーケットプレイスを使用**: マーケットプレイスを Git リポジトリでホストし、git URL で追加してください。Git ベースのマーケットプレイスはリポジトリ全体をクローンするため、相対パスが正しく機能します。

<h3 id="files-not-found-after-installation">
  インストール後にファイルが見つからない
</h3>

**症状**: プラグインはインストールされますが、ファイルへの参照が失敗します。特にプラグインディレクトリの外のファイル

**原因**: プラグインは、[リンクモードの `command` ソース](#copy-mode-and-link-mode)を除き、その場で使用されるのではなく、キャッシュディレクトリにコピーされます。コピーされたプラグインのディレクトリの外のファイルを参照するパス（`../shared-utils` など）は、それらのファイルがコピーされないため機能しません。

**解決策**: [プラグインキャッシングとファイル解決](/docs/ja/plugins-reference#plugin-caching-and-file-resolution)を参照して、シンボリックリンクとディレクトリ再構成を含む回避策を確認してください。

追加のデバッグツールと一般的な問題については、[デバッグと開発ツール](/docs/ja/plugins-reference#debugging-and-development-tools)を参照してください。

<h2 id="see-also">
  関連項目
</h2>

* [既成プラグインの検出とインストール](/docs/ja/discover-plugins) - 既存のマーケットプレイスからプラグインをインストール
* [プラグイン](/docs/ja/plugins) - 独自のプラグインの作成
* [プラグインリファレンス](/docs/ja/plugins-reference) - 完全な技術仕様とスキーマ
* [プラグイン設定](/docs/ja/settings-reference#plugin-settings) - プラグイン設定オプション
* [strictKnownMarketplaces リファレンス](/docs/ja/settings-reference#strictknownmarketplaces) - 管理マーケットプレイス制限
