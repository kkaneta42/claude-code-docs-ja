> ## Documentation Index
> Fetch the complete documentation index at: https://code.claude.com/docs/llms.txt
> Use this file to discover all available pages before exploring further.

# アイデンティティとアクセス管理

> Claude Codeのユーザー認証、認可、およびアクセス制御を組織内で設定する方法を学びます。

## 認証方法

Claude Codeのセットアップには、Anthropicモデルへのアクセスが必要です。チームの場合、以下のいずれかの方法でClaude Codeアクセスをセットアップできます：

* [Claude for Teams or Enterprise](/ja/setup#for-teams-and-organizations)（推奨）
* [チームビリングを使用したClaude Console](/ja/setup#for-teams-and-organizations)
* [Amazon Bedrock](/ja/amazon-bedrock)
* [Google Vertex AI](/ja/google-vertex-ai)
* [Microsoft Foundry](/ja/microsoft-foundry)

### Claude for Teams or Enterprise（推奨）

[Claude for Teams](https://claude.com/pricing#team-&-enterprise)と[Claude for Enterprise](https://anthropic.com/contact-sales)は、Claude Codeを使用する組織に最適なエクスペリエンスを提供します。チームメンバーは、一元化されたビリングとチーム管理により、Claude CodeとWeb上のClaudeの両方にアクセスできます。

* **Claude for Teams**：コラボレーション機能、管理ツール、ビリング管理を備えたセルフサービスプラン。小規模なチームに最適です。
* **Claude for Enterprise**：SSO、ドメインキャプチャ、ロールベースの権限、コンプライアンスAPI、および組織全体のClaude Code設定のための管理ポリシー設定を追加します。セキュリティとコンプライアンス要件を持つ大規模な組織に最適です。

**Claude Codeアクセスをセットアップするには：**

1. [Claude for Teams](https://claude.com/pricing#team-&-enterprise)にサブスクライブするか、[Claude for Enterprise](https://anthropic.com/contact-sales)について営業に連絡してください
2. 管理ダッシュボードからチームメンバーを招待します
3. チームメンバーはClaude Codeをインストールし、Claude.aiアカウントでログインします

### Claude Console認証

API ベースのビリングを好む組織の場合、Claude Consoleを通じてアクセスをセットアップできます。

**Claude Consoleを介してチームのClaude Codeアクセスをセットアップするには：**

1. 既存のClaude Consoleアカウントを使用するか、新しいClaude Consoleアカウントを作成します
2. 以下のいずれかの方法でユーザーを追加できます：
   * Console内からユーザーを一括招待します（Console -> Settings -> Members -> Invite）
   * [SSOをセットアップします](https://support.claude.com/en/articles/13132885-setting-up-single-sign-on-sso)
3. ユーザーを招待する際、以下のいずれかのロールが必要です：
   * 「Claude Code」ロールは、ユーザーがClaude Code APIキーのみを作成できることを意味します
   * 「Developer」ロールは、ユーザーがあらゆる種類のAPIキーを作成できることを意味します
4. 招待された各ユーザーは、以下の手順を完了する必要があります：
   * Console招待を受け入れます
   * [システム要件を確認します](/ja/setup#system-requirements)
   * [Claude Codeをインストールします](/ja/setup#installation)
   * Consoleアカウント認証情報でログインします

### クラウドプロバイダー認証

**Bedrock、Vertex、またはAzure経由でチームのClaude Codeアクセスをセットアップするには：**

1. [Bedrock docs](/ja/amazon-bedrock)、[Vertex docs](/ja/google-vertex-ai)、または[Microsoft Foundry docs](/ja/microsoft-foundry)に従います
2. 環境変数とクラウド認証情報を生成するための手順をユーザーに配布します。[ここで設定を管理する方法](/ja/settings)についてさらに詳しく読んでください。
3. ユーザーは[Claude Codeをインストール](/ja/setup#installation)できます

## アクセス制御と権限

エージェントが何をすることが許可されているか（例：テストの実行、リンターの実行）と何が許可されていないか（例：クラウドインフラストラクチャの更新）を正確に指定できるように、きめ細かい権限をサポートしています。これらの権限設定は、バージョン管理にチェックインでき、組織内のすべての開発者に配布でき、個々の開発者によってカスタマイズできます。

### 権限システム

Claude Codeは、パワーと安全性のバランスを取るために、段階的な権限システムを使用しています：

| ツールタイプ   | 例             | 承認が必要 | 「はい、今後は聞かない」の動作         |
| :------- | :------------ | :---- | :---------------------- |
| 読み取り専用   | ファイル読み取り、Grep | いいえ   | N/A                     |
| Bashコマンド | シェル実行         | はい    | プロジェクトディレクトリとコマンドごとに永続的 |
| ファイル変更   | ファイルの編集/書き込み  | はい    | セッション終了まで               |

### 権限の設定

`/permissions`を使用してClaude Codeのツール権限を表示および管理できます。このUIは、すべての権限ルールと、それらが取得されるsettings.jsonファイルをリストします。

* **Allow**ルールは、Claude Codeが手動承認なしで指定されたツールを使用できるようにします。
* **Ask**ルールは、Claude Codeが指定されたツールを使用しようとするたびに確認を促します。
* **Deny**ルールは、Claude Codeが指定されたツールを使用することを防止します。

ルールは順序で評価されます：**deny → ask → allow**。最初にマッチするルールが優先されるため、denyルールは常に優先されます。

* **追加ディレクトリ**は、Claude のファイルアクセスを初期作業ディレクトリを超えたディレクトリに拡張します。
* **デフォルトモード**は、新しいリクエストに遭遇したときのClaudeの権限動作を制御します。

権限ルールは、`Tool`または`Tool(optional-specifier)`の形式を使用します

ツール名だけのルールは、そのツールの任意の使用にマッチします。たとえば、許可リストに`Bash`を追加すると、Claude Codeはユーザーの承認を必要とせずにBashツールを使用できます。`Bash(*)`は**すべての**Bashコマンドにマッチしないことに注意してください。すべての使用にマッチするには、括弧なしで`Bash`を使用します。

<Note>
  ワイルドカードを含む権限ルール構文の簡単なリファレンスについては、設定ドキュメントの[権限ルール構文](/ja/settings#permission-rule-syntax)を参照してください。
</Note>

#### 権限モード

Claude Codeは、[設定ファイル](/ja/settings#settings-files)で`defaultMode`として設定できるいくつかの権限モードをサポートしています：

| モード                 | 説明                                                                                                         |
| :------------------ | :--------------------------------------------------------------------------------------------------------- |
| `default`           | 標準動作 - 各ツールの最初の使用時に権限を促します                                                                                 |
| `acceptEdits`       | セッションのファイル編集権限を自動的に受け入れます                                                                                  |
| `plan`              | プランモード - Claudeはファイルを分析できますが、ファイルを変更したりコマンドを実行したりすることはできません                                                |
| `dontAsk`           | `/permissions`または[`permissions.allow`](/ja/settings#permission-settings)ルールを通じて事前に承認されていない限り、ツールを自動的に拒否します |
| `bypassPermissions` | すべての権限プロンプトをスキップします（安全な環境が必要 - 下の警告を参照）                                                                    |

#### 作業ディレクトリ

デフォルトでは、Claudeは起動されたディレクトリ内のファイルにアクセスできます。このアクセスを拡張できます：

* **スタートアップ中**：`--add-dir <path>` CLIオプションを使用します
* **セッション中**：`/add-dir`スラッシュコマンドを使用します
* **永続的な設定**：[設定ファイル](/ja/settings#settings-files)の`additionalDirectories`に追加します

追加ディレクトリ内のファイルは、元の作業ディレクトリと同じ権限ルールに従います。プロンプトなしで読み取り可能になり、ファイル編集権限は現在の権限モードに従います。

#### ツール固有の権限ルール

一部のツールは、より細かい権限制御をサポートしています：

**Bash**

Bash権限ルールは、`:*`を使用したプレフィックスマッチングと`*`を使用したワイルドカードマッチングの両方をサポートしています：

* `Bash(npm run build)` 正確なBashコマンド`npm run build`にマッチします
* `Bash(npm run test:*)` `npm run test`で始まるBashコマンドにマッチします
* `Bash(npm *)` `npm `で始まるコマンドにマッチします（例：`npm install`、`npm run build`）
* `Bash(* install)` ` install`で終わるコマンドにマッチします（例：`npm install`、`yarn install`）
* `Bash(git * main)` `git checkout main`、`git merge main`などのコマンドにマッチします

<Tip>
  Claude Codeはシェルオペレーター（`&&`など）を認識しているため、`Bash(safe-cmd:*)`のようなプレフィックスマッチルールは、`safe-cmd && other-cmd`コマンドを実行する権限を与えません
</Tip>

<Warning>
  Bash権限パターンの重要な制限：

  1. `:*`ワイルドカードはプレフィックスマッチングのためにパターンの最後でのみ機能します
  2. `*`ワイルドカードは任意の位置に表示でき、任意の文字シーケンスにマッチします
  3. `Bash(curl http://github.com/:*)`のようなパターンは、多くの方法でバイパスできます：
     * URLの前のオプション：`curl -X GET http://github.com/...`はマッチしません
     * 異なるプロトコル：`curl https://github.com/...`はマッチしません
     * リダイレクト：`curl -L http://bit.ly/xyz`（githubにリダイレクト）
     * 変数：`URL=http://github.com && curl $URL`はマッチしません
     * 余分なスペース：`curl  http://github.com`はマッチしません

  より信頼性の高いURLフィルタリングについては、以下を検討してください：

  * **Bashネットワークツールを制限する**：denyルールを使用して`curl`、`wget`、および同様のコマンドをブロックし、許可されたドメインに対して`WebFetch(domain:github.com)`権限でWebFetchツールを使用します
  * **PreToolUseフックを使用する**：Bashコマンド内のURLを検証し、許可されていないドメインをブロックするフックを実装します
  * CLAUDE.mdを介してClaude Codeに許可されたcurlパターンについて指示します

  WebFetchのみを使用しても、ネットワークアクセスは防止されないことに注意してください。Bashが許可されている場合、Claude Codeは`curl`、`wget`、または他のツールを使用して任意のURLに到達できます。
</Warning>

**Read & Edit**

`Edit`ルールは、ファイルを編集するすべての組み込みツールに適用されます。Claudeは、GrepやGlobなどのファイルを読み取るすべての組み込みツールに`Read`ルールを適用するためにベストエフォートを試みます。

Read & Editルールは両方とも、4つの異なるパターンタイプを持つ[gitignore](https://git-scm.com/docs/gitignore)仕様に従います：

| パターン              | 意味                     | 例                                | マッチ                                |
| ----------------- | ---------------------- | -------------------------------- | ---------------------------------- |
| `//path`          | ファイルシステムルートからの**絶対**パス | `Read(//Users/alice/secrets/**)` | `/Users/alice/secrets/**`          |
| `~/path`          | **ホーム**ディレクトリからのパス     | `Read(~/Documents/*.pdf)`        | `/Users/alice/Documents/*.pdf`     |
| `/path`           | **設定ファイルに相対的な**パス      | `Edit(/src/**/*.ts)`             | `<settings file path>/src/**/*.ts` |
| `path`または`./path` | **現在のディレクトリに相対的な**パス   | `Read(*.env)`                    | `<cwd>/*.env`                      |

<Warning>
  `/Users/alice/file`のようなパターンは絶対パスではなく、設定ファイルに相対的です！絶対パスには`//Users/alice/file`を使用してください。
</Warning>

* `Edit(/docs/**)` - `<project>/docs/`内の編集（`/docs/`ではありません！）
* `Read(~/.zshrc)` - ホームディレクトリの`.zshrc`を読み取ります
* `Edit(//tmp/scratch.txt)` - 絶対パス`/tmp/scratch.txt`を編集します
* `Read(src/**)` - `<current-directory>/src/`から読み取ります

**WebFetch**

* `WebFetch(domain:example.com)` example.comへのフェッチリクエストにマッチします

**MCP**

* `mcp__puppeteer` `puppeteer`サーバーによって提供されるツールにマッチします（Claude Codeで設定された名前）
* `mcp__puppeteer__*` `puppeteer`サーバーからのすべてのツールにもマッチするワイルドカード構文
* `mcp__puppeteer__puppeteer_navigate` `puppeteer`サーバーによって提供される`puppeteer_navigate`ツールにマッチします

**Task（サブエージェント）**

`Task(AgentName)`ルールを使用して、Claude が使用できる[サブエージェント](/ja/sub-agents)を制御します：

* `Task(Explore)` Exploreサブエージェントにマッチします
* `Task(Plan)` Planサブエージェントにマッチします
* `Task(Verify)` Verifyサブエージェントにマッチします

これらのルールを[設定](/ja/settings#permission-settings)の`deny`配列に追加するか、`--disallowedTools` CLIフラグを使用して特定のエージェントを無効にします。たとえば、Exploreエージェントを無効にするには：

```json  theme={null}
{
  "permissions": {
    "deny": ["Task(Explore)"]
  }
}
```

### フックを使用した追加の権限制御

[Claude Codeフック](/ja/hooks-guide)は、実行時に権限評価を実行するカスタムシェルコマンドを登録する方法を提供します。Claude Codeがツール呼び出しを行うと、PreToolUseフックは権限システムが実行される前に実行され、フック出力は権限システムの代わりにツール呼び出しを承認または拒否するかどうかを決定できます。

### 管理設定

集中化されたClaude Code設定制御が必要な組織の場合、管理者は`managed-settings.json`ファイルを[システムディレクトリ](/ja/settings#settings-files)にデプロイできます。これらのポリシーファイルは通常の設定ファイルと同じ形式に従い、ユーザーまたはプロジェクト設定でオーバーライドすることはできません。

### 設定の優先順位

複数の設定ソースが存在する場合、以下の順序（優先度が高い順から低い順）で適用されます：

1. 管理設定（`managed-settings.json`）
2. コマンドライン引数
3. ローカルプロジェクト設定（`.claude/settings.local.json`）
4. 共有プロジェクト設定（`.claude/settings.json`）
5. ユーザー設定（`~/.claude/settings.json`）

この階層により、組織のポリシーが常に適用されながら、プロジェクトおよびユーザーレベルで適切な柔軟性が許可されます。

## 認証情報管理

Claude Codeは認証認証情報を安全に管理します：

* **保存場所**：macOSでは、APIキー、OAuthトークン、およびその他の認証情報は、暗号化されたmacOS Keychainに保存されます。
* **サポートされている認証タイプ**：Claude.ai認証情報、Claude API認証情報、Azure Auth、Bedrock Auth、およびVertex Auth。
* **カスタム認証情報スクリプト**：[`apiKeyHelper`](/ja/settings#available-settings)設定は、APIキーを返すシェルスクリプトを実行するように設定できます。
* **リフレッシュ間隔**：デフォルトでは、`apiKeyHelper`は5分後またはHTTP 401応答時に呼び出されます。カスタムリフレッシュ間隔の場合は、`CLAUDE_CODE_API_KEY_HELPER_TTL_MS`環境変数を設定します。
