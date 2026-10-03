> ## Documentation Index
> Fetch the complete documentation index at: https://code.claude.com/docs/llms.txt
> Use this file to discover all available pages before exploring further.

# worktree を使用して並列セッションを実行する

> 並列 Claude Code セッションを個別の git worktree に分離して、変更が衝突しないようにします。`--worktree` フラグ、サブエージェントの分離、`.worktreeinclude`、クリーンアップ、および非 git VCS フックについて説明します。

[git worktree](https://git-scm.com/docs/git-worktree) は、独自のファイルとブランチを持つ別の作業ディレクトリであり、メインのチェックアウトと同じリポジトリ履歴とリモートを共有します。各 Claude Code セッションを独自の worktree で実行すると、1 つのセッションでの編集が別のセッションのファイルに触れることはないため、1 つのセッションで機能を構築しながら、2 つ目のセッションでバグを修正できます。

<Note>
  worktree には git リポジトリが必要です。その他のバージョン管理システムについては、[git のロジックを置き換えるフックを設定](#non-git-version-control)してください。[デスクトップアプリ](/docs/ja/desktop#work-in-parallel-with-sessions)では、セッションの開始時に **worktree** オプションを選択すると、そのセッション専用の worktree が作成されます。
</Note>

worktree は Claude を並列で実行するいくつかの方法の 1 つで、ファイル編集を分離します。[サブエージェント](/docs/ja/sub-agents)は 1 つのセッション内で作業を分割し、[セッション間メッセージング](/docs/ja/cross-session-messaging)を使用すると、Claude は worktree 内のセッション間で調査結果を受け渡せます。アプローチを比較するには [エージェントを並列で実行する](/docs/ja/agents) を参照するか、worktree とサブエージェントを一緒に使用するには [worktree でサブエージェントを分離する](#isolate-subagents-with-worktrees) に進んでください。

ほとんどのセッションで必要なのは最初の 2 つのセクションだけです。[worktree で Claude を開始](#start-claude-in-a-worktree)し、[終了時にクリーンアップ](#clean-up-worktrees)します。[セッションを再開する](#resume-a-worktree-session)、[worktree の作成方法を変更する](#customize-worktree-creation)、または[失敗をデバッグする](#troubleshooting)必要がある場合は、このページの残りの部分に戻ってください。

<h2 id="start-claude-in-a-worktree">
  worktree で Claude を開始する
</h2>

`--worktree` または `-w` に名前を付けて渡すと、分離された worktree を作成し、その中で Claude を開始します。デフォルトでは、worktree はリポジトリルートの `.claude/worktrees/<name>/` の下に、`worktree-<name>` という名前の新しいブランチ上に作成されます。

```bash theme={null}
claude --worktree feature-auth
```

別のターミナルで異なる名前を使用してコマンドを再度実行すると、2 つ目の分離されたセッションを開始できます。名前を省略すると、Claude は `bright-running-fox` などの名前を生成します。

対話実行には[ワークスペースの信頼](/docs/ja/security)が必要です。そのディレクトリでこれまで Claude を実行したことがない場合は、そこで `claude` を 1 回実行して信頼ダイアログを受け入れてください。そうしないと、`--worktree` はエラーで終了し、それを行うよう求めます。`-p` を使用した非対話実行は信頼チェックをスキップするため、`claude -p --worktree` はそれなしで進行します。

<Tip>
  `.claude/worktrees/` を `.gitignore` に追加して、worktree の内容がメインのチェックアウトで追跡されていないファイルとして表示されないようにします。
</Tip>

<h3 id="set-up-the-worktree-environment">
  worktree の環境をセットアップする
</h3>

worktree は新しいチェックアウトなので、そこで開発環境を初期化してください。Claude に依存関係のインストールを依頼するか、`.claude/worktrees/` の下の worktree ディレクトリでプロジェクトのセットアップを自分で実行します。`.env` などの gitignore されたファイルをすべての新しい worktree に自動的に持ち込むには、[`.worktreeinclude` ファイル](#copy-gitignored-files-into-worktrees)を追加します。

<h3 id="ask-claude-to-create-a-worktree">
  Claude に worktree の作成を依頼する
</h3>

セッション中に Claude に「worktree で作業する」と指示することもでき、Claude は [`EnterWorktree`](/docs/ja/tools-reference) ツールを使用して worktree を作成します。worktree に入ると、Claude はターゲットパスを指定して `EnterWorktree` を呼び出すことで、`.claude/worktrees/` の下の別の worktree に直接切り替えることができます。前の worktree はディスク上に変更されずに残ります。

Claude がリポジトリの `.claude/worktrees/` ディレクトリの外のパスに入る場合、Claude Code は最初に承認を求めます。この移動により、セッションの作業ディレクトリ、書き込みアクセス、および `CLAUDE.md` や設定などのプロジェクト設定がその場所に移るためです。`EnterWorktree` の[権限ルール](/docs/ja/permissions)や「今後は確認しない」の選択ではこのプロンプトは抑制されず、`bypassPermissions` モードのみがスキップします。v2.1.206 より前は、Claude は既存の任意の worktree パスに確認なしで入ることができました。

<Note>
  **フックのパスは worktree に追従しません。** Claude が worktree に入った後も、Claude Code は[フック](/docs/ja/hooks#reference-scripts-by-path)内の `${CLAUDE_PROJECT_DIR}` を元の場所のままにし、worktree のパスは別の方法でフックに渡します。

  * **`${CLAUDE_PROJECT_DIR}` は変わらない**: セッションが開始されたプロジェクトルートを引き続き指すため、`${CLAUDE_PROJECT_DIR}/.claude/hooks/check-style.sh` などのフックコマンドは引き続きメインチェックアウト内のスクリプトを実行します。
  * **`cwd` は Claude に追従する**: フックの[入力 JSON](/docs/ja/hooks#common-input-fields) の `cwd` フィールドは worktree のルートであり、Claude が `cd` を実行すると再び移動します。フックが worktree のパスを必要とする場合はこれを読み取ります。
</Note>

<h2 id="clean-up-worktrees">
  worktree をクリーンアップする
</h2>

対話的な worktree セッションを終了すると、Claude は削除によって失われる作業がないか worktree を確認します。対象は、変更されたファイルや追跡されていないファイル、チェックアウトされたサブモジュール内のコミットされていない作業、および新しいコミットです。これらのルールは、Claude が git で作成した worktree に適用されます。[WorktreeCreate フック](/docs/ja/hooks#worktreecreate)が作成した worktree については、代わりに [WorktreeRemove](/docs/ja/hooks#worktreeremove) を参照してください。

* **worktree がクリーンな場合**: 名前のないセッションでは、Claude は worktree とそのブランチを自動的に削除します。[名前付き](/docs/ja/sessions#name-your-sessions)セッションでは最初にプロンプトが表示されるため、後で使用するために worktree を保持できます
* **worktree に作業が含まれている場合**: Claude は worktree を保持するか削除するかを求めるプロンプトを表示します。保持するとディレクトリとブランチが保存されます。後で戻るには、Claude Code が終了時に出力する `claude --worktree <name> --resume` コマンドを実行します。削除すると worktree ディレクトリとそのブランチが、その中のすべての作業とともに削除されます
* **worktree の状態を検証できない場合**: Claude Code が worktree の変更をカウントできない、またはサブモジュールのチェックアウトを検査できない場合、worktree を自動的に削除するのではなくプロンプトを表示します。プロンプトには確認できなかった内容が示されます

`-p` を使用した非対話実行には終了プロンプトがないため、Claude はその worktree をクリーンアップしません。また Claude Code は、作成時に各 worktree に設定したロックを、後続のセッションの[古いロックのスイープ](#clean-up-subagent-and-background-session-worktrees)が解放するまでそのまま残します。削除するには `git worktree remove` を実行します。worktree がロックされているために git が拒否した場合は、先にその worktree に対して `git worktree unlock` を実行してください。

Windows では、worktree を削除しても worktree 外のファイルは削除されません。worktree 内のフォルダーが NTFS ジャンクションやディレクトリのシンボリックリンクなど、別の場所へのリンクである場合、Claude Code はリンクのみを削除し、リンク先のフォルダーは保持します。v2.1.205 より前は、サブディレクトリにネストされたリンクを含む worktree を削除すると、リンク先のフォルダーが削除される可能性がありました。

<h2 id="resume-a-worktree-session">
  worktree セッションを再開する
</h2>

worktree 内で[終了](#clean-up-worktrees)せずに終わったセッションを再開すると、Claude Code はセッションをその worktree に戻します。これは対話的な再開、`-p` を使用した[非対話モード](/docs/ja/headless)での `--continue` と `--resume`、および Agent SDK に当てはまります。`--continue` は、起動したディレクトリの下に記録されている最新のセッションを選択します。worktree 内に戻った後も、Claude は [`ExitWorktree`](/docs/ja/tools-reference) ツールで worktree を終了できます。

セッションを worktree に戻す前に、Claude Code は worktree がメインのチェックアウトとは別のチェックアウトのままであることを検証し、チェックに失敗した worktree への再入を拒否します。git worktree の場合、チェックはその git メタデータを読み取ります。[`WorktreeCreate` フック](#non-git-version-control)が作成したものなど、git メタデータを持たない worktree はチェックに合格する場合があります。Claude Code が引き続き拒否するケースは、その回復方法とともに [Claude Code が worktree の使用を拒否する](#claude-code-refuses-to-use-a-worktree) に記載されています。メッセージとそれぞれからの回復方法については、[セッションが worktree の外で再開される](#the-session-resumes-outside-its-worktree) を参照してください。

起動する場所と再開の方法によって、Claude Code が再入する対象が変わります。

* **起動ディレクトリ**: メインのチェックアウトまたはリポジトリの別のディレクトリから `--resume` で再開します。Claude Code は、`.claude/worktrees/` の下に git で作成した worktree には、その内部から起動した場合でも再入します。その他の worktree の内部から起動した場合、Claude Code はそこからその worktree が安全であると確認できる場合にのみ再入します。独自のリポジトリである worktree、git メタデータを持たない worktree、または `git worktree add` で作成した worktree のサブディレクトリからの起動は拒否されるため、これらはメインのチェックアウトから起動してください。
* **`--fork-session`**: フォークされたセッションは Claude を起動したディレクトリで開始され、Claude Code は元のセッションの worktree に手を加えません。
* **削除された worktree**: worktree ディレクトリが存在しなくなった場合、Claude Code は Claude を起動したディレクトリでセッションを再開します。worktree がなくなったことを通知し、セッションの worktree バインディングをクリアします。

<Note>
  v2.1.212 より前は、非対話的な再開は開始ディレクトリにとどまり、`ExitWorktree` は終了するアクティブな worktree セッションがないと報告していました。
</Note>

Claude Code が git で作成した worktree に Claude が入るか出ると、トランスクリプトもそれに追従します。Claude Code は [`/cd`](/docs/ja/commands) と同じ方法で、セッションの新しい作業ディレクトリの下にセッションを記録するため、`/desktop` と `--resume` はそこでセッションを見つけます。終了すると同じ方法で元に戻ります。[`WorktreeCreate` フック](#non-git-version-control)によって作成された worktree は、トランスクリプトを起動ディレクトリに保持します。Claude Code v2.1.198 以降が必要です。

<h2 id="how-claude-code-enforces-isolation">
  Claude Code が分離を強制する仕組み
</h2>

セッションが worktree 内で分離されている間、Claude Code は以下のチェックで定義されるツール呼び出しをブロックします。セッションを `--worktree` で開始した場合も、Claude が `EnterWorktree` で worktree に入った場合も、worktree セッションを再開した場合も、同じルールが適用されます。

分離されたセッションから Claude が生成するすべてのサブエージェントにも同じ強制が適用されます。これはセッションが対話的な場合でも、[バックグラウンド](/docs/ja/agent-view#how-file-edits-are-isolated)で実行される場合でも適用されます。[独自の worktree で実行されるサブエージェント](#isolate-subagents-with-worktrees)にも同じチェックが適用されます。そのバージョン履歴は [サブエージェントファイルの書き込み](/docs/ja/sub-agents#write-subagent-files) にあります。

Claude Code は 4 つのチェックを適用します。

* **ファイル編集**: Claude Code は、メインチェックアウト内のパスを対象とする `Edit`、`Write`、または `NotebookEdit` をブロックします。
* **コマンドの作業ディレクトリ**: Claude Code は、作業ディレクトリがメインチェックアウトに解決される Bash、PowerShell、または Monitor コマンド、あるいは作業ディレクトリがメインチェックアウトの外にとどまることを検証できないコマンドをブロックします。
* **Git のリダイレクト**: Claude Code は、git をメインチェックアウトにリダイレクトする Bash または Monitor コマンドをブロックします。リダイレクトは、`git -C`、`--git-dir`、`GIT_DIR` または `GIT_WORK_TREE` 変数、あるいは git を実行する前のメインチェックアウトへの `cd` によって発生する可能性があります。
* **コマンドの形式**: Claude Code は、コマンドが実行する git が worktree 内にとどまることをコマンドテキストから検証できない場合、Bash または Monitor コマンドをブロックします。これは、たとえばコマンド名が実行時に計算される場合、構文を解析できない場合、または `${!name}` や `${ command; }` などの展開がテキストに明記されていないコマンドを実行する可能性がある場合に発生します。Claude Code は、拒否されたコマンドを単純な個別のコマンドに分割するなど、書き直す方法を Claude に伝えます。このチェックをオフにすることはできません。

チェックは、Claude Code を起動したリポジトリに適用されます。リンクされた worktree のリンク元であるメインチェックアウトも対象になります。PowerShell コマンドについては、Claude Code は作業ディレクトリのチェックのみを適用します。

Claude は各拒否を、worktree の名前と続行方法を示すツールエラーとして受け取ります。拒否されたコマンドについては、[拒否メッセージの意味とその解消方法](/docs/ja/errors#command-blocked-by-the-worktree-isolation-checks) を参照してください。

<h2 id="isolate-subagents-with-worktrees">
  worktree でサブエージェントを分離する
</h2>

サブエージェントは独自の worktree で実行できるため、並列編集が競合しません。Claude に「エージェントに worktree を使用する」と指示するか、[カスタムサブエージェント](/docs/ja/sub-agents#supported-frontmatter-fields)のフロントマターに `isolation: worktree` を追加して分離を永続化します。

`.claude/agents/` 内のこのサブエージェントは、常に独自の worktree で実行されます。

```markdown theme={null}
---
name: refactorer
description: Applies mechanical refactors across many files
isolation: worktree
---

Apply the requested refactor across every affected file, then run the tests
and report the results.
```

各サブエージェントは一時的な worktree を取得し、サブエージェントが変更なしで完了すると Claude Code がそれを自動的に削除します。変更を含む worktree は、[以下の定期スイープ](#clean-up-subagent-and-background-session-worktrees)が作業を失わずに削除できるようになるまでディスク上に残ります。

サブエージェントの worktree は `--worktree` と同じ[ベースブランチ](#choose-the-base-branch)を使用するため、`worktree.baseRef` が `"head"` に設定されていない限り、リポジトリのデフォルトブランチからブランチします。

独自の worktree で実行されるサブエージェントは、[起動時に読み込む](/docs/ja/sub-agents#what-loads-at-startup)指示ファイルを、その worktree からではなくメインの会話から取得します。その worktree が `.claude/worktrees/` 配下のデフォルトの場所にある場合、サブエージェントは worktree 内のファイルを読み取る際にも、worktree のルートにある `CLAUDE.md` ファイルや `.claude/rules/` ディレクトリを読み込みません。これらが worktree のブランチ上で異なっている場合でも同様です。

<h3 id="clean-up-subagent-and-background-session-worktrees">
  サブエージェントとバックグラウンドセッションの worktree をクリーンアップする
</h3>

Claude Code は定期的なスイープを実行し、Claude がサブエージェントと[バックグラウンドセッション](/docs/ja/agent-view#how-file-edits-are-isolated)用に作成した worktree のうち、[`cleanupPeriodDays`](/docs/ja/settings-reference#cleanupperioddays) 設定より古くなったものを、[保持スイープのルール](/docs/ja/claude-directory#cleaned-up-automatically)に従って削除します。

`--worktree` セッションを[バックグラウンドに送る](/docs/ja/agent-view#send-the-session-to-the-background)と、その worktree はスイープで削除可能なバックグラウンドセッションの worktree になります。スイープは次の場合に worktree をそのまま残します。

* worktree にまだ作業が含まれている: 変更されたファイルや追跡されていないファイル、またはプッシュされていないコミット。
* worktree 内のチェックアウトされたサブモジュールに変更されたファイルや追跡されていないファイルがある、または Claude Code が worktree のサブモジュールを検査できない。このチェックには Claude Code v2.1.274 以降が必要です。
* [worktree の作成もブロックする 4 つのケース](#git-lfs-content-is-missing-from-a-worktree-claude-code-created)のいずれかに該当する: Claude Code がリポジトリ設定で定義されているフィルタードライバーを特定できない、またはそこにオフにできない設定項目が見つかった。
* worktree が、バックグラウンドに送っていない `--worktree` セッションに属している（経過時間に関係なく）。
* `git worktree add` で worktree を自分で作成した（その後その中で `--worktree <name>` セッションを実行し、そのセッションをバックグラウンドに送った場合でも）。

Claude Code は git で作成するすべての worktree の git メタデータにマーカーを書き込み、スイープはマーカーのない worktree（[`WorktreeCreate` フック](#non-git-version-control)が作成した worktree を含む）を保持します。

エージェントの実行中、Claude Code は同時実行のクリーンアップで削除されないように、その worktree に `git worktree lock` をかけ、エージェントが完了するとロックを解放します。Claude Code は、バックグラウンドに送られたセッション用に作成した worktree にも、セッションの実行中に同じロックをかけるため、スイープはその worktree をそのまま残し、`git worktree remove` は削除を拒否します。

スイープは、プロセスが終了したセッションのために Claude Code が設定したロックも解放するため、強制終了されたバックグラウンドセッションが worktree を永続的にロックしたままにすることはありません。スイープは、`git worktree lock` で自分で設定したロックを解放することはありません。v2.1.210 より前は、強制終了されたセッションが残したロックは、`git worktree unlock` を実行するまで残っていました。

スイープが保持する worktree をクリーンアップするには、`git worktree remove` を実行し、worktree にコミットされていない変更または追跡されていないファイルがある場合は `--force` を追加します。worktree がロックされているために git が拒否した場合は、先にその worktree に対して `git worktree unlock` を実行してください。

<h2 id="customize-worktree-creation">
  worktree の作成をカスタマイズする
</h2>

Claude Code の worktree 作成のデフォルトは、ほとんどのセッションに対応しています。worktree を `.claude/worktrees/` の下に作成し、リポジトリのデフォルトブランチからブランチし、追跡されているファイルのみをチェックアウトします。このセクションのオプションでこれらのデフォルトを変更できます。

<h3 id="choose-the-base-branch">
  ベースブランチを選択する
</h3>

新しい worktree はリポジトリのデフォルトブランチからブランチするため、ほとんどのセッションではこの設定は必要ありません。代わりに現在の作業からブランチするには、[設定](/docs/ja/settings-reference#worktree)で `worktree.baseRef` を設定します。この設定は 2 つの値を受け入れます。

* `"fresh"`（デフォルト）: リモート上のリポジトリのデフォルトブランチ（通常は `main`）からブランチするため、worktree はリモートと一致するクリーンなツリーから開始します。
* `"head"`: 現在のローカル `HEAD` からブランチするため、worktree はプッシュされていないコミットと機能ブランチの状態を保持します。進行中の作業で動作する必要があるサブエージェントを分離する場合に使用します。worktree 内では、`"head"` はメインチェックアウトの `HEAD` ではなく、その worktree の `HEAD` に解決されます。

`worktree.baseRef` をブランチ名に設定することはできません。特定の既存ブランチから worktree を開始するには、[git で直接作成](#manage-worktrees-manually)してください。

`"fresh"` ベースの場合、Claude Code は `origin/HEAD` を最新の状態に保ちます。過去 24 時間にリポジトリがフェッチされていない場合、デフォルトブランチを 5 秒を上限としてフェッチし、フェッチが失敗した場合はローカルにキャッシュされたリファレンスを使用します。このフェッチはターミナルでの入力を待機しないため、git または ssh がパスワード、鍵のパスフレーズ、または新しい SSH ホストの確認を求める場合も失敗として扱われます。リモートが設定されていない場合、または `origin/HEAD` がローカルにキャッシュされておらずフェッチできない場合、worktree は現在のローカル `HEAD` にフォールバックします。v2.1.208 より前は、fresh の worktree はローカルに既にキャッシュされていた `origin/HEAD` をそのまま使用していました。

この例では、すべての新しい worktree が現在の作業からブランチするようにします。

```json theme={null}
{
  "worktree": {
    "baseRef": "head"
  }
}
```

<h3 id="branch-from-a-pull-request">
  プルリクエストからブランチする
</h3>

特定のプルリクエストまたはマージリクエストからブランチするには、`#` を前に付けた番号、GitHub プルリクエスト URL、または `https://gitlab.com/group/repo/-/merge_requests/123` などの GitLab マージリクエスト URL を `--worktree` に渡します。Claude Code はその変更の head コミットを `origin` からフェッチし、`.claude/worktrees/pr-<number>` に worktree を作成します。シェルが `#` をコメントの開始として扱わないように、引数を引用符で囲んでください。

```bash theme={null}
claude --worktree "#1234"
```

Claude Code は URL から番号のみを読み取ります。常にリポジトリの `origin` リモートからフェッチし、`origin` のホストに応じてフェッチパスを選択します。

* **github.com**: `pull/<number>/head` をフェッチします
* **gitlab.com**: `merge-requests/<number>/head` をフェッチします
* **GitHub Enterprise、セルフマネージド GitLab、またはその他のホスト**: まず `pull/<number>/head` を試し、次に `merge-requests/<number>/head` を試します

このフェッチはターミナルでの入力を待機しません。git または ssh がパスワード、鍵のパスフレーズ、または新しい SSH ホストの確認を求める場合、フェッチは代わりに失敗し、Claude Code は `Error creating worktree: Failed to fetch PR/MR #<number>` メッセージを表示して終了します。`ssh-agent` が保持している鍵は引き続き使用できるため、開始する前に鍵を `ssh-agent` に読み込み、`git fetch` を一度手動で実行して新しいホストを記録してください。

v2.1.233 より前は、Claude Code は `--worktree` に対して `#<number>` と GitHub 形式のプルリクエスト URL のみを受け入れ、常に `pull/<number>/head` をフェッチしていました。

<h3 id="copy-gitignored-files-into-worktrees">
  gitignore されたファイルを worktree にコピーする
</h3>

worktree は新しいチェックアウトなので、メインリポジトリの `.env` や `.env.local` などの追跡されていないファイルは存在しません。Claude が worktree を作成するときに自動的にコピーするには、プロジェクトルートに `.worktreeinclude` ファイルを追加します。

このファイルは `.gitignore` 構文を使用します。パターンに一致し、かつ gitignore されているファイルのみがコピーされるため、追跡されているファイルは決して複製されません。

`**/` で始まるパターンを記述し、対象のファイルがディレクトリ全体として gitignore されているディレクトリ内にある場合、Claude Code は、そのディレクトリ自体がパターンに一致する場合、または `**/` の後の最初の名前がディレクトリのパスに含まれる名前のいずれかである場合にのみ、それらをコピーします。たとえば `**/.claude/skills/*.md` と記述した場合、その最初の名前は `.claude` なので、Claude Code は無視された `.claude/` ディレクトリから一致するファイルをコピーします。`**/` パターンが届かない無視されたディレクトリからファイルをコピーするには、代わりにパターン内でディレクトリ名を指定します。`**/config.json` ではなく `vendor/**/config.json` と記述してください。v2.1.239 より前は、Claude Code は `**/` パターンについて、ディレクトリ自体がパターンに一致する場合にのみ、全体が無視されたディレクトリからファイルをコピーしていました。

この `.worktreeinclude` は 2 つの env ファイルと 1 つのシークレット設定を各新しい worktree にコピーします。

```text .worktreeinclude theme={null}
.env
.env.local
config/secrets.json
```

これは Claude Code が git で作成するすべての worktree に適用されます。対象は、`--worktree` の worktree、[サブエージェントの worktree](#isolate-subagents-with-worktrees)、および[デスクトップアプリ](/docs/ja/desktop#work-in-parallel-with-sessions)の並列セッションです。[`WorktreeCreate` フック](#non-git-version-control)を使用する場合は、フックスクリプト内でファイルをコピーしてください。

<h3 id="reuse-a-worktree-name">
  worktree 名を再利用する
</h3>

既にディレクトリが存在する名前を `--worktree` に渡すと、新しい worktree を作成する代わりに、その既存の worktree が開きます。

デフォルトの `"fresh"` [ベース](#choose-the-base-branch)では、以下のすべてが当てはまる場合、再度開かれた worktree は古いチップで続行する代わりにリポジトリのデフォルトブランチにリセットされます。

* コミットされていない変更または追跡されていないファイルがない。
* Claude Code が作成したブランチ上にまだある。
* 独自のコミットがない、またはプルリクエストやマージリクエストがマージされ、リモートブランチが削除されている。

Claude Code はマージされたケースを git の状態のみから検出します。具体的には、worktree がプッシュしたリモートブランチがもう存在せず、worktree 内のすべてのコミットが既にデフォルトブランチ上にある場合です。

その他のすべての場合、Claude Code は worktree を古いチップで再度開きます。

* worktree がいずれかの条件を満たさない。
* Claude Code が worktree の状態を検証できない。
* `worktree.baseRef` が `"head"` である。
* 名前がプルリクエストまたはマージリクエストの参照である。

v2.1.208 より前は、名前を再利用すると、Claude Code は常に古い worktree を古いチップで再度開いていました。

<h3 id="replace-worktree-creation-with-a-hook">
  フックで worktree の作成を置き換える
</h3>

[`WorktreeCreate` フック](/docs/ja/hooks#worktreecreate)を設定すると、`.claude/worktrees/` 以外の場所に worktree を配置することも含め、デフォルトの `git worktree` ロジックを完全に置き換えることができます。完全な例については、[非 git バージョン管理](#non-git-version-control) を参照してください。

<h2 id="what-worktrees-share-with-the-main-checkout">
  worktree がメインチェックアウトと共有するもの
</h2>

worktree は独自のファイルとブランチを持ちますが、以下をメインチェックアウトと共有します。

* **リポジトリの `.git` ディレクトリ**: worktree 内の git コマンドはメインリポジトリの共有 `.git` ディレクトリに書き込み、[サンドボックス化](/docs/ja/sandboxing#filesystem-isolation)はそれらの書き込みを許可するため、サンドボックスが有効な状態でも `git commit` などのコマンドは worktree 内から動作します。
* **プラグイン**: メインチェックアウトから[プロジェクトスコープ](/docs/ja/plugins/loading#find-where-a-plugin-is-enabled)でインストールされたプラグインは、同じリポジトリの worktree でも読み込まれるため、worktree ごとに再インストールする必要はありません。Claude Code v2.1.200 以降が必要です。
* **権限の承認**: worktree セッションで Bash コマンドに対して「はい、今後は確認しない」を選択すると、ルールはメインチェックアウトの `.claude/settings.local.json` に保存されるため、メインチェックアウトとリポジトリの他のすべての worktree に適用され、worktree の削除後も残ります。Windows や、Claude Code が[リポジトリルートを使用しない](/docs/ja/settings#where-claude-code-looks-for-each-file)その他のケースでは、ルールはその worktree に残ります。v2.1.211 より前は、worktree で付与された承認はその worktree 内に保存され、他の場所には適用されず、worktree が削除されると失われていました。[承認が保存される場所](/docs/ja/permissions#permission-system)を参照してください。
* **追跡されていないスキル、エージェント、コマンド**: worktree のチェックアウトのルートに `.claude/skills` ディレクトリがない場合（たとえば `.claude/skills` が gitignore されている場合）、Claude Code は worktree セッションでメインチェックアウトの[プロジェクトスキル](/docs/ja/skills#where-skills-live)を読み込みます。独自の `.claude/skills` ディレクトリを持つ worktree では、そのコピーのみが読み込まれます。

  同じ読み取りの引き継ぎは `.claude/agents` と `.claude/commands` にも適用されます。スキルについては、この引き継ぎには Claude Code v2.1.277 以降が必要です。

これらはすべて、worktree を `--worktree` で作成した場合も、`git worktree add` で作成した場合も、[デスクトップアプリ](/docs/ja/desktop#work-in-parallel-with-sessions)を通じて作成した場合も適用されます。

<h2 id="manage-worktrees-manually">
  worktree を手動で管理する
</h2>

特定の既存ブランチをチェックアウトする必要がある場合や、worktree をリポジトリの外に配置する必要がある場合は、Git を直接使用して worktree を作成します。

新しいブランチに worktree を作成します。

```bash theme={null}
git worktree add ../project-feature-a -b feature-a
```

既存のブランチから worktree を作成します。`fix-issue-456` は、リポジトリに既に存在するブランチに置き換えてください。

```bash theme={null}
git worktree add ../project-bugfix fix-issue-456
```

worktree で Claude を開始します。

```bash theme={null}
cd ../project-feature-a
claude
```

worktree を一覧表示します。

```bash theme={null}
git worktree list
```

完了したら削除します。

```bash theme={null}
git worktree remove ../project-feature-a
```

完全なコマンドリファレンスについては、[Git worktree ドキュメント](https://git-scm.com/docs/git-worktree) を参照してください。

<h2 id="non-git-version-control">
  非 git バージョン管理
</h2>

worktree の分離はデフォルトで git を使用します。SVN、Perforce、Mercurial、またはその他のシステムの場合、[`WorktreeCreate` および `WorktreeRemove` フック](/docs/ja/hooks#worktreecreate) を設定して、カスタム作成およびクリーンアップロジックを提供します。フックはデフォルトの git 動作を置き換えるため、`--worktree` を使用する場合、[`.worktreeinclude`](#copy-gitignored-files-into-worktrees) は処理されません。フックスクリプト内でローカル設定ファイルをコピーしてください。

この `WorktreeCreate` フックは、`jq` を使用して stdin の JSON から worktree 名を読み取り、新しい SVN 作業コピーをチェックアウトし、ディレクトリパスを出力して Claude Code がセッションの作業ディレクトリとして使用できるようにします。設定を [`settings.json`](/docs/ja/settings#where-settings-live) に追加します。

```json theme={null}
{
  "hooks": {
    "WorktreeCreate": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "bash -c 'NAME=$(jq -r .name); DIR=\"$HOME/.claude/worktrees/$NAME\"; svn checkout https://svn.example.com/repo/trunk \"$DIR\" >&2 && echo \"$DIR\"'"
          }
        ]
      }
    ]
  }
}
```

セッションが終了するときにクリーンアップするために `WorktreeRemove` フックとペアにします。入力スキーマと削除例については、[フックリファレンス](/docs/ja/hooks#worktreecreate) を参照してください。

`WorktreeCreate` フックを使用すると、git リポジトリの外で [`/batch`](/docs/ja/commands#all-commands) を実行することもできます。その場合、各 `/batch` サブエージェントはプロジェクトのバージョン管理コマンドで変更を公開し、プルリクエストを開けない場合は、代わりに公開した内容を報告します。git リポジトリの外で `/batch` を実行するには、Claude Code v2.1.281 以降が必要です。

<h2 id="troubleshooting">
  トラブルシューティング
</h2>

Claude Code は、worktree を作成するとき、起動時に worktree に入るとき、または再開したセッションを worktree に戻すときに、以下のエラーを報告します。

<h3 id="claude-code-can’t-enter-the-worktree-at-startup">
  Claude Code が起動時に worktree に入れない
</h3>

Claude Code が起動時に worktree ディレクトリに入ることができない場合、パスを示すエラーを出力し、コード 1 で終了します。これは、[`WorktreeCreate` フック](/docs/ja/hooks#worktreecreate)が作成したディレクトリ以外のものを出力した場合や、セットアップ後にディレクトリが削除された場合に発生する可能性があります。

<h3 id="worktree-creation-fails-on-a-symlinked-path">
  シンボリックリンクされたパスで worktree の作成が失敗する
</h3>

`.claude`、`.claude/worktrees`、または worktree ディレクトリ自体がシンボリックリンクである場合、Claude Code は worktree の作成を拒否し、エラーにはシンボリックリンクのパスが示されます。シンボリックリンクを削除して再試行してください。v2.1.212 より前は、リポジトリにこれらのパスのいずれかにコミットされたシンボリックリンクが既に含まれていた場合、worktree の作成はそれをたどり、リポジトリの外にファイルを作成する可能性がありました。

<h3 id="git-lfs-content-is-missing-from-a-worktree-claude-code-created">
  Claude Code が作成した worktree で Git LFS ファイルがポインターファイルになる
</h3>

`git lfs install --local` で [Git LFS](https://git-lfs.com) をセットアップした場合、Claude Code が作成する worktree には実際のファイルではなく LFS ポインターファイルが含まれます。`--local` フラグは、LFS フィルターをグローバル git 設定ではなく、リポジトリ独自の `.git/config` に書き込みます。通常の `git lfs install` はグローバル設定に書き込むため、影響を受けません。リポジトリ独自の設定で定義されているその他の[フィルタードライバー](https://git-scm.com/docs/gitattributes)にも同じことが当てはまります。

Claude Code は、worktree を作成する際にリポジトリ独自のフィルタードライバーをスキップします。フィルタードライバーはシェルコマンドであり、Claude を含め、リポジトリに書き込めるものなら何でもそこに配置できた可能性があるためです。v2.1.247 より前は、Claude Code は worktree の作成中にこれらのドライバーを実行していました。

実際のファイルを取得するには、worktree 内で `git lfs pull` を実行します。

まれな 4 つのケースでは、Claude Code は worktree をまったく作成しません。リポジトリの設定で定義されているフィルタードライバーを判別できない場合、またはそこでオフにできない設定項目が見つかった場合です。エラーと対応する修正方法を照らし合わせてください。

* **`Could not read the repository git config to neutralize filter drivers`**: Claude Code がリポジトリの `.git/config` を読み取れませんでした（たとえばそのファイルの権限が原因）。それを修正して再試行してください。
* **`The repository git config defines a filter driver whose name cannot be neutralized (contains "=" or a newline)`**: `.git/config` 内のそのフィルタードライバーの名前を変更するか削除して、再試行してください。
* **`The repository git config has a conditional include (includeIf)`**: `.git/config` 内の `includeIf` が取り込む設定をそのファイルに直接移動し、`includeIf` を削除して再試行してください。グローバル git 設定内の `includeIf` はこれをトリガーしません。
* **`Git was not run: the repository's own git config sets <key>`**: メッセージには、`lfs.customtransfer.<name>.path` や `lfs.standalonetransferagent` など、Git LFS に実行するプログラムを指定するキーが示されます。その設定が自分のものであれば、グローバル git 設定に移動します。心当たりがない場合は、信頼していないツールやチェックアウトが書き込んだ可能性があるため、リポジトリの git 設定から削除してください。リポジトリの設定からキーがなくなったら再試行してください。

<h3 id="claude-code-refuses-to-use-a-worktree">
  Claude Code が worktree の使用を拒否する
</h3>

`Refusing to use <path> as an isolation worktree` で始まるエラーは、Claude Code がディレクトリをセッションまたはサブエージェントの分離されたチェックアウトとして採用する前にそのディレクトリの git ID を確認し、拒否したことを意味します。このチェックは、Claude Code が worktree を作成する場合、既存の worktree に入る場合、以前の実行の worktree を再利用する場合のいずれでも実行されます。

ほとんどの場合、メッセージの残りの部分には、ディレクトリの git メタデータがメインチェックアウトに解決されることが示されています。たとえば、その `.git` ファイルがメインリポジトリ自体の `.git` ディレクトリを指している場合や、`core.worktree` リダイレクトによって git がその作業ツリーをメインチェックアウトに解決する場合です。そのようなディレクトリからは、`git reset --hard` などの通常の git コマンドが worktree ではなくメインチェックアウトに作用してしまいます。Claude Code は、ディレクトリに読み取れない `.git` エントリがある場合も、worktree が安全であると想定せずに拒否します。

[`WorktreeCreate` フック](#non-git-version-control)が作成するディレクトリなど、git メタデータをまったく持たないディレクトリは、それを含む git リポジトリがない場合にのみチェックに合格します。フックがリポジトリ内にディレクトリを作成すると、git はそれをそのリポジトリのチェックアウトに解決し、Claude Code は `git resolves its working tree to` メッセージで拒否するため、フックはディレクトリをリポジトリの外に作成するようにしてください。

拒否されたディレクトリには作業が含まれている可能性があるため、Claude Code はそのまま残します。メッセージが `Refusing to use <path>` に続くものであっても、[再開メッセージ](#the-session-resumes-outside-its-worktree)に表示されるものであっても、メッセージと回復方法を照らし合わせてください。一部の末尾は再開メッセージにのみ表示されます。

* **`launch from the parent checkout` または `Run the resume from the project checkout` と表示される**: worktree 内から Claude Code を起動しました。代わりにメインチェックアウトから起動してください。worktree を再作成する必要はありません。
* **`it cannot be resumed or re-entered` と表示される**: このセッションには、起動した場所からその worktree を安全と確認できるものがありません。worktree を再作成してください。ディレクトリとその作業は手動回復のためにディスク上に残ります。worktree に親チェックアウトがある場合は、そこから再開することもできます。
* **`it contains the protected checkout` と表示される**: 拒否されたディレクトリは、ホームディレクトリなど、メインチェックアウトの親です。削除しないでください。`WorktreeCreate` フックが返すパスや `EnterWorktree` のターゲットなど、worktree のパスを変更して、worktree がチェックアウトを含まないようにしてください。
* **`the protected checkout <path> has a .git entry that could not be examined` または `has git metadata that could not be resolved` と表示される**: 問題は worktree ではなくメインチェックアウトの git メタデータにあります。worktree を削除しないでください。また、メッセージ末尾の worktree を再作成するようにというアドバイスは、これら 2 つの末尾には当てはまらないため無視してください。メインチェックアウトを修復し（たとえば `.git` に対する権限の問題や git の `dubious ownership` による拒否）、再試行してください。
* **`its recorded path has a network spelling` と表示される**: Claude Code はネットワークパスにある worktree へ再開することはありません。ローカルパスに worktree を再作成してください。
* **その他の末尾**: メッセージには、`core.worktree` リダイレクトの削除や worktree の再作成など、問題とその修正方法が示されています。それに従ってください。git ID を検証できなかったというメッセージが表示されたディレクトリを削除する前に、worktree のパス内のシンボリックリンクや git 自体の実行失敗など、示された原因に先に対処してください。ディレクトリが正常である可能性があるためです。再作成する場合は、先に古いディレクトリから必要な変更を回収してください。古いディレクトリはディスク上に残ります。

<h3 id="the-session-resumes-outside-its-worktree">
  セッションが worktree の外で再開される
</h3>

セッションを対話的に再開し、Claude Code がそれを worktree に戻せない場合、Claude Code は以下のいずれかのメッセージでその旨を伝えます。Claude Code が worktree バインディングをクリアすると、そのクリアをセッションのトランスクリプトに記録します。[トランスクリプトの書き込みを抑制](/docs/ja/sessions#where-transcripts-are-stored)している場合、メッセージは代わりに、バインディングをクリアできなかったこと、および Claude Code が後の再開時に worktree を再確認することを示します。

| メッセージの先頭 | 発生したことと対処方法 |
| :- | :- |
| `Your worktree <path> no longer exists` | worktree ディレクトリが削除されました。セッションは分離なしで現在のディレクトリで続行され、Claude Code は worktree バインディングをクリアします。対処は不要です。 |
| `Could not verify your worktree <path> this time` | Claude Code は、通常は一時的な理由で worktree を検証できませんでした。バインディングは保持され、セッションは分離なしで現在のディレクトリで続行されます。再試行するには再度再開してください。繰り返し発生する場合は、新しいセッションで worktree に入り、拒否メッセージを [Claude Code が worktree の使用を拒否する](#claude-code-refuses-to-use-a-worktree) と照らし合わせてください。このメッセージは、worktree ではなくメインチェックアウトのメタデータを示している場合があります。 |
| `Did not re-enter your worktree <path>` | Claude Code は worktree バインディングを安全でないとして拒否しました。バインディングをクリアし、セッションは分離なしで続行されます。メッセージには具体的な拒否理由が含まれています。一部の拒否では再作成、その他の拒否ではパスの変更が修正方法となるため、[Claude Code が worktree の使用を拒否する](#claude-code-refuses-to-use-a-worktree) と照らし合わせてください。 |
| `Could not re-enter your worktree <path>` | 起動した場所から Claude Code が worktree を安全と確認できませんでした。最も一般的な原因は worktree 内から起動したことです。バインディングは保持されます。メッセージの残りの部分に修正方法が示されているので、[Claude Code が worktree の使用を拒否する](#claude-code-refuses-to-use-a-worktree) と照らし合わせてください。 |

`-p` を使用した[非対話モード](/docs/ja/headless)および [Agent SDK](/docs/ja/agent-sdk/sessions) が実行する再開では、Claude Code は分離なしで続行するのではなく、worktree が存在しない場合を除くすべての拒否に対して stderr エラーで再開を停止します。

`--output-format stream-json` を使用すると、拒否は stdout にもサブタイプ `error_during_execution` の `result` メッセージとして届き、その `errors` 配列に同じテキストが含まれるため、Agent SDK アプリケーションはゼロ以外の終了コードだけでなく理由も受け取れます。v2.1.260 より前は、worktree の再開拒否で `result` メッセージは生成されませんでした。

メッセージは、表にある対話的なメッセージとは異なる形式になります。

* 表で `Did not re-enter` として示される拒否の場合は `Error: cannot resume into worktree <path>: ...This session was not started.`。Claude Code は終了前に worktree バインディングをクリアし、エラーにもそのことが示されます。次に会話を再開すると、セッションは worktree 分離なしで現在のディレクトリで続行されます。v2.1.260 より前は、Claude Code はクリアされたバインディングを書き込まなかったため、同じ再開を再試行するたびに同じエラーで失敗していました。

  [トランスクリプトの書き込みを抑制](/docs/ja/sessions#where-transcripts-are-stored)している場合、クリアを保存できません。その場合、エラーには同じコマンドが再び拒否されることが示され、worktree なしで続行する方法として `--fork-session` と新しい会話の開始が挙げられます。
* `Could not verify` の場合は `Error: could not verify worktree <path> for this resume, so the resume was aborted...`
* `Could not re-enter` の場合は `Error: ...The worktree binding is kept.`
* worktree が存在しない場合は `Notice: the worktree <path> for this session no longer exists...`。Claude Code はこれを出力し、対話的な再開と同様にセッションを続行します

各エラーに埋め込まれた拒否の末尾は対話的な通知と共通であるため、引き続き [Claude Code が worktree の使用を拒否する](#claude-code-refuses-to-use-a-worktree) の該当項目と照らし合わせることができます。

stream-json の結果では、[`startup_failure_reason`](/docs/ja/agent-sdk/typescript#startup_failure_reason) は、`could not verify worktree` エラーの場合は `worktree_unverified`、`cannot resume into worktree` および `The worktree binding is kept` エラーの場合は `worktree_resume_refused` になります。アプリケーションはエラーテキストを照合する代わりに、これに基づいて分岐できます。v2.1.274 より前は、結果に `startup_failure_reason` フィールドは含まれていませんでした。

<h2 id="see-also">
  関連項目
</h2>

worktree はファイルの分離を処理します。以下の関連ページでは、これらの分離されたチェックアウトに作業を委任する方法、チェックアウト間で調査結果を受け渡す方法、および作成したセッション間を切り替える方法について説明しています。

* [サブエージェント](/docs/ja/sub-agents): セッション内の分離されたエージェントに作業を委任する
* [セッション間メッセージング](/docs/ja/cross-session-messaging): worktree 内のセッション同士で調査結果を受け渡せるようにする
* [エージェントチーム](/docs/ja/agent-teams): 複数の Claude セッションを自動的に調整する
* [セッションを管理する](/docs/ja/sessions): 会話に名前を付け、再開し、切り替える
* [デスクトップ並列セッション](/docs/ja/desktop#work-in-parallel-with-sessions): デスクトップアプリの worktree でサポートされるセッション
