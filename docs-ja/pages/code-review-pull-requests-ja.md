> ## Documentation Index
> Fetch the complete documentation index at: https://code.claude.com/docs/llms.txt
> Use this file to discover all available pages before exploring further.

# プルリクエストのレビューを読む・リクエストする

> GitHub のプルリクエストで Code Review の指摘を読み、返信または却下し、`@claude review` でレビューをリクエストします。

Code Review は、Claude 組織の Owner が一連の GitHub リポジトリに対してオンにするマネージドサービスです。オンにすると、Claude はそれらのリポジトリのプルリクエストをレビューし、指摘をインラインコメント、レビュー本文のサマリー、そして **Claude Code Review** という名前のチェックランとして投稿します。レビューがプルリクエストを承認したりブロックしたりすることはなく、チェックランが失敗として終了することもありません。

Owner は、リポジトリごとに[レビューを実行するタイミング](/docs/ja/code-review-setup#set-when-reviews-run)と[レビューの詳細度](/docs/ja/code-review-setup#set-the-default-review-level)を制御します。

> [!NOTE]
>
> プランに Code Review が含まれていない場合でも、Claude Code セッションから Claude にブランチをレビューさせることができます。[`/code-review` でローカルにレビューする](/docs/ja/code-review-local)を参照してください。

## 重大度レベル

Claude は各指摘を該当する行へのインラインコメントとして投稿し、3 つの重大度レベルのいずれかでマークします。

| マーカー | 重大度 | 意味 |
| :- | :- | :- |
| 🔴 | Important | マージ前に修正すべきバグ |
| 🟡 | Nit | 軽微な問題。修正する価値はあるがブロックするほどではない |
| 🟣 | Pre-existing | コードベースに存在するが、この PR で導入されたものではないバグ |

レビューが推論を記録した場合、指摘には折りたたまれた **Why this was flagged** セクションがあります。これを展開すると、Claude がその問題を指摘した理由と、問題をどのように検証したかを読むことができます。

リポジトリで Claude が指摘する内容や重大度の判定方法を変更するには、[Code Review をカスタマイズする](/docs/ja/code-review-customize)を参照してください。

## 指摘に対応する

リポジトリ独自のルールで求められていない限り、指摘に対応しなくてもマージできます。ブランチ保護で[会話の解決が必須](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-protected-branches/about-protected-branches#require-conversation-resolution-before-merging)になっている場合は、マージする前に各指摘のスレッドを解決してください。

指摘を解消するには、そのスレッドを解決するか、修正をプッシュします。

* **コードを変更せずに却下する**: GitHub 上で自分でスレッドを解決します。返信するだけでは指摘は却下されません。
* **問題を修正する**: コードを変更してプッシュします。プルリクエストの次のレビューは、問題が修正されたと判断した場合に以前のスレッドを解決します。これは、そのレビューがプッシュで自動的に実行された場合でも、リクエストによって実行された場合でも同じです。
* **説明する、または反論する**: コメントに返信します。Claude はすぐには応答せず、返信によってレビューが開始されることもありません。プルリクエストの次のレビューが以前の指摘への返信を読み、スレッドを解決するか、フォローアップの返信を 1 件投稿することがあります。同じ種類の指摘が繰り返し出る場合は、メンテナーに [`REVIEW.md`](/docs/ja/code-review-customize#choose-what-to-write-in-review-md) へのルール追加を依頼してください。

プッシュせずに次のレビューを実行するには、`@claude review` を[プルリクエストのトップレベルコメント](#comment-commands)として投稿します。

## チェックランの出力

**Claude Code Review** チェックランの **Details** リンクを開くと、GitHub がインラインコメントを受け付けなかった指摘も含め、すべての指摘が重大度順に並んだ 1 つの表で表示されます。

| 重大度 | ファイル:行 | 問題 |
| - | - | - |
| 🔴 Important | `src/auth/session.ts:142` | トークンのリフレッシュがログアウトと競合し、古いセッションがアクティブなまま残る |
| 🟡 Nit | `src/auth/session.ts:88` | `parseExpiry` が不正な入力に対して暗黙的に 0 を返す |

行情報があるもののインラインコメントとして投稿されなかった指摘は、**Files changed** タブの該当行にアノテーションとして表示されます。Important の指摘は赤、Nit は黄、既存のバグはグレーで表示されます。

チェックランは neutral として終了します。プッシュでファイルが変更されなかったために自動レビューが実行されなかった場合は skipped として終了します。失敗として終了することはないため、完了したレビューが必須チェックを失敗させることはありません。指摘が表示されない場合やレビューが実行されなかった場合は、[Code Review のトラブルシューティング](/docs/ja/code-review-troubleshooting)を参照してください。

### スクリプトから結果を読む

独自の CI でマージをゲートしたりサマリーを投稿したりするには、`gh` と jq を使って Details テキストの最終行を解析します。この行は、重大度ごとの件数を JSON として保持する HTML コメントです。

```text theme={null}
<!-- bughunter-severity: {"nit":1,"normal":2,"pre_existing":0} -->
```

その上の行には、プルリクエストのファイル名が含まれることがあります。テキストを独自の方法で解析する場合は、以下の手順のコマンドと同様に、件数を最終行からのみ取得してください。

**1. チェックラン ID を見つける**

シェルからコミットのチェックランを一覧表示し、`Claude Code Review` ランの `id` を取得します。`OWNER` と `REPO` をリポジトリのオーナーと名前に、`<commit-sha>` をプルリクエストの head コミットに置き換えてください。

```bash theme={null}
gh api repos/OWNER/REPO/commits/<commit-sha>/check-runs --jq '.check_runs[] | {id, name}'
```

**2. 重大度ごとの件数を読む**

Details テキストを保持するチェックランの `output.text` フィールドから件数を読み取ります。`CHECK_RUN_ID` を ID に置き換えてください。

```bash theme={null}
gh api repos/OWNER/REPO/check-runs/CHECK_RUN_ID --jq '
  (.output.text | split("\n") | last
    | scan("^<!-- bughunter-severity: (.*) -->$")[0] | fromjson)?
  // error("no severity line")'
```

これにより、重大度ごとの件数を持ち、キーがアルファベット順に並んだ JSON オブジェクトが出力されます。例: `{"nit": 1, "normal": 2, "pre_existing": 0}`。件数には、スレッドがまだ未解決のままになっているプルリクエストの以前のレビューによる指摘も含まれます。

**3. 結果に基づいて処理する**

スクリプトで次のケースを処理するようにします。

* **`normal` が 0 より大きい**: マージをゲートしたい場合はジョブを失敗させます。`normal` キーには Important の指摘の件数が入っているため、Claude がマージ前に修正すべきバグを少なくとも 1 件見つけたことを意味します。この件数のみを出力するには、閉じの単一引用符の前に `| .normal` を追加します。
* **行が存在しない**: コマンドは件数の代わりに `no severity line` を含むエラーを出力し、0 以外のステータスで終了します。これは指摘 0 件ではなく、判定なしとして扱います。失敗した、タイムアウトした、キャンセルされた、または新しいレビューに置き換えられたレビューのチェックランにはこの行がなく、完了したレビューの中にもこの行がないものがあります。

## レビューをリクエストする

プルリクエストがドラフトである場合やフォークからのものである場合、自動レビューはスキップされるため、[コメントコマンドでレビューをリクエスト](#review-drafts-and-pull-requests-from-forks)してください。プルリクエストのレビューを受けるには、次のいずれかを行います。

* **オープンする、または ready にする**: **Once after PR creation** または **After every push** に設定されたリポジトリでは、プルリクエストをオープンまたは再オープンしたとき、あるいはドラフトを ready for review にしたときにレビューが開始されます。
* **コマンドをコメントする**: プルリクエストに [`@claude review`](#comment-commands) を投稿します。
* **コミットをプッシュする**: **After every push** に設定されたリポジトリ、または `@claude review always` でサブスクライブしたプルリクエストでは、プッシュによってレビューが開始されます。
* **Re-run をクリックする**: フォークからではないプルリクエストでレビューが失敗またはタイムアウトした場合は、チェックランから[再実行](/docs/ja/code-review-troubleshooting#retrigger-a-failed-or-timed-out-review)します。
* **自動再試行を待つ**: セッションが中断されたレビューは、自動的に 1 回再試行されます。再試行が行われている場合は、[チェックランのサマリー](/docs/ja/code-review-troubleshooting#retrigger-a-failed-or-timed-out-review)にその旨が表示されます。

### コメントコマンド

次のいずれかのコマンドをプルリクエストへのコメントとして投稿します。

| コマンド | 動作 | 使用するタイミング |
| :- | :- | :- |
| `@claude review` | 今後のプッシュに PR をサブスクライブせずに、1 回だけレビューを開始する | 今すぐ 1 回レビューしたい場合。たとえば **Manual** に設定されたリポジトリのプルリクエストや、他のモードですぐにもう一度レビューしたい場合 |
| `@claude review always` | レビューを開始し、以降はプッシュでトリガーされるレビューに PR をサブスクライブする | 以降のプッシュごとに新しいレビューを開始したい場合。たとえば **Manual** に設定されたリポジトリの優先度の高い PR |
| `@claude review once` | `@claude review` と同じ: サブスクライブせずに 1 回だけレビューを開始する | `@claude review` と同じケース |
| `@claude review stop` | プッシュでトリガーされるレビューへの PR のサブスクリプションを終了する。レビューを開始したり、すでにキューに入っているレビューや実行中のレビューをキャンセルしたりはしない。Claude はチェックランではなくコメントで返信する。 | **Manual** または **Once after PR creation** に設定されたリポジトリで `@claude review always` により PR をサブスクライブしたが、プッシュごとにレビューを開始する必要がなくなった場合 |
| `@claude review off` または `@claude review pause` | `@claude review stop` と同じ | `@claude review stop` と同じケース |

**After every push** に設定されたリポジトリでは、サブスクリプションの有無にかかわらずプッシュによってレビューが開始されるため、コメントでレビューを停止することはできません。そのようなリポジトリで 1 つのプルリクエストについてプッシュによるレビューの開始を止めるには、そのプルリクエストを[ドラフト](#review-drafts-and-pull-requests-from-forks)に変換してください。再び ready for review にすると、レビューが開始されます。

コメントコマンドを有効にするには、次の条件をすべて満たす必要があります。

* 新しいプルリクエストのトップレベルコメントとして投稿すること。差分の行へのインラインコメントやレビュー本文では機能しません。以前のコメントを編集しても対象になりません。
* コマンド全体をコメントの先頭の 1 行に書くこと。その後に他のテキストを続けてもかまいません。`always` や `stop` のスペルが間違っていたり、後の行に書かれていたりすると、Claude はそのコメントを単なる `@claude review` として読み取り、1 回だけレビューを開始します。大文字と小文字は区別されません。
* リポジトリに対する write、maintain、または admin 権限を持っていること。Claude はコメントした各ユーザーについて GitHub でこれを確認し、ボットからのコメントではレビューは開始されません。
* プルリクエストがオープンであること。

レビューを開始するコマンドが受け付けられると、**Code review queued...** というタイトルの **Claude Code Review** チェックランがプルリクエストに表示されます。レビューが開始されると、タイトルは **Code review in progress...** に変わります。Claude がコメントに 👀 でリアクションすることもありますが、このリアクションはレビューが開始されない場合にも表示されることがあるため、代わりにチェックランを確認してください。

プルリクエストの最新コミットですでにレビューが実行中の場合、新しいリクエストによって 2 つ目のレビューが開始されることはありません。

> [!NOTE]
>
> 2026 年 7 月のアップデート以前は、`@claude review` によって PR がプッシュでトリガーされるレビューにサブスクライブされていました。その動作に依存していた場合は、代わりに `@claude review always` をコメントしてください。

### 以降のレビューの対象範囲

プッシュ後など、自動的に開始される以降のレビューは、前回のレビュー以降に変更された部分に焦点を当て、Nit や既存の問題の指摘を少なく投稿します。そのサマリーには、除外した件数が "found and not posted" または "outside the scope of this re-review and not posted." で終わる行に記載されます。

これらを何も除外しないレビューを受けるには、[`@claude review`](#comment-commands) をコメントしてください。プルリクエスト全体が改めてレビューされます。

### ドラフトとフォークからのプルリクエストをレビューする

自動レビューはこれらの両方をスキップするため、コメントコマンドでレビューをリクエストしてください。

* **ドラフトのプルリクエスト**: コメントコマンドはドラフトでも実行されるため、プルリクエストを ready にする前にレビューをリクエストできます。ドラフトへのプッシュでは、`@claude review always` の後でもレビューは開始されません。サブスクリプションは、プルリクエストを ready にした時点で有効になります。
* **フォークからのプルリクエスト**: リポジトリの **Review runs** 設定にかかわらず、Claude はフォークからのプルリクエストを自動的にはレビューしません。レビューを開始するには、プルリクエストに `@claude review` をコメントします。[コメントコマンドの条件](#comment-commands)は引き続き適用され、必要な書き込み権限はフォークではなくベースリポジトリに対するものです。

フォークからのプルリクエストでも `@claude review always` は機能しますが、以降のプッシュでのレビューにプルリクエストがサブスクライブされることはありません。また、そこではチェックランの **Re-run** をクリックしてもレビューは開始されません。

### Claude Code GitHub Action と併用する

リポジトリで [Claude Code GitHub Action](/docs/ja/github-actions) もデフォルトの `@claude` トリガーフレーズを使ったインタラクティブモードで実行している場合、`@claude review` コメントによって Action も開始されます。2 つを区別するには、Action の `trigger_phrase` 入力を別のフレーズに設定してください。

## 関連リソース

* [Code Review のトラブルシューティング](/docs/ja/code-review-troubleshooting): 開始されなかった、失敗した、または予算のためにスキップされたレビュー
* [Code Review](/docs/ja/code-review): サービスの概要とレビューの実行方法
* [Code Review をセットアップする](/docs/ja/code-review-setup): Owner 向け。Code Review をオンにし、レビューを実行するタイミングとレベルを選択する
* [Code Review をカスタマイズする](/docs/ja/code-review-customize): `REVIEW.md` と `CLAUDE.md` で Claude が指摘する内容を変更する
* [Code Review のコストと使用量](/docs/ja/code-review-costs): レビューの課金方法と支出上限の設定場所
* [`/code-review` でローカルにレビューする](/docs/ja/code-review-local): Claude Code セッションからブランチのレビューを実行する
