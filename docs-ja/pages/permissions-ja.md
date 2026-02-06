> ## Documentation Index
> Fetch the complete documentation index at: https://code.claude.com/docs/llms.txt
> Use this file to discover all available pages before exploring further.

# パーミッションの設定

> きめ細かいパーミッションルール、モード、管理ポリシーを使用して、Claude Code がアクセスして実行できる内容を制御します。

Claude Code は、エージェントが実行できることと実行できないことを正確に指定できるようにするため、きめ細かいパーミッションをサポートしています。パーミッション設定はバージョン管理にチェックインでき、組織内のすべての開発者に配布できるほか、個々の開発者がカスタマイズできます。

## パーミッションシステム

Claude Code は、パワーと安全性のバランスを取るために、段階的なパーミッションシステムを使用しています。

| ツールタイプ    | 例             | 承認が必要 | 「はい、今後は聞かない」の動作         |
| :-------- | :------------ | :---- | :---------------------- |
| 読み取り専用    | ファイル読み取り、Grep | いいえ   | N/A                     |
| Bash コマンド | シェル実行         | はい    | プロジェクトディレクトリとコマンドごとに永続的 |
| ファイル変更    | ファイルの編集/書き込み  | はい    | セッション終了まで               |

## パーミッションの管理

`/permissions` を使用して、Claude Code のツールパーミッションを表示および管理できます。この UI は、すべてのパーミッションルールと、それらが取得される settings.json ファイルをリストします。

* **Allow** ルールは、Claude Code が手動承認なしで指定されたツールを使用できるようにします。
* **Ask** ルールは、Claude Code が指定されたツールを使用しようとするたびに確認を促します。
* **Deny** ルールは、Claude Code が指定されたツールを使用することを防止します。

ルールは順序で評価されます。**deny -> ask -> allow**。最初にマッチしたルールが優先されるため、deny ルールは常に優先されます。

## パーミッションモード

Claude Code は、ツールの承認方法を制御するいくつかのパーミッションモードをサポートしています。[設定ファイル](/ja/settings#settings-files)で `defaultMode` を設定します。

| モード                 | 説明                                                                                                                                                                |
| :------------------ | :---------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `default`           | 標準動作。各ツールの最初の使用時にパーミッションを促します                                                                                                                                     |
| `acceptEdits`       | セッション中のファイル編集パーミッションを自動的に受け入れます                                                                                                                                   |
| `plan`              | Plan Mode。Claude はファイルを分析できますが、ファイルを変更したりコマンドを実行したりすることはできません                                                                                                     |
| `delegate`          | エージェントチームリーダー向けの調整専用モード。リーダーをチーム管理ツールに制限し、すべての実装作業がチームメイトを通じて行われるようにします。エージェントチームがアクティブな場合にのみ利用可能です。詳細は [delegate mode](/ja/agent-teams#delegate-mode) を参照してください。 |
| `dontAsk`           | `/permissions` または `permissions.allow` ルールで事前承認されていない限り、ツールを自動的に拒否します                                                                                             |
| `bypassPermissions` | すべてのパーミッションプロンプトをスキップします（安全な環境が必要です。以下の警告を参照してください）                                                                                                               |

<Warning>
  `bypassPermissions` モードはすべてのパーミッションチェックを無効にします。このモードは、Claude Code が損害を引き起こせないコンテナや VM などの隔離された環境でのみ使用してください。管理者は、[管理設定](#managed-settings)で `disableBypassPermissionsMode` を `"disable"` に設定することで、このモードを防止できます。
</Warning>

## パーミッションルール構文

パーミッションルールは、`Tool` または `Tool(specifier)` の形式に従います。

### ツールのすべての使用をマッチさせる

ツールのすべての使用をマッチさせるには、括弧なしでツール名を使用します。

| ルール        | 効果                       |
| :--------- | :----------------------- |
| `Bash`     | すべての Bash コマンドをマッチさせます   |
| `WebFetch` | すべてのウェブフェッチリクエストをマッチさせます |
| `Read`     | すべてのファイル読み取りをマッチさせます     |

`Bash(*)` は `Bash` と同等で、すべての Bash コマンドをマッチさせます。

### きめ細かい制御のためにスペシファイアを使用する

括弧内にスペシファイアを追加して、特定のツール使用をマッチさせます。

| ルール                            | 効果                                  |
| :----------------------------- | :---------------------------------- |
| `Bash(npm run build)`          | 正確なコマンド `npm run build` をマッチさせます    |
| `Read(./.env)`                 | 現在のディレクトリの `.env` ファイルの読み取りをマッチさせます |
| `WebFetch(domain:example.com)` | example.com へのフェッチリクエストをマッチさせます     |

### ワイルドカードパターン

Bash ルールは `*` を使用したグロブパターンをサポートしています。ワイルドカードはコマンド内の任意の位置に表示できます。この設定により、npm および git commit コマンドが許可され、git push がブロックされます。

```json  theme={null}
{
  "permissions": {
    "allow": [
      "Bash(npm run *)",
      "Bash(git commit *)",
      "Bash(git * main)",
      "Bash(* --version)",
      "Bash(* --help *)"
    ],
    "deny": [
      "Bash(git push *)"
    ]
  }
}
```

`*` の前のスペースは重要です。`Bash(ls *)` は `ls -la` にマッチしますが `lsof` にはマッチしません。一方、`Bash(ls*)` は両方にマッチします。レガシーな `:*` サフィックス構文は ` *` と同等ですが、非推奨です。

## ツール固有のパーミッションルール

### Bash

Bash パーミッションルールは `*` を使用したワイルドカードマッチングをサポートしています。ワイルドカードは、開始、中間、終了を含むコマンド内の任意の位置に表示できます。

* `Bash(npm run build)` は正確な Bash コマンド `npm run build` をマッチさせます
* `Bash(npm run test *)` は `npm run test` で始まる Bash コマンドをマッチさせます
* `Bash(npm *)` は `npm ` で始まるすべてのコマンドをマッチさせます
* `Bash(* install)` は ` install` で終わるすべてのコマンドをマッチさせます
* `Bash(git * main)` は `git checkout main`、`git merge main` などのコマンドをマッチさせます

`*` が前にスペースを付けて終わりに表示される場合（`Bash(ls *)` など）、単語境界を強制し、プレフィックスの後にスペースまたは文字列の終わりが続く必要があります。たとえば、`Bash(ls *)` は `ls -la` にマッチしますが `lsof` にはマッチしません。対照的に、スペースなしの `Bash(ls*)` は、単語境界制約がないため、`ls -la` と `lsof` の両方にマッチします。

<Tip>
  Claude Code はシェルオペレータ（`&&` など）を認識しているため、`Bash(safe-cmd *)` のようなプレフィックスマッチルールは、`safe-cmd && other-cmd` コマンドを実行する権限を与えません。
</Tip>

<Warning>
  コマンド引数を制限しようとする Bash パーミッションパターンは脆弱です。たとえば、`Bash(curl http://github.com/ *)` は curl を GitHub URL に制限することを意図していますが、次のようなバリエーションにはマッチしません。

  * URL の前のオプション。`curl -X GET http://github.com/...`
  * 異なるプロトコル。`curl https://github.com/...`
  * リダイレクト。`curl -L http://bit.ly/xyz`（github にリダイレクト）
  * 変数。`URL=http://github.com && curl $URL`
  * 余分なスペース。`curl  http://github.com`

  より信頼性の高い URL フィルタリングについては、以下を検討してください。

  * **Bash ネットワークツールを制限する**。deny ルールを使用して `curl`、`wget` などのコマンドをブロックし、許可されたドメインに対して `WebFetch(domain:github.com)` パーミッションで WebFetch ツールを使用します
  * **PreToolUse フックを使用する**。Bash コマンド内の URL を検証し、許可されていないドメインをブロックするフックを実装します
  * CLAUDE.md を通じて許可された curl パターンについて Claude Code に指示します

  WebFetch のみを使用しても、ネットワークアクセスは防止されません。Bash が許可されている場合、Claude は `curl`、`wget`、または他のツールを使用して任意の URL に到達できます。
</Warning>

### Read と Edit

`Edit` ルールは、ファイルを編集するすべての組み込みツールに適用されます。Claude は、Grep や Glob などのファイルを読み取るすべての組み込みツールに `Read` ルールを適用するためにベストエフォートを試みます。

Read と Edit ルールの両方は、[gitignore](https://git-scm.com/docs/gitignore) 仕様に従い、4 つの異なるパターンタイプがあります。

| パターン                | 意味                     | 例                                | マッチ                                |
| ------------------- | ---------------------- | -------------------------------- | ---------------------------------- |
| `//path`            | ファイルシステムルートからの**絶対**パス | `Read(//Users/alice/secrets/**)` | `/Users/alice/secrets/**`          |
| `~/path`            | **ホーム**ディレクトリからのパス     | `Read(~/Documents/*.pdf)`        | `/Users/alice/Documents/*.pdf`     |
| `/path`             | **設定ファイルに相対的な**パス      | `Edit(/src/**/*.ts)`             | `<settings file path>/src/**/*.ts` |
| `path` または `./path` | **現在のディレクトリに相対的な**パス   | `Read(*.env)`                    | `<cwd>/*.env`                      |

<Warning>
  `/Users/alice/file` のようなパターンは絶対パスではありません。設定ファイルに相対的です。絶対パスには `//Users/alice/file` を使用してください。
</Warning>

例：

* `Edit(/docs/**)`: `<project>/docs/` での編集（`/docs/` ではない）
* `Read(~/.zshrc)`: ホームディレクトリの `.zshrc` を読み取ります
* `Edit(//tmp/scratch.txt)`: 絶対パス `/tmp/scratch.txt` を編集します
* `Read(src/**)`: `<current-directory>/src/` から読み取ります

<Note>
  gitignore パターンでは、`*` は単一ディレクトリ内のファイルをマッチさせ、`**` はディレクトリ全体で再帰的にマッチさせます。すべてのファイルアクセスを許可するには、括弧なしでツール名を使用します。`Read`、`Edit`、または `Write`。
</Note>

### WebFetch

* `WebFetch(domain:example.com)` は example.com へのフェッチリクエストをマッチさせます

### MCP

* `mcp__puppeteer` は `puppeteer` サーバーによって提供されるすべてのツールをマッチさせます（Claude Code で設定された名前）
* `mcp__puppeteer__*` ワイルドカード構文は、`puppeteer` サーバーからのすべてのツールもマッチさせます
* `mcp__puppeteer__puppeteer_navigate` は `puppeteer` サーバーによって提供される `puppeteer_navigate` ツールをマッチさせます

### Task（subagents）

`Task(AgentName)` ルールを使用して、Claude が使用できる [subagents](/ja/sub-agents) を制御します。

* `Task(Explore)` は Explore subagent をマッチさせます
* `Task(Plan)` は Plan subagent をマッチさせます
* `Task(my-custom-agent)` は `my-custom-agent` という名前のカスタム subagent をマッチさせます

これらのルールを設定の `deny` 配列に追加するか、`--disallowedTools` CLI フラグを使用して特定のエージェントを無効にします。Explore エージェントを無効にするには。

```json  theme={null}
{
  "permissions": {
    "deny": ["Task(Explore)"]
  }
}
```

## フックでパーミッションを拡張する

[Claude Code フック](/ja/hooks-guide)は、実行時にパーミッション評価を実行するカスタムシェルコマンドを登録する方法を提供します。Claude Code がツール呼び出しを行うと、PreToolUse フックはパーミッションシステムの前に実行され、フック出力はパーミッションシステムの代わりにツール呼び出しを承認または拒否するかどうかを決定できます。

## 作業ディレクトリ

デフォルトでは、Claude は起動されたディレクトリ内のファイルにアクセスできます。このアクセスを拡張できます。

* **起動時**。`--add-dir <path>` CLI 引数を使用します
* **セッション中**。`/add-dir` コマンドを使用します
* **永続的な設定**。[設定ファイル](/ja/settings#settings-files)の `additionalDirectories` に追加します

追加ディレクトリ内のファイルは、元の作業ディレクトリと同じパーミッションルールに従います。プロンプトなしで読み取り可能になり、ファイル編集パーミッションは現在のパーミッションモードに従います。

## パーミッションがサンドボックスとどのように相互作用するか

パーミッションと [サンドボックス](/ja/sandboxing) は相補的なセキュリティレイヤーです。

* **パーミッション**は、Claude Code が使用できるツールと、アクセスできるファイルまたはドメインを制御します。すべてのツール（Bash、Read、Edit、WebFetch、MCP など）に適用されます。
* **サンドボックス**は、Bash ツールのファイルシステムとネットワークアクセスを制限する OS レベルの強制を提供します。Bash コマンドとその子プロセスにのみ適用されます。

防御を深くするために両方を使用します。

* パーミッション deny ルールは、Claude が制限されたリソースへのアクセスを試みることさえ防止します
* サンドボックス制限は、プロンプトインジェクションが Claude の意思決定をバイパスしても、Bash コマンドが定義された境界外のリソースに到達することを防止します
* サンドボックス内のファイルシステム制限は、Read と Edit deny ルールを使用し、別のサンドボックス設定は使用しません
* ネットワーク制限は、WebFetch パーミッションルールとサンドボックスの `allowedDomains` リストを組み合わせます

## 管理設定

Claude Code 設定の一元化された制御が必要な組織の場合、管理者は `managed-settings.json` ファイルをシステムディレクトリにデプロイできます。これらのポリシーファイルは通常の設定ファイルと同じ形式に従い、ユーザーまたはプロジェクト設定でオーバーライドできません。

**管理設定ファイルの場所**。

* **macOS**。`/Library/Application Support/ClaudeCode/managed-settings.json`
* **Linux と WSL**。`/etc/claude-code/managed-settings.json`
* **Windows**。`C:\Program Files\ClaudeCode\managed-settings.json`

<Note>
  これらはシステム全体のパス（`~/Library/...` のようなユーザーホームディレクトリではない）で、管理者権限が必要です。IT 管理者によってデプロイされるように設計されています。
</Note>

### 管理専用設定

一部の設定は管理設定でのみ有効です。

| 設定                                | 説明                                                                                                                |
| :-------------------------------- | :---------------------------------------------------------------------------------------------------------------- |
| `disableBypassPermissionsMode`    | `"disable"` に設定して、`bypassPermissions` モードと `--dangerously-skip-permissions` フラグを防止します                             |
| `allowManagedPermissionRulesOnly` | `true` の場合、ユーザーおよびプロジェクト設定が `allow`、`ask`、または `deny` パーミッションルールを定義することを防止します。管理設定のルールのみが適用されます                    |
| `allowManagedHooksOnly`           | `true` の場合、ユーザー、プロジェクト、およびプラグインフックの読み込みを防止します。管理フックと SDK フックのみが許可されます                                             |
| `strictKnownMarketplaces`         | ユーザーが追加できるプラグインマーケットプレイスを制御します。[管理マーケットプレイス制限](/ja/plugin-marketplaces#managed-marketplace-restrictions)を参照してください |

## 設定の優先順位

パーミッションルールは、他のすべての Claude Code 設定と同じ [設定優先順位](/ja/settings#settings-precedence) に従います。管理設定が最も高い優先順位を持ち、その後にコマンドライン引数、ローカルプロジェクト、共有プロジェクト、ユーザー設定が続きます。

ユーザー設定でパーミッションが許可されているが、プロジェクト設定で拒否されている場合、プロジェクト設定が優先され、パーミッションはブロックされます。

## 設定例

この [リポジトリ](https://github.com/anthropics/claude-code/tree/main/examples/settings)には、一般的なデプロイメントシナリオの開始設定が含まれています。これらを出発点として使用し、ニーズに合わせて調整してください。

## 関連項目

* [設定](/ja/settings)。パーミッション設定テーブルを含む完全な設定リファレンス
* [サンドボックス](/ja/sandboxing)。Bash コマンドの OS レベルのファイルシステムとネットワーク分離
* [認証](/ja/authentication)。Claude Code へのユーザーアクセスの設定
* [セキュリティ](/ja/security)。セキュリティ保護とベストプラクティス
* [フック](/ja/hooks-guide)。ワークフローの自動化とパーミッション評価の拡張
