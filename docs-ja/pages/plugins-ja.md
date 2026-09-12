> ## Documentation Index
> Fetch the complete documentation index at: https://code.claude.com/docs/llms.txt
> Use this file to discover all available pages before exploring further.

# プラグインを作成する

> スキル、エージェント、フック、MCP サーバーで Claude Code を拡張するカスタムプラグインを作成します。

プラグインを使用すると、Claude Code をカスタム機能で拡張でき、プロジェクトとチーム全体で共有できます。このガイドでは、スキル、エージェント、フック、MCP サーバーを使用して独自のプラグインを作成する方法について説明します。

既存のプラグインをインストールしたいですか？[プラグインを検出してインストールする](/docs/ja/discover-plugins)を参照してください。完全な技術仕様については、[プラグインリファレンス](/docs/ja/plugins-reference)を参照してください。

<h2 id="when-to-use-plugins-vs-standalone-configuration">
  プラグインとスタンドアロン設定を使い分ける
</h2>

Claude Code では、カスタムスキル、エージェント、フックを追加する 2 つの方法をサポートしています。

| アプローチ                                                                           | スキル名                 | 最適な用途                                                |
| :------------------------------------------------------------------------------ | :------------------- | :--------------------------------------------------- |
| **スタンドアロン**（`.claude/` ディレクトリ）                                                  | `/hello`             | 個人的なワークフロー、プロジェクト固有のカスタマイズ、クイック実験                    |
| **プラグイン**（スキル、エージェント、フック、または `.claude-plugin/plugin.json` マニフェストを含む自己完結型ディレクトリ） | `/plugin-name:hello` | チームメンバーとの共有、コミュニティへの配布、バージョン管理されたリリース、プロジェクト全体で再利用可能 |

<Tip>
  `.claude/` でスタンドアロン設定を使用してクイック反復を行い、共有する準備ができたら[既存の設定をプラグインに変換](#convert-existing-configurations-to-plugins)してください。
</Tip>

<h2 id="quickstart">
  クイックスタート
</h2>

このクイックスタートでは、カスタムスキルを使用してプラグインを作成する手順を説明します。マニフェスト（プラグインを定義する設定ファイル）を作成し、スキルを追加して、`--plugin-dir` フラグを使用してローカルでテストします。

<h3 id="prerequisites">
  前提条件
</h3>

* Claude Code [インストール済みで認証済み](/docs/ja/quickstart#step-1-install-claude-code)

<h3 id="create-your-first-plugin">
  最初のプラグインを作成する
</h3>

<Steps>
  <Step title="プラグインディレクトリを作成する">
    すべてのプラグインは、スキル、エージェント、またはフックを含む独自のディレクトリに存在し、オプションで `.claude-plugin/plugin.json` マニフェストと一緒に配置されます。このクイックスタートではテストステップで `--plugin-dir` を使用して Claude Code をディレクトリに指すため、場所は重要ではありません。スクラッチフォルダやプロジェクトディレクトリなど、便利な場所に作成してください。

    ```bash theme={null}
    mkdir my-first-plugin
    ```

    残りのステップは親ディレクトリから実行され、`my-first-plugin/...` のようなパスを相対的に参照します。
  </Step>

  <Step title="プラグインマニフェストを作成する">
    `.claude-plugin/plugin.json` のマニフェストファイルは、プラグインの ID（名前、説明、バージョン）を定義します。Claude Code はこのメタデータを使用して、プラグインマネージャーにプラグインを表示します。

    プラグインフォルダ内に `.claude-plugin` ディレクトリを作成します。

    ```bash theme={null}
    mkdir my-first-plugin/.claude-plugin
    ```

    次に、このコンテンツで `my-first-plugin/.claude-plugin/plugin.json` を作成します。

    ```json my-first-plugin/.claude-plugin/plugin.json theme={null}
    {
      "name": "my-first-plugin",
      "description": "A greeting plugin to learn the basics",
      "version": "1.0.0",
      "author": {
        "name": "Your Name"
      }
    }
    ```

    | フィールド         | 目的                                                                                                                                                                                                                                                           |
    | :------------ | :----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
    | `name`        | 一意の識別子とスキル名前空間。スキルにはこれが接頭辞として付きます（例：`/my-first-plugin:hello`）。                                                                                                                                                                                               |
    | `description` | プラグインマネージャーでプラグインを参照またはインストールするときに表示されます。                                                                                                                                                                                                                    |
    | `version`     | オプション。設定されている場合、ユーザーはこのフィールドをバンプしたときにのみ更新を受け取ります。[`command` ソース](/docs/ja/plugin-marketplaces#command-sources)を除きます。[バージョン管理](/docs/ja/plugins-reference#version-management)を参照してください。省略された場合、バージョンは[バージョン管理](/docs/ja/plugins-reference#version-management)の次のソースから取得されます。 |
    | `author`      | オプション。属性に役立ちます。                                                                                                                                                                                                                                              |

    `homepage`、`repository`、`license` などの追加フィールドについては、[完全なマニフェストスキーマ](/docs/ja/plugins-reference#plugin-manifest-schema)を参照してください。
  </Step>

  <Step title="スキルを追加する">
    スキルは `skills/` ディレクトリに存在します。各スキルは `SKILL.md` ファイルを含むフォルダです。フォルダ名がスキル名になり、プラグインの名前空間が接頭辞として付きます（`my-first-plugin` という名前のプラグイン内の `hello/` は `/my-first-plugin:hello` を作成します）。

    プラグインフォルダ内にスキルディレクトリを作成します。

    ```bash theme={null}
    mkdir -p my-first-plugin/skills/hello
    ```

    次に、このコンテンツで `my-first-plugin/skills/hello/SKILL.md` を作成します。

    ```markdown my-first-plugin/skills/hello/SKILL.md theme={null}
    ---
    description: Greet the user with a friendly message
    disable-model-invocation: true
    ---

    Greet the user warmly and ask how you can help them today.
    ```
  </Step>

  <Step title="プラグインをテストする">
    `--plugin-dir` フラグを使用して Claude Code を実行し、プラグインを読み込みます。

    ```bash theme={null}
    claude --plugin-dir ./my-first-plugin
    ```

    Claude Code が起動したら、新しいスキルを試してください。

    ```shell theme={null}
    /my-first-plugin:hello
    ```

    Claude がグリーティングで応答します。`/help` を実行して、**カスタムコマンド**タブを開き、プラグイン名前空間の下にリストされたスキルを確認してください。

    <Note>
      **名前空間を使う理由は？** プラグインスキルは常に名前空間が付きます（`/my-first-plugin:hello` など）。複数のプラグインが同じ名前のスキルを持つ場合の競合を防ぐためです。

      名前空間プレフィックスを変更するには、`plugin.json` の `name` フィールドを更新してください。
    </Note>
  </Step>

  <Step title="スキル引数を追加する">
    `$ARGUMENTS` プレースホルダーを使用してユーザー入力をキャプチャすることで、スキルを動的にします。

    `SKILL.md` ファイルを更新します。

    ```markdown my-first-plugin/skills/hello/SKILL.md theme={null}
    ---
    description: Greet the user with a personalized message
    ---

    # Hello Skill

    Greet the user named "$ARGUMENTS" warmly and ask how you can help them today. Make the greeting personal and encouraging.
    ```

    `/reload-plugins` を実行して変更を反映させ、スキルを名前で試してください。

    ```shell theme={null}
    /my-first-plugin:hello Alex
    ```

    Claude があなたを名前で挨拶します。スキルに引数を渡す方法の詳細については、[スキル](/docs/ja/skills#pass-arguments-to-skills)を参照してください。
  </Step>
</Steps>

<Tip>
  `--plugin-dir` フラグは開発とテストに役立ちます。プラグインを他のユーザーと共有する準備ができたら、[プラグインマーケットプレイスを作成して配布する](/docs/ja/plugin-marketplaces)を参照してください。
</Tip>

<h2 id="develop-a-plugin-in-your-skills-directory">
  スキルディレクトリでプラグインを開発する
</h2>

毎回起動時に `--plugin-dir` を渡す代わりに、スキルディレクトリにプラグインを保持して、Claude Code に自動的に読み込ませることができます。`claude plugin init` がスキャフォルドします。

```bash theme={null}
claude plugin init my-tool
```

これにより、`.claude-plugin/plugin.json` マニフェストとスターター `SKILL.md` を含む `~/.claude/skills/my-tool/` が作成されます。次のセッションでは、マーケットプレイスやインストール手順なしで `my-tool@skills-dir` として読み込まれます。

自動読み込みルール、個人スコープ対プロジェクトスコープ、ワークスペース信頼要件、および更新または削除方法については、[スキルディレクトリプラグイン](/docs/ja/plugins-reference#skills-directory-plugins)を参照してください。

<h2 id="plugin-structure-overview">
  プラグイン構造の概要
</h2>

スキルを使用してプラグインを作成しましたが、プラグインにはさらに多くの機能を含めることができます。カスタムエージェント、フック、MCP サーバー、LSP サーバー、バックグラウンドモニターです。

<Warning>
  **よくある間違い**：`commands/`、`agents/`、`skills/`、`hooks/` を `.claude-plugin/` ディレクトリ内に配置しないでください。`plugin.json` のみが `.claude-plugin/` 内に入ります。他のすべてのディレクトリはプラグインルートレベルにある必要があります。

  プラグインルートは個別プラグイン自体のディレクトリです。例えば、[クイックスタート](#quickstart)の `my-first-plugin/` のようなものです。`~/.claude/` ではありません。例えば、Claude Code は `~/.claude/.mcp.json` に配置された `.mcp.json` を読み込みません。
</Warning>

| ディレクトリ            | 場所       | 目的                                                                                                                                                                                |
| :---------------- | :------- | :-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `.claude-plugin/` | プラグインルート | `plugin.json` マニフェストを含みます（コンポーネントがデフォルトの場所を使用する場合はオプション）                                                                                                                          |
| `skills/`         | プラグインルート | `<name>/SKILL.md` ディレクトリとしてのスキル                                                                                                                                                   |
| `commands/`       | プラグインルート | フラットな Markdown ファイルとしてのスキル。新しいプラグインには `skills/` を使用してください                                                                                                                         |
| `agents/`         | プラグインルート | カスタムエージェント定義                                                                                                                                                                      |
| `hooks/`          | プラグインルート | `hooks.json` のイベントハンドラー                                                                                                                                                           |
| `.mcp.json`       | プラグインルート | MCP サーバー設定                                                                                                                                                                        |
| `.lsp.json`       | プラグインルート | コード インテリジェンス用の LSP サーバー設定                                                                                                                                                         |
| `monitors/`       | プラグインルート | `monitors.json` のバックグラウンドモニター設定                                                                                                                                                   |
| `bin/`            | プラグインルート | プラグインが有効になっている間に Bash ツールの `PATH` に追加される実行可能ファイル。[Claude.ai 組織設定を通じて配布するプラグインにはこのディレクトリを含めることはできません](/docs/ja/plugin-marketplaces#keep-executables-out-of-the-top-level-bin-directory) |
| `settings.json`   | プラグインルート | プラグインが有効になったときに適用されるデフォルト[設定](/docs/ja/settings)                                                                                                                                       |

正確に 1 つのスキルを含むプラグインは、`skills/` ディレクトリを作成する代わりに、`SKILL.md` をプラグインルートに直接配置できます。Claude Code はそれを単一のスキルとして読み込み、フロントマター `name` フィールドを呼び出し名として使用します。複数のスキルに成長する可能性があるプラグインには、`skills/` レイアウトを使用してください。

<h2 id="develop-more-complex-plugins">
  より複雑なプラグインを開発する
</h2>

基本的なプラグインに慣れたら、より高度な拡張機能を作成できます。

<h3 id="add-skills-to-your-plugin">
  プラグインに Skills を追加する
</h3>

プラグインは [Agent Skills](/docs/ja/skills) を含めることで、Claude の機能を拡張できます。Skills はモデルが呼び出すもので、Claude はタスクのコンテキストに基づいて自動的に使用します。

プラグインのルートに `skills/` ディレクトリを追加し、`SKILL.md` ファイルを含む Skill フォルダを配置します。

```text theme={null}
my-plugin/
├── .claude-plugin/
│   └── plugin.json
└── skills/
    └── code-review/
        └── SKILL.md
```

各 `SKILL.md` には YAML フロントマターと説明が含まれます。Claude がいつ Skill を使用するかを知るために `description` を含めます。

```yaml theme={null}
---
description: Reviews code for best practices and potential issues. Use when reviewing code, checking PRs, or analyzing code quality.
---

When reviewing code, check for:
1. Code organization and structure
2. Error handling
3. Security concerns
4. Test coverage
```

プラグインをインストール後、インストール概要を確認します。`Run /reload-plugins to activate.` と表示される場合は、[プラグインの変更を再起動なしで適用する](/docs/ja/discover-plugins#apply-plugin-changes-without-restarting) を参照して、現在のセッションで Skills を読み込みます。段階的な情報開示とツール制限を含む完全な Skill 作成ガイダンスについては、[Agent Skills](/docs/ja/skills) を参照してください。

<h3 id="add-lsp-servers-to-your-plugin">
  プラグインに LSP サーバーを追加する
</h3>

<Tip>
  TypeScript、Python、Rust などの一般的な言語については、公式マーケットプレイスから事前構築された LSP プラグインをインストールしてください。カスタム LSP プラグインは、まだカバーされていない言語のサポートが必要な場合にのみ作成してください。
</Tip>

LSP（Language Server Protocol）プラグインは Claude にリアルタイムのコード インテリジェンスを提供します。公式 LSP プラグインがない言語をサポートする必要がある場合は、プラグインに `.lsp.json` ファイルを追加することで、独自のプラグインを作成できます。

```json .lsp.json theme={null}
{
  "go": {
    "command": "gopls",
    "args": ["serve"],
    "extensionToLanguage": {
      ".go": "go"
    }
  }
}
```

プラグインをインストールするユーザーは、言語サーバーのバイナリをマシンにインストールしておく必要があります。

サーバーが起動することを確認するには、プラグインを有効にして Claude Code を起動し、`/plugin` Errors タブを確認します。起動に失敗した言語サーバーはそこに表示されます。例えば、バイナリがインストールされていない場合は `Executable not found in $PATH` と表示されます。無効な設定を持つエントリはスキップされます。理由を確認するには `claude --debug` を実行してください。

完全な LSP 設定オプションについては、[LSP servers](/docs/ja/plugins-reference#lsp-servers) を参照してください。

<h3 id="add-background-monitors-to-your-plugin">
  プラグインにバックグラウンド モニターを追加する
</h3>

バックグラウンド モニターを使用すると、プラグインはログ、ファイル、または外部ステータスをバックグラウンドで監視し、イベントが到着したときに Claude に通知できます。Claude Code はプラグインがアクティブな場合、各モニターを自動的に起動するため、Claude にウォッチを開始するよう指示する必要はありません。

プラグインのルートに `monitors/monitors.json` ファイルを追加し、モニター エントリの配列を含めます。

```json monitors/monitors.json theme={null}
[
  {
    "name": "error-log",
    "command": "tail -F ./logs/error.log",
    "description": "Application error log"
  }
]
```

`command` からの各 stdout 行は、セッション中に Claude への通知として配信されます。`when` トリガーと変数置換を含む完全なスキーマについては、[Monitors](/docs/ja/plugins-reference#monitors) を参照してください。

<h3 id="ship-default-settings-with-your-plugin">
  プラグインでデフォルト設定を配布する
</h3>

プラグインはプラグインのルートに `settings.json` ファイルを含めて、プラグインが有効になったときにデフォルト設定を適用できます。現在、`agent` と `subagentStatusLine` キーのみがサポートされています。

`agent` を設定すると、プラグインの [custom agents](/docs/ja/sub-agents) の 1 つがメイン スレッドとしてアクティブになり、そのシステム プロンプト、ツール制限、およびモデルが適用されます。これにより、プラグインは有効になったときに Claude Code のデフォルトの動作を変更できます。

```json settings.json theme={null}
{
  "agent": "security-reviewer"
}
```

この例は、プラグインの `agents/` ディレクトリで定義された `security-reviewer` エージェントをアクティブにします。`settings.json` の設定は、`plugin.json` で宣言された `settings` よりも優先されます。不明なキーは無視されます。

<h3 id="organize-complex-plugins">
  複雑なプラグインを整理する
</h3>

多くのコンポーネントを持つプラグインの場合、機能別にディレクトリ構造を整理します。完全なディレクトリ レイアウトと整理パターンについては、[Plugin directory structure](/docs/ja/plugins-reference#plugin-directory-structure) を参照してください。

<h3 id="test-your-plugins-locally">
  プラグインをローカルでテストする
</h3>

`--plugin-dir` フラグを使用して、開発中にプラグインをテストします。これにより、インストールを必要とせずにプラグインを直接読み込みます。

```bash theme={null}
claude --plugin-dir ./my-plugin
```

このフラグはプラグイン ディレクトリの `.zip` アーカイブも受け入れます。

```bash theme={null}
claude --plugin-dir ./my-plugin.zip
```

`--plugin-dir` プラグインがインストール済みのマーケットプレイス プラグインと同じ名前を持つ場合、そのセッションではローカル コピーが優先されます。これにより、最初にアンインストールしなくても、既にインストール済みのプラグインへの変更をテストできます。例外は、管理設定によって強制的に有効にされたまたは強制的に無効にされたプラグインです。`--plugin-dir` はそれらをオーバーライドできません。

プラグインに変更を加えると、`/reload-plugins` を実行して、再起動せずに更新を取得します。これにより、プラグイン、Skills、エージェント、hooks、プラグイン MCP サーバー、およびプラグイン LSP サーバーが再読み込みされます。インタラクティブ ターミナルのないセッションでは、プラグイン MCP サーバーの変更は [次のセッションまで待機](/docs/ja/discover-plugins#apply-plugin-changes-without-restarting) します。プラグイン コンポーネントをテストします。

* `/plugin-name:skill-name` で Skills を試す
* エージェントが `/context` の Custom Agents に表示されるか、またはスコープ付き名で @-mention できるかを確認する
* `PostToolUse` hook の場合は Claude にファイルを編集するよう求めるなど、各 hook が一致するイベントをトリガーし、その効果を確認する。Claude Code は、一致した hooks、終了コード、および出力を [debug log](/docs/ja/hooks#debug-hooks) に記録します。

<Tip>
  複数のプラグインを一度に読み込むには、フラグを複数回指定します。

  ```bash theme={null}
  claude --plugin-dir ./plugin-one --plugin-dir ./plugin-two
  ```

  プラグインとそれが依存するプラグインをテストするには、[プラグインとその依存関係をローカルでテストする](/docs/ja/plugin-dependencies#test-a-plugin-and-its-dependency-locally) を参照してください。
</Tip>

`--plugin-dir` でプラグインを試すことで、それが機能することがわかります。Claude が実際にどのくらいの頻度でそれに到達し、正しい結果を得るかを確認するには、[`claude plugin eval`](/docs/ja/plugin-evals) を使用してテスト プロンプトのセットに対して実行します。各プロンプトはプラグインが読み込まれた状態と読み込まれていない状態で複数回実行されるため、プラグインが何を貢献しているかを確認し、プラグインを変更したときまたは新しいモデルがリリースされたときの回帰を検出できます。

複数のプラグインを 1 つの場所から読み込むには、それらを保持するフォルダを渡します（例：`--plugin-dir ./plugins`）。フォルダからプラグインを読み込むには Claude Code v2.1.265 以降が必要です。Claude Code はフォルダのトップ レベルを読み取り、どのプラグインを読み込むかを決定し、インタラクティブ セッションではフォルダの後の変更も監視します。

* **読み込まれるもの**: フォルダにマニフェストまたはプラグイン コンポーネントがトップ レベルにない場合、Claude Code はそれをプラグインのフォルダとして扱います。`.claude-plugin/plugin.json` マニフェストを持つ各直下のサブフォルダは、別のプラグインとして読み込まれます。Claude Code はフォルダ内の他のすべてをスキップします。マニフェストのないプラグインを含め、エラーを報告せずにスキップします。
* **インタラクティブ セッション中の変更**: 追加したサブフォルダは、マニフェストが配置されると新しいプラグインとして読み込まれ、サブフォルダを削除するとそのプラグインがアンロードされます。Claude Code は各変更についてセッションに行を出力します。変更を会話の途中で適用すると [プロンプト キャッシュが無効になる](/docs/ja/prompt-caching#enabling-or-disabling-a-plugin) 場合、Claude Code はそれを保持し、行は `/reload-plugins` を実行して適用するよう指示します。

既に `.zip` アーカイブとしてパッケージ化され、CI ビルド アーティファクトなどの URL でホストされているプラグインをテストするには、代わりに `--plugin-url` を使用します。Claude Code は起動時にアーカイブをフェッチし、そのセッションのみ読み込みます。Claude Code がアーカイブをフェッチできない場合、またはアーカイブが無効な場合、プラグインなしで起動し、`/plugin` マネージャーの **Errors** タブで確認できるプラグイン読み込みエラーを記録します。同じ [信頼に関する考慮事項](/docs/ja/discover-plugins#security) が、任意のプラグイン ソースに適用されます。このフラグは、制御または信頼するアーカイブのみを指します。

複数のプラグインを読み込むには、各 URL に対してフラグを繰り返します。

```bash theme={null}
claude --plugin-url https://example.com/my-plugin.zip --plugin-url https://example.com/other.zip
```

または、スペース区切りの URL を 1 つの引用符付き引数として渡します。

```bash theme={null}
claude --plugin-url "https://example.com/my-plugin.zip https://example.com/other.zip"
```

<h3 id="debug-plugin-issues">
  プラグインの問題をデバッグする
</h3>

プラグインが期待どおりに機能していない場合：

1. **構造を確認する**: ディレクトリが `.claude-plugin/` 内ではなく、プラグイン ルートにあることを確認します。
2. **コンポーネントを個別にテストする**: 各 Skill、エージェント、および hook を個別に確認します。
3. **検証とデバッグ ツールを使用する**: CLI コマンドとトラブルシューティング技術については、[Debugging and development tools](/docs/ja/plugins-reference#debugging-and-development-tools) を参照してください。

<h3 id="share-your-plugins">
  プラグインを共有する
</h3>

プラグインを共有する準備ができたら：

1. **ドキュメントを追加する**: インストールと使用方法の説明を含む `README.md` を含めます。
2. **バージョン管理戦略を選択する**: 明示的な `version` を設定するか、[version management](/docs/ja/plugins-reference#version-management) で説明されているフォールバックに依存するかを決定します。
3. **マーケットプレイスを作成または使用する**: [plugin marketplaces](/docs/ja/plugin-marketplaces) を通じて配布してインストールします。
4. **他の人でテストする**: より広い配布の前に、チーム メンバーにプラグインをテストしてもらいます。

プラグインがマーケットプレイスに登録されたら、他のユーザーは [Discover and install plugins](/docs/ja/discover-plugins) の説明を使用してインストールできます。プラグインをチーム内に保つには、[private repository](/docs/ja/plugin-marketplaces#private-repositories) でマーケットプレイスをホストします。

<h3 id="submit-your-plugin-to-the-community-marketplace">
  プラグインをコミュニティ マーケットプレイスに送信する
</h3>

Anthropic は Claude Code プラグイン用に 2 つの公開マーケットプレイスを管理しています。

* **`claude-plugins-official`**: Anthropic によって管理されるキュレーションされたプラグイン セット。Claude Code は初めて対話的に Claude Code を起動するときに自動的に登録します。初回の対話的な起動の前に Claude Code を非対話的に実行した場合、または [marketplace policy](/docs/ja/plugin-marketplaces#managed-marketplace-restrictions) が以前の試行をブロックした場合は、`claude plugin marketplace add anthropics/claude-plugins-official` で自分で登録します。
* **`claude-community`**: レビュー後にサードパーティの送信が行われる公開コミュニティ マーケットプレイス。ユーザーは `/plugin marketplace add anthropics/claude-plugins-community` で追加し、`@claude-community` としてインストールします。

コミュニティ マーケットプレイスのレビューのためにプラグインを送信するには、アプリ内フォームの 1 つを使用します。

* **claude.ai**: [claude.ai/admin-settings/directory/submissions/plugins/new](https://claude.ai/admin-settings/directory/submissions/plugins/new)
* **Console**: [platform.claude.com/plugins/submit](https://platform.claude.com/plugins/submit)

claude.ai フォームには Team または Enterprise 組織とディレクトリ管理アクセスが必要です。組織の所有者はデフォルトでこのアクセス権を持っています。Team または Enterprise 組織に属していない個別の作成者は、代わりに Console フォームを使用できます。

送信する前に、`claude plugin validate ./your-plugin` をローカルで実行します。`./your-plugin` をプラグイン ディレクトリへのパスに置き換えます。レビュー パイプラインはすべての送信に対して同じチェックを実行し、自動化されたセーフティ スクリーニングも実行します。検証が成功すると、Claude Code は `✔ Validation passed` を出力するか、警告がある場合は `✔ Validation passed with warnings` を出力します。警告は検証を失敗させません。警告をエラーとして扱うには `--strict` を追加します。

承認されたプラグインは [`anthropics/claude-plugins-community`](https://github.com/anthropics/claude-plugins-community) カタログの特定のコミット SHA にピン留めされ、CI はリポジトリに新しいコミットをプッシュするときに自動的にピンをバンプします。公開カタログは毎晩レビュー パイプラインから同期されるため、承認と `marketplace.json` にプラグインが表示されるまでの間に遅延が生じる可能性があります。プラグインがインストール可能かどうかを確認するには、[community catalog](https://github.com/anthropics/claude-plugins-community/blob/main/.claude-plugin/marketplace.json) でその名前を検索します。

公式マーケットプレイス `claude-plugins-official` は別途キュレーションされています。Anthropic は、どのプラグインを含めるかを裁量で決定します。申請プロセスはなく、送信フォームは公式マーケットプレイスにプラグインを追加しません。

Anthropic がプラグインを公式マーケットプレイスにリストしている場合、CLI は Claude Code ユーザーにインストールを促すことができます。[CLI からプラグインを推奨する](/docs/ja/plugin-hints) を参照してください。

<h2 id="convert-existing-configurations-to-plugins">
  既存の設定をプラグインに変換する
</h2>

`.claude/` ディレクトリにスキルまたはフックが既にある場合は、それらをプラグインに変換して、より簡単に共有および配布できます。

<h3 id="migration-steps">
  移行手順
</h3>

<Steps>
  <Step title="プラグイン構造を作成する">
    プロジェクトルートに新しいプラグインディレクトリを作成します。既存の `.claude/` フォルダの隣に配置することで、次のステップの相対 `cp` パスが解決されます。

    ```bash theme={null}
    mkdir -p my-plugin/.claude-plugin
    ```

    `my-plugin/.claude-plugin/plugin.json` にマニフェストファイルを作成します。

    ```json my-plugin/.claude-plugin/plugin.json theme={null}
    {
      "name": "my-plugin",
      "description": "Migrated from standalone configuration",
      "version": "1.0.0"
    }
    ```
  </Step>

  <Step title="既存のファイルをコピーする">
    既存の各設定ディレクトリをプラグインルートにコピーします。3 つすべてがない場合もあります。ディレクトリが存在しない場合、`cp` は `No such file or directory` を出力してコピーしないため、そのコマンドをスキップするか、エラーを無視してください。

    ```bash theme={null}
    cp -r .claude/commands my-plugin/

    cp -r .claude/agents my-plugin/

    cp -r .claude/skills my-plugin/
    ```

    プラグインには、`.claude/` の下にあったディレクトリのコピーが含まれるようになりました。`ls my-plugin` を実行して確認します。コピーした各ディレクトリが表示されるはずです。
  </Step>

  <Step title="フックを移行する">
    設定にフックがある場合は、フックディレクトリを作成します。

    ```bash theme={null}
    mkdir my-plugin/hooks
    ```

    `my-plugin/hooks/hooks.json` をフック設定で作成します。`.claude/settings.json` または `settings.local.json` から `hooks` オブジェクトをコピーします。形式は同じです。コマンドはフック入力を stdin で JSON として受け取るため、`jq` を使用してファイルパスを抽出します。

    ```json my-plugin/hooks/hooks.json theme={null}
    {
      "hooks": {
        "PostToolUse": [
          {
            "matcher": "Write|Edit",
            "hooks": [{ "type": "command", "command": "jq -r '.tool_input.file_path' | xargs npm run lint:fix" }]
          }
        ]
      }
    }
    ```
  </Step>

  <Step title="移行したプラグインをテストする">
    プラグインを読み込んで、すべてが機能することを確認します。

    ```bash theme={null}
    claude --plugin-dir ./my-plugin
    ```

    各コンポーネントをテストします。コマンドを実行し、`/context` にエージェントが表示されることを確認し、フックが一致するイベントをトリガーして、その効果を確認します。Claude Code は、どのフックが一致し、どのように終了したかを [デバッグログ](/docs/ja/hooks#debug-hooks) に記録します。
  </Step>
</Steps>

<h3 id="what-changes-when-migrating">
  移行時の変更点
</h3>

| スタンドアロン（`.claude/`）        | プラグイン                          |
| :------------------------- | :----------------------------- |
| 1 つのプロジェクトでのみ利用可能          | マーケットプレイス経由で共有可能               |
| `.claude/commands/` 内のファイル | `plugin-name/commands/` 内のファイル |
| `settings.json` のフック       | `hooks/hooks.json` のフック        |
| 共有するには手動でコピーする必要がある        | `/plugin install` でインストール      |

<Note>
  移行後、重複を避けるために `.claude/` から元のファイルを削除してください。プロジェクトおよびユーザーの `.claude/agents/` 定義は、同じ名前のプラグインエージェントをオーバーライドするため、元のファイルを削除した後にのみプラグインバージョンが有効になります。プラグインスキルは `/plugin-name:skill-name` として名前空間化されるため、元の `/skill-name` とプラグインコピーの両方が利用可能なままになり、一方が他方をオーバーライドするのではなく両方が共存します。
</Note>

<h2 id="next-steps">
  次のステップ
</h2>

Claude Code のプラグインシステムを理解したので、異なる目標のための推奨パスを以下に示します。

<h3 id="for-plugin-users">
  プラグインユーザー向け
</h3>

* [プラグインを検出してインストールする](/docs/ja/discover-plugins)：マーケットプレイスを参照してプラグインをインストール
* [チームマーケットプレイスを設定する](/docs/ja/discover-plugins#configure-team-marketplaces)：チーム用のリポジトリレベルプラグインを設定

<h3 id="for-plugin-developers">
  プラグイン開発者向け
</h3>

* [evals でプラグインをテストする](/docs/ja/plugin-evals)：プラグインが何を変更するかを測定し、CI でゲートする
* [マーケットプレイスを作成して配布する](/docs/ja/plugin-marketplaces)：プラグインをパッケージ化して共有
* [プラグインリファレンス](/docs/ja/plugins-reference)：完全な技術仕様
* 特定のプラグインコンポーネントをさらに詳しく調べる：
  * [Skills](/docs/ja/skills)：スキル開発の詳細
  * [Subagents](/docs/ja/sub-agents)：エージェント設定と機能
  * [Hooks](/docs/ja/hooks)：イベント処理と自動化
  * [MCP](/docs/ja/mcp)：外部ツール統合
