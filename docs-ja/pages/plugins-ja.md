> ## Documentation Index
> Fetch the complete documentation index at: https://code.claude.com/docs/llms.txt
> Use this file to discover all available pages before exploring further.

# プラグインを作成する

> スラッシュコマンド、エージェント、フック、スキル、MCPサーバーを使用してClaude Codeを拡張するカスタムプラグインを作成します。

プラグインを使用すると、プロジェクトとチーム全体で共有できるカスタム機能を使用してClaude Codeを拡張できます。このガイドでは、スラッシュコマンド、エージェント、スキル、フック、MCPサーバーを使用して独自のプラグインを作成する方法について説明します。

既存のプラグインをインストールしたいですか？[プラグインを発見してインストールする](/ja/discover-plugins)を参照してください。完全な技術仕様については、[プラグインリファレンス](/ja/plugins-reference)を参照してください。

## プラグインとスタンドアロン設定を使用する場合

Claude Codeは、カスタムスラッシュコマンド、エージェント、フックを追加する2つの方法をサポートしています：

| アプローチ                                              | スラッシュコマンド名           | 最適な用途                                               |
| :------------------------------------------------- | :------------------- | :-------------------------------------------------- |
| **スタンドアロン** (`.claude/` ディレクトリ)                    | `/hello`             | 個人的なワークフロー、プロジェクト固有のカスタマイズ、クイック実験                   |
| **プラグイン** (`.claude-plugin/plugin.json` を含むディレクトリ) | `/plugin-name:hello` | チームメイトとの共有、コミュニティへの配布、バージョン管理されたリリース、プロジェクト全体で再利用可能 |

**スタンドアロン設定を使用する場合**：

* 単一のプロジェクト用にClaude Codeをカスタマイズしている
* 設定は個人的であり、共有する必要がない
* スラッシュコマンドやフックをパッケージ化する前に実験している
* `/hello` や `/review` のような短いスラッシュコマンド名が必要

**プラグインを使用する場合**：

* チームまたはコミュニティと機能を共有したい
* 複数のプロジェクト全体で同じスラッシュコマンド/エージェントが必要
* 拡張機能のバージョン管理と簡単な更新が必要
* マーケットプレイスを通じて配布している
* `/my-plugin:hello` のような名前空間付きスラッシュコマンドで問題ない（名前空間はプラグイン間の競合を防ぎます）

<Tip>
  `.claude/` でスタンドアロン設定から始めてクイック反復を行い、共有する準備ができたら[既存の設定をプラグインに変換](#convert-existing-configurations-to-plugins)してください。
</Tip>

## クイックスタート

このクイックスタートでは、カスタムスラッシュコマンドを使用してプラグインを作成する手順を説明します。マニフェスト（プラグインを定義する設定ファイル）を作成し、スラッシュコマンドを追加して、`--plugin-dir` フラグを使用してローカルでテストします。

### 前提条件

* Claude Code [インストール済みで認証済み](/ja/quickstart#step-1-install-claude-code)
* Claude Code バージョン 1.0.33 以降（`claude --version` で確認）

<Note>
  `/plugin` コマンドが表示されない場合は、Claude Codeを最新バージョンに更新してください。アップグレード手順については、[トラブルシューティング](/ja/troubleshooting)を参照してください。
</Note>

### 最初のプラグインを作成する

<Steps>
  <Step title="プラグインディレクトリを作成する">
    すべてのプラグインは、マニフェストとカスタムコマンド、エージェント、またはフックを含む独自のディレクトリに存在します。今すぐ作成してください：

    ```bash  theme={null}
    mkdir my-first-plugin
    ```
  </Step>

  <Step title="プラグインマニフェストを作成する">
    `.claude-plugin/plugin.json` のマニフェストファイルは、プラグインの名前、説明、バージョンなど、プラグインのアイデンティティを定義します。Claude Codeはこのメタデータを使用して、プラグインマネージャーにプラグインを表示します。

    プラグインフォルダ内に `.claude-plugin` ディレクトリを作成します：

    ```bash  theme={null}
    mkdir my-first-plugin/.claude-plugin
    ```

    次に、このコンテンツで `my-first-plugin/.claude-plugin/plugin.json` を作成します：

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

    | フィールド         | 目的                                                                         |
    | :------------ | :------------------------------------------------------------------------- |
    | `name`        | 一意の識別子とスラッシュコマンド名前空間。スラッシュコマンドにはこれが接頭辞として付きます（例：`/my-first-plugin:hello`）。 |
    | `description` | プラグインを参照またはインストールするときにプラグインマネージャーに表示されます。                                  |
    | `version`     | [セマンティックバージョニング](/ja/plugins-reference#version-management)を使用してリリースを追跡します。 |
    | `author`      | オプション。属性付けに役立ちます。                                                          |

    `homepage`、`repository`、`license` などの追加フィールドについては、[完全なマニフェストスキーマ](/ja/plugins-reference#plugin-manifest-schema)を参照してください。
  </Step>

  <Step title="スラッシュコマンドを追加する">
    スラッシュコマンドは `commands/` ディレクトリ内のMarkdownファイルです。ファイル名がスラッシュコマンド名になり、プラグインの名前空間が接頭辞として付きます（`my-first-plugin` という名前のプラグイン内の `hello.md` は `/my-first-plugin:hello` を作成します）。Markdownコンテンツは、スラッシュコマンドが実行されたときにClaudeがどのように応答するかを指示します。

    プラグインフォルダに `commands` ディレクトリを作成します：

    ```bash  theme={null}
    mkdir my-first-plugin/commands
    ```

    次に、このコンテンツで `my-first-plugin/commands/hello.md` を作成します：

    ```markdown my-first-plugin/commands/hello.md theme={null}
    ---
    description: Greet the user with a friendly message
    ---

    # Hello Command

    Greet the user warmly and ask how you can help them today.
    ```
  </Step>

  <Step title="プラグインをテストする">
    `--plugin-dir` フラグを使用してClaude Codeを実行し、プラグインをロードします：

    ```bash  theme={null}
    claude --plugin-dir ./my-first-plugin
    ```

    Claude Codeが起動したら、新しいコマンドを試してください：

    ```shell  theme={null}
    /my-first-plugin:hello
    ```

    Claudeが挨拶で応答するのが表示されます。`/help` を実行して、プラグイン名前空間の下にリストされたコマンドを確認してください。

    <Note>
      **なぜ名前空間を使用するのか？** プラグインスラッシュコマンドは常に名前空間が付きます（`/greet:hello` など）。複数のプラグインが同じ名前のコマンドを持つ場合の競合を防ぐためです。

      名前空間プレフィックスを変更するには、`plugin.json` の `name` フィールドを更新してください。
    </Note>
  </Step>

  <Step title="スラッシュコマンド引数を追加する">
    ユーザー入力を受け入れることで、スラッシュコマンドを動的にします。`$ARGUMENTS` プレースホルダーは、ユーザーがスラッシュコマンドの後に提供するテキストをキャプチャします。

    `hello.md` ファイルを更新します：

    ```markdown my-first-plugin/commands/hello.md theme={null}
    ---
    description: Greet the user with a personalized message
    ---

    # Hello Command

    Greet the user named "$ARGUMENTS" warmly and ask how you can help them today. Make the greeting personal and encouraging.
    ```

    Claude Codeを再起動して変更を反映させ、名前を使用してコマンドを試してください：

    ```shell  theme={null}
    /my-first-plugin:hello Alex
    ```

    Claudeがあなたを名前で挨拶します。`$1`、`$2` などの個別パラメータのための引数オプションについては、[スラッシュコマンド](/ja/slash-commands)を参照してください。
  </Step>
</Steps>

これらの主要なコンポーネントを使用してプラグインを正常に作成およびテストしました：

* **プラグインマニフェスト** (`.claude-plugin/plugin.json`)：プラグインのメタデータを説明します
* **コマンドディレクトリ** (`commands/`)：カスタムスラッシュコマンドを含みます
* **コマンド引数** (`$ARGUMENTS`)：動的な動作のためにユーザー入力をキャプチャします

<Tip>
  `--plugin-dir` フラグは開発とテストに役立ちます。プラグインを他のユーザーと共有する準備ができたら、[プラグインマーケットプレイスを作成および配布する](/ja/plugin-marketplaces)を参照してください。
</Tip>

## プラグイン構造の概要

スラッシュコマンドを使用してプラグインを作成しましたが、プラグインにはさらに多くの機能が含まれます：カスタムエージェント、スキル、フック、MCPサーバー、LSPサーバー。

<Warning>
  **よくある間違い**：`commands/`、`agents/`、`skills/`、`hooks/` を `.claude-plugin/` ディレクトリ内に配置しないでください。`.claude-plugin/` には `plugin.json` のみが入ります。他のすべてのディレクトリはプラグインルートレベルにある必要があります。
</Warning>

| ディレクトリ            | 場所       | 目的                              |
| :---------------- | :------- | :------------------------------ |
| `.claude-plugin/` | プラグインルート | `plugin.json` マニフェストのみを含みます（必須） |
| `commands/`       | プラグインルート | Markdownファイルとしてのスラッシュコマンド       |
| `agents/`         | プラグインルート | カスタムエージェント定義                    |
| `skills/`         | プラグインルート | `SKILL.md` ファイルを含むエージェントスキル     |
| `hooks/`          | プラグインルート | `hooks.json` 内のイベントハンドラー        |
| `.mcp.json`       | プラグインルート | MCPサーバー設定                       |
| `.lsp.json`       | プラグインルート | コード知能用のLSPサーバー設定                |

<Note>
  **次のステップ**：さらに多くの機能を追加する準備ができましたか？[より複雑なプラグインを開発する](#develop-more-complex-plugins)にジャンプして、エージェント、フック、MCPサーバー、LSPサーバーを追加してください。すべてのプラグインコンポーネントの完全な技術仕様については、[プラグインリファレンス](/ja/plugins-reference)を参照してください。
</Note>

## より複雑なプラグインを開発する

基本的なプラグインに慣れたら、より洗練された拡張機能を作成できます。

### プラグインにスキルを追加する

プラグインには、Claudeの機能を拡張する[エージェントスキル](/ja/skills)を含めることができます。スキルはモデルによって呼び出されます：Claudeはタスクコンテキストに基づいて自動的にそれらを使用します。

プラグインルートに `skills/` ディレクトリを追加し、`SKILL.md` ファイルを含むスキルフォルダを追加します：

```
my-plugin/
├── .claude-plugin/
│   └── plugin.json
└── skills/
    └── code-review/
        └── SKILL.md
```

各 `SKILL.md` には、`name` と `description` フィールドを含むフロントマターが必要で、その後に指示が続きます：

```yaml  theme={null}
---
name: code-review
description: Reviews code for best practices and potential issues. Use when reviewing code, checking PRs, or analyzing code quality.
---

When reviewing code, check for:
1. Code organization and structure
2. Error handling
3. Security concerns
4. Test coverage
```

プラグインをインストールした後、Claude Codeを再起動してスキルをロードします。段階的な開示とツール制限を含む完全なスキル作成ガイダンスについては、[エージェントスキル](/ja/skills)を参照してください。

### プラグインにLSPサーバーを追加する

<Tip>
  TypeScript、Python、Rustなどの一般的な言語については、公式マーケットプレイスから事前構築されたLSPプラグインをインストールしてください。既にカバーされていない言語のサポートが必要な場合にのみ、カスタムLSPプラグインを作成してください。
</Tip>

LSP（Language Server Protocol）プラグインは、Claudeにリアルタイムコード知能を提供します。公式LSPプラグインがない言語をサポートする必要がある場合は、プラグインに `.lsp.json` ファイルを追加することで、独自のプラグインを作成できます：

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

プラグインをインストールするユーザーは、マシンに言語サーバーバイナリをインストールしている必要があります。

完全なLSP設定オプションについては、[LSPサーバー](/ja/plugins-reference#lsp-servers)を参照してください。

### 複雑なプラグインを整理する

多くのコンポーネントを持つプラグインの場合、ディレクトリ構造を機能別に整理します。完全なディレクトリレイアウトと整理パターンについては、[プラグインディレクトリ構造](/ja/plugins-reference#plugin-directory-structure)を参照してください。

### プラグインをローカルでテストする

開発中にプラグインをテストするには、`--plugin-dir` フラグを使用します。これにより、インストールを必要とせずにプラグインが直接ロードされます。

```bash  theme={null}
claude --plugin-dir ./my-plugin
```

プラグインに変更を加えると、Claude Codeを再起動して更新を反映させます。プラグインコンポーネントをテストします：

* `/command-name` でコマンドを試す
* `/agents` にエージェントが表示されることを確認する
* フックが期待通りに機能することを確認する

<Tip>
  フラグを複数回指定することで、複数のプラグインを一度にロードできます：

  ```bash  theme={null}
  claude --plugin-dir ./plugin-one --plugin-dir ./plugin-two
  ```
</Tip>

### プラグインの問題をデバッグする

プラグインが期待通りに機能していない場合：

1. **構造を確認する**：ディレクトリが `.claude-plugin/` 内ではなく、プラグインルートにあることを確認してください
2. **コンポーネントを個別にテストする**：各コマンド、エージェント、フックを個別に確認してください
3. **検証とデバッグツールを使用する**：CLIコマンドとトラブルシューティング技術については、[デバッグと開発ツール](/ja/plugins-reference#debugging-and-development-tools)を参照してください

### プラグインを共有する

プラグインを共有する準備ができたら：

1. **ドキュメントを追加する**：インストールと使用方法の指示を含む `README.md` を含めます
2. **プラグインをバージョン管理する**：`plugin.json` で[セマンティックバージョニング](/ja/plugins-reference#version-management)を使用します
3. **マーケットプレイスを作成または使用する**：[プラグインマーケットプレイス](/ja/plugin-marketplaces)を通じて配布してインストールします
4. **他のユーザーでテストする**：より広い配布の前に、チームメンバーにプラグインをテストしてもらいます

プラグインがマーケットプレイスに入ったら、他のユーザーは[プラグインを発見してインストールする](/ja/discover-plugins)の指示を使用してインストールできます。

<Note>
  完全な技術仕様、デバッグ技術、配布戦略については、[プラグインリファレンス](/ja/plugins-reference)を参照してください。
</Note>

## 既存の設定をプラグインに変換する

既に `.claude/` ディレクトリにカスタムコマンド、スキル、またはフックがある場合は、それらをプラグインに変換して、より簡単に共有および配布できます。

### 移行手順

<Steps>
  <Step title="プラグイン構造を作成する">
    新しいプラグインディレクトリを作成します：

    ```bash  theme={null}
    mkdir -p my-plugin/.claude-plugin
    ```

    `my-plugin/.claude-plugin/plugin.json` にマニフェストファイルを作成します：

    ```json my-plugin/.claude-plugin/plugin.json theme={null}
    {
      "name": "my-plugin",
      "description": "Migrated from standalone configuration",
      "version": "1.0.0"
    }
    ```
  </Step>

  <Step title="既存のファイルをコピーする">
    既存の設定をプラグインディレクトリにコピーします：

    ```bash  theme={null}
    # コマンドをコピー
    cp -r .claude/commands my-plugin/

    # エージェントをコピー（ある場合）
    cp -r .claude/agents my-plugin/

    # スキルをコピー（ある場合）
    cp -r .claude/skills my-plugin/
    ```
  </Step>

  <Step title="フックを移行する">
    設定にフックがある場合は、フックディレクトリを作成します：

    ```bash  theme={null}
    mkdir my-plugin/hooks
    ```

    `my-plugin/hooks/hooks.json` をフック設定で作成します。`.claude/settings.json` または `settings.local.json` から `hooks` オブジェクトをコピーしてください。形式は同じです：

    ```json my-plugin/hooks/hooks.json theme={null}
    {
      "hooks": {
        "PostToolUse": [
          {
            "matcher": "Write|Edit",
            "hooks": [{ "type": "command", "command": "npm run lint:fix $FILE" }]
          }
        ]
      }
    }
    ```
  </Step>

  <Step title="移行されたプラグインをテストする">
    プラグインをロードしてすべてが機能することを確認します：

    ```bash  theme={null}
    claude --plugin-dir ./my-plugin
    ```

    各コンポーネントをテストします：コマンドを実行し、`/agents` にエージェントが表示されることを確認し、フックが正しくトリガーされることを確認します。
  </Step>
</Steps>

### 移行時の変更内容

| スタンドアロン (`.claude/`)       | プラグイン                          |
| :------------------------- | :----------------------------- |
| 1つのプロジェクトでのみ利用可能           | マーケットプレイスを通じて共有可能              |
| `.claude/commands/` 内のファイル | `plugin-name/commands/` 内のファイル |
| `settings.json` 内のフック      | `hooks/hooks.json` 内のフック       |
| 共有するには手動でコピーが必要            | `/plugin install` でインストール可能    |

<Note>
  移行後、重複を避けるために `.claude/` から元のファイルを削除できます。ロードされたときにプラグインバージョンが優先されます。
</Note>

## 次のステップ

Claude Codeのプラグインシステムを理解したので、異なる目標のための推奨パスは次のとおりです：

### プラグインユーザー向け

* [プラグインを発見してインストールする](/ja/discover-plugins)：マーケットプレイスを参照してプラグインをインストールする
* [チームマーケットプレイスを設定する](/ja/discover-plugins#configure-team-marketplaces)：チーム用のリポジトリレベルプラグインを設定する

### プラグイン開発者向け

* [マーケットプレイスを作成および配布する](/ja/plugin-marketplaces)：プラグインをパッケージ化して共有する
* [プラグインリファレンス](/ja/plugins-reference)：完全な技術仕様
* 特定のプラグインコンポーネントをさらに詳しく調べる：
  * [スラッシュコマンド](/ja/slash-commands)：コマンド開発の詳細
  * [サブエージェント](/ja/sub-agents)：エージェント設定と機能
  * [エージェントスキル](/ja/skills)：Claudeの機能を拡張する
  * [フック](/ja/hooks)：イベント処理と自動化
  * [MCP](/ja/mcp)：外部ツール統合
