> ## Documentation Index
> Fetch the complete documentation index at: https://code.claude.com/docs/llms.txt
> Use this file to discover all available pages before exploring further.

# Claude Code のベストプラクティス

> Claude Code をさらに活用するために、Claude に見えないことを伝え、実行できるチェックを与え、例外を許さないルールを強制します。

Claude Code は、ほとんどの場合、新しいセッションで最初に送るシンプルなプロンプトだけで、ユーザー側の設定なしに正しく動作するよう作られています。

例えば：

* 各コマンドを逐一承認しなくても安全に実行できるよう、新しいターミナルおよび VS Code セッションは [auto モード](https://code.claude.com/docs/ja/permission-modes.md#eliminate-prompts-with-auto-mode)で開始します。このモードでは、リスクのある操作は実行前に分類器がレビューします。
* 独立した作業を並列で進めながらメインの会話を集中した状態に保つため、Claude はサブエージェントに委譲し、必要なときだけ確認を求めます。
* ユーザーが管理しなくても長いセッションを続けられるよう、コンテキストウィンドウがいっぱいになる前に、会話が自動でコンテキスト圧縮されます。

このページでは、デフォルトだけでは不十分な場合に何をすべきかを説明します。これは通常、Claude がコードだけからは把握できない知識、ルール、制約がプロジェクトにある場合に起こります：

* 誰かの頭の中にしかないデプロイ手順
* 決して読み取ってはいけないファイル
* 何かを完了とみなす前に必ず通過しなければならないチェック
* 超えてはならない予算

どのデフォルトも、プロジェクトについてのこうした事柄を知ることはできません。そのため、ここでユーザー側が少し設定を行うことが効果を発揮します。

セッションが期待どおりに進まない場合、原因はほぼ必ず次のいずれかです：

* Claude が想定と違うものを作った、あるいは毎回のセッション開始時に同じ事実を再発見しなければならない。リポジトリを読んでも得られない情報が欠けています。[Claude に見えないことを伝える](#tell-claude-what-it-cant-see)を参照してください。
* Claude が完了したと言ったのに、実際には完全には終わっていなかった。通常は、自分の作業を確認する手段がなかったことが原因です。[Claude に実行できるチェックを与える](#give-claude-a-check-to-run)を参照してください。
* このリポジトリで決して起きてはならないことを Claude が行った、あるいは必ず行うべき手順を飛ばした。プロンプトだけではそのどちらも保証できません。[例外を許さないルールを強制する](#enforce-the-rules-that-cant-have-exceptions)を参照してください。
* Claude は正しく仕上げたが、タスクに見合わないほどの時間、トークン、権限プロンプトを費やした。[デフォルトを変更する](#change-a-default)を参照してください。

[Claude を無人で実行する](#let-claude-run-without-you)では同じ 4 つのポイントを無人実行に適用し、[やめてもよいこと](#what-you-can-stop-doing)では現在のモデルによって不要になったアドバイスを挙げています。

> [!NOTE]
>
> チーム全体のセットアップは別のページにあります：[組織向けに Claude Code をセットアップする](https://code.claude.com/docs/ja/admin-setup.md)。

## 決定論的な指示と非決定論的な指示

Claude Code に与える指示は、すべて次のいずれかです：

1. 非決定論的：ユーザーが指示を書き、Claude（モデル）がそれを読みます。プロンプト、`CLAUDE.md`、スキルなどがこれに当たります。モデルはその情報をどう扱うかを自分で判断します。通常はコマンドに従いますし、現在のモデルは多くのコンテキストがなくても意図をよく理解しますが、指示に従うという*保証*はありません。実行しないと判断することも、別のことをすることもあり得ます。
2. 決定論的：ユーザーが指示を設定し、Claude Code（ハーネス）がそれを必ず実行*しなければなりません*。フック、拒否ルール、管理設定などがこれに当たります。モデルが何をすると判断したかにかかわらず、Claude Code は毎回これを適用します。

Claude Code のほとんどの機能には、両方の形式があります：

| | 非決定論的（Claude が判断） | 決定論的（Claude Code が強制） |
| :- | :- | :- |
| 何をするか | プロンプト、`CLAUDE.md`、Claude が自ら使うスキル | フック、およびユーザーだけが開始できるスキル |
| 何に触れられるか | auto モードの分類器 | 拒否ルール、[strict モード](https://code.claude.com/docs/ja/sandboxing.md#turn-off-the-retry-with-strict-sandbox-mode)のサンドボックス、管理設定 |
| いつ完了とするか | 証拠の要求、`/goal`、`/code-review` | テスト、型チェック、`Stop` フック、CI |
| どれだけ費やすか | effort レベル、Claude 自身のペース | `-p` と併用する `--max-turns` または [`--max-budget-usd`](https://code.claude.com/docs/ja/cli-reference)、設定した[支出上限](https://code.claude.com/docs/ja/costs.md) |
| 最終判断を下すのは誰か | Claude による作業内容の要約 | ブランチ保護、マージを承認する人 |

ほとんどの場合、判断は Claude に任せるのが望ましいです。ほぼすべてのガイドラインには例外があり、現在のモデルは目の前のコードを読み、ガイドラインが状況に合うかどうかを判断するのが得意です。実際のコードを目の前にしている Claude のほうが、事前に書いたルールよりもうまく判断できることが多いのです。

決定論的な方式は、モデルの判断にかかわらず、特定のことが*必ず*起きる（あるいは決して起きない）ようにしたい場合のためのものです。大げさなものである必要はありません。本番デプロイや他人の作業を上書きする force push のような重大なことは、auto モードがすでに[ブロックしています](https://code.claude.com/docs/ja/permission-modes.md#what-the-classifier-blocks-by-default)。通常は*自分の*プロジェクト固有のことで、いくらでもニッチなもので構いません：

* `src/gen/` にある生成されたクライアントは決して編集しない
* ファイルを作成した後は必ずライセンスヘッダースクリプトを実行する

これらはどちらも `CLAUDE.md` やプロンプトに 1 行書いておくこともでき、Claude はほぼ毎回それに従うでしょう。しかし、どれほど強い言葉で書いても、特定のターンでその行に従うかどうかは Claude の判断に委ねられたままです。

> [!TIP]
>
> `CLAUDE.md` の行に強調を加え続けても Claude が見落とすなら、その行はフックにすべきというサインです。逆も成り立ちます。単なる好みにすぎないものにフックを設定しているなら、それを削除して Claude に判断させましょう。

## Claude に見えないことを伝える

> [!TIP]
>
> Claude がリポジトリを読んでも見つけられないこと、またはそうしなければ毎セッション再発見に時間を費やすことになることだけを書き留めてください。

Claude はすべてのタスクをコードを読むことから始め、現在のモデルはこれが*非常に*得意です。ファイル構成、規約、テストフレームワーク、既存コンポーネントの作り方を見つけ出し、たいていはユーザーが説明するよりも速く把握します。つまり、Claude のために書き留めたくなることの大半は、Claude がすでに知っているということです。

見つけられないのは、一度もリポジトリに入ったことのない情報です：

* チームが会議で決めたこと
* 1 人の頭の中にしかないデプロイ手順
* インテグレーションテストに必要な環境変数

また、リポジトリには*ある*ものの、見つけるのに数分かかる情報もあり、Claude は毎回のセッション開始時にその調査をやり直さなければなりません。

Claude のために何かを書き留める前の良いテスト：

1. コードを読めばこれを見つけられるか？
2. 実際に探しに行くか？

両方とも「はい」なら、書かないでおきましょう。

### 具体的なプロンプトを書く

具体的なプロンプトが役立つのも同じ理由で、Claude がまだ持っていない情報を与えるからです。ファイル名を挙げ、症状を説明し、「修正された」状態がどういうものかを最初に伝えれば、たいていは後の修正の手間を 1 回分省けます。

妥当なアプローチが 2 つある場合の好みも同様です。Claude はそれをコードから読み取れないので、どちらを選ぶかにこだわりがあるなら、最初に伝えてください。

| こうではなく | こうする |
| :- | :- |
| *「ログインのバグを修正して」* | *「セッションのタイムアウト後にログインが失敗するとユーザーから報告がある。src/auth/ のトークン更新を確認し、問題を再現する失敗するテストを書いてから修正して」* |
| *「カレンダーウィジェットを追加して」* | *「HotDogWidget.php のパターンに従って、月を選択でき、年単位でページ移動できるカレンダーウィジェットを作って。新しいライブラリは使わない」* |

Claude に必要なものがすでに手元にあるなら、説明するのではなくそれを渡してください：

* ファイル：`@` とパスを入力すると、メッセージに[ファイルの内容を含められます](https://code.claude.com/docs/ja/common-workflows.md#reference-files-and-directories)。
* 画像：デザインやエラーのスクリーンショットをプロンプトに貼り付けます。
* コマンド出力：`cat error.log | claude -p "what's going on here"` のようにシェルからパイプで渡します。

`think step by step` や `be thorough` のようなフレーズは、キーワードではなく通常のプロンプトテキストです。Claude がどれだけ深く考えるかを制御する主な手段は [effort レベル](https://code.claude.com/docs/ja/model-config.md#adjust-effort-level)で、[モデルと effort を変更する](#change-the-model-and-effort)で説明しています。こうした言い回しでも effort 設定の範囲内で Claude を少し後押しすることはできますが、設定を超えて引き上げることはありません。

今でも役立つフレーズの 1 つが `be ambitious` です。Claude はユーザーがどこまで期待しているかを知ることができないため、リクエストを控えめに解釈し、それを満たす最小限のものを作る傾向があります。エッジケースに対応し、自然な後続作業も含めた充実版が欲しいときは、そう伝えてください：

```text theme={null}
build the settings page from the mockup. be ambitious: empty and error states, the save flow wired up, keyboard navigation, not just the layout
```

これは考える深さではなく、ユーザーだけが知っているスコープを Claude に伝えるものです。

また、特定の何かを修正するのではなく探索しているときは、`what would you improve in this file?` のような曖昧なプロンプトでもまったく問題ありません。進めながら修正する回数は少し増えますが、それがトレードオフです。

### まず Claude とブレインストーミングする

何が欲しいのかまだはっきりしていないときは、プロンプトを送る前にすべてを詰めておく必要はありません。代わりに Claude にインタビューしてもらいましょう：

```text theme={null}
I want to add rate limiting to the public API but haven't thought it through yet. Interview me until you could write the spec, then write it to SPEC.md.
```

Claude は、まだ決まっていない部分について多肢選択式の質問を返してきます。ユーザー単位かキー単位の制限か、上限を超えたリクエストをどう扱うか、何がスコープ外か、といったことです。回答が仕様としてまとまるまで質問を続けます。

`SPEC.md` ができたら、それをもとに構築するための新しいセッションを開始します。そうすれば、クリーンなコンテキストと書面化された完了の定義から作業を始められます。これは後で[Claude に実行できるチェックを与える](#give-claude-a-check-to-run)でレビュアーに参照させるファイルでもあります。

### CLAUDE.md を短く保つ

Claude Code は [`CLAUDE.md`](https://code.claude.com/docs/ja/memory) をすべてのセッションに読み込みます。つまり、そこに書かれたすべての行が、関連があるかどうかにかかわらず、*すべての*タスクで Claude の注意を少しずつ消費します。だからこそ、このファイルには Claude がコード自体から把握できないことだけを入れておくのが最も効果的です：

* このリポジトリで作業を確認する方法：正確なテスト、型チェック、lint のコマンドと、単一のテストファイルを実行する方法
* コードが誤解を招く箇所：あちこちにあるが新しいコードでは真似してはいけない古いパターンや、使われていないように見えて実は使われているディレクトリ
* リポジトリにない決定事項：チームがどのエラーヘルパーに決めたか、デプロイの仕組み、何にマイグレーションレビューが必要か
* すでに 2 回修正しなければならなかったこと

このテストに合格する `CLAUDE.md` は短く収まります：

```markdown CLAUDE.md theme={null}
# Commands
- Install: pnpm install
- Run one test file: pnpm vitest run path/to/file.test.ts
- Typecheck: pnpm tsc --noEmit

# Conventions
- Use the error helpers in src/lib/errors.ts, never throw raw strings
- src/legacy/ is still live but don't copy its patterns into new code

# Gotchas
- Integration tests need DATABASE_URL set, see .env.example
```

セッション内で `/context` を実行すると、Claude がファイルを読み込んだことを確認できます。

型チェックの行はコマンドだけである点に注目してください。Claude は作業しながら自分の作業を確認できるよう、コマンドを知っている必要があります。Claude が終了する前に型チェックの合格を Claude Code に*強制*させたい場合は、[`Stop` フック](#enforce-the-check-with-a-stop-hook)の出番です。このファイルに `Always typecheck before you finish` のような行を書いても、たいていは機能しますが、毎回ではありません。

ファイルを一から書く必要はありません：

* `/init` はコードベースから初期バージョンを生成します。そこからの作業は主に行を削ることです。[メモリガイド](https://code.claude.com/docs/ja/memory.md#write-effective-instructions)では 200 行未満に抑えることを推奨しています。
* `/doctor` は、Claude が[コードからすでに把握できる](https://code.claude.com/docs/ja/memory.md#my-claude-md-is-too-large)内容について削除を提案します。
* `/doctor prompt-audit` は、古いモデル向けに書かれた指示、存在しなくなったファイルを指している指示、[互いに矛盾する](https://code.claude.com/docs/ja/memory.md#audit-your-instruction-files)指示を指摘します。

個人的な好みは `CLAUDE.md` ではなく `CLAUDE.local.md` に書き、そのファイルを `.gitignore` に追加してリポジトリに含まれないようにします。

> [!NOTE]
>
> `CLAUDE.md` に*書かれている*行を Claude が無視し続ける場合、IMPORTANT を追加してもおそらく解決しません。ファイルが長くなりすぎてその行が埋もれているか、その行が例外を許さないルールであるかのどちらかで、後者の場合は[フック](#enforce-the-rules-that-cant-have-exceptions)にすべきです。

### ルールをコードベースの一部にスコープする

あるルールがコードベースの一部でしか意味を持たない場合は、`paths:` フィルター付きで [`.claude/rules/`](https://code.claude.com/docs/ja/memory#path-specific-rules) に置くと、Claude が実際にその部分で作業しているときだけ読み込まれます。例えば、この `.claude/rules/api.md` は `src/api/` 配下の TypeScript ファイルに対して読み込まれます：

```markdown .claude/rules/api.md theme={null}
---
paths:
  - "src/api/**/*.ts"
---
- Validate request bodies with the zod schemas in src/api/schemas/, don't hand-roll checks
- Every new endpoint needs an entry in openapi.yaml, CI fails without it
```

### チームの手順をスキルにまとめる

より高性能なモデルはエンジニアリングについてより多くを知っていますが、*自分たちの*チームがどのようにリリースを行うか、インシデントランブックに何が書かれているか、API ドキュメントをどう書いてほしいかまでは知りません。こうした知識は[スキル](https://code.claude.com/docs/ja/skills.md)に入れます。スキルとは、`.claude/skills/<name>/SKILL.md` に保存された手順やチームの知識です。

この種のものについては、スキルは `CLAUDE.md` よりもコンテキストへの負担が軽くもあります。Claude が自ら開始できるスキルの場合、Claude はすべてのセッションで名前と説明を目にしますが、[ファイル全体を読む](https://code.claude.com/docs/ja/skills.md#skill-content-lifecycle)のはタスクで必要になったときだけです。スキルに入れた長いリリース手順は、`CLAUDE.md` に入れた場合のように無関係なバグ修正の負担になることはありません。

> [!NOTE]
>
> `CLAUDE.md` のルールはスキルにも当てはまります。Claude が自分で見つけられないことだけを書き留めてください。

実際にリリースを作成するような副作用のあるワークフローには、`disable-model-invocation: true` を追加します。すると Claude は[スキルを自ら開始できなくなり](https://code.claude.com/docs/ja/skills.md#control-who-invokes-a-skill)、ユーザーが自分で `/release` と入力したときだけ実行されます。`.claude/skills/release/SKILL.md` として保存すると、次のようになります：

```markdown .claude/skills/release/SKILL.md theme={null}
---
name: release
description: Cut a new release. Bumps the version, writes the changelog entry, tags it and pushes the tag so CI can publish.
disable-model-invocation: true
---
1. Make sure you're on main with a clean tree. If not, stop and ask.
2. Run `pnpm changeset version` and commit the result.
3. Summarize the PRs merged since the last tag into CHANGELOG.md, one line each, user-facing changes only.
4. Tag `v<new version>` and push the tag. CI publishes from there, never publish from your machine.
```

### Claude に必要なツールを接続する

Claude に見えないものの中には、課題トラッカーやエラーダッシュボードのように、まったく別のシステムにあるものもあります。そのシステムに CLI があれば、たいていはそれが最も簡単な接続方法です。例えば `gh` をインストールしてサインインしておけば、Claude はユーザーの説明なしにプルリクエストを作成し、レビューコメントを読みます。Claude が初めて見る CLI であれば、`--help` を参照させるだけで十分です。

CLI のないシステムには [MCP](https://code.claude.com/docs/ja/mcp.md) があります。シェルからサーバーを追加します：

```bash theme={null}
claude mcp add --transport http notion https://mcp.notion.com/mcp
```

するとセッション内の `/mcp` にサーバーが表示されます。接続されたサーバーは、使用していないときでもツール名と指示をコンテキストに追加するため、そこで[不要なものをオフにする](https://code.claude.com/docs/ja/mcp.md#disable-a-server-without-removing-it)価値があります。

また、型付き言語で作業している場合は、[コードインテリジェンスプラグイン](https://code.claude.com/docs/ja/plugins/code-intelligence.md)を使うと、Claude は定義を探して多くのファイルを読み進める代わりに、定義へ直接ジャンプできます。

## Claude に実行できるチェックを与える

Claude は作業が完了したように見えた時点で停止します。作業が本当に完了*しているか*を教えてくれる実行可能なものが何もなければ、頼りにできるのは「完了したように見える」ことだけです。実際には、ユーザー自身がテストスイートになり、あらゆる間違いはたまたま気付くまで放置されます。

合格か不合格かが返ってくるものを与えれば、Claude はそのループを自分で閉じられます。変更を加え、チェックを実行し、何かが壊れていれば出力を読んで修正し、再びチェックを実行します。

> [!TIP]
>
> 合格か不合格かを返す、Claude が実行できるものを与えてください。それがあれば Claude は自力で作業を続けられ、ユーザーが見守る必要はありません。

Claude が結果を読める限り、チェックはほぼ何でも構いません：

* テストファイル
* ビルドの終了コード
* リンター
* 出力をフィクスチャと比較するスクリプト
* モックアップと並べた[ブラウザのスクリーンショット](https://code.claude.com/docs/ja/chrome.md)

リポジトリにすでにこれらのいずれかがあるなら、`CLAUDE.md` で最も役立つ 1 行は、それを実行するコマンドです。

チェックをどれだけ厳格にするかはユーザー次第です。選択肢は、Claude 自身が判断するものから、Claude Code が強制するものまであります：

* プロンプトで：`run the auth tests after, and keep going until they pass`。満足したかどうかは Claude 自身が判断します。これはどんなタスクでも、今すぐ、設定なしで機能します。
* ゴールとして：[`/goal all tests in tests/auth pass and lint is clean`](https://code.claude.com/docs/ja/goal) は、別のモデルが毎ターン後に会話と照らし合わせてチェックする条件を設定し、Claude はそれが満たされるまで作業を続けます。セッション内で自分でこれが必要になることはまれです。重要になるのは長時間のバックグラウンド実行で、未完了の項目が残っているのに Claude が進捗の要約でターンを終えることがあり、その場合にゴールが Claude を作業に戻します。
* Stop フックとして：[`Stop` フック](https://code.claude.com/docs/ja/hooks#stop)は Claude がターンを終えようとするたびにスクリプトを実行し、スクリプトが終了コード 2 で終了した場合は Claude を作業に戻します。これは Claude Code（ハーネス）によって強制されるため、型チェックが合格するか[ブロック上限](https://code.claude.com/docs/ja/hooks.md#stop-input)に達するまでターンは終了しません。[後述の例](#enforce-the-check-with-a-stop-hook)があります。
* コードを書いていない誰かによって：ターミナルでは、[`/code-review`](https://code.claude.com/docs/ja/code-review-local) が、ユーザーとの会話を一度も見ていない新しいサブエージェントで差分をレビューします。コードを生み出した推論に左右されません。

どの選択肢を使う場合でも、Claude に*証拠*を求めてください。実行したコマンドとその出力、またはスクリーンショットです。「すべてのテストが合格しました」だけではほとんど何もわかりませんし、出力を読むほうが自分でチェックを再実行するより速く済みます。見ていなかったセッションでは、それが唯一の証拠でもあります。

> [!TIP]
>
> Claude が完了したと言ったら、セッション内で [`/verify`](https://code.claude.com/docs/ja/skills#run-and-verify-your-app) を実行することもできます。これは Claude にアプリをビルド・実行させて結果を確認させるもので、テストや型チェックでは見逃す種類の問題を捉えます。

### 仕様に照らしてレビューする

一般的なバグ探しよりも、計画に照らして作業をチェックするレビューが欲しい場合は、レビュープロンプトを自分で書きます：

```text theme={null}
use a subagent to review the rate limiter diff against SPEC.md, check every requirement is implemented and the listed edge cases have tests, report gaps that affect correctness and skip style
```

> [!NOTE]
>
> このプロンプトの `skip style` の部分は省かないでください。問題を見つけるよう求められたレビュアーは、必ず*何か*を見つけます。すべての指摘を修正すると、余計な抽象化レイヤーや、起こり得ないケースのためのテストが増えることになります。

### Stop フックでチェックを強制する

型チェックルールの `Stop` フック版は、`.claude/settings.json` に数行書くだけです。停止をブロックするのは終了コード 2 です。コマンドが stderr に出力した内容は、まだ終了できない理由として Claude に返されます。そのため、コンパイラの出力を stderr にリダイレクトしています：

```json .claude/settings.json theme={null}
{
  "hooks": {
    "Stop": [
      {
        "hooks": [
          { "type": "command", "command": "pnpm tsc --noEmit 1>&2 || exit 2" }
        ]
      }
    ]
  }
}
```

動作を確認するには、型を壊す変更を Claude に依頼してください。Claude は終了する代わりにコンパイラのエラーを受け取り、`tsc` が合格するまで作業を続けます。ツール呼び出しを挟まずにフックが[連続 8 回の停止](https://code.claude.com/docs/ja/hooks.md#stop-input)をブロックした場合、Claude Code は次のブロックを上書きしてターンを終了します。上限を引き上げるには [`CLAUDE_CODE_STOP_HOOK_BLOCK_CAP`](https://code.claude.com/docs/ja/env-vars) を設定します。

## 例外を許さないルールを強制する

> [!TIP]
>
> 毎回必ず起きなければならないことは、フック、拒否ルール、または管理設定にしてください。`CLAUDE.md` はガイドラインのためのもので、Claude はガイドラインが当てはまらないと判断することが許されています。

今 `CLAUDE.md` に書いているかもしれない 3 つのルールを例に取りましょう：`Never read .env`、`Always run the formatter after editing`、`Don't touch the migrations folder`。Claude はほぼ毎回これらに従います。「ほぼ」では不十分な少数のものについては、`CLAUDE.md` から外し、Claude Code（ハーネス）自身が適用する設定に移します。以降、結果はモデルが何を覚えているか、何を判断するかに左右されなくなります。

### フックで手順を強制する

[フック](https://code.claude.com/docs/ja/hooks-guide.md)は、Claude のループ内の決まったポイントでユーザーが用意したものを実行します。ツール呼び出しの前後、Claude が停止しようとするとき、セッションの開始時などです。実行するものは次のいずれかです：

* シェルコマンド（通常のケース）
* HTTP エンドポイントへの POST
* MCP サーバーのいずれかでのツール呼び出し
* モデルに判断させる [`prompt` または `agent` フック](https://code.claude.com/docs/ja/hooks#hook-handler-fields)

`prompt` または `agent` フックは*別のモデル*に判断を求めるため、これも決定論的ではありません。本当の意味で強制するには `command` または `http` フックを使い、フック自体がクラッシュしたりタイムアウトしたりした場合にもアクションを止めるべきなら [`onFailure: "block"`](https://code.claude.com/docs/ja/hooks#block-the-action-when-a-hook-fails) を追加します。例えばコミットに含まれるシークレットをスキャンするフックなら、スキャナーが停止している間にスキャンされないままコミットを通すより、コミットをブロックしたほうがよいでしょう。

以下はフォーマッタールールを `PostToolUse` フックにしたものです。すべての `Edit` または `Write` の後に実行され、実行するのは Claude ではないため、Claude がルールを覚えているかどうかはもはや関係ありません：

```json .claude/settings.json theme={null}
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Edit|Write",
        "hooks": [
          { "type": "command", "command": "npx prettier --write --ignore-unknown \"$(jq -r '.tool_input.file_path')\"" }
        ]
      }
    ]
  }
}
```

フックを確認するには、Prettier がフォーマットするファイルにインデントの崩れた行を追加するよう Claude に依頼します。保存されたファイルはインデントが修正された状態になります。

マイグレーションのルールは、`migrations/` 配下のパスに対して終了コード 2 で終了する [`PreToolUse` フック](https://code.claude.com/docs/ja/hooks-guide#block-edits-to-protected-files)になります。自分で書く必要はありません。`write a hook that blocks edits to the migrations folder` とプロンプトすればよく、結果は `/hooks` で確認できます。ただし、やりすぎは禁物です。フックは例外が*ゼロ*のルールのためのもので、`Prefer named exports` には例外がたくさんあるため、これは `CLAUDE.md` に残します。

### 権限ルールとサンドボックスでアクセスを制限する

[権限ルール](https://code.claude.com/docs/ja/permissions.md)は、Claude が何を実行、読み取り、取得できるかを決定します。`deny` ルールは auto や `bypassPermissions` を含むすべての権限モードで有効であり、だからこそ `.env` のルールはここに置くべきなのです：

```json .claude/settings.json theme={null}
{
  "permissions": {
    "allow": ["Bash(pnpm tsc --noEmit)"],
    "ask": ["Bash(git push *)"],
    "deny": ["Read(./.env)", "Read(./.env.local)", "Read(./secrets/**)"]
  }
}
```

これを保存すると、`.env` の中身を Claude に尋ねても、`Read` ツール経由でも `cat .env` 経由でも失敗します。

ルールは意図ではなくツール呼び出しに一致するため、どこに境界があるかを知っておく価値があります：

* `Read` ルールは `cat .env` を*捕捉します*。Claude Code が[一般的なファイル読み取りコマンド](https://code.claude.com/docs/ja/permissions.md#read-and-edit)を認識するためです。
* ファイルを開くスクリプトは捕捉しません。
* ドメインに対する `WebFetch` の拒否ルールは、サンドボックスがオンでない限り、同じドメインへの `curl` には何の効果もありません。

ファイルシステムやネットワークアクセスに OS レベルの制限をかけるには、セッション内で `/sandbox` を使って[サンドボックス](https://code.claude.com/docs/ja/sandboxing.md)をオンにします。これは macOS、Linux、WSL2 で Claude のシェルコマンドを制限し、[`Read` の拒否ルールと `WebFetch(domain:...)` ルールも取り込む](https://code.claude.com/docs/ja/sandboxing#permission-rules)ため、セキュリティに関わるものには両方を使うのが望ましいです。

デフォルトでは、Claude はブロックされたコマンドをサンドボックスの外で再試行するよう求めることができ、そのリクエストは通常の権限フローを通ります。`/sandbox` の **Overrides** タブにある [strict サンドボックスモード](https://code.claude.com/docs/ja/sandboxing.md#turn-off-the-retry-with-strict-sandbox-mode)を使うと、この再試行がオフになります。

> [!WARNING]
>
> auto モードは、厳格なルールではなく、各アクションを判断する分類器モデルです。判断は得意ですが、あらゆる判断と同様に間違うこともあります。また、何をリスクとみなすかを調整することもでき、組織がそれを完全にオフにすることもできます。そのため、「決して」のルールは拒否ルールまたはフックに置くべきです。

### ルールを誰に適用するかを選ぶ

ルールをどこに置くかによって、誰に適用されるかが決まります：

* `.claude/settings.local.json` と `~/.claude/settings.json` は自分専用です。コマンドに対して **Yes, and don't ask again** を選択すると、Claude Code はそのルールをローカルファイルに保存します。
* `.claude/settings.json` とその中のフックはリポジトリに属します。コミットすると、リポジトリで作業するすべての人に適用されます。その拒否ルールはすぐに適用されます。`allow` ルールは、各人がそのフォルダーの[信頼ダイアログ](https://code.claude.com/docs/ja/permissions.md#what-runs-before-you-trust-a-folder)を承認するまで待機し、[ワークスペースの信頼](https://code.claude.com/docs/ja/hooks.md#workspace-trust)によって、そのフックが各人のマシンで実行され始めるタイミングも決まります。
* [管理設定](https://code.claude.com/docs/ja/managed-settings.md)は組織に属します。管理コンソール、MDM、または `managed-settings.json` ファイルから配布され、どの個人設定ファイルでも上書きできないため、セキュリティチームのポリシーを置ける唯一の場所です。自分がそれを設定する立場であれば、[組織向けに Claude Code をセットアップする](https://code.claude.com/docs/ja/admin-setup.md)を参照してください。

スコープがどこであれ、強制するものは少数に保ってください。フックや拒否ルールはどれも時々は発火すべきでないときに発火しますし、誰かがそれぞれを保守しなければなりません。もし 40 個にもなっているなら、その大半はおそらく Claude が自分で判断できた好みにすぎません。

## デフォルトを変更する

> [!TIP]
>
> タスクにかかる時間、トークン、中断が想定以上になるまでは、デフォルトのままで十分です。そうなったら、セッション内で `/usage` を実行して、どこに費やされたかを確認してください。

新しいセッションは、すでにいくつかの判断をユーザーに代わって行っています：

* 対話型のターミナルおよび VS Code セッションは auto モードで開始します。
* ほとんどのプランとプロバイダーで、[medium effort の Claude Opus 5.5](https://code.claude.com/docs/ja/model-config.md#default-model-setting) で実行されます。
* 理由があると判断すれば、作業をサブエージェントに委譲します。
* 会話が長くなるにつれて圧縮します。

ほとんどの場合、これらを意識することはありません。タスクに想定以上のコストがかかるときは、たいていこの 4 つのいずれかが原因です。

### 権限モードを変更する

権限の範囲の両端には、それぞれコストがあります：

* **Manual モード**：読み取り専用ではないすべての編集とコマンドを自分で承認します。安全ですが、10 回目のプロンプトを過ぎると読まずに承認するようになり、キーボードから離れている間は何も進みません。
* **`bypassPermissions`**：拒否ルールと確認ルールの対象外のものをすべて承認します。使い捨てのコンテナでのみ意味があります。

[auto モード](https://code.claude.com/docs/ja/permission-modes.md#eliminate-prompts-with-auto-mode)はこの 2 つの中間に位置し、対話型のターミナルおよび VS Code セッションは[このモードで開始します](https://code.claude.com/docs/ja/permission-modes.md#which-mode-a-session-starts-in)。Claude は日常的な承認で止まることなく作業し、別の分類器モデルが実行前に[決まった順序](https://code.claude.com/docs/ja/permission-modes.md#how-the-classifier-evaluates-actions)でアクションをチェックします。分類器が重点を置くのは、[人間に止めてほしいと思うようなもの](https://code.claude.com/docs/ja/permission-modes.md#what-the-classifier-blocks-by-default)です：

* `curl | bash`
* 本番デプロイとマイグレーション
* 他人の作業を上書きする force push
* 外部エンドポイントへの機密データの送信
* ユーザーではなく、Claude が読んだコンテンツによって引き起こされたように見えるアクション

実際に何かをブロックすると通知が届き、そのアクションは `/permissions` の **Recently denied** に表示されます。そこから手動承認で再試行できます。[3 回連続](https://code.claude.com/docs/ja/permission-modes.md#when-auto-mode-falls-back)（または合計 20 回）ブロックされると、auto モードは一時停止し、ユーザーに確認する方式に戻ります。

これは決定論的な制御に取って代わるものではありません。それらの*後*に実行されるからです。拒否ルール、確認ルール、`PreToolUse` フックは分類器が何かを見る前に適用されるため、拒否ルールは auto モードでも他のすべての場所とまったく同じようにブロックします。サンドボックスも引き続き、[ラップするシェルコマンド](https://code.claude.com/docs/ja/sandboxing.md#what-runs-outside-the-sandbox)を制限します。

> [!NOTE]
>
> 会話の中で `don't push until I've reviewed` と伝えることもでき、分類器は[それをブロックのシグナルとして扱います](https://code.claude.com/docs/ja/permission-modes.md#boundaries-you-state-in-conversation)。ただし、これはあくまでモデルがトランスクリプトを読んでいるだけで、会話が圧縮されるとその一文が失われることもあるため、重要なことは拒否ルールに置くべきです。

逆の問題は、自分の環境では日常的な操作を分類器が繰り返し止めてしまうことです。毎回手動で承認する代わりに、それを `autoMode.allow` に追加するか、[auto モードの設定](https://code.claude.com/docs/ja/auto-mode-config.md)で信頼できるインフラストラクチャを記述します。パターンではなく平易な英語で書くもので、[`/auto-mode-setup`](https://code.claude.com/docs/ja/auto-mode-config#generate-environment-entries) を使えば、プロジェクトと最近のセッションから `environment` 部分の下書きを作成できます：

```json ~/.claude/settings.json theme={null}
{
  "autoMode": {
    "environment": [
      "$defaults",
      "Source control: github.com/example-org and every repo under it",
      "Trusted internal domains: *.internal.example.com"
    ],
    "allow": [
      "$defaults",
      "Deploying to the staging namespace is fine, it's isolated from production and resets nightly"
    ]
  }
}
```

> [!WARNING]
>
> 設定するすべてのリストに `"$defaults"` を残してください。これがないと、エントリはそのリストの組み込みルールに追加されるのではなく、組み込みルールを*置き換えます*。`environment` と `allow` では組み込みのコンテキストと例外が失われ、`soft_deny` リストでこれを省くと、force push や本番デプロイに対する組み込みのブロックがなくなります。
>
> `autoMode` ブロックは、プロジェクトではなく `~/.claude/settings.json` に置く必要もあります。分類器はプロジェクト設定内の `autoMode` を無視するためです。

すべての編集とコマンドを実行前に確認したい場合は、セッション内で `Shift+Tab` を押すと Manual を含む権限モードが切り替わります。またはシェルから `claude --permission-mode manual` で開始します。そして Manual で確認が多すぎる場合は、`/fewer-permission-prompts` が最近のトランスクリプトから一般的な読み取り専用の Bash および MCP 呼び出しを探し、`.claude/settings.json` の許可リストに追加します。

### モデルと effort を変更する

[effort](https://code.claude.com/docs/ja/model-config.md#adjust-effort-level) は Claude が考える長さを制御する主な手段であり、かつてプロンプトの言い回しで行っていたことのほとんどを置き換えます。Claude Opus 5.5、Sonnet 5.5、Haiku 5.5 のデフォルトは `medium` で、スコープが明確な日常的な機能開発には十分です。セッション内で `/effort` を使って変更するのは次のような場合です：

* 正しく仕上げられるかどうかが見落としやすいケースにかかっているときは、`/effort high` または `/effort xhigh` で引き上げます。自分が書いていないコードのバグ、不安定なテスト、古い形式を読んでいる箇所を Claude がすべて見つけなければならないスキーマ変更などです。Claude はより多くのエッジケースをチェックし、回答前に自分の作業をより多く検証します。追加の時間とトークンはそこに使われます。
* 素早くやり取りしながら、いずれにせよ各結果をレビューするときは、`/effort low` で引き下げます。ブレインストーミング、最初のスケッチ、いくつかのファイルにわたる名前変更などです。Claude はより早く出発点を示してくれますし、すべてのステップをユーザーが舵取りしているので、追加の熟考をしても待ち時間以外はあまり変わらなかったでしょう。
* `max` は、セキュリティ脆弱性の調査のように、ユーザーなしで Claude に取り組んでほしい難しい問題のために取っておきます。通常のタスクでは考えすぎる傾向があり、`high` で得られたものと変わらないかもしれない回答に多く支払うことになります。
* 日常的な作業の途中で難しい質問が 1 つだけあるときのように、次のメッセージだけに必要な場合は、設定を変更する代わりにそのプロンプトに [`ultrathink`](https://code.claude.com/docs/ja/model-config#use-ultrathink-for-one-off-deep-reasoning) を入れます。

モデル自体については、デフォルトの Opus 5.5 がほとんどのコーディングをうまくこなし、Sonnet は日常的な作業でより低コストです。[Claude Fable 5.1](https://code.claude.com/docs/ja/model-config.md#work-with-fable) は `/model fable` で明示的に選択したときに使用でき、Haiku は単純な仕事をするサブエージェントに適しています。プランとプロバイダーごとの完全なリストは[モデル設定](https://code.claude.com/docs/ja/model-config.md)にあります。

### サブエージェントのコストを知る

Claude は自ら[サブエージェント](https://code.claude.com/docs/ja/sub-agents.md)に委譲します：

* 広範なコードベース検索は組み込みの Explore エージェントに渡されます。
* fork モードがオン（デフォルト）の間は、サイドタスクが[フォーク](https://code.claude.com/docs/ja/sub-agents.md#fork-the-current-conversation)されます。
* Claude が開始したサブエージェントはデフォルトでバックグラウンドで実行されるため、メインの会話は進み続けます。

これらを依頼する必要はほとんどありませんが、何が得られ、何にコストがかかるかを知っておくと役立ちます。

サブエージェントが効果を発揮するのは次のような場合です：

* 独立した作業を同時に実行し、タスク全体を早く終わらせる
* 完全なテスト実行や広範な検索のような長い出力を、メインの会話から切り離す（そうしないと、セッションの残りの間ずっと付いて回ります）
* コードがどのように書かれたかを見ていないレビュアーを得る
* 読み取りはできても編集はできないレビュアーのように、メインセッションよりも少ないツールをタスクに与える

コストは主にトークンです。各サブエージェントは独自のリクエストを送信し、それらはメインの会話と同じ使用量にカウントされるためです。時間がかかる場合もあります。新しいサブエージェントは、会話にすでにあったコンテキストをまず集めなければならないため、今いる場所でタスクを行うより*遅く*なることがあります。

また、デフォルトでは同じタスクに同じモデル（またはより小さいモデル）を使います。並列性や新鮮な視点は得られますが、より賢い回答が得られるわけではありません。

サブエージェントにかかるコストを減らすには：

* モジュールをインポートしているファイルを集める、ドキュメント内のリンクをチェックするなど、作業が単純な場合は、サブエージェントの定義に [`model: haiku`](https://code.claude.com/docs/ja/sub-agents#choose-a-model) を設定します。そうした仕事に大きなモデルは不要で、Haiku はリクエストあたりのコストがはるかに低くなります。
* 短い要約を返すよう依頼し、20 件の結果でコンテキストがいっぱいにならないようにします。
* `/usage` を確認して、各サブエージェントタイプが使用量のどれだけを占めているかを把握し、どれがコストに見合っているかを判断します。
* `.claude/agents/` のカスタムサブエージェントには `tools: Read, Grep, Glob` だけを与えます。これで何も編集できないレビュアーになり、その制限はプロンプトで依頼するのではなく Claude Code によって強制されます。

そのレビュアーは `.claude/agents/reviewer.md` という短いファイル 1 つです：

```markdown .claude/agents/reviewer.md theme={null}
---
name: reviewer
description: Reviews changed files against the spec they were built from. Use after implementing a feature, before opening the PR.
tools: Read, Grep, Glob
---
You're reviewing code you didn't write. Compare the changed files against the spec you're given,
check that every requirement is implemented and the listed edge cases have tests,
and report only the gaps that affect correctness. Skip style.
```

Claude に `have the reviewer compare the rate limiter against SPEC.md` と依頼すると、ギャップがセッションに返され、Claude がそれを修正できます。

### コストとコンテキストを抑える

現在のほとんどのモデルは 1M トークンのウィンドウを持ち、その上限近くでコンテキスト圧縮が行われるため、コンテキストが足りなくなることはまれです。それでも、不要なコンテキストに*支払う*ことはあり得ます。すべてのリクエストは会話全体を送信するため、無関係な 3 つのタスクを抱えたセッションでは、4 つ目のタスクのターンごとに 3 つすべてを再読み込みします。これは[キャッシュが有効な間は割引され](https://code.claude.com/docs/ja/costs.md#why-usage-climbs-in-a-long-session)、期限が切れると正規料金になります。

まず確認すべきは [`/usage`](https://code.claude.com/docs/ja/costs) です。Pro、Max、Ultra、Team、Enterprise では、使用量をスキル、サブエージェント、プラグイン、MCP サーバーごとに分類して表示します。また、長いコンテキストや頻繁なキャッシュミスなどのパターンが使用量の 10% を超えると、それを指摘します。そこからの一般的な対処法は次のとおりです：

* 無関係なタスクの間には `/clear`。コストはかからず、次のタスクが前のタスクの履歴の分まで支払い続けることがなくなります。`/clear oauth-migration` は離れるセッションに名前を付けるので、後で戻ってこられます。
* `/compact keep the API changes and the test commands` のように、焦点を指定した `/compact`。長いセッションでは、`/compact` は要約のために会話全体を読み込むため、それ自体が大きなリクエストになります。キャッシュの期限が切れた後はなおさらです。
* バックグラウンドの作業に注意：`/loop`、毎ターン後のゴールのチェック、Claude 自身のサブエージェントは、ユーザーが入力していない間もリクエストを送り続けます。

> [!NOTE]
>
> [プロンプトキャッシュ](https://code.claude.com/docs/ja/prompt-caching.md)の持続時間は、サブスクリプションでは約 1 時間、API キー、クラウドプロバイダー、使用クレジットでは 5 分です。サブエージェントは、変更しない限り 5 分です。
>
> 1 時間キャッシュでは、約 200K トークンを超えたセッションがアイドル状態になると、キャッシュの期限切れの少し前に圧縮されるため、昼休み明けには要約から続けることになります。履歴がまったく不要なら、新しいセッションのほうが依然として低コストです。

## セッションを舵取りする

> [!TIP]
>
> 最初の 1 分間を見守り、Claude が逸れたらすぐに `Esc` を押し、2 回修正しても駄目なら 3 回目の修正ではなく `/clear` を実行してより良いプロンプトを書いてください。

どれだけ設定しても、最初の 1 分間を見守り、Claude が意図しない方向に向かったときに介入することの代わりにはなりません。そのための操作はわずかしかなく、しっかり覚えておく価値があります：

* `Esc` は Claude をアクションの途中で止め、それまでのすべてを保持するため、作業を失わずに方向を変えられます。
* `/rewind`、または空のプロンプトで `Esc` を 2 回押すと、[巻き戻しメニュー](https://code.claude.com/docs/ja/checkpointing.md#rewind-and-summarize)が開き、コード、会話、またはその両方を以前のプロンプトの時点まで戻せます。これにより、大胆なアプローチをまず試し、うまくいかなければ巻き戻すというやり方のリスクが低くなります。同じメニューでは、古くなった会話の一部を要約することもできます。
* `/clear` は最初からやり直します。同じことを 2 回修正してもまだ間違っている場合、3 回目の修正は、Claude が読み返し続ける失敗した試みが 2 つすでに含まれた会話に、さらに追加するだけになりがちです。`/clear` と、学んだことを盛り込んだ新しいプロンプト 1 つのほうが、ほぼ毎回うまくいきます。

> [!WARNING]
>
> チェックポイントは、メインの会話で Claude が自身のファイルツールで編集したファイルを対象とするため、Bash コマンドだけが変更したファイルは[復元されません](https://code.claude.com/docs/ja/checkpointing.md#bash-command-changes-not-tracked)。チェックポイントは git を置き換えるものではなく、git と併用するものです。

ほかに小さなものが 2 つあります。[`/btw`](https://code.claude.com/docs/ja/interactive-mode#side-questions-with-%2Fbtw) は履歴に何も追加せずに簡単な質問に答えます。また、数日にわたる作業の場合は、セッション内で `/rename oauth-migration` を実行して名前を付けておくと、後でシェルから [`claude --resume oauth-migration`](https://code.claude.com/docs/ja/sessions#resume-by-session-id-or-name) を実行して、チェックポイントも含めて再開できます。`claude --continue` は最新のセッションを再開します。

## Claude を無人で実行する

> [!TIP]
>
> 実行を無人にする前に、完了とは何かを理解していること、自分の作業を確認できること、触れてよいものだけに触れられることを確認してください。ターン数または支出に上限を設け、最後に人間が結果を承認するようにします。

ユーザーがその場にいて間違いを指摘できなくなると、このページのすべてがもう少し重要になります。見守っている間は、Claude が何らかのコンテキストを欠いていても大きな問題ではありません。1～2 メッセージ以内に気付いて伝えればよいのです。寝る前に開始した実行では誰も指摘しないため、翌朝になって、Claude が一晩中間違った前提の上に作業を積み上げていたことに気付くことになります。

タスクを自力で実行させたままにする前に、その具体的なタスクを念頭に置いて次の 5 つの質問を確認する価値があります：

1. 完了とは何かを理解しているか？ゴール条件、仕様ファイル、または合格させなければならない失敗中のテスト。
2. 自分の作業を確認できるか？テストスイート、`Stop` フック、何らかのレビューステップ。
3. 何に触れてよいか？権限ルール、`dontAsk`、サンドボックス、worktree、push してよい唯一のブランチ。
4. 何がそれを止めるか？`--max-turns`、`--max-budget-usd`、支出上限。
5. 結果はどこに行き、誰が承認するか？PR、コメント、または要約。そして、マージ、デプロイ、その他取り消せないものを人間が承認します。

いったん動き出せば、Claude は長いタスクを自力でやり遂げます。ユーザーの手元に残るのは、それを開始すること、今回の「完了」が何を意味するかを決めること、そして最後にマージを承認することです。

### スクリプトから Claude を実行する

[`claude -p "prompt"`](https://code.claude.com/docs/ja/headless) は 1 回実行して終了します。これにより、Claude Code を CI ジョブ、git フック、シェルループで使えます。

スクリプトでは、ほぼ必ず追加のフラグがいくつか必要になります：

* [`--bare`](https://code.claude.com/docs/ja/headless#start-faster-with-bare-mode) は、フック、スキル、プラグイン、MCP サーバー、`CLAUDE.md` ファイル（リポジトリのものもマシンのものも）をスキップするため、どこで実行しても同じ動作になります。また、claude.ai のログインには一切触れません。認証は `ANTHROPIC_API_KEY`、`--settings` で渡すファイル内の `apiKeyHelper`、またはクラウドプロバイダーの認証情報から取得します。
* `--append-system-prompt`、`--mcp-config`、`--settings` は、その実行で*実際に*必要なものを明示的に渡します。
* `--allowedTools` はツールを事前承認し、[`--permission-mode dontAsk`](https://code.claude.com/docs/ja/permission-modes#allow-only-pre-approved-tools-with-dontask-mode) はそれ以外で確認が必要になるものをすべて拒否します。
* `--output-format json` は解析用の単一の結果オブジェクトを返し、`stream-json` を `--verbose` と組み合わせると、イベントが発生するたびにストリーミングされます。

これらを組み合わせると、次のようになります：

```bash theme={null}
for file in $(cat files.txt); do
  claude --bare -p "Migrate $file to the new logger API and commit. Reply OK or FAIL." \
    --allowedTools "Read,Edit,Bash(git add *),Bash(git commit *)" \
    --permission-mode dontAsk \
    --max-turns 20
done
```

実行が終わると Claude は `OK` または `FAIL` と応答し、ターン数の上限に達した実行は代わりにエラーで終了します。まず 3 つのファイルで試し、何がうまくいかないかを確認してプロンプトを修正してから、残りを実行してください。

`--permission-mode auto` を渡せば、auto モードは `-p` でも機能します。非対話型の実行では、分類器のブロックはその 1 つのアクションを拒否し、Claude は作業を続けます。ブロックが繰り返されても、ターミナルのように実行が一時停止することはありません。これに頼る前に、[そこでのしきい値の適用方法](https://code.claude.com/docs/ja/permission-modes.md#repeated-block-thresholds)をお読みください。

### スケジュールやイベントで実行を開始する

いったん実行が始まれば、残りは Claude が自力で処理できます。Claude にできない唯一のことは*開始*を決めることなので、何かがそれを行う必要があります。ユーザー、タイマー、または CI チェックの失敗や新しい PR のようなイベントです。

開いているセッション内では、プロンプトを一定間隔で繰り返す [`/loop`](https://code.claude.com/docs/ja/scheduled-tasks#run-a-prompt-repeatedly-with-%2Floop) を使います：

```text theme={null}
/loop 15m check CI on this branch, and if it's red pull the failing job's log, fix it and push
```

各実行は同じセッション内の別のターンになるため、長い会話の中で実行したままにしないでください。ノートパソコンを閉じている間に行うべきことには、[`/schedule`](https://code.claude.com/docs/ja/routines#create-from-the-cli) で、タイマーで実行される[クラウドスケジュールタスク](https://code.claude.com/docs/ja/routines.md)を設定します。これには API キーではなく claude.ai のログインが必要です。GitHub イベントトリガーは Claude に依頼して追加でき、API トリガーは [claude.ai/code/routines](https://claude.ai/code/routines) で追加できます。

> [!WARNING]
>
> クラウドスケジュールタスクを実行したままにする前に、[タスクがバイパスできない GitHub ブランチルール](https://code.claude.com/docs/ja/routines.md#repositories-and-branch-permissions)で `main` を保護してください。また、新しいものは、無人で任せる前に最初の数回の実行を見守ってください。

### セッションを並列で実行する

別々の作業を同時に進めるときは、それぞれに専用のチェックアウトを与えて、編集が衝突しないようにします。[`claude -w feature-auth`](https://code.claude.com/docs/ja/worktrees#start-claude-in-a-worktree) は新しい worktree でセッションを開始し、[デスクトップアプリ](https://code.claude.com/docs/ja/desktop.md#work-in-parallel-with-sessions)はこれらを複数並べて実行し、[クラウドセッション](https://code.claude.com/docs/ja/claude-code-on-the-web.md)はマシン上ではなくクラウドで実行します。

worktree は新しいチェックアウトなので、`.env` のような gitignore されたファイルは存在せず、依存関係もインストールされていません。前者については、必要な gitignore 対象ファイルをリポジトリのルートにある [`.worktreeinclude`](https://code.claude.com/docs/ja/worktrees#copy-gitignored-files-into-worktrees) に列挙すると（構文は `.gitignore` と同じ）、Claude Code は作成するすべての worktree にそれらをコピーします：

```text .worktreeinclude theme={null}
.env
.env.local
config/dev-credentials.json
```

小さなファイルだけにしてください。リンクではなくコピーされるため、`node_modules` を入れると worktree ごとに完全なコピーが作られます。大きなディレクトリには [`worktree.symlinkDirectories`](https://code.claude.com/docs/ja/settings-reference#worktree-symlinkdirectories) 設定があります。あるいは、インストールコマンドを `CLAUDE.md` に書いておけば、Claude は新しいチェックアウトで開始するたびにそれを実行します。

これらを自分でクリーンアップしなければならないことはほとんどありません：

* 名前のない worktree セッションを終了すると、中身が何もなければ Claude Code は [worktree を削除します](https://code.claude.com/docs/ja/worktrees.md#clean-up-worktrees)。名前付きセッションや変更のあるセッションの場合は、どうするかを尋ねます。
* サブエージェントの worktree は、サブエージェントが変更なしで終了すると消えます。
* 残されたサブエージェントやバックグラウンドセッションの worktree は、`cleanupPeriodDays` より古くなり、作業を含んでいなければ一掃されます。

> [!NOTE]
>
> `claude -p --worktree` の実行は確認せずに終了するため、自分でクリーンアップする必要があります。`git worktree remove <path>` で削除し、worktree がロックされているために git が拒否する場合は、先に `git worktree unlock <path>` を実行します。

多数のファイルにわたる 1 つの大きな機械的変更には、[`/batch migrate every handler to the v2 response helpers`](https://code.claude.com/docs/ja/commands) が作業を 5～30 個の単位に分割し、計画を表示します。その後、各単位を専用の worktree で実行し、それぞれについて PR を作成します。シェルからは、[`claude agents`](https://code.claude.com/docs/ja/agent-view)（まだリサーチプレビュー）で、マシン上のバックグラウンドで実行中のすべてを 1 つの画面で確認できます。

2 つ目のセッションは、手に入る中で最も手軽な独立レビュアーでもあります。一方のセッションがレートリミッターを書き、もう一方が書かれる過程を見ずに `@src/middleware/rateLimiter.ts` をレビューし、その指摘を最初のセッションに貼り付けます。`/code-review` と同じ考え方で、メッセージの受け渡しをユーザーが行う形です。

## やめてもよいこと

これらはどれも、書かれた当時は良いアドバイスでした。ほとんどはモデルがまだ確実にはできなかったことへの回避策で、その後モデルが追いつきました。まだ習慣として残っているものがあれば、それをやめても安全な理由を以下に示します。

| 以前のアドバイス | 不要になった理由 |
| :- | :- |
| コンテキストウィンドウが主な制約なので、積極的に管理する | 現在のほとんどのモデルは 1M トークンのウィンドウを持ち、コンテキスト圧縮は自動で行われるため、足りなくなることはまれです。ただし、タスク間の `/clear` は今でも行う価値があります。焦点の定まったコンテキストのほうが良い回答が得られ、コストも低くなるためです。 |
| Claude が見落とし続ける指示に IMPORTANT や全大文字を加える | 以前のモデルでは強調が必要なこともありました。現在のモデルは平易に書かれた行に従い、強調を重ねると主に Claude がルールを過剰に適用するようになります。曲げられないルールなら、フックか拒否ルールにしてください。長いファイルの中で行が埋もれているなら、ファイルを短くする必要があります。 |
| コンテキストウィンドウを守るためにサブエージェントを使う | コンテキストが足りなくなることは、もはやほとんど問題になりません。サブエージェントは並列作業、ノイズの多い出力の切り離し、独立したレビューには今でも非常に有用ですが、どれも追加のトークンがかかります。 |
| より良い回答を得るためにサブエージェントに委譲する | 同じタスクをサブエージェントに渡しても、回答が良くなるわけではありません。新しいレビュアーは役立ちますが、それはユーザーの推論を見ていないからであり、委譲とは別の話です。 |
| プロンプトに `think hard`、`think harder`、`be thorough` と書く | それを制御するのは effort です。これらのフレーズは、effort 設定を引き上げるキーワードではなく、その設定の範囲内で Claude を後押しする通常のプロンプトテキストです。`ultrathink` は今でも機能し、effort 設定に触れずにその 1 ターンだけより深い推論を求めます。 |
| Claude に作業を続けるよう、完了するまでループするよう、怠けないよう指示する | 現在のモデルは通常、合意したタスクを指示されなくてもやり遂げます。そうした行は停滞を解消するより、過剰な作業を引き起こす可能性のほうが高いです。合格すべきチェックを Claude に与えるのはこれとは別で、今でも行う価値があります。実行が途中で止まってしまったら `continue` と伝え、誰も見ていない実行では `/goal` または `Stop` フックで強制します。 |
| `CLAUDE.md` にアーキテクチャとファイル構成を記述する | Claude はリポジトリを自分で読みます。そこにないことだけを書き留めてください。 |

このページの他のアドバイスが無駄な作業のように感じ始めたら、それもおそらくこの表に加えるべきだというサインです。

## 関連リソース

* [Claude Code の仕組み](https://code.claude.com/docs/ja/how-claude-code-works.md)：ループ、ツール、起動時に読み込まれるもの
* [コンテキストウィンドウを探索する](https://code.claude.com/docs/ja/context-window.md)：セッションで何がスペースを使い、いつ読み込まれるか
* [Claude Code を拡張する](https://code.claude.com/docs/ja/features-overview.md)：スキル、フック、MCP、サブエージェント、プラグインの選び方
* [権限モードを選択する](https://code.claude.com/docs/ja/permission-modes.md)と[権限を設定する](https://code.claude.com/docs/ja/permissions.md)
* [コストを効果的に管理する](https://code.claude.com/docs/ja/costs.md)
* [Claude Code をプログラムで実行する](https://code.claude.com/docs/ja/headless.md)と[クラウドスケジュールタスクで作業を自動化する](https://code.claude.com/docs/ja/routines.md)
* チームリーダーと管理者向け：[組織向けに Claude Code をセットアップする](https://code.claude.com/docs/ja/admin-setup.md)
