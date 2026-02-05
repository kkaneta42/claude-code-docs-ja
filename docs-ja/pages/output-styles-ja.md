> ## Documentation Index
> Fetch the complete documentation index at: https://code.claude.com/docs/llms.txt
> Use this file to discover all available pages before exploring further.

# 出力スタイル

> ソフトウェアエンジニアリング以外の用途にClaude Codeを適応させる

出力スタイルを使用すると、Claude Codeをあらゆるタイプのエージェントとして使用できます。ローカルスクリプトの実行、ファイルの読み書き、TODOの追跡など、コアの機能を保持したままです。

## 組み込み出力スタイル

Claude Codeの**デフォルト**出力スタイルは既存のシステムプロンプトであり、ソフトウェアエンジニアリングタスクを効率的に完了するのに役立つように設計されています。

コードベースとClaudeの動作方法を教えることに焦点を当てた、2つの追加の組み込み出力スタイルがあります：

* **説明的（Explanatory）**: ソフトウェアエンジニアリングタスクの完了を支援する際に、教育的な「インサイト」を提供します。実装の選択肢とコードベースのパターンを理解するのに役立ちます。

* **学習（Learning）**: 協調的な学習型モードです。Claudeはコーディング中に「インサイト」を共有するだけでなく、小さな戦略的なコードの一部を自分で実装するよう求めます。Claude Codeはあなたが実装するためのコードに`TODO(human)`マーカーを追加します。

## 出力スタイルの仕組み

出力スタイルはClaude Codeのシステムプロンプトを直接変更します。

* すべての出力スタイルは、効率的な出力のための指示（簡潔に応答するなど）を除外します。
* カスタム出力スタイルは、`keep-coding-instructions`がtrueでない限り、コーディングのための指示（テストでコードを検証するなど）を除外します。
* すべての出力スタイルは、システムプロンプトの最後に追加された独自のカスタム指示を持っています。
* すべての出力スタイルは、会話中に出力スタイル指示に従うようClaudeに思い出させるトリガーを持っています。

## 出力スタイルを変更する

以下のいずれかを実行できます：

* `/output-style`を実行してメニューにアクセスし、出力スタイルを選択します（これは`/config`メニューからもアクセスできます）

* `/output-style [style]`（例：`/output-style explanatory`）を実行して、スタイルに直接切り替えます

これらの変更は[ローカルプロジェクトレベル](/ja/settings)に適用され、`.claude/settings.local.json`に保存されます。設定ファイルの`outputStyle`フィールドを別のレベルで直接編集することもできます。

## カスタム出力スタイルを作成する

カスタム出力スタイルは、フロントマターとシステムプロンプトに追加されるテキストを含むMarkdownファイルです：

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

出力スタイルファイルはフロントマターをサポートしており、コマンドに関するメタデータを指定するのに便利です：

| フロントマター                    | 目的                                          | デフォルト     |
| :------------------------- | :------------------------------------------ | :-------- |
| `name`                     | 出力スタイルの名前（ファイル名でない場合）                       | ファイル名から継承 |
| `description`              | 出力スタイルの説明。`/output-style`のUIでのみ使用されます       | なし        |
| `keep-coding-instructions` | Claude Codeのシステムプロンプトのコーディング関連の部分を保持するかどうか。 | false     |

## 関連機能との比較

### 出力スタイル vs. CLAUDE.md vs. --append-system-prompt

出力スタイルは、ソフトウェアエンジニアリング固有のClaude Codeのデフォルトシステムプロンプトの部分を完全に「オフ」にします。CLAUDE.mdも`--append-system-prompt`も、Claude Codeのデフォルトシステムプロンプトを編集しません。CLAUDE.mdは、Claude Codeのデフォルトシステムプロンプト\_の後\_のユーザーメッセージとしてコンテンツを追加します。`--append-system-prompt`はコンテンツをシステムプロンプトに追加します。

### 出力スタイル vs. [エージェント](/ja/sub-agents)

出力スタイルはメインエージェントループに直接影響し、システムプロンプトにのみ影響します。エージェントは特定のタスクを処理するために呼び出され、使用するモデル、利用可能なツール、エージェントをいつ使用するかに関するコンテキストなどの追加設定を含めることができます。

### 出力スタイル vs. [カスタムスラッシュコマンド](/ja/slash-commands)

出力スタイルを「保存されたシステムプロンプト」と考え、カスタムスラッシュコマンドを「保存されたプロンプト」と考えることができます。
