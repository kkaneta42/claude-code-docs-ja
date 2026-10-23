> ## Documentation Index
> Fetch the complete documentation index at: https://code.claude.com/docs/llms.txt
> Use this file to discover all available pages before exploring further.

# Code Review をカスタマイズする

> REVIEW.md と CLAUDE.md を使って、Code Review がプルリクエストで指摘する内容を調整します。重大度の再調整、パスのスキップ、チェックの追加、そしてどのコピーが適用されるかを確認する方法を説明します。

リポジトリに指示をコミットすることで、[Code Review](/docs/ja/code-review.md) がそのリポジトリで指摘する内容を変更できます。これにより、nit の量を減らしたり、生成されたファイルへのコメントを止めたり、チームが重視するルールを追加したりできます。指示は次の 2 つのファイルのいずれかに記述します。

* **`CLAUDE.md`**：Claude Code がレビューを含むすべてのタスクで読み込む[プロジェクト指示](/docs/ja/memory.md)です。Code Review はこれをプロジェクトのコンテキストとして読み込み、これに違反する変更を指摘します。
* **`REVIEW.md`**：レビュー専用の指示です。チームが何を指摘してほしいか、どの重大度で指摘するか、何をスキップするかを記述するために使用します。

リポジトリのルートに `REVIEW.md` を追加してマージします。その後、[デフォルトブランチを保護](#which-branch-review-md-is-read-from)します。

> [!NOTE]
>
> レビューの徹底度や実行タイミングを変更するには、Owner に[レビューレベル](/docs/ja/code-review-setup.md#set-the-default-review-level)または [**Review runs** 設定](/docs/ja/code-review-setup.md#set-when-reviews-run)の変更を依頼してください。

## プロジェクト全体のルールには CLAUDE.md を使用する

Code Review は、リポジトリの `CLAUDE.md` ファイルをプロジェクトのコンテキストとして読み込みます。そのルールのいずれかに違反する変更は、問題に応じた[重大度レベル](/docs/ja/code-review-pull-requests.md#severity-levels)の検出結果になります。

レビューでは、リポジトリのルートにある `CLAUDE.md` と、変更された各ファイルの親ディレクトリにある `CLAUDE.md` ファイルが読み込まれます。サブディレクトリの `CLAUDE.md` は、プルリクエストがそのパス配下のファイルを変更した場合に読み込まれます。

## レビュー専用のルールには REVIEW\.md を使用する

`REVIEW.md` は、Code Review をリポジトリに合わせて調整するための、リポジトリのルートに置くファイルです。サブディレクトリに `REVIEW.md` を追加して、ルートのファイルに加えて、そのパス配下の変更に対するチェックを追加することもできます。

問題を検出するエージェントと、それを検証するエージェントは、Code Review のデフォルトのレビューガイダンスとともに、このファイルの内容をリポジトリのレビュー指示として受け取ります。最終的なレビューを書き出すステップでは、重大度を確定してサマリーを書く前にこのファイルを参照します。

次のレイアウト例には、ルートのファイルとサブディレクトリのファイルが 1 つずつあります。

```text theme={null}
your-repo/
├── REVIEW.md            # Root file
├── services/
│   └── billing/
│       └── REVIEW.md    # Adds checks for changes under services/billing/
└── src/
```

サブディレクトリのファイルに頼る前に、デフォルトブランチを保護し、[ブランチ構成に応じてレビューが何を読み込むか](#what-a-review-reads-for-each-branch-setup)を確認してください。

> [!NOTE]
>
> Code Review サービスとローカルの [`/code-review` コマンド](/docs/ja/code-review-local)は別々のツールであり、読み込むファイルが異なります。サービスは `CLAUDE.md` と `REVIEW.md` の両方を読み込みます。自分のマシン上の Claude Code セッション内で実行する `/code-review` コマンドは、`CLAUDE.md` ファイルを読み込みますが、`REVIEW.md` は読み込みません。両方で適用したいガイダンスは `CLAUDE.md` に記述し、`REVIEW.md` はプルリクエストのレビューに固有のルールのために使用してください。

### REVIEW\.md の例

この `REVIEW.md` は、バックエンドサービス向けに重大度を再調整し、nit の数に上限を設け、生成されたファイルをスキップし、リポジトリ固有のチェックを追加します。

```markdown theme={null}
# Review instructions

## What Important means here

Reserve Important for findings that would break behavior, leak data,
or block a rollback: incorrect logic, unscoped database queries, PII
in logs or error messages, and migrations that aren't backward
compatible. Style, naming, and refactoring suggestions are Nit at
most.

## Cap the nits

Report at most five Nits per review.

## Do not report

- Anything CI already enforces: lint, formatting, type errors
- Generated files under `src/gen/` and any `*.lock` file
- Test-only code that intentionally violates production rules

## Always check

- New API routes have an integration test
- Log lines don't include email addresses, user IDs, or request bodies
- Database queries are scoped to the caller's tenant
```

### REVIEW\.md に何を書くかを決める

`REVIEW.md` は自由形式の Markdown で、レビューが何を検出して報告するかを変更します。レビューの形式は変更しません。発生している問題を見つけ、示されているような指示を追加してください。[例](#example-review-md)では最初の 4 つを使用しています。

* **間違ったものが Important としてマークされる**：リポジトリにおける 🔴 Important の意味を再定義します。デフォルトの調整は本番コードを対象としており、ドキュメントリポジトリ、設定リポジトリ、プロトタイプではもっと狭い定義が望ましい場合があります。どの種類の検出結果が Important で、どれがせいぜい Nit なのかを明記してください。重大度を引き上げることもでき、たとえば `CLAUDE.md` への違反をすべて Important として扱うこともできます。
* **nit が多すぎる**：1 回のレビューで投稿される 🟡 Nit コメントの数に上限を設けます。「nit は最大 5 件まで報告する」のような上限により、レビューを対応可能な内容に保てます。
* **生成されたファイルや CI がすでにチェックしている内容へのコメント**：Claude が検出結果をスキップすべきパスと検出結果のカテゴリを列挙します。よくある候補は、生成コード、ロックファイル、vendor された依存関係、そして lint やスペルチェックなど CI がすでに強制しているものです。ある程度のレビューを必要とするものの、徹底的な精査までは不要なパスについては、代わりに基準を引き上げます。たとえば「`scripts/` では、ほぼ確実かつ重大な場合にのみ報告する」とします。
* **チームのルールがチェックされていない**：「新しい API ルートには統合テストが必要」のように、すべてのプルリクエストで指摘してほしいルールを追加します。
* **誤っていることが判明する検出結果**：ある種類の検出結果を投稿する前に根拠を求めます。たとえば「動作に関する主張には、命名からの推測ではなく、ソース内の `file:line` の引用が必要」とすることで、作成者に余計なやり取りを強いる誤検出を減らせます。

これらの指示の一部は、[保護されたデフォルトブランチ上のルートファイルを必要とします](#which-branch-review-md-is-read-from)。

`REVIEW.md` にはレビューの動作を変える指示だけを記述し、一般的なプロジェクトのコンテキストは `CLAUDE.md` に残してください。

### REVIEW\.md に他のファイルを取り込む

レビュー指示を複数のファイルに分割し、それらをルートの `REVIEW.md` に取り込むことができます。`REVIEW.md` が長くなった場合や、すでに別のファイルでレビュールールを管理している場合に使用してください。

ファイルを取り込むには、ルートの `REVIEW.md` に `@` とファイル名だけを記述した行を追加します。Code Review はその行をファイルの内容で置き換えるため、内容は `REVIEW.md` の一部として適用されます。この例では、ルートのファイルが独自の指示を 1 つ記述し、その後に 2 つのルールファイルを取り込んでいます。

```markdown theme={null}
# Review instructions

Report at most five Nits per review.

@review-security.md
@review-api.md
```

取り込むファイルは、リポジトリのルートに `REVIEW.md` と並べて保存します。

```text theme={null}
your-repo/
├── REVIEW.md
├── review-security.md
└── review-api.md
```

Code Review は保護されたブランチから `REVIEW.md` を読み込む場合にファイルを取り込むため、[リポジトリでレビューがどのブランチを読み込むか](#what-a-review-reads-for-each-branch-setup)を確認してください。

* **保護されたブランチ**：Code Review は `@` 行を取り込むファイルで置き換えます
* **保護されていないデフォルトブランチ**：`@` 行はプレーンテキストとして `REVIEW.md` に残ります。プルリクエストがその行で指定されたファイルを変更している場合、その行は除外されます。

レビューで取り込んだファイルが適用されない場合は、次の各項目を確認してください。

* **場所**：ファイルをリポジトリのルートに移動します。`@docs/review-rules.md` のようなサブディレクトリ内へのパスは取り込まれません。
* **名前**：大文字と小文字を含めてファイル名を正確に一致させ、スペースを含まない名前を使用します。`REVIEW.md` と同じ場所にあるどのファイルとも名前が一致しない行は、プレーンテキストとして `REVIEW.md` に残り、チェック実行ではスキップされた取り込みとして報告されません。
* **1 階層のみ**：すべてのファイルをルートの `REVIEW.md` に列挙します。取り込まれたファイル内やサブディレクトリの `REVIEW.md` 内の `@` 行はプレーンテキストのまま残り、別のファイルへの Markdown リンクは取り込みになりません。
* **上限**：取り込むファイルは異なるファイルで最大 8 つまでとし、`REVIEW.md` とそれが取り込むファイルの合計を 150,000 バイト未満に保ちます。バイト数の上限に達するファイルは、途中で切り詰められるのではなく、ファイル全体がスキップされます。チェック実行では、いずれかの上限によってスキップされた取り込み行の数が報告されます。
* **リンク**：`REVIEW.md` とそれが取り込むファイル全体で、Markdown リンクを 64 個以下に保ちます。`http`、`https`、`mailto` アドレスへのリンクと `#` アンカーへのリンクは数に含まれません。この上限を超えると、レビューは取り込まれたファイルだけでなく、ルートの `REVIEW.md` 全体をスキップします。その場合、チェック実行では[指示が適用されなかったことが示されます](/docs/ja/code-review-troubleshooting.md#the-check-run-mentions-review-md)。
* **マージ済みのコピー**：取り込むファイルを [`REVIEW.md` が読み込まれるブランチ](#which-branch-review-md-is-read-from)にマージします。レビューは両方を同じコミットから読み込み、プルリクエスト自体の変更から読み込むことはありません。

### REVIEW\.md がどのブランチから読み込まれるか

Code Review は、`REVIEW.md` をプルリクエストのベースブランチまたはデフォルトブランチから読み込み、プルリクエスト自体の変更から読み込むことはありません。レビューの動作を変更するには、まず `REVIEW.md` の変更をマージしてください。

`REVIEW.md` はデフォルトブランチに置き、そのブランチを保護してください。レビューが保護されたデフォルトブランチ上のコピー（下の表の 1 行目）を読み込む場合、ルートファイルにある次の指示が適用されます。

* 検出結果の重大度を下げる
* パス、ファイル、または問題の種類を除外する
* nit コメントの数に上限を設ける

#### ブランチ保護とみなされるもの

Code Review は、次の設定を保護とみなします。

* **デフォルトブランチ**：クラシックなブランチ保護ルールまたはルールセット
* **その他のブランチ**：ルールセットのみ

ルールセットは、更新を制限している場合、または少なくとも 1 件の承認を伴うプルリクエストを必須にしている場合に保護とみなされます。プルリクエストを必須にしている場合は、新しいプッシュ時にその承認を取り消すか、最後のプッシュ以降の承認を必須にする必要もあります。

#### ブランチ構成ごとにレビューが読み込むもの

下の表の 1 列目から、リポジトリの状況に該当するものを見つけてください。

| ブランチ保護 | 読み込まれるコピー | 読み込まれるファイル |
| :- | :- | :- |
| デフォルトブランチが保護されており、プルリクエストがそのブランチ、またはどのルールセットにも保護されていないブランチを対象としている | デフォルトブランチ | ルートファイル、それが取り込むファイル、およびサブディレクトリのファイル |
| プルリクエストが、ルールセットで保護された別のブランチを対象としている | そのベースブランチ | ルートファイル、それが取り込むファイル、およびサブディレクトリのファイル |
| デフォルトブランチが保護されておらず、ベースブランチにもどちらの種類の保護ルールもない | デフォルトブランチ | ルートファイル |
| Code Review が保護設定を確認できない。保護されていないデフォルトブランチと、クラシックなルールのみを持つベースブランチの組み合わせもこれに含まれる | なし | なし |

チェック実行で `REVIEW.md` について言及されている場合は、[The check run mentions REVIEW.md](/docs/ja/code-review-troubleshooting.md#the-check-run-mentions-review-md) を参照してください。

## 関連リソース

* [Code Review](/docs/ja/code-review.md)：サービスの概要とレビューの実行方法
* [プルリクエストでレビューを確認・依頼する](/docs/ja/code-review-pull-requests.md#severity-levels)：各重大度レベルの意味と検出結果の表示方法
* [Code Review をセットアップする](/docs/ja/code-review-setup.md)：Owner が設定するレビューレベルとレビューの実行タイミング
* [`/code-review` でローカルにレビューする](/docs/ja/code-review-local)：`/code-review` コマンド、その引数、effort レベル
* [メモリ](/docs/ja/memory.md)：Claude Code 全体で `CLAUDE.md` ファイルがどのように機能するか
