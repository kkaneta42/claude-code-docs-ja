> ## Documentation Index
> Fetch the complete documentation index at: https://code.claude.com/docs/llms.txt
> Use this file to discover all available pages before exploring further.

# プルリクエストで PR Steward を使用する

> PR Steward が GitHub のプルリクエストに追加するものを確認し、指示を与え、コメントやラベルで開始または停止し、ユーザーのために行う作業を制限します

[PR Steward](https://code.claude.com/docs/ja/pr-steward.md) は、PR Steward が有効になっているリポジトリで、ユーザーが作成した GitHub のプルリクエストを処理するエージェントです。レビューのフィードバックに対応するコミットをプッシュし、失敗しているチェックの修正やマージコンフリクトの解消を試みます。

[作業内容を指示する](#change-what-pr-steward-does)ことも、[自分のプルリクエストではオフにする](#turn-off-or-limit-pr-steward-on-all-your-pull-requests)こともできます。1 つのプルリクエストで停止するには、`claude-pr-steward-watching` ラベルを削除するか、`@claude stop` とコメントします。

## PR Steward がプルリクエストに追加するもの

github.com では、PR Steward は [Claude GitHub App](https://github.com/apps/claude) のアカウントである `claude[bot]` としてコメントを投稿します。

PR Steward はプルリクエストに次のラベル、コメント、コミットを追加します。

![PR Steward がプルリクエストに残すものの図：PR Steward が監視している間の claude-pr-steward-watching ラベル、最初に開始したときの Claude PR Steward という見出しのコメント、作業の前後の進捗コメント、Claude によるブランチへの通常のコミット。](https://mintcdn.com/claude-code/sMH7RDpTvyWlAkrg/images/pr-steward-pull-request.svg?fit=max\&auto=format\&n=sMH7RDpTvyWlAkrg\&q=85\&s=2c76cf9593743c0a05718e7a90c45796)

PR Steward はそれぞれを次のタイミングで追加します。

| PR Steward が追加するもの | タイミング |
| :- | :- |
| `claude-pr-steward-watching` ラベル | プルリクエストを監視している間 |
| `claude-pr-steward-is-working` ラベル | 作業している間 |
| **Claude PR Steward** という見出しのコメント | プルリクエストで最初に開始したとき |
| 進捗コメント | 作業の前後 |
| 作成者とコミッターが `Claude <noreply@anthropic.com>` のコミット | 修正をプッシュしたとき |

プッシュ後の進捗コメントには、[プッシュを元に戻す](#undo-a-fix-that-pr-steward-pushed)場合に revert するコミットが記載されます。

### 失敗したチェックの修正例

この例では、PR Steward が自動的に開始するリポジトリでプルリクエストを作成し、変更したコードのテストが失敗します。進捗コメントは Claude が書くため、文言は毎回異なります。

1. **PR Steward が開始する**：`claude-pr-steward-watching` ラベルを追加し、最初のコメントを投稿します。絵文字と冒頭の文言はプルリクエストごとに変わり、残りの部分は次のようになります。

   ```text wrap theme={null}
   🛠️ Claude PR Steward — On it. I'll chase down CI failures, work through review comments, and push fixes until it's green. Ask me anything in a comment and I'll answer or take action. I'll check for a steward skill at .claude/skills/steward/SKILL.md for any repo-specific behavior I should follow.

   Remove the claude-pr-steward-watching label any time to take over.

   React with 👍 or 👎 to provide feedback · Settings
   ```

2. **テストが失敗する**：PR Steward は `claude-pr-steward-is-working` ラベルを追加し、何をする予定かを伝えます。

   ```text wrap theme={null}
   The unit-tests check failed on test_parse_date. I'll find the cause and push a fix.

   – Claude PR steward · Settings
   ```

3. **PR Steward が修正をプッシュする**：PR Steward は、たとえば他のチェックがまだ実行中の場合など、プッシュする前に待機することがあり、その旨をコメントで伝えます。その後、`Claude <noreply@anthropic.com>` によるコミットがブランチに表示されます。2 つ目の進捗コメントで、何が変更されたか、どのように元に戻すかが説明されます。

   ```text wrap theme={null}
   Pushed a1b2c3d: parse_date now accepts a date with no time zone, which is the case that test_parse_date covers. To undo it, revert a1b2c3d, or remove the claude-pr-steward-watching label to stop me entirely.

   – Claude PR steward · Settings
   ```

4. **作業が終了する**：PR Steward は `claude-pr-steward-is-working` ラベルを削除し、プルリクエストの監視を続けます

## PR Steward の動作を変更する

PR Steward は、失敗したチェック、レビューコメント、ベースブランチの扱い方に関する[デフォルトの指示](#default-instructions-for-pr-steward)に基づいて動作を開始します。動作は、1 つのプルリクエスト、ユーザーが作成するすべてのプルリクエスト、またはリポジトリ全体に対して変更できます。

* **自分が作成した 1 つのプルリクエストに対して**：そのプルリクエストで [`@claude` で始まるコメントを書きます](#give-pr-steward-instructions-in-a-comment)
* **自分が作成するすべてのプルリクエストに対して**：claude.ai の設定で、[オフにするか制限する](#turn-off-or-limit-pr-steward-on-all-your-pull-requests)、[作業対象を選択する](#choose-what-pr-steward-works-on)、または[指示を入力します](#save-pr-steward-instructions-for-every-pull-request-you-open)
* **リポジトリ内の全員のプルリクエストに対して**：そのリポジトリの [`.claude/skills/steward/SKILL.md` にファイルを保存します](#save-pr-steward-instructions-for-everyone-in-a-repository)

### PR Steward のデフォルトの指示

PR Steward のデフォルトの指示は Claude への指示であるため、PR Steward が目指す動作を記述したものです。

ユーザーからの指示がない場合、PR Steward は次のようなデフォルトに従います。

| 作業 | デフォルトの動作 |
| :- | :- |
| 失敗したチェック | 失敗がプルリクエストで変更したコードにある場合に、修正してプッシュします |
| 不安定なチェック | テストが 1 つも実行される前にジョブが失敗した場合、または同じコミットで以前に成功していた場合に、失敗したジョブを 1 回再実行します |
| ベースブランチ | コンフリクトがある場合に、ベースブランチをユーザーのブランチにマージします。ユーザーのブランチが遅れている場合にもマージすることがあります |
| ロックファイルと生成ファイル | 再生成します |
| 名前の変更やテストの追加などの小さなレビューリクエスト | 変更をプッシュしてスレッドを解決します |
| 大規模なレビューリクエストや設計レベルのレビューリクエスト | 返信します。レビュアーが加えるべき変更を指定した場合を除き、プッシュもスレッドの解決も行いません |
| Code Review のオプションの指摘 | 返信してスレッドを解決します。これらの指摘だけのためにプッシュはしません |
| アプローチの選択 | 自分で 1 つを選び、どれを採用するかをユーザーに尋ねません |

リポジトリ内の全員のプルリクエストについてこれらのデフォルトの大部分を変更するには、そのリポジトリの [`.claude/skills/steward/SKILL.md` に指示を保存します](#save-pr-steward-instructions-for-everyone-in-a-repository)。

### コメントで PR Steward に指示を与える

自分が作成したプルリクエストで、`@claude` で始まるコメントを書き、してほしいことを伝えます。

次のコメントは、PR Steward に 1 種類の失敗だけを修正するよう求めています。

```text theme={null}
@claude only fix the lint failures. I'm still working on the tests.
```

### すべてのプルリクエストで PR Steward をオフにする、または制限する

claude.ai の **Settings > Code** または **Settings > Claude Code** にある [**PR Steward**](https://claude.ai/settings/claude-code#pr-steward) に移動し、自分が作成するプルリクエストで PR Steward がどこまで作業するかを選択します。この設定を変更するには、[GitHub アカウントの接続](https://code.claude.com/docs/ja/web-quickstart.md#connect-github)が必要です。

| オプション | ユーザーのプルリクエストでの PR Steward の動作 |
| :- | :- |
| **Off** | ユーザー自身が `claude-pr-steward-watching` ラベルを追加するか、`@claude steward` とコメントした場合にのみ開始します |
| **Only when tagged** | ユーザー自身または書き込みアクセス権を持つチームメイトが `claude-pr-steward-watching` ラベルを追加するか、`@claude steward` とコメントした場合にのみ開始します |
| **Act on its own** | Owner が [**Manual** に設定した](https://code.claude.com/docs/ja/pr-steward-setup.md#choose-when-pr-steward-starts-in-each-repository)リポジトリを含め、[対象となる各プルリクエスト](https://code.claude.com/docs/ja/pr-steward.md#when-pr-steward-starts)で開始します |
| **Customize** | 開始タイミングについては各リポジトリの設定に従います。[作業対象を選択します](#choose-what-pr-steward-works-on) |

オプションを選択する前は、設定ページでは **Act on its own** が選択された状態で表示されます。いずれかを選択するまで、PR Steward は各リポジトリの設定に従います。

PR Steward はプルリクエストで開始するときにユーザーの設定を読み込むため、変更はそれ以降の開始に適用されます。

### PR Steward の作業対象を選択する

自分が作成するすべてのプルリクエストについて PR Steward の作業対象を指定するには、設定のトグルを使用します。リポジトリの `.claude/skills/steward/SKILL.md` が異なる内容を指定している場合があるため、[どの指示が優先されるか](#which-pr-steward-instructions-take-priority)を確認してください。

1. claude.ai の **Settings > Code** または **Settings > Claude Code** にある [**PR Steward**](https://claude.ai/settings/claude-code#pr-steward) に移動します
2. **How much should Steward do on its own?** で [**Customize**](#turn-off-or-limit-pr-steward-on-all-your-pull-requests) を選択します
3. PR Steward にさせたくない項目ごとにトグルをオフにします。各トグルはオフにするまでオンのままです。
   * **Failing CI and merge conflicts**
   * **Issues found by Code Review and other review bots**
   * **Comments from human reviewers**
     * **Reply to reviewers and resolve their threads**（**Comments from human reviewers** がオンである必要があります）
   * **Include my draft PRs**

**Customize** を選択すると、設定は次のようになります。

![Customize が選択された PR Steward の設定。失敗した CI とマージコンフリクト、レビューボットの指摘、人間のレビュアーのコメント、レビュアーへの返信、ドラフト PR のスイッチと、ベースブランチからの更新のメニューが表示されています。](https://mintcdn.com/claude-code/sMH7RDpTvyWlAkrg/images/pr-steward-customize.png?fit=max\&auto=format\&n=sMH7RDpTvyWlAkrg\&q=85\&s=10695821d6e7766ee94cdb5706c1319f)

> [!NOTE]
>
> **Customize** は PR Steward の開始タイミングも変更します。各リポジトリの設定に従うようになります。以前に **Off** または **Only when tagged** を選択していた場合、PR Steward が自動的に開始するようになることがあります。

**Include my draft PRs** がオンの間、PR Steward は Owner がドラフトを含めるように設定したリポジトリで、ユーザーのドラフトを処理します。また、Owner が **Manual** に設定したリポジトリでも、誰かがドラフト上で依頼した場合は、ユーザーのドラフトを処理します。オフの間、PR Steward はユーザーのドラフトでは開始しません。

**Failing CI and merge conflicts** がオンの間は、PR Steward がベースブランチをユーザーのブランチにマージするタイミングも指定できます。**Updating my branch from the base branch** を **Whenever my branch falls behind**、**Only when there is a conflict**、または **Never, I update it myself** に設定します。

### 自分が作成するすべてのプルリクエスト向けに PR Steward の指示を保存する

自分が作成するすべてのプルリクエストで PR Steward に同じ指示を与えるには、claude.ai の **Settings > Code** または **Settings > Claude Code** にある [**PR Steward**](https://claude.ai/settings/claude-code#pr-steward) に移動します。**My instructions for Steward** に最大 1,000 文字を入力します。

次の指示は、小さなコミットを求め、レビュアーへの返信をしないよう求めています。

```text theme={null}
Keep commits small.
Don't reply to reviewers for me.
```

### リポジトリ内の全員向けに PR Steward の指示を保存する

リポジトリ内の全員に対する PR Steward の動作を設定するには、`.claude/skills/steward/SKILL.md` にファイルを保存し、デフォルトブランチにマージします。

この例では、PR Steward にどの作業を引き受けるか、また 1 つのファイルと 1 つの不安定なチェックをどう扱うかを指示しています。

```markdown theme={null}
---
name: steward
description: House rules for PR Steward in this repository
user-invocable: false
disable-model-invocation: true
---

- Work on failing checks, merge conflicts, and Important findings from Code Review.
- Leave comments from human reviewers to the author.
- Regenerate `package-lock.json` with `npm install`. Don't edit it directly.
- The `e2e-nightly` check is flaky. Re-run it once before you look for a cause.
```

PR Steward がこのファイルに従っていることを確認するには、次の手順を実行します。

1. ファイルがデフォルトブランチに反映された後、テスト用のプルリクエストを作成します。
2. `claude-pr-steward-watching` ラベルが自動的に表示されない場合は、`@claude steward` とコメントします。
3. ラベルが付いたら、チームメイトにレビューコメントを残してもらいます。

この例では人間のレビュアーのコメントを作成者に任せているため、PR Steward はそのレビューコメントに対して修正をプッシュしないはずです。

PR Steward は、リポジトリのルートにある `CLAUDE.md`、`.claude/CLAUDE.md`、`.claude/rules/`、`AGENTS.md` などのファイルからも指示を読み込みます。これらはデフォルトブランチから読み込まれます。

> [!NOTE]
>
> Claude Code の `/ship` コマンドと `/steward` コマンドも同じファイルを読み込みます。監視中、Claude は[チェックアウト内のコピーに従います](https://code.claude.com/docs/ja/ship-command.md#save-instructions-for-watches-in-a-repository)。

### どの PR Steward の指示が優先されるか

ユーザーの設定、リポジトリのファイル、ユーザーのコメントの内容が食い違うことがあります。PR Steward はそれを次のように解決します。

* **PR Steward が開始するかどうか**：[選択したオプション](#turn-off-or-limit-pr-steward-on-all-your-pull-requests)と [**Include my draft PRs**](#choose-what-pr-steward-works-on) は、PR Steward が指示を読み込む前に確認されます
* **開始後の PR Steward の動作**：ユーザー自身の設定とリポジトリの [`.claude/skills/steward/SKILL.md`](#save-pr-steward-instructions-for-everyone-in-a-repository) が食い違う場合は、そのファイルが適用されます。プルリクエスト上のユーザーのコメントはユーザー自身の設定を上書きし、PR Steward に停止や保留を求めるコメントはそのファイルも上書きします

## PR Steward を開始または停止する

1 つのプルリクエストで PR Steward を開始または停止するには、コメントまたはラベルを使用します。自分が作成するすべてのプルリクエストでオフにしたり制限したりするには、[設定を変更します](#turn-off-or-limit-pr-steward-on-all-your-pull-requests)。

### 1 つのプルリクエストで PR Steward を開始または停止する

プルリクエストで PR Steward を停止するには、`claude-pr-steward-watching` ラベルを削除するか、`@claude stop` とコメントします。

コメントで PR Steward を開始または停止するには、オープンなプルリクエストのトップレベルのコメントの先頭に、次のいずれかのコマンドを記述します。

| コメント | 動作 |
| :- | :- |
| `@claude stop` | PR Steward を停止します。コメント全体をこのコマンドだけにしてください |
| `@claude steward stop` または `@claude unwatch` | PR Steward を停止します |
| `@claude steward` | PR Steward を開始します |
| `@claude babysit`、`@claude watch`、`@claude babysit stop`、`@claude watch stop` | 開始コマンドと停止コマンドの別の表記 |

停止コマンドの後、PR Steward はラベルを削除し、コメントで停止を確認します。ユーザーがラベルを削除した場合は、コメントなしで停止します。

その後にプッシュやコメントをしても、PR Steward は停止したままです。再開するには、`@claude steward` とコメントするか、ラベルを再度追加します。開始しない場合は、[PR Steward がプルリクエストで開始しなかった](https://code.claude.com/docs/ja/pr-steward-troubleshooting.md#pr-steward-didn’t-start-on-a-pull-request)を参照してください。

### PR Steward がプッシュした修正を元に戻す

revert した後、PR Steward が同じ修正を再度行う可能性があるため、次の手順を順番に実行してください。

1. **PR Steward を止める**：[停止します](#start-or-stop-pr-steward-on-one-pull-request)。
2. **コミットを revert する**：`Claude <noreply@anthropic.com>` による不要なコミットを revert します。

### 最初から PR Steward をプルリクエストで動作させない

プルリクエストを作成するときに、説明に次のマーカーを含めます。

```html theme={null}
<!-- claude-pr-steward-disable -->
```

後でそのプルリクエストで PR Steward を開始するには、先にマーカーを削除します。

### PR Steward を開始および停止できるユーザー

PR Steward を開始または停止するには、リポジトリに対する次のアクセス権が必要です。

| 操作 | 実行できるユーザー |
| :- | :- |
| コメントで PR Steward を開始または停止する | リポジトリへの書き込みアクセス権を持つユーザー |
| `claude-pr-steward-watching` ラベルを追加して PR Steward を開始する | 書き込みアクセス権を持つユーザー |
| ラベルを削除して PR Steward を停止する | GitHub がラベルの削除を許可しているすべてのユーザー |

## 関連リソース

* [PR Steward](https://code.claude.com/docs/ja/pr-steward.md)
* [PR Steward のトラブルシューティング](https://code.claude.com/docs/ja/pr-steward-troubleshooting.md)
* [PR Steward がアクセスできるもの](https://code.claude.com/docs/ja/pr-steward-security.md)
* [PR Steward をセットアップする](https://code.claude.com/docs/ja/pr-steward-setup.md)
