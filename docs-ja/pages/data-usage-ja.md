> ## Documentation Index
> Fetch the complete documentation index at: https://code.claude.com/docs/llms.txt
> Use this file to discover all available pages before exploring further.

# データ使用

> Anthropic の Claude のデータ使用ポリシーについて学習します

## データポリシー

### データトレーニングポリシー

**コンシューマーユーザー（Free、Pro、Max プラン）**：
将来の Claude モデルの改善のためにデータを使用することを許可するかどうかを選択できます。この設定がオンの場合、Free、Pro、Max アカウントからのデータを使用して新しいモデルをトレーニングします（これらのアカウントから Claude Code を使用する場合を含む）。

**商用ユーザー**：（Team および Enterprise プラン、API、サードパーティプラットフォーム、Claude Gov）既存のポリシーを維持します。Anthropic は、商用条件の下で Claude Code に送信されたコードまたはプロンプトを使用して生成モデルをトレーニングしません。ただし、カスタマーがモデル改善のためにデータを提供することを選択した場合は除きます（例えば、[Developer Partner Program](https://support.claude.com/ja/articles/11174108-about-the-development-partner-program)）。

### Development Partner Program

[Development Partner Program](https://support.claude.com/ja/articles/11174108-about-the-development-partner-program) などを通じて、トレーニング用の資料を提供する方法に明示的にオプトインした場合、提供された資料を使用してモデルをトレーニングする可能性があります。組織管理者は、組織の Development Partner Program に明示的にオプトインできます。このプログラムは Anthropic ファーストパーティ API でのみ利用可能であり、Bedrock または Vertex ユーザーは利用できないことに注意してください。

### `/bug` コマンドを使用したフィードバック

`/bug` コマンドを使用して Claude Code に関するフィードバックを送信することを選択した場合、製品とサービスを改善するためにフィードバックを使用する可能性があります。`/bug` を通じて共有されたトランスクリプトは 5 年間保持されます。

### セッション品質調査

Claude Code で「How is Claude doing this session?」プロンプトが表示される場合、この調査に応答する（「Dismiss」を選択する場合を含む）と、数値評価（1、2、3、または dismiss）のみが記録されます。この調査の一部として、会話トランスクリプト、入力、出力、またはその他のセッションデータは収集または保存されません。サムズアップ/ダウンフィードバックまたは `/bug` レポートとは異なり、このセッション品質調査は単純な製品満足度メトリックです。この調査への応答は、データトレーニング設定に影響を与えず、AI モデルをトレーニングするために使用することはできません。

これらの調査を無効にするには、`CLAUDE_CODE_DISABLE_FEEDBACK_SURVEY=1` を設定します。サードパーティプロバイダー（Bedrock、Vertex、Foundry）を使用する場合、またはテレメトリが無効になっている場合、調査は自動的に無効になります。

### データ保持

Anthropic は、アカウントタイプと設定に基づいて Claude Code データを保持します。

**コンシューマーユーザー（Free、Pro、Max プラン）**：

* モデル改善のためのデータ使用を許可するユーザー：モデル開発とセキュリティ改善をサポートするための 5 年間の保持期間
* モデル改善のためのデータ使用を許可しないユーザー：30 日間の保持期間
* プライバシー設定は、[claude.ai/settings/data-privacy-controls](https://claude.ai/settings/data-privacy-controls) でいつでも変更できます。

**商用ユーザー（Team、Enterprise、API）**：

* 標準：30 日間の保持期間
* ゼロデータ保持：適切に設定された API キーで利用可能 - Claude Code はサーバーにチャットトランスクリプトを保持しません
* ローカルキャッシング：Claude Code クライアントは、セッション再開を有効にするために、セッションをローカルに最大 30 日間保存できます（設定可能）

データ保持慣行の詳細については、[Privacy Center](https://privacy.anthropic.com/) をご覧ください。

詳細については、[Commercial Terms of Service](https://www.anthropic.com/legal/commercial-terms)（Team、Enterprise、API ユーザー向け）または [Consumer Terms](https://www.anthropic.com/legal/consumer-terms)（Free、Pro、Max ユーザー向け）および [Privacy Policy](https://www.anthropic.com/legal/privacy) をご確認ください。

## データアクセス

すべてのファーストパーティユーザーの場合、[local Claude Code](#local-claude-code-data-flow-and-dependencies) および [remote Claude Code](#cloud-execution-data-flow-and-dependencies) でログされるデータについて詳しく知ることができます。リモート Claude Code の場合、Claude は Claude Code セッションを開始したリポジトリにアクセスします。Claude は接続したが、セッションを開始していないリポジトリにはアクセスしません。

## Local Claude Code：データフローと依存関係

以下の図は、インストール中および通常の操作中に Claude Code が外部サービスにどのように接続するかを示しています。実線は必須の接続を示し、破線はオプションまたはユーザーが開始したデータフローを表します。

<img src="https://mintcdn.com/claude-code/I9Dpo7RZuIbc86cX/images/claude-code-data-flow.svg?fit=max&auto=format&n=I9Dpo7RZuIbc86cX&q=85&s=9e77f476347e7c9983f6e211d27cf6a9" alt="Claude Code の外部接続を示す図：インストール/更新は NPM に接続し、ユーザーリクエストは Console 認証、public-api、およびオプションで Statsig、Sentry、バグレポートを含む Anthropic サービスに接続します" data-og-width="720" width="720" data-og-height="520" height="520" data-path="images/claude-code-data-flow.svg" data-optimize="true" data-opv="3" srcset="https://mintcdn.com/claude-code/I9Dpo7RZuIbc86cX/images/claude-code-data-flow.svg?w=280&fit=max&auto=format&n=I9Dpo7RZuIbc86cX&q=85&s=94c033b9b6db3d10b9e2d7c6d681d9dc 280w, https://mintcdn.com/claude-code/I9Dpo7RZuIbc86cX/images/claude-code-data-flow.svg?w=560&fit=max&auto=format&n=I9Dpo7RZuIbc86cX&q=85&s=430aaaf77c28c501d5753ffa456ee227 560w, https://mintcdn.com/claude-code/I9Dpo7RZuIbc86cX/images/claude-code-data-flow.svg?w=840&fit=max&auto=format&n=I9Dpo7RZuIbc86cX&q=85&s=63c3c3f160b522220a8291fe2f93f970 840w, https://mintcdn.com/claude-code/I9Dpo7RZuIbc86cX/images/claude-code-data-flow.svg?w=1100&fit=max&auto=format&n=I9Dpo7RZuIbc86cX&q=85&s=a7f6e838482f4a1a0a0b4683439369ea 1100w, https://mintcdn.com/claude-code/I9Dpo7RZuIbc86cX/images/claude-code-data-flow.svg?w=1650&fit=max&auto=format&n=I9Dpo7RZuIbc86cX&q=85&s=5fbf749c2f94babb3ef72edfb7aba1e9 1650w, https://mintcdn.com/claude-code/I9Dpo7RZuIbc86cX/images/claude-code-data-flow.svg?w=2500&fit=max&auto=format&n=I9Dpo7RZuIbc86cX&q=85&s=7a1babbdccc4986957698d9c5c30c4a8 2500w" />

Claude Code は [NPM](https://www.npmjs.com/package/@anthropic-ai/claude-code) からインストールされます。Claude Code はローカルで実行されます。LLM と対話するために、Claude Code はネットワーク経由でデータを送信します。このデータには、すべてのユーザープロンプトとモデル出力が含まれます。データは TLS を介して転送中に暗号化され、保存時には暗号化されません。Claude Code はほとんどの一般的な VPN および LLM プロキシと互換性があります。

Claude Code は Anthropic の API 上に構築されています。API のセキュリティ制御（API ロギング手順を含む）の詳細については、[Anthropic Trust Center](https://trust.anthropic.com) で提供されるコンプライアンスアーティファクトを参照してください。

### クラウド実行：データフローと依存関係

[web 上の Claude Code](/ja/claude-code-on-the-web) を使用する場合、セッションはローカルではなく Anthropic が管理する仮想マシンで実行されます。クラウド環境では：

* **コードとデータストレージ**：リポジトリは分離された VM にクローンされます。コードとセッションデータは、アカウントタイプの保持および使用ポリシーに従います（上記のデータ保持セクションを参照）
* **認証情報**：GitHub 認証はセキュアプロキシを通じて処理されます。GitHub 認証情報はサンドボックスに入りません
* **ネットワークトラフィック**：すべてのアウトバウンドトラフィックはセキュリティプロキシを通じて監査ログと不正使用防止のために送信されます
* **セッションデータ**：プロンプト、コード変更、出力は、local Claude Code 使用と同じデータポリシーに従います

クラウド実行のセキュリティ詳細については、[Security](/ja/security#cloud-execution-security) を参照してください。

## テレメトリサービス

Claude Code はユーザーのマシンから Statsig サービスに接続して、レイテンシ、信頼性、使用パターンなどの運用メトリックをログします。このロギングには、コードまたはファイルパスは含まれません。データは TLS を使用して転送中に暗号化され、256 ビット AES 暗号化を使用して保存時に暗号化されます。[Statsig security documentation](https://www.statsig.com/trust/security) で詳細をご覧ください。Statsig テレメトリをオプトアウトするには、`DISABLE_TELEMETRY` 環境変数を設定します。

Claude Code はユーザーのマシンから Sentry に接続して、運用エラーログを記録します。データは TLS を使用して転送中に暗号化され、256 ビット AES 暗号化を使用して保存時に暗号化されます。[Sentry security documentation](https://sentry.io/security/) で詳細をご覧ください。エラーログをオプトアウトするには、`DISABLE_ERROR_REPORTING` 環境変数を設定します。

ユーザーが `/bug` コマンドを実行すると、コードを含む完全な会話履歴のコピーが Anthropic に送信されます。データは転送中および保存時に暗号化されます。オプションで、公開リポジトリに Github イシューが作成されます。バグレポートをオプトアウトするには、`DISABLE_BUG_COMMAND` 環境変数を設定します。

## API プロバイダー別のデフォルト動作

デフォルトでは、Bedrock、Vertex、または Foundry を使用する場合、すべての非必須トラフィック（エラーレポート、テレメトリ、バグレポート機能、セッション品質調査を含む）を無効にします。`CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC` 環境変数を設定することで、これらすべてを一度にオプトアウトすることもできます。以下は完全なデフォルト動作です：

| サービス                        | Claude API                                                     | Vertex API                                             | Bedrock API                                             | Foundry API                                             |
| --------------------------- | -------------------------------------------------------------- | ------------------------------------------------------ | ------------------------------------------------------- | ------------------------------------------------------- |
| **Statsig（メトリクス）**          | デフォルトオン。<br />`DISABLE_TELEMETRY=1` で無効にします。                   | デフォルトオフ。<br />`CLAUDE_CODE_USE_VERTEX` は 1 である必要があります。 | デフォルトオフ。<br />`CLAUDE_CODE_USE_BEDROCK` は 1 である必要があります。 | デフォルトオフ。<br />`CLAUDE_CODE_USE_FOUNDRY` は 1 である必要があります。 |
| **Sentry（エラー）**             | デフォルトオン。<br />`DISABLE_ERROR_REPORTING=1` で無効にします。             | デフォルトオフ。<br />`CLAUDE_CODE_USE_VERTEX` は 1 である必要があります。 | デフォルトオフ。<br />`CLAUDE_CODE_USE_BEDROCK` は 1 である必要があります。 | デフォルトオフ。<br />`CLAUDE_CODE_USE_FOUNDRY` は 1 である必要があります。 |
| **Claude API（`/bug` レポート）** | デフォルトオン。<br />`DISABLE_BUG_COMMAND=1` で無効にします。                 | デフォルトオフ。<br />`CLAUDE_CODE_USE_VERTEX` は 1 である必要があります。 | デフォルトオフ。<br />`CLAUDE_CODE_USE_BEDROCK` は 1 である必要があります。 | デフォルトオフ。<br />`CLAUDE_CODE_USE_FOUNDRY` は 1 である必要があります。 |
| **セッション品質調査**               | デフォルトオン。<br />`CLAUDE_CODE_DISABLE_FEEDBACK_SURVEY=1` で無効にします。 | デフォルトオフ。<br />`CLAUDE_CODE_USE_VERTEX` は 1 である必要があります。 | デフォルトオフ。<br />`CLAUDE_CODE_USE_BEDROCK` は 1 である必要があります。 | デフォルトオフ。<br />`CLAUDE_CODE_USE_FOUNDRY` は 1 である必要があります。 |

すべての環境変数は `settings.json` にチェックインできます（[詳細をご覧ください](/ja/settings)）。
