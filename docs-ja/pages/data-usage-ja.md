> ## Documentation Index
> Fetch the complete documentation index at: https://code.claude.com/docs/llms.txt
> Use this file to discover all available pages before exploring further.

# データ使用

> Anthropic の Claude のデータ使用ポリシーについて学習します

## データポリシー

### データトレーニングポリシー

**コンシューマーユーザー（Free、Pro、Max、Ultra プラン）**：
データを将来の Claude モデルの改善に使用することを許可するかどうかを選択できます。この設定がオンになっている場合、Free、Pro、Max、Ultra アカウントのデータ（これらのアカウントから Claude Code を使用する場合を含む）を使用して新しいモデルをトレーニングします。

**商用ユーザー**：（Team および Enterprise プラン、API、サードパーティプラットフォーム、Claude Gov）には既存のポリシーが引き続き適用されます。顧客がモデル改善のためにデータを提供することを選択した場合（たとえば [Developer Partner Program](https://support.claude.com/en/articles/11174108-about-the-development-partner-program)）を除き、Anthropic は商用規約の下で Claude Code に送信されたコードやプロンプトを使用して生成モデルをトレーニングすることはありません。

### Development Partner Program

[Development Partner Program](https://support.claude.com/en/articles/11174108-about-the-development-partner-program) などを通じて、トレーニング用の素材を提供する方法に明示的にオプトインした場合、提供された素材をモデルのトレーニングに使用することがあります。組織の管理者は、組織として Development Partner Program に明示的にオプトインできます。このプログラムは Anthropic のファーストパーティ API でのみ利用可能であり、Amazon Bedrock または Google Cloud の Agent Platform のユーザーは利用できません。

### `/feedback` コマンドによるフィードバック

`/feedback` コマンドを使用して Claude Code に関するフィードバックを送信することを選択した場合、そのフィードバックを製品やサービスの改善に使用することがあります。`/feedback`、または同じ経路で報告される `/bug` および `/share` を通じて共有されたトランスクリプトは 5 年間保持されます。

[Claude が作成するフィードバック](https://code.claude.com/docs/ja/tools-reference.md#sendfeedback-tool-behavior)では、Claude がフィードバックレポートの下書きを作成し、ユーザーが確認できるようにマシン上のキューに入れることもできます。ユーザーが下書きの送信を選択するまで Claude Code は何も送信せず、送信された下書きは他の `/feedback` レポートと同じ送信経路と保持期間が適用されます。

### セッション品質アンケート

Claude Code で「How is Claude doing this session?」というプロンプトが表示された場合、このアンケートへの回答（「Dismiss」の選択を含む）では評価のみが記録されます。評価プロンプト自体の一部として、会話のトランスクリプト、入力、出力、その他のセッションデータを収集または保存することはありません。高評価/低評価のフィードバックや `/feedback` レポートとは異なり、このセッション品質アンケートは単純な製品満足度の指標です。

評価プロンプトの後に、「Can Anthropic look at your session transcript to help us improve Claude Code?」と尋ねる別のフォローアップが表示される場合があります。これは評価とは別の、任意の 2 番目のステップです。

* **Yes**：会話のトランスクリプト、すべてのサブエージェントのトランスクリプト、およびディスク上の生のセッションログファイルを Anthropic にアップロードします。既知の API キーおよびトークンのパターンはアップロード前に編集されます。ソースコード、ファイルの内容、その他の会話内容はそのままアップロードされます。共有されたトランスクリプトは最大 6 か月間保持されます。Amazon Bedrock、Google Cloud の Agent Platform、Microsoft Foundry、およびサインイン済みの [Claude apps gateway](https://code.claude.com/docs/ja/claude-apps-gateway) のセッションでは、Yes を選択するとアップロードする代わりに同じペイロードが `~/.claude/feedback-bundles/` 配下のローカルアーカイブに書き込まれます。そのファイルを転送するまで、マシンから何も送信されません。
* **No**：何も送信せずに辞退します
* **Don't ask again**：辞退し、今後のセッションでこのフォローアップが表示されないようにします

明示的に **Yes** を選択しない限り、何もアップロードされません。[ゼロデータ保持](https://code.claude.com/docs/ja/zero-data-retention.md)が適用されている組織、組織のポリシーで製品フィードバックが無効になっている組織、または `CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC` が設定されている組織では、このフォローアップは表示されません。評価プロンプトの後に送信されたセッショントランスクリプトを含め、このアンケートへの回答はデータトレーニングの設定に影響せず、AI モデルのトレーニングに使用されることはありません。

これらのアンケートを無効にするには、`CLAUDE_CODE_DISABLE_FEEDBACK_SURVEY=1` を設定します。`DISABLE_TELEMETRY`、`DO_NOT_TRACK`、または `CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC` が設定されている場合も、アンケートは無効になります。不要なトラフィックをブロックしつつ、独自の [OpenTelemetry コレクター](https://code.claude.com/docs/ja/monitoring-usage.md)でアンケートの回答を収集している組織は、`CLAUDE_CODE_ENABLE_FEEDBACK_SURVEY_FOR_OTEL=1` を設定することでアンケートを再度有効にできます。その場合、アンケートは設定されたコレクターにのみ評価をログに記録します。トランスクリプト共有のフォローアップと、Anthropic 宛てのその他すべてのフィードバックトラフィックは無効のままです。無効にする代わりに頻度を制御するには、設定ファイルで [`feedbackSurveyRate`](https://code.claude.com/docs/ja/settings-reference#feedbacksurveyrate) を `0` から `1` の間の確率に設定します。

### データ保持

Anthropic は、アカウントの種類と設定に基づいて Claude Code のデータを保持します。

**コンシューマーユーザー（Free、Pro、Max、Ultra プラン）**：

* モデル改善のためのデータ使用を許可しているユーザー：モデル開発と安全性の向上をサポートするため、保持期間は 5 年間です
* モデル改善のためのデータ使用を許可していないユーザー：保持期間は 30 日間です
* プライバシー設定は [claude.ai/settings/data-privacy-controls](https://claude.ai/settings/data-privacy-controls) でいつでも変更できます。

**商用ユーザー（Team、Enterprise、API）**：

* 標準：保持期間は 30 日間です
* [ゼロデータ保持](https://code.claude.com/docs/ja/zero-data-retention.md)：Claude for Enterprise 上の Claude Code について、条件を満たすアカウントで利用できます。ZDR は標準の Enterprise プランには含まれていません。資格の確認後、アカウントチームによって組織ごとに有効化されます
* ローカルキャッシュ：Claude Code クライアントは、セッションを再開できるように、セッショントランスクリプトをデフォルトで 30 日間 `~/.claude/projects/` 配下にプレーンテキストでローカルに保存します。期間は `cleanupPeriodDays` で調整できます。保存される内容と削除方法については、[アプリケーションデータ](https://code.claude.com/docs/ja/claude-directory.md#application-data)を参照してください。

  Claude Desktop または Cowork で開始された、または最後に続行されたセッションのトランスクリプトは、[デフォルトでこの制限の対象外](https://code.claude.com/docs/ja/claude-directory.md#cleaned-up-automatically)です。

個々のクラウドセッションはいつでも削除できます。セッションを削除すると、そのセッションのイベントデータは完全に削除されます。セッションの削除方法については、[セッションの削除](https://code.claude.com/docs/ja/claude-code-on-the-web.md#delete-sessions)を参照してください。

データ保持の取り組みの詳細については、[Privacy Center](https://privacy.anthropic.com/) をご覧ください。

詳細については、[商用利用規約](https://www.anthropic.com/legal/commercial-terms)（Team、Enterprise、API ユーザー向け）または[コンシューマー規約](https://www.anthropic.com/legal/consumer-terms)（Free、Pro、Max、Ultra ユーザー向け）、および[プライバシーポリシー](https://www.anthropic.com/legal/privacy)をご確認ください。

## データアクセス

すべてのファーストパーティユーザーの場合、[ローカル Claude Code](#local-claude-code-data-flow-and-dependencies) および [リモート Claude Code](#cloud-execution-data-flow-and-dependencies) に対してログされるデータについて詳しく知ることができます。[Remote Control](https://code.claude.com/docs/ja/remote-control.md) セッションは、すべての実行がマシン上で行われるため、ローカルデータフローに従います。接続中、セッショントランスクリプトは [Connection and security](https://code.claude.com/docs/ja/remote-control.md#connection-and-security) に記載されているように、デバイス間で会話を同期するために Anthropic サーバーにも保存されます。リモート Claude Code の場合、Claude は Claude Code セッションを開始するリポジトリにアクセスします。Claude は接続したが、セッションを開始していないリポジトリにはアクセスしません。

## ローカル Claude Code：データフローと依存関係

下の図は、Claude Code がインストール中および通常の操作中に外部サービスにどのように接続するかを示しています。実線は必須の接続を示し、破線はオプションまたはユーザーが開始するデータフローを表します。

![Claude Code の外部接続を示す図：インストール/更新は配布サーバーに接続し、ユーザーリクエストは Anthropic の Console 認証と public-api に接続します。オプションのテレメトリフローはメトリクスとエラーレポートを Anthropic とサードパーティサービスに送信します。/feedback で送信されたフィードバックは Google Cloud Storage に送信され、オプションで GitHub issue を作成します](https://mintcdn.com/claude-code/YR4DRZyI3CdsXkiT/images/claude-code-data-flow.svg?fit=max\&auto=format\&n=YR4DRZyI3CdsXkiT\&q=85\&s=2846ea92cfc2297b8620c31c82b482ad)

Claude Code はローカルで実行されます。LLM と相互作用するために、Claude Code はネットワーク経由でデータを送信します。このデータには、すべてのユーザープロンプトとモデル出力が含まれ、TLS 1.2 以上で転送中に暗号化されます。Claude Code はほとんどの一般的な VPN と LLM プロキシと互換性があります。

保存時の暗号化はモデルプロバイダーによって異なります：

| プロバイダー | 保存時の暗号化 |
| - | - |
| Anthropic API | インフラストラクチャレベルのディスク暗号化（AES-256）。サーバー側の永続化がないようにするには、[Zero Data Retention](https://code.claude.com/docs/ja/zero-data-retention.md) を有効にしてください。 |
| Amazon Bedrock | AWS 管理キーを使用した AES-256。AWS KMS 経由でカスタマー管理キーを利用可能です。 |
| Google Cloud の Agent Platform | Google 管理の暗号化キー。CMEK を利用可能です。 |
| Microsoft Foundry | デプロイメントの[ホスティングオプション](https://platform.claude.com/docs/en/build-with-claude/claude-in-microsoft-foundry#hosting-options)によって異なります。Azure でホストされているデプロイメントの場合、プロンプトと完了は Azure 内に留まり、使用状況メタデータと Anthropic のセーフティシステムでフラグが付けられたコンテンツのみが Anthropic に送信されます。Anthropic でホストされているデプロイメントの場合、リクエストは AES-256 ディスク暗号化を使用して Anthropic インフラストラクチャにルーティングされます。 |

Claude Code は Anthropic の API 上に構築されています。API ロギング手順を含む API セキュリティコントロールの詳細については、[Anthropic Trust Center](https://trust.anthropic.com) のコンプライアンスアーティファクトを参照してください。

### クラウド実行：データフローと依存関係

[クラウドセッション](https://code.claude.com/docs/ja/claude-code-on-the-web.md)は、デフォルトではローカルではなく Anthropic 管理の仮想マシンで実行されます。組織が[自己ホスト環境](https://code.claude.com/docs/ja/self-hosted-environments)にルーティングするセッションは、制御するインフラストラクチャ上で実行されます。マシン上に留まるもの、および Anthropic に送信されるものについては、[インフラストラクチャに留まるもの](https://code.claude.com/docs/ja/self-hosted-environments#what-stays-on-your-infrastructure)を参照してください。Anthropic ホスト型クラウドセッションでは：

* **コードとデータストレージ：** リポジトリは分離された VM にクローンされます。Anthropic はセッショントランスクリプトを保存して、後でセッションに戻ることができるようにします。コードとセッションデータは、アカウントタイプの[保持および使用ポリシー](#data-retention)の対象となります
* **認証情報：** GitHub 認証情報は Anthropic のサーバーに暗号化されて保存され、VM に入ることはありません。VM からの GitHub トラフィックは、Anthropic プロキシを通じて送信され、サーバー側でそれらを接続します
* **ネットワークトラフィック：** すべてのアウトバウンドトラフィックは、監査ログと不正使用防止のためのセキュリティプロキシを通じて送信されます
* **セッションデータ：** プロンプト、コード変更、および出力は、ローカル Claude Code 使用と同じデータポリシーに従います

クラウド実行のセキュリティの詳細については、[セキュリティ](https://code.claude.com/docs/ja/security.md#cloud-execution-security)を参照してください。

## テレメトリサービス

Claude Code は 2 種類の運用テレメトリを送信します。使用メトリクスとエラーレポートです。以下の環境変数を使用して各々をオフにすることができます。または `CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC` を設定することで、すべての非必須トラフィックを一度に無効にできます。`DISABLE_TELEMETRY` または `CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC` を設定すると、[Remote Control](https://code.claude.com/docs/ja/remote-control.md#requirements) が依存するフィーチャーフラグ評価も無効になります。`DISABLE_ERROR_REPORTING` はそうではありません。

**メトリクス**：レイテンシ、信頼性、使用パターンは、Anthropic およびサードパーティのログインフラストラクチャに TLS 経由で送信されます。メトリクスにはコード、プロンプト、またはファイルパスが含まれることはありません。`DISABLE_TELEMETRY=1` を設定してオプトアウトします。

**エラーレポート**：Claude Code の内部からのエラーメッセージとスタックトレースは、TLS 経由でサードパーティのエラー追跡サービスに送信されます。Claude Code は、マシンから何かが出ていく前に、既知のシークレット、ファイルパス、メールアドレス、およびその他の個人情報のパターンを削除します。`DISABLE_ERROR_REPORTING=1` を設定してオプトアウトします。

エラーレポートは、以下のすべてが当てはまる場合にのみオンになります。

* Claude Pro、Max、または Ultra サブスクリプションでサインインしている
* Claude Code v2.1.198 以降を実行している
* Claude API に直接接続している
* 組織がゼロデータ保持または HIPAA 契約を持っていない

`/feedback` コマンドを実行すると、コードを含む会話履歴のコピーが Anthropic に送信されます。`/bug` および `/share` コマンドは同じパスを通じて送信されます。フィードバックダイアログからレポートを送信する前に、含める履歴の量を選択します。デフォルトは現在のセッションのみですが、同じプロジェクトの過去 24 時間または 7 日間の他のセッションも含めることができます。Claude Code は [Claude が作成したフィードバック](https://code.claude.com/docs/ja/tools-reference.md#sendfeedback-tool-behavior) を同じパスを通じて送信します。ドラフトのレビュー画面で含めることを選択した場合、トランスクリプトを含めます。データは TLS 経由で転送中に暗号化され、Google Cloud Storage に保存されます。Google Cloud Storage はデフォルトで保存時のデータを暗号化します。オプションで、公開リポジトリに GitHub イシューが作成されます。オプトアウトするには、`DISABLE_FEEDBACK_COMMAND` 環境変数を `1` に設定します。

Amazon Bedrock や Google Cloud の Agent Platform などのサードパーティプロバイダーを使用している場合、または Anthropic 認証情報が設定されていない場合、`/feedback` はレポートを Anthropic に送信する代わりに、`~/.claude/feedback-bundles/` の下のローカルアーカイブに書き込みます。既知の API キーおよびトークンパターンは、アーカイブが書き込まれる前に削除されます。Anthropic アカウント担当者にファイルを送信するか、サポートリクエストに添付するまで、何もマシンから出ません。

## API プロバイダーのデフォルト動作

デフォルトでは、Amazon Bedrock、Google Cloud の Agent Platform、Microsoft Foundry、または Claude Platform on AWS を使用する場合、エラーレポート、テレメトリ、およびバグレポートは無効になります。セッション品質調査と WebFetch ドメインセーフティチェックは例外であり、プロバイダーに関係なく実行されます。署名済みの [Claude apps gateway](https://code.claude.com/docs/ja/claude-apps-gateway) セッションでは、Anthropic への使用分析、エラーレポート、および調査評価はゲートウェイ認証情報自体によって無効になり、それらを再度有効にする設定はありません。`CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC` を設定することで、調査を含むすべての非必須トラフィックをオプトアウトできます。この変数は WebFetch チェックや公式プラグインマーケットプレイスの自動インストールに影響を与えません。それぞれに独自のオプトアウトがあります。WebFetch の場合は [settings](https://code.claude.com/docs/ja/settings.md) の `skipWebFetchPreflight`、マーケットプレイスの場合は `CLAUDE_CODE_DISABLE_OFFICIAL_MARKETPLACE_AUTOINSTALL` です。以下は完全なデフォルト動作です：

| サービス | Claude API | Google Cloud の Agent Platform API | Amazon Bedrock API | Microsoft Foundry API | Claude Platform on AWS |
| - | - | - | - | - | - |
| **メトリクス** | デフォルトオン。 `DISABLE_TELEMETRY=1` で無効にします。 | デフォルトオフ。 `CLAUDE_CODE_USE_VERTEX` は 1 である必要があります。 | デフォルトオフ。 `CLAUDE_CODE_USE_BEDROCK` は 1 である必要があります。 | デフォルトオフ。 `CLAUDE_CODE_USE_FOUNDRY` は 1 である必要があります。 | デフォルトオフ。 `CLAUDE_CODE_USE_ANTHROPIC_AWS` は 1 である必要があります。 |
| **エラーレポート** | v2.1.198 以降の Pro、Max、および Ultra サインインではオン、それ以外はオフ。 `DISABLE_ERROR_REPORTING=1` で無効にします。 | デフォルトオフ。 `CLAUDE_CODE_USE_VERTEX` は 1 である必要があります。 | デフォルトオフ。 `CLAUDE_CODE_USE_BEDROCK` は 1 である必要があります。 | デフォルトオフ。 `CLAUDE_CODE_USE_FOUNDRY` は 1 である必要があります。 | デフォルトオフ。 `CLAUDE_CODE_USE_ANTHROPIC_AWS` は 1 である必要があります。 |
| **Claude API（`/feedback` レポート）** | デフォルトオン。 `DISABLE_FEEDBACK_COMMAND=1` で無効にします。 | デフォルトオフ。 `CLAUDE_CODE_USE_VERTEX` は 1 である必要があります。 | デフォルトオフ。 `CLAUDE_CODE_USE_BEDROCK` は 1 である必要があります。 | デフォルトオフ。 `CLAUDE_CODE_USE_FOUNDRY` は 1 である必要があります。 | デフォルトオフ。 `CLAUDE_CODE_USE_ANTHROPIC_AWS` は 1 である必要があります。 |
| **セッション品質調査** | デフォルトオン。 `CLAUDE_CODE_DISABLE_FEEDBACK_SURVEY=1` で無効にします。 | デフォルトオン。 `CLAUDE_CODE_DISABLE_FEEDBACK_SURVEY=1` で無効にします。 | デフォルトオン。 `CLAUDE_CODE_DISABLE_FEEDBACK_SURVEY=1` で無効にします。 | デフォルトオン。 `CLAUDE_CODE_DISABLE_FEEDBACK_SURVEY=1` で無効にします。 | デフォルトオン。 `CLAUDE_CODE_DISABLE_FEEDBACK_SURVEY=1` で無効にします。 |
| **WebFetch ドメインセーフティチェック** | デフォルトオン。 [settings](https://code.claude.com/docs/ja/settings.md) で `skipWebFetchPreflight: true` で無効にします。 | デフォルトオン。 [settings](https://code.claude.com/docs/ja/settings.md) で `skipWebFetchPreflight: true` で無効にします。 | デフォルトオン。 [settings](https://code.claude.com/docs/ja/settings.md) で `skipWebFetchPreflight: true` で無効にします。 | デフォルトオン。 [settings](https://code.claude.com/docs/ja/settings.md) で `skipWebFetchPreflight: true` で無効にします。 | デフォルトオン。 [settings](https://code.claude.com/docs/ja/settings.md) で `skipWebFetchPreflight: true` で無効にします。 |

すべての環境変数は `settings.json` にチェックインできます（[settings reference](https://code.claude.com/docs/ja/settings-reference.md) を参照）。

ホストプラットフォームが `CLAUDE_CODE_PROVIDER_MANAGED_BY_HOST` を設定する場合、メトリクスは Google Cloud の Agent Platform、Amazon Bedrock、Microsoft Foundry、および Claude Platform on AWS でデフォルトでオンになり、標準の `DISABLE_TELEMETRY` オプトアウトに従います。エラーレポートと `/feedback` レポートは、これらのプロバイダーではデフォルトでオフのままです。

### WebFetch ドメインセーフティチェック

URL をフェッチする前に、WebFetch ツールは要求されたホスト名を `api.anthropic.com` に送信して、Anthropic が管理するセーフティブロックリストに対してチェックします。ホスト名のみが送信され、完全な URL、パス、またはページコンテンツは送信されません。Claude Code はチェックに合格したホスト名を 5 分間キャッシュし、ブロックされたまたは失敗したホスト名は次のリクエストで再チェックします。

このチェックは、使用するモデルプロバイダーに関係なく実行され、`CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC` の影響を受けません。ネットワークが `api.anthropic.com` をブロックしている場合、WebFetch リクエストはドメインをホワイトリストに登録するか、[settings](https://code.claude.com/docs/ja/settings.md) で `skipWebFetchPreflight: true` を設定するまで失敗します。チェックを無効にすると、WebFetch はブロックリストに相談せずに任意の URL を取得しようとするため、Claude が到達できるドメインを制限する必要がある場合は [`WebFetch` permission rules](https://code.claude.com/docs/ja/permissions#webfetch) と組み合わせてください。
