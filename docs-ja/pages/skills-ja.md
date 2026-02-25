> ## Documentation Index
> Fetch the complete documentation index at: https://code.claude.com/docs/llms.txt
> Use this file to discover all available pages before exploring further.

# スキルで Claude を拡張する

> Claude Code でスキルを作成、管理、共有して Claude の機能を拡張します。カスタムスラッシュコマンドを含みます。

スキルは Claude ができることを拡張します。`SKILL.md` ファイルに指示を記述すると、Claude がそれをツールキットに追加します。Claude は関連する場合にスキルを使用するか、`/skill-name` で直接呼び出すことができます。

<Note>
  `/help` や `/compact` などの組み込みコマンドについては、[インタラクティブモード](/ja/interactive-mode#built-in-commands)を参照してください。

  **カスタムスラッシュコマンドはスキルにマージされました。** `.claude/commands/review.md` のファイルと `.claude/skills/review/SKILL.md` のスキルの両方が `/review` を作成し、同じように機能します。既存の `.claude/commands/` ファイルは引き続き機能します。スキルはオプション機能を追加します。サポートファイル用のディレクトリ、[スキルを呼び出すユーザーを制御する](#control-who-invokes-a-skill)ためのフロントマター、および Claude が関連する場合に自動的にスキルを読み込む機能です。
</Note>

Claude Code スキルは [Agent Skills](https://agentskills.io) オープン標準に従い、複数の AI ツール全体で機能します。Claude Code は [呼び出し制御](#control-who-invokes-a-skill)、[subagent 実行](#run-skills-in-a-subagent)、[動的コンテキスト注入](#inject-dynamic-context)などの追加機能でこの標準を拡張します。

## はじめに

### 最初のスキルを作成する

この例は、Claude にビジュアルダイアグラムと類推を使用してコードを説明するように教えるスキルを作成します。デフォルトのフロントマターを使用するため、何かの仕組みを尋ねるときに Claude が自動的にスキルを読み込むか、`/explain-code` で直接呼び出すことができます。

<Steps>
  <Step title="スキルディレクトリを作成する">
    個人用スキルフォルダにスキル用のディレクトリを作成します。個人用スキルはすべてのプロジェクト全体で利用可能です。

    ```bash  theme={null}
    mkdir -p ~/.claude/skills/explain-code
    ```
  </Step>

  <Step title="SKILL.md を記述する">
    すべてのスキルには `SKILL.md` ファイルが必要です。このファイルには 2 つの部分があります。YAML フロントマター（`---` マーカー間）は Claude にスキルをいつ使用するかを伝え、マークダウンコンテンツはスキルが呼び出されたときに Claude が従う指示です。`name` フィールドは `/slash-command` になり、`description` は Claude がスキルを自動的に読み込むかどうかを決定するのに役立ちます。

    `~/.claude/skills/explain-code/SKILL.md` を作成します。

    ```yaml  theme={null}
    ---
    name: explain-code
    description: ビジュアルダイアグラムと類推を使用してコードを説明します。コードの仕組みを説明する場合、コードベースについて教える場合、またはユーザーが「これはどのように機能しますか？」と尋ねる場合に使用します。
    ---

    コードを説明するときは、常に以下を含めてください。

    1. **類推から始める**：コードを日常生活の何かと比較する
    2. **ダイアグラムを描く**：ASCII アートを使用してフロー、構造、または関係を示す
    3. **コードをステップスルーする**：何が起こるかをステップバイステップで説明する
    4. **落とし穴をハイライトする**：一般的な間違いや誤解は何ですか？

    説明は会話的に保ちます。複雑な概念については、複数の類推を使用します。
    ```
  </Step>

  <Step title="スキルをテストする">
    2 つの方法でテストできます。

    **説明に一致する何かを尋ねることで Claude に自動的に呼び出させる**：

    ```
    このコードはどのように機能しますか？
    ```

    **またはスキル名で直接呼び出す**：

    ```
    /explain-code src/auth/login.ts
    ```

    どちらの方法でも、Claude の説明に類推と ASCII ダイアグラムが含まれるはずです。
  </Step>
</Steps>

### スキルが存在する場所

スキルを保存する場所によって、誰がそれを使用できるかが決まります。

| 場所         | パス                                       | 適用対象         |
| :--------- | :--------------------------------------- | :----------- |
| Enterprise | [管理設定](/ja/settings#settings-files)を参照   | 組織内のすべてのユーザー |
| Personal   | `~/.claude/skills/<skill-name>/SKILL.md` | すべてのプロジェクト   |
| Project    | `.claude/skills/<skill-name>/SKILL.md`   | このプロジェクトのみ   |
| Plugin     | `<plugin>/skills/<skill-name>/SKILL.md`  | プラグインが有効な場所  |

スキルがレベル全体で同じ名前を共有する場合、優先度の高い場所が優先されます。enterprise > personal > project。プラグインスキルは `plugin-name:skill-name` 名前空間を使用するため、他のレベルと競合することはできません。`.claude/commands/` にファイルがある場合、それらは同じように機能しますが、スキルとコマンドが同じ名前を共有する場合、スキルが優先されます。

#### ネストされたディレクトリからの自動検出

サブディレクトリ内のファイルを操作する場合、Claude Code はネストされた `.claude/skills/` ディレクトリからスキルを自動的に検出します。たとえば、`packages/frontend/` 内のファイルを編集している場合、Claude Code は `packages/frontend/.claude/skills/` でもスキルを探します。これはパッケージが独自のスキルを持つ monorepo セットアップをサポートします。

各スキルは `SKILL.md` をエントリポイントとするディレクトリです。

```
my-skill/
├── SKILL.md           # メイン指示（必須）
├── template.md        # Claude が入力するテンプレート
├── examples/
│   └── sample.md      # 期待される形式を示すサンプル出力
└── scripts/
    └── validate.sh    # Claude が実行できるスクリプト
```

`SKILL.md` はメイン指示を含み、必須です。他のファイルはオプションで、より強力なスキルを構築できます。Claude が入力するテンプレート、期待される形式を示すサンプル出力、Claude が実行できるスクリプト、または詳細なリファレンスドキュメント。`SKILL.md` からこれらのファイルを参照して、Claude がそれらの内容と読み込むタイミングを知るようにします。詳細については、[サポートファイルを追加する](#add-supporting-files)を参照してください。

<Note>
  `.claude/commands/` 内のファイルは引き続き機能し、同じ[フロントマター](#frontmatter-reference)をサポートします。スキルはサポートファイルなどの追加機能をサポートするため、推奨されます。
</Note>

#### 追加ディレクトリからのスキル

`--add-dir` 経由で追加されたディレクトリ内の `.claude/skills/` で定義されたスキルは自動的に読み込まれ、ライブ変更検出によって取得されるため、セッション中に再起動せずにそれらを編集できます。

<Note>
  `--add-dir` ディレクトリからの CLAUDE.md ファイルはデフォルトでは読み込まれません。それらを読み込むには、`CLAUDE_CODE_ADDITIONAL_DIRECTORIES_CLAUDE_MD=1` を設定します。[追加ディレクトリからメモリを読み込む](/ja/memory#load-memory-from-additional-directories)を参照してください。
</Note>

## スキルを設定する

スキルは `SKILL.md` の上部にある YAML フロントマターと、その後に続くマークダウンコンテンツを通じて設定されます。

### スキルコンテンツのタイプ

スキルファイルには任意の指示を含めることができますが、それらを呼び出す方法を考えることは、何を含めるかをガイドするのに役立ちます。

**リファレンスコンテンツ**は Claude が現在の作業に適用する知識を追加します。規約、パターン、スタイルガイド、ドメイン知識。このコンテンツはインラインで実行されるため、Claude は会話コンテキストと一緒にそれを使用できます。

```yaml  theme={null}
---
name: api-conventions
description: このコードベースの API 設計パターン
---

API エンドポイントを記述する場合：
- RESTful 命名規約を使用する
- 一貫したエラー形式を返す
- リクエスト検証を含める
```

**タスクコンテンツ**は Claude にデプロイメント、コミット、またはコード生成などの特定のアクション用のステップバイステップ指示を提供します。これらは多くの場合、Claude に決定させるのではなく `/skill-name` で直接呼び出したいアクションです。`disable-model-invocation: true` を追加して、Claude が自動的にトリガーするのを防ぎます。

```yaml  theme={null}
---
name: deploy
description: アプリケーションを本番環境にデプロイする
context: fork
disable-model-invocation: true
---

アプリケーションをデプロイします。
1. テストスイートを実行する
2. アプリケーションをビルドする
3. デプロイメントターゲットにプッシュする
```

`SKILL.md` には何でも含めることができますが、スキルを呼び出す方法（ユーザーが呼び出すか、Claude が呼び出すか、またはその両方）と実行場所（インラインまたは subagent）を考えることは、何を含めるかをガイドするのに役立ちます。複雑なスキルの場合、[サポートファイルを追加](#add-supporting-files)して、メインスキルを焦点を当てた状態に保つこともできます。

### フロントマターリファレンス

マークダウンコンテンツを超えて、`SKILL.md` ファイルの上部にある `---` マーカー間の YAML フロントマターフィールドを使用してスキルの動作を設定できます。

```yaml  theme={null}
---
name: my-skill
description: このスキルが何をするか
disable-model-invocation: true
allowed-tools: Read, Grep
---

スキル指示をここに記述...
```

すべてのフィールドはオプションです。Claude がスキルをいつ使用するかを知るために、`description` のみが推奨されます。

| フィールド                      | 必須  | 説明                                                                                                  |
| :------------------------- | :-- | :-------------------------------------------------------------------------------------------------- |
| `name`                     | いいえ | スキルの表示名。省略した場合、ディレクトリ名を使用します。小文字、数字、ハイフンのみ（最大 64 文字）。                                               |
| `description`              | 推奨  | スキルが何をするか、いつ使用するか。Claude はこれを使用してスキルを適用するかどうかを決定します。省略した場合、マークダウンコンテンツの最初の段落を使用します。                 |
| `argument-hint`            | いいえ | オートコンプリート中に表示されるヒント。期待される引数を示します。例：`[issue-number]` または `[filename] [format]`。                      |
| `disable-model-invocation` | いいえ | Claude がこのスキルを自動的に読み込むのを防ぐには `true` に設定します。`/name` で手動でトリガーするワークフロー用です。デフォルト：`false`。               |
| `user-invocable`           | いいえ | `/` メニューから非表示にするには `false` に設定します。ユーザーが直接呼び出すべきではないバックグラウンド知識用です。デフォルト：`true`。                      |
| `allowed-tools`            | いいえ | このスキルがアクティブな場合、Claude が許可を求めずに使用できるツール。                                                             |
| `model`                    | いいえ | このスキルがアクティブな場合に使用するモデル。                                                                             |
| `context`                  | いいえ | フォークされた subagent コンテキストで実行するには `fork` に設定します。                                                       |
| `agent`                    | いいえ | `context: fork` が設定されている場合に使用する subagent タイプ。                                                       |
| `hooks`                    | いいえ | このスキルのライフサイクルにスコープされたフック。設定形式については、[スキルとエージェントのフック](/ja/hooks#hooks-in-skills-and-agents)を参照してください。 |

#### 利用可能な文字列置換

スキルはスキルコンテンツ内の動的値の文字列置換をサポートします。

| 変数                     | 説明                                                                                    |
| :--------------------- | :------------------------------------------------------------------------------------ |
| `$ARGUMENTS`           | スキルを呼び出すときに渡されたすべての引数。`$ARGUMENTS` がコンテンツに存在しない場合、引数は `ARGUMENTS: <value>` として追加されます。 |
| `$ARGUMENTS[N]`        | 0 ベースのインデックスで特定の引数にアクセスします。例：最初の引数の場合は `$ARGUMENTS[0]`。                               |
| `$N`                   | `$ARGUMENTS[N]` の短縮形。例：最初の引数の場合は `$0`、2 番目の引数の場合は `$1`。                               |
| `${CLAUDE_SESSION_ID}` | 現在のセッション ID。ログ、セッション固有のファイルの作成、またはスキル出力とセッションの相関に役立ちます。                               |

**置換を使用した例：**

```yaml  theme={null}
---
name: session-logger
description: このセッションのアクティビティをログに記録する
---

以下を logs/${CLAUDE_SESSION_ID}.log にログします。

$ARGUMENTS
```

### サポートファイルを追加する

スキルはディレクトリ内に複数のファイルを含めることができます。これにより、`SKILL.md` は本質的なものに焦点を当てたままで、Claude は必要な場合にのみ詳細なリファレンス資料にアクセスできます。大規模なリファレンスドキュメント、API 仕様、またはサンプルコレクションは、スキルが実行されるたびにコンテキストに読み込む必要はありません。

```
my-skill/
├── SKILL.md (必須 - 概要とナビゲーション)
├── reference.md (詳細な API ドキュメント - 必要に応じて読み込まれる)
├── examples.md (使用例 - 必要に応じて読み込まれる)
└── scripts/
    └── helper.py (ユーティリティスクリプト - 実行される、読み込まれない)
```

`SKILL.md` からサポートファイルを参照して、Claude が各ファイルの内容と読み込むタイミングを知るようにします。

```markdown  theme={null}
## 追加リソース

- 完全な API 詳細については、[reference.md](reference.md) を参照してください。
- 使用例については、[examples.md](examples.md) を参照してください。
```

<Tip>`SKILL.md` を 500 行以下に保ちます。詳細なリファレンス資料を別のファイルに移動します。</Tip>

### スキルを呼び出すユーザーを制御する

デフォルトでは、ユーザーと Claude の両方がスキルを呼び出すことができます。`/skill-name` を入力して直接呼び出すことができ、Claude は会話に関連する場合に自動的にスキルを読み込むことができます。2 つのフロントマターフィールドでこれを制限できます。

* **`disable-model-invocation: true`**：ユーザーのみがスキルを呼び出すことができます。`/commit`、`/deploy`、または `/send-slack-message` のような副作用のあるワークフロー、またはタイミングを制御したいワークフロー用です。コードが準備完了に見えるため Claude がデプロイすることを望みません。

* **`user-invocable: false`**：Claude のみがスキルを呼び出すことができます。古いシステムの仕組みを説明する `legacy-system-context` スキルのようなアクション不可能なバックグラウンド知識用です。Claude はこれが関連する場合に知るべきですが、`/legacy-system-context` はユーザーが取るべき意味のあるアクションではありません。

この例は、ユーザーのみがトリガーできるデプロイスキルを作成します。`disable-model-invocation: true` フィールドは Claude が自動的に実行するのを防ぎます。

```yaml  theme={null}
---
name: deploy
description: アプリケーションを本番環境にデプロイする
disable-model-invocation: true
---

$ARGUMENTS を本番環境にデプロイします。

1. テストスイートを実行する
2. アプリケーションをビルドする
3. デプロイメントターゲットにプッシュする
4. デプロイメントが成功したことを確認する
```

2 つのフィールドが呼び出しとコンテキスト読み込みにどのように影響するかは次のとおりです。

| フロントマター                          | ユーザーが呼び出せる | Claude が呼び出せる | コンテキストに読み込まれるタイミング                       |
| :------------------------------- | :--------- | :------------ | :--------------------------------------- |
| （デフォルト）                          | はい         | はい            | 説明は常にコンテキストに含まれ、呼び出されたときにフルスキルが読み込まれる    |
| `disable-model-invocation: true` | はい         | いいえ           | 説明はコンテキストに含まれず、ユーザーが呼び出したときにフルスキルが読み込まれる |
| `user-invocable: false`          | いいえ        | はい            | 説明は常にコンテキストに含まれ、呼び出されたときにフルスキルが読み込まれる    |

<Note>
  通常のセッションでは、スキル説明はコンテキストに読み込まれるため Claude は利用可能なものを知っていますが、フルスキルコンテンツは呼び出されたときにのみ読み込まれます。[事前読み込みされたスキルを持つ Subagent](/ja/sub-agents#preload-skills-into-subagents)は異なります。フルスキルコンテンツはスタートアップ時に注入されます。
</Note>

### ツールアクセスを制限する

`allowed-tools` フィールドを使用して、スキルがアクティブな場合に Claude が使用できるツールを制限します。このスキルは読み取り専用モードを作成します。Claude はファイルを探索できますが、変更することはできません。

```yaml  theme={null}
---
name: safe-reader
description: 変更を加えずにファイルを読む
allowed-tools: Read, Grep, Glob
---
```

### スキルに引数を渡す

ユーザーと Claude の両方がスキルを呼び出すときに引数を渡すことができます。引数は `$ARGUMENTS` プレースホルダーを通じて利用可能です。

このスキルは GitHub の問題を番号で修正します。`$ARGUMENTS` プレースホルダーはスキル名の後に続くものに置き換えられます。

```yaml  theme={null}
---
name: fix-issue
description: GitHub の問題を修正する
disable-model-invocation: true
---

GitHub の問題 $ARGUMENTS をコーディング標準に従って修正します。

1. 問題の説明を読む
2. 要件を理解する
3. 修正を実装する
4. テストを記述する
5. コミットを作成する
```

`/fix-issue 123` を実行すると、Claude は'GitHub の問題 123 をコーディング標準に従って修正します...'を受け取ります。

引数を使用してスキルを呼び出しても、スキルに `$ARGUMENTS` が含まれていない場合、Claude Code はスキルコンテンツの最後に `ARGUMENTS: <your input>` を追加するため、Claude は入力したものを引き続き見ることができます。

位置で個別の引数にアクセスするには、`$ARGUMENTS[N]` または短い `$N` を使用します。

```yaml  theme={null}
---
name: migrate-component
description: コンポーネントをあるフレームワークから別のフレームワークに移行する
---

$ARGUMENTS[0] コンポーネントを $ARGUMENTS[1] から $ARGUMENTS[2] に移行します。
既存のすべての動作とテストを保持します。
```

`/migrate-component SearchBar React Vue` を実行すると、`$ARGUMENTS[0]` が `SearchBar` に、`$ARGUMENTS[1]` が `React` に、`$ARGUMENTS[2]` が `Vue` に置き換えられます。`$N` 短縮形を使用する同じスキル。

```yaml  theme={null}
---
name: migrate-component
description: コンポーネントをあるフレームワークから別のフレームワークに移行する
---

$0 コンポーネントを $1 から $2 に移行します。
既存のすべての動作とテストを保持します。
```

## 高度なパターン

### 動的コンテキストを注入する

`` !`command`` \`\` 構文はスキルコンテンツが Claude に送信される前にシェルコマンドを実行します。コマンド出力はプレースホルダーを置き換えるため、Claude はコマンド自体ではなく実際のデータを受け取ります。

このスキルは GitHub CLI でライブ PR データを取得することで pull request を要約します。`` !`gh pr diff`` \`\` およびその他のコマンドが最初に実行され、その出力がプロンプトに挿入されます。

```yaml  theme={null}
---
name: pr-summary
description: pull request の変更を要約する
context: fork
agent: Explore
allowed-tools: Bash(gh *)
---

## Pull request コンテキスト
- PR diff：!`gh pr diff`
- PR コメント：!`gh pr view --comments`
- 変更されたファイル：!`gh pr diff --name-only`

## タスク
この pull request を要約します...
```

このスキルが実行されるとき：

1. 各 `` !`command`` \`\` が直ちに実行されます（Claude が何かを見る前に）
2. 出力はスキルコンテンツ内のプレースホルダーを置き換えます
3. Claude は実際の PR データを含む完全にレンダリングされたプロンプトを受け取ります

これは前処理であり、Claude が実行するものではありません。Claude は最終結果のみを見ます。

<Tip>
  スキルで[拡張思考](/ja/common-workflows#use-extended-thinking-thinking-mode)を有効にするには、スキルコンテンツのどこかに'ultrathink'という単語を含めます。
</Tip>

### スキルを subagent で実行する

スキルを分離して実行したい場合、フロントマターに `context: fork` を追加します。スキルコンテンツは subagent を駆動するプロンプトになります。会話履歴にアクセスできません。

<Warning>
  `context: fork` は明示的な指示を含むスキルにのみ意味があります。スキルに'これらの API 規約を使用する'などのガイドラインが含まれていても、タスクがない場合、subagent はガイドラインを受け取りますが、実行可能なプロンプトがなく、意味のある出力なしで返されます。
</Warning>

スキルと [subagent](/ja/sub-agents) は 2 つの方向で連携します。

| アプローチ                      | システムプロンプト                        | タスク             | また読み込む                   |
| :------------------------- | :------------------------------- | :-------------- | :----------------------- |
| `context: fork` を持つスキル     | エージェントタイプから（`Explore`、`Plan` など） | SKILL.md コンテンツ  | CLAUDE.md                |
| `skills` フィールドを持つ Subagent | Subagent のマークダウン本体               | Claude の委任メッセージ | 事前読み込みされたスキル + CLAUDE.md |

`context: fork` を使用すると、スキルにタスクを記述し、実行するエージェントタイプを選択します。逆の場合（スキルをリファレンス資料として使用するカスタム subagent を定義する）については、[Subagent](/ja/sub-agents#preload-skills-into-subagents)を参照してください。

#### 例：Explore エージェントを使用した研究スキル

このスキルはフォークされた Explore エージェントで研究を実行します。スキルコンテンツはタスクになり、エージェントはコードベース探索に最適化された読み取り専用ツールを提供します。

```yaml  theme={null}
---
name: deep-research
description: トピックを徹底的に研究する
context: fork
agent: Explore
---

$ARGUMENTS を徹底的に研究します。

1. Glob と Grep を使用して関連ファイルを見つける
2. コードを読んで分析する
3. 特定のファイル参照を含む結果を要約する
```

このスキルが実行されるとき：

1. 新しい分離されたコンテキストが作成されます
2. Subagent はスキルコンテンツをプロンプト（'\$ARGUMENTS を徹底的に研究します...'）として受け取ります
3. `agent` フィールドは実行環境（モデル、ツール、権限）を決定します
4. 結果は要約され、メイン会話に返されます

`agent` フィールドは使用する subagent 設定を指定します。オプションには組み込みエージェント（`Explore`、`Plan`、`general-purpose`）または `.claude/agents/` からのカスタム subagent が含まれます。省略した場合、`general-purpose` を使用します。

### Claude のスキルアクセスを制限する

デフォルトでは、Claude は `disable-model-invocation: true` が設定されていないスキルを呼び出すことができます。`allowed-tools` を定義するスキルは、スキルがアクティブな場合、ユーザーごとの承認なしにこれらのツールへのアクセスを Claude に付与します。[権限設定](/ja/permissions)は引き続き、他のすべてのツールのベースライン承認動作を管理します。`/compact` や `/init` などの組み込みコマンドはスキルツールを通じて利用できません。

Claude が呼び出すことができるスキルを制御する 3 つの方法。

**`/permissions` でスキルツールを拒否することで、すべてのスキルを無効にする**：

```
# 拒否ルールに追加：
Skill
```

**[権限ルール](/ja/permissions)を使用して特定のスキルを許可または拒否する**：

```
# 特定のスキルのみを許可
Skill(commit)
Skill(review-pr *)

# 特定のスキルを拒否
Skill(deploy *)
```

権限構文：正確一致の場合は `Skill(name)`、任意の引数を含むプレフィックス一致の場合は `Skill(name *)`。

**個別のスキルを非表示にする**。フロントマターに `disable-model-invocation: true` を追加します。これにより、スキルが Claude のコンテキストから完全に削除されます。

<Note>
  `user-invocable` フィールドはメニュー表示のみを制御し、スキルツールアクセスは制御しません。プログラム的な呼び出しをブロックするには `disable-model-invocation: true` を使用します。
</Note>

## スキルを共有する

スキルはオーディエンスに応じて異なるスコープで配布できます。

* **プロジェクトスキル**：`.claude/skills/` をバージョン管理にコミットする
* **プラグイン**：[プラグイン](/ja/plugins)に `skills/` ディレクトリを作成する
* **管理**：[管理設定](/ja/settings#settings-files)を通じて組織全体にデプロイする

### ビジュアル出力を生成する

スキルは任意の言語でスクリプトをバンドルして実行でき、Claude に単一のプロンプトで可能なもの以上の機能を提供します。1 つの強力なパターンはビジュアル出力を生成することです。データの探索、デバッグ、またはレポート作成用にブラウザで開くインタラクティブな HTML ファイル。

この例はコードベースエクスプローラーを作成します。ディレクトリを展開および折りたたむことができるインタラクティブなツリービュー。一目でファイルサイズを確認でき、ファイルタイプを色で識別できます。

スキルディレクトリを作成します。

```bash  theme={null}
mkdir -p ~/.claude/skills/codebase-visualizer/scripts
```

`~/.claude/skills/codebase-visualizer/SKILL.md` を作成します。説明は Claude にこのスキルをいつアクティブにするかを伝え、指示は Claude にバンドルされたスクリプトを実行するよう伝えます。

````yaml  theme={null}
---
name: codebase-visualizer
description: コードベースのインタラクティブな折りたたみ可能なツリービジュアライゼーションを生成します。新しいリポジトリを探索する場合、プロジェクト構造を理解する場合、または大きなファイルを識別する場合に使用します。
allowed-tools: Bash(python *)
---

# コードベースビジュアライザー

プロジェクトのファイル構造を折りたたみ可能なディレクトリで示すインタラクティブな HTML ツリービューを生成します。

## 使用方法

プロジェクトルートからビジュアライゼーションスクリプトを実行します。

```bash
python ~/.claude/skills/codebase-visualizer/scripts/visualize.py .
```

これにより、現在のディレクトリに `codebase-map.html` が作成され、デフォルトブラウザで開きます。

## ビジュアライゼーションが表示するもの

- **折りたたみ可能なディレクトリ**：フォルダをクリックして展開/折りたたむ
- **ファイルサイズ**：各ファイルの横に表示
- **色**：異なるファイルタイプに異なる色
- **ディレクトリ合計**：各フォルダの集計サイズを表示
````

`~/.claude/skills/codebase-visualizer/scripts/visualize.py` を作成します。このスクリプトはディレクトリツリーをスキャンし、以下を含む自己完結型の HTML ファイルを生成します。

* ファイル数、ディレクトリ数、合計サイズ、ファイルタイプ数を示す**サマリーサイドバー**
* ファイルタイプ別（サイズ上位 8 つ）のコードベースを分類する**棒グラフ**
* ディレクトリを展開および折りたたむことができる**折りたたみ可能なツリー**。色分けされたファイルタイプインジケーター付き

スクリプトは Python が必要ですが、組み込みライブラリのみを使用するため、インストールするパッケージはありません。

```python expandable theme={null}
#!/usr/bin/env python3
"""コードベースのインタラクティブな折りたたみ可能なツリービジュアライゼーションを生成します。"""

import json
import sys
import webbrowser
from pathlib import Path
from collections import Counter

IGNORE = {'.git', 'node_modules', '__pycache__', '.venv', 'venv', 'dist', 'build'}

def scan(path: Path, stats: dict) -> dict:
    result = {"name": path.name, "children": [], "size": 0}
    try:
        for item in sorted(path.iterdir()):
            if item.name in IGNORE or item.name.startswith('.'):
                continue
            if item.is_file():
                size = item.stat().st_size
                ext = item.suffix.lower() or '(no ext)'
                result["children"].append({"name": item.name, "size": size, "ext": ext})
                result["size"] += size
                stats["files"] += 1
                stats["extensions"][ext] += 1
                stats["ext_sizes"][ext] += size
            elif item.is_dir():
                stats["dirs"] += 1
                child = scan(item, stats)
                if child["children"]:
                    result["children"].append(child)
                    result["size"] += child["size"]
    except PermissionError:
        pass
    return result

def generate_html(data: dict, stats: dict, output: Path) -> None:
    ext_sizes = stats["ext_sizes"]
    total_size = sum(ext_sizes.values()) or 1
    sorted_exts = sorted(ext_sizes.items(), key=lambda x: -x[1])[:8]
    colors = {
        '.js': '#f7df1e', '.ts': '#3178c6', '.py': '#3776ab', '.go': '#00add8',
        '.rs': '#dea584', '.rb': '#cc342d', '.css': '#264de4', '.html': '#e34c26',
        '.json': '#6b7280', '.md': '#083fa1', '.yaml': '#cb171e', '.yml': '#cb171e',
        '.mdx': '#083fa1', '.tsx': '#3178c6', '.jsx': '#61dafb', '.sh': '#4eaa25',
    }
    lang_bars = "".join(
        f'<div class="bar-row"><span class="bar-label">{ext}</span>'
        f'<div class="bar" style="width:{(size/total_size)*100}%;background:{colors.get(ext,"#6b7280")}"></div>'
        f'<span class="bar-pct">{(size/total_size)*100:.1f}%</span></div>'
        for ext, size in sorted_exts
    )
    def fmt(b):
        if b < 1024: return f"{b} B"
        if b < 1048576: return f"{b/1024:.1f} KB"
        return f"{b/1048576:.1f} MB"

    html = f'''<!DOCTYPE html>
<html><head>
  <meta charset="utf-8"><title>Codebase Explorer</title>
  <style>
    body {{ font: 14px/1.5 system-ui, sans-serif; margin: 0; background: #1a1a2e; color: #eee; }}
    .container {{ display: flex; height: 100vh; }}
    .sidebar {{ width: 280px; background: #252542; padding: 20px; border-right: 1px solid #3d3d5c; overflow-y: auto; flex-shrink: 0; }}
    .main {{ flex: 1; padding: 20px; overflow-y: auto; }}
    h1 {{ margin: 0 0 10px 0; font-size: 18px; }}
    h2 {{ margin: 20px 0 10px 0; font-size: 14px; color: #888; text-transform: uppercase; }}
    .stat {{ display: flex; justify-content: space-between; padding: 8px 0; border-bottom: 1px solid #3d3d5c; }}
    .stat-value {{ font-weight: bold; }}
    .bar-row {{ display: flex; align-items: center; margin: 6px 0; }}
    .bar-label {{ width: 55px; font-size: 12px; color: #aaa; }}
    .bar {{ height: 18px; border-radius: 3px; }}
    .bar-pct {{ margin-left: 8px; font-size: 12px; color: #666; }}
    .tree {{ list-style: none; padding-left: 20px; }}
    details {{ cursor: pointer; }}
    summary {{ padding: 4px 8px; border-radius: 4px; }}
    summary:hover {{ background: #2d2d44; }}
    .folder {{ color: #ffd700; }}
    .file {{ display: flex; align-items: center; padding: 4px 8px; border-radius: 4px; }}
    .file:hover {{ background: #2d2d44; }}
    .size {{ color: #888; margin-left: auto; font-size: 12px; }}
    .dot {{ width: 8px; height: 8px; border-radius: 50%; margin-right: 8px; }}
  </style>
</head><body>
  <div class="container">
    <div class="sidebar">
      <h1>📊 Summary</h1>
      <div class="stat"><span>Files</span><span class="stat-value">{stats["files"]:,}</span></div>
      <div class="stat"><span>Directories</span><span class="stat-value">{stats["dirs"]:,}</span></div>
      <div class="stat"><span>Total size</span><span class="stat-value">{fmt(data["size"])}</span></div>
      <div class="stat"><span>File types</span><span class="stat-value">{len(stats["extensions"])}</span></div>
      <h2>By file type</h2>
      {lang_bars}
    </div>
    <div class="main">
      <h1>📁 {data["name"]}</h1>
      <ul class="tree" id="root"></ul>
    </div>
  </div>
  <script>
    const data = {json.dumps(data)};
    const colors = {json.dumps(colors)};
    function fmt(b) {{ if (b < 1024) return b + ' B'; if (b < 1048576) return (b/1024).toFixed(1) + ' KB'; return (b/1048576).toFixed(1) + ' MB'; }}
    function render(node, parent) {{
      if (node.children) {{
        const det = document.createElement('details');
        det.open = parent === document.getElementById('root');
        det.innerHTML = `<summary><span class="folder">📁 ${{node.name}}</span><span class="size">${{fmt(node.size)}}</span></summary>`;
        const ul = document.createElement('ul'); ul.className = 'tree';
        node.children.sort((a,b) => (b.children?1:0)-(a.children?1:0) || a.name.localeCompare(b.name));
        node.children.forEach(c => render(c, ul));
        det.appendChild(ul);
        const li = document.createElement('li'); li.appendChild(det); parent.appendChild(li);
      }} else {{
        const li = document.createElement('li'); li.className = 'file';
        li.innerHTML = `<span class="dot" style="background:${{colors[node.ext]||'#6b7280'}}"></span>${{node.name}}<span class="size">${{fmt(node.size)}}</span>`;
        parent.appendChild(li);
      }}
    }}
    data.children.forEach(c => render(c, document.getElementById('root')));
  </script>
</body></html>'''
    output.write_text(html)

if __name__ == '__main__':
    target = Path(sys.argv[1] if len(sys.argv) > 1 else '.').resolve()
    stats = {"files": 0, "dirs": 0, "extensions": Counter(), "ext_sizes": Counter()}
    data = scan(target, stats)
    out = Path('codebase-map.html')
    generate_html(data, stats, out)
    print(f'Generated {out.absolute()}')
    webbrowser.open(f'file://{out.absolute()}')
```

テストするには、任意のプロジェクトで Claude Code を開き、「このコードベースを可視化します」と尋ねます。Claude はスクリプトを実行し、`codebase-map.html` を生成し、ブラウザで開きます。

このパターンは任意のビジュアル出力に機能します。依存関係グラフ、テストカバレッジレポート、API ドキュメント、またはデータベーススキーマビジュアライゼーション。バンドルされたスクリプトが重い処理を行い、Claude がオーケストレーションを処理します。

## トラブルシューティング

### スキルがトリガーされない

Claude が期待どおりにスキルを使用しない場合：

1. 説明にユーザーが自然に言うキーワードが含まれていることを確認します
2. スキルが「どのスキルが利用可能ですか？」に表示されることを確認します
3. 説明により密接に一致するようにリクエストを言い換えてみます
4. スキルがユーザー呼び出し可能な場合は、`/skill-name` で直接呼び出してみます

### スキルが頻繁にトリガーされる

Claude がスキルを望まないときに使用する場合：

1. 説明をより具体的にします
2. ユーザーのみが手動で呼び出したい場合は `disable-model-invocation: true` を追加します

### Claude がすべてのスキルを見ない

スキル説明はコンテキストに読み込まれるため、Claude は利用可能なものを知っています。多くのスキルがある場合、文字予算を超える可能性があります。予算はコンテキストウィンドウの 2% で動的にスケーリングされ、16,000 文字のフォールバックがあります。`/context` を実行して、除外されたスキルに関する警告を確認します。

制限をオーバーライドするには、`SLASH_COMMAND_TOOL_CHAR_BUDGET` 環境変数を設定します。

## 関連リソース

* **[Subagent](/ja/sub-agents)**：特化したエージェントにタスクを委任する
* **[プラグイン](/ja/plugins)**：他の拡張機能を使用してスキルをパッケージ化して配布する
* **[フック](/ja/hooks)**：ツールイベント周辺のワークフローを自動化する
* **[メモリ](/ja/memory)**：永続的なコンテキスト用に CLAUDE.md ファイルを管理する
* **[インタラクティブモード](/ja/interactive-mode#built-in-commands)**：組み込みコマンドとショートカット
* **[権限](/ja/permissions)**：ツールとスキルアクセスを制御する
