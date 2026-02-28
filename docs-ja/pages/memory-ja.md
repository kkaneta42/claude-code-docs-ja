> ## Documentation Index
> Fetch the complete documentation index at: https://code.claude.com/docs/llms.txt
> Use this file to discover all available pages before exploring further.

# Claude のメモリを管理する

> 異なるメモリロケーションとベストプラクティスを使用して、セッション全体で Claude Code のメモリを管理する方法を学びます。

Claude Code には、セッション全体で保持される 2 種類のメモリがあります。

* **Auto memory**: Claude は、プロジェクトパターン、主要コマンド、ユーザーの設定など、有用なコンテキストを自動的に保存します。これはセッション全体で保持されます。
* **CLAUDE.md ファイル**: Claude が従うべき指示、ルール、設定を含むマークダウンファイルで、ユーザーが作成・管理します。

どちらも、すべてのセッションの開始時に Claude のコンテキストに読み込まれます。ただし、auto memory はメインファイルの最初の 200 行のみを読み込みます。

## メモリタイプを決定する

Claude Code は階層構造で複数のメモリロケーションを提供し、それぞれ異なる目的を果たします。

| メモリタイプ                     | ロケーション                                                                                                                                                          | 目的                       | ユースケース例                           | 共有対象              |
| -------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------ | --------------------------------- | ----------------- |
| **Managed policy**         | • macOS: `/Library/Application Support/ClaudeCode/CLAUDE.md`<br />• Linux: `/etc/claude-code/CLAUDE.md`<br />• Windows: `C:\Program Files\ClaudeCode\CLAUDE.md` | IT/DevOps が管理する組織全体の指示   | 企業のコーディング標準、セキュリティポリシー、コンプライアンス要件 | 組織内のすべてのユーザー      |
| **Project memory**         | `./CLAUDE.md` または `./.claude/CLAUDE.md`                                                                                                                         | プロジェクトのチーム共有指示           | プロジェクトアーキテクチャ、コーディング標準、一般的なワークフロー | ソース管理経由のチームメンバー   |
| **Project rules**          | `./.claude/rules/*.md`                                                                                                                                          | モジュール化されたトピック固有のプロジェクト指示 | 言語固有のガイドライン、テスト規約、API 標準          | ソース管理経由のチームメンバー   |
| **User memory**            | `~/.claude/CLAUDE.md`                                                                                                                                           | すべてのプロジェクトの個人設定          | コードスタイル設定、個人用ツールショートカット           | あなただけ（すべてのプロジェクト） |
| **Project memory (local)** | `./CLAUDE.local.md`                                                                                                                                             | 個人的なプロジェクト固有の設定          | サンドボックス URL、推奨テストデータ              | あなただけ（現在のプロジェクト）  |
| **Auto memory**            | `~/.claude/projects/<project>/memory/`                                                                                                                          | Claude の自動メモと学習          | プロジェクトパターン、デバッグの洞察、アーキテクチャノート     | あなただけ（プロジェクトごと）   |

作業ディレクトリより上のディレクトリ階層内の CLAUDE.md ファイルは、起動時に完全に読み込まれます。子ディレクトリ内の CLAUDE.md ファイルは、Claude がそれらのディレクトリ内のファイルを読むときにオンデマンドで読み込まれます。Auto memory は `MEMORY.md` の最初の 200 行のみを読み込みます。より具体的な指示は、より広い指示よりも優先されます。

<Note>
  CLAUDE.local.md ファイルは自動的に .gitignore に追加されるため、バージョン管理にチェックインすべきではないプライベートなプロジェクト固有の設定に最適です。
</Note>

## Auto memory

Auto memory は、Claude が作業中に学習、パターン、洞察を記録する永続的なディレクトリです。Claude に対して記述する指示を含む CLAUDE.md ファイルとは異なり、auto memory はセッション中に Claude が発見したことに基づいて Claude が自分自身のために記述するメモを含みます。

<Note>
  Auto memory はデフォルトで有効です。オン/オフを切り替えるには、`/memory` を使用して auto-memory トグルを選択します。
</Note>

### Claude が記憶すること

Claude が作業する際、以下のようなことを保存する場合があります。

* プロジェクトパターン: ビルドコマンド、テスト規約、コードスタイル設定
* デバッグの洞察: 難しい問題の解決策、一般的なエラーの原因
* アーキテクチャノート: 主要ファイル、モジュール関係、重要な抽象化
* ユーザーの設定: コミュニケーションスタイル、ワークフロー習慣、ツール選択

### Auto memory が保存される場所

各プロジェクトは `~/.claude/projects/<project>/memory/` に独自のメモリディレクトリを取得します。`<project>` パスは git リポジトリルートから派生するため、同じリポジトリ内のすべてのサブディレクトリは 1 つの auto memory ディレクトリを共有します。Git worktrees は個別のメモリディレクトリを取得します。git リポジトリの外では、代わりに作業ディレクトリが使用されます。

ディレクトリには `MEMORY.md` エントリポイントとオプションのトピックファイルが含まれます。

```text  theme={null}
~/.claude/projects/<project>/memory/
├── MEMORY.md          # 簡潔なインデックス、すべてのセッションに読み込まれます
├── debugging.md       # デバッグパターンの詳細なメモ
├── api-conventions.md # API 設計の決定
└── ...                # Claude が作成するその他のトピックファイル
```

`MEMORY.md` はメモリディレクトリのインデックスとして機能します。Claude はセッション全体を通じてこのディレクトリ内のファイルを読み書きし、`MEMORY.md` を使用して何が保存されているかを追跡します。

### 動作方法

* `MEMORY.md` の最初の 200 行は、すべてのセッションの開始時に Claude のシステムプロンプトに読み込まれます。200 行を超えるコンテンツは自動的に読み込まれず、Claude は詳細なメモを個別のトピックファイルに移動することで簡潔に保つよう指示されます。
* `debugging.md` や `patterns.md` などのトピックファイルは起動時に読み込まれません。Claude は標準ファイルツールを使用してオンデマンドで読み込み、情報が必要な場合に読み込みます。
* Claude はセッション中にメモリファイルを読み書きするため、作業中にメモリの更新が行われるのを確認できます。

### Auto memory を管理する

Auto memory ファイルはマークダウンファイルで、いつでも編集できます。`/memory` を使用してファイルセレクタを開きます。このセレクタには、CLAUDE.md ファイルと共に auto memory エントリポイントが含まれます。`/memory` セレクタには、機能をオン/オフにするための auto-memory トグルも含まれます。

Claude に特定のものを保存するよう指示するには、直接指示します。「pnpm を使用していることを覚えておいて、npm ではなく」または「API テストがローカル Redis インスタンスを必要とすることをメモリに保存して」などです。

設定または環境変数を通じて auto memory を制御することもできます。

すべてのプロジェクトの auto memory を無効にするには、ユーザー設定に `autoMemoryEnabled` を追加します。

```json  theme={null}
// ~/.claude/settings.json
{ "autoMemoryEnabled": false }
```

単一のプロジェクトの auto memory を無効にするには、プロジェクト設定に `autoMemoryEnabled` を追加します。

```json  theme={null}
// .claude/settings.json
{ "autoMemoryEnabled": false }
```

`CLAUDE_CODE_DISABLE_AUTO_MEMORY` 環境変数を使用してすべての他の設定をオーバーライドします。これは `/memory` トグルと `settings.json` の両方よりも優先されるため、CI または管理環境に役立ちます。

```bash  theme={null}
export CLAUDE_CODE_DISABLE_AUTO_MEMORY=1  # Force off
export CLAUDE_CODE_DISABLE_AUTO_MEMORY=0  # Force on
```

## CLAUDE.md インポート

CLAUDE.md ファイルは `@path/to/import` 構文を使用して追加ファイルをインポートできます。次の例は 3 つのファイルをインポートします。

```
See @README for project overview and @package.json for available npm commands for this project.

# Additional Instructions
- git workflow @docs/git-instructions.md
```

相対パスと絶対パスの両方が許可されます。相対パスは、作業ディレクトリではなく、インポートを含むファイルに相対的に解決されます。バージョン管理にチェックインすべきではないプライベートなプロジェクト固有の設定については、`CLAUDE.local.md` を優先します。これは自動的に読み込まれ、`.gitignore` に追加されます。

複数の git worktrees 全体で作業する場合、`CLAUDE.local.md` は 1 つにのみ存在します。すべての worktrees が同じ個人指示を共有するように、ホームディレクトリインポートを代わりに使用します。

```
# Individual Preferences
- @~/.claude/my-project-instructions.md
```

<Warning>
  Claude Code がプロジェクトで外部インポートを初めて遭遇すると、特定のファイルをリストする承認ダイアログが表示されます。承認して読み込むか、拒否してスキップします。これはプロジェクトごとの 1 回限りの決定です。拒否されると、ダイアログは再度表示されず、インポートは無効のままになります。
</Warning>

潜在的な衝突を回避するため、インポートはマークダウンコードスパンとコードブロック内では評価されません。

```
This code span will not be treated as an import: `@anthropic-ai/claude-code`
```

インポートされたファイルは、最大深度 5 ホップで追加ファイルを再帰的にインポートできます。読み込まれたメモリファイルを確認するには、`/memory` コマンドを実行します。

## Claude がメモリを検索する方法

Claude Code はメモリを再帰的に読み込みます。cwd から開始して、Claude Code はルートディレクトリ */* までさかのぼり（ただし含まない）、見つかった CLAUDE.md または CLAUDE.local.md ファイルを読み込みます。これは、Claude Code を *foo/bar/* で実行し、*foo/CLAUDE.md* と *foo/bar/CLAUDE.md* の両方にメモリがある大規模なリポジトリで作業する場合に特に便利です。

Claude は、現在の作業ディレクトリの下のサブツリーにネストされた CLAUDE.md も発見します。起動時に読み込む代わりに、Claude がそれらのサブツリー内のファイルを読むときにのみ含まれます。

### 追加ディレクトリからメモリを読み込む

`--add-dir` フラグは、Claude にメインの作業ディレクトリの外の追加ディレクトリへのアクセスを提供します。デフォルトでは、これらのディレクトリからの CLAUDE.md ファイルは読み込まれません。

追加ディレクトリからメモリファイル（CLAUDE.md、.claude/CLAUDE.md、.claude/rules/\*.md）も読み込むには、`CLAUDE_CODE_ADDITIONAL_DIRECTORIES_CLAUDE_MD` 環境変数を設定します。

```bash  theme={null}
CLAUDE_CODE_ADDITIONAL_DIRECTORIES_CLAUDE_MD=1 claude --add-dir ../shared-config
```

## `/memory` でメモリを直接編集する

セッション中に `/memory` コマンドを使用して、より広範な追加または整理のためにシステムエディタでメモリファイルを開きます。

## プロジェクトメモリを設定する

重要なプロジェクト情報、規約、頻繁に使用されるコマンドを保存するための CLAUDE.md ファイルを設定したいとします。プロジェクトメモリは `./CLAUDE.md` または `./.claude/CLAUDE.md` に保存できます。

次のコマンドを使用してコードベースの CLAUDE.md をブートストラップします。

```
> /init
```

<Tip>
  ヒント:

  * 繰り返し検索を避けるために、頻繁に使用されるコマンド（ビルド、テスト、リント）を含めます
  * コードスタイル設定と命名規約を文書化します
  * プロジェクト固有の重要なアーキテクチャパターンを追加します
  * CLAUDE.md メモリは、チームと共有される指示と個人の設定の両方に使用できます。
</Tip>

## `.claude/rules/` を使用したモジュール化ルール

大規模なプロジェクトの場合、`.claude/rules/` ディレクトリを使用して指示を複数のファイルに整理できます。これにより、チームは 1 つの大きな CLAUDE.md ではなく、焦点を絞った整理されたルールファイルを保持できます。

### 基本構造

プロジェクトの `.claude/rules/` ディレクトリにマークダウンファイルを配置します。

```
your-project/
├── .claude/
│   ├── CLAUDE.md           # Main project instructions
│   └── rules/
│       ├── code-style.md   # Code style guidelines
│       ├── testing.md      # Testing conventions
│       └── security.md     # Security requirements
```

`.claude/rules/` 内のすべての `.md` ファイルは、`.claude/CLAUDE.md` と同じ優先度でプロジェクトメモリとして自動的に読み込まれます。

### パス固有のルール

ルールは `paths` フィールドを含む YAML frontmatter を使用して特定のファイルにスコープできます。これらの条件付きルールは、Claude が指定されたパターンに一致するファイルで作業している場合にのみ適用されます。

```markdown  theme={null}
---
paths:
  - "src/api/**/*.ts"
---

# API Development Rules

- All API endpoints must include input validation
- Use the standard error response format
- Include OpenAPI documentation comments
```

`paths` フィールドのないルールは無条件に読み込まれ、すべてのファイルに適用されます。

### Glob パターン

`paths` フィールドは標準 glob パターンをサポートします。

| パターン                   | マッチ                             |
| ---------------------- | ------------------------------- |
| `**/*.ts`              | 任意のディレクトリ内のすべての TypeScript ファイル |
| `src/**/*`             | `src/` ディレクトリの下のすべてのファイル        |
| `*.md`                 | プロジェクトルートのマークダウンファイル            |
| `src/components/*.tsx` | 特定のディレクトリの React コンポーネント        |

複数のパターンを指定できます。

```markdown  theme={null}
---
paths:
  - "src/**/*.ts"
  - "lib/**/*.ts"
  - "tests/**/*.test.ts"
---
```

ブレース展開は複数の拡張子またはディレクトリをマッチングするためにサポートされています。

```markdown  theme={null}
---
paths:
  - "src/**/*.{ts,tsx}"
  - "{src,lib}/**/*.ts"
---

# TypeScript/React Rules
```

これは `src/**/*.{ts,tsx}` を展開して、`.ts` と `.tsx` ファイルの両方をマッチングします。

### サブディレクトリ

ルールはより良い構造のためにサブディレクトリに整理できます。

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

すべての `.md` ファイルは再帰的に発見されます。

### シンボリックリンク

`.claude/rules/` ディレクトリはシンボリックリンクをサポートし、複数のプロジェクト全体で共通ルールを共有できます。

```bash  theme={null}
# Symlink a shared rules directory
ln -s ~/shared-claude-rules .claude/rules/shared

# Symlink individual rule files
ln -s ~/company-standards/security.md .claude/rules/security.md
```

シンボリックリンクは解決され、その内容は通常どおり読み込まれます。循環シンボリックリンクは検出され、適切に処理されます。

### ユーザーレベルのルール

すべてのプロジェクトに適用される個人ルールを `~/.claude/rules/` に作成できます。

```
~/.claude/rules/
├── preferences.md    # Your personal coding preferences
└── workflows.md      # Your preferred workflows
```

ユーザーレベルのルールはプロジェクトルールの前に読み込まれ、プロジェクトルールに高い優先度を与えます。

<Tip>
  `.claude/rules/` のベストプラクティス:

  * **ルールを焦点を絞る**: 各ファイルは 1 つのトピック（例：`testing.md`、`api-design.md`）をカバーする必要があります
  * **説明的なファイル名を使用する**: ファイル名はルールがカバーする内容を示す必要があります
  * **条件付きルールは控えめに使用する**: ルールが本当に特定のファイルタイプに適用される場合にのみ `paths` frontmatter を追加します
  * **サブディレクトリで整理する**: 関連するルールをグループ化します（例：`frontend/`、`backend/`）
</Tip>

## 組織レベルのメモリ管理

組織は、すべてのユーザーに適用される一元管理された CLAUDE.md ファイルをデプロイできます。

組織レベルのメモリ管理を設定するには:

1. [上記のメモリタイプテーブル](#determine-memory-type)に示されている **Managed policy** ロケーションで管理メモリファイルを作成します。

2. 構成管理システム（MDM、Group Policy、Ansible など）経由でデプロイして、すべての開発者マシン全体で一貫した配布を確保します。

## メモリのベストプラクティス

* **具体的にする**: 「コードを適切にフォーマットする」よりも「2 スペースのインデントを使用する」の方が優れています。
* **構造を使用して整理する**: 各個別のメモリを箇条書きとしてフォーマットし、関連するメモリを説明的なマークダウン見出しの下にグループ化します。
* **定期的に確認する**: プロジェクトが進化するにつれてメモリを更新して、Claude が常に最新の情報とコンテキストを使用していることを確認します。
