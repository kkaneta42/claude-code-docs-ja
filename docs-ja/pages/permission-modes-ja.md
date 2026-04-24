> ## Documentation Index
> Fetch the complete documentation index at: https://code.claude.com/docs/llms.txt
> Use this file to discover all available pages before exploring further.

# パーミッションモードを選択する

> Claude がファイルを編集またはコマンドを実行する前に確認するかどうかを制御します。CLI で Shift+Tab でモードをサイクルするか、VS Code、Desktop、claude.ai のモードセレクターを使用します。

Claude がファイルを編集、シェルコマンドを実行、またはネットワークリクエストを行いたい場合、一時停止してアクションを承認するよう求めます。パーミッションモードは、その一時停止がどのくらいの頻度で発生するかを制御します。選択するモードはセッションのフローを形作ります。デフォルトモードではアクションが来るたびにレビューし、より緩いモードでは Claude が長い中断のない作業を行い、完了時に報告できます。機密作業には監視を強化し、信頼できる方向性には中断を減らしてください。

## 利用可能なモード

各モードは利便性と監視のバランスが異なります。以下の表は、各モードでパーミッションプロンプトなしで Claude が実行できることを示しています。

| モード                                                                 | 確認なしで実行されるもの                                               | 最適な用途             |
| :------------------------------------------------------------------ | :--------------------------------------------------------- | :---------------- |
| `default`                                                           | 読み取りのみ                                                     | 開始、機密作業           |
| [`acceptEdits`](#auto-approve-file-edits-with-acceptedits-mode)     | 読み取り、ファイル編集、一般的なファイルシステムコマンド（`mkdir`、`touch`、`mv`、`cp` など） | レビュー中のコードの反復処理    |
| [`plan`](#analyze-before-you-edit-with-plan-mode)                   | 読み取りのみ                                                     | コードベースの探索、変更前     |
| [`auto`](#eliminate-prompts-with-auto-mode)                         | すべて、背景安全チェック付き                                             | 長時間タスク、プロンプト疲労の軽減 |
| [`dontAsk`](#allow-only-pre-approved-tools-with-dontask-mode)       | 事前承認済みツールのみ                                                | ロックダウン CI とスクリプト  |
| [`bypassPermissions`](#skip-all-checks-with-bypasspermissions-mode) | 保護されたパス以外のすべて                                              | 隔離されたコンテナと VM のみ  |

モードに関係なく、[保護されたパス](#protected-paths)への書き込みは自動承認されることはなく、リポジトリ状態と Claude 独自の設定を偶発的な破損から保護します。

モードはベースラインを設定します。[パーミッションルール](/ja/permissions#manage-permissions)を上に層状にして、`bypassPermissions` を除くすべてのモードで特定のツールを事前承認またはブロックします。`bypassPermissions` はパーミッション層全体をスキップします。

## パーミッションモードを切り替える

セッション中、起動時、または永続的なデフォルトとしてモードを切り替えることができます。モードは Claude にチャットで尋ねるのではなく、これらのコントロールを通じて設定されます。以下からインターフェースを選択して、変更方法を確認してください。

<Tabs>
  <Tab title="CLI">
    **セッション中**：`Shift+Tab` を押して `default` → `acceptEdits` → `plan` をサイクルします。現在のモードはステータスバーに表示されます。すべてのモードがデフォルトサイクルに含まれるわけではありません。

    * `auto`：アカウントが [auto モード要件](#eliminate-prompts-with-auto-mode)を満たす場合に表示されます。auto へのサイクルはオプトインプロンプトを表示し、それを受け入れるか、**いいえ、今後は聞かないでください** を選択して auto をサイクルから削除するまで続きます
    * `bypassPermissions`：`--permission-mode bypassPermissions`、`--dangerously-skip-permissions`、または `--allow-dangerously-skip-permissions` で開始した後に表示されます。`--allow-` バリアントはモードをサイクルに追加しますが、アクティブ化しません
    * `dontAsk`：サイクルに表示されることはありません。`--permission-mode dontAsk` で設定します

    有効なオプションモードは `plan` の後にスロットインし、`bypassPermissions` が最初で `auto` が最後です。両方が有効な場合、`bypassPermissions` から `auto` へのサイクルを通過します。

    **起動時**：モードをフラグとして渡します。

    ```bash theme={null}
    claude --permission-mode plan
    ```

    **デフォルトとして**：[設定](/ja/settings#settings-files)で `defaultMode` を設定します。

    ```json theme={null}
    {
      "permissions": {
        "defaultMode": "acceptEdits"
      }
    }
    ```

    同じ `--permission-mode` フラグは [非対話的実行](/ja/headless)用に `-p` で機能します。
  </Tab>

  <Tab title="VS Code">
    **セッション中**：プロンプトボックスの下部にあるモード指示器をクリックします。

    **デフォルトとして**：VS Code 設定で `claudeCode.initialPermissionMode` を設定するか、Claude Code 拡張機能設定パネルを使用します。

    モード指示器は以下のラベルを表示し、各ラベルが適用するモードにマップされます。

    | UI ラベル       | モード                 |
    | :----------- | :------------------ |
    | 編集前に確認       | `default`           |
    | 自動編集         | `acceptEdits`       |
    | 計画モード        | `plan`              |
    | 自動モード        | `auto`              |
    | パーミッションをバイパス | `bypassPermissions` |

    自動モードは拡張機能設定で **Allow dangerously skip permissions** を有効にした後、モード指示器に表示されますが、アカウントが [auto モードセクション](#eliminate-prompts-with-auto-mode)にリストされているすべての要件を満たすまで利用不可のままです。`claudeCode.initialPermissionMode` 設定は `auto` を受け入れません。デフォルトで自動モードで開始するには、代わりに Claude Code [`settings.json`](/ja/settings#settings-files) で `defaultMode` を設定します。

    パーミッションのバイパスもモード指示器に表示される前に **Allow dangerously skip permissions** トグルが必要です。

    拡張機能固有の詳細については、[VS Code ガイド](/ja/vs-code)を参照してください。
  </Tab>

  <Tab title="JetBrains">
    JetBrains プラグインは IDE ターミナルで Claude Code を実行するため、モードの切り替えは CLI と同じように機能します。`Shift+Tab` を押してサイクルするか、起動時に `--permission-mode` を渡します。
  </Tab>

  <Tab title="Desktop">
    送信ボタンの横にあるモードセレクターを使用します。自動とパーミッションのバイパスは Desktop 設定で有効にした後にのみ表示されます。[Desktop ガイド](/ja/desktop#choose-a-permission-mode)を参照してください。
  </Tab>

  <Tab title="Web and mobile">
    [claude.ai/code](https://claude.ai/code) のプロンプトボックスの横またはモバイルアプリのモードドロップダウンを使用します。パーミッションプロンプトは承認のために claude.ai に表示されます。どのモードが表示されるかはセッションが実行される場所によります。

    * **[Claude Code on the web](/ja/claude-code-on-the-web) のクラウドセッション**：自動編集受け入れと計画モード。パーミッション確認、自動、パーミッションのバイパスは利用できません。
    * **ローカルマシンの [Remote Control](/ja/remote-control) セッション**：パーミッション確認、自動編集受け入れ、計画モード。自動とパーミッションのバイパスは利用できません。

    Remote Control の場合、ホストを起動するときに開始モードを設定することもできます。

    ```bash theme={null}
    claude remote-control --permission-mode acceptEdits
    ```
  </Tab>
</Tabs>

## acceptEdits モードでファイル編集を自動承認する

`acceptEdits` モードでは Claude はプロンプトなしに作業ディレクトリ内のファイルを作成および編集できます。このモードがアクティブな間、ステータスバーは `⏵⏵ accept edits on` を表示します。

ファイル編集に加えて、`acceptEdits` モードは一般的なファイルシステム Bash コマンドを自動承認します。`mkdir`、`touch`、`rm`、`rmdir`、`mv`、`cp`、`sed`。これらのコマンドは `LANG=C` または `NO_COLOR=1` のような安全な環境変数、または `timeout`、`nice`、`nohup` のようなプロセスラッパーでプレフィックスされた場合にも自動承認されます。ファイル編集と同様に、自動承認は作業ディレクトリまたは `additionalDirectories` 内のパスにのみ適用されます。そのスコープ外のパス、[保護されたパス](#protected-paths)への書き込み、その他すべての Bash コマンドはまだプロンプトが表示されます。

事実後にエディターまたは `git diff` 経由で変更をレビューしたい場合、各編集をインラインで承認するのではなく `acceptEdits` を使用します。デフォルトモードから `Shift+Tab` を 1 回押して入るか、直接開始します。

```bash theme={null}
claude --permission-mode acceptEdits
```

## 計画モードで編集前に分析する

計画モードは Claude に変更を加えずに調査と提案を行うよう指示します。Claude はファイルを読み、シェルコマンドを実行して探索し、計画を書きますが、ソースを編集しません。パーミッションプロンプトはデフォルトモードと同じように適用されます。

`Shift+Tab` を押すか、単一のプロンプトに `/plan` をプレフィックスして計画モードに入ります。CLI から計画モードで開始することもできます。

```bash theme={null}
claude --permission-mode plan
```

計画モードを終了するには `Shift+Tab` を再度押し、計画を承認しません。

計画の準備ができたら、Claude はそれを提示し、どのように進めるかを尋ねます。そのプロンプトから以下を実行できます。

* 承認して自動モードで開始
* 承認して編集を受け入れる
* 承認して各編集を手動でレビュー
* フィードバック付きで計画を続ける
* [Ultraplan](/ja/ultraplan) でブラウザベースのレビュー用に改善

各承認オプションは計画コンテキストを最初にクリアするオプションも提供します。

## 自動モードでプロンプトを削除する

<Note>
  自動モードには Claude Code v2.1.83 以降が必要です。
</Note>

自動モードでは Claude はパーミッションプロンプトなしで実行できます。別の分類器モデルはアクション実行前にアクションをレビューし、リクエストを超えてエスカレートするもの、認識されないインフラストラクチャをターゲットにするもの、または Claude が読んだ敵対的なコンテンツによって駆動されているように見えるものをブロックします。

<Warning>
  自動モードはリサーチプレビューです。プロンプトを削除しますが、安全性を保証しません。一般的な方向を信頼するタスクに使用し、機密操作のレビューの代わりとしては使用しないでください。
</Warning>

自動モードはアカウントがこれらすべての要件を満たす場合にのみ利用可能です。

* **プラン**：Max、Team、Enterprise、または API。Pro では利用できません。
* **管理者**：Team と Enterprise では、管理者がユーザーがオンにできるようにする前に [Claude Code 管理設定](https://claude.ai/admin-settings/claude-code) で有効にする必要があります。管理者は [管理設定](/ja/permissions#managed-settings) で `permissions.disableAutoMode` を `"disable"` に設定することでロックオフすることもできます。
* **モデル**：Team、Enterprise、API プランで Claude Sonnet 4.6、Opus 4.6、または Opus 4.7。Max プランで Claude Opus 4.7 のみ。Haiku および claude-3 モデルを含む他のモデルはサポートされていません。
* **プロバイダー**：Anthropic API のみ。Bedrock、Vertex、Foundry では利用できません。

Claude Code が自動モードを利用不可と報告する場合、これらの要件のいずれかが満たされていません。これは一時的な停止ではありません。モデルに名前を付けて自動モードが「アクションの安全性を判断できない」と言う別のメッセージは一時的な分類器停止です。[エラーリファレンス](/ja/errors#auto-mode-cannot-determine-the-safety-of-an-action)を参照してください。

### 分類器がデフォルトでブロックするもの

分類器は作業ディレクトリとリポジトリの設定されたリモートを信頼します。その他すべては [信頼できるインフラストラクチャを設定](/ja/auto-mode-config)するまで外部として扱われます。

**デフォルトでブロック**：

* `curl | bash` のようなコードのダウンロードと実行
* 機密データを外部エンドポイントに送信
* 本番環境へのデプロイとマイグレーション
* クラウドストレージでの大量削除
* IAM またはリポジトリパーミッションの付与
* 共有インフラストラクチャの変更
* セッション前に存在していたファイルを不可逆的に破壊
* フォースプッシュまたは `main` への直接プッシュ

**デフォルトで許可**：

* 作業ディレクトリ内のローカルファイル操作
* ロックファイルまたはマニフェストで宣言されている依存関係のインストール
* `.env` を読み取り、認証情報を一致する API に送信
* 読み取り専用 HTTP リクエスト
* 開始したブランチまたは Claude が作成したブランチへのプッシュ

サンドボックスネットワークアクセスリクエストはデフォルトで許可されるのではなく、分類器を通じてルーティングされます。`claude auto-mode defaults` を実行して完全なルールリストを確認してください。日常的なアクションがブロックされている場合、管理者は `autoMode.environment` 設定を通じて信頼できるリポジトリ、バケット、サービスを追加できます。[自動モードを設定](/ja/auto-mode-config)を参照してください。

### 会話で述べる境界

分類器は会話で述べる境界をブロック信号として扱います。Claude に「プッシュしないで」または「デプロイ前にレビューを待って」と言う場合、分類器はデフォルトルールが許可する場合でも一致するアクションをブロックします。境界は後のメッセージで解除するまで有効です。Claude 独自の判断が条件が満たされたことは解除しません。

境界はルールとして保存されません。分類器はチェックのたびにトランスクリプトから再読み込みするため、[コンテキストコンパクション](/ja/costs#reduce-token-usage)が述べたメッセージを削除する場合、境界は失われる可能性があります。ハード保証の場合、代わりに [deny ルール](/ja/permissions#permission-rule-syntax)を追加します。

### 自動モードがフォールバックする場合

拒否されたアクションはそれぞれ通知を表示し、`/permissions` の Recently denied タブに表示されます。そこで `r` を押して手動承認で再試行できます。

分類器がアクション 3 回連続でブロックするか、合計 20 回ブロックする場合、自動モードは一時停止し、Claude Code はプロンプトを再開します。プロンプトされたアクションを承認すると自動モードが再開されます。これらのしきい値は設定不可です。許可されたアクションは連続カウンターをリセットし、合計カウンターはセッション中に保持され、独自の制限がフォールバックをトリガーする場合にのみリセットされます。

[非対話的モード](/ja/headless)で `-p` フラグを使用する場合、プロンプトするユーザーがいないため、繰り返されるブロックはセッションを中止します。

繰り返されるブロックは通常、分類器がインフラストラクチャについてのコンテキストが不足していることを意味します。`/feedback` を使用して誤検知を報告するか、管理者に [信頼できるインフラストラクチャを設定](/ja/auto-mode-config)するよう依頼してください。

<AccordionGroup>
  <Accordion title="分類器がアクションを評価する方法">
    各アクションは固定の決定順序を通過します。最初に一致するステップが勝ちます。

    1. [allow または deny ルール](/ja/permissions#manage-permissions)に一致するアクションは即座に解決されます
    2. 読み取り専用アクションと作業ディレクトリ内のファイル編集は自動承認されます。[保護されたパス](#protected-paths)への書き込みを除く
    3. その他すべては分類器に送られます
    4. 分類器がブロックする場合、Claude は理由を受け取り、別のアプローチを試みます

    自動モードに入ると、任意のコード実行を許可する広いルールが削除されます。

    * ブランケット `Bash(*)`
    * `Bash(python*)` のようなワイルドカードインタープリター
    * パッケージマネージャー実行コマンド
    * `Agent` allow ルール

    `Bash(npm test)` のような狭いルールは引き継がれます。削除されたルールは自動モードを終了するときに復元されます。

    分類器はユーザーメッセージ、ツール呼び出し、CLAUDE.md コンテンツを見ます。ツール結果は削除されるため、ファイルまたは Web ページの敵対的なコンテンツはそれを直接操作することはできません。サーバー側プローブは受信ツール結果をスキャンし、Claude がそれを読む前に疑わしいコンテンツにフラグを立てます。これらのレイヤーがどのように連携するかについての詳細については、[自動モードのお知らせ](https://claude.com/blog/auto-mode)および [エンジニアリング深掘り](https://www.anthropic.com/engineering/claude-code-auto-mode)を参照してください。
  </Accordion>

  <Accordion title="自動モードがサブエージェントを処理する方法">
    分類器は [サブエージェント](/ja/sub-agents)の作業を 3 つのポイントでチェックします。

    1. サブエージェント開始前に、委譲されたタスク説明が評価されるため、危険に見えるタスクは生成時にブロックされます。
    2. サブエージェント実行中、その各アクションは親セッションと同じルールで分類器を通過し、サブエージェントのフロントマターの任意の `permissionMode` は無視されます。
    3. サブエージェント完了時、分類器はその完全なアクション履歴をレビューします。リターンチェックが懸念事項にフラグを立てた場合、セキュリティ警告がサブエージェントの結果の前に付加されます。
  </Accordion>

  <Accordion title="コストとレイテンシ">
    分類器は `/model` 選択から独立したサーバー設定モデルで実行されるため、モデルの切り替えは分類器の可用性を変更しません。分類器呼び出しはトークン使用量にカウントされます。各チェックはトランスクリプトの一部と保留中のアクションを送信し、実行前にラウンドトリップを追加します。保護されたパス外の読み取りと作業ディレクトリ編集は分類器をスキップするため、オーバーヘッドは主にシェルコマンドとネットワーク操作から発生します。
  </Accordion>
</AccordionGroup>

## dontAsk モードで事前承認済みツールのみを許可する

`dontAsk` モードはプロンプトが表示されるすべてのツール呼び出しを自動的に拒否します。`permissions.allow` ルールと [読み取り専用 Bash コマンド](/ja/permissions#read-only-commands)に一致するアクションのみが実行できます。明示的な `ask` ルールはプロンプトするのではなく拒否されます。これにより、モードは CI パイプラインまたは Claude が実行を許可されているものを事前に定義する制限環境で完全に非対話的になります。

フラグで起動時に設定します。

```bash theme={null}
claude --permission-mode dontAsk
```

## bypassPermissions モードですべてのチェックをスキップする

`bypassPermissions` モードはパーミッションプロンプトと安全チェックを無効にするため、ツール呼び出しは即座に実行されます。[保護されたパス](#protected-paths)への書き込みは、まだプロンプトが表示される唯一のアクションです。このモードは、Claude Code がホストシステムに損害を与えることができないコンテナ、VM、またはインターネットアクセスのない devcontainer のような隔離環境でのみ使用してください。

有効にするフラグの 1 つで開始したセッションから `bypassPermissions` に入ることはできません。有効にするために再起動します。

```bash theme={null}
claude --permission-mode bypassPermissions
```

`--dangerously-skip-permissions` フラグは同等です。

<Warning>
  `bypassPermissions` はプロンプトインジェクションまたは意図しないアクションに対する保護を提供しません。プロンプトなしで背景安全チェックの場合、代わりに [自動モード](#eliminate-prompts-with-auto-mode)を使用してください。管理者は [管理設定](/ja/permissions#managed-settings) で `permissions.disableBypassPermissionsMode` を `"disable"` に設定することでこのモードをブロックできます。
</Warning>

## 保護されたパス

パスの小さなセットへの書き込みはすべてのモードで自動承認されることはありません。これはリポジトリ状態と Claude 独自の設定の偶発的な破損を防ぎます。`default`、`acceptEdits`、`plan`、`bypassPermissions` ではこれらの書き込みはプロンプトが表示されます。`auto` では分類器にルーティングされます。`dontAsk` では拒否されます。

保護されたディレクトリ：

* `.git`
* `.vscode`
* `.idea`
* `.husky`
* `.claude`。ただし `.claude/commands`、`.claude/agents`、`.claude/skills`、`.claude/worktrees` は除く。Claude はこれらで定期的にコンテンツを作成します

保護されたファイル：

* `.gitconfig`、`.gitmodules`
* `.bashrc`、`.bash_profile`、`.zshrc`、`.zprofile`、`.profile`
* `.ripgreprc`
* `.mcp.json`、`.claude.json`

## 関連項目

* [Permissions](/ja/permissions)：allow、ask、deny ルール。管理ポリシー
* [Configure auto mode](/ja/auto-mode-config)：分類器に組織が信頼するインフラストラクチャを伝える
* [Hooks](/ja/hooks)：`PreToolUse` および `PermissionRequest` フック経由のカスタムパーミッションロジック
* [Ultraplan](/ja/ultraplan)：ブラウザベースのレビュー付き Claude Code on the web セッションで計画モードを実行
* [Security](/ja/security)：セキュリティ保護とベストプラクティス
* [Sandboxing](/ja/sandboxing)：Bash コマンドのファイルシステムとネットワーク隔離
* [Non-interactive mode](/ja/headless)：`-p` フラグで Claude Code を実行
