> ## Documentation Index
> Fetch the complete documentation index at: https://code.claude.com/docs/llms.txt
> Use this file to discover all available pages before exploring further.

# 設定をデバッグする

> CLAUDE.md、設定、hooks、MCP サーバー、またはスキルが機能していない理由を診断します。/context、/doctor、/hooks、/mcp を使用して、実際に読み込まれた内容を確認します。

Claude が指示を無視したり、設定した機能が表示されない場合、通常の原因はファイルが読み込まれなかった、予期した場所とは異なる場所から読み込まれた、または別のファイルがそれをオーバーライドしたことです。このガイドでは、Claude Code が実際に読み込んだ内容を検査して、どれが当てはまるかを絞り込む方法を示します。

インストール、認証、接続の問題については、代わりに [トラブルシューティング インストールとログイン](https://code.claude.com/docs/ja/troubleshoot-install.md) を参照してください。

## コンテキストに読み込まれた内容を確認する

`/context` コマンドは、現在のセッションでコンテキストウィンドウを占めているすべての内容をカテゴリ別に表示します。カテゴリは、システムプロンプト、システムツール、MCP ツール、カスタムサブエージェント（それぞれの読み込み元を含む）、メモリファイル、スキル、会話メッセージです。まずこのコマンドを実行して、`CLAUDE.md`、ルール、スキルの説明がそもそも存在するかどうかを確認してください。`/context` のスキルセクションには[バンドルスキル](https://code.claude.com/docs/ja/skills.md#bundled-skills)も含まれますが、これは `/skills` には表示されません。

特定のカテゴリの詳細を確認するには、続けて専用のコマンドを実行します。

| コマンド | 表示内容 |
| :- | :- |
| `/memory` | ユーザースコープとプロジェクトスコープにわたるメモリファイルの場所と、それぞれをエディターで開くオプション、および自動メモリフォルダーへのアクセスと自動メモリの切り替え |
| `/skills` | プロジェクト、ユーザー、プラグインから利用可能なスキル |
| `/hooks` | 有効なフックの設定 |
| `/mcp` | 接続されている MCP サーバーとそのステータス |
| `/permissions` | 現在有効な、解決済みの許可ルールと拒否ルール |
| `/doctor` | セットアップの点検：インストールの健全性、無効な設定ファイル、未使用の拡張機能、同じディレクトリ内で重複している[サブエージェント](https://code.claude.com/docs/ja/sub-agents.md)名、および Claude がコードベースから導き出せるのにチェックインされている `CLAUDE.md` の内容を、修正案とともに表示 |
| `/debug [issue]` | セッションのデバッグログを有効にし、ログ出力と設定パスを使って診断するよう Claude に促す |
| `/status` | 有効な設定ソース（管理設定が適用されているかどうかを含む） |

メモリファイルが `/context` の内訳に表示されない場合は、その場所を [CLAUDE.md ファイルの読み込み方法](https://code.claude.com/docs/ja/memory.md#how-claude-md-files-load)と照らし合わせて確認してください。サブディレクトリの `CLAUDE.md` ファイルは、セッション開始時ではなくオンデマンドで読み込まれるため、この内訳には表示されません。

`/context` でファイルが読み込まれていることを確認できたのに、Claude が特定の指示に従わない場合、問題は読み込まれたかどうかではなく、指示の書き方にある可能性が高いです。CLAUDE.md は、プロジェクトの規約、ビルドコマンド、ファイルの配置場所など、新しいチームメイトに伝えるような種類のガイダンスに適しています。

指示が複数の解釈ができるほど曖昧な場合、2 つのファイルが矛盾する指示を与えている場合、またはファイルが長くなりすぎて個々のルールへの注意が薄れている場合には、指示の遵守率が低下します。[効果的な指示を書く](https://code.claude.com/docs/ja/memory.md#write-effective-instructions)では、遵守率を高く保つための具体性、サイズ、構造のパターンを説明しています。

> [!NOTE]
>
> CLAUDE.md と権限は、それぞれ異なる問題を解決します。CLAUDE.md は、Claude が適切な判断を下せるようにプロジェクトの仕組みを伝えます。[権限](https://code.claude.com/docs/ja/permissions.md)と[フック](https://code.claude.com/docs/ja/hooks.md)は、Claude の判断に関係なく制限を強制します。「ここではこのやり方をする」という内容には CLAUDE.md を使用してください。セキュリティ境界や、決して起きてはならないことなど、ガイダンスではなく保証が必要なものには、権限またはフックを使用してください。

## 解決された設定を確認する

設定はマネージド、ユーザー、プロジェクト、ローカルスコープ全体でマージされます。マネージド設定が存在する場合は常に優先されます。その他の場合、より近いスコープが、ローカル、プロジェクト、ユーザーの順序でより広いスコープをオーバーライドします。一部の設定は、コマンドラインフラグまたは [環境変数](https://code.claude.com/docs/ja/env-vars.md) で設定することもでき、これは別のオーバーライドレイヤーとして機能します。設定が適用されないように見える場合、設定した値は通常、別のスコープまたは環境変数によってオーバーライドされています。

無効な設定ファイルを見つけるには、ターミナルから `claude doctor` を実行してください。セッションを開始せずに、読み取り専用のインストールと設定の診断をプリントします。セッション内で完全なチェックアップを実行する場合は、[`/doctor`](https://code.claude.com/docs/ja/commands#all-commands) を実行してください。これは修正を提案し、適用する前に確認を求めます。

`/status` を実行して、マネージド設定が有効かどうかを含む、どの設定ソースがアクティブかを確認します。特定のキーに対して Claude Code がどのスコープを使用するかを理解するには、[設定の優先順位](https://code.claude.com/docs/ja/settings.md#settings-precedence) を参照してください。

## MCP サーバーを確認する

`/mcp` を実行すると、設定されているすべてのサーバー、その接続状態、および現在のプロジェクトでそのサーバーを承認済みかどうかを確認できます。サーバーが正しく定義されていても、いくつかのよくある理由でツールが提供されない場合があります。

* `.mcp.json` 内のプロジェクトスコープのサーバーには、一度だけの承認が必要です。プロンプトが閉じられた場合、`/mcp` から承認するまでそのサーバーは無効のままになります。
* 起動に失敗したサーバーは、`/mcp` で失敗として表示されます。`command` または `args` 内の相対ファイルパスはよくある原因です。これらは `.mcp.json` の場所ではなく、Claude Code を起動したディレクトリを基準に解決されるためです。
* 接続済みと表示されているのにツールが 0 個と表示されるサーバーは、正常に起動しているもののツールリストを返していません。`/mcp` から **Reconnect** を選択してください。それでも数が 0 のままの場合は、`claude --debug=mcp` を実行し、`~/.claude/debug/<session-id>.txt` にあるデバッグログでサーバーの stderr を確認してください。

設定の場所とスコープのルールについては、[MCP](https://code.claude.com/docs/ja/mcp.md) を参照してください。

## Hooks を確認する

`/hooks` を実行して、現在のセッションに登録されているすべてのフックをイベント別にグループ化して一覧表示します。定義したフックが表示されない場合、Claude Code はそのフックを読み込んでいません。次の原因がないか確認してください：

* フックがスタンドアロンファイルで定義されている。フックは[設定ファイル](https://code.claude.com/docs/ja/settings.md#settings-files)の `"hooks"` キーの下に置きます。
* `matcher` の値が単一の文字列ではなく配列になっている。Claude Code は、対話型セッションの開始時と `claude doctor` で、そのエントリを無効な設定として一覧表示します。配列が `PreToolUse` または `PermissionRequest` の下にある場合、そのファイルの他のフックも一切読み込まれません。
* フックがスキルのフロントマターにあり、このセッションでユーザーも Claude もまだそのスキルを呼び出していない。スキルを呼び出すか Claude に呼び出しを依頼してから、`/hooks` を再度実行してください。それでもフックが表示されない場合は、[解析されなかったフロントマター](https://code.claude.com/docs/ja/skills.md#skill-not-triggering)や[スキルフックの制限](https://code.claude.com/docs/ja/hooks.md#limits-on-skill-hooks)のいずれかなど、他の原因がないか確認してください。

フックが表示されても発火しない場合、通常の原因はマッチャーです。以下の間違いがないか確認してください：

* `matcher` フィールドは、複数のツール名をマッチするために `|` を使用する単一の文字列です。例えば `"Edit|Write"` です。`,` セパレータは同等であるため、`"Edit,Write"` は同じツールをマッチします。v2.1.191 より前では、カンマは正規表現評価にフォールスルーし、マッチャーは一致しないため、v2.1.191 をまだ使用していない場合は `|` を使用してください。
* ツール名のスペルミスはマッチャーが何もマッチしないため、フックはサイレントに失敗します。

`settings.json` を編集すると、短いファイル安定性遅延後に実行中のセッションで変更が有効になります。セッション開始後にプロジェクトの `.claude/` フォルダを作成した場合でも、再起動する必要はありません。v2.1.257 より前では、Claude Code はセッション開始後に作成された `.claude/` フォルダの編集を検出しませんでした。

保存後数秒経っても `/hooks` が古い定義を表示している場合は、`/hooks` を再度実行してビューをリフレッシュしてください。

`/hooks` がフックを表示しても発火しない場合、次のステップはフック評価をライブで監視することです。`claude --debug` でセッションを開始し、ツール呼び出しをトリガーします。デバッグログは各イベント、チェックされたマッチャー、フックの終了コードと出力を記録します。ログ形式については [フックをデバッグする](https://code.claude.com/docs/ja/hooks.md#debug-hooks) を、一般的な失敗パターンについては [hooks トラブルシューティング](https://code.claude.com/docs/ja/hooks-guide.md#limitations-and-troubleshooting) を参照してください。

## クリーン設定に対してテストする

[`claude --safe-mode`](https://code.claude.com/docs/ja/cli-reference#cli-flags) で開始します。これにより、次のようなカスタマイズが無効になった状態でセッションが起動します。

* `CLAUDE.md`
* スキル、プラグイン、フック
* MCP サーバー
* カスタムコマンドとエージェント
* カスタム出力スタイル
* カスタムキーボードショートカット

認証、モデル選択、組み込みツール、権限は通常通り機能します。セーフモードで問題が消える場合、原因は無効にした項目のいずれかに絞り込まれます。どれが原因かを特定するには、[コンテキストに読み込まれた内容を確認する](#see-what-loaded-into-context)、[MCP サーバーを確認する](#check-mcp-servers)、[フックを確認する](#check-hooks) など、その項目に対応するチェックを使用してください。

セーフモードでも、組織からの管理フックと設定ポリシーは引き続き適用されます。管理対象のプラグイン、スキル、`CLAUDE.md`、MCP サーバーはオフになります。

セーフモードで問題が続く場合、または設定自体が疑わしい場合は、自分の設定を一切使わないセッションを開始し、問題が再現するかどうかを確認してください。

**1. 空のディレクトリを作成して移動する**

Claude Code のセッションを実行していない状態のシェルで、ディレクトリを作成して移動します。

**Bash または Zsh**

```bash theme={null}
mkdir -p ~/claude-clean/empty && cd ~/claude-clean/empty
```

**PowerShell**

```powershell theme={null}
New-Item -ItemType Directory -Force "$HOME/claude-clean/empty" | Out-Null
Set-Location "$HOME/claude-clean/empty"
```

**2. クリーンな設定ディレクトリで Claude Code を起動する**

同じシェルから、[`CLAUDE_CONFIG_DIR`](https://code.claude.com/docs/ja/env-vars) を `~/.claude` の代わりに新しいディレクトリに設定し、[`--setting-sources user`](https://code.claude.com/docs/ja/cli-reference#cli-flags) を渡して、`.claude/settings.json`、`CLAUDE.md`、`.mcp.json` などのプロジェクト設定をオフにします。

**Bash または Zsh**

この変数は今回の起動にのみ適用されます。

```bash theme={null}
CLAUDE_CONFIG_DIR=~/claude-clean/config claude --setting-sources user
```

**PowerShell**

この変数はこの PowerShell セッションの残りの間ずっと設定されたままになるため、同じウィンドウでの以降の `claude` の起動でもクリーンなディレクトリが使われ続けます。通常のディレクトリに戻すには、次回の起動前に `Remove-Item Env:CLAUDE_CONFIG_DIR` を実行してください。

```powershell theme={null}
$env:CLAUDE_CONFIG_DIR = "$HOME/claude-clean/config"
claude --setting-sources user
```

最初の起動時には、初回実行時のセットアップ画面が再び表示されます。これはクリーンな設定ディレクトリが有効になっていることを示しています。管理設定は引き続き適用され、claude.ai アカウントでログインした場合は[コネクタ](https://code.claude.com/docs/ja/mcp.md#use-mcp-servers-from-claude-ai)も引き続き読み込まれます。

**3. 問題を再現する**

クリーンなセッションで、問題を引き起こした操作を繰り返します。

* **問題が消えた場合**: 原因はユーザー設定またはプロジェクト設定にあります。`~/.claude.json` と `~/.claude` 内のファイルを 1 つずつ `~/claude-clean/config` にコピーします。どのファイルでも問題が再発しない場合は、同じシェルでプロジェクトディレクトリに移動し、`--setting-sources user` を付けずに Claude Code を起動します。Bash または Zsh では、`CLAUDE_CONFIG_DIR=~/claude-clean/config claude` を実行します。PowerShell では変数がまだ設定されているため、`claude` を実行します。
* **問題が続く場合**: 原因はユーザー設定とプロジェクト設定の外にあります。セッションで `/status` を実行して管理設定を確認し、シェルの[環境変数](https://code.claude.com/docs/ja/env-vars.md)を確認してから、[トラブルシューティング](https://code.claude.com/docs/ja/troubleshooting.md)を参照してください。

## 一般的な原因を確認する

ほとんどの設定の問題は、少数の場所とシンタックスのルールに遡ることができます。バグだと思う前に、以下を確認してください。

| 症状 | 原因 | 修正方法 |
| :- | :- | :- |
| Hook が発火しない | `matcher` が文字列ではなく JSON 配列である | 複数のツールにマッチさせるには、`\|` を使用した単一の文字列を使用してください。例えば `"Edit\|Write"` です。[matcher パターン](https://code.claude.com/docs/ja/hooks.md#matcher-patterns)を参照してください。 |
| Hook が発火しない | `matcher` が v2.1.191 より前のバージョンで `,` を区切り文字として使用している | Claude Code v2.1.191 以降では、`,` は `\|` のようなリスト区切り文字として扱われます。それより前のバージョンでは、カンマをリテラル文字として評価するため、`"Edit,Write"` は何にもマッチしません。代わりに `\|` を使用するか、Claude Code をアップグレードしてください。 |
| Hook が発火しない | `matcher` の値が小文字である。例えば `"bash"` | マッチングは大文字と小文字を区別します。ツール名は大文字で始まります。`Bash`、`Edit`、`Write`、`Read` です。 |
| Hook が発火しない | Hook が `settings.json` ではなくスタンドアロンファイルで定義されている | プロジェクトまたはユーザー設定用のスタンドアロン hooks ファイルはありません。`settings.json` の `"hooks"` キーの下に Hook を定義してください。[プラグイン](https://code.claude.com/docs/ja/plugins/components.md#hooks)のみが別の `hooks/hooks.json` を読み込みます。[hook 設定](https://code.claude.com/docs/ja/hooks.md)を参照してください。 |
| グローバルに設定された権限または Hook が無視される | 設定が `~/.claude.json` に追加された | `~/.claude.json` はアプリの状態と UI トグルを保持します。`permissions`、`hooks`、`env` は `~/.claude/settings.json` に属します。これらは 2 つの異なるファイルです。 |
| `settings.json` の値が無視されているように見える | 同じキーが `settings.local.json` で設定されている | `settings.local.json` は `settings.json` をオーバーライドし、両方とも `~/.claude/settings.json` をオーバーライドします。[設定の優先順位](https://code.claude.com/docs/ja/settings.md#settings-precedence)を参照してください。 |
| Skill が `/skills` に表示されない | Skill ファイルがフォルダ内ではなく `.claude/skills/name.md` にある | フォルダを使用して、その中に `SKILL.md` を配置してください。`.claude/skills/name/SKILL.md` です。 |
| Skill が `/skills` に表示されるが Claude が呼び出さない | Skill の frontmatter に `disable-model-invocation: true` がある、またはその説明がリクエストの表現方法と一致しない | `/skills` のバッジを確認してください。「user-only」ラベルは Claude が自動的にトリガーしないことを意味します。[skill 呼び出し](https://code.claude.com/docs/ja/skills.md)を参照してください。 |
| サブディレクトリの `CLAUDE.md` 指示が無視されているように見える | サブディレクトリファイルはセッション開始時ではなく、オンデマンドで読み込まれます | サブディレクトリの `CLAUDE.md` を読み込むには、そのサブディレクトリ内の別のファイルを読むよう Claude に依頼してください。[サブディレクトリファイルが読み込まれるタイミング](https://code.claude.com/docs/ja/memory.md#how-claude-md-files-load)を参照してください。 |
| サブエージェントが `CLAUDE.md` 指示を無視する | 組み込みの Explore および Plan エージェントは起動時に `CLAUDE.md` をスキップします。カスタムサブエージェントは、その定義が [`omitClaudeMd`](https://code.claude.com/docs/ja/sub-agents#supported-frontmatter-fields) を設定しない限り、メイン会話と同じ方法で読み込みます | Explore または Plan の場合、委譲プロンプトで指示を再度述べてください。`omitClaudeMd` を設定するサブエージェントの場合、フィールドを削除してください。その他のカスタムサブエージェントの場合、重要な指示をエージェントファイルの本体に配置してください。これはエージェントのシステムプロンプトになります。[起動時に読み込まれるもの](https://code.claude.com/docs/ja/sub-agents.md#what-loads-at-startup)を参照してください。 |
| クリーンアップロジックがセッション終了時に実行されない | `SessionEnd` hook が設定されていない | `settings.json` に `SessionEnd` hook を追加してください。[hook イベントリスト](https://code.claude.com/docs/ja/hooks.md#hook-events)を参照してください。 |
| `.mcp.json` の MCP サーバーが読み込まれない | ファイルが `.claude/` の下にあるか、そのサーバーが VS Code の `mcp.json` のように、`mcpServers` ではなくトップレベルの `servers` キーの下にある | プロジェクト MCP 設定はリポジトリルートの `.mcp.json` に配置され、`.claude/` 内ではなく、`mcpServers` キーの下にサーバーがあります。[MCP 設定](https://code.claude.com/docs/ja/mcp.md)を参照してください。 |
| `settings.json` の `mcpServers` の下に追加された MCP サーバーが表示されない | `settings.json` が `mcpServers` キーを読み込まない | プロジェクトサーバーをリポジトリルートの `.mcp.json` で定義するか、ユーザースコープのサーバーの場合は `claude mcp add --scope user` を実行してください。[MCP 設定](https://code.claude.com/docs/ja/mcp.md)を参照してください。 |
| プロジェクト MCP サーバーが追加されたが表示されない | ワンタイム承認プロンプトが却下された | プロジェクトスコープのサーバーは承認が必要です。`/mcp` を実行してステータスを確認し、承認してください。 |
| MCP サーバーが一部のディレクトリから起動に失敗する | `command` または `args` が相対ファイルパスを使用している | ローカルスクリプトには絶対パスを使用してください。`npx` や `uvx` のような `PATH` 上の実行可能ファイルはそのまま機能します。 |
| MCP サーバーが予期された環境変数なしで起動する | サーバーの設定エントリがそれらを設定していない、および Claude Code が stdio サーバーに渡す環境に含まれていない。その環境は、[サブプロセスから削除される変数](https://code.claude.com/docs/ja/monitoring-usage.md#administrator-configuration)を除いた独自の環境です | サーバーの `.mcp.json` エントリ内でサーバーごとの `env` を設定してください。これは起動環境またはワークスペーストラストに依存しません。 |
| `Bash(rm *)` 拒否ルールが `/bin/rm` または `find -delete` をブロックしない | Bash ルールは基になる実行可能ファイルではなく、リテラルコマンド文字列にマッチします。[Bash ルールがマッチしないもの](https://code.claude.com/docs/ja/permissions.md#bash-rule-limits)を参照してください | [PreToolUse hook](https://code.claude.com/docs/ja/hooks-guide.md)または[サンドボックス](https://code.claude.com/docs/ja/sandboxing.md)を使用して、ハード保証を取得してください。 |

## 関連リソース

各設定サーフェスの完全なリファレンスについては、専用ページを参照してください：

* **[`.claude` ディレクトリリファレンス](https://code.claude.com/docs/ja/claude-directory)**: すべての設定ファイルの場所とそれを読むもの
* **[設定](https://code.claude.com/docs/ja/settings.md)**: どのファイルを使用するか、および Claude Code が使用する値。[設定リファレンス](https://code.claude.com/docs/ja/settings-reference.md)に完全なキーリストがあります
* **[Hooks リファレンス](https://code.claude.com/docs/ja/hooks.md)**: イベント名、ペイロード、および `--debug` 出力形式
* **[MCP](https://code.claude.com/docs/ja/mcp.md)**: サーバー設定、承認、`/mcp` 出力
* **[インストールとログインのトラブルシューティング](https://code.claude.com/docs/ja/troubleshoot-install.md)**: `command not found`、PATH、認証の問題
* **[トラブルシューティング](https://code.claude.com/docs/ja/troubleshooting.md)**: パフォーマンス、ハング、検索の問題
