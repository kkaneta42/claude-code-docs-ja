> ## Documentation Index
> Fetch the complete documentation index at: https://code.claude.com/docs/llms.txt
> Use this file to discover all available pages before exploring further.

# 出力スタイル

> ソフトウェアエンジニアリング以外の用途に合わせて Claude Code をカスタマイズする

出力スタイルを使用すると、Claude Code をあらゆるタイプのエージェントとして使用しながら、ローカルスクリプトの実行、ファイルの読み書き、TODO の追跡などのコア機能を保持できます。

## 組み込み出力スタイル

Claude Code の **Default** 出力スタイルは既存のシステムプロンプトであり、ソフトウェアエンジニアリングタスクを効率的に完了するのに役立つように設計されています。

コードベースと Claude の動作方法を教えることに焦点を当てた、2 つの追加の組み込み出力スタイルがあります。

* **Explanatory**: ソフトウェアエンジニアリングタスクの完了を支援しながら、教育的な「Insights」を提供します。実装の選択肢とコードベースのパターンを理解するのに役立ちます。

* **Learning**: 協調的な学習型モードで、Claude はコーディング中に「Insights」を共有するだけでなく、小さな戦略的なコードの一部を自分で実装するよう求めます。Claude Code はコード内に `TODO(human)` マーカーを追加して、実装するようにします。

## 出力スタイルの仕組み

出力スタイルは Claude Code のシステムプロンプトを直接変更します。

* すべての出力スタイルは、効率的な出力のための指示（簡潔に応答するなど）を除外します。
* カスタム出力スタイルは、`keep-coding-instructions` が true でない限り、コーディングのための指示（テストでコードを検証するなど）を除外します。
* すべての出力スタイルは、システムプロンプトの最後に独自のカスタム指示が追加されます。
* すべての出力スタイルは、会話中に出力スタイルの指示に従うよう Claude に思い出させるトリガーを持ちます。

## 出力スタイルを変更する

以下のいずれかを実行できます。

* `/output-style` を実行してメニューにアクセスし、出力スタイルを選択します（これは `/config` メニューからもアクセスできます）

* `/output-style [style]`（例：`/output-style explanatory`）を実行して、スタイルに直接切り替えます

これらの変更は[ローカルプロジェクトレベル](/ja/settings)に適用され、`.claude/settings.local.json` に保存されます。設定ファイルの `outputStyle` フィールドを別のレベルで直接編集することもできます。

## カスタム出力スタイルを作成する

カスタム出力スタイルは、フロントマターとシステムプロンプトに追加されるテキストを含む Markdown ファイルです。

```markdown  theme={null}
---
name: My Custom Style
description:
  A brief description of what this style does, to be displayed to the user
---

# Custom Style Instructions

You are an interactive CLI tool that helps users with software engineering
tasks. [Your custom instructions here...]

## Specific Behaviors

[Define how the assistant should behave in this style...]
```

これらのファイルはユーザーレベル（`~/.claude/output-styles`）またはプロジェクトレベル（`.claude/output-styles`）に保存できます。

### フロントマター

出力スタイルファイルはフロントマターをサポートしており、コマンドに関するメタデータを指定するのに便利です。

| フロントマター                    | 目的                                          | デフォルト     |
| :------------------------- | :------------------------------------------ | :-------- |
| `name`                     | 出力スタイルの名前（ファイル名でない場合）                       | ファイル名から継承 |
| `description`              | 出力スタイルの説明。`/output-style` の UI でのみ使用されます    | なし        |
| `keep-coding-instructions` | Claude Code のシステムプロンプトのコーディング関連の部分を保持するかどうか | false     |

## 関連機能との比較

### 出力スタイル vs. CLAUDE.md vs. --append-system-prompt

出力スタイルは Claude Code のデフォルトシステムプロンプトのソフトウェアエンジニアリング固有の部分を完全に「オフ」にします。CLAUDE.md も `--append-system-prompt` も Claude Code のデフォルトシステムプロンプトを編集しません。CLAUDE.md は内容をユーザーメッセージとして Claude Code のデフォルトシステムプロンプトの「後に」追加します。`--append-system-prompt` はコンテンツをシステムプロンプトに追加します。

### 出力スタイル vs. [Agents](/ja/sub-agents)

出力スタイルはメインエージェントループに直接影響し、システムプロンプトのみに影響します。エージェントは特定のタスクを処理するために呼び出され、使用するモデル、利用可能なツール、エージェントをいつ使用するかに関するコンテキストなどの追加設定を含めることができます。

### 出力スタイル vs. [Skills](/ja/skills)

出力スタイルは Claude の応答方法（フォーマット、トーン、構造）を変更し、選択されると常にアクティブになります。スキルはタスク固有のプロンプトで、`/skill-name` で呼び出すか、関連する場合に Claude が自動的に読み込みます。一貫したフォーマット設定を使用する場合は出力スタイルを使用します。再利用可能なワークフローとタスクの場合はスキルを使用します。
