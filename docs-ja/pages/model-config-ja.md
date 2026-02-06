> ## Documentation Index
> Fetch the complete documentation index at: https://code.claude.com/docs/llms.txt
> Use this file to discover all available pages before exploring further.

# モデル設定

> Claude Code のモデル設定について学習します。opusplan などのモデルエイリアスを含みます。

## 利用可能なモデル

Claude Code の `model` 設定では、以下のいずれかを設定できます。

* **モデルエイリアス**
* **モデル名**
  * Anthropic API：完全な **[モデル名](https://platform.claude.com/docs/ja/about-claude/models/overview)**
  * Bedrock：推論プロファイル ARN
  * Foundry：デプロイメント名
  * Vertex：バージョン名

### モデルエイリアス

モデルエイリアスは、正確なバージョン番号を覚えることなくモデル設定を選択するための便利な方法を提供します。

| モデルエイリアス         | 動作                                                                                                                                                  |
| ---------------- | --------------------------------------------------------------------------------------------------------------------------------------------------- |
| **`default`**    | アカウントタイプに応じた推奨モデル設定                                                                                                                                 |
| **`sonnet`**     | 日常的なコーディングタスク用に最新の Sonnet モデル（現在は Sonnet 4.5）を使用します                                                                                                 |
| **`opus`**       | 複雑な推論タスク用に最新の Opus モデル（現在は Opus 4.6）を使用します                                                                                                          |
| **`haiku`**      | シンプルなタスク用に高速で効率的な Haiku モデルを使用します                                                                                                                   |
| **`sonnet[1m]`** | 長いセッション用に [100 万トークンのコンテキストウィンドウ](https://platform.claude.com/docs/ja/build-with-claude/context-windows#1m-token-context-window) を備えた Sonnet を使用します |
| **`opusplan`**   | Plan Mode 中は `opus` を使用し、実行中は `sonnet` に切り替わる特別なモード                                                                                                 |

エイリアスは常に最新バージョンを指します。特定のバージョンに固定するには、完全なモデル名（例：`claude-opus-4-5-20251101`）を使用するか、`ANTHROPIC_DEFAULT_OPUS_MODEL` のような対応する環境変数を設定します。

### モデルの設定

モデルは優先度順に複数の方法で設定できます。

1. **セッション中** - `/model <alias|name>` を使用してセッション中にモデルを切り替えます
2. **起動時** - `claude --model <alias|name>` で起動します
3. **環境変数** - `ANTHROPIC_MODEL=<alias|name>` を設定します
4. **設定** - 設定ファイルで `model` フィールドを使用して永続的に設定します。

使用例：

```bash  theme={null}
# Opus で起動
claude --model opus

# セッション中に Sonnet に切り替え
/model sonnet
```

設定ファイルの例：

```
{
    "permissions": {
        ...
    },
    "model": "opus"
}
```

## 特別なモデルの動作

### `default` モデル設定

`default` の動作はアカウントタイプによって異なります。

* **Max と Teams**：Opus 4.6 がデフォルト
* **Pro**：Claude Code では Opus 4.6 がデフォルト
* **Enterprise**：Opus 4.6 は利用可能ですがデフォルトではありません

Claude Code は、Opus の使用量閾値に達した場合、自動的に Sonnet にフォールバックする場合があります。

### `opusplan` モデル設定

`opusplan` モデルエイリアスは、自動化されたハイブリッドアプローチを提供します。

* **Plan Mode 中** - 複雑な推論とアーキテクチャの決定用に `opus` を使用します
* **実行モード中** - コード生成と実装用に自動的に `sonnet` に切り替わります

これにより、計画用の Opus の優れた推論能力と、実行用の Sonnet の効率性の両方の利点が得られます。

### 努力レベルの調整

[努力レベル](https://platform.claude.com/docs/ja/build-with-claude/effort) は Opus 4.6 の適応的推論を制御し、タスクの複雑さに基づいて思考を動的に割り当てます。低い努力はシンプルなタスクではより高速で安価ですが、高い努力は複雑な問題に対してより深い推論を提供します。

3 つのレベルが利用可能です：**low**、**medium**、**high**（デフォルト）。

**努力レベルの設定：**

* **`/model` 内**：モデルを選択する際に左右矢印キーを使用して努力スライダーを調整します
* **環境変数**：`CLAUDE_CODE_EFFORT_LEVEL=low|medium|high` を設定します
* **設定**：設定ファイルで `effortLevel` を設定します

努力は現在 Opus 4.6 でサポートされています。サポートされているモデルが選択されると、努力スライダーが `/model` に表示されます。

### \[1m] による拡張コンテキスト

`[1m]` サフィックスは、長いセッション用に [100 万トークンのコンテキストウィンドウ](https://platform.claude.com/docs/ja/build-with-claude/context-windows#1m-token-context-window) を有効にします。

<Note>
  Opus 4.6 の場合、1M コンテキストウィンドウは API と Claude Code の従量課金ユーザーが利用できます。Pro、Max、Teams、Enterprise サブスクリプションユーザーは、ローンチ時点では Opus 4.6 1M コンテキストにアクセスできません。
</Note>

`[1m]` サフィックスはモデルエイリアスまたは完全なモデル名で使用できます。

```bash  theme={null}
# sonnet[1m] エイリアスを使用
/model sonnet[1m]

# または完全なモデル名に [1m] を追加
/model claude-sonnet-4-5-20250929[1m]
```

注：拡張コンテキストモデルは [異なる価格設定](https://platform.claude.com/docs/ja/about-claude/pricing#long-context-pricing) があります。

## 現在のモデルの確認

現在使用しているモデルは複数の方法で確認できます。

1. [ステータスライン](/ja/statusline)（設定されている場合）
2. `/status` で、アカウント情報も表示されます。

## 環境変数

以下の環境変数を使用できます。これらは完全な **モデル名**（または API プロバイダーの同等のもの）である必要があり、エイリアスがマップするモデル名を制御します。

| 環境変数                             | 説明                                                                           |
| -------------------------------- | ---------------------------------------------------------------------------- |
| `ANTHROPIC_DEFAULT_OPUS_MODEL`   | `opus` に使用するモデル、または Plan Mode がアクティブな場合の `opusplan` に使用するモデル。                |
| `ANTHROPIC_DEFAULT_SONNET_MODEL` | `sonnet` に使用するモデル、または Plan Mode がアクティブでない場合の `opusplan` に使用するモデル。            |
| `ANTHROPIC_DEFAULT_HAIKU_MODEL`  | `haiku` に使用するモデル、または [バックグラウンド機能](/ja/costs#background-token-usage) に使用するモデル |
| `CLAUDE_CODE_SUBAGENT_MODEL`     | [subagents](/ja/sub-agents) に使用するモデル                                         |

注：`ANTHROPIC_SMALL_FAST_MODEL` は `ANTHROPIC_DEFAULT_HAIKU_MODEL` の代わりに非推奨です。

### Prompt caching 設定

Claude Code は [prompt caching](https://platform.claude.com/docs/ja/build-with-claude/prompt-caching) を自動的に使用してパフォーマンスを最適化し、コストを削減します。prompt caching をグローバルに、または特定のモデルティアに対して無効にできます。

| 環境変数                            | 説明                                                           |
| ------------------------------- | ------------------------------------------------------------ |
| `DISABLE_PROMPT_CACHING`        | `1` に設定すると、すべてのモデルの prompt caching を無効にします（モデル固有の設定より優先されます） |
| `DISABLE_PROMPT_CACHING_HAIKU`  | `1` に設定すると、Haiku モデルのみの prompt caching を無効にします               |
| `DISABLE_PROMPT_CACHING_SONNET` | `1` に設定すると、Sonnet モデルのみの prompt caching を無効にします              |
| `DISABLE_PROMPT_CACHING_OPUS`   | `1` に設定すると、Opus モデルのみの prompt caching を無効にします                |

これらの環境変数は、prompt caching の動作に対するきめ細かい制御を提供します。グローバルな `DISABLE_PROMPT_CACHING` 設定はモデル固有の設定より優先され、必要に応じてすべてのキャッシングをすばやく無効にできます。モデル固有の設定は、特定のモデルをデバッグする場合や、異なるキャッシング実装を持つ可能性があるクラウドプロバイダーと連携する場合など、選択的な制御に役立ちます。
