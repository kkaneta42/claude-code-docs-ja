> ## Documentation Index
> Fetch the complete documentation index at: https://code.claude.com/docs/llms.txt
> Use this file to discover all available pages before exploring further.

# 権限を設定する

> きめ細かい権限ルール、モード、管理ポリシーを使用して、Claude Code がアクセスして実行できる内容を制御します。

Claude Code は、エージェントが実行できることと実行できないことを正確に指定できるようにするため、きめ細かい権限をサポートしています。権限設定はバージョン管理にチェックインでき、組織内のすべての開発者に配布できるほか、個々の開発者がカスタマイズできます。

## 権限システム

Claude Code は、パワーと安全性のバランスを取るために、段階的な権限システムを使用しています。表は、各ツールタイプについて、Manual モードがアクションの実行前に確認するかどうかを示しています。その他の[権限モード](#permission-modes)は、これらのどれがあなたに確認するかを変更します。auto モードでは、分類器があなたの代わりにアクションをレビューし、[分類器がアクションをどのように評価するか](/docs/ja/permission-modes#how-the-classifier-evaluates-actions)は、それが見るアクションをリストアップしています。

| ツールタイプ | 例 | 承認が必要 | 「はい、今後は聞かない」の動作 |
| :- | :- | :- | :- |
| 読み取り専用 | ファイル読み取り、Grep | いいえ、[作業ディレクトリと追加ディレクトリ](#working-directories)内 | N/A |
| Bash コマンド | シェル実行 | はい、[読み取り専用コマンド](#read-only-commands)の組み込みセットを除く | リポジトリとコマンドごとに永続的 |
| ファイル変更 | Edit/Write ファイル | はい | セッション終了まで |
| Web フェッチ | WebFetch | はい、[事前承認されたドキュメンテーションドメイン](/docs/ja/tools-reference#webfetch-tool-behavior)の組み込みセットを除く | リポジトリとドメインごとに永続的 |
| Web 検索 | WebSearch | はい | リポジトリごとに永続的 |

権限プロンプトには、Claude が実行しようとしている内容が表示され、その後に選択肢が続きます。次の例は、Manual モードのセッションにおける Bash コマンドのプロンプトです。

![Bash command というタイトルの Claude Code の権限プロンプト。auto モードに関するヒントの下に、説明「Run the test suite」、コマンド npm test、「This command requires approval」という行が表示され、続いて「Do you want to proceed?」と尋ね、4 つのオプション（Yes、Yes, and don't ask again for: npm test \*、Yes, and switch to auto mode、No）が表示されています。フッターには 2 つのキー（キャンセルする Esc と修正する Tab）が記載されています。](https://mintcdn.com/claude-code/oa7CKjMeIChox26S/images/permission-prompt-bash-light.png?fit=max\&auto=format\&n=oa7CKjMeIChox26S\&q=85\&s=87585d008a29304873466399f7b476f6)

3 番目のオプションである **Yes, and switch to auto mode** は、[すべてのプロンプトに表示されるわけではありません](/docs/ja/permission-modes#switch-permission-modes)。

「はい、今後は聞かない」を選択し、承認が永続的に保存される場合（Bash コマンドや WebFetch ドメインなど）、Claude Code はルールを git リポジトリのルートにある `.claude/settings.local.json` に保存します。これは[worktrees](/docs/ja/worktrees)を通じてメインチェックアウトに解決されます。ルールは、そのリポジトリ内のサブディレクトリで開始されたセッションや worktrees 内のセッションを含む、そのリポジトリ内の将来のセッションに適用されます。ファイル変更の承認はファイルに保存されません。表が示すように、セッション終了まで続きます。git リポジトリの外部や Windows 上など、場合によっては Claude Code はリポジトリルートを使用しません。[Claude Code が各ファイルを探す場所](/docs/ja/settings#where-claude-code-looks-for-each-file)は、これらのケースと代わりにルールを保存する場所をリストアップしています。

v2.1.211 より前では、Claude Code は常にルールを開始ディレクトリに保存していたため、worktree またはサブディレクトリで付与された承認はリポジトリの残りの部分に適用されませんでした。以前のバージョンがサブディレクトリまたは worktree に保存したルールは、そこで開始されたセッションに引き続き適用されます。

場合によっては、権限プロンプトは 1 回限りの承認のみを提供し、「今後は聞かない」オプションもセッションの残りの部分のアクションを許可するオプションもありません。Claude Code はプロンプトがそれらが許可するすべてのものを表示できる場合にのみ、これらのオプションを提供するため、プロンプトから保存するルールは、その名前のオプションが許可するものだけをカバーします。プロンプトが 1 回限りの承認のみを提供する場合、アクションを 1 回承認するか、[`/permissions`](#manage-permissions)でルール自体を追加してください。`watch` などの exec ラッパーで始まるコマンドや、`-delete` などのアクションを含む `find` コマンドのプロンプトを表示しないようにするには、[exec ラッパーと `find` アクション](#exec-wrappers-and-find-actions)を参照してください。

### 権限プロンプトに回答するときにコメントを追加する

権限プロンプトに回答するときに、単一のアクションを承認または拒否するときに、Claude にメモを添付できます。Bash、PowerShell、ファイル、MCP ツールプロンプトを含むほとんどの権限プロンプトで、**はい**または**いいえ**に移動し、`Tab` を押してそのオプションのコメントフィールドを開きます。WebFetch とブラウザプロンプトはフィールドを提供しません。セッションの残りの部分のアクションを許可するか、ルールを保存するオプションも 1 つを取りません。

フィールドが開いている状態で、コメントを入力してから、これらのキーのいずれかを押します。

* `Enter`：コメントが添付された状態で回答を送信します。フィールドを空のままにすると、Claude Code はコメントなしで回答を送信します。
* `Tab`：フィールドを閉じて回答しません。Claude Code は入力したテキストを保持し、そのオプションで回答する場合でも送信します。
* `Shift+Tab`：ファイルプロンプト（Edit または Write プロンプトなど）では、フィールドを `Tab` と同じように閉じます。v2.1.235 より前では、フィールド内で `Shift+Tab` を押すと、セッションの残りの部分のアクションを許可するオプションが選択されたため、Claude Code はセッションの残りの部分のアクションを承認し、コメントを破棄しました。

Claude Code は、回答方法に応じてコメントを異なる方法で配信します。

* **はい**：Claude Code はアクションを実行し、結果の後に Claude にコメントを送信します。
* **いいえ**：Claude Code はコメントを Claude に拒否の理由として送信し、Claude は作業を続けます。メインの会話からのプロンプトでコメントなしで**いいえ**を選択すると、Claude Code はターンを停止します。

## 権限を管理する

`/permissions` を使用して、Claude Code のツール権限を表示および管理できます。このダイアログは、すべての権限ルールと、各ルールが取得される `settings.json` ファイルをリストします。Claude が作業中にダイアログを開くことができます。ルールを追加または削除すると、Claude Code は同じターン内の Claude の次のツール呼び出しから変更を適用します。v2.1.234 より前では、Claude Code はターンが終了するまでコマンドをキューに入れていました。

* **Allow** ルールは、Claude Code が手動承認なしで指定されたツールを使用できるようにします。
* **Ask** ルールは、Claude Code が指定されたツールを使用しようとするたびに確認を促します。
* **Deny** ルールは、Claude Code が指定されたツールを使用することを防止します。

ルールは順序で評価されます。deny、ask、allow の順です。その順序での最初のマッチがアウトカムを決定し、ルールの特異性は順序を変更しません。

`Bash(aws *)` のような広い deny ルールは、`Bash(aws s3 ls)` のようなより狭い allow ルールにもマッチする呼び出しを含む、マッチするすべての呼び出しをブロックします。allow ルールは deny ルールから例外を作成することはできません。ask と allow の間にも同じ優先順位が適用されます。マッチする ask ルールは、同じ呼び出しにマッチするより具体的な allow ルールがある場合でも、プロンプトを表示します。

Deny ルールは、ツール名を指定するか、ツール内のパターンをスコープするかによって異なる動作をします。`Bash` のようなベアツール名は、ツールを Claude のコンテキストから完全に削除するため、Claude はそれを見ることはありません。セッション中にそのようなルールを追加する場合、Claude は次のツール呼び出しからそのツールを呼び出すことができません。[ツール全体を拒否する](/docs/ja/prompt-caching#denying-an-entire-tool)では、Claude が既に見た定義に何が起こるかについて説明しています。`Bash(rm *)` のようなスコープ付きルールは、ツールを利用可能なままにし、Claude が試みたときにマッチする呼び出しをブロックします。

ベア名削除はすべてのツールに適用されます（[`EndConversation`](/docs/ja/tools-reference#endconversation-tool-behavior) を除く）。deny ルールは他のツールが残っている間はそれを削除できず、ask ルールはそれに対してプロンプトを表示しません。

> [!NOTE]
>
> 権限ルールは Claude Code によって実装されており、モデルによってではありません。プロンプトまたは `CLAUDE.md` の指示は、Claude が何をしようとするかを形作りますが、Claude Code が許可する内容は変わりません。アクセスを付与または取り消すには、`/permissions`、ここで説明されているルール、[permission mode](/docs/ja/permission-modes)、または [PreToolUse hook](#extend-permissions-with-hooks) を使用してください。

[auto mode](/docs/ja/permission-modes#eliminate-prompts-with-auto-mode) がセッションで利用可能な場合、ダイアログには [auto mode classifier rules](/docs/ja/auto-mode-config#edit-rules-from-permissions) も含まれます。**Auto mode** タブを選択して、それらを表示します。

## 権限モード

Claude Code は、ツール呼び出しの承認方法を制御するいくつかの権限モードをサポートしています。[権限モード](/docs/ja/permission-modes)を参照して、各モードをいつ使用するかを確認してください。セッションが開始される際のモードを変更するには、[設定ファイル](/docs/ja/settings#where-settings-live)で `defaultMode` を設定してください。[セッションが開始されるモード](/docs/ja/permission-modes#which-mode-a-session-starts-in)では、各プランの組み込みデフォルトと VS Code 拡張機能が読み込む内容について説明しています。

| モード | 説明 |
| :- | :- |
| `default` | 各ツールの最初の使用時に権限を促します。CLI、VS Code と JetBrains 拡張機能、およびデスクトップアプリでは Manual とラベル付けされており、Claude Code は `manual` をエイリアスとして受け入れます |
| `acceptEdits` | ファイル編集と一般的なファイルシステムコマンド（`mkdir`、`touch`、`mv`、`cp` など）を、作業ディレクトリまたは `additionalDirectories` 内のパスに対して自動的に受け入れます |
| `plan` | Claude はファイルを読み取り、読み取り専用シェルコマンドを実行して探索しますが、ソースファイルを編集しません。[auto モード](/docs/ja/permission-modes#eliminate-prompts-with-auto-mode)が利用可能で、分類器が承認したコマンドも実行されます。CLI および VS Code 拡張機能では Plan とラベル付けされています |
| `auto` | ルーチンプロンプトなしで実行されます。シェルコマンドやネットワークリクエストなどのアクションが実行される前に、バックグラウンド[分類器](/docs/ja/permission-modes#eliminate-prompts-with-auto-mode)がそれらがリクエストと一致することを確認します |
| `dontAsk` | その他の場合はプロンプトを表示するすべての呼び出しを自動的に拒否します。ただし、インストールした [mod](/docs/ja/plugins/mods/overview) がそれらの呼び出しの一部を承認することは引き続き可能です。作業ディレクトリ内のファイル読み取りおよび承認が不要なその他のアクションは実行されます。`/permissions` または `permissions.allow` ルール経由で事前に承認されたツールも実行されます。`AskUserQuestion`、MCP ツール（[`requiresUserInteraction`](/docs/ja/mcp#require-approval-for-a-specific-tool)とマークされたもの）、[ネットワークパスからの読み取り](#network-paths)、およびコネクタツール（[組織が `ask` に設定したもの](/docs/ja/mcp#organization-controls-on-connector-tools)）は、その設定が Claude Code に到達するセッションでは、許可していてもすべて拒否されます |
| `bypassPermissions` | 権限プロンプトをスキップします。ただし、[どのモードも自動承認しないアクション](/docs/ja/permission-modes#actions-no-mode-auto-approves)は除きます |

> [!WARNING]
>
> `bypassPermissions` モードでは、Claude Code は権限プロンプトをスキップします。これには [保護されたパス](/docs/ja/permission-modes#protected-paths)（`.git` や `.claude` など）への書き込みも含まれます。[クロスセッションメッセージングセーフガード](/docs/ja/permission-modes#skip-all-checks-with-bypasspermissions-mode)は引き続き適用されます。このモードは、Claude Code が損害を引き起こせないコンテナや VM などの隔離された環境でのみ使用してください。

`bypassPermissions` または `auto` モードが使用されるのを防ぐには、任意の[設定ファイル](/docs/ja/settings#where-settings-live)で `permissions.disableBypassPermissionsMode` または `permissions.disableAutoMode` を `"disable"` に設定してください。これらは、オーバーライドできない[管理設定](#managed-settings)で最も有用です。

## 権限ルール構文

権限ルールは、`Tool` または `Tool(specifier)` の形式に従います。スペシファイア内の括弧はリテラルであるため、括弧を含むコマンドまたはパスはエスケープが不要です。

### ツールのすべての使用をマッチさせる

ツールのすべての使用をマッチさせるには、括弧なしでツール名を使用します。

| ルール | 効果 |
| :- | :- |
| `Bash` | すべての Bash コマンドをマッチさせます |
| `WebFetch` | すべてのウェブフェッチリクエストをマッチさせます |
| `Read` | すべてのファイル読み取りをマッチさせます |

`Bash(*)` は `Bash` と同等で、すべての Bash コマンドをマッチさせます。拒否ルールとして、両方の形式は Claude のコンテキストからツールを削除します。

### 細かい制御のためにスペシファイアを使用する

括弧内にスペシファイアを追加して、特定のツール使用をマッチさせます。

| ルール | 効果 |
| :- | :- |
| `Bash(npm run build)` | 正確なコマンド `npm run build` をマッチさせます |
| `Read(./.env)` | 現在のディレクトリの `.env` ファイルを読み取ることをマッチさせます |
| `WebFetch(domain:example.com)` | example.com へのフェッチリクエストをマッチさせます |

### 入力パラメータでマッチさせる

拒否ルールと確認ルールは、`Tool(param:value)` を使用して任意のビルトインツール上のトップレベル入力パラメータをマッチさせることができます。

MCP ツール上のパラメータをマッチさせるには、[`--disallowedTools`](/docs/ja/cli-reference#cli-flags) を使用して拒否ルールを渡します。Claude Code が設定ファイルを読み込むとき、括弧を持つ `mcp__` ルールをスキップします。Claude Code は、インタラクティブセッションが開始されるときに無効な設定ダイアログでスキップされたルールをリストし、[`claude doctor`](/docs/ja/debug-your-config#check-resolved-settings) 出力に表示します。

パラメータルールは、Claude がそのパラメータをその正確な値に設定してツールを呼び出すときにマッチします。1 つのパラメータ値に対する許可ルールは、その呼び出しが全体的に安全であることを確立しないため、許可ルールは各ツール独自のスペシファイア構文を使用し続けます。これはツールが受け入れるスカラーパラメータで機能します。

| ルール | マッチ |
| :- | :- |
| `Agent(model:opus)` | Opus モデルティアをリクエストする Agent 呼び出し |
| `Agent(isolation:worktree)` | git worktree をリクエストする Agent 呼び出し |
| `Bash(run_in_background:true)` | バックグラウンドで実行される Bash 呼び出し |

パラメータマッチングは以下のルールに従います。

* パラメータ名は Agent ツール上の `model` など、ツールの入力の直接フィールドである必要があります。オブジェクトまたは配列内にネストされたフィールドはマッチ可能ではありません
* 各ルールは 1 つのパラメータに名前を付けます。`model` と `isolation` の両方でゲートするには、1 つのルールで組み合わせるのではなく、`Agent(model:opus)` と `Agent(isolation:worktree)` の 2 つのルールを記述します
* 値は `*` をワイルドカードとしてサポートし、任意の文字シーケンスにマッチするため、`Agent(isolation:*)` は任意の明示的な isolation 値にマッチします。`*` がない場合、マッチは正確です
* モデルが省略するパラメータは決してマッチしないため、`Agent(model:*)` は `model` が設定されていない呼び出しにはマッチしません
* 値は Claude が送信するリテラル入力と比較され、正規化の前です。`Agent(model:opus)` は別名 `opus` にマッチしますが、完全なモデル ID にはマッチしません
* `Skill(skill:<name>)` 拒否ルールは代わりに [スキルをそのいずれかの名前でマッチさせます](/docs/ja/skills#restrict-claude%E2%80%99s-skill-access)。別名や表示名など
* [`--verbose`](/docs/ja/cli-reference) で実行して、各ツール呼び出しの正確なパラメータ名と値を確認してください
* コロンの周りのホワイトスペースは無視されます

ツールのプライマリコンテンツフィールドはこの方法ではマッチ可能ではありません。Bash と PowerShell の `command`、Read、Edit、Write の `file_path`、Grep と Glob の `path`、NotebookEdit の `notebook_path`、WebFetch の `url` です。`Bash(command:rm *)` のようなルールはコンパウンドコマンドでバイパス可能であるため、Claude Code はそれを無視し、スタートアップ警告を発行します。代わりに `Bash(rm *)`、`Read(./path)`、または `WebFetch(domain:host)` を使用してください。

### ワイルドカードパターン

Bash ルールの `*` は、スペースを含む任意のテキストにマッチするため、1 つのルールはコマンドのファミリーをカバーします。`*` のないルールは 1 つの正確なコマンドにマッチします。

> [!WARNING]
>
> `*` をサブコマンドの後に配置します。`git log --oneline main` では、`git` はプログラムで `log` はサブコマンドです。サブコマンドはプログラムが何をするかを決定する単語です。Claude Code は最初の `*` の前のすべてをそのまま書かれたようにマッチさせるため、これらの単語がルールを制限するものです。`Bash(git log *)` は `git log` コマンドのみを許可し、`Bash(git *)` はすべての git コマンドを許可します。Claude Code は、`Bash(git * main)` のようなサブコマンドの前に `*` を持つ許可ルールについて [スタートアップで警告](/docs/ja/errors#has-a-wildcard-before-the-rest-of-the-command) します。

Claude が質問なしで実行するコマンドを記述し、変わる部分を `*` に置き換えます。この設定により、Claude Code は npm スクリプトと git コミットを質問なしで実行し、`git push` で始まるコマンドを拒否します。`git -C . push` のように別の書き方をした push はマッチしません。[Bash ルールがマッチしないもの](#bash-rule-limits)を参照してください。

```json theme={null}
{
  "permissions": {
    "allow": [
      "Bash(npm run *)",
      "Bash(git commit *)"
    ],
    "deny": [
      "Bash(git push *)"
    ]
  }
}
```

`*` はルール内の任意の場所に配置できます。開始時、中間、または終了時です。各行はルール、マッチするコマンド、マッチしない近くのコマンドを示します。

| 記述内容 | マッチ | マッチしない |
| :- | :- | :- |
| `Bash(npm run build)` | `npm run build` | `npm run build --watch` |
| `Bash(npm run *)` | `npm run build`、`npm run test --watch`、`npm run` | `npm install` |
| `Bash(git log * main)` | `git log --oneline main`、`git log -5 main`、`git log --output=<file> main` | `git log main`、`git push origin main` |
| `Bash(git * main)` | `git merge main`、`git push origin main`、`git -c core.fsmonitor=<script> diff main` | `git log` |
| `Bash(* --version)` | `node --version`、`bash -c 'echo hi' --version` | `node -v` |
| `Bash(ls *)` | `ls -la`、`ls` | `lsof` |
| `Bash(ls*)` | `ls -la`、`lsof` | |
| `Bash(* --help *)` | `npm --help x` | `npm --help` |

3 つのマッチングルールがこれらの行を生成します。

* **`*` はその場所にあるテキストの代わりになります。** `Bash(git * main)` では、サブコマンドの代わりになるため、Claude Code はすべての git サブコマンドとその前のすべてのオプションにマッチします。これには `-c` が含まれます。これは git に名前を付けたプログラムを実行させます。`Bash(* --version)` では、`*` はプログラムの代わりになるため、任意のプログラムがマッチします。
* **末尾の `*` とその前のスペースは、ベアコマンドにもマッチします。** `Bash(ls *)` は `ls` にマッチし、`Bash(git log *)` は `git log` にマッチします。これは末尾の `*` がルールの唯一のワイルドカードである場合にのみ成立します。`Bash(* --help *)` は `npm --help x` にマッチしますが `npm --help` にはマッチしません。
* **末尾の `*` の前のスペースはルールの一部です。** `Bash(ls *)` は `ls` の後にスペースが必要であるため、`lsof` はマッチしません。`Bash(ls*)` にはスペースがないため、`lsof` にもマッチします。

`:*` サフィックスは末尾のワイルドカードを記述する同等の方法であるため、`Bash(ls:*)` は `Bash(ls *)` と同じコマンドをマッチさせます。

権限ダイアログは、コマンドプレフィックスに対して「はい、今後は聞かない」を選択すると、スペース区切り形式を書き込みます。`:*` 形式はパターンの末尾でのみ認識されます。`Bash(git:* push)` のようなパターンでは、コロンはリテラル文字として扱われ、git コマンドにはマッチしません。

### ツール名ワイルドカード

拒否ルールと確認ルールは、ツール名の位置でもグロブパターンを受け入れます。パターンはツール名全体にマッチする必要があります。`"*"` はすべてのツールにマッチし、`"mcp__*"` はすべてのサーバー全体のすべての MCP ツールにマッチします。ベアネーム glob 拒否ルールでマッチしたツールは Claude のコンテキストから削除されます。これはベアツール名と同じです。[`EndConversation`](/docs/ja/tools-reference#endconversation-tool-behavior) 例外を含みます。glob 拒否は他のツールが残っている間はそれを削除できず、glob 確認はそれに対してプロンプトを表示しません。この設定はすべての MCP ツールを拒否します。

```json theme={null}
{
  "permissions": {
    "deny": [
      "mcp__*"
    ]
  }
}
```

許可ルールは、リテラル `mcp__<server>__` プレフィックスの後でのみツール名 glob を受け入れます。サーバーセグメントは glob フリーである必要があるため、ルールは設定した特定のサーバーに名前を付けます。`mcp__puppeteer__*` は `puppeteer` サーバーからのすべてのツールにマッチし、`mcp__github__get_*` はその `get_` ツールにマッチします。`"*"`、`"B*"`、または `"mcp__*"` などのアンカーなし許可 glob は警告とともにスキップされ、自動承認されません。

ツール名がマッチしない既知のツールを持つ拒否ルールまたは確認ルールは、タイプミスをキャッチするためにスタートアップ警告を生成します。`_` または `*` を含むツール名はチェックから除外されます。また、Claude Code が削除したツール（`TaskOutput` など）の名前も除外されます。

トランスクリプトと権限ダイアログに表示されるツールのラベルは、その正規名と異なる場合があります。たとえば、トランスクリプトで `Stop Task` というラベルが付いているツールの正規名は `TaskStop` です。権限ルールと [hook マッチャー](/docs/ja/hooks) はラベルにはマッチしないため、`Stop Task` として記述されたルールはマッチしません。拒否ルールと確認ルールの場合、上記のスタートアップ警告がミスマッチをキャッチします。[ツール参照](/docs/ja/tools-reference) に記載されている正規名を使用してください。

## ツール固有の権限ルール

### Bash

Bash ルールはコマンドテキスト全体に対してマッチし、`*` は任意のテキストを表します。各ルールの形がどのコマンドにマッチするか、また `*` をどこに置くべきかについては、[ワイルドカードパターン](#wildcard-patterns)を参照してください。このセクションの残りの部分では、Claude Code が複合コマンドとラッパーをどのようにマッチさせるか、プレフィックスルールでは承認できないラッパーと `find` アクション、ルールがマッチしないもの、読み取り専用コマンド、およびリダイレクトについて説明します。

#### 複合コマンド

> [!TIP]
>
> Claude Code はシェル演算子を認識するため、`Bash(safe-cmd *)` のようなルールで `safe-cmd && other-cmd` というコマンドの実行権限が与えられることはありません。認識されるコマンド区切りは `&&`、`||`、`;`、`|`、`|&`、`&`、および改行です。ルールは各サブコマンドに個別にマッチする必要があります。

拒否ルールと確認ルールは、いずれかのサブコマンドがマッチした場合に適用されます。これにはサブシェル、コマンド置換、または `for` ループのような制御フローの本体の中にネストされたコマンドも含まれます。`Bash(git clean *)` のような確認ルールは、[auto モード](/docs/ja/permission-modes#eliminate-prompts-with-auto-mode)であっても、`cd /tmp && git clean -f` や `echo "$(git clean -f)"` に対して引き続き確認を求めます。

`npm test &&` のように `&&` や `||` の後に何もない場合、Claude Code はそのコマンドを解析不能として扱い、許可ルールのマッチングのためにサブコマンドへ分割しません。そのため、`Bash(npm *)` のようなルールではそのコマンドは承認されません。

複合コマンドを「Yes, and don't ask again」で承認すると、Claude Code は複合文字列全体に対する単一のルールではなく、承認が必要な各サブコマンドごとに個別のルールを保存します。たとえば、`git status && npm test` を承認すると `npm test` のルールが保存されるため、今後の `npm test` の呼び出しは `&&` の前に何があっても認識されます。作業ディレクトリの外にあるディレクトリへの `cd` のようなサブコマンドは、そのパスに対する独自の Read ルールを生成します。1 つの複合コマンドに対して保存されるルールは最大 5 つです。

#### ラッパー

Bash ルールをマッチさせる前に、Claude Code は固定されたラッパーのセットを取り除きます。そのため、`Bash(npm test *)` のようなルールは `timeout 30 npm test` にもマッチします。取り除かれるラッパーは `timeout`、`time`、`nice`、`nohup`、`stdbuf`、さらにシェル組み込みの `command` と `builtin`、および zsh の `noglob` です。これらはいずれも引数を実際のコマンドとして実行します。関連する 2 つの形式は取り除かれません。コマンドを実行するのではなく検索するクエリ形式の `command -v` と、zsh の `nocorrect` です。

Claude Code は、特定の既知の安全な環境変数の先頭での代入も取り除くため、`Bash(npm test *)` は `NODE_ENV=test npm test` にマッチします。許可ルールは、それ以外の変数の代入を越えてマッチすることはありません。拒否ルールまたは確認ルールは先頭のあらゆる代入を越えてマッチするため、deny にある `Bash(rm *)` は `FOO=bar rm -rf tmp/` にも引き続きマッチします。

フラグなしの `xargs` も取り除かれるため、`Bash(grep *)` は `xargs grep pattern` にマッチします。取り除きが適用されるのは `xargs` にフラグがない場合のみです。`xargs -n1 grep pattern` のような呼び出しは `xargs` コマンドとしてマッチされるため、内側のコマンド向けに書かれたルールではカバーされません。

このラッパーリストは組み込みであり、設定できません。`direnv exec`、`devbox run`、`mise exec`、`npx`、`docker exec` などの開発環境ランナーはリストに含まれていません。これらのツールは引数をコマンドとして実行するため、`Bash(devbox run *)` のようなルールは `run` の後に続くものすべてにマッチし、`devbox run rm -rf .` も含まれます。環境ランナー内での作業を承認するには、`Bash(devbox run npm test)` のように、ランナーと内側のコマンドの両方を含む具体的なルールを書いてください。許可したい内側のコマンドごとに 1 つのルールを追加します。

#### exec ラッパーと `find` アクション

`Bash(watch *)` や `Bash(find *)` のようなプレフィックスルールでは次のコマンドを自動承認できないため、Manual モードではこれらについて確認が求められます。

* **exec ラッパー**: `watch`、`setsid`、`ionice`、`flock` など
* **`find`**: `-exec`、`-delete`、`-fprint` など、コマンドを実行する、ファイルを削除する、またはファイルに書き込むアクションを伴うもの、あるいは検索するパスをファイルから受け取る `-files0-from` を伴うもの

`*` を含まない特定の呼び出しを承認するには、`Bash(find build -type f -delete)` のように、コマンド文字列全体に対する完全一致ルールを書いてください。

`find . -name '*.tmp' -delete` のようにコマンドに `*` が含まれる場合、Claude Code はルールを完全一致ではなく[ワイルドカードパターン](#wildcard-patterns)として読み取るため、コマンドは引き続き確認を求めます。確認が求められるたびに承認するか、そのコマンドに対して `"allow"` を返す [PreToolUse フック](/docs/ja/hooks#pretooluse-decision-control)を使用してください。

#### Bash ルールがマッチしないもの

Bash ルールは、Claude Code が[複合コマンド](#compound-commands)を分割し[ラッパー](#process-wrappers)を取り除いた後の、Claude が書いたコマンドテキストにマッチします。別の形式で呼び出された同じプログラムにはマッチしないため、拒否ルールや確認ルールは Claude が通常生成する呼び出しをカバーするものであり、プログラムに対するセキュリティ境界ではありません。`deny` または `ask` にある以下のルールは、最初の形式は止めますが、その他の形式は止めません。

| ルール | 止めるもの | 止めないもの |
| :- | :- | :- |
| `Bash(curl *)` | `curl https://example.com` | `/usr/bin/curl https://example.com`、`sh -c 'curl https://example.com'` |
| `Bash(rm *)` | `rm -rf build/` | `/bin/rm -rf build/`、`bash -c 'rm -rf build/'` |
| `Bash(git push *)` | `git push origin main` | `git -C . push origin main`、`git -c push.default=current push origin main`、`git 'push' origin main` |

最後の列のコマンドは、他のルールと権限モードによって決まります。

コマンドテキストに依存しないファイルシステムおよびネットワークの強制には、[サンドボックス化](/docs/ja/sandboxing)を使用してください。コマンドの実行前に独自のロジックでコマンドテキスト全体を検査するには、[PreToolUse フック](#extend-permissions-with-hooks)を使用してください。

#### 読み取り専用コマンド

Claude Code は組み込みの Bash コマンドのセットを読み取り専用として認識し、すべてのモードで権限プロンプトなしに実行します。ただし、作業ディレクトリ外のパスについて [`permissions.blockReadsOutsideWorkingDirectories`](/docs/ja/settings-reference#permissions-blockreadsoutsideworkingdirectories) によって変更される場合を除きます。このセットには `ls`、`cat`、`echo`、`pwd`、`head`、`tail`、`grep`、`find`、`wc`、`which`、`diff`、`stat`、`du`、`cd`、および `git` の読み取り専用形式が含まれます。このセットは設定できません。これらのコマンドのいずれかで確認を必須にするには、そのコマンドに対する `ask` または `deny` ルールを追加してください。auto モードでは、これらのコマンドも分類器のレビューを待つことがあります。[分類器がアクションを評価する方法](/docs/ja/permission-modes#how-the-classifier-evaluates-actions)を参照してください。

`ls > out.txt` のようなリダイレクトでは、対象に対するチェックが追加されます。[リダイレクト](#redirections)を参照してください。

すべてのフラグが読み取り専用であるコマンドでは、引用符で囲まれていない glob パターンが許可されるため、`ls *.ts` や `wc -l src/*.py` は確認なしで実行されます。

Manual モードでは、このセットのコマンドでも次の場合には確認が求められます。

* **書き込み可能なフラグを持つコマンドでの引用符なしの glob**: `find`、`sort`、`sed`、`git` など、書き込みまたは実行が可能なフラグを持つコマンドは、引用符で囲まれていない glob が存在する場合に確認を求めます。glob が `-delete` のようなフラグに展開される可能性があるためです。
* **別のデーモンを指す `docker`**: `docker` の読み取り専用形式は、`-H`、`--context`、または Podman の `--url` や `--connection` など、別のデーモンを選択するフラグをコマンドが含む場合に確認を求めます。
* **パスを開くフラグを伴う `file`**: `file` は、`-m`/`--magic-file` または `-f`/`--files-from` を渡す場合に確認を求めます。これらのフラグにより、`file` がフラグの値で指定されたパスを開くためです。
* **環境変数を出力する可能性のある `ps`**: `ps` は、`ps auxe` や `ps aux -e` のように、引数のいずれかが `e` オプションとして機能しうる場合に確認を求めます。このオプションはプロセスの環境変数を出力するためです。`ps aux` と `ps -ef` は確認なしで実行されます。`ps aux -e` のようなダッシュ付き形式のチェックには Claude Code v2.1.290 以降が必要です。
* **Windows 上のネットワークパス**: `\\server\share\file` のようなネットワーク（UNC）パスを引数に含むコマンドは確認を求めます。ネットワークパスへのアクセスにより、Windows の認証情報がそのパスで指定されたホストに送信される可能性があるためです。同じチェックが [PowerShell ツール](/docs/ja/tools-reference#powershell-tool)のコマンドにも適用されます。
* **特殊なシェル変数への書き込み**: `PATH` や `IFS` など、特定の特殊なシェル変数を設定、解除、またはループするコマンドは、コマンドの残りの部分が読み取り専用であっても確認を求めます。
* **解析できないコマンド**: Claude Code がコマンドを完全に解析できない場合、そのコマンドを読み取り専用として扱うのではなく承認を求めます。10,000 文字を超えるコマンドは、解析できる範囲を超えるため常に確認を求めます。

作業ディレクトリまたは[追加ディレクトリ](#working-directories)内のパスへの `cd` も読み取り専用であり、`cd packages/api && ls` のような複合コマンドは、各部分がそれぞれ条件を満たす場合に確認なしで実行されます。以下の組み合わせは、各部分が読み取り専用であっても確認を求めます。

* **`cd` と `git`**: `cd` が別のディレクトリに移動する場合に確認を求めます。新しいディレクトリで `git` を実行すると、そのディレクトリのフックが実行される可能性があるためです。対象が現在の作業ディレクトリに解決される `cd` は何もしない操作であり、確認は発生しません。
* **`cd` とリダイレクト**: `cd` の実行後にリダイレクト先がどのディレクトリを基準に解決されるかを Claude Code が判断できない場合に確認を求めます。`cd app; grep -r pattern . 2>/dev/null` のように、リダイレクト先が `/dev/null` のみであるコマンドは確認を求めません。`/dev/null` は作業ディレクトリに依存しないためです。

> [!WARNING]
>
> コマンドの引数を制限しようとする Bash 権限パターンは脆弱です。たとえば、`Bash(curl http://github.com/ *)` は curl を GitHub の URL に制限することを意図していますが、次のようなバリエーションにはマッチしません。
>
> * URL の前のオプション: `curl -X GET http://github.com/...`
> * 異なるプロトコル: `curl https://github.com/...`
> * リダイレクト: GitHub にリダイレクトされる `curl -L http://short.example.com/xyz`
> * 変数: `URL=http://github.com && curl $URL`
>
> より信頼性の高い URL フィルタリングのためには、次の方法を検討してください。
>
> * **Bash のネットワークツールを制限する**: 拒否ルールを使用して `curl`、`wget` などのコマンドを止め、許可するドメインについては WebFetch ツールと `WebFetch(domain:github.com)` 権限を使用します。拒否ルールはパス指定や `sh -c` 内の同じプログラムにはマッチしないため、制限を確実に維持する必要がある場合は[サンドボックスのネットワーク許可リスト](/docs/ja/sandboxing#network-isolation)と組み合わせてください。[Bash ルールがマッチしないもの](#bash-rule-limits)を参照してください
> * **PreToolUse フックを使用する**: Bash コマンド内の URL を検証し、許可されていないドメインをブロックするフックを実装します
> * **CLAUDE.md にガイダンスを追加する**: 許可する curl パターンを `CLAUDE.md` に記述します。これは Claude が試みる内容を方向付けますが境界を強制するものではないため、上記のいずれかの方法と組み合わせてください
>
> WebFetch を使用するだけではネットワークアクセスは防げないことに注意してください。Bash が許可されている場合、Claude は引き続き `curl`、`wget`、その他のツールを使用して任意の URL にアクセスできます。

#### リダイレクト

コマンドが出力または入力をリダイレクトする場合、Claude Code は、Claude がそのファイルを直接書き込んだり読み取ったりした場合と同様に、リダイレクト先をファイルルールと照合してチェックします。

* **出力リダイレクト**: `> file`、`>> file`、`2> file` の場合、チェックは `Edit` の許可ルールと拒否ルール、[保護されたパス](/docs/ja/permission-modes#protected-paths)、および[作業ディレクトリ](#working-directories)を対象とします。`Bash(git commit *)` のようなルールはコマンドを許可するものであり、リダイレクト先を許可するものではありません。`~` で始まる、または glob 文字を含むリダイレクト先には承認が必要です。
* **入力リダイレクト**: `< file` の場合、チェックは `Read` の許可ルールと拒否ルール、および作業ディレクトリを対象とします。作業ディレクトリ外のリダイレクト先には、許可ルールでカバーされていない限り承認が必要です。glob パターンを含むリダイレクト先、または同じコマンド内の `cd` の後に続く相対パスは、許可ルールでカバーされていても承認が必要です。Claude Code は v2.1.257 以降で入力先をチェックします。

背後にファイルが存在しないリダイレクト先はチェックされません。`/dev/null`、`2>&1` や `<&3` のようなファイルディスクリプタ形式、およびヒアドキュメントとヒアストリングがこれに該当します。

Claude Code は、`make | tee build.log` のようなパイプライン内を含め、`tee` コマンドが書き込むファイルもチェックします。チェックは `Edit` の許可ルールと拒否ルール、[保護されたパス](/docs/ja/permission-modes#protected-paths)、および[作業ディレクトリ](#working-directories)を対象とします。`Bash(tee *)` のような許可ルールは、作業ディレクトリ外の書き込み先をカバーしません。Claude Code は v2.1.269 以降で `tee` の書き込み先をチェックします。

### PowerShell

PowerShell の権限ルールは Bash ルールと同じ形式を使用します。`*` によるワイルドカードは任意の位置でマッチし、`:*` サフィックスは末尾の ` *` と同等であり、単独の `PowerShell` または `PowerShell(*)` はすべてのコマンドにマッチします。次の設定は、`Remove-Item` をブロックしつつ、`Get-ChildItem` と `git commit` コマンドを許可します。

```json theme={null}
{
  "permissions": {
    "allow": [
      "PowerShell(Get-ChildItem *)",
      "PowerShell(git commit *)"
    ],
    "deny": [
      "PowerShell(Remove-Item *)"
    ]
  }
}
```

一般的なエイリアスはマッチング前に正規化されます。コマンドレット名に対して書かれたルールはそのエイリアスにもマッチするため、`PowerShell(Get-ChildItem *)` は `gci`、`ls`、`dir` にもマッチします。マッチングでは大文字と小文字は区別されません。

Claude Code は PowerShell の AST を解析し、複合コマンド内の各コマンドを個別にチェックします。パイプライン演算子 `|`、ステートメント区切り `;`、および PowerShell 7 以降ではチェーン演算子 `&&` と `||` によって、複合コマンドはサブコマンドに分割されます。複合コマンドが許可されるには、ルールがすべてのサブコマンドにマッチする必要があります。

### Read と Edit

Claude のファイルツールによるファイルやディレクトリの読み取りをブロックするには、`Read(./.env)` や `Read(./secrets/**)` のように、そのパスに対する `Read` 拒否ルールを追加してください。[機密ファイルを除外する](/docs/ja/settings-reference#exclude-sensitive-files)に、そのまま貼り付けて使える例があります。プロジェクトに `.claudeignore` ファイルがある場合、それは効果がないため、そのエントリを `Read` 拒否ルールに移してください。

`Edit` ルールは、ファイルを編集するすべての組み込みツールに適用されます。Claude は、Grep や Glob のようなファイルを読み取るすべての組み込みツール、プロンプト内の `@file` メンション、および接続された [IDE](/docs/ja/vs-code#the-built-in-ide-mcp-server) が Claude と共有する選択範囲や開いているファイルのコンテキストに対して、`Read` ルールをベストエフォートで適用しようとします。

`Read(path)` 拒否ルールは、プロンプトに貼り付けた画像パスや @ メンションしたディレクトリにも適用されます。

* **画像パス**: ターミナルでプロンプトに画像のパスを貼り付けたり画像ファイルをドラッグしたりしたときに、ルールがそのパスにマッチする場合、Claude Code は画像を添付しません。貼り付けた内容に他の画像が含まれていない場合、パスはテキストとしてプロンプトに残ります。
* **ディレクトリ**: [Claude が受け取る一覧](/docs/ja/common-workflows#reference-files-and-directories)から、ルールにマッチするファイル名とディレクトリ名が除外されます。

Claude Code は v2.1.290 以降で、貼り付けられた画像パスとディレクトリ一覧をチェックします。

`Read` 拒否ルールは、同じパスに対する [Edit ツールと Write ツール](/docs/ja/errors#file-is-covered-by-a-read-deny-rule)もブロックします。これにはそのパスへの新しいファイルの作成も含まれます。NotebookEdit は対象外であるため、どのツールにも変更させたくないパスには `Edit` 拒否ルールを追加してください。Write ツールの場合、このチェックには Claude Code v2.1.228 以降が必要です。

Claude Code は、ファイル権限を `Edit(path)` ルールと `Read(path)` ルールに対してのみチェックします。代わりに `Write`、`NotebookEdit`、`Glob`、または従来の `MultiEdit` ツールに対するパスルールを書いた場合、Claude Code はそのルールを受け入れますが参照することはなく、[起動時に警告します](/docs/ja/errors#is-not-matched-by-file-permission-checks)。ただし、`--allowedTools` で渡された `Glob` ルールは除きます。`Write(docs/**)`、`NotebookEdit(docs/**)`、`MultiEdit(docs/**)` の代わりに `Edit(docs/**)` を、`Glob(docs/**)` の代わりに `Read(docs/**)` を使用してください。`Write` に対する拒否ルールのような、パスを持たないツール名のルールについては、Claude Code は警告しません。そのルールはあらゆる場所でツールレベルでマッチします。

> [!WARNING]
>
> Read と Edit の拒否ルールは、Claude の組み込みファイルツール、`cat`、`head`、`tail`、`sed`、`tee` など Claude Code が Bash 内で認識するファイルコマンド、および `> file` や `< file` のような Bash [リダイレクト](#redirections)の対象に適用されます。ファイルを含むディレクトリから実行される `grep -r pattern .` のようにファイル名を指定せずにファイルを読み取るコマンドや、ファイル自体を開く Python や Node のスクリプトのように間接的にファイルを読み書きする任意のサブプロセスには適用されません。すべてのプロセスによるパスへのアクセスをブロックする OS レベルの強制には、[サンドボックスを有効にしてください](/docs/ja/sandboxing)。

Read ルールと Edit ルールはどちらも、4 つの異なるパターンタイプを持つ [gitignore](https://git-scm.com/docs/gitignore) パターン構文を使用します。単一セグメントのディレクトリパターンの場合、マッチする深さはルールの種類にも依存します。これについてはこのセクションの後半で説明します。

| パターン | 意味 | 例 | マッチするもの |
| - | - | - | - |
| `//path` | ファイルシステムのルートからの絶対パス | `Read(//Users/alice/secrets/**)` | `/Users/alice/secrets/**` |
| `~/path` | ホームディレクトリからのパス | `Read(~/Documents/*.pdf)` | `/Users/alice/Documents/*.pdf` |
| `/path` | 設定ソースからの相対パス | `Edit(/src/**/*.ts)` | プロジェクト設定では `<primary working directory>/src/**/*.ts` |
| `path` または `./path` | 現在のディレクトリからの相対パス | `Read(*.env)` | `<cwd>/*.env` |

> [!WARNING]
>
> `/Users/alice/file` のようなパターンは絶対パスではありません。先頭の単一のスラッシュは、ファイルシステムのルートではなく設定ソースを基準にします。絶対パスには `//Users/alice/file` を使用してください。

`/path` パターンは、それを定義する設定ソースに関連付けられたディレクトリを基準にするため、同じルールでも配置する場所によって異なる場所にマッチします。

| ルールの定義場所 | `/path` の解決先 |
| :- | :- |
| `.claude/settings.json` のプロジェクト設定 | `<primary working directory>/path` |
| `.claude/settings.local.json` のローカル設定 | `<primary working directory>/path` |
| `~/.claude/settings.json` のユーザー設定 | `~/.claude/path` |
| `--settings <file>` で渡されたファイル | `<directory of file>/path` |
| CLI フラグまたはセッションルール | `<primary working directory>/path` |

`/permissions` で追加したルールは、保存先の設定ファイルに対応する行に従います。

v2.1.211 以降、ローカル設定のルールは、Claude Code が[ファイルを保存する](#permission-system)リポジトリのルートではなく、セッションの[プライマリ作業ディレクトリ](#working-directories)を基準にします。リポジトリのルートで開始されたセッションでは 2 つのディレクトリは同じです。[worktree](/docs/ja/worktrees) セッションでは、`Edit(/src/**)` のような共有ルールはその worktree 自体の `src/` ディレクトリにマッチします。

ユーザー設定にある `Read(/secrets/**)` のような拒否ルールは、プロジェクト内の `secrets` ディレクトリではなく、`~/.claude/secrets/**` をブロックします。すべてのプロジェクト内で適用されるルールをユーザー設定に書くには、代わりに `//` の絶対パスまたは `~/` のホーム相対パスを使用してください。

Windows では、パスはマッチング前に POSIX 形式に正規化されます。`C:\Users\alice` は `/c/Users/alice` になるため、そのドライブ上の任意の場所にある `.env` ファイルにマッチさせるには `//c/**/.env` を使用してください。すべてのドライブにわたってマッチさせるには、`//**/.env` を使用してください。

例:

* `Edit(/docs/**)`: `<primary working directory>/docs/` 内の編集。`/docs/` や `<primary working directory>/.claude/docs/` ではありません
* `Read(~/.zshrc)`: ホームディレクトリの `.zshrc` の読み取り
* `Edit(//tmp/scratch.txt)`: 絶対パス `/tmp/scratch.txt` の編集
* `Read(src/**)`: 許可ルールとしては `<current-directory>/src/` からのみ読み取り、拒否ルールまたは確認ルールとしては現在のディレクトリ配下の任意の深さにある `src` ディレクトリにマッチ

ルールはその基準点の配下にあるファイルにのみマッチします。その範囲内では、マッチする深さはパターンの形と、単一セグメントのディレクトリパターンの場合はルールの種類に依存します。これについては以下で説明します。単独のファイル名は gitignore のセマンティクスに従い任意の深さでマッチするため、`Read(.env)` と `Read(**/.env)` は同等です。

| 拒否ルール | ブロックするもの | ブロックしないもの |
| - | - | - |
| `Read(.env)` または `Read(**/.env)` | 現在のディレクトリ以下にある任意の `.env` | 親ディレクトリや別のプロジェクトにある `.env` |
| `Read(//**/.env)` | ファイルシステム上のあらゆる場所にある任意の `.env` | なし。ルールはファイルシステムのルートを基準にしています |

`src/**` のように単一のディレクトリセグメントを持つ相対パターンは、ルールの種類によって異なる深さでマッチします。

* **許可ルール**: `Edit(src/**)` は `<cwd>/src` とその配下のファイルのみにマッチします。任意の深さのディレクトリ名を許可するには、`Edit(**/src/**)` と書いてください。
* **拒否ルールと確認ルール**: `Read(secrets/**)` は現在のディレクトリ配下の任意の深さにある `secrets` という名前のディレクトリにマッチするため、ルールはネストされたコピーにも適用されます。

その他のすべてのパターンの形は、どのルールの種類でも同じ深さでマッチします。`Edit(/src/**)` と `Edit(src/components/**)` は基準となる場所でのみマッチし、`Edit(**/src/**)` は任意の深さでマッチします。

次の例は、トップレベルの `src/` ディレクトリと `vendor/` 配下にネストされたコピーを持つプロジェクトに対して、各パターンの形がどのようにマッチするかを示しています。

```text theme={null}
<current-directory>/
├── src/
│   └── app.ts
└── vendor/
    └── pkg/
        └── src/
            └── lib.js
```

| ルール | `src/app.ts` にマッチ | `vendor/pkg/src/lib.js` にマッチ |
| :- | :- | :- |
| 許可ルールとしての `Edit(src/**)` | はい | いいえ |
| 拒否ルールまたは確認ルールとしての `Edit(src/**)` | はい | はい |
| 任意のルールの種類での `Edit(/src/**)` | はい | いいえ |
| 任意のルールの種類での `Edit(**/src/**)` | はい | はい |

> [!NOTE]
>
> gitignore パターンでは、`*` は単一のパスセグメント内でマッチし、パターン内の任意の位置に置くことができます。一方、`**` はディレクトリをまたいでマッチします。

ファイルパスを「Yes, and don't ask again」で承認すると、Claude Code はそのパス内の `[`、`]`、`*` などの gitignore パターン文字をエスケープするため、生成されたルールは承認したリテラルのパスのみにマッチします。自分で書いたルールはエスケープされません。

パス内の括弧をエスケープする必要はないため、`Edit(./Finance (2024)/**)` は表記どおりの `Finance (2024)` フォルダにマッチします。

gitignore パターンとして使用できないパスを持つ拒否ルールまたは確認ルールも、その正確なパスを引き続き保護します。使用できないパターンを持つ許可ルールは何も承認しません。

`!` で始まる拒否パターンまたは確認パターンは gitignore の否定です。これは、その前に列挙された `path` または `./path` ルールから、マッチするパスを除外します。1 つの設定ファイルの `deny` リストで、`Read(*.env)` の後に `Read(!sample.env)` が続く場合、名前が `.env` で終わる任意の深さのファイルをすべてブロックしますが、`sample.env` という名前のファイルは除外されます。最初に列挙された `!` ルールは何も除外しません。

除外が及ぶのは同じソースのルールのみです。プロジェクト設定または `--disallowedTools` にある `Read(!.env)` は、管理設定やその他の設定ファイルにある `Read(./.env)` 拒否を取り消しません。

`!` パターンで除外できる範囲は、次の 2 つの制限によって狭まります。

* Claude Code は、`!` の後に `/`、`~/`、`//` が続く場合でも `!` パターンを現在のディレクトリからの相対パスとして読み取るため、パターンはこれらのプレフィックスのいずれかを基準とするルールには及びません。`Read(!~/notes/public/**)` は `Read(~/notes/**)` から何も除外しません。
* 除外によって、ルールがディレクトリ全体としてブロックしているディレクトリ内のファイルを再び開くことはできません。`Read(secrets/**)` と `Read(!secrets/public/**)` がある場合、Claude Code は `secrets` の残りの部分と一緒に `secrets/public` も引き続きブロックします。

#### シンボリックリンク

Claude が要求したファイルパスがシンボリックリンクを経由する場合、権限チェックは 2 つのパスを対象とします。Claude が要求したパスと、その解決先のファイルです。これは macOS、Linux、Windows のシンボリックリンクと、Windows のディレクトリジャンクションに適用されます。

##### ルールがシンボリックリンクされたパスにマッチする仕組み

許可ルールと拒否ルールは、要求されたパスとその解決先のファイルを異なる方法で扱います。

* **許可ルール**: 要求されたパスとその解決先のファイルの両方がマッチする場合にのみ適用されます。許可されたディレクトリ内にあり、その外を指すシンボリックリンクを介した読み取りは、ルールにマッチしません。
* **拒否ルール**: 要求されたパスまたはその解決先のファイルのいずれかがマッチする場合に適用されます。拒否されたファイルを指すシンボリックリンクは、それ自体が拒否されます。たとえば、`Read(./project/**)` が許可され、`Read(~/.ssh/**)` が拒否されている場合、`~/.ssh/id_rsa` を指す `./project/key` のシンボリックリンクはブロックされます。リンク先が許可ルールを満たさず、拒否ルールにマッチするためです。

macOS と Linux では、`//`、`~/`、`/` パターンを使ってシンボリックリンクされたディレクトリを経由して書かれた拒否ルールまたは確認ルールは、そのディレクトリの実際の場所にも適用されます。たとえば、`/etc` が `/private/etc` に解決される macOS では、`Read(//etc/**)` は `/private/etc/hosts` もブロックします。v2.1.268 より前では、シンボリックリンクされたディレクトリを経由して書かれた拒否ルールまたは確認ルールは、実際の場所で指定されたパスには適用されませんでした。

Grep と Glob は、`path` 引数の解決先のディレクトリを検索します。Claude Code は、そのディレクトリに `Read` 拒否ルールを適用します。

##### シンボリックリンクを介した書き込み

Claude が編集または書き込みを求めるパス自体がシンボリックリンクである場合、Edit ツールと Write ツールは[書き込みを拒否し、Claude にリンク先を指示します](/docs/ja/errors#refusing-after-a-symlink-changed)。

ファイルへの経路上のディレクトリがシンボリックリンクである場合や、Bash または PowerShell のコマンドが書き込みを行う場合は、書き込みがシンボリックリンクを通過することがあります。このような書き込みでは、書き込みの解決先のファイルが[作業ディレクトリ](#working-directories)と[保護されたパス](/docs/ja/permission-modes#protected-paths)に対してどこに位置するかによって動作が決まります。

* **作業ディレクトリ外に解決される場合**: 要求されたパスが作業ディレクトリ内にあり、その解決先のファイルが作業ディレクトリ外にある場合、[`acceptEdits` モード](/docs/ja/permission-modes#auto-approve-file-edits-with-acceptedits-mode)では書き込みは自動承認されません。[auto モード](/docs/ja/permission-modes#eliminate-prompts-with-auto-mode)では、許可ルールが書き込みを承認しない限り、分類器が判断するのではなくユーザーに確認が求められます。確認には書き込みの解決先のパスが表示されます。
* **要求されたパスが指定していない保護されたパスに解決される場合**: [保護されたパスの表](/docs/ja/permission-modes#protected-paths)に各権限モードでの結果が示されています。ただし、表で書き込みが分類器に回される場合、この書き込みでは代わりにユーザーに確認が求められます。

##### 解決できない、または変化するパス

たとえばパス上のシンボリックリンクがループを形成しているなどの理由で、Claude Code がパスのディスク上の行き先を判断できない場合、Read、Edit、Write ツールは[操作を拒否します](/docs/ja/errors#refusing-after-a-symlink-changed)。

その後ツールが承認済みのファイルを開くときには、[パスが引き続き権限チェックで承認された場所に解決されることを確認します](/docs/ja/errors#refusing-after-a-symlink-changed)。

#### ネットワークパス

Read、Grep、Glob など、Claude のファイル読み取りツールがネットワークパスから読み取る場合、その読み取りには独自の権限チェックが行われます。ネットワークパスとは、別のコンピューターに到達しうるパスのことです。Windows では `\\server\share\file` のような UNC パス、macOS と Linux では `/net/fileserver/notes.txt` のような `/net` 自動マウントパスが該当します。このようなパスを参照すると、そのパスで指定されたホストに接続する可能性があり、Windows ではその接続によってホストに認証情報が送信される可能性があります。シェルコマンドには独自のチェックがあります。Manual モードでは、UNC パスを引数に含む読み取り専用の Bash または PowerShell コマンドは [Windows 上で引き続き確認を求めます](#read-only-commands)。

Claude Code v2.1.292 以降では、次のいずれの場合も確認はそのまま残ります。

* **許可ルール**: `Read` のようなツール全体に対するルールを含め、ルールは読み取りを事前承認しません
* **PreToolUse フック**: `"allow"` を返す[フック](#extend-permissions-with-hooks)は確認をスキップしません
* **auto モード**: 確認はユーザーに届き、[分類器](/docs/ja/permission-modes#eliminate-prompts-with-auto-mode)は読み取りを判断しません

`dontAsk` モードでは、Claude Code は確認を求める代わりに読み取りを拒否します。`bypassPermissions` モード、および[権限のバイパス](/docs/ja/permission-modes#skip-all-checks-with-bypasspermissions-mode)が利用可能な plan モードの対話型ターミナルセッションでは、読み取りはこの確認なしで実行されます。

この確認なしでネットワーク共有上のファイルを読み取るには、まず共有にローカルパスを割り当ててください。

* **Windows**: [作業ディレクトリ](#working-directories)で説明されているように、共有をドライブ文字にマッピングし、Claude Code の起動時に `--add-dir` でそのドライブを渡します
* **macOS と Linux**: [Working directory is a network path](/docs/ja/errors#working-directory-is-a-network-path) で説明されているように、`/mnt` や `/Volumes` 配下のディレクトリなどのローカルパスに共有をマウントし、そこからファイルを読み取ります

### WebFetch

WebFetch ルールは `domain:` プレフィックスを使用し、要求された URL のホスト名に対してマッチします。マッチングでは大文字と小文字は区別されず、`*` ワイルドカードをサポートし、ルールとホスト名の両方から末尾の `.` を取り除くため、`example.com.` と `example.com` は同じものとして扱われます。

* `WebFetch(domain:example.com)` は `example.com` へのリクエストのみにマッチします。`api.example.com` のようなサブドメインもカバーするには、`WebFetch(domain:*.example.com)` ルールを追加してください
* `WebFetch(domain:*.example.com)` は、`api.example.com` や `a.b.example.com` など任意の深さのサブドメインにマッチしますが、`example.com` 自体にはマッチしません
* `WebFetch(domain:*)` はすべてのドメインにマッチします。これは単独の `WebFetch` ルールとは異なります。[すべての取得を許可または拒否する](#allow-or-deny-every-fetch)を参照してください

先頭の `*.` または単独の `*` 以外の位置では、ワイルドカードは 2 つのドットの間のテキストにのみマッチします。`WebFetch(domain:example.*)` は `*` が `org` になる `example.org` にはマッチしますが、`*` が `evil.com` になってドットをまたぐ必要がある `example.evil.com` にはマッチしません。これにより、末尾のワイルドカードが攻撃者が登録しうるドメインにマッチすることを防ぎます。

`WebFetch` ルールのワイルドカードで取得をマッチさせるには、Claude Code v2.1.172 以降が必要です。

#### すべての取得を許可または拒否する

単独の `WebFetch` ルールとは、`"deny": ["WebFetch"]` のように `domain:` 部分を持たないツール名です。これと `WebFetch(domain:*)` はどちらもすべての URL をカバーしますが、Claude Code はそれらを異なる方法で適用し、`domain:` 形式のみがそのドメインをサンドボックスの[許可または拒否ドメインリスト](/docs/ja/sandboxing#network-isolation)にも追加します。そのセクションには、サンドボックスが受け入れるワイルドカード形式と、単独の `*` が追加されたバージョンが記載されています。

各行は、ルールが `allow` リストと `deny` リストでそれぞれ何をするかを示しています。

| ルール | `allow` の場合 | `deny` の場合 |
| :- | :- | :- |
| `WebFetch` | Claude は確認なしで取得します。サンドボックス化されたコマンドが到達できるホストは変わりません。 | Claude Code は `WebFetch` ツールを削除するため、Claude は一切取得できません。サンドボックス化されたコマンドが到達できるホストは変わりません。 |
| `WebFetch(domain:*)` | Claude は確認なしで取得し、サンドボックス化されたコマンドは任意のホストに到達できます。 | Claude Code はツールを保持したまま各取得を拒否し、サンドボックス化されたコマンドはどのホストにも到達できません。 |

2 つの形式は、Artifact ツールが claude.ai に公開するページである[アーティファクト](/docs/ja/artifacts)の読み取りについても異なります。単独の `WebFetch` 拒否ルールまたは確認ルールは、それらの読み取りには適用されません。`WebFetch(domain:claude.ai)` や `WebFetch(domain:*)` のように、`claude.ai` または `*.claudeusercontent.com` コンテンツホストをカバーする `domain:` ルールは、各読み取りを拒否するか、その前に確認を求めます。[`Artifact` ルール](/docs/ja/artifacts#disable-artifacts)も同じ動作をします。

ルールが読み取りをブロックすると、拒否メッセージにそのルールが表示されます。v2.1.268 より前では、単独の `WebFetch` 拒否ルールはすべてのアーティファクトの読み取りをブロックし、単独の確認ルールはそれぞれの読み取りの前に確認を求めていました。

サンドボックスの許可リストをそのままにしつつ Claude に自由に取得させるには、単独の形式を使用します。次の `settings.json` はそれを行います。

```json theme={null}
{
  "permissions": {
    "allow": ["WebFetch"]
  }
}
```

Claude にページの取得を依頼すると、確認なしで取得します。サンドボックスの許可リスト外のホストに対して[サンドボックス化された](/docs/ja/sandboxing) `curl` の実行を依頼した場合、単独のルールはそのホストを許可リストに追加していないため、Claude Code は引き続きそのホストについて確認を求めます。

[auto モード](/docs/ja/permission-modes#eliminate-prompts-with-auto-mode)では、Claude は代わりに、分類器がレビューできるよう、コマンドの[コマンドごとの許可ドメイン](/docs/ja/sandboxing#per-command-allowed-domains-in-auto-mode)にそのホストを指定します。

### MCP

MCP サーバーのすべてのツールにマッチさせるには、`mcp__<server>__*` と書きます。1 つのツールにマッチさせるには、その完全な名前 `mcp__<server>__<tool>` を書きます。

* `mcp__puppeteer` は `puppeteer` サーバーが提供する任意のツールにマッチします
* `mcp__puppeteer__*` はワイルドカード構文を使用し、同じく `puppeteer` サーバーのすべてのツールにマッチします
* `mcp__puppeteer__puppeteer_navigate` は `puppeteer` サーバーが提供する `puppeteer_navigate` ツールにマッチします

`<server>` には、そのサーバーのツール名に表示されるとおりにサーバー名を書きます。以下の例は、特殊文字を含む名前、プラグインのサーバー、および `__` を含む、または `_` で終わる名前について書くべきルールを示しています。

* **`.` やスペースなどの文字を含む名前**: これらの文字は `_` になるため、`my.server` として設定したサーバーには `mcp__my_server__*` と書きます
* **プラグインが提供するサーバー**: `<server>` は[プラグインスコープの形式](/docs/ja/mcp#plugin-provided-mcp-servers)をとるため、`my-plugin` という名前のプラグイン内の `database-tools` サーバーには `mcp__plugin_my-plugin_database-tools__*` と書きます
* **`__` を含む、または `_` で終わる `<server>`**: 名前全体を使ったワイルドカード形式 `mcp__<server>__*` を書きます。`reports__v2` という名前のサーバーには、`mcp__reports__v2__*` と書きます。単独の `mcp__reports__v2` や短い `mcp__reports` は、Claude Code がどちらも `reports` という名前のサーバーに対するルールとして読み取るため、許可ルールとしてはそのツールにマッチしません

組織が [claude.ai コネクタ](/docs/ja/mcp#organization-controls-on-connector-tools)のツールを `ask` に設定しており、その設定がセッション内の Claude Code に届いている場合、そのツールに対する許可ルールは効果を持ちません。Claude Code は `auto` モードや `bypassPermissions` モードであっても、すべての呼び出しで確認を求めます。確認を一切求めない `dontAsk` モードでは、Claude Code は代わりに呼び出しを拒否します。Claude Code 自体が取得するコネクタのツールは、`mcp__claude_ai_<server>__<tool>` として表示されます。

Claude Desktop アプリの [Cowork](https://claude.com/docs/cowork/overview) セッションでは、Claude は組み込みの `Bash` ツールではなく Cowork の `mcp__workspace__bash` ツールを通じてシェルコマンドを実行し、同様に Cowork は Web 取得用に `mcp__workspace__web_fetch` を提供します。Claude Code は、`Bash` または `WebFetch` ツール全体を指定する拒否ルールをこれらの Cowork ツールにも適用するため、管理設定の `Bash` 拒否ルールは Claude が Cowork でシェルコマンドを実行するのを止めます。Claude Code がそのような呼び出しをブロックすると、メッセージには Cowork ツールの名前が表示されます: `Permission to use mcp__workspace__bash has been denied.` 許可ルールは引き継がれません。Claude Code が `Bash` 許可ルールを `mcp__workspace__bash` に適用することはありません。

### Agent（サブエージェント）

`Agent(AgentName)` ルールを使用して、Claude が使用できる[サブエージェント](/docs/ja/sub-agents)を制御します。

* `Agent(Explore)` は Explore サブエージェントにマッチします
* `Agent(Plan)` は Plan サブエージェントにマッチします
* `Agent(my-custom-agent)` は `my-custom-agent` という名前のカスタムサブエージェントにマッチします

特定のエージェントを無効にするには、これらのルールを設定の `deny` 配列に追加するか、`--disallowedTools` CLI フラグを使用します。Explore エージェントを無効にするには、次のようにします。

```json theme={null}
{
  "permissions": {
    "deny": ["Agent(Explore)"]
  }
}
```

### Cd

`Cd` ルールは、[`/cd` コマンド](/docs/ja/commands)がセッションを移動できるディレクトリを制御します。`Cd` はモデルが呼び出せるツールではありません。Claude はこれを呼び出すことができず、ルールはユーザー自身が `/cd` を実行した場合にのみ適用されます。

単独の `Cd` 拒否ルールは `/cd` を完全に無効にします。`Cd(<path-pattern>)` 拒否ルールは、マッチする移動先をブロックします。拒否ルールは、解決の過程で経由する各シンボリックリンクのホップを含め、移動先のあらゆる表記をチェックするため、あるパスに対して書かれたルールは、そのパスに解決される移動先もブロックします。

`Cd` 許可ルールを 1 つでも追加すると、`/cd` は許可リストモードに切り替わります。解決された移動先のディレクトリがいずれかの許可ルールにマッチする必要があり、マッチしない場合 `/cd` は拒否します。`Cd` ルールが設定されていない場合、`/cd` はデフォルトの動作を維持し、見慣れないディレクトリを信頼するかどうかの確認を求めます。

パスパターンは [Read と Edit のルール](#read-and-edit)と同じ `//`、`~/`、`/` の基準を共有しますが、マッチングは gitignore スタイルではなくディレクトリパス全体に対して行われます。`*` はちょうど 1 つのパスセグメントにマッチし、`**` はセグメントをまたいでマッチします。末尾の `/**` は、指定されたルート自体にもマッチします。

| ルール | マッチするもの | マッチしないもの |
| - | - | - |
| `Cd(~/code/*)` | `~/code/app` | `~/code/app/src`、`~/code` |
| `Cd(~/code/**)` | `~/code` およびその配下の任意のディレクトリ | `~/code` 外のディレクトリ |
| `Cd(**/node_modules)` | 現在のディレクトリ配下の任意の深さにある任意の `node_modules` ディレクトリ | `node_modules/pkg` |

## フックで権限を拡張する

[Claude Code フック](/docs/ja/hooks-guide)は、実行時に権限評価を実行するカスタムシェルコマンドを登録する方法を提供します。Claude Code がツール呼び出しを行うと、PreToolUse フックは権限プロンプトの前に実行されます。ただし、[`EndConversation`](/docs/ja/tools-reference#endconversation-tool-behavior)を除くすべてのツールに対して実行されます。フック出力はツール呼び出しを拒否し、プロンプトを強制し、またはプロンプトをスキップしてコールを続行させることができます。

### ルール、フック、mod の間の優先順位

PreToolUse フック決定は権限ルールをバイパスしません。Claude Code は deny ルールと ask ルールを、フックが何を返すかに関係なく評価します。マッチする deny ルールはコールをブロックし、マッチする ask ルールはフックが `"allow"` または `"ask"` を返した場合でもプロンプトを表示します。これは、[権限を管理する](#manage-permissions)で説明されている deny 優先の優先順位を保持し、管理設定で設定された deny ルールを含みます。

その優先順位は、設定ファイル内のフックとプラグインの `hooks/hooks.json` 内のフックをカバーしています。インストールした [mod](/docs/ja/plugins/mods/overview) が [`tool.check`](/docs/ja/plugins/mods/events#approve-or-refuse-a-tool-call-before-the-user-is-asked) イベントを処理する場合、その mod は `PreToolUse` フックの実行後に応答します。マシン上に[管理設定](/docs/ja/settings#check-what-your-organization-enforces)がある場合、またはセッションの認証情報が Team または Enterprise の [`/login`](/docs/ja/authentication#authentication-precedence) である場合、mod がコールを承認しても、デフォルトで次の結果は維持されます。

* 拒否ルールが拒否するコールは拒否されたままです。組織はこれを変更できます。
* 確認ルールがプロンプトを表示するコールでは、引き続きプロンプトが表示されます。
* `PreToolUse` フックまたは [`permissions.blockReadsOutsideWorkingDirectories`](/docs/ja/settings-reference#permissions-blockreadsoutsideworkingdirectories) がプロンプトを表示するコールでは、引き続きプロンプトが表示されます。
* `PreToolUse` フックがブロックしたコールは、フックがどの設定ファイルに由来するかにかかわらず、ブロックされたままです。
* [`--permission-prompt-tool`](/docs/ja/cli-reference#cli-flags) または Agent SDK の [`canUseTool` コールバック](/docs/ja/agent-sdk/user-input#handle-tool-approval-requests)に確認が求められるコールは、引き続きそのツールまたはコールバックに渡されます。

管理設定も、セッションの認証情報としての Team または Enterprise の `/login` もない場合、mod は拒否ルールが拒否するコールや `PreToolUse` フックがブロックしたコールを承認できます。代わりに API キーまたは長期間有効な [`CLAUDE_CODE_OAUTH_TOKEN`](/docs/ja/authentication#generate-a-long-lived-token) で実行されるセッションは、そのログインが保存されていても、そのログインを使用していません。

この構成では、確認ルール、`PreToolUse` フック、または `permissions.blockReadsOutsideWorkingDirectories` がプロンプトを表示するコールを mod が承認した場合、プロンプトは表示されません。また、mod が承認したコールについて、`--permission-prompt-tool` や `canUseTool` コールバックに確認が求められることもありません。auto モード、plan モード、`dontAsk` モードは、どの構成でもそれぞれ独自の結果を追加します。

* **[auto モード](/docs/ja/permission-modes#eliminate-prompts-with-auto-mode)**: mod が承認したコールは分類器チェックなしで実行されます。ただし、mod が権限プロンプトツールや Agent SDK の権限コールバックをバイパスできない場合は除きます。その場合は、分類器が先にコールをチェックします。
* **[plan モード](#hook-approvals-in-plan-mode)**: mod は、ファイル編集や書き込みを行うシェルコマンドなど、読み取り専用でないコールを承認できません。
* **[`dontAsk` モード](/docs/ja/permission-modes#allow-only-pre-approved-tools-with-dontask-mode)**: mod は、モード以外に拒否するものがないコールを承認できます。

[mod を信頼するかどうかを決定する](/docs/ja/plugins/mods/overview#decide-whether-to-trust-a-mod)を参照するか、管理設定をデプロイする場合は[組織の mod を管理する](/docs/ja/plugins/mods/admin#know-what-happens-by-default)を参照してください。

`AskUserQuestion` や `requiresUserInteraction` でマークされた MCP ツールなど、[ユーザーの操作が必要なツール](/docs/ja/permission-modes#actions-no-mode-auto-approves)では、mod の `tool.check` による承認があってもプロンプトはスキップされません。Claude Code v2.1.292 以降が必要です。[`requiresUserInteraction`](/docs/ja/mcp#require-approval-for-a-specific-tool)でマークされた MCP ツールは、フックが `"allow"` を返した場合でも引き続きプロンプトを表示します。[ネットワークパス](#network-paths)からの読み取りや、その設定が Claude Code に到達するセッションにおける[組織が `ask` に設定した](/docs/ja/mcp#organization-controls-on-connector-tools)コネクタツールも同様です。

ブロッキングフックは allow ルールよりも優先されます。終了コード 2 で終了するフックは、権限ルールが評価される前にツール呼び出しを停止するため、allow ルールがコールを許可する場合でもブロックが適用されます。プロンプトなしですべての Bash コマンドを実行し、ブロックしたい少数のコマンドを除外するには、allow リストに `"Bash"` を追加し、それらの特定のコマンドを拒否する PreToolUse フックを登録します。適応できるフックスクリプトについては、[保護されたファイルへの編集をブロックする](/docs/ja/hooks-guide#block-edits-to-protected-files)を参照してください。

### plan モードでのフックによる承認

[plan モード](/docs/ja/permission-modes#analyze-before-you-edit-with-plan-mode)では、`ExitPlanMode` を除き、`PreToolUse` フックの `"allow"` はファイル編集やその他の読み取り専用でないコールに対して効果を持ちません。フックがない場合と同じプロンプト、ブロック、または承認が適用され、Claude Code はフックが返す `updatedInput` を引き続き適用します。フックが [`ExitPlanMode`](/docs/ja/hooks#allow-with-updatedinput) に対して `"allow"` と `updatedInput` で応答した場合、そのツールは引き続きプロンプトなしで実行されます。

plan モードでは、`tool.check` を処理する mod もファイル編集やその他の読み取り専用でないコールを承認できません。ただし、そのようなコールをブロックすることは引き続き可能です。フックと mod による承認に対するこの制限を解除するには、[プランを承認する](/docs/ja/permission-modes#review-and-approve-a-plan)か、別の権限モードに切り替えてください。

## 作業ディレクトリ

デフォルトでは、Claude は起動されたディレクトリ内のファイルにアクセスできます。そのディレクトリはセッションの主要な作業ディレクトリであり、[`/cd` でセッションを移動](#move-the-session-to-another-directory)するまで変わりません。このアクセスを拡張できます。

* **起動時**：`--add-dir <path>` CLI 引数を使用します
* **セッション中**：`/add-dir` コマンドを使用します
* **永続的な設定**：[設定ファイル](/docs/ja/settings#where-settings-live)の `additionalDirectories` に追加します

追加ディレクトリ内のファイルは、元の作業ディレクトリと同じ権限ルールに従います。[ネットワークパス](#network-paths)のチェックを除き、プロンプトなしで読み取り可能になり、ファイル編集権限は現在の権限モードに従います。

ほとんどの[ネットワークパス](/docs/ja/errors#working-directory-is-a-network-path)（`\\server\share` などの UNC 共有など）は、作業ディレクトリとして追加できません。これは、ルックアップがそれが指す名前のホストに接続する可能性があるためです。Windows では、代わりに共有をドライブ文字にマップし、起動時に `--add-dir` でドライブを渡します。

[`permissions.blockReadsOutsideWorkingDirectories`](/docs/ja/settings-reference#permissions-blockreadsoutsideworkingdirectories) を設定して、ファイルツールがすべての権限モードで囲まれたパスを拒否するようにします。自動モードでは、Claude Code は Claude が[作業ディレクトリの外側を読み取る](/docs/ja/permission-modes#first-read-outside-the-working-directories)最初の時点でこれをオンにするよう提案します。

macOS のバックグラウンドセッションでは、セッションホストは `~/Desktop`、`~/Documents`、`~/Downloads` などの保護されたフォルダへのアクセスをターミナルとは別に要求します。Claude がそこでファイルを読み取りまたは書き込む必要がある場合、`Operation not permitted` で読み取りが失敗する場合は、[バックグラウンドセッションにフォルダアクセスを許可する方法](/docs/ja/agent-view#background-sessions-can%E2%80%99t-read-desktop-documents-or-downloads-on-macos)を参照してください。

### セッションを別のディレクトリに移動する

セッションを別の主要な作業ディレクトリに移動するには、現在のディレクトリの横に[ディレクトリを追加](#working-directories)するのではなく、`/cd <path>` を実行します。Claude Code は会話を保持し、新しいディレクトリの `CLAUDE.md` を読み込み、以前にそこで作業していない場合は[ワークスペースを信頼](#project-allow-rules-and-workspace-trust)するよう促します。その後、新しいディレクトリから `--resume` を実行すると、Claude Code は[移動されたセッションを検出](/docs/ja/sessions#where-the-session-picker-looks)します。

移動するとすぐに、Claude Code は新しいディレクトリのプロジェクト設定を適用します。

* プロジェクト設定（権限ルールと[hooks](/docs/ja/hooks)を含む）
* [`.mcp.json` サーバー](/docs/ja/mcp#project-scope)（起動時と同じ[サーバー承認](/docs/ja/mcp#project-server-approvals-and-workspace-trust)の対象であり、それに登録した[ローカルスコープ](/docs/ja/mcp#local-scope) MCP サーバー）
* 設定が有効にする[プラグイン](/docs/ja/plugins/overview)、その[スキル](/docs/ja/skills#discovery-from-parent-and-nested-directories)、およびその[サブエージェント](/docs/ja/sub-agents)
* [`env`](/docs/ja/settings-reference#env) 値（前のディレクトリの設定から適用された環境変数の上に適用され、有効なままです）

Claude Code はまた、前のディレクトリのプロジェクトと[ローカルスコープ](/docs/ja/mcp#local-scope) MCP サーバーを切断し、移動後に有効でなくなった[プラグイン](/docs/ja/mcp#plugin-provided-mcp-servers)のサーバーを切断します。前のディレクトリの設定ではなく、新しいディレクトリの設定から[追加ディレクトリ](#working-directories)を取得し、`--add-dir` または `/add-dir` で追加したディレクトリを保持します。移動が有効にする Hooks は、セッションが開始されたプロジェクトルートに設定された[`${CLAUDE_PROJECT_DIR}`](/docs/ja/hooks#reference-scripts-by-path)を受け取ります。

新しいディレクトリがまだ信頼されていない場合、Claude Code は信頼プロンプトでディレクトリの設定が有効にするアロールール、追加ディレクトリ、hooks、およびヘルパーコマンドをリストアップするため、受け入れる前に確認できます。拒否した場合、セッションはそのままです。v2.1.246 より前では、`/cd` は再開するまで新しいディレクトリの設定、hooks、MCP サーバー、またはスキルを適用しませんでした。また、信頼プロンプトはディレクトリの設定が何を有効にするかをリストアップしませんでした。

[`Cd` 権限ルール](#cd)で `/cd` ターゲットを制限または無効にします。

### 追加ディレクトリはファイルアクセスを許可し、設定ではありません

ディレクトリを追加すると、Claude がファイルを読み取りおよび編集できる場所が拡張されます。そのディレクトリを完全な設定ルートにはしません。ほとんどの `.claude/` 設定は追加ディレクトリから検出されませんが、いくつかのタイプは例外として読み込まれます。

これらの例外は、`--add-dir` フラグまたは `/add-dir` コマンドで追加されたディレクトリにのみ適用されます（Agent SDK がフラグを通じて追加するディレクトリを含む）。設定ファイルの `permissions.additionalDirectories` にリストされているディレクトリは、ファイルアクセスのみを許可し、以下の設定は読み込みません。

Agent SDK の TypeScript の [`additionalDirectories`](/docs/ja/agent-sdk/typescript#options) オプションと Python の [`add_dirs`](/docs/ja/agent-sdk/python#claudeagentoptions) オプションは、TypeScript オプションが設定キーと同じ名前を共有していても、例外を受け取ります。SDK は各エントリを Claude Code に `--add-dir` として渡すため、これらのディレクトリはフラグで追加されたディレクトリのように動作します。任意のフラグで追加されたディレクトリからのスキル、コマンド、およびサブエージェントは、`project` [設定ソース](/docs/ja/agent-sdk/claude-code-features#control-filesystem-settings-with-settingsources)を通じて読み込まれるため、CLI で [`--setting-sources`](/docs/ja/cli-reference) を使用するか SDK で `settingSources` を使用してそのソースを除外した場合は読み込まれず、[bare モード](/docs/ja/headless#start-faster-with-bare-mode)はそれらの中のコマンドとサブエージェントをスキップします。

次の設定タイプは `--add-dir` ディレクトリから読み込まれます。

| 設定 | `--add-dir` から読み込まれます |
| :- | :- |
| `.claude/skills/` の[スキル](/docs/ja/skills) | はい、ライブリロード付き |
| `.claude/commands/` の[コマンドファイル](/docs/ja/skills#where-skills-live) | はい、ライブリロードなし。追加されたディレクトリとプロジェクトの両方が同じ名前のコマンドを定義する場合、Claude Code はプロジェクトのコマンドを実行します |
| `.claude/agents/` の[サブエージェント](/docs/ja/sub-agents) | はい、ライブリロードなし |
| `.claude/settings.json` および `.claude/settings.local.json` の[設定](/docs/ja/settings) | `enabledPlugins` および[`extraKnownMarketplaces`](/docs/ja/settings-reference#extraknownmarketplaces)キーのみ |
| [CLAUDE.md](/docs/ja/memory)ファイル、`.claude/rules/`、および `CLAUDE.local.md` | `CLAUDE_CODE_ADDITIONAL_DIRECTORIES_CLAUDE_MD=1` が設定されている場合のみ。`CLAUDE.local.md` はさらに `local` 設定ソースが必要です。これはデフォルトで有効になっています |

[主要な作業ディレクトリ](#working-directories)のサブディレクトリからスキル、コマンド、およびサブエージェントをセッション中に読み込むには、そのサブディレクトリのパスで `/add-dir` を実行します。Claude Code はサブディレクトリが既に読み取り可能であるため、プロンプトを表示したり作業ディレクトリを追加したりせずに、セッションの残りの間それらを読み込みます。これには Claude Code v2.1.257 以降が必要です。

Claude Code は現在の作業ディレクトリとその親、`~/.claude/` のユーザーディレクトリ、および管理設定から出力スタイルを検出します。Hooks およびその他の `.claude/settings.json` キーは、現在の作業ディレクトリの `.claude/` フォルダから親ディレクトリへのフォールバックなしで読み込まれ、ユーザーの `~/.claude/settings.json` および管理設定と共に読み込まれます。`.claude/settings.local.json` は git リポジトリルートから読み込まれます。Claude Code がサブディレクトリで起動された場合でも、Windows など Claude Code が[リポジトリルートを使用しない](/docs/ja/settings#where-claude-code-looks-for-each-file)場合を除きます。v2.1.211 より前では、これも現在の作業ディレクトリからのみ読み込まれました。[Agent SDK](/docs/ja/agent-sdk/claude-code-features#control-filesystem-settings-with-settingsources)セッションはすべてのバージョンで作業ディレクトリから読み込みます。

その設定をプロジェクト全体で共有するには、次のいずれかのアプローチを使用します。

* **ユーザーレベルの設定**：`~/.claude/agents/`、`~/.claude/output-styles/`、または `~/.claude/settings.json` にファイルを配置して、すべてのプロジェクトで利用可能にします
* **プラグイン**：設定を[プラグイン](/docs/ja/plugins/overview)としてパッケージ化および配布し、チームがインストールできるようにします
* **設定ディレクトリから起動する**：使用する `.claude/` 設定を含むディレクトリから Claude Code を実行します

## 権限とサンドボックス化の相互作用

権限と[サンドボックス化](/docs/ja/sandboxing)は、互いを補完するセキュリティレイヤーです。

* **権限**は、Claude Code が使用できるツールと、アクセスできるファイルやドメインを制御します。権限は Bash、Read、Edit、WebFetch、MCP をはじめとするすべてのツールに適用されます。ただし、他のツールが 1 つでも残っている間は、拒否ルールや確認ルールで [`EndConversation`](/docs/ja/tools-reference#endconversation-tool-behavior) をブロックすることはできません。
* **サンドボックス化**は、シェルコマンドのファイルシステムおよびネットワークへのアクセスを制限する OS レベルの強制を提供します。これは Bash、PowerShell、[Monitor](/docs/ja/tools-reference#monitor-tool) ツールのコマンドとその子プロセスに適用されます。

多層防御のために両方を使用してください。プロンプトインジェクションによって Claude の意思決定が回避された場合でも、サンドボックスの制限は引き続き適用されるためです。サンドボックス設定と権限ルールの両方に含まれるパスとドメインは、[最終的なサンドボックス設定にマージされます](/docs/ja/sandboxing#permission-rules)。

サンドボックス化を有効にし、`autoAllowBashIfSandboxed` をデフォルトの `true` のままにしている場合、権限に単独の `Bash` 確認ルール、または[同等の `Bash(*)` 形式](#match-all-uses-of-a-tool)が含まれていても、サンドボックス化された Bash コマンドは確認なしで実行されます。サンドボックスの境界が、このツール全体に対する確認の代わりになるためです。

[plan モード](/docs/ja/permission-modes#analyze-before-you-edit-with-plan-mode)では、Claude Code はこの代替を行いません。確認ルールがない場合、[組み込みの読み取り専用コマンド](#read-only-commands)は引き続き確認なしで実行され、それ以外のシェルコマンドは、計画中である間は通常の権限フローを経由します。plan モードで Claude Code がコマンドをどのように制御するかについては、[plan モード](/docs/ja/permission-modes#analyze-before-you-edit-with-plan-mode)を参照してください。単独の `Bash` 確認ルールがある場合は、サンドボックス化されていない場合と同様に、サンドボックス化された読み取り専用コマンドを含むすべての Bash コマンドで確認が求められます。

次のチェックは引き続き適用されます。

* `Bash(git push *)` のような内容を限定した確認ルールは、引き続き確認を強制します
* [自動許可モード](/docs/ja/sandboxing#auto-allow-mode)で説明されているように、その他のサンドボックス化されたコマンドも通常の権限フローを経由する場合があります

除外されたコマンドなど、サンドボックス内で実行されないコマンドは、通常どおり単独の `Bash` 確認ルールに従います。この動作を変更するには、[サンドボックスモード](/docs/ja/sandboxing#sandbox-modes)を参照してください。

## 管理設定

一元的な制御が必要な組織の場合、管理者はユーザーおよびプロジェクト設定でオーバーライドできない管理設定をデプロイします。ただし、いくつかの[セキュリティに関連するキー](/docs/ja/settings#exceptions-to-managed-settings-precedence)は例外です。[管理設定をデプロイする](/docs/ja/managed-settings)では、配信メカニズム、管理層内での優先順位、および[管理設定のみが設定できるキー](/docs/ja/managed-settings#managed-only-settings)について説明しています。

これらのキーの 1 つである[`allowManagedPermissionRulesOnly`](/docs/ja/settings-reference#allowmanagedpermissionrulesonly)は、管理設定を権限ルールの唯一の設定ソースにします。そのエントリには、Claude Code がその後無視するすべてのソースが記載されています。

`disableBypassPermissionsMode` は通常、組織ポリシーを強制するために管理設定に配置されますが、任意のスコープから機能します。ユーザーは独自の設定で設定して、自分自身をバイパスモードからロックアウトできます。

## 設定の優先順位

権限ルールは、他のすべての Claude Code 設定と同じ[設定優先順位](/docs/ja/settings#settings-precedence)に従います。管理設定が最も高い優先度を持ちます。コマンドライン引数を含む他のレベルは、管理権限ルールをオーバーライドできません。

ツールがいずれかのレベルで拒否されている場合、他のレベルはそれを許可できません。たとえば、管理設定の deny は `--allowedTools` でオーバーライドできず、`--disallowedTools` は管理設定が定義する内容を超えて制限を追加できます。

設定スコープ全体でも同じことが当てはまります。ユーザー設定で権限が許可されており、プロジェクト設定で拒否されている場合、拒否ルールがそれをブロックします。逆も同様です。ユーザーレベルの deny がプロジェクトレベルの allow をブロックします。これは、任意のスコープからの deny ルールが allow ルールの前に評価されるためです。

この優先順位は、設定ファイルとコマンドライン引数の間のものです。deny ルールがインストールした [mod](/docs/ja/plugins/mods/overview) に対して有効かどうかについては、[フックで権限を拡張する](#extend-permissions-with-hooks)を参照してください。

埋め込みホストは、SDK の `managedSettings` オプションを介して追加の管理ポリシーを提供できます。これには、管理者が `allowManaged*Only` ロックを設定していない限り、権限許可ルールが含まれます。[Claude Desktop セッションにポリシーを配信する](/docs/ja/claude-apps-gateway#deliver-policy-to-claude-desktop-sessions)では、埋め込み元ポリシーがいつ適用されるかについて説明しています。

## プロジェクトの許可ルールとワークスペーストラスト

プロジェクトの `.claude/settings.json` 内の `permissions.allow` ルールと `permissions.additionalDirectories` エントリは機能を付与するため、Claude Code はそのフォルダの[ワークスペーストラストダイアログ](/docs/ja/security#additional-safeguards)を受け入れた後にのみ適用します。ダイアログにはフォルダが付与するルールとディレクトリが表示されるため、受け入れる前に確認できます。`deny` ルールと `ask` ルールは制限のみを行うため、影響を受けません。

Claude Code はワークスペーストラストをそれを起動した場所に応じてキーとして保存します。

* リポジトリ内では、Claude Code は git リポジトリルートをキーとしてトラストを保存するため、トラストはリポジトリ全体をカバーします。ただし、サブモジュールなどのネストされた git リポジトリは除きます。[worktree](/docs/ja/worktrees) では、[保存されたルール](#permission-system)の場合と同様にメインチェックアウトのルートを使用します。
* リポジトリ外では、Claude Code はそれを起動したディレクトリをキーとしてトラストを保存し、そのディレクトリのサブディレクトリをカバーします。ただし、クローンなどのネストされた git リポジトリは除きます。カバーされた各サブディレクトリは、その親を信頼したフォルダとしてカウントされます。
* ホームディレクトリから起動した場合、Claude Code はトラストを現在のセッションのみ保持し、ディスクに書き込みません。[追加のセーフガード](/docs/ja/security#additional-safeguards)に関する注記を参照してください。

Claude Code はインタラクティブセッションでのみトラストダイアログを表示します。`claude -p` 実行または SDK セッションはダイアログを表示しません。親フォルダを信頼してもこれらのルールにはカウントされないため、[フォルダを信頼する前に実行されるもの](#what-runs-before-you-trust-a-folder)は、これら 2 つの状況で Claude Code がどのリポジトリコンテンツを使用するかを説明しています。

[バックグラウンドセッション](/docs/ja/agent-view)を開始または再開する前に、Claude Code はセッションが実行されるディレクトリのワークスペーストラストもチェックします。信頼していないディレクトリのターミナルから `claude --bg` を実行した場合、トラストダイアログが最初に表示され、それを受け入れるとセッションが開始されます。スクリプト内など、ダイアログが表示できない場所では、コマンドは代わりに[`Workspace not trusted`](/docs/ja/errors#workspace-not-trusted-when-dispatching-a-background-session)エラーで終了します。

### ローカル設定ファイルがトラストを必要とする場合

`.claude/settings.local.json` は通常あなた自身のファイルであるため、Claude Code はトラストステップなしにその許可ルールと追加ディレクトリを適用します。ファイルが git で追跡されている場合、または `.claude` がシンボリックリンクである場合、Claude Code はそれをリポジトリ提供として扱い、フォルダを信頼するまでそのルールを保持します。

Claude Code は git を実行して 2 つを区別し、フォルダを信頼した後にのみ git を実行します。つまり、そのトラストダイアログを受け入れたか、トラストがそれに拡張される親ディレクトリを受け入れたか、`-p` または SDK セッションにいます。これはトラストが受け入れられたとしてカウントされます。それまでは、Claude Code を起動した場所がファイルのルールに何が起こるかを決定します。

* **設定ホーム内：** Claude Code は git を実行せずにそのフォルダの `.claude/settings.local.json` をすぐに適用します。設定ホームはホームディレクトリ、または `.claude` サブディレクトリを [`CLAUDE_CONFIG_DIR`](/docs/ja/env-vars#variables) として設定したディレクトリです。その `CLAUDE_CONFIG_DIR` ディレクトリが git リポジトリ内にあり、Claude Code が[リポジトリルートでローカル設定を保持](/docs/ja/settings#where-claude-code-looks-for-each-file)する場合、他の場所と同様にルールを保持します。
* **その他の場所：** Claude Code はプロジェクト設定と同様にファイルのルールを保持します。チェックが実行されると、Claude Code は追跡されていないファイルのルール、またはどの git リポジトリの外にあるディレクトリ内のファイルのルールを適用します。その正確なフォルダを信頼していなくても同様です。

> [!NOTE]
>
> 設定ホーム例外はトラストステップのみをスキップします。`~/.claude/settings.local.json` は依然として[ローカルスコープ](/docs/ja/settings#compare-the-scope-of-each-settings-file)であるため、Claude Code はホームディレクトリ自体で起動したセッションでのみそれを読み込み、すべてのプロジェクトでは読み込みません。すべてのプロジェクトに許可ルールを適用するには、代わりにユーザー設定に追加してください。`~/.claude/settings.json`、または `CLAUDE_CONFIG_DIR` が設定されている場合は `$CLAUDE_CONFIG_DIR/settings.json`。

### フォルダを信頼する前に実行されるもの

各行はリポジトリが提供できるコンテンツの 1 種類です。列は、フォルダ自体を信頼していない 2 つの状況です。親フォルダのみを信頼したか、そこで `claude -p` または SDK を実行しました。これはトラストダイアログを表示しません。親フォルダ列は[ネストされたリポジトリ](#project-allow-rules-and-workspace-trust)内には適用されません。インタラクティブセッションでは Claude Code はそれのトラストダイアログを表示し、`claude -p` または SDK 実行はそこで `claude -p` 列に従います。

| リポジトリが提供するもの | 親フォルダのみを信頼した | `claude -p` または SDK、フォルダは信頼されていない |
| :- | :- | :- |
| 設定ファイル内の[Hooks](/docs/ja/hooks)、[`env`](/docs/ja/settings-reference#env)ブロック、[`apiKeyHelper`](/docs/ja/settings-reference#apikeyhelper)などのヘルパーコマンド、およびプロジェクトスキルの[hooks](/docs/ja/hooks#hooks-in-skills-and-agents)と[`allowed-tools`](/docs/ja/skills#pre-approve-tools-for-a-skill) | 使用 | 使用。ワークスペーストラストはどのセッションでもスキルの `allowed-tools` をゲートしません |
| `.claude/settings.json` 内の `permissions.allow` ルールと `additionalDirectories` | トラストダイアログを受け入れるまで使用されません。ダイアログは再度表示され、それらをリストします | 使用されません。Claude Code は stderr に[`this workspace has not been trusted`](/docs/ja/errors#workspace-has-not-been-trusted)警告を出力します |
| プロジェクト[subagent](/docs/ja/sub-agents#hooks-in-subagent-frontmatter)のフロントマターフック、プロジェクト[`@skills-dir` プラグイン](/docs/ja/plugins/loading#plugins-shared-through-a-repository)、およびリポジトリまたは `--add-dir` ディレクトリからの[`extraKnownMarketplaces`](/docs/ja/settings-reference#extraknownmarketplaces)エントリ | 使用されず、ダイアログは提供されません | 使用されません |
| リポジトリまたは `--add-dir` ディレクトリからの subagent のフロントマター内のインライン[`mcpServers`](/docs/ja/sub-agents#scope-mcp-servers-to-a-subagent) | 使用されず、ダイアログは提供されません | 使用されません |
| `.mcp.json` 内のサーバー。リポジトリが[独自の設定で承認](/docs/ja/mcp#project-server-approvals-and-workspace-trust)するものを含む | Claude Code は接続する前にユーザーに確認します。リポジトリ独自の承認はカウントされません | 承認されているかどうかに関わらず接続されます。SDK は `settingSources` がプロジェクト設定を含む場合にのみそれらを読み込みます。同じフォルダの `claude mcp list` はそのようなサーバーを依然として保留中として報告します |
| `.mcp.json` 内のサーバー上の[`headersHelper`](/docs/ja/mcp#trust-a-folder-before-its-headershelper-runs) | トラストダイアログを受け入れるまで実行されません。ダイアログは再度表示され、ヘルパーが宣言されている場所を名前で指定します。Claude Code はそれまでサーバーを静的 `headers` のみで接続します | 実行されません。Claude Code はサーバーを静的 `headers` のみで接続し、サーバーごとに stderr に[`headersHelper not run`](/docs/ja/errors#headershelper-not-run)行を出力します |

このフォルダを信頼する必要がある行については、手動で信頼してください。`~/.claude.json` で `projects["<path>"].hasTrustDialogAccepted` を `true` に設定します。`<path>` はリポジトリルート、またはリポジトリ外のフォルダ自体です。Claude Code はスキップされた subagent フックまたはインライン MCP サーバーのデバッグログ行、スキップされた許可ルールの stderr 警告、およびスキップされたヘルパーの `headersHelper not run` 行に正確なキーを出力します。

あなたが書いていないリポジトリで `claude -p` を実行する前に、マシンで実行される可能性があるものを決定してください。

* `--setting-sources user` を渡すか、SDK の `settingSources` をプロジェクト設定なしで設定して、Claude Code がプロジェクトの設定ファイルも `.mcp.json` も読み込まないようにします
* [`--bare`](/docs/ja/headless#start-faster-with-bare-mode)で起動して、Claude Code がプロジェクトから hooks、skills、カスタムコマンド、subagents、プラグイン、または `.mcp.json` サーバーを読み込まないようにします。プロジェクトの `env` ブロックと `awsAuthRefresh` などのヘルパーはその設定ファイルで依然として適用され、Claude Code は `apiKeyHelper` を `--settings` からのみ読み込みます
* `--settings '{"disableAllHooks": true}'` を渡して、その実行の[hooks をオフにします](/docs/ja/hooks#disable-or-remove-hooks)。ユーザー設定のみで設定するのは十分ではありません。リポジトリのプロジェクト設定があなたのものより優先され、それを `false` に戻すことができるためです
* [`disabledMcpjsonServers`](/docs/ja/settings-reference#disabledmcpjsonservers)エントリをすべてのセッションタイプで名前で `.mcp.json` サーバーを拒否するために追加します

## 設定例

この[リポジトリ](https://github.com/anthropics/claude-code/tree/main/examples/settings)には、一般的なデプロイメントシナリオのスターター設定が含まれています。これらを出発点として使用し、ニーズに合わせて調整してください。

## 関連項目

* [すべての設定](/docs/ja/settings-reference#permission-settings)：権限キーを含むすべての設定キー
* [auto モードを設定する](/docs/ja/auto-mode-config)：auto モード分類器に組織が信頼するインフラストラクチャを伝えます
* [サンドボックス](/docs/ja/sandboxing)：Bash コマンドの OS レベルのファイルシステムとネットワーク分離
* [認証](/docs/ja/authentication)：Claude Code へのユーザーアクセスを設定します
* [セキュリティ](/docs/ja/security)：セキュリティ保護とベストプラクティス
* [フック](/docs/ja/hooks-guide)：ワークフローを自動化し、権限評価を拡張します
