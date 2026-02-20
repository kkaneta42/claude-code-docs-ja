> ## Documentation Index
> Fetch the complete documentation index at: https://code.claude.com/docs/llms.txt
> Use this file to discover all available pages before exploring further.

# Claude Code の仕組み

> agentic ループ、組み込みツール、Claude Code がプロジェクトとどのように相互作用するかを理解します。

Claude Code はターミナルで実行される agentic アシスタントです。コーディングに優れていますが、コマンドラインからできることなら何でも手助けできます。ドキュメント作成、ビルド実行、ファイル検索、トピック調査など、様々なタスクに対応します。

このガイドでは、コアアーキテクチャ、組み込み機能、および [Claude Code を効果的に使用するためのヒント](#work-effectively-with-claude-code) について説明します。ステップバイステップのウォークスルーについては、[一般的なワークフロー](/ja/common-workflows) を参照してください。skills、MCP、hooks などの拡張機能については、[Claude Code を拡張する](/ja/features-overview) を参照してください。

## agentic ループ

Claude にタスクを与えると、3 つのフェーズを通じて作業します。**コンテキストの収集**、**アクションの実行**、**結果の検証** です。これらのフェーズは相互に融合します。Claude はツールを使用して、コードを理解するためのファイル検索、変更を加えるための編集、作業を確認するためのテスト実行など、様々な場面で活用します。

<img src="https://mintcdn.com/claude-code/TBPmHzr19mDCuhZi/images/agentic-loop.svg?fit=max&auto=format&n=TBPmHzr19mDCuhZi&q=85&s=9d9cdb2102f397a0f57450ca5ca2a969" alt="agentic ループ：プロンプトから Claude がコンテキストを収集し、アクションを実行し、結果を検証し、タスク完了まで繰り返します。任意の時点で中断できます。" data-og-width="720" width="720" data-og-height="280" height="280" data-path="images/agentic-loop.svg" data-optimize="true" data-opv="3" srcset="https://mintcdn.com/claude-code/TBPmHzr19mDCuhZi/images/agentic-loop.svg?w=280&fit=max&auto=format&n=TBPmHzr19mDCuhZi&q=85&s=9c6a590754c1c1b281d40fc9f10fed0d 280w, https://mintcdn.com/claude-code/TBPmHzr19mDCuhZi/images/agentic-loop.svg?w=560&fit=max&auto=format&n=TBPmHzr19mDCuhZi&q=85&s=9fb2f2fc174e285797cad25a9ca2a326 560w, https://mintcdn.com/claude-code/TBPmHzr19mDCuhZi/images/agentic-loop.svg?w=840&fit=max&auto=format&n=TBPmHzr19mDCuhZi&q=85&s=3a1b68dd7b861e8ff25391773d8ab60c 840w, https://mintcdn.com/claude-code/TBPmHzr19mDCuhZi/images/agentic-loop.svg?w=1100&fit=max&auto=format&n=TBPmHzr19mDCuhZi&q=85&s=e64edf9f5cbc62464617945cf08ef134 1100w, https://mintcdn.com/claude-code/TBPmHzr19mDCuhZi/images/agentic-loop.svg?w=1650&fit=max&auto=format&n=TBPmHzr19mDCuhZi&q=85&s=3bf3319e76669f11513c6bcc5bf86feb 1650w, https://mintcdn.com/claude-code/TBPmHzr19mDCuhZi/images/agentic-loop.svg?w=2500&fit=max&auto=format&n=TBPmHzr19mDCuhZi&q=85&s=9413880a191409ff3c81bafc8f7ab977 2500w" />

ループは、あなたが何を求めるかに応じて適応します。コードベースに関する質問は、コンテキスト収集だけで済むかもしれません。バグ修正は 3 つのフェーズすべてを繰り返し循環します。リファクタリングは広範な検証を伴うかもしれません。Claude は前のステップから学んだことに基づいて、各ステップが何を必要とするかを判断し、数十のアクションを連鎖させ、途中で軌道修正します。

あなたもこのループの一部です。任意の時点で中断して Claude を別の方向に導いたり、追加のコンテキストを提供したり、別のアプローチを試すよう求めたりできます。Claude は自律的に動作しますが、あなたの入力に対して応答性を保ちます。

agentic ループは 2 つのコンポーネントによって駆動されます。推論する [モデル](#models) と、アクションを実行する [ツール](#tools) です。Claude Code は Claude の周りの **agentic ハーネス** として機能します。言語モデルを有能なコーディングエージェントに変えるツール、コンテキスト管理、実行環境を提供します。

### モデル

Claude Code は Claude モデルを使用して、コードを理解し、タスクについて推論します。Claude は任意の言語のコードを読み、コンポーネントがどのように接続されているかを理解し、目標を達成するために何を変更する必要があるかを判断できます。複雑なタスクの場合、作業をステップに分割し、実行し、学んだことに基づいて調整します。

[複数のモデル](/ja/model-config) が異なるトレードオフで利用可能です。Sonnet はほとんどのコーディングタスクをうまく処理します。Opus は複雑なアーキテクチャ上の決定に対してより強力な推論を提供します。セッション中に `/model` で切り替えるか、`claude --model <name>` で開始します。

このガイドで「Claude が選択する」または「Claude が決定する」と言う場合、それはモデルが推論を行っていることを意味します。

### ツール

ツールは Claude Code を agentic にするものです。ツールがなければ、Claude はテキストで応答することしかできません。ツールがあれば、Claude はアクションを実行できます。コードを読み、ファイルを編集し、コマンドを実行し、ウェブを検索し、外部サービスと相互作用します。各ツール使用は情報を返し、それがループにフィードバックされ、Claude の次の決定に情報を与えます。

組み込みツールは一般的に 4 つのカテゴリに分類され、それぞれが異なる種類のエージェンシーを表します。

| カテゴリ             | Claude ができること                                                                                   |
| ---------------- | ----------------------------------------------------------------------------------------------- |
| **ファイル操作**       | ファイルの読み取り、コードの編集、新しいファイルの作成、名前変更と再編成                                                            |
| **検索**           | パターンでファイルを検索、正規表現でコンテンツを検索、コードベースを探索                                                            |
| **実行**           | シェルコマンドの実行、サーバーの起動、テストの実行、git の使用                                                               |
| **ウェブ**          | ウェブの検索、ドキュメントの取得、エラーメッセージの検索                                                                    |
| **コード インテリジェンス** | 編集後の型エラーと警告の表示、定義へのジャンプ、参照の検索（[コード インテリジェンス プラグイン](/ja/discover-plugins#code-intelligence) が必要） |

これらが主な機能です。Claude には subagents の生成、質問、その他のオーケストレーションタスク用のツールもあります。完全なリストについては、[Claude が利用可能なツール](/ja/settings#tools-available-to-claude) を参照してください。

Claude は、プロンプトと途中で学んだことに基づいて、どのツールを使用するかを選択します。「失敗しているテストを修正して」と言うと、Claude は以下のようなことを行うかもしれません。

1. テストスイートを実行して、何が失敗しているかを確認する
2. エラー出力を読む
3. 関連するソースファイルを検索する
4. それらのファイルを読んでコードを理解する
5. ファイルを編集して問題を修正する
6. テストを再度実行して検証する

各ツール使用は Claude に新しい情報を与え、次のステップに情報を与えます。これが agentic ループの実際の動作です。

**基本機能の拡張：** 組み込みツールは基盤です。[skills](/ja/skills) で Claude が知ることを拡張し、[MCP](/ja/mcp) で外部サービスに接続し、[hooks](/ja/hooks) でワークフローを自動化し、[subagents](/ja/sub-agents) でタスクをオフロードできます。これらの拡張は、コア agentic ループの上に層を形成します。ニーズに適した拡張を選択するためのガイダンスについては、[Claude Code を拡張する](/ja/features-overview) を参照してください。

## Claude がアクセスできるもの

このガイドはターミナルに焦点を当てています。Claude Code は [VS Code、JetBrains IDE、その他の環境](/ja/ide-integrations) でも実行されます。

ディレクトリで `claude` を実行すると、Claude Code は以下にアクセスできます。

* **プロジェクト。** ディレクトリとサブディレクトリ内のファイル、およびあなたの許可を得た他の場所のファイル。
* **ターミナル。** 実行できるコマンド。ビルドツール、git、パッケージマネージャー、システムユーティリティ、スクリプト。コマンドラインからできることなら、Claude もできます。
* **git の状態。** 現在のブランチ、コミットされていない変更、最近のコミット履歴。
* **[CLAUDE.md](/ja/memory)。** プロジェクト固有の指示、規約、Claude が毎回のセッションで知っておくべきコンテキストを保存するマークダウンファイル。
* **設定した拡張機能。** 外部サービス用の [MCP servers](/ja/mcp)、ワークフロー用の [skills](/ja/skills)、委譲作業用の [subagents](/ja/sub-agents)、ブラウザ相互作用用の [Claude in Chrome](/ja/chrome)。

Claude はプロジェクト全体を見ることができるため、プロジェクト全体で作業できます。「認証バグを修正して」と Claude に頼むと、関連するファイルを検索し、複数のファイルを読んでコンテキストを理解し、それらを横断して調整された編集を行い、修正を検証するためにテストを実行し、求めればそれらの変更をコミットします。これは現在のファイルのみを見るインラインコードアシスタントとは異なります。

## セッションで作業する

Claude Code は、作業中にローカルに会話を保存します。各メッセージ、ツール使用、結果が保存されます。これにより、[巻き戻し](#undo-changes-with-checkpoints)、[再開、フォーク](#resume-or-fork-sessions) セッションが可能になります。Claude がコード変更を行う前に、影響を受けるファイルのスナップショットも作成されるため、必要に応じて元に戻すことができます。

**セッションは一時的です。** claude.ai とは異なり、Claude Code はセッション間に永続的なメモリを持ちません。各新しいセッションは最初から始まります。Claude は時間とともにあなたの好みを「学習」したり、先週何に取り組んだかを覚えたりしません。Claude がセッション間で何かを知ってほしい場合は、[CLAUDE.md](/ja/memory) に入れてください。

### ブランチ間で作業する

各 Claude Code の会話は、現在のディレクトリに結び付けられたセッションです。再開すると、そのディレクトリからのセッションのみが表示されます。

Claude は現在のブランチのファイルを見ます。ブランチを切り替えると、Claude は新しいブランチのファイルを見ますが、会話履歴は同じままです。Claude はブランチを切り替えた後でも、何を議論したかを覚えています。

セッションはディレクトリに結び付けられているため、[git worktrees](/ja/common-workflows#run-parallel-claude-code-sessions-with-git-worktrees) を使用して並列 Claude Code セッションを実行できます。これは個別のブランチ用に別のディレクトリを作成します。

### セッションを再開またはフォークする

`claude --continue` または `claude --resume` でセッションを再開すると、同じセッション ID を使用して中断したところから再開します。新しいメッセージは既存の会話に追加されます。完全な会話履歴が復元されますが、セッションスコープの権限は復元されません。それらを再度承認する必要があります。

<img src="https://mintcdn.com/claude-code/TBPmHzr19mDCuhZi/images/session-continuity.svg?fit=max&auto=format&n=TBPmHzr19mDCuhZi&q=85&s=808da1b213c731bf98874c75981d688b" alt="セッション継続性：再開は同じセッションを続行し、フォークは新しい ID で新しいブランチを作成します。" data-og-width="560" width="560" data-og-height="280" height="280" data-path="images/session-continuity.svg" data-optimize="true" data-opv="3" srcset="https://mintcdn.com/claude-code/TBPmHzr19mDCuhZi/images/session-continuity.svg?w=280&fit=max&auto=format&n=TBPmHzr19mDCuhZi&q=85&s=ba75f64bc571f3ef84a3237ef795bf22 280w, https://mintcdn.com/claude-code/TBPmHzr19mDCuhZi/images/session-continuity.svg?w=560&fit=max&auto=format&n=TBPmHzr19mDCuhZi&q=85&s=343ad422a171a2b909c87ed01c768745 560w, https://mintcdn.com/claude-code/TBPmHzr19mDCuhZi/images/session-continuity.svg?w=840&fit=max&auto=format&n=TBPmHzr19mDCuhZi&q=85&s=afce54d5e3b08cdb54d506332462b74c 840w, https://mintcdn.com/claude-code/TBPmHzr19mDCuhZi/images/session-continuity.svg?w=1100&fit=max&auto=format&n=TBPmHzr19mDCuhZi&q=85&s=28648c0a04cf7aef2de02d1c98491965 1100w, https://mintcdn.com/claude-code/TBPmHzr19mDCuhZi/images/session-continuity.svg?w=1650&fit=max&auto=format&n=TBPmHzr19mDCuhZi&q=85&s=a5287882beedaea54af606f682e4818d 1650w, https://mintcdn.com/claude-code/TBPmHzr19mDCuhZi/images/session-continuity.svg?w=2500&fit=max&auto=format&n=TBPmHzr19mDCuhZi&q=85&s=f392dbe67b63eead4a2aae67adfbfdbe 2500w" />

元のセッションに影響を与えずに別のアプローチを試すためにブランチを分岐させるには、`--fork-session` フラグを使用します。

```bash  theme={null}
claude --continue --fork-session
```

これにより、その時点までの会話履歴を保持しながら新しいセッション ID が作成されます。元のセッションは変更されません。再開と同様に、フォークされたセッションはセッションスコープの権限を継承しません。

**複数のターミナルで同じセッション**：複数のターミナルで同じセッションを再開すると、両方のターミナルが同じセッションファイルに書き込みます。両方からのメッセージがインターリーブされます。同じノートブックに 2 人が書き込むようなものです。何も破損しませんが、会話がごちゃごちゃになります。セッション中、各ターミナルは自分のメッセージのみを見ますが、後でそのセッションを再開すると、すべてがインターリーブされた状態で表示されます。同じ開始点から並列作業する場合は、`--fork-session` を使用して、各ターミナルに独自のクリーンなセッションを与えます。

### コンテキストウィンドウ

Claude のコンテキストウィンドウは、会話履歴、ファイルコンテンツ、コマンド出力、[CLAUDE.md](/ja/memory)、読み込まれた skills、システム指示を保持します。作業を進めると、コンテキストが満杯になります。Claude は自動的にコンパクト化しますが、会話の早い段階からの指示が失われる可能性があります。永続的なルールを CLAUDE.md に入れ、`/context` を実行してスペースを使用しているものを確認してください。

#### コンテキストが満杯になったとき

Claude Code は、制限に近づくにつれてコンテキストを自動的に管理します。古いツール出力をクリアし、必要に応じて会話を要約します。リクエストと主要なコードスニペットは保持されます。会話の早い段階からの詳細な指示は失われる可能性があります。会話履歴に依存するのではなく、永続的なルールを CLAUDE.md に入れてください。

コンパクト化中に保持されるものを制御するには、CLAUDE.md に「Compact Instructions」セクションを追加するか、`/compact` をフォーカス付きで実行します（例：`/compact focus on the API changes`）。

`/context` を実行してスペースを使用しているものを確認してください。MCP servers はすべてのリクエストにツール定義を追加するため、いくつかのサーバーは作業を開始する前に大量のコンテキストを消費できます。`/mcp` を実行してサーバーごとのコストを確認してください。

#### skills と subagents でコンテキストを管理する

コンパクト化を超えて、他の機能を使用してコンテキストにロードされるものを制御できます。

[Skills](/ja/skills) はオンデマンドでロードされます。Claude はセッション開始時に skill の説明を見ますが、完全なコンテンツは skill が使用されるときのみロードされます。手動で呼び出す skill の場合、`disable-model-invocation: true` を設定して、必要になるまで説明をコンテキストから除外してください。

[Subagents](/ja/sub-agents) は独自のフレッシュコンテキストを取得し、メイン会話から完全に分離されています。それらの作業はコンテキストを膨張させません。完了すると、要約を返します。この分離が subagents が長いセッションに役立つ理由です。

各機能のコストについては [コンテキストコスト](/ja/features-overview#understand-context-costs) を参照し、コンテキスト管理のヒントについては [トークン使用量を削減する](/ja/costs#reduce-token-usage) を参照してください。

## チェックポイントと権限で安全を保つ

Claude には 2 つの安全メカニズムがあります。チェックポイントはファイル変更を元に戻すことができ、権限は Claude が何をできるかを制御します。

### チェックポイントで変更を元に戻す

**すべてのファイル編集は可逆的です。** Claude がファイルを編集する前に、現在のコンテンツのスナップショットを作成します。何か問題が発生した場合は、`Esc` を 2 回押して前の状態に巻き戻すか、Claude に元に戻すよう求めてください。

チェックポイントはセッションに対してローカルであり、git とは別です。ファイル変更のみをカバーします。リモートシステム（データベース、API、デプロイメント）に影響を与えるアクションはチェックポイントできません。これが Claude が外部の副作用を持つコマンドを実行する前に尋ねる理由です。

### Claude ができることを制御する

`Shift+Tab` を押して権限モードをサイクルします。

* **デフォルト**：Claude はファイル編集とシェルコマンドの前に尋ねます
* **自動受け入れ編集**：Claude はファイルを編集するときに尋ねず、コマンドについては尋ねます
* **Plan Mode**：Claude は読み取り専用ツールのみを使用し、実行前に承認できるプランを作成します
* **Delegate Mode**：Claude は [agent teammates](/ja/agent-teams) を通じてのみ作業を調整し、直接実装はありません。agent team がアクティブな場合のみ利用可能です。

`.claude/settings.json` で特定のコマンドを許可することもできます。これにより、Claude は毎回尋ねる必要がなくなります。これは `npm test` や `git status` などの信頼できるコマンドに役立ちます。設定は組織全体のポリシーから個人的な好みまでスコープできます。詳細については、[権限](/ja/permissions) を参照してください。

***

## Claude Code を効果的に使用する

これらのヒントは Claude Code からより良い結果を得るのに役立ちます。

### Claude Code に助けを求める

Claude Code は、それの使い方を教えることができます。「hooks をセットアップするにはどうすればいい？」や「CLAUDE.md を構造化する最良の方法は何か？」などの質問をすると、Claude が説明します。

組み込みコマンドもセットアップをガイドします。

* `/init` はプロジェクト用の CLAUDE.md を作成するプロセスをウォークスルーします
* `/agents` はカスタム subagents を設定するのに役立ちます
* `/doctor` はインストールの一般的な問題を診断します

### 会話です

Claude Code は会話型です。完璧なプロンプトは必要ありません。何をしたいかで始めて、その後改善します。

```
> ログインバグを修正して

[Claude が調査し、何かを試す]

> それは完全には正しくありません。問題はセッション処理にあります。

[Claude がアプローチを調整する]
```

最初の試みが正しくない場合、最初からやり直す必要はありません。反復します。

#### 中断して操舵する

任意の時点で Claude を中断できます。間違った道を進んでいる場合は、修正を入力して Enter キーを押すだけです。Claude は何をしているかを停止し、入力に基づいてアプローチを調整します。完了を待つ必要も、最初からやり直す必要もありません。

### 最初から具体的に

最初のプロンプトが正確であるほど、必要な修正が少なくなります。特定のファイルを参照し、制約を述べ、例のパターンを指摘してください。

```
> チェックアウトフローは有効期限切れのカードを持つユーザーに対して機能していません。
> src/payments/ で問題を確認してください。特にトークン更新。
> 最初に失敗するテストを書いて、その後修正してください。
```

「ログインバグを修正して」のような曖昧なプロンプトは機能しますが、より多くの時間を操舵に費やします。上記のような具体的なプロンプトは、最初の試みで成功することが多いです。

### Claude が検証するものを与える

Claude は自分の作業をチェックできるときにより良いパフォーマンスを発揮します。テストケースを含め、期待される UI のスクリーンショットを貼り付けるか、望む出力を定義してください。

```
> validateEmail を実装してください。テストケース：'user@example.com' → true、
> 'invalid' → false、'user@.com' → false。その後テストを実行してください。
```

ビジュアル作業の場合、デザインのスクリーンショットを貼り付けて、Claude にその実装と比較するよう求めてください。

### 実装する前に探索する

複雑な問題の場合、研究とコーディングを分離します。Plan Mode（`Shift+Tab` を 2 回）を使用してコードベースを最初に分析します。

```
> src/auth/ を読んで、セッションの処理方法を理解してください。
> その後、OAuth サポートを追加するためのプランを作成してください。
```

プランを確認し、会話を通じて改善し、その後 Claude に実装させます。このフェーズアプローチは、コードに直接ジャンプするよりも良い結果を生み出します。

### 指示するのではなく委譲する

有能な同僚に委譲することを考えてください。コンテキストと方向を与え、その後 Claude が詳細を理解することを信頼します。

```
> チェックアウトフローは有効期限切れのカードを持つユーザーに対して機能していません。
> 関連するコードは src/payments/ にあります。調査して修正できますか？
```

どのファイルを読むか、どのコマンドを実行するかを指定する必要はありません。Claude がそれを理解します。

## 次のステップ

<CardGroup cols={2}>
  <Card title="機能で拡張する" icon="puzzle-piece" href="/ja/features-overview">
    Skills、MCP 接続、カスタムコマンドを追加する
  </Card>

  <Card title="一般的なワークフロー" icon="graduation-cap" href="/ja/common-workflows">
    典型的なタスクのステップバイステップガイド
  </Card>
</CardGroup>
