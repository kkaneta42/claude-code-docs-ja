> ## Documentation Index
> Fetch the complete documentation index at: https://code.claude.com/docs/llms.txt
> Use this file to discover all available pages before exploring further.

# 一般的なワークフロー

> Claude Code でコードベースの探索、バグ修正、リファクタリング、テスト、その他の日常的なタスクを行うためのステップバイステップガイド。

このページでは、日常的な開発のための実践的なワークフローについて説明します。コードベースの探索、デバッグ、リファクタリング、テストの作成、PR の作成、セッション管理などです。各セクションには、自分のプロジェクトに適応できるプロンプトの例が含まれています。より高度なパターンとヒントについては、[ベストプラクティス](/ja/best-practices)を参照してください。

## 新しいコードベースを理解する

### コードベースの概要を素早く取得する

新しいプロジェクトに参加したばかりで、その構造を素早く理解する必要があるとします。

<Steps>
  <Step title="プロジェクトルートディレクトリに移動する">
    ```bash  theme={null}
    cd /path/to/project 
    ```
  </Step>

  <Step title="Claude Code を起動する">
    ```bash  theme={null}
    claude 
    ```
  </Step>

  <Step title="高レベルの概要をリクエストする">
    ```
    > give me an overview of this codebase 
    ```
  </Step>

  <Step title="特定のコンポーネントについてさらに詳しく調べる">
    ```
    > explain the main architecture patterns used here 
    ```

    ```
    > what are the key data models?
    ```

    ```
    > how is authentication handled?
    ```
  </Step>
</Steps>

<Tip>
  ヒント：

  * 広い質問から始めて、特定の領域に絞り込んでいく
  * プロジェクトで使用されているコーディング規約とパターンについて質問する
  * プロジェクト固有の用語の用語集をリクエストする
</Tip>

### 関連するコードを見つける

特定の機能または機能に関連するコードを見つける必要があるとします。

<Steps>
  <Step title="Claude に関連ファイルを見つけるよう依頼する">
    ```
    > find the files that handle user authentication 
    ```
  </Step>

  <Step title="コンポーネントがどのように相互作用するかについてのコンテキストを取得する">
    ```
    > how do these authentication files work together? 
    ```
  </Step>

  <Step title="実行フローを理解する">
    ```
    > trace the login process from front-end to database 
    ```
  </Step>
</Steps>

<Tip>
  ヒント：

  * 探しているものについて具体的に説明する
  * プロジェクトのドメイン言語を使用する
  * 言語用の[コード インテリジェンス プラグイン](/ja/discover-plugins#code-intelligence)をインストールして、Claude に正確な'定義に移動'と'参照を検索'ナビゲーションを提供する
</Tip>

***

## バグを効率的に修正する

エラーメッセージが表示され、その原因を見つけて修正する必要があるとします。

<Steps>
  <Step title="エラーを Claude と共有する">
    ```
    > I'm seeing an error when I run npm test 
    ```
  </Step>

  <Step title="修正の推奨事項をリクエストする">
    ```
    > suggest a few ways to fix the @ts-ignore in user.ts 
    ```
  </Step>

  <Step title="修正を適用する">
    ```
    > update user.ts to add the null check you suggested 
    ```
  </Step>
</Steps>

<Tip>
  ヒント：

  * Claude に問題を再現するコマンドとスタックトレースを伝える
  * エラーを再現するための手順を記載する
  * エラーが断続的か一貫しているかを Claude に知らせる
</Tip>

***

## コードをリファクタリングする

古いコードを最新のパターンとプラクティスを使用するように更新する必要があるとします。

<Steps>
  <Step title="リファクタリング対象のレガシーコードを特定する">
    ```
    > find deprecated API usage in our codebase 
    ```
  </Step>

  <Step title="リファクタリングの推奨事項を取得する">
    ```
    > suggest how to refactor utils.js to use modern JavaScript features 
    ```
  </Step>

  <Step title="変更を安全に適用する">
    ```
    > refactor utils.js to use ES2024 features while maintaining the same behavior 
    ```
  </Step>

  <Step title="リファクタリングを検証する">
    ```
    > run tests for the refactored code 
    ```
  </Step>
</Steps>

<Tip>
  ヒント：

  * Claude に最新のアプローチの利点を説明するよう依頼する
  * 必要に応じて、変更が後方互換性を維持することをリクエストする
  * リファクタリングを小さくテスト可能な増分で実行する
</Tip>

***

## 特殊な subagents を使用する

特定のタスクをより効果的に処理するために、特殊な AI subagents を使用したいとします。

<Steps>
  <Step title="利用可能な subagents を表示する">
    ```
    > /agents
    ```

    これにより、利用可能なすべての subagents が表示され、新しいものを作成できます。
  </Step>

  <Step title="subagents を自動的に使用する">
    Claude Code は、特殊な subagents に適切なタスクを自動的に委譲します：

    ```
    > review my recent code changes for security issues
    ```

    ```
    > run all tests and fix any failures
    ```
  </Step>

  <Step title="特定の subagents を明示的にリクエストする">
    ```
    > use the code-reviewer subagent to check the auth module
    ```

    ```
    > have the debugger subagent investigate why users can't log in
    ```
  </Step>

  <Step title="ワークフロー用のカスタム subagents を作成する">
    ```
    > /agents
    ```

    次に「Create New subagent」を選択し、プロンプトに従って以下を定義します：

    * subagent の目的を説明する一意の識別子（例：`code-reviewer`、`api-designer`）。
    * Claude がこのエージェントを使用する場合
    * アクセスできるツール
    * エージェントの役割と動作を説明するシステムプロンプト
  </Step>
</Steps>

<Tip>
  ヒント：

  * チーム共有用に `.claude/agents/` にプロジェクト固有の subagents を作成する
  * 自動委譲を有効にするために説明的な `description` フィールドを使用する
  * 各 subagent が実際に必要なツールへのアクセスを制限する
  * 詳細な例については、[subagents ドキュメント](/ja/sub-agents)を確認する
</Tip>

***

## Plan Mode を使用して安全なコード分析を行う

Plan Mode は Claude に読み取り専用操作でコードベースを分析することで計画を作成するよう指示します。これはコードベースの探索、複雑な変更の計画、またはコードの安全なレビューに最適です。Plan Mode では、Claude は [`AskUserQuestion`](/ja/settings#tools-available-to-claude) を使用して要件を収集し、計画を提案する前に目標を明確にします。

### Plan Mode を使用する場合

* **マルチステップ実装**：機能が多くのファイルへの編集を必要とする場合
* **コード探索**：何かを変更する前にコードベースを徹底的に調査したい場合
* **インタラクティブ開発**：Claude との方向性を反復したい場合

### Plan Mode の使用方法

**セッション中に Plan Mode をオンにする**

**Shift+Tab** を使用してセッション中に Plan Mode に切り替えることができます。

Normal Mode にいる場合、**Shift+Tab** は最初に Auto-Accept Mode に切り替わります。これはターミナルの下部に `⏵⏵ accept edits on` で示されます。その後の **Shift+Tab** は Plan Mode に切り替わります。これは `⏸ plan mode on` で示されます。

**Plan Mode で新しいセッションを開始する**

Plan Mode で新しいセッションを開始するには、`--permission-mode plan` フラグを使用します：

```bash  theme={null}
claude --permission-mode plan
```

**Plan Mode で「ヘッドレス」クエリを実行する**

`-p` を使用して Plan Mode でクエリを直接実行することもできます（つまり、[「ヘッドレスモード」](/ja/headless)で）：

```bash  theme={null}
claude --permission-mode plan -p "Analyze the authentication system and suggest improvements"
```

### 例：複雑なリファクタリングの計画

```bash  theme={null}
claude --permission-mode plan
```

```
> I need to refactor our authentication system to use OAuth2. Create a detailed migration plan.
```

Claude は現在の実装を分析し、包括的な計画を作成します。フォローアップで改善します：

```
> What about backward compatibility?
> How should we handle database migration?
```

<Tip>`Ctrl+G` を押して計画をデフォルトのテキストエディタで開き、Claude が続行する前に直接編集できます。</Tip>

### Plan Mode をデフォルトとして設定する

```json  theme={null}
// .claude/settings.json
{
  "permissions": {
    "defaultMode": "plan"
  }
}
```

詳細な設定オプションについては、[設定ドキュメント](/ja/settings#available-settings)を参照してください。

***

## テストを使用する

カバーされていないコードのテストを追加する必要があるとします。

<Steps>
  <Step title="テストされていないコードを特定する">
    ```
    > find functions in NotificationsService.swift that are not covered by tests 
    ```
  </Step>

  <Step title="テストスキャフォルディングを生成する">
    ```
    > add tests for the notification service 
    ```
  </Step>

  <Step title="意味のあるテストケースを追加する">
    ```
    > add test cases for edge conditions in the notification service 
    ```
  </Step>

  <Step title="テストを実行して検証する">
    ```
    > run the new tests and fix any failures 
    ```
  </Step>
</Steps>

Claude は、プロジェクトの既存のパターンと規約に従うテストを生成できます。テストをリクエストするときは、検証したい動作について具体的に説明してください。Claude は既存のテストファイルを調べて、既に使用されているスタイル、フレームワーク、アサーションパターンに一致させます。

包括的なカバレッジのために、Claude に見落とした可能性のあるエッジケースを特定するよう依頼してください。Claude はコードパスを分析し、エラー条件、境界値、見落としやすい予期しない入力のテストを提案できます。

***

## プルリクエストを作成する

Claude に直接依頼するか（「create a pr for my changes」）、`/commit-push-pr` skill を使用してプルリクエストを作成できます。これは 1 つのステップでコミット、プッシュ、PR を開きます。

```
> /commit-push-pr
```

Slack MCP サーバーが設定されており、CLAUDE.md でチャネルを指定している場合（例：「post PR URLs to #team-prs」）、skill は自動的に PR URL をそれらのチャネルに投稿します。

プロセスをより細かく制御するには、Claude をステップバイステップでガイドするか、[独自のスキルを作成](/ja/skills)してください：

<Steps>
  <Step title="変更内容をまとめる">
    ```
    > summarize the changes I've made to the authentication module
    ```
  </Step>

  <Step title="プルリクエストを生成する">
    ```
    > create a pr
    ```
  </Step>

  <Step title="レビューと改善">
    ```
    > enhance the PR description with more context about the security improvements
    ```
  </Step>
</Steps>

`gh pr create` を使用して PR を作成すると、セッションはその PR に自動的にリンクされます。後で `claude --from-pr <number>` で再開できます。

<Tip>
  Claude が生成した PR を送信する前にレビューし、Claude に潜在的なリスクまたは考慮事項を強調するよう依頼してください。
</Tip>

## ドキュメントを処理する

コードのドキュメントを追加または更新する必要があるとします。

<Steps>
  <Step title="ドキュメント化されていないコードを特定する">
    ```
    > find functions without proper JSDoc comments in the auth module 
    ```
  </Step>

  <Step title="ドキュメントを生成する">
    ```
    > add JSDoc comments to the undocumented functions in auth.js 
    ```
  </Step>

  <Step title="レビューと改善">
    ```
    > improve the generated documentation with more context and examples 
    ```
  </Step>

  <Step title="ドキュメントを検証する">
    ```
    > check if the documentation follows our project standards 
    ```
  </Step>
</Steps>

<Tip>
  ヒント：

  * 必要なドキュメント スタイルを指定する（JSDoc、docstrings など）
  * ドキュメントに例を含めるよう依頼する
  * パブリック API、インターフェース、複雑なロジックのドキュメントをリクエストする
</Tip>

***

## 画像を使用する

コードベースで画像を使用する必要があり、Claude の画像コンテンツ分析を支援してほしいとします。

<Steps>
  <Step title="会話に画像を追加する">
    次のいずれかの方法を使用できます：

    1. Claude Code ウィンドウに画像をドラッグアンドドロップする
    2. 画像をコピーして、ctrl+v を使用して CLI に貼り付ける（cmd+v は使用しないでください）
    3. Claude に画像パスを提供する。例：「Analyze this image: /path/to/your/image.png」
  </Step>

  <Step title="Claude に画像を分析するよう依頼する">
    ```
    > What does this image show?
    ```

    ```
    > Describe the UI elements in this screenshot
    ```

    ```
    > Are there any problematic elements in this diagram?
    ```
  </Step>

  <Step title="コンテキストに画像を使用する">
    ```
    > Here's a screenshot of the error. What's causing it?
    ```

    ```
    > This is our current database schema. How should we modify it for the new feature?
    ```
  </Step>

  <Step title="ビジュアルコンテンツからコード提案を取得する">
    ```
    > Generate CSS to match this design mockup
    ```

    ```
    > What HTML structure would recreate this component?
    ```
  </Step>
</Steps>

<Tip>
  ヒント：

  * テキスト説明が不明確または面倒な場合は画像を使用する
  * より良いコンテキストのために、エラー、UI デザイン、または図のスクリーンショットを含める
  * 会話で複数の画像を使用できます
  * 画像分析は図、スクリーンショット、モックアップなどで機能します
  * Claude が画像を参照する場合（例：`[Image #1]`）、`Cmd+Click`（Mac）または `Ctrl+Click`（Windows/Linux）リンクをクリックして、デフォルトビューアで画像を開きます
</Tip>

***

## ファイルとディレクトリを参照する

@ を使用して、Claude がファイルを読むのを待たずにファイルまたはディレクトリをすばやく含めます。

<Steps>
  <Step title="単一ファイルを参照する">
    ```
    > Explain the logic in @src/utils/auth.js
    ```

    これにより、ファイルの完全な内容が会話に含まれます。
  </Step>

  <Step title="ディレクトリを参照する">
    ```
    > What's the structure of @src/components?
    ```

    これにより、ファイル情報を含むディレクトリリストが提供されます。
  </Step>

  <Step title="MCP リソースを参照する">
    ```
    > Show me the data from @github:repos/owner/repo/issues
    ```

    これにより、@server:resource 形式を使用して接続された MCP サーバーからデータを取得します。詳細については、[MCP リソース](/ja/mcp#use-mcp-resources)を参照してください。
  </Step>
</Steps>

<Tip>
  ヒント：

  * ファイルパスは相対パスまたは絶対パスにできます
  * @ ファイル参照は、ファイルのディレクトリと親ディレクトリの `CLAUDE.md` をコンテキストに追加します
  * ディレクトリ参照はコンテンツではなくファイルリストを表示します
  * 単一のメッセージで複数のファイルを参照できます（例：「@file1.js and @file2.js」）
</Tip>

***

## 拡張思考（思考モード）を使用する

[拡張思考](https://platform.claude.com/docs/en/build-with-claude/extended-thinking)はデフォルトで有効になっており、出力トークン予算の一部（最大 31,999 トークン）を Claude が複雑な問題をステップバイステップで推論するために予約しています。この推論は詳細モードで表示されます。詳細モードは `Ctrl+O` で切り替えることができます。

拡張思考は、複雑なアーキテクチャの決定、難しいバグ、マルチステップの実装計画、異なるアプローチ間のトレードオフの評価に特に価値があります。複数のソリューションの探索、エッジケースの分析、間違いの自己修正のためのより多くのスペースを提供します。

<Note>
  「think」、「think hard」、「ultrathink」、「think more」などのフレーズは通常のプロンプト指示として解釈され、思考トークンを割り当てません。
</Note>

### 思考モードを設定する

思考はデフォルトで有効になっていますが、調整または無効にすることができます。

| スコープ            | 設定方法                                                                  | 詳細                                                                                           |
| --------------- | --------------------------------------------------------------------- | -------------------------------------------------------------------------------------------- |
| **トグルショートカット**  | `Option+T`（macOS）または `Alt+T`（Windows/Linux）を押す                        | 現在のセッションの思考をオン/オフに切り替えます。Option キーショートカットを有効にするには[ターミナル設定](/ja/terminal-config)が必要な場合があります   |
| **グローバルデフォルト**  | `/config` を使用して思考モードを切り替える                                            | すべてのプロジェクト全体でデフォルトを設定します。<br />`~/.claude/settings.json` に `alwaysThinkingEnabled` として保存されます |
| **トークン予算を制限する** | [`MAX_THINKING_TOKENS`](/ja/settings#environment-variables) 環境変数を設定する | 思考予算を特定のトークン数に制限します。例：`export MAX_THINKING_TOKENS=10000`                                     |

Claude の思考プロセスを表示するには、`Ctrl+O` を押して詳細モードを切り替え、内部推論をグレーのイタリック体のテキストとして表示します。

### 拡張思考トークン予算の仕組み

拡張思考は、Claude が応答する前に実行できる内部推論の量を制御する**トークン予算**を使用します。

より大きな思考トークン予算は以下を提供します：

* 複数のソリューション アプローチをステップバイステップで探索するためのより多くのスペース
* エッジケースを分析し、トレードオフを徹底的に評価するためのスペース
* 推論を修正し、間違いを自己修正する能力

思考モードのトークン予算：

* 思考が**有効**な場合、Claude は出力予算から最大**31,999 トークン**を内部推論に使用できます
* 思考が**無効**な場合（トグルまたは `/config` 経由）、Claude は思考に**0 トークン**を使用します

**思考予算を制限する：**

* [`MAX_THINKING_TOKENS` 環境変数](/ja/settings#environment-variables)を使用して思考予算をキャップします
* 設定すると、この値は Claude が思考に使用できる最大トークンを制限します
* 有効なトークン範囲については、[拡張思考ドキュメント](https://docs.claude.com/en/docs/build-with-claude/extended-thinking)を参照してください

<Warning>
  Claude 4 モデルが要約された思考を表示していても、使用されたすべての思考トークンに対して課金されます
</Warning>

***

## 以前の会話を再開する

Claude Code を起動するときは、以前のセッションを再開できます：

* `claude --continue` は現在のディレクトリで最新の会話を続行します
* `claude --resume` は会話ピッカーを開くか、名前で再開します
* `claude --from-pr 123` は特定のプルリクエストにリンクされたセッションを再開します

アクティブなセッション内から、`/resume` を使用して別の会話に切り替えます。

セッションはプロジェクト ディレクトリごとに保存されます。`/resume` ピッカーは、worktrees を含む同じ git リポジトリからのセッションを表示します。

### セッションに名前を付ける

セッションに説明的な名前を付けて、後で見つけやすくします。これは複数のタスクまたは機能に取り組むときのベストプラクティスです。

<Steps>
  <Step title="現在のセッションに名前を付ける">
    セッション中に `/rename` を使用して、覚えやすい名前を付けます：

    ```
    > /rename auth-refactor
    ```

    ピッカーから任意のセッションの名前を変更することもできます：`/resume` を実行し、セッションに移動して、`R` を押します。
  </Step>

  <Step title="後で名前で再開する">
    コマンドラインから：

    ```bash  theme={null}
    claude --resume auth-refactor
    ```

    またはアクティブなセッション内から：

    ```
    > /resume auth-refactor
    ```
  </Step>
</Steps>

### セッションピッカーを使用する

`/resume` コマンド（または引数なしの `claude --resume`）は、次の機能を備えたインタラクティブなセッションピッカーを開きます：

**ピッカーのキーボードショートカット：**

| ショートカット   | アクション                          |
| :-------- | :----------------------------- |
| `↑` / `↓` | セッション間を移動する                    |
| `→` / `←` | グループ化されたセッションを展開または折りたたむ       |
| `Enter`   | ハイライトされたセッションを選択して再開する         |
| `P`       | セッションコンテンツをプレビューする             |
| `R`       | ハイライトされたセッションの名前を変更する          |
| `/`       | 検索してセッションをフィルタリングする            |
| `A`       | 現在のディレクトリとすべてのプロジェクト間を切り替える    |
| `B`       | 現在の git ブランチからのセッションにフィルタリングする |
| `Esc`     | ピッカーまたは検索モードを終了する              |

**セッション組織：**

ピッカーは有用なメタデータを含むセッションを表示します：

* セッション名または初期プロンプト
* 最後のアクティビティからの経過時間
* メッセージ数
* Git ブランチ（該当する場合）

フォークされたセッション（`/rewind` または `--fork-session` で作成）は、ルートセッションの下にグループ化されており、関連する会話を見つけやすくなっています。

<Tip>
  ヒント：

  * **セッションを早期に名前付ける**：個別のタスクで作業を開始するときに `/rename` を使用します。後で「payment-integration」を見つける方が「explain this function」よりもはるかに簡単です
  * 現在のディレクトリで最新の会話にすばやくアクセスするには `--continue` を使用します
  * 必要なセッションがわかっている場合は `--resume session-name` を使用します
  * 参照して選択する必要がある場合は `--resume`（名前なし）を使用します
  * スクリプトの場合は、`claude --continue --print "prompt"` を使用して非対話型モードで再開します
  * ピッカーで `P` を押してセッションを再開する前にプレビューします
  * 再開されたセッションは、元のセッションと同じモデルと設定で開始されます

  仕組み：

  1. **会話ストレージ**：すべての会話は完全なメッセージ履歴を含めてローカルに自動保存されます
  2. **メッセージ逆シリアル化**：再開時に、コンテキストを維持するために全メッセージ履歴が復元されます
  3. **ツール状態**：前の会話からのツール使用と結果が保持されます
  4. **コンテキスト復元**：会話は以前のすべてのコンテキストを保持して再開されます
</Tip>

***

## Git worktrees を使用して並列 Claude Code セッションを実行する

複数のタスクに同時に取り組む必要があり、Claude Code インスタンス間で完全なコード分離が必要なとします。

<Steps>
  <Step title="Git worktrees を理解する">
    Git worktrees を使用すると、同じリポジトリから複数のブランチを別々のディレクトリにチェックアウトできます。各 worktree には、Git 履歴を共有しながら、独立した作業ディレクトリがあります。詳細については、[公式 Git worktree ドキュメント](https://git-scm.com/docs/git-worktree)を参照してください。
  </Step>

  <Step title="新しい worktree を作成する">
    ```bash  theme={null}
    # 新しいブランチで新しい worktree を作成する 
    git worktree add ../project-feature-a -b feature-a

    # または既存のブランチで worktree を作成する
    git worktree add ../project-bugfix bugfix-123
    ```

    これにより、リポジトリの個別の作業コピーを含む新しいディレクトリが作成されます。
  </Step>

  <Step title="各 worktree で Claude Code を実行する">
    ```bash  theme={null}
    # worktree に移動する 
    cd ../project-feature-a

    # この分離された環境で Claude Code を実行する
    claude
    ```
  </Step>

  <Step title="別の worktree で Claude を実行する">
    ```bash  theme={null}
    cd ../project-bugfix
    claude
    ```
  </Step>

  <Step title="worktrees を管理する">
    ```bash  theme={null}
    # すべての worktrees をリストする
    git worktree list

    # 完了したら worktree を削除する
    git worktree remove ../project-feature-a
    ```
  </Step>
</Steps>

<Tip>
  ヒント：

  * 各 worktree には独立したファイル状態があり、並列 Claude Code セッションに最適です
  * 1 つの worktree で行われた変更は他に影響しないため、Claude インスタンスが相互に干渉するのを防ぎます
  * すべての worktrees は同じ Git 履歴とリモート接続を共有します
  * 長時間実行されるタスクの場合、1 つの worktree で Claude が作業している間に別の worktree で開発を続行できます
  * 各 worktree がどのタスク用かを簡単に識別するために、説明的なディレクトリ名を使用します
  * 新しい各 worktree でプロジェクトの設定に従って開発環境を初期化することを忘れないでください。スタックに応じて、これには以下が含まれる場合があります：
    * JavaScript プロジェクト：依存関係のインストール（`npm install`、`yarn`）を実行する
    * Python プロジェクト：仮想環境の設定またはパッケージマネージャーでのインストール
    * その他の言語：プロジェクトの標準的なセットアップ プロセスに従う
</Tip>

***

## Claude を unix スタイルのユーティリティとして使用する

### 検証プロセスに Claude を追加する

Claude Code をリンターまたはコードレビューアーとして使用したいとします。

**ビルドスクリプトに Claude を追加する：**

```json  theme={null}
// package.json
{
    ...
    "scripts": {
        ...
        "lint:claude": "claude -p 'you are a linter. please look at the changes vs. main and report any issues related to typos. report the filename and line number on one line, and a description of the issue on the second line. do not return any other text.'"
    }
}
```

<Tip>
  ヒント：

  * CI/CD パイプラインで自動コードレビューに Claude を使用する
  * プロンプトをカスタマイズして、プロジェクトに関連する特定の問題をチェックする
  * 異なるタイプの検証用に複数のスクリプトを作成することを検討する
</Tip>

### パイプイン、パイプアウト

Claude にデータをパイプインし、構造化された形式でデータを取得したいとします。

**Claude を通じてデータをパイプする：**

```bash  theme={null}
cat build-error.txt | claude -p 'concisely explain the root cause of this build error' > output.txt
```

<Tip>
  ヒント：

  * パイプを使用して Claude を既存のシェルスクリプトに統合する
  * 他の Unix ツールと組み合わせて強力なワークフローを作成する
  * スクリプトまたは他のツールに Claude Code を統合する場合は --output-format の使用を検討する
</Tip>

### 出力形式を制御する

特に Claude Code をスクリプトまたは他のツールに統合する場合、Claude の出力が特定の形式である必要があるとします。

<Steps>
  <Step title="テキスト形式を使用する（デフォルト）">
    ```bash  theme={null}
    cat data.txt | claude -p 'summarize this data' --output-format text > summary.txt
    ```

    これにより、Claude のプレーンテキスト応答のみが出力されます（デフォルトの動作）。
  </Step>

  <Step title="JSON 形式を使用する">
    ```bash  theme={null}
    cat code.py | claude -p 'analyze this code for bugs' --output-format json > analysis.json
    ```

    これにより、コストと期間を含むメタデータを含むメッセージの JSON 配列が出力されます。
  </Step>

  <Step title="ストリーミング JSON 形式を使用する">
    ```bash  theme={null}
    cat log.txt | claude -p 'parse this log file for errors' --output-format stream-json
    ```

    これにより、Claude がリクエストを処理するときに、一連の JSON オブジェクトがリアルタイムで出力されます。各メッセージは有効な JSON オブジェクトですが、連結された場合、全体の出力は有効な JSON ではありません。
  </Step>
</Steps>

<Tip>
  ヒント：

  * Claude の応答だけが必要な単純な統合には `--output-format text` を使用する
  * 完全な会話ログが必要な場合は `--output-format json` を使用する
  * 各会話ターンのリアルタイム出力には `--output-format stream-json` を使用する
</Tip>

***

## Claude の機能について質問する

Claude は自分のドキュメントへの組み込みアクセスを持っており、自分の機能と制限について質問に答えることができます。

### 質問例

```
> can Claude Code create pull requests?
```

```
> how does Claude Code handle permissions?
```

```
> what skills are available?
```

```
> how do I use MCP with Claude Code?
```

```
> how do I configure Claude Code for Amazon Bedrock?
```

```
> what are the limitations of Claude Code?
```

<Note>
  Claude はこれらの質問にドキュメントベースの回答を提供します。実行可能な例と実践的なデモンストレーションについては、上記の特定のワークフローセクションを参照してください。
</Note>

<Tip>
  ヒント：

  * Claude は、使用しているバージョンに関係なく、常に最新の Claude Code ドキュメントにアクセスできます
  * 詳細な回答を得るために具体的な質問をする
  * Claude は、MCP 統合、エンタープライズ設定、高度なワークフローなどの複雑な機能を説明できます
</Tip>

***

## 次のステップ

<CardGroup cols={2}>
  <Card title="ベストプラクティス" icon="lightbulb" href="/ja/best-practices">
    Claude Code から最大限の価値を得るためのパターン
  </Card>

  <Card title="Claude Code の仕組み" icon="gear" href="/ja/how-claude-code-works">
    agentic ループとコンテキスト管理を理解する
  </Card>

  <Card title="Claude Code を拡張する" icon="puzzle-piece" href="/ja/features-overview">
    skills、hooks、MCP、subagents、プラグインを追加する
  </Card>

  <Card title="リファレンス実装" icon="code" href="https://github.com/anthropics/claude-code/tree/main/.devcontainer">
    開発コンテナリファレンス実装をクローンする
  </Card>
</CardGroup>
