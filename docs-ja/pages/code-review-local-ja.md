> ## Documentation Index
> Fetch the complete documentation index at: https://code.claude.com/docs/llms.txt
> Use this file to discover all available pages before exploring further.

# /code-review でローカルにレビューする

> Claude Code セッションで `/code-review` を実行して、ブランチの変更に含まれるバグを見つけたり、レビュー対象をプルリクエストやパスに向けたり、Claude に修正を適用させたりします。

`/code-review` は、作業中のセッションで Claude Code のプロンプトに入力するコマンドです。Claude はブランチ上の変更をレビューし、正確性に関わるバグを探し、見つかった内容を会話内で報告します。モデルと effort レベルによっては、再利用、簡素化、効率化のためのクリーンアップもレビューの対象になります。

このコマンドはどのプランでも使用できます。レビューはユーザー自身のセッションで実行されるため、セッションの他の部分と同じように、プランの使用量または API の課金にカウントされます。

> [!NOTE]
>
> GitHub 上でリポジトリ内のすべてのプルリクエストを自動的にレビューするには、Owner が組織に対して有効にするマネージドサービスである [Code Review](https://code.claude.com/docs/ja/code-review.md) を参照してください。

`/review` は `/code-review` のエイリアスです。v2.1.223 より前は、`/review` は GitHub プルリクエストに対してシングルパスの読み取り専用レビューを実行する別のコマンドでした。

**1. /code-review を実行する**

次のコマンドを実行します。

```text theme={null}
/code-review
```

対象を指定しない場合、レビューは現在のブランチ上の変更を対象とします。代わりにプルリクエスト、別のブランチ、パス、またはコミットの範囲をレビュー対象にするには、[レビュー対象を選択する](#choose-what-to-review)を参照してください。

フラグを追加することもできます。

* `--fix`: レビュー後に、指摘事項を作業ツリーに適用するよう Claude に求めます。その編集は[権限モード](https://code.claude.com/docs/ja/permission-modes.md)に従います。
* `--comment`: 指摘事項を GitHub プルリクエストにはインラインコメントとして、[GitLab マージリクエスト](#post-findings-to-a-gitlab-merge-request)には単一のノートとして投稿します

**2. 作業を続ける**

レビューは独自のコンテキストウィンドウを持つバックグラウンドの[サブエージェント](https://code.claude.com/docs/ja/sub-agents.md)として実行されるため、会話を圧迫しません。指摘事項はレビューが完了すると会話に届きます。

**3. 指摘事項に対応する**

レビューで見つかった問題を修正するよう Claude に依頼します。`--fix` または `--comment` を指定した場合、Claude はレビューの一環として指摘事項を適用または投稿し、その編集の承認を求められることがあります。

## レビュー対象を選択する

現在のブランチ以外のものをレビューするには、effort レベルとフラグの後に対象を入力します。Claude はそのテキストをレビュー対象として受け取ります。対象には、プルリクエスト番号、ブランチ名、ファイルパス、または Git のリビジョン範囲を指定できます。レビューしたいものを 1 列目から探し、2 列目に示されている内容を入力してください。

| レビュー対象 | 入力内容 |
| :- | :- |
| 現在のブランチとコミットされていない変更 | `/code-review` |
| 直近 15 件のコミット | `/code-review HEAD~15..HEAD` |
| あるブランチと別のブランチの比較 | `/code-review main...my-feature` |
| 単一のコミット（`abc1234` はコミットのハッシュ） | `/code-review abc1234^..abc1234` |
| 番号で指定したプルリクエスト | `/code-review 1234` |
| ファイルまたはディレクトリのパス | `/code-review src/auth` |

対象を指定しない場合、`/code-review` はブランチのアップストリームブランチより先行しているコミットと、コミットされていない変更をレビューします。ブランチにアップストリームがない場合、Claude は `main` または 1 つ前のコミットと比較します。

`ultra` を指定した場合、[effort レベルとフラグの後のテキスト](#text-after-the-effort-level-and-flags)で説明しているように、Claude Code は対象を異なる方法で解釈します。

## レビューが読み取るものと編集するもの

レビューを実行する前に、特に `--fix` を使用する場合は、次の点を確認してください。

* **編集**: `--fix` を指定しない場合、レビューの指示は Claude にレポートのみを求めます。`--fix` を指定すると、指摘事項を作業ツリーに適用することも求めます。いずれの場合も、すべての編集は権限モードに従います。
* **巻き戻し**: バックグラウンドのレビューは、`--fix` による編集をセッションの[チェックポイント](https://code.claude.com/docs/ja/checkpointing.md#subagent-edits-not-restored)の外で適用します。その後に `/rewind` を実行しても、Claude がすでに会話内で編集していたファイルしか復元されません。レビューによる他のファイルへの編集は残るため、git を使用して元に戻してください。レビューが[フォアグラウンドで実行される](#run-in-the-foreground)場合は、ユーザー自身のターン中に作業ツリーを編集するため、`/rewind` で通常どおりその編集を復元できます。
* **指示**: レビューは、非対話の `-p` 実行を含め、`CLAUDE.md` に従います。`REVIEW.md` は読み取りません。このファイルは、GitHub プルリクエストに対するマネージドの [Code Review サービス](https://code.claude.com/docs/ja/code-review-customize.md#use-review-md-for-review-only-rules)を設定するものです。

## 指摘事項の報告方法

次のどちらの実行でも、Claude は指摘事項を応答内のテキストとして報告します。

* ターミナルセッション。この場合、`/code-review` はレビューを[フォークされたサブエージェント](https://code.claude.com/docs/ja/skills.md#run-skills-in-a-subagent)として実行します
* テキストまたは JSON 出力を使用する `-p` 実行

[デスクトップアプリ](https://code.claude.com/docs/ja/desktop.md#review-your-code)など、指摘事項のリストを要求するホストアプリケーションでは、Claude は代わりに [`ReportFindings` ツール](https://code.claude.com/docs/ja/tools-reference)を通じてレビューの指摘事項を報告します。レポートは指摘事項のリストとして表示され、各エントリにはファイルの場所、1 文の要約、そして指摘事項にカテゴリがある場合は `correctness` などのカテゴリタグが表示されます。ホストからの要求はすべての effort レベルに適用されます。

セッションの後半で Claude が報告済みの指摘事項を修正すると、Claude は再度それらを報告します。その後、Claude Code は更新された指摘事項のリスト内の各指摘事項を、修正済み、スキップ、または変更不要としてマークします。

## effort と引数を調整する

`--fix` と `--comment` のほかに、このコマンドは次のフラグを受け付けます。

* `--post`: `github.com` のプルリクエストに対する `ultra` クラウドレビューで、起動ダイアログにおいて完了した指摘事項を PR に投稿するオプションをあらかじめ選択します。[指摘事項をプルリクエストに投稿する](https://code.claude.com/docs/ja/ultrareview.md#post-findings-to-the-pull-request)を参照してください。Claude Code v2.1.227 以降が必要です。
* `--max-findings <n>`、`--max-findings all`、または `--max-findings default`: レビューの通常の上限の代わりに、最大 `n` 件の指摘事項、または `all` の場合はすべての指摘事項を報告します。レビューが指摘事項ツールを通じて報告する場合、上限は 32 件です。以降のレビューでは、`--max-findings default` を渡すまで入力した値が再利用されますが、非対話の `-p` 実行で渡した値は記憶されません。Claude Code v2.1.288 以降が必要です。

[effort レベル](https://code.claude.com/docs/ja/model-config.md#adjust-effort-level)を渡すと、網羅性と確信度のバランスを調整できます。`low` では、レビューは最も確信度の高い指摘事項を報告するため、誤検知が少なくなります。`medium` から `max` にかけて、レビューの網羅性が広がります。

レベルを入力しない場合、レビューは、以前のセッションであっても、最後に入力した `low` から `max` までのレベルを再利用します。Claude Code は `Reusing high effort, the level you typed last time` のような通知を表示します。実行時にどのレベルが使用されるかは、次のルールで決まります。

* **レベルを入力した場合**: `/code-review high` のように入力したレベルは、以降の実行で再利用されるレベルを変更します
* **非対話の実行**: 非対話の `-p` 実行で渡したレベルは、記憶されているレベルを更新しません
* **`ultra`**: レビューは記憶されているレベルを使用も更新もしません
* **一度もレベルを入力していない場合**: レビューはセッションの現在の effort を使用します

v2.1.223 より前は、レベルを指定しない `/code-review` は常にセッションの現在の effort を使用していました。

### 指摘事項を GitLab マージリクエストに投稿する

GitLab マージリクエストに対して `--comment` を渡すと、Claude Code は GitLab の `glab` CLI を通じて指摘事項を投稿します。Claude Code v2.1.257 以降が必要です。`glab` がインストールされていない場合、Claude は代わりにターミナルに指摘事項を出力します。

マージリクエストは URL または `!123` 形式の参照で渡してください。Claude Code が数字のみやブランチ名をマージリクエストとして扱うのは、チェックアウトの origin が `gitlab.com` にある場合のみです。セルフマネージドの GitLab インスタンスでは、URL または `!123` 形式を渡してください。

### effort レベルとフラグの後のテキスト

effort レベルとフラグの後、Claude Code は行の残りをレビュー対象として読み取ります。`ultra` 引数はこの解釈を変更します。

* **`ultra` を指定した場合**: Claude Code は単一の単語をベースブランチまたは PR 番号として読み取ります。ブランチや PR を指していない長いテキストは、[レビューに添付されるメモ](https://code.claude.com/docs/ja/ultrareview.md#pass-a-request-in-plain-words)になります。`/code-review ultra check my auth changes` は現在のブランチをレビューし、Claude は指摘事項をメモと関連付けます。
* **`ultra` を指定しない場合**: 残りはすべてレビュー対象になります。これは別のコマンド名で始まる場合も同様です。`/code-review /fix-issue 123` は、`/fix-issue` を 2 つ目の[スタックされたスキル](https://code.claude.com/docs/ja/skills.md#stack-several-skills-in-one-message)として読み込むのではなく、`/fix-issue 123` を対象テキストとしてレビューします。

## フォアグラウンドで実行する

レビューをフォアグラウンドで実行するには、次のいずれかを行います。

* `-p` フラグまたは Agent SDK を使用して、非対話モードで実行します。Claude Code はレビューを待機し、指摘事項を応答に含めます。ただし `ultra` は例外で、[クラウドレビューを待機しません](https://code.claude.com/docs/ja/ultrareview.md#run-ultrareview-non-interactively)。
* [`CLAUDE_CODE_DISABLE_BACKGROUND_TASKS`](https://code.claude.com/docs/ja/env-vars) を `1` に設定します。これにより、他のバックグラウンドタスク機能もオフになります
* 以前のレビューがまだ進行中の間に、`/code-review` を再度実行します

## Claude にレビューを開始させる

Claude は、ユーザーがコマンドを入力しなくても、自ら `/code-review` を開始できます。

* **自然な言葉で依頼した場合**: 変更をレビューするよう Claude に依頼すると、Claude はスキルを実行できます
* **スケジュールタスクから**: `/code-review` をプロンプトとする[セッションスコープのスケジュールタスク](https://code.claude.com/docs/ja/scheduled-tasks.md)はレビューを実行します

セッションスコープのスケジュールタスクが[クラウドレビュー](#escalate-to-ultrareview)を起動することはないため、`/code-review` は `ultra` 引数なしでスケジュールしてください。

`/code-review` をユーザーが入力できる状態に保ちつつ、Claude とスケジュールタスクの両方がレビューを開始しないようにするには、`~/.claude/settings.json` などの[設定ファイル](https://code.claude.com/docs/ja/settings.md#where-settings-live)に [`skillOverrides`](https://code.claude.com/docs/ja/skills#override-skill-visibility-from-settings) エントリを追加します。

```json theme={null}
{
  "skillOverrides": {
    "code-review": "user-invocable-only"
  }
}
```

v2.1.246 より前は、Claude が自ら `/code-review` を開始するのは、Anthropic から取得した機能フラグによって有効化されている場合のみでした。[機能フラグを取得しないセッション](https://code.claude.com/docs/ja/env-vars.md#features-that-need-feature-flag-fetching)では、`/code-review` はユーザーが入力した場合にのみ実行され、スケジュールされた `/code-review` はプレーンテキストとして Claude に届いていました。

## ultrareview にエスカレーションする

`/code-review ultra --fix` は、より詳細な [ultrareview](https://code.claude.com/docs/ja/ultrareview.md) をクラウドで実行し、その指摘事項がセッションに戻ってきた時点で、作業ツリーに適用するよう Claude に求めます。

ultrareview は独自のスコープを使用します。

* **比較対象**: 現在のブランチとリポジトリのデフォルトブランチの比較に加え、作業ツリー内のコミットされていない変更とステージされた変更
* **機密ファイル**: `.env` や `*.tfvars` ファイルなど、認証情報やキーのような名前のファイルに対するコミットされていない変更については、Claude Code は[ローカルリポジトリをクラウドセッションにアップロードする](https://code.claude.com/docs/ja/claude-code-on-the-web.md#send-local-repositories-without-github)際のルールに従います
* **別のベース**: 別のベースと比較するには、`/code-review ultra develop` のようにブランチ名を渡します

対象が `github.com` のプルリクエストである場合、完了した指摘事項を GitHub アカウントからのコメントとして [PR に投稿する](https://code.claude.com/docs/ja/ultrareview.md#post-findings-to-the-pull-request)よう Claude に指示できます。Claude Code v2.1.227 以降が必要です。

> [!NOTE]
>
> ultrareview には claude.ai アカウントでの認証が必要です。Amazon Bedrock、Google Cloud の Agent Platform、Microsoft Foundry では利用できず、Zero Data Retention が有効になっている組織や [HIPAA 構成](https://code.claude.com/docs/ja/hipaa-setup.md)が適用されている組織でも利用できません。これらの場合、`/code-review ultra` は代わりにセッション内でローカルレビューを実行します。[顧客管理の暗号化キー](https://platform.claude.com/docs/en/manage-claude/cmek)（CMEK）を使用する組織は ultrareview を実行できません。変更をローカルでレビューするには、`/code-review` を実行してください。

スクリプトや CI ジョブからクラウドレビューを実行するには、[`claude ultrareview` サブコマンド](https://code.claude.com/docs/ja/ultrareview#run-ultrareview-non-interactively)を使用します。このサブコマンドは指摘事項を待機し、stdout に出力します。

## レビューを変更する、またはレビューを基に構築する

`/code-review` は[バンドルスキル](https://code.claude.com/docs/ja/skills.md#bundled-skills)です。その指示は Claude Code に組み込まれているため、開いたり編集したりできる `SKILL.md` ファイルはディスク上にありません。すべてのレビューに従わせたいプロジェクトのルールがある場合は、`CLAUDE.md` に追加してください。さらに踏み込むには、次のいずれかのページから始めてください。

* **コマンドを置き換える**: `code-review` という名前のプロジェクトスキルまたは個人スキルは、バンドルされたスキルの代わりに実行され、`/review` エイリアスは引き続きバンドルされたレビューを実行します。[同じ名前を持つスキルを解決する](https://code.claude.com/docs/ja/skills.md#resolve-skills-that-share-a-name)を参照してください。
* **独自のレビュアーを構築する**: レビュアーの[サブエージェント](https://code.claude.com/docs/ja/sub-agents.md)またはレビュー用の[スキル](https://code.claude.com/docs/ja/skills.md)を作成します
* **関連するコマンドを使用する**: [`/simplify`](https://code.claude.com/docs/ja/commands) はクリーンアップのみを目的にレビューして修正を適用し、[`/verify`](https://code.claude.com/docs/ja/commands) はアプリを実行して変更が機能することを確認します

このコマンドは v2.1.147 より前は `/simplify` という名前で、デフォルトで修正を適用していました。バグを見つけるために `/simplify` をスクリプト化していた場合は、`/code-review --fix` に切り替えてください。

## 関連リソース

* [Code Review](https://code.claude.com/docs/ja/code-review.md): 組織の GitHub 上のすべてのプルリクエストをレビューするマネージドサービス
* [Ultrareview](https://code.claude.com/docs/ja/ultrareview.md): より詳細なクラウドレビューのセットアップ、制限、コスト
* [コマンド](https://code.claude.com/docs/ja/commands.md): `/code-review`、`/review`、`/simplify`、`/verify` の 1 行リファレンス
* [スキル](https://code.claude.com/docs/ja/skills.md): バンドルスキルの仕組みと独自のスキルの作成方法
