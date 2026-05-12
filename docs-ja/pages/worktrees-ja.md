> ## Documentation Index
> Fetch the complete documentation index at: https://code.claude.com/docs/llms.txt
> Use this file to discover all available pages before exploring further.

# worktree を使用して並列セッションを実行する

> 並列 Claude Code セッションを個別の git worktree に分離して、変更が衝突しないようにします。`--worktree` フラグ、subagent の分離、`.worktreeinclude`、クリーンアップ、および非 git VCS フックについて説明します。

[git worktree](https://git-scm.com/docs/git-worktree) は、独自のファイルとブランチを持つ別の作業ディレクトリであり、メインのチェックアウトと同じリポジトリ履歴とリモートを共有します。各 Claude Code セッションを独自の worktree で実行すると、1 つのセッションでの編集は別のセッションのファイルに触れることがないため、Claude が 1 つのターミナルで機能を構築しながら、2 番目のターミナルでバグを修正できます。

このページでは、CLI での worktree の分離について説明します。以下のすべての内容は git リポジトリを想定しています。その他のバージョン管理システムについては、[非 git バージョン管理](#non-git-version-control) を参照してください。[デスクトップアプリ](/ja/desktop#work-in-parallel-with-sessions) は、新しいセッションごとに自動的に worktree を作成します。

Worktree は Claude を並列で実行するいくつかの方法の 1 つです。これらは、ファイル編集を分離しますが、[subagent](/ja/sub-agents) と [agent team](/ja/agent-teams) は作業自体を調整します。アプローチを比較するには [Claude を並列で実行する](/ja/agents) を参照するか、worktree と subagent を一緒に使用するには [worktree で subagent を分離する](#isolate-subagents-with-worktrees) にスキップしてください。

## worktree で Claude を開始する

`--worktree` または `-w` を渡して、分離された worktree を作成し、その中で Claude を開始します。デフォルトでは、worktree はリポジトリルートの `.claude/worktrees/<value>/` の下に作成され、`worktree-<value>` という名前の新しいブランチ上に作成されます。

```bash theme={null}
claude --worktree feature-auth
```

Worktree を別の場所に配置するには、[`WorktreeCreate` フック](#non-git-version-control) を設定します。別のターミナルで異なる名前を使用してコマンドを再度実行して、2 番目の分離されたセッションを開始します。

```bash theme={null}
claude --worktree bugfix-123
```

名前を省略すると、Claude は `bright-running-fox` などの名前を生成します。

```bash theme={null}
claude --worktree
```

セッション中に Claude に「worktree で作業する」と指示することもでき、[`EnterWorktree`](/ja/tools-reference) ツールを使用して作成します。

初めてディレクトリで `--worktree` を使用する前に、そのディレクトリで `claude` を 1 回実行してワークスペース信頼ダイアログを受け入れてください。信頼がまだ受け入れられていない場合、`--worktree` はエラーで終了し、最初にディレクトリで `claude` を実行するよう求めるプロンプトが表示されます。これは `-p` と組み合わせた場合も含まれます。

<Tip>
  `.claude/worktrees/` を `.gitignore` に追加して、worktree の内容がメインのチェックアウトで追跡されていないファイルとして表示されないようにします。
</Tip>

### ベースブランチを選択する

Worktree はリポジトリのデフォルトブランチ `origin/HEAD` からブランチするため、リモートと一致するクリーンなツリーから開始します。リモートが設定されていない場合、またはフェッチが失敗した場合、worktree は現在のローカル `HEAD` にフォールバックします。代わりにローカル `HEAD` から常にブランチするには、[設定](/ja/settings#worktree-settings) で `worktree.baseRef` を `"head"` に設定します。`baseRef` を `"head"` に設定すると、新しい worktree はプッシュされていないコミットと機能ブランチの状態を保持します。これは、進行中の作業で動作する必要がある subagent を分離する場合に便利です。この設定は `"fresh"` または `"head"` のみを受け入れ、任意の git ref は受け入れません。

```json theme={null}
{
  "worktree": {
    "baseRef": "head"
  }
}
```

特定のプルリクエストからブランチするには、`#` が付いた PR 番号、または完全な GitHub プルリクエスト URL を渡します。Claude Code は `origin` から `pull/<number>/head` をフェッチし、`.claude/worktrees/pr-<number>` に worktree を作成します。

```bash theme={null}
claude --worktree "#1234"
```

Worktree の作成方法を完全に制御するには、[`WorktreeCreate` フック](/ja/hooks#worktreecreate) を設定します。これはデフォルトの `git worktree` ロジックを完全に置き換えます。

## gitignore されたファイルを worktree にコピーする

Worktree は新しいチェックアウトなので、メインリポジトリの `.env` や `.env.local` などの追跡されていないファイルは存在しません。Claude が worktree を作成するときに自動的にコピーするには、プロジェクトルートに `.worktreeinclude` ファイルを追加します。

このファイルは `.gitignore` 構文を使用します。パターンに一致し、かつ gitignore されているファイルのみがコピーされるため、追跡されているファイルは決して複製されません。

この `.worktreeinclude` は 2 つの env ファイルと 1 つのシークレット設定を各新しい worktree にコピーします。

```text .worktreeinclude theme={null}
.env
.env.local
config/secrets.json
```

これは `--worktree` で作成された worktree、[subagent worktree](#isolate-subagents-with-worktrees)、および[デスクトップアプリ](/ja/desktop#work-in-parallel-with-sessions) の並列セッションに適用されます。

## worktree で subagent を分離する

Subagent は独自の worktree で実行できるため、並列編集は競合しません。Claude に「エージェント用に worktree を使用する」と指示するか、[カスタム subagent](/ja/sub-agents#supported-frontmatter-fields) にフロントマターに `isolation: worktree` を追加して永続的に設定します。各 subagent は一時的な worktree を取得し、subagent が変更なしで完了すると自動的に削除されます。

## worktree をクリーンアップする

Worktree セッションを終了すると、クリーンアップは変更を加えたかどうかによって異なります。

* **変更なし**: worktree とそのブランチは自動的に削除されます
* **変更またはコミットが存在する**: Claude は worktree を保持するか削除するかを求めるプロンプトを表示します。保持するとディレクトリとブランチが保存されるため、後で戻ることができます。削除すると worktree ディレクトリとそのブランチが削除され、すべてのコミットされていない変更とコミットが破棄されます
* **非対話的な実行**: `-p` と共に `--worktree` で作成された worktree は、終了プロンプトがないため自動的にクリーンアップされません。`git worktree remove` で削除します

Crash または中断された実行によって孤立した subagent worktree は、[`cleanupPeriodDays`](/ja/settings#available-settings) 設定より古い場合、コミットされていない変更、追跡されていないファイル、およびプッシュされていないコミットがない場合、起動時に削除されます。`--worktree` で作成した worktree は、このスイープによって削除されることはありません。

## worktree を手動で管理する

Worktree の場所とブランチ設定を完全に制御するには、Git を直接使用して worktree を作成します。これは特定の既存ブランチをチェックアウトするか、worktree をリポジトリの外に配置する必要がある場合に便利です。

新しいブランチに worktree を作成します。

```bash theme={null}
git worktree add ../project-feature-a -b feature-a
```

既存のブランチから worktree を作成します。

```bash theme={null}
git worktree add ../project-bugfix bugfix-123
```

Worktree で Claude を開始します。

```bash theme={null}
cd ../project-feature-a && claude
```

Worktree をリストします。

```bash theme={null}
git worktree list
```

完了したら削除します。

```bash theme={null}
git worktree remove ../project-feature-a
```

完全なコマンドリファレンスについては、[Git worktree ドキュメント](https://git-scm.com/docs/git-worktree) を参照してください。各新しい worktree で開発環境を初期化することを忘れないでください。依存関係をインストールし、仮想環境をセットアップするか、プロジェクトのセットアップが必要なものを実行します。

## 非 git バージョン管理

Worktree の分離はデフォルトで git を使用します。SVN、Perforce、Mercurial、またはその他のシステムの場合、[`WorktreeCreate` および `WorktreeRemove` フック](/ja/hooks#worktreecreate) を設定して、カスタム作成およびクリーンアップロジックを提供します。フックはデフォルトの git 動作を置き換えるため、`--worktree` を使用する場合、[`.worktreeinclude`](#copy-gitignored-files-into-worktrees) は処理されません。フックスクリプト内でローカル設定ファイルをコピーします。

この `WorktreeCreate` フックは stdin から worktree 名を読み取り、新しい SVN 作業コピーをチェックアウトし、ディレクトリパスを出力して Claude Code がセッションの作業ディレクトリとして使用できるようにします。

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

セッションが終了するときにクリーンアップするために `WorktreeRemove` フックとペアにします。入力スキーマと削除例については、[フックリファレンス](/ja/hooks#worktreecreate) を参照してください。

## 関連項目

Worktree はファイルの分離を処理します。以下の関連ページでは、これらの分離されたチェックアウトに作業を委任し、作成したセッション間を切り替える方法について説明しています。

* [Subagent](/ja/sub-agents): セッション内の分離されたエージェントに作業を委任する
* [Agent team](/ja/agent-teams): 複数の Claude セッションを自動的に調整する
* [セッションを管理する](/ja/sessions): 会話に名前を付け、再開し、切り替える
* [デスクトップ並列セッション](/ja/desktop#work-in-parallel-with-sessions): デスクトップアプリの worktree でサポートされるセッション
