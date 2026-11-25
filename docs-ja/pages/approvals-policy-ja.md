> ## Documentation Index
> Fetch the complete documentation index at: https://code.claude.com/docs/llms.txt
> Use this file to discover all available pages before exploring further.

# Claude Approvals ポリシーファイルリファレンス

> Claude Approvals のポリシーファイル `.claude/approvals.yml` のリファレンスです。キー、ルールの組み合わせ方、承認のカウント方法、ポリシーの例を説明します。

ポリシーファイル `.claude/approvals.yml` は、プルリクエストを誰が承認する必要があるか、また Claude がいつ承認してよいかを [Claude Approvals](https://code.claude.com/docs/ja/approvals.md) に伝えます。ここでは、そのキー、ルールの組み合わせ方、承認のカウント方法を確認できます。

> [!TIP]
>
> Approvals をセットアップして **Claude Approvals** チェックを必須にするには、[Claude Approvals をセットアップする](https://code.claude.com/docs/ja/approvals-setup.md)を参照してください。チェックのタイトルの意味を確認するには、[プルリクエストで Claude Approvals を使用する](https://code.claude.com/docs/ja/approvals-pull-requests.md)を参照してください。チェックが拒否するファイルについては、[Approvals が拒否するポリシーファイルを修正する](https://code.claude.com/docs/ja/approvals-troubleshooting.md#fix-a-policy-file-that-approvals-refuses)を参照してください。`repo/<name>` 分類器を定義するには、[Claude Approvals の分類器](https://code.claude.com/docs/ja/approvals-classifiers.md)を参照してください。

## ポリシーファイルの仕組み

ポリシーファイルはルールのリストです。各ルールは、対象とするファイルを `paths` で指定し、それらを変更するプルリクエストに何が必要かを示します。

* **`seats`**: 承認する必要がある人数
* **`claude`**: Claude が `approves`（承認する）、`comments`（コメントする）、`blocks`（ブロックする）のいずれを行うか
* **`override`**: 別の判定。その `if` が true の間、ルール自身の判定を置き換えます

次のポリシーファイルは、[Claude Approvals をセットアップする](https://code.claude.com/docs/ja/approvals-setup.md#let-claude-approve-when-code-review-passes)で出発点として使うものです。変更には 2 人の承認を求め、Claude のレビューがパスした場合は 1 人で済みます。どちらの場合も、プルリクエストの作成者を 1 人としてカウントできます。

```yaml theme={null}
# .claude/approvals.yml
version: 1
mode: observe
rules:
  - purpose: "A change takes two people. When Claude's review passes, one is enough and Claude approves."
    paths: ["**"]
    verdict: { claude: comments, seats: 2 }
    override:
      - { if: "claude/code_review = pass", verdict: { claude: approves, seats: 1 } }
  - purpose: "A change to the review rules takes two people."
    paths: ["**/.claude/**"]
    nested: inherit
    verdict: { claude: comments, seats: 2 }
```

このファイルの各行はそれぞれ 1 つの役割を担います。

| 行 | 役割 |
| :- | :- |
| [`mode: observe`](#top-level-keys) | **Claude Approvals** チェックが、ルールによって何が決まるかを表示します。ルールを適用するにはこの行を削除します |
| `purpose` | ルールが存在する理由を示します |
| [`paths: ["**"]`](#paths) | 1 つ目のルールはすべてのファイルにマッチします |
| [`verdict`](#verdict) | 2 人が承認する必要があり、[作成者を 1 人としてカウントできます](#whether-a-pull-request’s-author-counts)。Claude はコメントし、承認はしません |
| [`override`](#override) | [`claude/code_review`](https://code.claude.com/docs/ja/approvals-classifiers#classifiers-anthropic-provides) が `pass` を示している間は、作成者であってもよい 1 人で十分になり、Claude は承認できます |
| `paths: ["**/.claude/**"]` | 2 つ目のルールは、任意の `.claude/` ディレクトリ配下のファイルにマッチします。これにはポリシーファイル自体も含まれます |
| [`nested: inherit`](#policy-files-in-subdirectories) | ポリシーを適用した後、独自のポリシーファイルを持つサブディレクトリでも 2 つ目のルールを有効に保ちます |

`.claude/` 配下のファイルは両方のルールにマッチします。Approvals は[適用される判定のうち最も厳しいものを採用する](#how-rules-combine-into-one-verdict)ため、ポリシーを適用した後は、2 つ目のルールに `override` がないことから、そのファイルへの変更には 2 人が必要です。

## ポリシーファイルの配置場所

ポリシーファイルをリポジトリのルートに `.claude/approvals.yml` として保存し、デフォルトブランチにマージします。Approvals はデフォルトブランチからポリシーファイルを読み込むため、マージされた時点でファイルのルールが適用されます。

ファイル名を `.claude/approvals.yaml` にすることもできます。Approvals は `.yml` ファイルがない場合にこれを読み込みます。ディレクトリに独自のルールを与えるには、[そのディレクトリにポリシーファイル](#policy-files-in-subdirectories)を追加します。

### ポリシーファイルへの変更が有効になるタイミング

ポリシーファイルへの変更がオープンなプルリクエストにある間、Approvals は変更されたファイルのエラーをチェックすることがありますが、そのルールは一切適用しません。そのプルリクエストについては、デフォルトブランチ上のルールが判断します。

変更がマージされると、新しいプルリクエストには新しいルールが適用され、オープン中のプルリクエストには次回の評価から適用されます。Approvals はその後数分間、以前のコピーを読み込むことがあります。オープン中のプルリクエストを今すぐ評価するには、[`@claude approvals rerun`](https://code.claude.com/docs/ja/approvals-pull-requests#comment-commands-for-approvals) とコメントします。

### サブディレクトリのポリシーファイル

ルートのポリシーファイルとは別に、あるディレクトリに独自のルールを与えるには、`services/billing/.claude/approvals.yml` のように、そのディレクトリ内に `.claude/approvals.yml` を追加します。

変更された各ファイルについて、Approvals はそのファイルのディレクトリから上へたどります。変更されたファイルをカバーし、かつ `verdict` を持つルールが[適用される](#how-rules-combine-into-one-verdict)、最初の適用モードのポリシーファイルが、そのファイルについて判断します。上位のポリシーファイルにある `nested: inherit` ルールは、判断するポリシーファイルのルールの 1 つとしてカウントされます。

* **最も近いポリシーファイルが判断する**: ルートのポリシーファイルより少ない要件にすることもできます。それより上位では、`nested: inherit` が指定されたルールのみが引き続きカウントされます。
* **`paths` はそのディレクトリを起点とする**: `services/billing/.claude/approvals.yml` では、`services/billing/api/` 配下のファイルにマッチさせるには `api/**` と記述します
* **`locals` は下位に届く**: ポリシーファイルでは、その上位にあるポリシーファイルの locals を使用できます
* **各ポリシーファイルは独自の `mode` を持つ**: ルートのポリシーファイルが observe モードの間、ディレクトリの適用モードのポリシーファイルの下では、`nested: inherit` ルールも含め、そのルールは一切カウントされません
* **一部のカスタム分類器は `advisory` の下にのみ置く**: これは、[`tools`](https://code.claude.com/docs/ja/approvals-classifiers#tools) に `reviewers` または `labels` が含まれる分類器、または `merge` のない[入力](https://code.claude.com/docs/ja/approvals-classifiers.md#inputs)を持つ分類器です。`if` のない適用ルールに記載してください。ルールがその結果を読み取る場合、ディレクトリのポリシーファイル配下のプルリクエストでは、チェックに **Cannot evaluate: classifier outside advisory** と表示されることがあります

## ファイル全体のルール

ファイルのすべての部分で次のルールに従ってください。

* **キーと固定値**: キー、および `observe` や `approves` などの固定値は小文字で記述します。Approvals は未知のキーを含むファイルを拒否します
* **目的、パターン、条件**: すべての目的、`paths` パターン、条件をダブルクォートで囲みます
* **`!` 項目**: 条件の外にある各 `"!"` 項目はダブルクォートで囲みます。条件の中では、`!` 項目はシングルクォートで囲みます。Approvals はクォートされていない `!` 項目を含むファイルを拒否します
* **YAML**: ファイルは 1 つの YAML ドキュメントにまとめてください。そうしないと Approvals はファイルを拒否します。インデントにはスペースを使います。アンカー、エイリアス、`!!` タグは少なくとも警告の対象になります

## トップレベルのキー

以下のキーはファイルのトップレベルに記述します。

| キー | 必須 | 値 | デフォルト | 説明 |
| :- | :- | :- | :- | :- |
| `version` | はい | `1` | | スキーマのバージョン。引用符なしの数値で指定します |
| `rules` | はい | [ルール](#rule-keys)のリスト | | ルールの順序は関係ありません |
| `mode` | いいえ | `enforce`、`observe` | `enforce` | `observe` はルールがどのような判定を下すかを表示し、ファイル内のすべてのルールに適用されます。それでも中立にならないチェックや、他のブランチへのプルリクエストについては、[observe モードでの承認](https://code.claude.com/docs/ja/approvals-pull-requests.md#approvals-in-observe-mode)を参照してください |
| `nested` | いいえ | `overwrite`、`inherit` | `overwrite` | このファイルのルールのデフォルトです。[サブディレクトリ内のポリシーファイル](#policy-files-in-subdirectories)を参照してください |
| `run` | いいえ | `sequential`、`parallel` | `sequential` | このファイルのルールのデフォルトです。[分類器が実行されるタイミング](https://code.claude.com/docs/ja/approvals-classifiers.md#when-a-classifier-runs)を参照してください |
| `locals` | いいえ | 名前と値のマップ | | 再利用する値です。[`locals` と `use`](#locals-and-use) を参照してください |

## ルールのキー

各ルールには `purpose`、`paths`、および `verdict`、`advisory`、`findings`、`reuse` のうち少なくとも 1 つを指定します。この 4 つのうちルールが持つのが `reuse` だけの場合、`reuse` の値は `false` にするか、分類器を指定する必要があります。`verdict` のないルールは誰にも承認を求めず、どのファイルも[カバー](#how-rules-combine-into-one-verdict)しません。

ルールには次のキーを記述できます。

| キー | 型 | デフォルト | 説明 |
| :- | :- | :- | :- |
| `purpose` | 1 行のテキスト | 必須 | ルールが存在する理由 |
| [`paths`](#paths) | パターンのリスト | 必須 | ルールが一致する変更済みファイル |
| [`verdict`](#verdict) | マップ | | Claude が何をするか、および誰が承認する必要があるか |
| [`if`](#if) | 条件 | `true` | 条件が true の間だけルールが適用される |
| [`override`](#override) | リスト | | それぞれ条件付きの別の verdict |
| [`advisory`](#advisory) | 分類器のリスト | | 実行されるが何も決定しない分類器 |
| [`reuse`](#reuse) | 条件またはマップ | 何も保持しない | 差分を変更するプッシュの後も引き続き有効なもの |
| [`findings`](#findings) | マップ | リストなし | 分類器の指摘をクローズできる人 |
| [`use`](#locals-and-use) | `"@name"` のリスト | | キーがルールにコピーされるローカル |
| `mode` | `enforce`、`observe` | ファイルの値 | observe するルールは、ファイルを[適用もカバーも](#how-rules-combine-into-one-verdict)しない |
| `nested` | `overwrite`、`inherit` | ファイルの値 | `inherit` は、下位のポリシーファイルのもとでもルールを有効に保つ |
| `run` | `sequential`、`parallel` | ファイルの値 | ルール自身の分類器を順番に開始するか、同時に開始するか |

### `paths`

各パターンは、`.claude` フォルダを含むディレクトリからのパスとして記述します。移動されたファイルは、古いパスと新しいパスの両方でカウントされます。

| パターン | 一致するもの |
| :- | :- |
| `*` | 1 つのフォルダ内の任意の文字 |
| `**` | 任意の数のフォルダ（ドットフォルダも含む）。`**/*.go` のように、セグメント全体である必要がある |
| `{a,b}`、`[ab]`、`?` | 選択肢、集合のうち 1 文字、任意の 1 文字 |
| `infra/**` | フォルダ内のすべてのファイル。単なる `infra` はその中のどのファイルにも一致せず、`infra/` は拒否される |
| `*.md` | ポリシーファイルの `.claude` フォルダと同じ階層にある Markdown ファイル。任意の深さを対象にするには `**/*.md` と記述する |
| `"!docs/**"` | このルールに限り、該当ファイルを除外する。ルールには `!` のないパターンが少なくとも 1 つ必要 |

### `if`

条件は `true`、`false`、または左側にファクト名か分類器名を置いた 1 つの二重引用符付き文字列（`"pr/files_changed > 50"` など）として記述します。ルールに `if` を指定する場合は、同じパスに対して `if` のない別のルールを残しておいてください。`if` が false の間、それを持つルールは適用されません。ファイルをカバーするルールがあるのに適用されるルールが 1 つもない場合、[Claude Approvals チェックは失敗します](#how-rules-combine-into-one-verdict)。

* **演算子**: `=`、`!=`、`<`、`<=`、`>`、`>=`
* **結合**: 大文字の `AND` と `OR`。両者を混在させる場合は括弧を使用します。
* **リスト**: `pr/authors` と `pr/approved_by` の前には `ANY` または `ALL` を記述します。条件がより緩い verdict につながる場合は `ALL` を使用します。`ANY` では、リストに含まれる作成者が 1 人いるだけで、他の全員のコミットに対してもルールが緩和されてしまいます。より厳しい verdict につながる場合は `ANY` を使用します。`ALL` では、リストに含まれない作成者が 1 人いるだけでルールが無効になってしまいます。空のリストをテストするには、`"pr/approved_by = empty"` のようにどちらも記述しません。
* **引用符**: ログイン名、ブランチパターン、または[人のリスト](#people-lists)内の `!` 付き項目全体は、`"ANY pr/authors = [humans, '!acme/interns']"` のように単一引用符で囲みます。チーム、`bot:` 名、`!` のないファクトは、`"ALL pr/authors = ['ana-acme', acme/payments]"` のように引用符で囲みません。
* **分類器**: `claude/code_review = pass`、`repo/change_risk <= medium`、および[ルールから分類器の回答を読み取る](https://code.claude.com/docs/ja/approvals-classifiers.md#read-a-classifier’s-answer-from-a-rule)に記載されているその他の形式

ファクトはプルリクエスト自体から得られます。

| ファクト | 例 | 保持する内容 |
| :- | :- | :- |
| `pr/files_changed`、`pr/files_added`、`pr/files_removed` | `"pr/files_changed > 50"` | プルリクエスト全体での件数 |
| `pr/diff_lines` | `"pr/diff_lines <= 20"` | プルリクエスト全体で変更された行 |
| `rule/files_changed`、`rule/files_added`、`rule/files_removed` | `"rule/files_changed = pr/files_changed"` | このルールの `paths` に一致するファイルの中での件数 |
| `pr/authors` | `"ALL pr/authors = bot:dependabot"` | コミットを作成またはプッシュしたアカウント、およびプルリクエストを作成したアカウント |
| `pr/opened_by` | `"pr/opened_by = acme/release"` | プルリクエストを作成したアカウント。bot のプルリクエストに他の誰かがプッシュすると、`pr/opened_by = bot:dependabot` に対する上書きは、ルールが求めるものを引き下げなくなる |
| `pr/approved_by` | `"ANY pr/approved_by = acme/security"` | 現在の差分を承認した、書き込み権限を持つ人。作成者と bot は含まれない。`ANY` や `ALL` なしで `= empty` と `!= empty` も使用できる |
| `pr/base` | `"pr/base = 'release/**'"` | プルリクエストの対象ブランチ |

### `verdict`

`verdict` は、Claude が何をするか、および誰が承認する必要があるかを指定します。ルールの `verdict` には `claude` を記述し、`claude` が `blocks` である場合を除き `seats` も記述します。

| フィールド | 値 | 説明 |
| :- | :- | :- |
| `claude` | `approves`、`comments`、`blocks` | `approves`: [適用されるすべてのルールがそう指定し、変更されたすべてのファイルがカバーされている](#how-rules-combine-into-one-verdict)場合、**Claude Approvals** チェックに合格すると Claude は承認レビューを投稿できます。このフィールドはレビューを開始しないため、ルールが分類器を読み取らない場合、Claude はどのレビューも読んでいない変更を承認できます。`comments`: Claude は承認しません。`blocks`: 誰が承認してもチェックは失敗します |
| `seats` | `0` から `16`、または最大 8 個のセットのリスト | 承認する必要がある[人](#how-people’s-approvals-are-counted)の数。数値 `N` は `[{ count: N, from: humans }]` の省略形。`blocks` と併用すると拒否される |
| `max_age` | 整数と `s`、`m`、`h`、`d` のいずれか（`1m` から `83d` まで） | 評価結果が有効な期間。それを過ぎると、チェックは **Results are older than the policy allows** というタイトルで失敗する |

`seats` の各セットには、`1` から `16` までの `count` と、[人のリスト](#people-lists)である `from` を指定します。すべてのセットが満たされる必要があり、1 人が複数のセットのシートを満たすこともできます。

### 人のリスト

人のリストはアカウントを指定します。[`seats`](#verdict) の下のセットの `from` として、または [`findings`](#findings) の下に、1 つの項目として、または角括弧で囲んだリストとして記述します。カウントされるのは、リポジトリへの書き込み権限を持つアカウントだけです。

| 項目 | 意味 |
| :- | :- |
| `humans` | 作成者を含むすべての人。スクリプトやエージェントが操作するユーザーアカウントであるマシンユーザーは人としてカウントされる。Claude のクラウドセッションがコミットに使用する `claude` ユーザーアカウントはカウントされない |
| `bots` | Claude のアプリや `github-actions` を含む、すべての bot と GitHub App |
| `everyone` | `humans` と `bots` を合わせたもの。角括弧なしで単独で記述する |
| `nobody` | 誰もいない。`findings` の下でのみ、単独で記述する |
| `ana-acme` | 1 つのログイン名。条件内では単一引用符で囲む |
| `acme/payments` | リポジトリの GitHub 組織のチーム |
| `bot:dependabot` | `[bot]` サフィックスなしの 1 つの bot。`bot:claude` は Claude のアプリを意味する |
| `pr/authors`、`pr/opened_by` | そのファクトが保持するアカウント |
| `"!pr/authors"` | アカウントを除外する。引用符で囲み（条件内では単一引用符）、`!` のない項目と並べて記述する |

セットの `from` が Claude を含む場合（たとえば `bots`、`everyone`、`bot:claude` を通じて）、かつ適用されるすべてのルールが `approves` を指定している場合、Approvals は Claude が承認する前にそのセットのシートを満たされたものとしてカウントします。その結果、**Claude Approvals** チェックは人の承認なしに合格する可能性があります。

### `override`

上書きは、上書き自身の `if` が true の間、そのルールの verdict を変更します。Approvals は `override` リストを上から読み取り、最初に true となった上書きが適用されます。

| キー | 必須 | 説明 |
| :- | :- | :- |
| `if` | はい | [条件](#if) |
| `verdict` | この 3 つのうち少なくとも 1 つ | 記述した各フィールドがルールのものを置き換える。`seats` は全体として置き換えられる |
| `reuse`、`findings` | この 3 つのうち少なくとも 1 つ | ルールの値全体を置き換える |
| `purpose`、`use` | いいえ | ルールの場合と同じ。ここでは `use` で `verdict` と `findings` をコピーできる |

上書きの `if` が分類器を読み取る場合、**Claude Approvals** チェックは分類器の実行を待ちます。

* **実行がまだ進行中の場合**: チェックは進行中のままです。ルールがまだ選択し得るすべての verdict を承認がすでに満たしている場合は早く完了することがありますが、分類器の `tools` に [`reviewers`](https://code.claude.com/docs/ja/approvals-classifiers#reviewers) が含まれている場合を除きます。サブディレクトリにポリシーファイルがある場合は、[そのような分類器は `advisory` の下にのみ記述してください](#policy-files-in-subdirectories)
* **実行が回答なしで終了した場合**: 読み取りはその上書きで停止し、ルール自身の `verdict` が適用されます。このため、厳しい verdict はルール側に記述してください。
* **回答がないことを検出したい場合**: 回答を読み取る上書きよりも上に、`= error` または `= incomplete` に対する上書きを置きます

ルール自身の `if` では、回答のない比較は、条件の他の部分で結果が確定する場合を除き、誰が承認してもチェックを失敗させます。

### `advisory`

`advisory` の下には、`[claude/code_review, repo/change_risk]` のように分類器名または呼び出しを記述します。ここに記述された `repo/` 分類器は[実行される可能性があり](https://code.claude.com/docs/ja/approvals-classifiers.md#when-a-classifier-runs)、実行ごとに課金されます。`verdict` を持つルールに記述してください。

Code Review の自動レビューを維持するには、レビュー対象にしたいファイルに一致し、`verdict` を持つルールで、`claude/code_review` をここに記述するか、`if` で読み取ってください。

### `reuse`

`reuse` は、差分を変更するプッシュの後も、どの以前の承認と分類器の回答が引き続き有効かを、通常は [`claude/diff`](https://code.claude.com/docs/ja/approvals-classifiers#classifiers-anthropic-provides) を読み取る条件のもとで指定します。

次の例では、`claude/diff` の回答が最大でも `same_intent` であり、新しいコミットに対する Claude のレビューが合格した場合に、人の承認を保持できます。

```yaml theme={null}
# in .claude/approvals.yml, on a rule
    reuse:
      seats: "claude/diff <= same_intent AND claude/code_review = pass"
```

`reuse` は次のいずれかの形式で記述します。

| 形式 | 保持できるもの |
| :- | :- |
| `seats: <condition>` | 人の承認 |
| `<classifier>: <condition>` | その分類器の以前の回答 |
| `reuse: <condition>` | 両方: シートと、ルールが読み取る分類器 |
| `false` | 何も保持しない。上書き内の `unset` はルールの値を削除する |

`reuse` に頼る前に、次のケースを確認してください。

* **ファイルに一致するすべてのルール**: それぞれに `reuse` を記述します
* **`claude/diff` が回答を返さない場合**: それを読み取る条件は何も保持しません
* **却下または強制プッシュの後**: この例では、GitHub が却下した承認は保持されず、強制プッシュ前に与えられた承認も通常は保持されません。`reuse` では、`"claude/diff <= same_intent"` のように、`claude/diff` だけを読み取り他の分類器を読み取らない `seats` 条件のもとでそれらを保持できます。
* **以前の作成者もカウントされる**: `reuse` が `seats` を保持する場合、以前のコミット時点で[作成者のシート](#whether-a-pull-request’s-author-counts)を占めていた人も引き続きカウントされることがあります。そのうち 2 人で、誰も承認しないまま `seats: 2` を満たせてしまいます。これを防ぐには、`"!pr/authors"` でセットから作成者を除外してください。
* **プッシュで変更されなかったファイル**: `reuse` を記述したポリシーファイルでは、承認は他のファイルのみへのプッシュの後も有効なままになることがあります。それらは、どのルールにもカバーされていないファイル、またはそのルールではその人をカウントできなかったファイルである場合があります。GitHub が却下した承認は、通常は有効なままになりません

### `findings`

分類器は指摘をレビュースレッドとして報告でき、条件ではその重大度を `.severity` として読み取れます。`findings` を使用して、スレッドを解決するか [`@claude approvals resolve`](https://code.claude.com/docs/ja/approvals-pull-requests#comment-commands-for-approvals) を使用して、誰が指摘をクローズできるかを指定します。

ルールの `findings` で指摘をクローズできる人が列挙されるまでは、人による解決だけでは `.severity` は下がりません。分類器が自身の指摘をクローズするのにリストは不要です。たとえば Code Review は、後のレビューで修正済みであることが判明した場合に指摘をクローズできます。

次の例では、`acme/leads` チーム（プルリクエストの作成者を除く）が Code Review の指摘をクローズできるようにします。

```yaml theme={null}
# in .claude/approvals.yml, on a rule with no if, beside verdict
    findings:
      resolution:
        claude/code_review: [acme/leads, "!pr/authors"]
```

`findings` の下には、次のいずれかの値を持つ `resolution` を記述します。

| 値 | 意味 |
| :- | :- |
| [人のリスト](#people-lists) | すべての分類器の指摘に対する 1 つのリスト。`resolution: humans` にすると、作成者を含め、書き込み権限を持つ人が指摘をクローズできる |
| 分類器名からリストへのマップ | 分類器ごとのリスト |
| それぞれ `{ if, from }` であるセットのリスト | 各 `if` は `{ if: "finding/severity >= high", from: acme/leads }` のように `finding/severity` を読み取れる。各 `if` が `finding/severity` だけを読み取る場合、`if` が true となる最初のセットが決定する。最後は `if` のないセットで終える |
| `nobody` | 人による解決だけでは指摘はクローズされない。分類器は自身の指摘をクローズできる |

人が指摘をクローズできるようにするには、`if` がなく、指摘のファイルをカバーするルールにリストを記述します。そのルールは、そのファイルについて[決定を行うポリシーファイル](#policy-files-in-subdirectories)に置いてください。解決だけでカウントされるには、そのファイルに適用されるすべてのリストが、解決する人を含んでいる必要があります。

失敗した `claude/code_review` は、プルリクエスト全体に対する 1 つの回答です。`claude/code_review = pass` のようにその回答を比較するルールのもとで、変更されたすべてのファイルを確認してください。

* **すべてのファイルのリストが解決する人を含んでいる場合**: レビューの Important な指摘がすべてクローズされると、新しいレビューなしで `pass` と読み取られることがあります
* **あるファイルのリストが解決する人を含んでいない場合、またはそのファイルが `nobody` であるかリストがない場合**: その人による解決では、レビューは `fail` のままです。そのファイルに対して、その人を含むリストを記述してください。

指摘をクローズしてもコードは変わらないため、人は何も修正しないまま `.severity` を下げ、失敗したレビューを合格させることができます。リストは短く保ってください。

### `locals` と `use`

値を再利用するには、ポリシーファイルの先頭にある `locals` の下で名前を付けます。その後、値を置く場所に `"@name"` と記述するか、`use` でマップ全体をルールにコピーします。

この例では、`payments_owner` が 1 つの人のセットに名前を付け、`strict` が最初のルールで `use` によってコピーされる verdict 全体に名前を付けています。

```yaml theme={null}
# .claude/approvals.yml
version: 1
locals:
  payments_owner: { count: 1, from: [acme/payments, "!pr/authors"] }
  strict:
    verdict: { claude: comments, seats: [{ count: 2, from: humans }, "@payments_owner"] }
rules:
  - purpose: "The payments API takes two people, one of them a payments owner."
    paths: ["services/payments/api/**"]
    use: ["@strict"]
  - purpose: "Everything else takes two people."
    paths: ["**"]
    verdict: { claude: comments, seats: 2 }
```

ローカルが保持できるものと、それを使用できる場所を確認してください。

* **ローカルが保持するもの**: テキスト、数値、`true` または `false`、リスト、または 1 つのマップ
* **`"@name"` を置ける場所**: `paths`、人のリスト、`seats`、`verdict`、`override` の全体、および `paths`、人のリスト、`seats` の 1 つの項目。条件内では、`"pr/files_changed > @many"` のように独自の引用符を付けません。
* **`use` がコピーするもの**: `verdict`、`override`、`if`、`paths`、`reuse`、`advisory`、`findings`。ルール自身が記述したものが優先されます。`verdict`、`findings`、`reuse` マップの中ではキーごとに、その他のキーでは全体として優先されます。

## ルールを 1 つの判定に組み合わせる方法

Approvals は、適用される判定のうち最も厳しいものを採用します。`blocks` は `comments` より優先され、`comments` は `approves` より優先されます。また、すべてのルールの枠が埋まる必要があります。どの判定が適用されるかは、ルールが変更ファイルにマッチするか、適用されるか、カバーするかによって決まります。

* **マッチする**: ルールの `paths` がファイルを含み、どの `"!"` 項目もそれを除外しない場合、ルールは変更ファイルにマッチします
* **適用される**: ルールがマッチし、その [`mode`](#rule-keys) が `enforce` で、その `if` が true であるか存在しない場合、ルールは変更ファイルに適用されます
* **カバーする**: ルールがマッチし、その `mode` が `enforce` で、`verdict` を持つ場合、`if` の内容にかかわらず、ルールは変更ファイルをカバーします

Approvals は、ポリシーファイル、ルール、判定の順に選択します。

1. **ポリシーファイル**: 変更された各ファイルについて、それをカバーし、かつ `verdict` を持つルールが適用される、[最も近い適用モードのポリシーファイル](#policy-files-in-subdirectories)。上位のポリシーファイルにある `nested: inherit` ルールは、そのファイルのルールとしてカウントされます。
2. **ルール**: 変更された各ファイルに適用されるルール。
3. **各ルールの判定**: ルール自身の判定、または最初に true になった [`override`](#override)。
4. **プルリクエストに対する 1 つの判定**: 変更されたすべてのファイルを通じて最も厳しいもの。1 人が複数のルールの枠を埋めることができ、最も短い `max_age` が適用されます。

適用モードのポリシーのもとでは、次のケースは別の結果になります。

| ケース | 結果 |
| :- | :- |
| どのルールも変更ファイルをカバーしない | そのファイルのレビューは誰にも求められません。[保護されたファイル](#protected-files)では、それでも人が必要になることがあります。Claude はプルリクエストを承認しません |
| どのルールも、どの変更ファイルもカバーしない | 通常、チェックは表示されません。GitHub がデフォルトブランチでチェックを必須にしている場合、通常は **Nothing ran, not blocking: no file is covered** というタイトルで neutral として終了します。GitHub はこれをパスとしてカウントします。ルートのポリシーファイルがない場合、ディレクトリのポリシーファイル配下のファイルを一切変更しないプルリクエストにはチェックが表示されないことがあり、必須チェックが待機状態になります |
| ルールが変更ファイルをカバーしているが、どれも適用されない | チェックは失敗し、タイトルは **No rule applies to** で始まります |
| ルールがカバーするパスとカバーしないパスの間でファイルが移動する | チェックは表示されず、Claude は Approvals が実行されなかったことをコメントします。GitHub がチェックを必須にしている場合、プルリクエストは待機状態になります |

これらを避けるには、[スターターポリシー](#how-a-policy-file-works)の 1 つ目のルールのように、`if` のないルートのルールですべてのパスをカバーしてください。

## 人の承認のカウント方法

承認は、書き込み権限を持つアカウントが GitHub のレビューまたは [`@claude approve`](https://code.claude.com/docs/ja/approvals-pull-requests#comment-commands-for-approvals) コメントで行った場合にカウントされます。最新のコミット、または[引き続きカウントされる](#earlier-approvals-after-a-new-push)以前のコミットに対するものである必要があります。

カバーされたファイルを含むプルリクエストで、書き込み権限を持つ人が変更をリクエストしている間は、他に何もチェックを保留していなければ、**Claude Approvals** チェックは通常 **Changes requested** を示します。

### プルリクエストの作成者がカウントされるかどうか

書き込み権限を持つ人がオープンしたプルリクエストでは、作成者は、自分を含むセットで、承認しなくても 1 つの枠を埋めることができます。[フォークや外部コントリビューターからのプルリクエスト](https://code.claude.com/docs/ja/approvals-pull-requests.md#pull-requests-from-forks-and-outside-contributors)を除き、作成者 1 人だけで `seats: 1` を満たせます。`seats: 2` は作成者ともう 1 人で満たせます。

* **作成者の枠を保持する人**: プルリクエストがオープンされた時点のコミットでは、それをオープンした人。その後のプッシュの後は、通常、最新のコミットを作成し、かつプッシュした人。
* **誰も保持しない場合**: たとえば、ある人が作成し別の人がプッシュしたコミットがプッシュされた後など。**Claude Approvals** チェックの概要に理由が示され、プルリクエストをオープンしたのが自分であれば、その後 [`@claude approve`](https://code.claude.com/docs/ja/approvals-pull-requests#comment-commands-for-approvals) とコメントできます。
* **作成者を除外するには**: `seats: [{ count: 1, from: [humans, "!pr/authors"] }]` と記述します。名前を指定した人のセットでは、`count` より少なくとも 1 人多く指定してください。そうしないと、作成者自身のプルリクエストが待機状態になることがあります。[フォークからのプルリクエスト](https://code.claude.com/docs/ja/approvals-pull-requests.md#pull-requests-from-forks-and-outside-contributors)では、`pr/authors` を除外するセットに対してはどの承認もカウントされません。
* **`"!pr/authors"` が基準とするもの**: GitHub が、コミットを作成またはプッシュした、あるいはプルリクエストをオープンしたとして示すアカウント。`Co-authored-by` 行は読み取らず、別のアカウントのもとで行われたエージェントのコミットによって人が作成者になることはありません。
* **bot**: bot は、自身を含むセットで、かつ自身がオープンし最新のコミットをプッシュしたプルリクエストでのみ枠を埋めます
* **マシンユーザー**: `claude` 以外のユーザーアカウントのもとで動作するエージェントは、人と同様に枠を保持し、[保護されたファイル](#protected-files)が必要とする 1 人になることができます。これを除外するには、`[humans, "!acme-ci"]` のように `"!"` でルールのセットからそのログイン名を除外します。保護されたファイルについては、そのセットを、それらを `paths` に指定し `nested: inherit` を付けたルールに置いてください。

### 新しいプッシュの後の以前の承認

プッシュの後、以前の承認がカウントされ続けるかどうかは、プッシュで何が変わったかによって決まります。

* **差分のテキストが同一のまま**: GitHub が却下していない以前の承認はカウントされることがあります。
* **差分のテキストが変わる**: 以前の承認は通常カウントされなくなります。ポリシーが [`reuse`](#reuse) を記述している場合、一部はカウントされ続けることがあります

Approvals は通常、プッシュを評価する際に Claude 自身の承認を[却下するよう GitHub に求め](https://code.claude.com/docs/ja/approvals-github-rules.md#required-reviews-and-codeowners)、Claude は **Claude Approvals** チェックが再びパスした場合にのみ新しいコミットを承認します。

## 保護されたファイル

保護されたファイルとは、ポリシーファイル自体のように、プルリクエストのレビュー方法を制御するファイルを指す Approvals の用語です。これらを編集すると、以降のプルリクエストのレビューが弱まる可能性があります。たとえば、ポリシーファイルを編集すると、必要な人数を減らせてしまいます。

ルールが変更ファイルをカバーしている場合、Approvals は通常、保護されたファイルへの変更に対して[人を求めます](#who-has-to-approve-a-change-to-a-protected-file)。保護されたファイルのリストは組み込みです。

* **ポリシーファイルと分類器ファイル**: すべてのポリシーファイルと、`.claude/classifiers/` 配下のすべて
* **レビュー指示**: リポジトリのルートにある `REVIEW.md`
* **Git ファイル**: `.gitmodules`、`.gitattributes`、シンボリックリンク、サブモジュールポインター
* **コードオーナー**: `CODEOWNERS` という名前のすべてのファイル

他のファイルが保護されていることを前提にしないでください。`.github` フォルダ、`CLAUDE.md`、`AGENTS.md`、`.mcp.json`、`.claude` フォルダの残りの部分など、重要なファイルにはルールを記述してください。

### 保護されたファイルへの変更を誰が承認する必要があるか

Approvals が求める人は、プルリクエストの作成者であってもかまいません。

| プルリクエスト | 承認する必要がある人 |
| :- | :- |
| ルールが変更ファイルをカバーしている | 通常、書き込み権限を持つ人が少なくとも 1 人。その人はプルリクエストの作成者でもよく、bot ではありません |
| どのルールも、どの変更ファイルもカバーしない | 作成者でもよい 1 人が必要な場合と、誰も必要ない場合があります |
| [observe モード](https://code.claude.com/docs/ja/approvals-pull-requests.md#approvals-in-observe-mode)でポリシーファイルまたは分類器ファイルを変更する | 作成者でもよい 1 人が必要な場合があります |

### Claude が保護されたファイルへの変更を承認するタイミング

Claude は、保護されたファイルを変更するプルリクエストを、そのファイルにルールが適用され、かつ適用されるすべてのルールが `approves` を示す場合にのみ承認します。`"**"` に対するルールもカウントされます。ルールの内容にかかわらず、Claude は `.gitattributes` ファイル、シンボリックリンク、サブモジュールポインターを変更するプルリクエストを承認しません。

## ポリシーファイルのサイズと数の上限

各ファイルは次の上限内に収めてください。そうしないと Approvals はファイルを拒否します。

| 対象 | 上限 |
| :- | :- |
| 1 つのポリシーファイル | 448 KiB |
| リポジトリ内のポリシーファイル | 1,024 ファイル、合計 8 MiB。いずれかを超えると、Approvals はどれも読み込みません |
| ファイル内のルール | 512 |
| ファイル内の locals | 512 |
| ルール内のパターン（`"!"` 項目を除く） | 256 |
| 上書き | ルールあたり 16、ファイルあたり 128 |
| 任意のリストの要素 | 1,024 |
| `purpose` | 1,000 文字 |
| 条件 | 4,096 文字、括弧のネストは 8 レベル |
| 数値としての `seats`、またはセットの `count` | 16 |
| 1 つの `seats` 内のセット | 8 |
| `resolution` 配下のセット | 16 |
| 1 つのリスト内、または 1 つの `seats` のすべてのセット内のチーム | 10 |
| 1 つの `use` 配下の名前 | 8 |
| ファイルが指定するカスタム分類器 | 16 |
| ファイルが要求する異なる分類器の実行 | 32 |

プルリクエストにも上限があります。それを超えると、GitHub は **Claude Approvals** チェックを **Action required** として表示します。

* **変更ファイル**: 2,000 以上。チェックのタイトルは **Change too large to evaluate** になります。プルリクエストを分割してください。
* **コミット**: セットが `"!pr/authors"` で作成者を除外している場合に 250 を超えるとき。タイトルは **Too many commits to tell who wrote it** になります。作成者にコミットを 250 以下にスカッシュして強制プッシュしてもらってください。

## 関連リソース

* [Claude Approvals をセットアップする](https://code.claude.com/docs/ja/approvals-setup.md): observe モードをオンにし、ポリシーを適用し、**Claude Approvals** チェックを必須にします
* [Claude Approvals のトラブルシューティング](https://code.claude.com/docs/ja/approvals-troubleshooting.md): チェックが拒否するポリシーファイルを修正します
* [Claude Approvals の分類器](https://code.claude.com/docs/ja/approvals-classifiers.md): 条件が読み取れる分類器と、独自の分類器を定義する方法
