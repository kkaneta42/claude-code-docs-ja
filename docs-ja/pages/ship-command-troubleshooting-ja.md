> ## Documentation Index
> Fetch the complete documentation index at: https://code.claude.com/docs/llms.txt
> Use this file to discover all available pages before exploring further.

# /ship と /steward のトラブルシューティング

> `/ship` や `/steward` のメッセージや症状を調べます。コマンドが見つからない、何もコミットやプッシュされない、ウォッチが開始しない、ウォッチが停止した、といったケースを扱います。

[`/ship`](https://code.claude.com/docs/ja/ship-command) は、変更の GitHub プルリクエストを作成し、Claude にレビューさせる Claude Code のコマンドです。その後、Claude はセッションからプルリクエストへの作業を続けます。この継続的な作業をウォッチと呼びます。`/steward` は、すでに作成済みのプルリクエストでウォッチを開始します。

最初の列で起きた事象を探すか、Claude Code が表示したメッセージの語句で検索してください。

| 起きたこと | 参照先 |
| :- | :- |
| `/ship` が `/` メニューにない、または Claude Code が認識しない | [セッションで /ship を使用できない](#%2Fship-isn’t-available-in-your-session) |
| コマンドを入力したところ、メッセージが表示されて開始しなかった | [/ship または /steward がメッセージを表示して開始しなかった](#%2Fship-or-%2Fsteward-printed-a-message-and-didn’t-start) |
| 実行されたが、何もコミットやプッシュされなかった | [/ship が何もコミットまたはプッシュしなかった](#%2Fship-committed-or-pushed-nothing) |
| プルリクエストは作成されたが、Claude がフォローアップしていない | [ウォッチが開始しなかった](#no-watch-started) |
| Claude がフォローアップしていたが、停止した | [ウォッチが停止した](#a-watch-stopped) |
| Claude のフォローアップ中にメッセージが表示された | [ウォッチ中のメッセージ](#messages-during-a-watch) |
| プルリクエストが期待どおりではない | [予期しないプルリクエストの結果](#pull-request-results-that-you-didn’t-expect) |
| カスタムの `/ship` または `/steward` コマンドが動作しなくなった | [カスタムの /ship または /steward コマンドが読み込まれなくなった](#a-custom-%2Fship-or-%2Fsteward-command-stopped-loading) |

## /ship または /steward が見つからない、または開始しない

コマンドが候補に表示されない場合や、メッセージが表示される場合は、ここから始めてください。

### セッションで /ship を使用できない

`/ship` が `/` メニューにない、入力すると `/code-review` が開始される、または `Unknown command: /ship` と表示される場合です。クラウドセッションには `/ship` がありません。

自分のマシンでは、次の手順を実行してください。

1. シェルで `claude update` を実行し、終了してから `claude` を再度起動します。
2. それでも `/ship` が表示されない場合は、もう一度終了して `claude` を起動します。新機能は[表示されるまでに 2 回目の起動が必要な場合がある](https://code.claude.com/docs/ja/env-vars.md#first-session-after-an-install-or-upgrade)ためです。
3. Claude Code のプロンプトで `/status` を実行します。その `Setting sources` 行には、読み込まれた設定が一覧表示されます。そのうち自分の[設定ファイル](https://code.claude.com/docs/ja/settings.md#find-or-create-your-settings-files)であるものそれぞれから、[`disableBundledSkills`](https://code.claude.com/docs/ja/settings-reference#disablebundledskills) と、[`skillOverrides`](https://code.claude.com/docs/ja/skills#override-skill-visibility-from-settings) の下にある `ship-local` エントリを削除します。管理設定を変更するには、管理者に依頼してください。
4. セッションが[機能フラグの取得をスキップしている](https://code.claude.com/docs/ja/env-vars.md#features-that-need-feature-flag-fetching)かどうかを確認します。サードパーティプロバイダー上、または Claude apps ゲートウェイのセッションでは、`/ship` には Claude Code v2.1.331 以降が必要です。それ以外のセッションでは、`DISABLE_TELEMETRY` など、取得をオフにする変数の設定をすべて解除します。
5. シェル内、または設定ファイルの `env` の下で [`CLAUDE_CODE_DISABLE_SHIP`](https://code.claude.com/docs/ja/env-vars#variables) が設定されているかどうかを確認します。設定を解除してから、終了して `claude` を再度起動します。この変数には Claude Code v2.1.331 以降が必要です。

### skillOverrides エントリが /ship または /steward をオフにしている

`Skill "ship-local" is disabled via skillOverrides`、または `steward` について同じメッセージが表示される場合は、設定内の [`skillOverrides`](https://code.claude.com/docs/ja/skills#override-skill-visibility-from-settings) エントリがコマンドをオフにしています。そのエントリを削除してください。管理設定内のエントリを変更するには、管理者に依頼してください。

### /ship または /steward がメッセージを表示して開始しなかった

メッセージの冒頭の語句を探してください。

| メッセージ | 対処方法 |
| :- | :- |
| `This session was started by another session` | 自分で開始したセッションで実行します |
| `Usage: /ship` または `Usage: /steward` | 入力した内容を[引数](https://code.claude.com/docs/ja/ship-command.md#arguments-for-%2Fship-and-%2Fsteward)と照らし合わせて確認します |
| `Nothing started. /ship starts only from a line that you type`、または `/steward` について同じメッセージ | Claude Code のプロンプトでコマンドを自分で入力します。`claude -p` やプログラムからは開始されません |
| `Nothing started. This line counts only if you type it yourself` | [プロンプトの提案](https://code.claude.com/docs/ja/interactive-mode.md#prompt-suggestions)を受け入れています。Claude Code のプロンプトでコマンドを自分で入力します |
| `Nothing started. Claude Code's built-in /ship is turned off while`、または `/steward` について同じメッセージ | `CLAUDE_CODE_DISABLE_SHIP` など、メッセージに示されている変数の設定を解除してから、Claude Code を再度起動します |
| `Nothing started. Claude Code's built-in /ship doesn't start in this kind of session`、または `/steward` について同じメッセージ | `claude -p` などの場所で入力しています。ターミナルで `claude` を実行し、そこでコマンドを入力します |
| `Nothing started. /ship is a command built into Claude Code`、または `/steward` について同じメッセージ | プラグインのコマンドなど、別のコマンドが同じ名前を持っています。組み込みコマンドを実行するには、同じ行をもう一度入力します。もう一方を実行するには、メッセージに従ってください。メッセージにはその名前、または見つける場所が示されています |
| `/ship didn't start:` または `/steward didn't start:` | メッセージの残りの部分に確認すべき内容が示されています。たとえば plan モードでは、`Shift+Tab` を押して plan モードを終了してから、コマンドを再度実行します |
| `/ship is turned off right now`、または `/steward` について同じメッセージ | メッセージに `/login` を実行するよう示されている場合は、Claude Code のプロンプトでそれを実行してから、コマンドを再度実行します。それ以外の場合、原因の 1 つとして、セッションの開始後に `CLAUDE_CODE_DISABLE_SHIP` が設定されたこと（たとえば設定ファイルの `env` の下で）が挙げられます。設定を解除し、終了して `claude` を再度起動してから、コマンドを実行します |
| `/ship can't start from a queued message` または `/steward can't start from a queued message` | Claude の処理が終わるまで待ってから、再度実行します |

### GitHub CLI の準備ができていない

`/ship` と `/steward` は、GitHub CLI である `gh` を通じて GitHub にアクセスします。

| メッセージ | 対処方法 |
| :- | :- |
| `GitHub CLI (gh) isn't installed` または `GitHub CLI (gh) isn't signed in` | インストールし、シェルで `gh auth login` を実行してから、コマンドを再度実行します |
| `gh couldn't tell me about a pull request here` | 括弧内の語句が失敗した内容を示しています。`gh` 自体のエラーを確認するには、シェルで `gh pr view` を実行します。原因の 1 つとして、チェックアウトのリモートがいずれも、`gh` がサインインしている GitHub ホスト上にないことが挙げられます。GitHub Enterprise の場合は、シェルで `gh auth login --hostname HOST` を実行します |
| `I can't watch the branch with git alone` | チェックアウトのリモートがいずれも、`gh` がサインインしている GitHub ホスト上にありません。GitHub Enterprise の場合は、シェルで `gh auth login --hostname HOST` を実行してから、コマンドを再度実行します。別のホストでは、コロンの後の語句に、先にブランチをプッシュするなど、修正すべき内容が示されています。[別のホスト上のブランチを監視する](https://code.claude.com/docs/ja/ship-command.md#watch-a-branch-on-another-host)を参照してください |

## /ship が何もコミットまたはプッシュしなかった

場合によっては、`/ship` はコミットやプッシュをユーザーに任せ、その理由を示します。メッセージは `Nothing committed or pushed`、`Nothing pushed`、`I didn't push anything`、`There is no pull request to watch`、`This branch has no open pull request` のいずれかで始まることがあります。GitHub 以外のホストでは、`/ship` は開始時にコミットもプッシュも行わないため、[別のホスト上のブランチをウォッチする](https://code.claude.com/docs/ja/ship-command.md#watch-a-branch-on-another-host)を参照してください。

該当するケースを探し、その行の手順を実行してから、`/ship` を再度実行してください。これらのケースでは、何もプッシュされず、ブランチにプルリクエストがない場合、Claude は変更をレビューしますが、[ウォッチは開始しません](#no-watch-started)。

### パブリックリポジトリと /ship がコミットしないファイル

`/ship` はコミットする前に、リポジトリと、変更された各ファイルの名前を確認します。

| ケース | 対処方法 |
| :- | :- |
| `For a public repository /ship doesn't commit anything for you` | デフォルトブランチ以外のブランチで、自分で作業をコミットします |
| `.env` や `password.txt` などの変更されたファイルについて、`By its name, this file may hold secrets` または `By their names, these files may hold secrets` | シークレットが含まれていない場合は、デフォルトブランチ以外のブランチで、自分で作業をコミットします。含まれている場合は、たとえばシェルで `git stash push -u -- <file>` を実行して退避させます |
| `.bashrc` や `.gitconfig` など、自分で作成していない空のファイルがメッセージに示されている | Linux と WSL2 では、サンドボックス化されたコマンドの実行中、[サンドボックス](https://code.claude.com/docs/ja/sandboxing.md)がチェックアウト内に空のファイルを保持します。サンドボックスはコマンドが終了するまでそれらを必要とするため、それまではスタッシュ、コミット、削除をしないでください。たとえば [`/tasks`](https://code.claude.com/docs/ja/commands#all-commands) からコマンドを停止するか、終了するまで待つと、サンドボックスがそれらを削除します。サンドボックス化されたコマンドが実行されていないのにファイルが残っている場合は、[残ったファイルを削除します](https://code.claude.com/docs/ja/errors.md#stale-sandbox-mask-files-left-by-a-killed-session) |
| `.gitignore`、`CLAUDE.md`、`.github/` 配下のファイルなど、git、CI、またはコーディングエージェントを設定するファイルを変更した | デフォルトブランチ以外のブランチで、自分で作業をコミットします |

### /ship がコミットまたはプッシュできないブランチ

`/ship` には、コミットとプッシュが可能なブランチが必要です。

| ケース | 対処方法 |
| :- | :- |
| `there is nothing here to open one for`: コミットされていない変更がなく、ブランチ上のすべてのコミットがすでにデフォルトブランチにあるか、それらをマージしてもデフォルトブランチに何も変化が生じない | 変更を加えるか、作業が含まれるブランチをチェックアウトします |
| `you're on the default branch, which /ship never pushes` | たとえばシェルで `git switch -c <branch>` を実行して、コミットを新しいブランチに移動します |
| detached HEAD 状態にある、またはリベースの途中である | ブランチをチェックアウトするか、リベースを完了します |

### コミットまたはプッシュを禁止する拒否ルール

`Bash(git push *)` などの[拒否ルール](https://code.claude.com/docs/ja/permissions.md#manage-permissions)により、コミット、プッシュ、またはプルリクエストの作成が禁止されることがあります。ルールを設定した人が同意する場合は、それらの手順を自分で実行してください。

ウォッチにも `git commit` と `git push` が必要です。ルールがそのいずれかを禁止している場合は、`/ship` を再度実行する前に[ルールを削除してもらってください](#a-tool-rule-or-hook-blocks-a-watch)。

### プルリクエストがすでに作成されている

次のようなメッセージは、`/ship` が新しい作業を作成済みのプルリクエストに含めなかったことを意味します。

| メッセージ | 意味 | 対処方法 |
| :- | :- | :- |
| `/ship didn't commit your uncommitted work` | 原因には、パブリックリポジトリ、自動マージが有効になっていること、マージまたはチェリーピックの途中であることなどがあります。[ウォッチを開始できない](#no-watch-started)場合、レビューはコミットされていない作業を対象にします。それ以外の場合、レビューはその作業を対象にせず、プッシュされていないコミットは [Claude の次回のプッシュで一緒にプッシュされることがあります](https://code.claude.com/docs/ja/ship-command.md#keep-working-while-a-watch-runs) | メッセージに `git push` の行が示されている場合は、自分で作業をコミットしてから、その行を実行します。示されていない場合は、メッセージで指示されたときに `/ship` を再度実行します |
| プッシュされていないコミットについての文を伴う `Nothing pushed` または `Nothing committed or pushed` | `/ship` がそれらのコミットを保留しました。レビューもウォッチも開始せず、そのプルリクエストで実行中のウォッチは終了します。原因の 1 つは、それらのコミットに `password.txt` のような名前のファイルが含まれていることです | コミットをプッシュすべき場合は、メッセージに示された `git push` の行を実行します。そうでない場合は、プッシュされていないすべてのコミットからそのファイルを取り除きます。その後、`/ship` を再度実行します |

v2.1.331 より前では、`/ship` はどちらのメッセージも表示しません。プルリクエストが作成された後は、コミットされていない作業をコミットしないため、自分でコミットしてから、シェルで `git push origin <branch>` のようにしてプッシュしてください。プッシュされていないコミットを保留することはなく、それらは [Claude の次回のプッシュで一緒にプッシュされることがあります](https://code.claude.com/docs/ja/ship-command.md#keep-working-while-a-watch-runs)。

### GitHub Enterprise とフォーク

`/ship` は、GitHub Enterprise 上やフォークからはプルリクエストを作成しません。ブランチをプッシュしてプルリクエストを自分で作成してから、`/ship` を実行してください。フォークからの場合、チェックアウトにはプルリクエストの送り先となるリポジトリのリモートも必要です。ない場合、ウォッチは開始しません。

## ウォッチが開始しなかった

ウォッチとは、プルリクエストに対する Claude の継続的な作業のことで、`/ship` のレビュー後、または `/steward` を入力したときに開始します。場合によってはウォッチが開始せず、Claude がその理由を示します。メッセージには `/steward didn't start.`、`I can't watch`、`is running on pull request` のいずれかが含まれることがあります。

原因を解消してから、`/steward` を入力して 2 回目のレビューなしでウォッチを開始します。GitHub 以外のホストでは、`/steward origin/main` のように、指定したベースがあればそれを追加します。GitHub 上のブランチにまだプルリクエストがない場合は、`/ship` を入力してください。

### プルリクエストまたはブランチがウォッチの準備ができていない

まず、プルリクエストとチェックアウトを確認してください。

| 原因 | 対処方法 |
| :- | :- |
| GitHub 上で、ブランチにプルリクエストがなく、`/steward` はプルリクエストを作成しない | [/ship が何もコミットまたはプッシュしなかった](#%2Fship-committed-or-pushed-nothing)を参照してください |
| プルリクエストのブランチがこのセッションでチェックアウトされていない | チェックアウトします |
| プルリクエストに `claude-pr-steward-watching` など、[PR Steward](https://code.claude.com/docs/ja/pr-steward.md) のラベルのいずれかが付いている | 引き継ぐには、Claude のメッセージに従って、ラベルを削除してブランチをプルします |

### セッションの設定がウォッチをブロックしている

セッションの一部の設定により、ウォッチが開始しないことがあります。

| 原因 | 対処方法 |
| :- | :- |
| セッションが `bypassPermissions` モードになっている | `Shift+Tab` を押して、plan モード以外の権限モードに切り替えます |
| [Remote Control](https://code.claude.com/docs/ja/remote-control.md) がオンになっている | `/rc` を実行し、**Disconnect this session** を選択します |
| `this session runs in the background` | ブランチを含むチェックアウトで新しいターミナルを開き、`claude` を実行して、そこで `/steward` を入力します |
| `entry 2 of 9 on your PATH is empty (a stray colon)` など、`on your PATH` のエントリに関するメッセージ | シェルのプロファイルと、`PATH` を設定している Claude Code の設定の `env` ブロックで、そのエントリを `PATH` から取り除くか、フルパスで記述します。Claude Code を終了し、新しいターミナルから再度起動してから、`/steward` を入力します |
| `your PATH has a relative or empty entry` | v2.1.331 より前では、プルリクエスト番号を指定しない `/ship` は変更をレビューしますが、コミット、プッシュ、プルリクエストの検索は行いません。末尾の `:`（Windows では `;`）など、空または相対のエントリを `PATH` から取り除きます。`claude` を再度起動してから、`/ship` を実行します |
| `PATH` にチェックアウト内のフォルダが含まれている。これは、たとえばチェックアウト内にある Python 仮想環境を有効化した場合や、`npx` やパッケージスクリプト経由で `claude` を起動した場合に発生します | そのフォルダなしでセッションを開始するには、仮想環境を使用している場合はシェルで `deactivate` を実行し、その後 `claude` を直接起動します |

### ツール、ルール、またはフックがウォッチをブロックしている

GitHub のプルリクエストに対するウォッチには `gh`、`git commit`、`git push` が必要です。また、プロジェクトのフックがコマンドを承認できる環境では開始しません。

| 原因 | 対処方法 |
| :- | :- |
| `gh` がインストールされていない、またはサインインしていない | [GitHub CLI の準備ができていない](#the-github-cli-isn’t-ready)を参照してください |
| `this gh is too old for a watch` | GitHub CLI を 2.63 以降に更新してから、`/steward` を入力します |
| 拒否ルールが、`git push` などウォッチに必要なコマンドを禁止している | Claude のメッセージに、そのコマンドとルールを含む設定が示されます。ルールを設定した人が同意する場合は、そこからルールを削除します。管理設定内のルールを変更するには、管理者に依頼してください |
| プロジェクトが、コマンドを承認できるフックを設定している。たとえば、チェックアウトの `.claude/settings.json` にあるシェルコマンドに対する `PreToolUse` または `PermissionRequest` [フック](https://code.claude.com/docs/ja/hooks.md)です | メッセージにファイル名と変更すべき内容が示されます |

### ウォッチを開始できないケース

次のケースでも、`/ship` は変更をレビューできます。

* ネイティブ Windows を使用している
* GitHub 上で、他の人がプルリクエストを作成した
* GitHub 上で、プルリクエストの送り先となるリポジトリにプッシュできず、かつ他の人がコメントまたはレビューをした。ウォッチの実行中にこれが発生した場合、ウォッチは終了します

## ウォッチが停止した

ウォッチとは、プルリクエストに対する Claude の継続的な作業のことで、`/ship` のレビュー後、または `/steward` を入力したときに開始します。ウォッチが終了したら、`Stopped watching` で始まる行を探してください。そこに理由が示されています。

ウォッチを再度開始するには、その行にコマンドが示されていれば、そのコマンドを入力します。ウォッチがまだ実行中かどうかを確認するには、Claude がアイドル状態のときに Claude Code のプロンプトで [`/tasks`](https://code.claude.com/docs/ja/ship-command#check-whether-a-watch-is-running) を入力します。

その行の「because」に続く語句を探してください。

| 理由 | 起きたこと |
| :- | :- |
| `the watch was cancelled`、または `its check-in was cancelled` | プロンプトで、または Claude の作業中に `Esc` または `Ctrl+C` を押したか、`/tasks` でタスクを停止しました。Claude のメッセージでは、プルリクエストに対する Claude の作業をチェックインと呼びます。`/tasks` の一覧を閉じるための `Esc` では、ウォッチは実行されたままです |
| `the watch couldn't go on` | Claude の返信に原因が示されている場合があります。原因の 1 つとして、プルリクエストのブランチがチェックアウトされなくなったことが挙げられます。開始したフォルダでブランチをチェックアウトしてから、ウォッチを再度開始します |
| `a watch doesn't carry over when a session is resumed` | ウォッチを実行していたプロセスが終了しました。たとえば、ターミナルを閉じた場合です。シェルで `claude --continue` を実行すると、会話は戻りますがウォッチは戻りません |
| `you moved to another session` | `/clear`、`/resume`、`/branch` によってこうなることがあります |
| `another loop took its place`、または `its check-ins were replaced` | `/loop` を開始しました |
| `your new command took over this session` | `/ship` または `/steward` を再度実行しました |
| `a deny rule now blocks a command that the watch runs`、または `a deny rule now forbids a command that the watch runs` | Claude Code のプロンプトで `/permissions` を入力してルールを確認します。[ツール、ルール、またはフックがウォッチをブロックしている](#a-tool-rule-or-hook-blocks-a-watch)を参照してください |
| `the watch reached its time limit` | 約 7 日が経過しました |
| `the watch stalled`、または `no next check-in was set` | 権限プロンプトの拒否、エラー、または使用制限によってこうなることがあります |
| `this session is in plan mode` | `Shift+Tab` を押して plan モードを終了してから、その行に示されたコマンドを入力します |
| `this session runs in the background` | ブランチを含むチェックアウトで新しいターミナルを開き、`claude` を実行して、その行に示されたコマンドを入力します |
| `you asked` | `/ship stop` または `/steward stop` を入力しました |
| `a file that gh, git, or /steward relies on changed` | [ウォッチが依存するファイルが変更された](#a-file-that-the-watch-relies-on-changed)を参照してください |
| `a file that git or /steward relies on changed` | [別のホスト上のウォッチ](https://code.claude.com/docs/ja/ship-command.md#watch-a-branch-on-another-host)での同じメッセージです。[ウォッチが依存するファイルが変更された](#a-file-that-the-watch-relies-on-changed)を参照してください |

2 つの文言が示されている行では、2 つ目が v2.1.331 より前の文言です。

`Nothing to stop. This session isn't watching a pull request`、または `No pull request is being watched in this session` は、`/ship stop` または `/steward stop` を入力したものの、実行中のウォッチがなかったことを意味します。上にスクロールして `Stopped watching` の行を探してください。

### ウォッチが依存するファイルが変更された

`gh`、`git`、または `/steward` が依存するファイルが何らかの理由で変更されると、ウォッチは終了します。対象となるのは次のようなファイルです。

* **Git の設定**: `git push -u`、`git branch -u`、`git remote add` によって変更されます。VS Code などのエディタも、リポジトリを開いたときやリポジトリに切り替えたときに、`.git/config` に設定を追加することがあります
* **`.claude/settings.local.json`**: 権限プロンプトに "Yes, and don't ask again" で回答すると、Claude Code がこのファイルに書き込みます

変更を確認してから、`Stopped watching` の行に示されたコマンドを入力してウォッチを再度開始してください。

何も変更していない場合、Linux と WSL2 での原因の 1 つとして、ウォッチ中に[サンドボックス化された](https://code.claude.com/docs/ja/sandboxing.md)コマンドが開始または終了したことが挙げられます。コマンドを停止するか、終了するまで待ってください。

## ウォッチ中のメッセージ

ウォッチ中、セッションには次のメッセージが表示されます。

| メッセージ、または表示される内容 | 対処方法 |
| :- | :- |
| `Claude Code did not run this`、または `Not run · permission denied` | Claude がある手順を試みましたが、[ウォッチの制限](https://code.claude.com/docs/ja/ship-command.md#what-claude-code-blocks-during-a-watch)、または自分のルールやフックのいずれかがそれを拒否しました。このメッセージは、ウォッチがすでに終了していた場合にも表示されます。Claude のメッセージでは、これらの制限を「the fence」と呼びます |
| `In this session there's a way around` の後に `the watch's limits`、`these limits`、または `my limits` が続くもの | ルール、フック、プラグイン、サンドボックスなど、セッション内の設定により、一部のコマンドが[ウォッチの制限](https://code.claude.com/docs/ja/ship-command.md#what-claude-code-blocks-during-a-watch)を通過できる状態です。メッセージの後に続くテキストでその設定が示されます。ルールを確認するには、Claude Code のプロンプトで `/permissions` を入力します。判断する間ウォッチを終了するには、`/steward stop` を入力します |
| `1 comment not read (no write access, or a bot that you haven't named)` などの行 | Claude が[コメントをスキップしました](https://code.claude.com/docs/ja/ship-command.md#what-claude-does-during-a-watch)。メッセージ内のリンクを開いて読んでください。Claude に読ませたい GitHub 上のボットの場合は、`/steward +botname` を入力します。同意できる人のコメントの場合は、変更すべき内容を Claude に伝えます |
| `gh couldn't say where the pull request's head and base stand` | Claude Code が Claude のプッシュの 1 つを拒否しました。`gh` 自体のエラーを確認するには、シェルで `gh pr view` を実行します。v2.1.331 より前では、原因の 1 つとして、GitHub CLI のバージョンが 2.63 より古いことが挙げられます。シェルで `gh --version` を実行して確認してください。更新してから、`/steward` を入力してウォッチを再度開始します |
| `←` を押すか `/background` を入力した後に表示される `A watch is on`、`The watch's limits still hold`、または `/ship is still starting`（`/steward` の場合も同様） | ウォッチ中、Claude Code はセッションをバックグラウンドに移動しません。移動するには、まずメッセージで示された手順を実行します。たとえば `/steward stop` を入力すると、ウォッチが終了します。v2.1.331 より前では、セッションは移動し、[ウォッチは終了します](https://code.claude.com/docs/ja/ship-command.md#when-a-watch-can-lead-to-a-merge) |
| セッション内の `Claude resuming /loop wakeup` または `/steward --tend` | ウォッチ中に Claude がプルリクエストを確認するときに、Claude Code がこれらを入力します。そのまま作業を続けて問題ありません |

## 予期しないプルリクエストの結果

`/ship` が実行され、GitHub 上またはリポジトリ内で予想外のことが起きた場合は、ここから始めてください。

| 表示される内容 | 理由と対処方法 |
| :- | :- |
| プルリクエストのタイトル、またはコミットメッセージが `Update greet.py and 1 more` のような行になっている | Claude がセッションの会話からそれを作成できない場合、たとえば変更について話し合っていないセッションでは、`/ship` はこの行にフォールバックします。GitHub でタイトルと説明を編集してください。次回は、変更を行ったセッションで `/ship` を実行するか、先にデフォルトブランチ以外のブランチで自分で作業をコミットしてください |
| 確認する前に、Claude がコミットをプッシュしたり、レビュアーに返信したりした | auto モードの場合や、ルールまたはサンドボックスがコマンドを許可している場合、ウォッチはそのように動作します。[先に Claude に確認させる](https://code.claude.com/docs/ja/ship-command.md#ask-claude-to-check-with-you-first)を参照してください |
| 新しいコミットされていない変更が、作成済みのプルリクエストに反映されなかった | [プルリクエストがすでに作成されている場合](#your-pull-request-is-already-open)を参照してください |
| `git pull` または `git push` がアップストリームブランチを求める | `/ship` はアップストリームを設定しません。`git push origin <branch>` のように、リモートとブランチを指定してください。アップストリームを設定すると git の設定が変更され、[実行中のウォッチが終了します](https://code.claude.com/docs/ja/ship-command.md#keep-working-while-a-watch-runs) |

## カスタムの /ship または /steward コマンドが読み込まれなくなった

これらのメッセージは、カスタムスキルまたはカスタムコマンドに関するものです。その名前は、`ship`、`ship-local`、`steward` など、組み込みコマンドが予約している名前です。

| メッセージ | 対処方法 |
| :- | :- |
| `Not loaded: a custom /ship` または `Not loaded: custom /ship, /steward` | 名前を変更してから、Claude Code を再起動してください |
| `Nothing started. A custom /ship isn't loaded`、または `/steward` についての同じメッセージ | 組み込みコマンドを実行するには、同じ行をもう一度入力してください。カスタムのものを実行するには、名前を変更してから、Claude Code を再起動してください |

リポジトリの `.claude/skills/steward/SKILL.md` はそのままにしておいてください。PR Steward とウォッチは、これを指示として読み込むためです。どちらのメッセージもこのファイルを対象としないため、`/steward` を示すメッセージは別のスキルまたはコマンドに関するものです。

### 名前を変更せずにカスタムの /ship または /steward を維持する

`/ship` または `/steward` という名前の独自のスキルまたはコマンドをすでに作成しており、組み込みバージョンでそれを上書きしたくない場合は、組み込みバージョンをオフにできます。そのためには、`CLAUDE_CODE_DISABLE_SHIP` 環境変数を使用します。この環境変数は両方をまとめてオフにし、Claude Code v2.1.331 以降が必要です。設定する前に、`skillOverrides` 内にあるそのコマンドの [`"off"` エントリをすべて削除](#a-skilloverrides-entry-turns-off-%2Fship-or-%2Fsteward)してください。

この [`env`](https://code.claude.com/docs/ja/settings-reference#env) エントリを[ユーザー設定ファイル](https://code.claude.com/docs/ja/settings.md#settings-files-and-who-they-affect)に追加するか、プロジェクトの最上位フォルダでセッションを開始するすべてのユーザーを対象にする場合はそのプロジェクトの `.claude/settings.json` に追加してから、Claude Code を再起動してください。

```json theme={null}
{
  "env": {
    "CLAUDE_CODE_DISABLE_SHIP": "1"
  }
}
```

コマンドが読み込まれたことを確認するには、Claude Code のプロンプトで `/` を入力し、その説明または最初の行を探してください。

コマンドの名前が `steward` で、リポジトリに `.claude/skills/steward/SKILL.md` ファイルがある場合は、[どちらが実行されるか](https://code.claude.com/docs/ja/skills.md#resolve-skills-that-share-a-name)を確認してください。

## 関連リソース

* [`/ship` と `/steward`](https://code.claude.com/docs/ja/ship-command): コマンドの機能、実行方法、ウォッチ中に Claude を制限する内容
* [権限モード](https://code.claude.com/docs/ja/permission-modes.md): auto モードとその他の権限モード
* [フック](https://code.claude.com/docs/ja/hooks.md): `PreToolUse` フックと `PermissionRequest` フック
