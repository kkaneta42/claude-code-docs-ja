> ## Documentation Index
> Fetch the complete documentation index at: https://code.claude.com/docs/llms.txt
> Use this file to discover all available pages before exploring further.

# データ使用

> Anthropicのデータ使用ポリシーについて学ぶ

## データポリシー

### データトレーニングポリシー

**コンシューマーユーザー（Free、Pro、Maxプラン）**：
将来のClaudeモデルの改善のためにデータを使用することを許可するかどうかを選択できます。この設定がオンの場合、Free、Pro、Maxアカウントからのデータを使用して新しいモデルをトレーニングします（これらのアカウントからClaude Codeを使用する場合を含む）。

**商用ユーザー**：（TeamおよびEnterpriseプラン、API、サードパーティプラットフォーム、およびClaude Gov）既存のポリシーを維持します。Anthropicは、商用条件の下でClaude Codeに送信されたコードまたはプロンプトを使用して生成モデルをトレーニングしません。ただし、顧客がモデル改善のためにデータを提供することを選択した場合は除きます（例えば、[Developer Partner Program](https://support.claude.com/ja/articles/11174108-about-the-development-partner-program)）。

### Development Partner Program

[Development Partner Program](https://support.claude.com/ja/articles/11174108-about-the-development-partner-program)などを通じて、トレーニング用の資料を提供する方法に明示的にオプトインした場合、提供された資料を使用してモデルをトレーニングする可能性があります。組織の管理者は、組織のDevelopment Partner Programに明示的にオプトインできます。このプログラムはAnthropicファーストパーティAPIでのみ利用可能であり、BedrockまたはVertexユーザーには利用できないことに注意してください。

### `/bug`コマンドを使用したフィードバック

`/bug`コマンドを使用してClaude Codeに関するフィードバックを送信することを選択した場合、フィードバックを使用して製品とサービスを改善する可能性があります。`/bug`経由で共有されたトランスクリプトは5年間保持されます。

### セッション品質調査

Claude Codeで「Claude is doing this session?」というプロンプトが表示されたときに、この調査に応答する場合（「Dismiss」を選択する場合を含む）、数値評価（1、2、3、またはdismiss）のみが記録されます。この調査の一部として、会話トランスクリプト、入力、出力、またはその他のセッションデータは収集または保存されません。サムズアップ/ダウンフィードバックまたは`/bug`レポートとは異なり、このセッション品質調査は単純な製品満足度メトリックです。この調査への応答は、データトレーニング設定に影響を与えず、AIモデルをトレーニングするために使用することはできません。

### データ保持

Anthropicは、アカウントタイプと設定に基づいてClaude Codeデータを保持します。

**コンシューマーユーザー（Free、Pro、Maxプラン）**：

* モデル改善のためのデータ使用を許可するユーザー：モデル開発とセキュリティ改善をサポートするための5年間の保持期間
* モデル改善のためのデータ使用を許可しないユーザー：30日間の保持期間
* プライバシー設定は、[claude.ai/settings/data-privacy-controls](https://claude.ai/settings/data-privacy-controls)でいつでも変更できます。

**商用ユーザー（Team、Enterprise、およびAPI）**：

* 標準：30日間の保持期間
* ゼロデータ保持：適切に構成されたAPIキーで利用可能 - Claude Codeはサーバーにチャットトランスクリプトを保持しません
* ローカルキャッシング：Claude Codeクライアントはセッション再開を有効にするために、セッションをローカルに最大30日間保存できます（設定可能）

[Privacy Center](https://privacy.anthropic.com/)でデータ保持慣行の詳細を確認してください。

詳細については、[Commercial Terms of Service](https://www.anthropic.com/legal/commercial-terms)（Team、Enterprise、およびAPIユーザー向け）または[Consumer Terms](https://www.anthropic.com/legal/consumer-terms)（Free、Pro、およびMaxユーザー向け）および[Privacy Policy](https://www.anthropic.com/legal/privacy)を確認してください。

## データアクセス

すべてのファーストパーティユーザーの場合、[ローカルClaude Code](#local-claude-code-data-flow-and-dependencies)および[リモートClaude Code](#cloud-execution-data-flow-and-dependencies)でログされるデータについて詳しく知ることができます。リモートClaude Codeの場合、ClaudeはClaude Codeセッションを開始するリポジトリにアクセスします。Claudeは接続したが、セッションを開始していないリポジトリにはアクセスしません。

## ローカルClaude Code：データフローと依存関係

以下の図は、インストール中および通常の操作中にClaude Codeが外部サービスにどのように接続するかを示しています。実線は必須の接続を示し、破線はオプションまたはユーザーが開始したデータフローを表します。

<img src="https://mintcdn.com/claude-code/I9Dpo7RZuIbc86cX/images/claude-code-data-flow.svg?fit=max&auto=format&n=I9Dpo7RZuIbc86cX&q=85&s=9e77f476347e7c9983f6e211d27cf6a9" alt="Claude Codeの外部接続を示す図：インストール/更新はNPMに接続し、ユーザーリクエストはConsole auth、public-api、およびオプションでStatsig、Sentry、バグレポートを含むAnthropicサービスに接続します" data-og-width="720" width="720" data-og-height="520" height="520" data-path="images/claude-code-data-flow.svg" data-optimize="true" data-opv="3" srcset="https://mintcdn.com/claude-code/I9Dpo7RZuIbc86cX/images/claude-code-data-flow.svg?w=280&fit=max&auto=format&n=I9Dpo7RZuIbc86cX&q=85&s=94c033b9b6db3d10b9e2d7c6d681d9dc 280w, https://mintcdn.com/claude-code/I9Dpo7RZuIbc86cX/images/claude-code-data-flow.svg?w=560&fit=max&auto=format&n=I9Dpo7RZuIbc86cX&q=85&s=430aaaf77c28c501d5753ffa456ee227 560w, https://mintcdn.com/claude-code/I9Dpo7RZuIbc86cX/images/claude-code-data-flow.svg?w=840&fit=max&auto=format&n=I9Dpo7RZuIbc86cX&q=85&s=63c3c3f160b522220a8291fe2f93f970 840w, https://mintcdn.com/claude-code/I9Dpo7RZuIbc86cX/images/claude-code-data-flow.svg?w=1100&fit=max&auto=format&n=I9Dpo7RZuIbc86cX&q=85&s=a7f6e838482f4a1a0a0b4683439369ea 1100w, https://mintcdn.com/claude-code/I9Dpo7RZuIbc86cX/images/claude-code-data-flow.svg?w=1650&fit=max&auto=format&n=I9Dpo7RZuIbc86cX&q=85&s=5fbf749c2f94babb3ef72edfb7aba1e9 1650w, https://mintcdn.com/claude-code/I9Dpo7RZuIbc86cX/images/claude-code-data-flow.svg?w=2500&fit=max&auto=format&n=I9Dpo7RZuIbc86cX&q=85&s=7a1babbdccc4986957698d9c5c30c4a8 2500w" />

Claude Codeは[NPM](https://www.npmjs.com/package/@anthropic-ai/claude-code)からインストールされます。Claude Codeはローカルで実行されます。LLMと対話するために、Claude Codeはネットワーク経由でデータを送信します。このデータには、すべてのユーザープロンプトとモデル出力が含まれます。データはTLSを介して転送中に暗号化され、保存時には暗号化されません。Claude Codeはほとんどの一般的なVPNおよびLLMプロキシと互換性があります。

Claude CodeはAnthropicのAPIに基づいて構築されています。APIのセキュリティ制御（APIログ手順を含む）の詳細については、[Anthropic Trust Center](https://trust.anthropic.com)で提供されるコンプライアンスアーティファクトを参照してください。

### クラウド実行：データフローと依存関係

[ウェブ上のClaude Code](/ja/claude-code-on-the-web)を使用する場合、セッションはローカルではなくAnthropicが管理する仮想マシンで実行されます。クラウド環境では：

* \*\*コードとデータストレージ：\*\*リポジトリは分離されたVMにクローンされます。コードとセッションデータは、アカウントタイプのデータ保持および使用ポリシーに従います（上記のデータ保持セクションを参照）
* **認証情報：** GitHub認証はセキュアプロキシを通じて処理されます。GitHubの認証情報はサンドボックスに入りません
* \*\*ネットワークトラフィック：\*\*すべてのアウトバウンドトラフィックはセキュリティプロキシを通じて監査ログと不正使用防止のために処理されます
* \*\*セッションデータ：\*\*プロンプト、コード変更、および出力は、ローカルClaude Code使用と同じデータポリシーに従います

クラウド実行のセキュリティ詳細については、[Security](/ja/security#cloud-execution-security)を参照してください。

## テレメトリサービス

Claude Codeはユーザーのマシンからレイテンシ、信頼性、使用パターンなどの運用メトリックをログするためにStatsigサービスに接続します。このログにはコードやファイルパスは含まれません。データはTLSを使用して転送中に暗号化され、256ビットAES暗号化を使用して保存時に暗号化されます。[Statsigセキュリティドキュメント](https://www.statsig.com/trust/security)で詳細を確認してください。Statsigテレメトリをオプトアウトするには、`DISABLE_TELEMETRY`環境変数を設定します。

Claude Codeはユーザーのマシンから運用エラーログのためにSentryに接続します。データはTLSを使用して転送中に暗号化され、256ビットAES暗号化を使用して保存時に暗号化されます。[Sentryセキュリティドキュメント](https://sentry.io/security/)で詳細を確認してください。エラーログをオプトアウトするには、`DISABLE_ERROR_REPORTING`環境変数を設定します。

ユーザーが`/bug`コマンドを実行すると、コードを含む完全な会話履歴のコピーがAnthropicに送信されます。データは転送中および保存時に暗号化されます。オプションで、公開リポジトリにGithubイシューが作成されます。バグレポートをオプトアウトするには、`DISABLE_BUG_COMMAND`環境変数を設定します。

## APIプロバイダーごとのデフォルト動作

デフォルトでは、BedrockまたはVertexを使用する場合、すべての非必須トラフィック（エラーレポート、テレメトリ、バグレポート機能を含む）を無効にします。`CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC`環境変数を設定することで、これらすべてを一度にオプトアウトすることもできます。以下は完全なデフォルト動作です：

| サービス                       | Claude API                                     | Vertex API                                          | Bedrock API                                          |
| -------------------------- | ---------------------------------------------- | --------------------------------------------------- | ---------------------------------------------------- |
| **Statsig（メトリクス）**         | デフォルトオン。<br />`DISABLE_TELEMETRY=1`で無効化。       | デフォルトオフ。<br />`CLAUDE_CODE_USE_VERTEX`は1である必要があります。 | デフォルトオフ。<br />`CLAUDE_CODE_USE_BEDROCK`は1である必要があります。 |
| **Sentry（エラー）**            | デフォルトオン。<br />`DISABLE_ERROR_REPORTING=1`で無効化。 | デフォルトオフ。<br />`CLAUDE_CODE_USE_VERTEX`は1である必要があります。 | デフォルトオフ。<br />`CLAUDE_CODE_USE_BEDROCK`は1である必要があります。 |
| **Claude API（`/bug`レポート）** | デフォルトオン。<br />`DISABLE_BUG_COMMAND=1`で無効化。     | デフォルトオフ。<br />`CLAUDE_CODE_USE_VERTEX`は1である必要があります。 | デフォルトオフ。<br />`CLAUDE_CODE_USE_BEDROCK`は1である必要があります。 |

すべての環境変数は`settings.json`にチェックインできます（[詳細を確認](/ja/settings)）。
