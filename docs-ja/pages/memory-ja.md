> ## Documentation Index
> Fetch the complete documentation index at: https://code.claude.com/docs/llms.txt
> Use this file to discover all available pages before exploring further.

# Claudeのメモリを管理する

> 異なるメモリロケーションとベストプラクティスを使用して、セッション間でClaude Codeのメモリを管理する方法を学びます。

Claude Codeは、スタイルガイドラインやワークフロー内の一般的なコマンドなど、セッション間であなたの設定を記憶することができます。

## メモリタイプを決定する

Claude Codeは階層構造で4つのメモリロケーションを提供し、それぞれが異なる目的を果たします：

| メモリタイプ              | ロケーション                                                                                                                                                          | 目的                        | ユースケース例                           | 共有対象              |
| ------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------- | --------------------------------- | ----------------- |
| **エンタープライズポリシー**    | • macOS: `/Library/Application Support/ClaudeCode/CLAUDE.md`<br />• Linux: `/etc/claude-code/CLAUDE.md`<br />• Windows: `C:\Program Files\ClaudeCode\CLAUDE.md` | IT/DevOpsによって管理される組織全体の指示 | 企業のコーディング標準、セキュリティポリシー、コンプライアンス要件 | 組織内のすべてのユーザー      |
| **プロジェクトメモリ**       | `./CLAUDE.md` または `./.claude/CLAUDE.md`                                                                                                                         | プロジェクトのチーム共有指示            | プロジェクトアーキテクチャ、コーディング標準、一般的なワークフロー | ソース管理を通じたチームメンバー  |
| **プロジェクトルール**       | `./.claude/rules/*.md`                                                                                                                                          | モジュール化されたトピック固有のプロジェクト指示  | 言語固有のガイドライン、テスト規約、API標準           | ソース管理を通じたチームメンバー  |
| **ユーザーメモリ**         | `~/.claude/CLAUDE.md`                                                                                                                                           | すべてのプロジェクトの個人的な設定         | コードスタイルの設定、個人的なツーリングショートカット       | あなただけ（すべてのプロジェクト） |
| **プロジェクトメモリ（ローカル）** | `./CLAUDE.local.md`                                                                                                                                             | 個人的なプロジェクト固有の設定           | あなたのサンドボックスURL、推奨テストデータ           | あなただけ（現在のプロジェクト）  |

すべてのメモリファイルは、Claude Codeが起動されるときに自動的にコンテキストに読み込まれます。階層内で高い位置にあるファイルが優先され、最初に読み込まれ、より具体的なメモリが構築される基盤を提供します。

<Note>
  CLAUDE.local.mdファイルは自動的に.gitignoreに追加されるため、バージョン管理にチェックインすべきではない個人的なプロジェクト固有の設定に最適です。
</Note>

## CLAUDE.mdインポート

CLAUDE.mdファイルは`@path/to/import`構文を使用して追加ファイルをインポートできます。次の例は3つのファイルをインポートします：

```
See @README for project overview and @package.json for available npm commands for this project.

# Additional Instructions
- git workflow @docs/git-instructions.md
```

相対パスと絶対パスの両方が許可されています。特に、ユーザーのホームディレクトリ内のファイルをインポートすることは、チームメンバーがリポジトリにチェックインされていない個人的な指示を提供するための便利な方法です。インポートはCLAUDE.local.mdの代替手段であり、複数のgitワークツリー間でより良く機能します。

```
# Individual Preferences
- @~/.claude/my-project-instructions.md
```

潜在的な衝突を避けるため、インポートはマークダウンコードスパンとコードブロック内では評価されません。

```
This code span will not be treated as an import: `@anthropic-ai/claude-code`
```

インポートされたファイルは再帰的に追加ファイルをインポートでき、最大深さは5ホップです。`/memory`コマンドを実行することで、どのメモリファイルが読み込まれているかを確認できます。

## Claudeがメモリをどのように検索するか

Claude Codeはメモリを再帰的に読み込みます：cwdから開始して、Claude Codeはルートディレクトリ\_/\_（ただし含まない）まで再帰し、見つかったCLAUDE.mdまたはCLAUDE.local.mdファイルを読み込みます。これは、Claude Codeを\_foo/bar/\_で実行し、\_foo/CLAUDE.md\_と\_foo/bar/CLAUDE.md\_の両方にメモリがある大規模なリポジトリで作業する場合に特に便利です。

Claudeはまた、現在の作業ディレクトリの下のサブツリーにネストされたCLAUDE.mdを発見します。起動時に読み込む代わりに、Claudeがそれらのサブツリー内のファイルを読み込むときにのみ含まれます。

## `/memory`でメモリを直接編集する

セッション中に`/memory`スラッシュコマンドを使用して、システムエディタでメモリファイルを開き、より広範な追加または整理を行います。

## プロジェクトメモリを設定する

重要なプロジェクト情報、規約、および頻繁に使用されるコマンドを保存するためにCLAUDE.mdファイルを設定したいとします。プロジェクトメモリは`./CLAUDE.md`または`./.claude/CLAUDE.md`に保存できます。

次のコマンドでコードベース用のCLAUDE.mdをブートストラップします：

```
> /init
```

<Tip>
  ヒント：

  * 繰り返しの検索を避けるために、頻繁に使用されるコマンド（ビルド、テスト、リント）を含める
  * コードスタイルの設定と命名規約を文書化する
  * プロジェクトに固有の重要なアーキテクチャパターンを追加する
  * CLAUDE.mdメモリは、チームと共有される指示と個人的な設定の両方に使用できます。
</Tip>

## `.claude/rules/`を使用したモジュール化ルール

大規模なプロジェクトの場合、`.claude/rules/`ディレクトリを使用して指示を複数のファイルに整理できます。これにより、チームは1つの大きなCLAUDE.mdの代わりに、焦点を絞った、よく整理されたルールファイルを維持できます。

### 基本構造

プロジェクトの`.claude/rules/`ディレクトリにマークダウンファイルを配置します：

```
your-project/
├── .claude/
│   ├── CLAUDE.md           # Main project instructions
│   └── rules/
│       ├── code-style.md   # Code style guidelines
│       ├── testing.md      # Testing conventions
│       └── security.md     # Security requirements
```

`.claude/rules/`内のすべての`.md`ファイルは自動的にプロジェクトメモリとして読み込まれ、`.claude/CLAUDE.md`と同じ優先度を持ちます。

### パス固有のルール

ルールは`paths`フィールドを持つYAMLフロントマターを使用して特定のファイルにスコープできます。これらの条件付きルールは、Claudeが指定されたパターンに一致するファイルで作業している場合にのみ適用されます。

```markdown  theme={null}
---
paths: src/api/**/*.ts
---

# API Development Rules

- All API endpoints must include input validation
- Use the standard error response format
- Include OpenAPI documentation comments
```

`paths`フィールドのないルールは無条件に読み込まれ、すべてのファイルに適用されます。

### グロブパターン

`paths`フィールドは標準的なグロブパターンをサポートしています：

| パターン                   | マッチ                           |
| ---------------------- | ----------------------------- |
| `**/*.ts`              | 任意のディレクトリ内のすべてのTypeScriptファイル |
| `src/**/*`             | `src/`ディレクトリの下のすべてのファイル       |
| `*.md`                 | プロジェクトルートのマークダウンファイル          |
| `src/components/*.tsx` | 特定のディレクトリ内のReactコンポーネント       |

中括弧を使用して複数のパターンを効率的にマッチさせることができます：

```markdown  theme={null}
---
paths: src/**/*.{ts,tsx}
---

# TypeScript/React Rules
```

これは`src/**/*.ts`と`src/**/*.tsx`の両方にマッチするように展開されます。カンマで複数のパターンを組み合わせることもできます：

```markdown  theme={null}
---
paths: {src,lib}/**/*.ts, tests/**/*.test.ts
---
```

### サブディレクトリ

ルールはより良い構造のためにサブディレクトリに整理できます：

```
.claude/rules/
├── frontend/
│   ├── react.md
│   └── styles.md
├── backend/
│   ├── api.md
│   └── database.md
└── general.md
```

すべての`.md`ファイルは再帰的に発見されます。

### シンボリックリンク

`.claude/rules/`ディレクトリはシンボリックリンクをサポートしており、複数のプロジェクト間で一般的なルールを共有できます：

```bash  theme={null}
# Symlink a shared rules directory
ln -s ~/shared-claude-rules .claude/rules/shared

# Symlink individual rule files
ln -s ~/company-standards/security.md .claude/rules/security.md
```

シンボリックリンクは解決され、その内容は通常どおり読み込まれます。循環シンボリックリンクは検出され、適切に処理されます。

### ユーザーレベルのルール

すべてのプロジェクトに適用される個人的なルールを`~/.claude/rules/`に作成できます：

```
~/.claude/rules/
├── preferences.md    # Your personal coding preferences
└── workflows.md      # Your preferred workflows
```

ユーザーレベルのルールはプロジェクトルールの前に読み込まれ、プロジェクトルールに高い優先度を与えます。

<Tip>
  `.claude/rules/`のベストプラクティス：

  * **ルールを焦点を絞る**：各ファイルは1つのトピック（例：`testing.md`、`api-design.md`）をカバーする必要があります
  * **説明的なファイル名を使用する**：ファイル名はルールがカバーする内容を示す必要があります
  * **条件付きルールは控えめに使用する**：ルールが本当に特定のファイルタイプに適用される場合にのみ`paths`フロントマターを追加します
  * **サブディレクトリで整理する**：関連するルールをグループ化します（例：`frontend/`、`backend/`）
</Tip>

## 組織レベルのメモリ管理

組織は、すべてのユーザーに適用される一元管理されたCLAUDE.mdファイルをデプロイできます。

組織レベルのメモリ管理を設定するには：

1. [上記のメモリタイプテーブル](#determine-memory-type)に示されている**管理ポリシー**ロケーションで管理されたメモリファイルを作成します。

2. 構成管理システム（MDM、グループポリシー、Ansibleなど）を通じてデプロイして、すべての開発者マシン間で一貫した配布を確保します。

## メモリのベストプラクティス

* **具体的である**：「2スペースのインデントを使用する」は「コードを適切にフォーマットする」より優れています。
* **構造を使用して整理する**：各個別のメモリを箇条書きとしてフォーマットし、関連するメモリを説明的なマークダウン見出しの下にグループ化します。
* **定期的にレビューする**：プロジェクトが進化するにつれてメモリを更新して、Claudeが常に最新の情報とコンテキストを使用していることを確認します。
