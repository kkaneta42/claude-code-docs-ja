> ## Documentation Index
> Fetch the complete documentation index at: https://code.claude.com/docs/llms.txt
> Use this file to discover all available pages before exploring further.

# Claude があなたのプロジェクトを記憶する方法

> CLAUDE.md ファイルで Claude に永続的な指示を与え、自動メモリで Claude が自動的に学習を蓄積できるようにします。

Claude Code の各セッションは、新しいコンテキストウィンドウで始まります。2 つのメカニズムがセッション間で知識を保持します。

* **CLAUDE.md ファイル**: Claude に永続的なコンテキストを与えるために書く指示
* **自動メモリ**: あなたの修正と好みに基づいて Claude が自分自身で書くメモ

このページでは、以下の方法について説明します。

* [CLAUDE.md ファイルを書いて整理する](#claude-md-files)
* [`.claude/rules/` で特定のファイルタイプにルールをスコープする](#organize-rules-with-claude/rules/)
* [自動メモリを設定する](#auto-memory)ので Claude が自動的にメモを取ります
* [指示が従われていない場合のトラブルシューティング](#troubleshoot-memory-issues)

<h2 id="claude-md-vs-auto-memory">
  CLAUDE.md と自動メモリ
</h2>

Claude Code には 2 つの相互補完的なメモリシステムがあります。どちらも各会話の開始時に読み込まれます。Claude はこれらをコンテキストとして扱い、強制的な設定ではありません。アクションをブロックするには、Claude の判断に関わらず [PreToolUse hook](/docs/ja/hooks-guide) を使用してください。より具体的で簡潔な指示ほど、Claude はそれに従う可能性が高くなります。

|              | CLAUDE.md ファイル                | 自動メモリ                                                |
| :----------- | :---------------------------- | :--------------------------------------------------- |
| **誰が書くか**    | あなた                           | Claude                                               |
| **何が含まれるか**  | 指示とルール                        | 学習とパターン                                              |
| **スコープ**     | プロジェクト、ユーザー、または組織             | リポジトリごと、ワーキングツリー全体で共有                                |
| **読み込まれる場所** | すべてのセッション                     | すべてのセッション（最初の 200 行または 25KB）                         |
| **用途**       | コーディング標準、ワークフロー、プロジェクトアーキテクチャ | あなたの好み、Claude に与える修正、Claude がコードから導き出せないプロジェクトコンテキスト |

Claude の動作をガイドしたい場合は CLAUDE.md ファイルを使用します。自動メモリにより、Claude は手動の作業なしにあなたの修正から学習できます。

Subagent も独自の自動メモリを保持できます。詳細については、[subagent 設定](/docs/ja/sub-agents#enable-persistent-memory)を参照してください。

<h2 id="claude-md-files">
  CLAUDE.md ファイル
</h2>

CLAUDE.md ファイルは、プロジェクト、個人のワークフロー、または組織全体に対して Claude に永続的な指示を与えるマークダウンファイルです。これらのファイルはプレーンテキストで記述し、Claude はすべてのセッションの開始時にそれらを読み込みます。

<h3 id="when-to-add-to-claude-md">
  CLAUDE.md に追加するタイミング
</h3>

CLAUDE.md を、そうでなければ何度も説明し直すことになる内容を記述する場所として扱ってください。以下の場合に追加してください。

* Claude が同じ間違いを 2 回目に犯した場合
* コードレビューで Claude がこのコードベースについて知っておくべきだった何かが指摘された場合
* 前回のセッションで入力した同じ修正または説明をチャットに再度入力している場合
* 新しいチームメンバーが生産性を高めるために同じコンテキストが必要な場合

すべてのセッションで Claude が保持すべき事実に限定してください。ビルドコマンド、規約、プロジェクトレイアウト、「常に X を実行する」ルールなどです。エントリが複数ステップの手順である場合、またはコードベースの 1 つの部分にのみ関連する場合は、代わりに [skill](/docs/ja/skills) または [パススコープ付きルール](#organize-rules-with-claude/rules/) に移動してください。[拡張機能の概要](/docs/ja/features-overview#build-your-setup-over-time) では、各メカニズムをいつ使用するかについて説明しています。

<h3 id="choose-where-to-put-claude-md-files">
  CLAUDE.md ファイルの配置場所を選択する
</h3>

CLAUDE.md ファイルはいくつかの場所に配置でき、それぞれ異なるスコープを持ちます。以下の表は、読み込み順序でそれらをリストしており、最も広いスコープから最も具体的なものまでなので、プロジェクト指示はユーザー指示の後に表示されます。

| スコープ         | 場所                                                                                                                                                                    | 目的                                     | ユースケース例                           | 共有対象              |
| ------------ | --------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------- | --------------------------------- | ----------------- |
| **管理ポリシー**   | • macOS: `/Library/Application Support/ClaudeCode/CLAUDE.md`<br />• Linux と WSL: `/etc/claude-code/CLAUDE.md`<br />• Windows: `C:\Program Files\ClaudeCode\CLAUDE.md` | IT/DevOps が管理する組織全体の指示                 | 企業のコーディング標準、セキュリティポリシー、コンプライアンス要件 | 組織内のすべてのユーザー      |
| **ユーザー指示**   | `~/.claude/CLAUDE.md`                                                                                                                                                 | すべてのプロジェクトの個人的な設定                      | コードスタイルの設定、個人的なツーリングショートカット       | あなただけ（すべてのプロジェクト） |
| **プロジェクト指示** | `./CLAUDE.md` または `./.claude/CLAUDE.md`                                                                                                                               | プロジェクトのチーム共有指示                         | プロジェクトアーキテクチャ、コーディング標準、一般的なワークフロー | ソース管理を通じたチームメンバー  |
| **ローカル指示**   | `./CLAUDE.local.md`                                                                                                                                                   | 個人的なプロジェクト固有の設定。`.gitignore` に追加してください | サンドボックス URL、推奨テストデータ              | あなただけ（現在のプロジェクト）  |

ワーキングディレクトリより上のディレクトリ階層内の CLAUDE.md および CLAUDE.local.md ファイルは起動時に読み込まれます。サブディレクトリ内のファイルは、Claude がそれらのディレクトリ内のファイルを読み込むときにオンデマンドで読み込まれます。完全な解決順序については、[CLAUDE.md ファイルの読み込み方法](#how-claude-md-files-load) を参照してください。

大規模なプロジェクトの場合、[プロジェクトルール](#organize-rules-with-claude/rules/) を使用して指示をトピック固有のファイルに分割できます。ルールを使用すると、指示を特定のファイルタイプまたはサブディレクトリにスコープできます。

<h3 id="set-up-a-project-claude-md">
  プロジェクト CLAUDE.md をセットアップする
</h3>

プロジェクト CLAUDE.md は `./CLAUDE.md` または `./.claude/CLAUDE.md` に保存できます。このファイルを作成し、プロジェクトで作業する誰もが適用される指示を追加してください。ビルドおよびテストコマンド、コーディング標準、アーキテクチャ上の決定、命名規約、一般的なワークフローなどです。これらの指示はバージョン管理を通じてチームと共有されるため、個人的な設定ではなくプロジェクトレベルの標準に焦点を当ててください。ファイルが読み込まれたことを確認するには、セッションで `/context` を実行し、**Memory files** の下のリストを確認してください。

<Tip>
  `/init` を実行して、開始用の CLAUDE.md を自動的に生成します。Claude はコードベースを分析し、検出したビルドコマンド、テスト指示、プロジェクト規約を含むファイルを作成します。CLAUDE.md が既に存在する場合、`/init` は上書きするのではなく改善を提案します。そこから Claude が自分で発見しない指示で改善してください。

  `CLAUDE_CODE_NEW_INIT=1` を設定して、インタラクティブなマルチフェーズフローを有効にします。`/init` はどのアーティファクトをセットアップするかを尋ねます。CLAUDE.md ファイル、スキル、フック。その後、サブエージェントでコードベースを探索し、フォローアップの質問でギャップを埋め、ファイルを書き込む前に確認可能な提案を提示します。
</Tip>

<h3 id="write-effective-instructions">
  効果的な指示を書く
</h3>

CLAUDE.md ファイルはすべてのセッションの開始時にコンテキストウィンドウに読み込まれ、会話と一緒にトークンを消費します。[コンテキストウィンドウの可視化](/docs/ja/context-window) は、CLAUDE.md がスタートアップコンテキストの残りの部分に対してどこに読み込まれるかを示しています。これらはコンテキストであり、強制的な設定ではないため、指示の書き方は Claude がそれらに従う信頼性に影響します。具体的で簡潔で、よく構造化された指示が最も効果的です。

**サイズ**: CLAUDE.md ファイルあたり 200 行以下を目指してください。より長いファイルはより多くのコンテキストを消費し、遵守を減らします。指示が大きくなっている場合は、[パススコープ付きルール](#path-specific-rules) を使用して、Claude が一致するファイルで作業するときにのみ指示が読み込まれるようにしてください。また、コンテンツを [インポート](#import-additional-files) に分割して整理することもできますが、インポートされたファイルは依然として読み込まれ、起動時にコンテキストウィンドウに入ります。

**構造**: マークダウンヘッダーと箇条書きを使用して関連する指示をグループ化してください。Claude は読者と同じ方法で構造をスキャンします。整理されたセクションは密集した段落よりも従いやすいです。

**具体性**: 検証できるほど具体的な指示を書いてください。例えば：

* 「コードを適切にフォーマットする」ではなく「2 スペースのインデントを使用する」
* 「変更をテストする」ではなく「コミット前に `npm test` を実行する」
* 「ファイルを整理する」ではなく「API ハンドラーは `src/api/handlers/` に配置する」

**一貫性**: 2 つのルールが矛盾している場合、Claude は 1 つを任意に選択する可能性があります。CLAUDE.md ファイル、サブディレクトリ内のネストされた CLAUDE.md ファイル、および [`.claude/rules/`](#organize-rules-with-claude/rules/) を定期的に確認して、古い指示または矛盾する指示を削除してください。モノレポでは、[`claudeMdExcludes`](#exclude-specific-claude-md-files) を使用して、作業に関連のない他のチームの CLAUDE.md ファイルをスキップしてください。

<h3 id="import-additional-files">
  追加ファイルをインポートする
</h3>

CLAUDE.md ファイルは `@path/to/import` 構文を使用して追加ファイルをインポートできます。インポートされたファイルは展開され、それらを参照する CLAUDE.md と一緒に起動時にコンテキストに読み込まれます。

相対パスと絶対パスの両方が許可されます。相対パスはワーキングディレクトリではなく、インポートを含むファイルに対して相対的に解決されます。インポートされたファイルは他のファイルを再帰的にインポートでき、最大深度は 4 ホップです。

インポート解析はマークダウンコードスパンとフェンスコードブロックをスキップします。CLAUDE.md でパスを言及する際にインポートしないようにするには、バッティックで囲んでください。`` `@README` `` を記述するとテキストはリテラルのままですが、バッティックの外の `@README` はファイルをインポートします。

README、package.json、ワークフローガイドを取り込むには、CLAUDE.md の任意の場所で `@` 構文で参照してください。

```text theme={null}
プロジェクト概要については @README を参照し、このプロジェクトで利用可能な npm コマンドについては @package.json を参照してください。

# 追加指示
- git ワークフロー @docs/git-instructions.md
```

バージョン管理にチェックインすべきではない個人的なプロジェクト固有の設定については、プロジェクトルートに `CLAUDE.local.md` を作成してください。これは `CLAUDE.md` と一緒に読み込まれ、同じ方法で扱われます。`CLAUDE.local.md` を `.gitignore` に追加して、コミットされないようにしてください。`CLAUDE_CODE_NEW_INIT=1` が設定されている場合、`/init` を実行して個人オプションを選択するとこれが自動的に行われます。

同じリポジトリの複数の git worktrees で作業する場合、gitignored `CLAUDE.local.md` はそれを作成した worktree にのみ存在します。worktrees 全体で個人的な指示を共有するには、代わりにホームディレクトリからファイルをインポートしてください。

```text theme={null}
# 個人的な設定
- @~/.claude/my-project-instructions.md
```

<Warning>
  プロジェクトレベルのメモリファイル内のインポートは、ホームディレクトリインポートのようにワーキングディレクトリの外に解決されるパスを持つ場合、外部です。Claude Code がプロジェクト内で外部インポートを初めて検出すると、ファイルをリストする承認ダイアログが表示されます。拒否した場合、インポートは無効のままになり、ダイアログは再度表示されません。

  Claude Code はダイアログを表示して、共有プロジェクトにコミットされた他の人のファイルから保護します。`~/.claude/CLAUDE.md` および `~/.claude/rules/` などのユーザースコープメモリファイルは、あなたが自分で記述したファイルです。[Cowork](https://claude.com/product/cowork) セッションをデスクトップで実行している場合を除き、Claude Code はダイアログなしでそれらのインポートを読み込み、残りの個人設定と同じように信頼します。

  デスクトップの Cowork セッションでは、Claude Code はユーザースコープファイル内のセッションのワーキングディレクトリの外に解決されるパスへのインポートをスキップし、ファイルの残りを読み込みます。これらのセッションでは、シンリンクまたはハードリンクである `~/.claude/CLAUDE.md` もスキップし、ワーキングディレクトリの外を指すシンリンクされた `~/.claude/rules/` ディレクトリまたはルールファイルもスキップします。
</Warning>

<h3 id="agents-md">
  AGENTS.md
</h3>

Claude Code は `AGENTS.md` ではなく `CLAUDE.md` を読み込みます。リポジトリが既に他のコーディングエージェント用に `AGENTS.md` を使用している場合、`CLAUDE.md` を作成してそれをインポートし、両方のツールが重複なしで同じ指示を読み込むようにしてください。また、インポートの下に Claude 固有の指示を追加することもできます。Claude は起動時にインポートされたファイルを読み込み、その後残りを追加します。

```markdown CLAUDE.md theme={null}
@AGENTS.md

## Claude Code

`src/billing/` の下の変更にはプランモードを使用してください。
```

Claude 固有のコンテンツを追加する必要がない場合は、シンリンクも機能します。

```bash theme={null}
ln -s AGENTS.md CLAUDE.md
```

コマンドは成功時に出力を印字しません。次のセッションで `/context` を実行し、`CLAUDE.md` が **Memory files** の下に表示されることを確認してください。

Windows では、シンリンクを作成するには管理者権限または開発者モードが必要なため、代わりに `@AGENTS.md` インポートを使用してください。

[`/init`](/docs/ja/commands) を実行すると、`.cursor/rules/` または `.cursorrules` の Cursor ルール、および `.github/copilot-instructions.md` の Copilot ルールが読み込まれ、関連する部分が生成された `CLAUDE.md` に組み込まれます。`CLAUDE_CODE_NEW_INIT=1` が設定されている場合、`/init` は `AGENTS.md`、`.devin/rules/`、`.windsurf/rules/` または `.windsurfrules`、および `.clinerules` も読み込みます。

また、[`/import`](/docs/ja/commands) を実行して、サポートされているコーディングエージェントの設定を Claude Code に取り込むこともできます。これは `AGENTS.md` などの指示ファイルの 1 回限りのコピーを一致する `CLAUDE.md` に追加し、MCP サーバー、コマンド、サブエージェント、スキルを引き継ぎます。Claude Code v2.1.213 以降が必要です。

<h3 id="how-claude-md-files-load">
  CLAUDE.md ファイルの読み込み方法
</h3>

Claude Code は、現在のワーキングディレクトリとそれより上のすべてのディレクトリから `CLAUDE.md` および `CLAUDE.local.md` を読み込みます。Claude Code を `foo/bar/` で実行すると、`foo/bar/CLAUDE.md`、`foo/CLAUDE.md`、およびそれらの隣にある `CLAUDE.local.md` ファイルから指示を読み込みます。

検出されたすべてのファイルはコンテキストに連結され、互いに上書きするのではなく、連結されます。ディレクトリツリー全体で、コンテンツはファイルシステムルートからワーキングディレクトリまで順序付けられます。`foo/bar/` の例では、`foo/CLAUDE.md` は `foo/bar/CLAUDE.md` の前にコンテキストに表示されるため、Claude を起動した場所に近い指示が最後に読み込まれます。各ディレクトリ内では、`CLAUDE.local.md` は `CLAUDE.md` の後に追加されるため、個人的なメモはそのレベルで Claude が読み込む最後のものです。

Claude はまた、現在のワーキングディレクトリの下のサブディレクトリ内の `CLAUDE.md` および `CLAUDE.local.md` ファイルを検出します。起動時に読み込む代わりに、Claude がそれらのサブディレクトリ内のファイルを読み込むときに含まれます。

大規模なモノレポで他のチームの CLAUDE.md ファイルが取得される場合は、[`claudeMdExcludes`](#exclude-specific-claude-md-files) を使用してそれらをスキップしてください。ルートおよびディレクトリごとの CLAUDE.md ファイルとルールの完全なレイアウトについては、[モノレポと大規模リポジトリ](/docs/ja/large-codebases) を参照してください。

CLAUDE.md ファイル内のブロックレベルの HTML コメント（`<!-- maintainer notes -->`）は、コンテンツが Claude のコンテキストに注入される前に削除されます。人間のメンテナーのためのメモを残すために使用してください。コンテキストトークンを費やさずに。コードブロック内のコメントは保持されます。CLAUDE.md ファイルを Read ツールで直接開くと、コメントは表示されたままになります。

<h4 id="load-from-additional-directories">
  追加ディレクトリから読み込む
</h4>

`--add-dir` フラグは、メインワーキングディレクトリの外の追加ディレクトリへのアクセスを Claude に提供します。デフォルトでは、これらのディレクトリからのメモリファイルは読み込まれません。

追加ディレクトリからメモリファイルも読み込むには、`CLAUDE_CODE_ADDITIONAL_DIRECTORIES_CLAUDE_MD` 環境変数を設定してください。

```bash theme={null}
CLAUDE_CODE_ADDITIONAL_DIRECTORIES_CLAUDE_MD=1 claude --add-dir ../shared-config
```

これは追加ディレクトリから `CLAUDE.md`、`.claude/CLAUDE.md`、`.claude/rules/*.md`、および `CLAUDE.local.md` を読み込みます。`CLAUDE.local.md` は [`--setting-sources`](/docs/ja/cli-reference) から `local` を除外した場合はスキップされます。

<h3 id="organize-rules-with-claude/rules/">
  `.claude/rules/` でルールを整理する
</h3>

大規模なプロジェクトの場合、`.claude/rules/` ディレクトリを使用して指示を複数のファイルに整理できます。これにより、指示がモジュール化され、チームが保守しやすくなります。ルールは [特定のファイルパスにスコープ](#path-specific-rules) することもでき、Claude が一致するファイルで作業するときにのみコンテキストに読み込まれるため、ノイズを減らしてコンテキストスペースを節約できます。

<Note>
  ルールはすべてのセッションまたは一致するファイルが開かれるときにコンテキストに読み込まれます。タスク固有の指示で常にコンテキストに必要ではない場合は、代わりに [スキル](/docs/ja/skills) を使用してください。これは呼び出すときまたは Claude がプロンプトに関連していると判断したときにのみ読み込まれます。
</Note>

<h4 id="set-up-rules">
  ルールをセットアップする
</h4>

プロジェクトの `.claude/rules/` ディレクトリにマークダウンファイルを配置してください。各ファイルは 1 つのトピックをカバーし、`testing.md` または `api-design.md` のような説明的なファイル名を持つべきです。すべての `.md` ファイルは再帰的に検出されるため、`frontend/` または `backend/` のようなサブディレクトリにルールを整理できます。

```text theme={null}
your-project/
├── .claude/
│   ├── CLAUDE.md           # メインプロジェクト指示
│   └── rules/
│       ├── code-style.md   # コードスタイルガイドライン
│       ├── testing.md      # テスト規約
│       └── security.md     # セキュリティ要件
```

[`paths` frontmatter](#path-specific-rules) のないルールは、`.claude/CLAUDE.md` と同じ優先度で起動時に読み込まれます。

[`--setting-sources`](/docs/ja/cli-reference) から `project` を除外した場合、プロジェクトルールはスキップされます。v2.1.211 より前では、パススコープ付きルールやネストされた `.claude/rules/` ディレクトリ内のルールを含む、オンデマンドで読み込まれるルールは、`project` が除外されていても読み込まれました。

<h4 id="path-specific-rules">
  パス固有のルール
</h4>

ルールは YAML frontmatter の `paths` フィールドを使用して特定のファイルにスコープできます。これらの条件付きルールは、Claude が指定されたパターンに一致するファイルで作業している場合にのみ適用されます。

```markdown theme={null}
---
paths:
  - "src/api/**/*.ts"
---

# API 開発ルール

- すべての API エンドポイントは入力検証を含める必要があります
- 標準エラー応答形式を使用してください
- OpenAPI ドキュメンテーションコメントを含めてください
```

`paths` フィールドのないルールは無条件に読み込まれ、すべてのファイルに適用されます。パススコープ付きルールは、すべてのツール使用時ではなく、パターンに一致するファイルを読み込むときにトリガーされます。v2.1.198 の時点で、マッチングは Claude がシンリンクされたパスを通じてファイルに到達するときにも機能します。例えば、シンリンクされたチェックアウトなど。

`paths` フィールドでグロブパターンを使用して、拡張子、ディレクトリ、またはそれらの任意の組み合わせでファイルをマッチしてください。

| パターン                   | マッチ                             |
| ---------------------- | ------------------------------- |
| `**/*.ts`              | 任意のディレクトリ内のすべての TypeScript ファイル |
| `src/**/*`             | `src/` ディレクトリの下のすべてのファイル        |
| `*.md`                 | プロジェクトルート内のマークダウンファイル           |
| `src/components/*.tsx` | 特定のディレクトリ内の React コンポーネント       |

複数のパターンを指定し、ブレース展開を使用して 1 つのパターンで複数の拡張子をマッチできます。

```markdown theme={null}
---
paths:
  - "src/**/*.{ts,tsx}"
  - "lib/**/*.ts"
  - "tests/**/*.test.ts"
---
```

各ブレースグループは展開されたパターンの数を乗算します。`src/*.{ts,tsx}` は 2 つのパターンに展開され、`{a,b}/{c,d}/*.{ts,tsx}` は 8 つに展開されます。展開を制限するために、ルールの全体 `paths` リストは 1,000 展開パターンと 4 MiB の 1 つの予算を共有し、ブレースのないパターンはそれに対してカウントされません。

Claude Code は予算を超えるパターンを展開されていない状態で使用し、その文字通りのブレースはファイルをマッチしません。v2.1.217 より前では、多くのブレースグループを持つ `paths` 値は起動時に CLI をスタールさせるか、クラッシュさせました。

グロブ構文は `[` をブラケット式（`[abc]` など）の開始として扱います。`photos [2024/**` のようにブラケット式として読み込めない `[` を持つパターンは無効です。何もマッチしません。ルールの他のパターンは機能し続けます。ファイル名内のリテラル `[` をマッチするには、`photos \[2024/**` のようにエスケープしてください。v2.1.207 より前では、1 つの無効なパターンは、ルールが評価されたすべてのファイルに対して Read ツールを失敗させました。何もマッチする代わりに。

<h4 id="share-rules-across-projects-with-symlinks">
  シンリンクを使用してプロジェクト全体でルールを共有する
</h4>

`.claude/rules/` ディレクトリはシンリンクをサポートしているため、共有ルールセットを保持し、複数のプロジェクトにリンクできます。循環シンリンクは検出され、適切に処理されます。

Claude Code は、ワーキングディレクトリの外のターゲットを持つシンリンクを [外部インポート](#import-additional-files) のように扱います。リンクされたルールは、プロジェクトの外部インポートを承認するまで読み込まれず、その後 [`paths` フィールド](#path-specific-rules) のないものだけが読み込まれます。Claude Code はプロジェクトメモリファイルが `@path` で外部ファイルをインポートするときだけその承認を求め、シンリンク単独では求めません。その承認なしで共有ルールを読み込むには、[`~/.claude/rules/`](#user-level-rules) に保持してください。ここでは、マシン上のすべてのプロジェクトに適用されます。

この例は、共有ディレクトリと個別ファイルの両方をリンクしています。

```bash theme={null}
ln -s ~/shared-claude-rules .claude/rules/shared
ln -s ~/company-standards/security.md .claude/rules/security.md
```

<h4 id="user-level-rules">
  ユーザーレベルのルール
</h4>

`~/.claude/rules/` 内の個人的なルールはマシン上のすべてのプロジェクトに適用されます。プロジェクト固有ではない設定に使用してください。

```text theme={null}
~/.claude/rules/
├── preferences.md    # あなたの個人的なコーディング設定
└── workflows.md      # あなたの推奨ワークフロー
```

ユーザーレベルのルールはプロジェクトルールの前に読み込まれ、プロジェクトルールに高い優先度を与えます。

<h3 id="manage-claude-md-for-large-teams">
  大規模なチーム向けに CLAUDE.md を管理する
</h3>

Claude Code を複数のチームにデプロイする組織の場合、指示を一元化し、どの CLAUDE.md ファイルが読み込まれるかを制御できます。

<h4 id="deploy-organization-wide-claude-md">
  組織全体の CLAUDE.md をデプロイする
</h4>

組織は、マシン上のすべてのユーザーに適用される一元管理された CLAUDE.md をデプロイできます。このファイルは個別の設定で除外することはできません。

<Steps>
  <Step title="管理ポリシーの場所にファイルを作成する">
    * macOS: `/Library/Application Support/ClaudeCode/CLAUDE.md`
    * Linux と WSL: `/etc/claude-code/CLAUDE.md`
    * Windows: `C:\Program Files\ClaudeCode\CLAUDE.md`
  </Step>

  <Step title="設定管理システムでデプロイする">
    MDM、グループポリシー、Ansible、または同様のツールを使用して、開発者マシン全体にファイルを配布してください。その他の組織全体の設定オプションについては、[管理設定](/docs/ja/managed-settings) を参照してください。
  </Step>
</Steps>

`claudeMd` キーを使用すると、別のファイルをデプロイする代わりに、管理された CLAUDE.md コンテンツを `managed-settings.json` 内に直接配置できます。

**スコープ**: マシン上のすべての Claude Code セッション、すべてのリポジトリで。リポジトリ固有のガイダンスについては、プロジェクト CLAUDE.md をコミットしてください。

**優先度**: 管理された CLAUDE.md ファイルと同じです。ユーザーおよびプロジェクト CLAUDE.md の前に読み込まれます。

**どこで尊重されるか**: 管理および ポリシー設定のみ。ユーザー、プロジェクト、またはローカル設定で `claudeMd` を設定しても効果がありません。

以下の例は、管理設定ファイル内に直接動作指示を追加します。

```json theme={null}
{
  "claudeMd": "常に `make lint` を実行してからコミットしてください。\nメインに直接プッシュしないでください。"
}
```

管理された CLAUDE.md と [管理設定](/docs/ja/managed-settings) は異なる目的を果たします。技術的な強制には設定を、動作ガイダンスには CLAUDE.md を使用してください。

| 懸念事項                         | 設定先                                          |
| :--------------------------- | :------------------------------------------- |
| 特定のツール、コマンド、またはファイルパスをブロックする | 管理設定: `permissions.deny`                     |
| サンドボックス分離を強制する               | 管理設定: `sandbox.enabled`                      |
| 環境変数と API プロバイダーのルーティング      | 管理設定: `env`                                  |
| ログイン方法と組織制限                  | 管理設定: `forceLoginMethod`、`forceLoginOrgUUID` |
| コードスタイルと品質ガイドライン             | 管理 CLAUDE.md                                 |
| データ処理とコンプライアンスのリマインダー        | 管理 CLAUDE.md                                 |
| Claude の動作指示                 | 管理 CLAUDE.md                                 |

設定ルールはクライアントによって強制され、Claude が何をするかに関係なく。CLAUDE.md 指示は Claude の動作を形作りますが、ハード強制レイヤーではありません。

<h4 id="exclude-specific-claude-md-files">
  特定の CLAUDE.md ファイルを除外する
</h4>

大規模なモノレポでは、祖先 CLAUDE.md ファイルに作業に関連のない指示が含まれている可能性があります。`claudeMdExcludes` 設定を使用すると、パスまたはグロブパターンで特定のファイルをスキップできます。

この例は、トップレベルの CLAUDE.md と親フォルダのルールディレクトリを除外します。`.claude/settings.local.json` に追加して、除外をマシンにローカルに保つしてください。

```json theme={null}
{
  "claudeMdExcludes": [
    "**/monorepo/CLAUDE.md",
    "/home/user/monorepo/other-team/.claude/rules/**"
  ]
}
```

パターンはグロブ構文を使用して絶対ファイルパスに対してマッチされます。`claudeMdExcludes` は任意の [設定レイヤー](/docs/ja/settings#where-settings-live) で設定できます。ユーザー、プロジェクト、ローカル、または管理ポリシー。配列はレイヤー全体でマージされます。

[シンリンク](#share-rules-across-projects-with-symlinks) を通じて到達するルールファイルを除外するには、ファイルまたはそのディレクトリがリンクであるかどうか、`.claude/rules/` の下のファイルのパスまたはそのリンクターゲットのいずれかに対してパターンを記述してください。いずれかのパスに一致するパターンはファイルを除外します。v2.1.239 より前では、リンクターゲットに一致するパターンのみがファイルを除外しました。

管理ポリシー CLAUDE.md ファイルは除外できません。これにより、個別の設定に関係なく、組織全体の指示が常に適用されることが保証されます。

<h2 id="auto-memory">
  自動メモリ
</h2>

自動メモリを使用すると、Claude は何も書かずにセッション間で知識を蓄積できます。Claude は作業中に自分自身のためにメモを 4 種類保存します。Claude はメモリファイルのフロントマターに `type` フィールドとして種類を記録します。

* `user`：あなたの役割、専門知識、および作業の好み
* `feedback`：Claude に与える修正と確認するアプローチ
* `project`：進行中の作業、期限、および Claude がコードまたは git 履歴から導き出せない決定
* `reference`：issue トラッカーやダッシュボードなど、プロジェクト外の情報を見つける場所

Claude はアーキテクチャ、ファイルパス、デバッグ修正など、コードベースから導き出せるものはすべてスキップします。また、CLAUDE.md ファイルが既に述べていることもスキップします。

Claude はすべてのセッションで何かを保存するわけではありません。情報が将来の会話で役立つかどうかに基づいて、何を記憶する価値があるかを決定します。

<h3 id="enable-or-disable-auto-memory">
  自動メモリを有効または無効にする
</h3>

自動メモリはデフォルトで有効です。切り替えるには、セッションで `/memory` を開き、自動メモリトグルを使用します。これにより `autoMemoryEnabled` が `~/.claude/settings.json` のユーザー設定に保存されます。単一のプロジェクトに対してオフにするには、そのプロジェクトの設定で `autoMemoryEnabled` を設定します。

```json theme={null}
{
  "autoMemoryEnabled": false
}
```

環境変数を使用して自動メモリを無効にするには、`CLAUDE_CODE_DISABLE_AUTO_MEMORY=1` を設定します。

<h3 id="storage-location">
  ストレージの場所
</h3>

各プロジェクトは `~/.claude/projects/<project>/memory/` に独自のメモリディレクトリを取得します。`<project>` パスは git リポジトリから派生しているため、同じリポジトリ内のすべてのワーキングツリーとサブディレクトリは 1 つの自動メモリディレクトリを共有します。git リポジトリの外では、プロジェクトルートが代わりに使用されます。

`CLAUDE_CODE_PROJECT_DIR_NAME` を `CLAUDE_CONFIG_DIR` の横に設定した場合、Claude Code はその名前を、どのリポジトリを起動しても `<config dir>/projects/` の下の `<project>` ディレクトリとして使用するため、その設定ディレクトリで起動されたプロジェクトは 1 つの自動メモリディレクトリを共有します。Claude Code v2.1.234 以降が必要です。詳細は [`CLAUDE_CODE_PROJECT_DIR_NAME`](/docs/ja/sessions#name-the-project-directory-yourself) を参照してください。

自動メモリを別の場所に保存するには、`settings.json` で `autoMemoryDirectory` を設定します。これは任意の[設定スコープ](/docs/ja/settings#settings-precedence)から読み込まれます。ユーザー、プロジェクト、ローカル、ポリシー、または `--settings` です。

```json theme={null}
{
  "autoMemoryDirectory": "~/my-custom-memory-dir"
}
```

値は絶対パスであるか、`~/` で始まる必要があります。プロジェクトの `.claude/settings.json` または `.claude/settings.local.json` で設定する場合、Claude Code はそれを[設定ファイル内の hooks と同じワークスペーストラストルール](/docs/ja/permissions#what-runs-before-you-trust-a-folder)の下で尊重します。

ディレクトリには `MEMORY.md` インデックスとメモリごとに 1 つのトピックファイルが含まれます。

```text theme={null}
~/.claude/projects/<project>/memory/
├── MEMORY.md           # インデックス、メモリごとに 1 行、すべてのセッションに読み込まれます
├── user_role.md        # 1 つのメモリ
├── feedback_testing.md # 1 つのメモリ
└── ...                 # Claude が作成するその他のトピックファイル
```

`MEMORY.md` はメモリディレクトリのインデックスとして機能します。Claude はセッション全体を通じてこのディレクトリ内のファイルを読み書きし、`MEMORY.md` を使用して保存されている内容を追跡します。

自動メモリはマシンローカルです。同じ git リポジトリ内のすべてのワーキングツリーとサブディレクトリは 1 つの自動メモリディレクトリを共有します。ファイルはマシン間またはクラウド環境全体で共有されません。

Claude Code は [`cleanupPeriodDays`](/docs/ja/settings-reference#cleanupperioddays) 保持期間後に古いセッショントランスクリプトを削除しますが、メモリディレクトリ内のメモリファイルをその[保持スイープ](/docs/ja/claude-directory#cleaned-up-automatically)から除外します。`MEMORY.md` とトピックファイルは、あなたまたは Claude が編集または削除するまで保持されます。

<h3 id="how-it-works">
  仕組み
</h3>

`MEMORY.md` の最初の 200 行、または最初の 25KB のいずれか先に来る方が、すべての会話の開始時に読み込まれます。そのしきい値を超えるコンテンツはセッション開始時に読み込まれません。Claude は詳細なメモを別のトピックファイルに移動することで、`MEMORY.md` を簡潔に保ちます。

Claude が `MEMORY.md` に書き込んだ後、Claude Code はファイルを 200 行および 25KB の読み込み制限に対して測定します。ファイルが制限に近い場合、Claude Code は Claude に短縮するよう促します。エントリごとに 1 行を保持し、詳細をトピックファイルに移動し、古いエントリをマージまたは削除します。ファイルが制限を超えている場合、書き込みは成功しますが、Claude Code は[Claude にインデックスを書き直すよう指示するエラー](/docs/ja/errors#memory-index-is-over-its-read-limit)を返します。次の読み込み時に制限を超えるすべてが削除されるためです。

この制限は `MEMORY.md` にのみ適用されます。Claude Code は最大 4 MiB の CLAUDE.md ファイルを完全に読み込み、より大きいファイルはスキップします。より短いファイルはより良い遵守を生成します。

`user_role.md` または `feedback_testing.md` などのトピックファイルは起動時に読み込まれません。Claude は標準ファイルツールを使用してセッション中にオンデマンドで読み込み、情報が必要な場合に読みます。

メイン会話の自動メモリは[サブエージェント](/docs/ja/sub-agents#what-loads-at-startup)に読み込まれません。例外は[フォーク](/docs/ja/sub-agents#fork-the-current-conversation)で、これは親会話とシステムプロンプトを継承します。サブエージェント `memory` フィールドで有効にされたサブエージェント自身の自動メモリは、別のディレクトリです。

Claude はセッション中にメモリファイルを読み書きします。Claude Code インターフェイスで「Saved 2 memories」または「Recalled 2 memories」などのメッセージが表示されたら、Claude は `~/.claude/projects/<project>/memory/` から積極的に更新または読み込みを行っています。

Claude が YAML フロントマターで始まるメモリファイルを書き込む場合、Claude Code は書き込み時刻を ISO 8601 タイムスタンプとして `modified` フロントマターフィールドに記録します。タイムスタンプは、事実がどの程度最新であるかを、あなたと Claude がメモリを読み戻すときの両方に示します。フロントマターを持つすべてのファイルは、以前のバージョンで作成されたファイルを含め、Claude が次に書き込むときにフィールドを取得します。Claude Code はフロントマターを持たないファイルにフロントマターを追加することはありません。`modified` フィールドには Claude Code v2.1.214 以降が必要です。

<h3 id="audit-and-edit-your-memory">
  メモリを監査および編集する
</h3>

自動メモリファイルはプレーンマークダウンで、いつでも編集または削除できます。[`/memory`](#view-and-edit-with-%2Fmemory) を実行して、セッション内からメモリファイルを参照して開きます。

<h2 id="view-and-edit-with-/memory">
  `/memory` で表示および編集する
</h2>

`/memory` コマンドは、ユーザーおよびプロジェクトスコープ全体にわたる CLAUDE.md、CLAUDE.local.md、およびその他のメモリファイルの場所をリストします。これには、まだ存在しないファイルのユーザーおよびプロジェクト CLAUDE.md エントリも含まれます。また、自動メモリのオン/オフを切り替えたり、自動メモリフォルダを開くオプションを提供したりできます。任意のファイルを選択してエディタで開きます。まだ存在しないファイルを選択すると、最初にそれが作成されます。現在のセッションに実際に読み込まれたファイルを確認するには、`/context` を実行します。

VS Code などの GUI エディタはファイルを別のウィンドウで開き、ファイルが開いている間もセッションを使用し続けることができます。v2.1.216 より前は、`/memory` はファイルを閉じるまで応答を待っていました。Vim などのターミナルエディタはターミナルを占有し、終了するまで制御します。

Claude に何かを記憶するよう求めるとき、「常に npm ではなく pnpm を使用する」または「API テストがローカル Redis インスタンスを必要とすることを覚えておく」のように、Claude はそれを自動メモリに保存します。代わりに CLAUDE.md に指示を追加するには、Claude に直接「これを CLAUDE.md に追加する」と尋ねるか、`/memory` を通じてファイルを自分で編集します。

<h2 id="troubleshoot-memory-issues">
  メモリの問題をトラブルシューティングする
</h2>

これらは CLAUDE.md と自動メモリに関する最も一般的な問題と、それらをデバッグするための手順です。

<h3 id="claude-isn’t-following-my-claude-md">
  Claude が CLAUDE.md に従っていない
</h3>

CLAUDE.md のコンテンツはシステムプロンプト自体の一部ではなく、システムプロンプトの後のユーザーメッセージとして配信されます。Claude はそれを読んで従おうとしますが、特に曖昧または矛盾した指示の場合、厳密な準拠の保証はありません。

デバッグするには：

* `/context` を実行し、**Memory files** の下のリストを確認して、CLAUDE.md と CLAUDE.local.md ファイルが読み込まれたことを確認します。ファイルがそこにない場合、Claude はそれを見ることができません。`/memory` を使用してファイルを開いて編集します。
* 関連する CLAUDE.md がセッションに読み込まれる場所にあることを確認します（[CLAUDE.md ファイルをどこに配置するかを選択する](#choose-where-to-put-claude-md-files)を参照）。
* 指示をより具体的にします。「2 スペースのインデントを使用する」は「コードを見栄えよくフォーマットする」よりも機能します。
* CLAUDE.md ファイル全体で矛盾する指示を探します。2 つのファイルが同じ動作に対して異なるガイダンスを提供する場合、Claude は任意に 1 つを選択する可能性があります。

指示が各コミットの前やファイル編集後など、特定の時点で実行する必要があるものである場合は、代わりに [hook](/docs/ja/hooks-guide) として記述します。Hook はシステムコマンドとして固定されたライフサイクルイベントで実行され、Claude が何をすることに決めたかに関係なく適用されます。

システムプロンプトレベルで指示が必要な場合は、[`--append-system-prompt`](/docs/ja/cli-reference#system-prompt-flags) を使用します。起動時に渡すため、対話的な使用よりもスクリプトと自動化に適しています。会話を再開するときの動作については、[再開された会話でのシステムプロンプトフラグ](/docs/ja/cli-reference#system-prompt-flags-in-resumed-conversations)を参照してください。

<Tip>
  [`InstructionsLoaded` hook](/docs/ja/hooks#instructionsloaded) を使用して、どの指示ファイルが読み込まれたか、いつ読み込まれたか、そしてなぜ読み込まれたかを正確にログに記録します。これはパス固有のルールまたはサブディレクトリ内の遅延読み込みファイルをデバッグするのに役立ちます。
</Tip>

<h3 id="i-don’t-know-what-auto-memory-saved">
  自動メモリが何を保存したかわからない
</h3>

`/memory` を実行し、自動メモリフォルダを選択して、Claude が保存したものを参照します。すべてはプレーンマークダウンであり、読み取り、編集、または削除できます。

<h3 id="my-claude-md-is-too-large">
  CLAUDE.md が大きすぎる
</h3>

200 行を超えるファイルはより多くのコンテキストを消費し、準拠を減らす可能性があります。Claude Code は 4 MiB を超えるファイルをスキップします。[パス固有のルール](#path-specific-rules)を使用して、Claude が一致するファイルで作業する場合にのみ指示を読み込むか、すべてのセッションで必要でないコンテンツをトリミングします。[`@path` インポート](#import-additional-files)に分割すると組織化に役立ちますが、インポートされたファイルは起動時に読み込まれるため、コンテキストは削減されません。

[`/doctor`](/docs/ja/commands#all-commands) チェックアップは、チェックインされた CLAUDE.md のトリミングを提案します。これはディレクトリレイアウト、依存関係リスト、アーキテクチャの概要など、Claude がコードベースから導き出せるコンテンツを削除し、落とし穴、根拠、およびツールのデフォルトと異なる規約を保持します。トリムチェックには Claude Code v2.1.206 以降が必要です。

<h3 id="instructions-seem-lost-after-/compact">
  `/compact` の後に指示が失われたようです
</h3>

プロジェクトルートの CLAUDE.md は圧縮を生き残ります。`/compact` の後、Claude はディスクから再度読み込み、セッションに再度注入します。サブディレクトリ内のネストされた CLAUDE.md ファイルと [`paths:` frontmatter](#path-specific-rules) を持つルールは、Claude がそれらが適用されるファイルを読み込むときに再度読み込まれます。

圧縮後に指示が消えた場合、それは会話でのみ与えられたか、まだ再度読み込まれていないネストされた CLAUDE.md に存在するか、または圧縮以降ファイルと一致していないパス固有のルールです。会話のみの指示を CLAUDE.md に追加して、それらを永続化させます。完全な内訳については、[圧縮を生き残るもの](/docs/ja/context-window#what-survives-compaction)を参照してください。

効果的な指示を書くためのガイダンスについては、[効果的な指示を書く](#write-effective-instructions)を参照してください。

<h2 id="related-resources">
  関連リソース
</h2>

* [設定をデバッグする](/docs/ja/debug-your-config): CLAUDE.md または設定が有効にならない理由を診断する
* [Skills](/docs/ja/skills): オンデマンドで読み込まれる反復可能なワークフローをパッケージ化する
* [Settings](/docs/ja/settings): 設定ファイルで Claude Code の動作を設定する
* [Subagent メモリ](/docs/ja/sub-agents#enable-persistent-memory): subagent が独自の自動メモリを保持できるようにする
