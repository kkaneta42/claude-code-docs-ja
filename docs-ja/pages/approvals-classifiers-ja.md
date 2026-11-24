> ## Documentation Index
> Fetch the complete documentation index at: https://code.claude.com/docs/llms.txt
> Use this file to discover all available pages before exploring further.

# Claude Approvals の分類器

> Claude Approvals のルールを、Code Review の回答やユーザーが定義した質問に依存させます。分類器を追加し、その回答を読み取り、実行にかかるコストを制限します。

[Claude Approvals](https://code.claude.com/docs/ja/approvals.md) では、[ポリシーファイル](https://code.claude.com/docs/ja/approvals-policy.md)内のルールによって、プルリクエストを誰が承認する必要があるかが決まります。分類器を使うと、Code Review に合格したかどうかや変更のリスクの高さなど、変更についての判断にルールを依存させることができます。たとえば、ルールで 2 人を求めつつ、分類器が変更を低リスクと評価した場合には 1 人だけを求めることができます。

ルールは、パス、ファクト、分類器に基づいて判断できます。

* **パス**: プルリクエストがどのファイルを変更するか
* **[ファクト](https://code.claude.com/docs/ja/approvals-policy.md#if)**: 変更された行数や作成者など、プルリクエスト自体の詳細
* **分類器**: 変更に関する質問への回答。パスやファクトでは表現できないことに使用します

Claude Approvals は、Team プランおよび Enterprise プランの組織向けに[パブリックベータ](https://code.claude.com/docs/ja/approvals.md#availability)として提供されています。

## 分類器の仕組み

分類器には、名前、質問、そして返すことができる回答があります。その回答は、次の手順でルールに届きます。

1. **分類器を選択または定義する**: `claude/code_review` と `claude/diff` は [Claude Approvals に付属しています](#classifiers-anthropic-provides)。カスタム分類器は、デフォルトブランチ上のリポジトリ内にあるフォルダー `.claude/classifiers/<name>/` です
2. **ルールで名前を指定する**: ポリシーファイル `.claude/approvals.yml` 内のルールの条件に、分類器の名前を記述します。フォルダー `change_risk` にあるカスタム分類器の場合、名前は `"repo/change_risk = low"` のように `repo/change_risk` になります
3. **Approvals がプルリクエストでそれを実行する**: たとえば、プルリクエストがレビュー可能な状態で開かれ、ルールに一致するファイルを変更した場合です。[分類器が実行されるタイミング](#when-a-classifier-runs)を参照してください。モデルを呼び出す各実行は、組織の使用クレジットに[課金](#what-a-classifier-run-costs)されます
4. **ルールが回答を使用する**: 回答は、誰が承認する必要があるかの判断に使われます。回答はプルリクエスト上の Claude のコメントの **Classifier results** の下に表示されます。ただし、[`reuse`](https://code.claude.com/docs/ja/approvals-policy#reuse) 条件がその回答を読み取る場合は表示されません

## 分類器の定義の例

カスタム分類器は、`def.yml` という名前のファイルで定義します。このファイルには、モデルへの質問を `prompt` に、モデルが選択できる回答を `outputs` に記述します。

この例では、`change_risk` という名前の分類器を定義しています。その `prompt` は変更のリスクの高さを評価するようモデルに求め、その `outputs` によってモデルは `low`、`medium`、`high` のいずれかで回答できます。

```yaml theme={null}
# .claude/classifiers/change_risk/def.yml
version: 1
description: "How risky is this change to ship?"
model: opus
prompt: |
  Rate how risky this change is to ship.
  high: it touches sign-in, billing or a data migration.
  medium: it changes behavior a user can see.
  low: anything else.
  When two ratings fit, pick the higher.
outputs:
  risk: { type: ordinal, values: [low, medium, high] }
```

例の各キーは、それぞれ 1 つの役割を担います。

| キー | この例での内容 |
| :- | :- |
| `version` | 形式のバージョン、`1` |
| `description` | 分類器が何を尋ねるかを説明する 1 行 |
| `model` | 回答する Claude モデル。ここでは最新の Opus モデル |
| `prompt` | 質問。各評価の意味と、2 つが当てはまる場合にどちらを選ぶかを記述しています |
| `outputs` | モデルが選択する回答。この分類器には出力が 1 つ (`risk`) あり、その `values` は最小から最大の順に並んでいます |

定義では `inputs`、`tools`、`budget` も設定できます。[分類器の定義ファイルのキー](#classifier-definition-file-keys)を参照してください。

### 例の評価をルールで使用する

分類器の名前はフォルダー名から付けられます。この例は `.claude/classifiers/change_risk/def.yml` に保存されているため、ポリシーファイルのルールでは `repo/change_risk` と記述します。

評価を使用するには、ルールの条件でそれを値と比較します。たとえば、`if: "repo/change_risk = low"` は、モデルが `low` と回答した場合に真になります。その条件下で求める人数を減らすルールについては、[ルールから分類器の回答を読み取る](#read-a-classifier’s-answer-from-a-rule)を参照してください。

## Anthropic が提供する分類器

Claude Approvals には、事前構築済みの分類器 `claude/code_review` と `claude/diff` が付属しています。いずれかを使用するには、ルールの条件にその名前を記述します。

### `claude/code_review`

`claude/code_review` は、[Code Review](https://code.claude.com/docs/ja/code-review.md) に合格したかどうかをルールに伝えます。たとえば、`if: "claude/code_review = pass"` は、回答が `pass` である間は真になります。

`claude/code_review` は次のいずれかの回答を返します。

| 回答 | タイミング |
| :- | :- |
| `pass` | [Important の指摘](https://code.claude.com/docs/ja/code-review-pull-requests.md#severity-levels)が未解決のまま残っていない状態でレビューが完了した |
| `fail` | Important の指摘が未解決のまま残った状態でレビューが完了した |

これは任意の条件で読み取ることも、[`advisory`](https://code.claude.com/docs/ja/approvals-policy#advisory) の下に記載することもできます。

* **未解決の指摘の重大度を読み取るには**: `claude/code_review.severity` と記述します。値は `none`、`minimal`、`high` のいずれかです
* **`fail` を `pass` に変更できる人を指定するには**: ポリシーの [`findings`](https://code.claude.com/docs/ja/approvals-policy#findings) リストにその人を指定します。指定された人は Important の指摘をクローズすることでこれを行います

### `claude/diff`

`claude/diff` は、承認または以前の回答以降にプルリクエストがどの程度変更されたかをルールに伝えます。回答は `trivial`、`same_intent`、`different` のいずれかです。

これは [`reuse`](https://code.claude.com/docs/ja/approvals-policy#reuse) の下の条件で読み取ります。`reuse` は、プッシュ後に何が引き続き有効かを指定します。

## カスタム分類器を追加する

カスタム分類器では、プルリクエストに関する質問を記述し、Claude モデルがそれに回答します。分類器をリポジトリ内のファイルで定義し、ルールでその名前を指定します。

1. **分類器を定義する**: `.claude/classifiers/` の下に、小文字、数字、`_` で名前を付けたフォルダーを作成します。その中に、質問と選択肢となる回答を記述した [`def.yml`](#classifier-definition-file-keys) を保存します。ルールでは、フォルダー `change_risk` を `repo/change_risk` と記述します。
2. **`advisory` の下に名前を指定する**: ルートの `.claude/approvals.yml` で、`verdict` を持ち、かつ `paths` が判断させたいファイルに一致するルールを選び、そのルールの [`advisory`](https://code.claude.com/docs/ja/approvals-policy#advisory) の下に分類器を記載します。`advisory` の下では、分類器は実行され、[課金されます](#what-a-classifier-run-costs)が、何も決定しません。
3. **両方のファイルをマージする**: 両方を含む 1 つのプルリクエストを開くと、Claude がプルリクエストにコメントします。編集したルールが強制されている場合は、「rules still hold on these files」という警告が表示されますが、これはマージをブロックしません。そのコメントの **Policy files in this change** セクションに拒否が報告されていなければ、プルリクエストをマージします。
4. **回答を読む**: それらのファイルを変更するプルリクエストを開き、Claude のコメントで[回答を探します](#when-a-classifier’s-answer-appears)。
5. **ルールを回答に依存させる**: 回答を信頼できるようになったら、[ルールから回答を読み取ります](#read-a-classifier’s-answer-from-a-rule)。

### 分類器の回答が表示されるタイミング

分類器の定義と、その分類器を指定するルールをマージしたら、5 分待ちます。その後、ドラフトではなく、かつそのルールの `paths` に一致するファイルを変更するプルリクエストを開きます。次のいずれかの場所で、分類器の行を探します。

* **Claude のコメント**: **Classifier results** の下
* **Claude Approvals チェックの概要**: **Advisory classifiers (not counted toward this verdict)** の下

最初、その行には「no result recorded yet」と表示されます。実行には最大 10 分かかることがあり、分類器の `def.yml` でより長い[時間制限](#budget)が設定されている場合はさらに長くかかります。強制されているルールの下では、実行が終了してもその行はそのままです。

回答は、Approvals が次にプルリクエストを評価するとき、たとえば誰かがプルリクエストを承認したり変更を要求したりしたときに表示されます。その後、行にはたとえば「`repo/change_risk`: reported `low` (advisory)」と表示されます。

* **行にまだ結果が表示されない場合**: 実行の時間制限が過ぎるまで待ってから、誰かにプルリクエストを承認するか変更を要求してもらいます
* **分類器の行がない場合**: 分類器を指定しているルールに `verdict` があること、およびその `paths` が変更したファイルに一致することを確認します

## ルールから分類器の回答を読み取る

ルールを分類器の回答に依存させるには、条件に分類器の名前を記述します。条件とは、ルール自体の `if`、または[上書き](https://code.claude.com/docs/ja/approvals-policy.md#override)の `if` です。`repo/change_risk` が `advisory` の下で適切に回答するようになったら、その名前を上書きの `if` に移します。

厳格な判定はルール自体に残しておきます。[実行が回答を返さなかった場合](#what-a-rule-sees-when-a-classifier-run-gives-no-answer)には、ルールの判定が適用されるためです。

このルールは 2 人を求め、`repo/change_risk` が `low` と回答している間は 1 人を求めます。

```yaml theme={null}
# .claude/approvals.yml
version: 1
rules:
  - purpose: "Two people. One is enough when the risk is low."
    paths: ["**"]
    verdict: { claude: comments, seats: 2 }
    override:
      - { if: "repo/change_risk = low", verdict: { claude: comments, seats: 1 } }
```

### 条件で分類器を読み取る方法

条件では、次の形式で分類器を読み取ることができます。

| 形式 | 例 | 読み取る内容 |
| :- | :- | :- |
| 名前のみ | `"repo/change_risk <= medium"` | 唯一の出力 |
| `.output` | `"repo/api_review.breaking = yes"` | 名前で指定した 1 つの出力。分類器の定義に複数の出力がある場合は必須です |
| `.severity` | `"repo/api_review.severity >= high"` | 最も重大な未解決の指摘。値は `none`、`minimal`、`low`、`medium`、`high`、`critical` のいずれかです。`tools` に `findings` が必要です |
| `(input=value)` | `"claude/code_review(level=deep) = pass"` | その入力による実行。Code Review の `level` は `quick`、`standard`、`deep` のいずれかです |
| `= error`、`= incomplete` | `"repo/change_risk = error"` | 実行が回答なしでどのように終了したか |

## 分類器の定義ファイルのキー

分類器の定義は `def.yml` に記述します。ファイルサイズは最大 64 KiB です。ファイル全体の例については、[分類器の定義の例](#example-classifier-definition)を参照してください。

`def.yml` には次のキーを記述できます。

| キー | 必須 | 値 |
| :- | :- | :- |
| `version` | はい | `1`（数値のまま） |
| `description` | はい | 1 行、最大 1,000 文字 |
| `model` | はい | `opus` や `sonnet` などの小文字のモデルファミリー、または[モデルの概要](https://platform.claude.com/docs/en/about-claude/models/overview)にある一般提供モデルの正確な Claude API ID。モデルは [auto モードをサポート](https://code.claude.com/docs/ja/permission-modes.md#eliminate-prompts-with-auto-mode)している必要があります |
| `prompt` | これか `prompt.md` のいずれか | 質問。長い場合は、`def.yml` と同じ場所に最大 512 KiB の `prompt.md` を保存します |
| [`outputs`](#outputs) | いいえ | 出力名とその型および値のマップ |
| [`inputs`](#inputs) | いいえ | ルールが設定できる入力名のマップ |
| [`tools`](#tools) | いいえ | リスト |
| [`budget`](#budget) | いいえ | `{ time, cost }` |

モデルファミリーを指定した場合、分類器はそのファミリーの最新モデルを使用するため、プルリクエストなしでコストや回答が変わる可能性があります。正確な ID を指定した場合、そのモデルが廃止されると分類器は読み込まれなくなります。組織の許可モデルリストはこれらの実行にも適用されます。

### `outputs`

各出力に `type` を指定し、名前と値は小文字、数字、`_` で記述します。出力に `severity` という名前を付けないでください。また、値として `true`、`false`、`error`、`incomplete`、`complete` を使用しないでください。`"yes"` と `"no"` は引用符で囲みます。

| `type` | 追加で必要なもの | 条件での[演算子](https://code.claude.com/docs/ja/approvals-policy.md#if) |
| :- | :- | :- |
| `criteria` | `values`（単語のリスト） | `=`、`!=` |
| `ordinal` | `values`（最小のものを先頭に） | 6 つすべて |
| `numeric` | `min` と `max`（整数） | 6 つすべて |

### `inputs`

入力とは、ルールが実行に対して設定できる値です。各入力を `def.yml` の `inputs` の下で定義し、`repo/change_risk(rigor=thorough)` のように、ルールから分類器の名前の後の括弧内で設定します。`rigor: { values: [quick, thorough], merge: right, default: quick }` のように、各入力に `default` と、`values` または `min` と `max` のいずれかを指定します。各値によって何が変わるかをプロンプトに記述してください。

入力の `merge` は、1 つのプルリクエストに対して複数のルールが異なる値を求めた場合に何が起こるかを指定します。

| `merge` | 実行される内容 |
| :- | :- |
| `left`、`right` | `values` 内でより前または後ろにある単語で 1 回実行 |
| `min`、`max` | より小さい数値またはより大きい数値で 1 回実行 |
| `list` | 求められたすべての単語で 1 回実行 |
| 省略 | 値ごとに個別に課金される実行 |

### `tools`

`tools` の下にエントリを記載すると、実行でできることが増えます。

| エントリ | 実行でできること | 制限 |
| :- | :- | :- |
| `findings` | プルリクエストのレビュースレッドの一部を読み取り、指摘を新規として報告し、自身の指摘を解決または再オープンする | 未解決スレッド 16 件 |
| `comment` | コメントを 1 件投稿する | 5,000 文字 |
| `code` | 差分以外のファイルを読み取る | 読み取り専用 |
| `labels` | リポジトリに既存のラベルを追加し、自身が追加したラベルを削除する | ラベル 8 個。名前が `approvals:` または `claude-` で始まるものは不可 |
| `reviewers` | レビュアーを追加し、自身が追加したレビュアーを削除する | レビュアー 8 人 |

Approvals は、observe モードや一部のプルリクエストでは、実行の `tools` の一部を制限します。

* **observe モードの場合**: 実行は `tools` のうち `findings` と `code` のみを保持します。Approvals は自身のコメントに指摘を一覧表示でき、新しいレビュースレッドは開きません。これは、ポリシーファイル、または分類器を指定し変更されたファイルに一致するすべてのルールが [`mode: observe`](https://code.claude.com/docs/ja/approvals-policy#rule-keys) を指定している間適用されます。
* **一部のプルリクエストの場合**: 実行はコメント、ラベル、レビュースレッド、GitHub のレビューリクエストを追加しません。例としては、フォークからのプルリクエストや、作成者に書き込み権限がないプルリクエストがあります

#### `labels`

ラベルによってマージ、デプロイ、ワークフローが制御されている場合は、`labels` を付与しないでください。実行が追加するラベルはプルリクエスト上の実際のラベルであり、ラベルを読み取るものはすべてそれに基づいて動作する可能性があります。

#### `reviewers`

誰を追加するかを、ログイン名でプロンプトに記述します。[適用される](https://code.claude.com/docs/ja/approvals-policy.md#how-rules-combine-into-one-verdict)ルールが[分類器の回答を読み取る](#read-a-classifier’s-answer-from-a-rule)場合、**Claude Approvals** チェックは [`seats`](https://code.claude.com/docs/ja/approvals-policy#verdict) に加えて、それらの人の承認を待つことがあります。書き込み権限を持つ人を指定してください。サブディレクトリにポリシーファイルがある場合は、[分類器を `advisory` の下にのみ記載します](https://code.claude.com/docs/ja/approvals-policy#policy-files-in-subdirectories)。

承認できないレビュアーを外すには、まずプロンプトにその人の名前が記載されている場合はプロンプトへの変更をマージし、5 分待ちます。その後、プルリクエストに [`@claude approvals rerun`](https://code.claude.com/docs/ja/approvals-pull-requests#comment-commands-for-approvals) とコメントします。

### `budget`

`budget: { time: 300, cost: 5 }` のように、`budget` の下に `time`、`cost`、またはその両方を設定します。いずれかの制限に達した実行は停止し、条件は `incomplete` を読み取ります。最大値を超える値を指定した場合、実行には最大値が適用され、Approvals が警告します。

| キー | 単位 | デフォルト | 最大値 |
| :- | :- | :- | :- |
| `time` | 秒（整数） | `600` | `3600` |
| `cost` | 米ドル（整数） | `10` | `10` |

Approvals は推定支出額が `cost` に達した時点で実行を停止しますが、請求額はそれより高くなる場合があります。\$5 未満では、大きなプルリクエストでの実行が回答する前に停止することがあります。

## 分類器の実行の動作

ルールの結果は、分類器がいつ実行されるか、実行で何を読み取れるか、回答が返されなかった場合に何が起こるかによって変わることがあります。

### 分類器が実行されるタイミング

`repo/` 分類器は、一致するルールでその名前を指定した場合にのみ、プルリクエストで実行されます。指定場所は、`if`、上書きの `if`、`reuse` 条件、または `advisory` です。[フォークからのプルリクエスト](https://code.claude.com/docs/ja/approvals-pull-requests.md#pull-requests-from-forks-and-outside-contributors)では、メンテナーがコミットを信頼できると確認するまで `repo/` 分類器は開始されません。`claude/code_review` については、[Approvals がレビューを開始するタイミング](https://code.claude.com/docs/ja/approvals-setup.md#what-approvals-costs)を参照してください。

* **実行を開始できるもの**: プルリクエストがレビュー可能な状態で開かれる、レビュー可能としてマークされる、または再オープンされる場合です。差分を変更するプッシュ、ベースブランチの変更、[Claude Approvals チェックの再実行](https://code.claude.com/docs/ja/approvals-pull-requests.md#comment-commands-for-approvals)によっても開始されることがあります。[ポリシーが observe を停止した](https://code.claude.com/docs/ja/approvals-setup.md#enforce-your-policy-and-require-claude-approvals)後、Approvals は一部の未解決のプルリクエストを自動的に評価し、それによって実行が開始されることがあります。
* **どの定義が実行されるか**: デフォルトブランチにある定義とプロンプトのコピーです。プルリクエスト自体のコピーは実行されません。このフォルダーのファイルは[保護されたファイル](https://code.claude.com/docs/ja/approvals-policy.md#protected-files)です。
* **定義を変更すると以前の回答は無効になる**: `def.yml` または `prompt.md` への編集は、デフォルトブランチに反映された時点で有効になります。未解決のプルリクエストは、プッシュや再実行などの次の評価までチェックを保持します。その評価で以前の回答は破棄され、分類器が再度実行されることがあります。
* **差分を変更するプッシュの後**: [`reuse`](https://code.claude.com/docs/ja/approvals-policy#reuse) が保持する場合、またはプッシュが分類器を指定していないルールの対象ファイルのみを変更する場合は、以前の回答が引き続き有効になることがあります
* **順序**: デフォルトの `run: sequential` では、上書きの分類器は通常、それより上にある上書きを待ちます。`run: parallel` では、すべてが同時に開始できますが、どの判定にも必要なかった実行が課金される可能性があります。

### 分類器の実行で読み取れるものと変更できるもの

`repo/` 分類器の実行は、Anthropic のインフラストラクチャ上の Claude Code クラウドセッションです。組織がセルフホストのコンピューティングを必須としている場合、条件はその実行の回答の代わりに `error` を読み取ります。

セッションが何を読み取れて、何を変更できるかを確認してください。

* **読み取れるもの**: プルリクエストのタイトル、説明、ラベル、作成者、変更されたファイル、差分、承認、必須レビュアー、分類器の以前の実行、ポリシーファイル、`.claude/classifiers/` 以下のファイル。`tools` に `findings` がある場合は、レビュースレッドの一部も読み取ります
* **`code` で追加されるもの**: プルリクエストの head とデフォルトブランチにあるファイルの読み取り専用コピー。ただし、`CLAUDE.md`、`AGENTS.md`、`.claude/`、`.mcp.json`、名前が `.pdf` で終わるファイルなど、一部のファイルは除きます
* **変更できるもの**: セッションの GitHub アクセスは読み取り専用です。[`tools`](#tools) に書き込みを行うエントリが記載されている場合、実行は要求内容を記録し、Approvals が実行後にそれを実施することがあります。

実行はプルリクエストの作成者が書いたテキストを読み取るため、そのテキストが分類器の回答を誘導しようとする可能性があります。重要なパスについては、分類器を読み取らないルールで[人を求めてください](https://code.claude.com/docs/ja/approvals-github-rules.md#ask-for-a-person-who-isn’t-an-author)。

### 分類器の実行が回答を返さなかった場合にルールが参照する値

実行が回答なしで終了した場合、条件は通常、次のいずれかの値を読み取ります。

| 条件が読み取る値 | タイミング |
| :- | :- |
| `incomplete` | 実行が開始され、回答なしで終了した |
| `error` | 実行を開始できなかった、中断された、またはチェックの待機時間を超えた |

どちらの場合も、回答を必要とする上書きは、ルール自体の `verdict` をそのまま適用します。回答を必要とするルール自体の `if` は、**A classifier had no result** というタイトルで **Claude Approvals** チェックを失敗させます。

別の判定を選択するには、回答を読み取る上書きよりも上に、`= error` または `= incomplete` に対する[上書き](https://code.claude.com/docs/ja/approvals-policy.md#override)を配置します。ルール自体の `if` で回答が得られなかった場合、上書きで別の判定を選択することはできません。分類器を読み取る比較を、ルールの `if` から上書きに移してください。

## 分類器の実行にかかるコスト

モデルを呼び出す実行は、トークンに基づいて組織の使用クレジットに課金されます。

| 分類器 | 課金対象 |
| :- | :- |
| カスタム分類器 `repo/<name>` | 各実行。observe モードでの実行、`advisory` の下での実行、回答なしで終了した実行も含まれます。エラー後、Approvals は実行を自動的に複数回再開することがあり、それらの各実行が課金されます |
| `claude/diff` | モデルを呼び出す各回答 |
| `claude/code_review` | [Code Review](https://code.claude.com/docs/ja/code-review-costs.md) として課金 |

### カスタム分類器のコストを制限する

1 回の実行に上限を設ける、月ごとに上限を設ける、低コストのモデルを選ぶ、実行回数を減らす、といった方法があります。

* **1 回の実行に上限を設ける**: 分類器の `def.yml` に `budget: { cost: 5 }` を追加します。Approvals は推定支出額がその米ドル額に達した時点で実行を停止しますが、請求額はそれより高くなる場合があります。[`budget`](#budget) がない場合、上限は \$10 です
* **月ごとに上限を設ける**: [**Organization settings > Usage**](https://claude.ai/admin-settings/usage) で[分類器の実行の支出上限](https://code.claude.com/docs/ja/approvals-setup.md#limit-what-a-policy-costs)を設定します。これには Owner ロールが必要です
* **低コストのモデルを選ぶ**: `def.yml` で `model` を、たとえば `opus` から `sonnet` に変更します
* **実行回数を減らす**: `def.yml` と `prompt.md` への編集を 1 つのプルリクエストにまとめます。編集がマージされるたびに、各未解決のプルリクエストの次の評価で分類器が再度実行されます

## 関連リソース

* [Claude Approvals ポリシーファイルリファレンス](https://code.claude.com/docs/ja/approvals-policy.md): 条件、上書き、`reuse`、`findings`
* [Claude Approvals をセットアップする](https://code.claude.com/docs/ja/approvals-setup.md): observe モード、強制、支出上限
* [Claude Approvals のトラブルシューティング](https://code.claude.com/docs/ja/approvals-troubleshooting.md): 分類器が回答を返さない場合
* [データの使用](https://code.claude.com/docs/ja/data-usage.md): Anthropic が Claude Code のデータをどのように扱うか
