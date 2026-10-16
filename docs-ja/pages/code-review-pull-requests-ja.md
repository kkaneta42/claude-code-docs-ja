> ## Documentation Index
> Fetch the complete documentation index at: https://code.claude.com/docs/llms.txt
> Use this file to discover all available pages before exploring further.

# プルリクエストのレビューを読む・リクエストする

> GitHub のプルリクエストで Code Review の指摘を読み、返信または却下し、`@claude review` でレビューをリクエストします。

Code Review は、Claude 組織の Owner が一連の GitHub リポジトリに対してオンにするマネージドサービスです。オンにすると、Claude はそれらのリポジトリのプルリクエストをレビューし、指摘をインラインコメント、レビュー本文のサマリー、そして **Claude Code Review** という名前のチェックランとして投稿します。レビューがプルリクエストを承認したりブロックしたりすることはなく、チェックランが失敗として終了することもありません。

Owner は、リポジトリごとに[レビューを実行するタイミング](/docs/ja/code-review-setup#set-when-reviews-run)と[レビューの詳細度](/docs/ja/code-review-setup#set-the-default-review-level)を制御します。

<Note>
  プランに Code Review が含まれていない場合でも、Claude Code セッションから Claude にブランチをレビューさせることができます。[`/code-review` でローカルにレビューする](/docs/ja/code-review-local)を参照してください。
</Note>

<h2 id="severity-levels">
  重大度レベル
</h2>

Claude は各指摘を該当する行へのインラインコメントとして投稿し、3 つの重大度レベルのいずれかでマークします。

| マーカー | 重大度 | 意味 |
| :- | :- | :- |
| 🔴 | Important | マージ前に修正すべきバグ |
| 🟡 | Nit | 軽微な問題。修正する価値はあるがブロックするほどではない |
| 🟣 | Pre-existing | コードベースに存在するが、この PR で導入されたものではないバグ |

レビューが推論を記録した場合、指摘には折りたたまれた **Why this was flagged** セクションがあります。これを展開すると、Claude がその問題を指摘した理由と、問題をどのように検証したかを読むことができます。

リポジトリで Claude が指摘する内容や重大度の判定方法を変更するには、[Code Review をカスタマイズする](/docs/ja/code-review-customize)を参照してください。

<h2 id="respond-to-findings">
  指摘に対応する
</h2>

リポジトリ独自のルールで求められていない限り、指摘に対応しなくてもマージできます。ブランチ保護で[会話の解決が必須](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-protected-branches/about-protected-branches#require-conversation-resolution-before-merging)になっている場合は、マージする前に各指摘のスレッドを解決してください。

指摘を解消するには、そのスレッドを解決するか、修正をプッシュします。

* **コードを変更せずに却下する**: GitHub 上で自分でスレッドを解決します。返信するだけでは指摘は却下されません。
* **問題を修正する**: コードを変更してプッシュします。プルリクエストの次のレビューは、問題が修正されたと判断した場合に以前のスレッドを解決します。これは、そのレビューがプッシュで自動的に実行された場合でも、リクエストによって実行された場合でも同じです。
* **説明する、または反論する**: コメントに返信します。Claude はすぐには応答せず、返信によってレビューが開始されることもありません。プルリクエストの次のレビューが以前の指摘への返信を読み、スレッドを解決するか、フォローアップの返信を 1 件投稿することがあります。同じ種類の指摘が繰り返し出る場合は、メンテナーに [`REVIEW.md`](/docs/ja/code-review-customize#choose-what-to-write-in-review-md) へのルール追加を依頼してください。

プッシュせずに次のレビューを実行するには、`@claude review` を[プルリクエストのトップレベルコメント](#comment-commands)として投稿します。

<h2 id="check-run-output">
  チェックランの出力
</h2>

**Claude Code Review** チェックランの **Details** リンクを開くと、GitHub がインラインコメントを受け付けなかった指摘も含め、すべての指摘が重大度順に並んだ 1 つの表で表示されます。

| 重大度 | ファイル:行 | 問題 |
| - | - | - |
| 🔴 Important | `src/auth/session.ts:142` | トークンのリフレッシュがログアウトと競合し、古いセッションがアクティブなまま残る |
| 🟡 Nit | `src/auth/session.ts:88` | `parseExpiry` が不正な入力に対して暗黙的に 0 を返す |

行情報があるもののインラインコメントとして投稿されなかった指摘は、**Files changed** タブの該当行にアノテーションとして表示されます。Important の指摘は赤、Nit は黄、既存のバグはグレーで表示されます。

チェックランは neutral として終了します。プッシュでファイルが変更されなかったために自動レビューが実行されなかった場合は skipped として終了します。失敗として終了することはないため、完了したレビューが必須チェックを失敗させることはありません。指摘が表示されない場合やレビューが実行されなかった場合は、[Code Review のトラブルシューティング](/docs/ja/code-review-troubleshooting)を参照してください。

<h3 id="read-the-result-from-a-script">
  スクリプトから結果を読む
</h3>

独自の CI でマージをゲートしたりサマリーを投稿したりするには、`gh` と jq を使って Details テキストの最終行を解析します。この行は機械可読なコメントになっています。

<Steps>
  <Step title="チェックラン ID を見つける">
    シェルからコミットのチェックランを一覧表示し、`Claude Code Review` ランの `id` を取得します。`OWNER` と `REPO` をリポジトリのオーナーと名前に、`<commit-sha>` をプルリクエストの head コミットに置き換えてください。

    ```bash theme={null}
    gh api repos/OWNER/REPO/commits/<commit-sha>/check-runs --jq '.check_runs[] | {id, name}'
    ```
  </Step>

  <Step title="重大度ごとの件数を読む">
    `CHECK_RUN_ID` を ID に置き換えて、そのチェックランから件数を読み取ります。

    ```bash theme={null}
    gh api repos/OWNER/REPO/check-runs/CHECK_RUN_ID \
      --jq '.output.text | split("bughunter-severity: ")[1] | split(" -->")[0] | fromjson'
    ```

    これにより、重大度ごとの件数を持ち、キーがアルファベット順に並んだ JSON オブジェクトが出力されます。例: `{"nit": 1, "normal": 2, "pre_existing": 0}`。件数には、スレッドがまだ未解決のままになっているプルリクエストの以前のレビューによる指摘も含まれます。
  </Step>

  <Step title="結果に基づいて処理する">
    スクリプトで次のケースを処理するようにします。

    * **`normal` が 0 より大きい**: マージをゲートしたい場合はジョブを失敗させます。`normal` キーには Important の指摘の件数が入っているため、Claude がマージ前に修正すべきバグを少なくとも 1 件見つけたことを意味します。
    * **行が存在しない**: 指摘 0 件ではなく、判定なしとして扱います。失敗した、タイムアウトした、キャンセルされた、または新しいレビューに置き換えられたレビューのチェックランにはこの行がなく、完了したレビューの中にもこの行がないものがあります。
  </Step>
</Steps>

<h2 id="request-a-review">
  レビューをリクエストする
</h2>

プルリクエストがドラフトである場合やフォークからのものである場合、自動レビューはスキップされるため、[コメントコマンドでレビューをリクエスト](#review-drafts-and-pull-requests-from-forks)してください。プルリクエストのレビューを受けるには、次のいずれかを行います。

* **オープンする、または ready にする**: **Once after PR creation** または **After every push** に設定されたリポジトリでは、プルリクエストをオープンまたは再オープンしたとき、あるいはドラフトを ready for review にしたときにレビューが開始されます。
* **コマンドをコメントする**: プルリクエストに [`@claude review`](#comment-commands) を投稿します。
* **コミットをプッシュする**: **After every push** に設定されたリポジトリ、または `@claude review always` でサブスクライブしたプルリクエストでは、プッシュによってレビューが開始されます。
* **Re-run をクリックする**: フォークからではないプルリクエストでレビューが失敗またはタイムアウトした場合は、チェックランから[再実行](/docs/ja/code-review-troubleshooting#retrigger-a-failed-or-timed-out-review)します。
* **自動再試行を待つ**: セッションが中断されたレビューは、自動的に 1 回再試行されます。再試行が行われている場合は、[チェックランのサマリー](/docs/ja/code-review-troubleshooting#retrigger-a-failed-or-timed-out-review)にその旨が表示されます。

<h3 id="comment-commands">
  コメントコマンド
</h3>

次のいずれかのコマンドをプルリクエストへのコメントとして投稿します。

| コマンド | 動作 | 使用するタイミング |
| :- | :- | :- |
| `@claude review` | 今後のプッシュに PR をサブスクライブせずに、1 回だけレビューを開始する | 今すぐ 1 回レビューしたい場合。たとえば Manual に設定されたリポジトリのプルリクエストや、他のモードですぐにもう一度レビューしたい場合 |
| `@claude review always` | レビューを開始し、以降はプッシュでトリガーされるレビューに PR をサブスクライブする | 以降のプッシュごとに新しいレビューを開始したい場合。たとえば Manual に設定されたリポジトリの優先度の高い PR |
| `@claude review once` | `@claude review` と同じ: サブスクライブせずに 1 回だけレビューを開始する | `@claude review` と同じケース |

これらのコマンドでレビューを開始するには、次の条件をすべて満たす必要があります。

* 新しいプルリクエストのトップレベルコメントとして投稿すること。差分の行へのインラインコメントやレビュー本文では機能しません。以前のコメントを編集しても対象になりません。
* コマンドをコメントの先頭に置き、`always` をコマンドの他の部分と同じ行に書くこと。大文字と小文字は区別されません。
* リポジトリに対する write、maintain、または admin 権限を持っていること。Claude はコメントした各ユーザーについて GitHub でこれを確認し、ボットからのコメントではレビューは開始されません。
* プルリクエストがオープンであること。

コマンドが受け付けられると、**Code review queued...** というタイトルの **Claude Code Review** チェックランがプルリクエストに表示されます。レビューが開始されると、タイトルは **Code review in progress...** に変わります。Claude がコメントに 👀 でリアクションすることもありますが、このリアクションはレビューが開始されない場合にも表示されることがあるため、代わりにチェックランを確認してください。

プルリクエストの最新コミットですでにレビューが実行中の場合、新しいリクエストによって 2 つ目のレビューが開始されることはありません。

<Note>
  2026 年 7 月のアップデート以前は、`@claude review` によって PR がプッシュでトリガーされるレビューにサブスクライブされていました。その動作に依存していた場合は、代わりに `@claude review always` をコメントしてください。
</Note>

<h3 id="what-a-later-review-covers">
  以降のレビューの対象範囲
</h3>

プッシュ後など、自動的に開始される以降のレビューは、前回のレビュー以降に変更された部分に焦点を当て、Nit や既存の問題の指摘を少なく投稿します。そのサマリーには、除外した件数が "found and not posted" または "outside the scope of this re-review and not posted." で終わる行に記載されます。

これらを何も除外しないレビューを受けるには、[`@claude review`](#comment-commands) をコメントしてください。プルリクエスト全体が改めてレビューされます。

<h3 id="review-drafts-and-pull-requests-from-forks">
  ドラフトとフォークからのプルリクエストをレビューする
</h3>

自動レビューはこれらの両方をスキップするため、コメントコマンドでレビューをリクエストしてください。

* **ドラフトのプルリクエスト**: コメントコマンドはドラフトでも実行されるため、プルリクエストを ready にする前にレビューをリクエストできます。ドラフトへのプッシュでは、`@claude review always` の後でもレビューは開始されません。サブスクリプションは、プルリクエストを ready にした時点で有効になります。
* **フォークからのプルリクエスト**: リポジトリの **Review runs** 設定にかかわらず、Claude はフォークからのプルリクエストを自動的にはレビューしません。レビューを開始するには、プルリクエストに `@claude review` をコメントします。[コメントコマンドの条件](#comment-commands)は引き続き適用され、必要な書き込み権限はフォークではなくベースリポジトリに対するものです。

フォークからのプルリクエストでも `@claude review always` は機能しますが、以降のプッシュでのレビューにプルリクエストがサブスクライブされることはありません。また、そこではチェックランの **Re-run** をクリックしてもレビューは開始されません。

<h3 id="use-code-review-alongside-the-claude-code-github-action">
  Claude Code GitHub Action と併用する
</h3>

リポジトリで [Claude Code GitHub Action](/docs/ja/github-actions) もデフォルトの `@claude` トリガーフレーズを使ったインタラクティブモードで実行している場合、`@claude review` コメントによって Action も開始されます。2 つを区別するには、Action の `trigger_phrase` 入力を別のフレーズに設定してください。

<h2 id="related-resources">
  関連リソース
</h2>

* [Code Review のトラブルシューティング](/docs/ja/code-review-troubleshooting): 開始されなかった、失敗した、または予算のためにスキップされたレビュー
* [Code Review](/docs/ja/code-review): サービスの概要とレビューの実行方法
* [Code Review をセットアップする](/docs/ja/code-review-setup): Owner 向け。Code Review をオンにし、レビューを実行するタイミングとレベルを選択する
* [Code Review をカスタマイズする](/docs/ja/code-review-customize): `REVIEW.md` と `CLAUDE.md` で Claude が指摘する内容を変更する
* [Code Review のコストと使用量](/docs/ja/code-review-costs): レビューの課金方法と支出上限の設定場所
* [`/code-review` でローカルにレビューする](/docs/ja/code-review-local): Claude Code セッションからブランチのレビューを実行する
