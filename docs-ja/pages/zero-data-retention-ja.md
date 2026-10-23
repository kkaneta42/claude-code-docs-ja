> ## Documentation Index
> Fetch the complete documentation index at: https://code.claude.com/docs/llms.txt
> Use this file to discover all available pages before exploring further.

# ゼロデータ保持

> Claude for Enterprise の適格なアカウントで利用可能な Claude Code のゼロデータ保持（ZDR）について、スコープ、無効化される機能、有効化のリクエスト方法を学びます。

Claude Code のゼロデータ保持（ZDR）は、Claude for Enterprise の適格なアカウントで利用可能です。ZDR が有効になると、Claude Code セッション中に生成されたプロンプトとモデル応答はリアルタイムで処理され、法令遵守またはミスユース対策が必要な場合を除き、応答が返された後は Anthropic によって保存されません。

> [!NOTE]
>
> ZDR は標準的な Claude for Enterprise プランに含まれておらず、管理者設定から有効化することはできません。適格なアカウントで利用可能であり、Anthropic による個別の有効化が必要です。組織が ZDR を必要とする場合は、[営業に連絡](https://www.anthropic.com/contact-sales?utm_source=claude_code\&utm_medium=docs\&utm_content=zero_data_retention_request)するか、Anthropic アカウントチームに連絡して適格性を確認してください。

HIPAA を有効にした Claude for Enterprise の組織は、HIPAA 設定を Claude Code（ローカルモード）と Cowork（ローカルモード）に適用すると、ZDR なしで Claude Code CLI と Claude Desktop の Code タブをビジネスアソシエイト契約（BAA）の対象にできます。[HIPAA 対応組織向けに Claude Code（ローカルモード）をセットアップする](/docs/ja/hipaa-setup.md)を参照してください。HIPAA 設定のない組織では、Claude Code を BAA の対象とするために引き続き ZDR が必要です。対象サービス（Eligible Services）の一覧については、[実装ガイド](https://trust.anthropic.com/resources?s=l1wrssd9hsbi4gak0tp5a6\&name=%5Banthropic%5D-hipaa-ready-offering-implementation-guide)を参照してください。

Claude for Enterprise 上の ZDR により、エンタープライズカスタマーは Claude Code をゼロデータ保持で使用し、管理機能にアクセスできます：

* ユーザーごとのコスト管理
* [Analytics](/docs/ja/analytics.md) ダッシュボード
* [Server-managed settings](/docs/ja/server-managed-settings.md)
* 監査ログ

Claude for Enterprise 上の Claude Code の ZDR は、Anthropic の直接プラットフォームにのみ適用されます。Amazon Bedrock、Google Cloud の Agent Platform、または Microsoft Foundry 上の Claude のデプロイについては、これらのプラットフォームのデータ保持ポリシーを参照してください。

## ZDR スコープ

ZDR は Claude for Enterprise 上の Claude Code 推論をカバーします。

> [!WARNING]
>
> ZDR は組織ごとに有効化されます。新しい各組織では、Anthropic アカウントチームによって ZDR を個別に有効化する必要があります。ZDR は同じアカウントの下に作成された新しい組織に自動的に適用されません。新しい組織に対して ZDR を有効化するには、アカウントチームに連絡してください。

### Claude Code トラフィックを ZDR 組織にルーティングする

ZDR は ZDR が有効化された組織に認証するリクエストに適用されます。開発者が個人アカウントまたは別の組織の API キーで Claude Code にサインインした場合、これらのセッションはカバーされません。開発者の claude.ai ログインが ZDR 組織に属することを要求するには、`forceLoginMethod` および `forceLoginOrgUUID` マネージド設定をデプロイしてください。[組織へのログインを制限する](/docs/ja/authentication.md#restrict-login-to-your-organization)を参照してください。このセクションでは、これらのキーが Claude Console ログインをどのように扱うかについても説明しています。

### ZDR がカバーする内容

ZDR は Claude for Enterprise 上の Claude Code を通じて行われたモデル推論呼び出しをカバーします。ターミナルで Claude Code を使用する場合、送信するプロンプトと Claude が生成する応答は Anthropic によって保持されません。これは、ZDR 組織で利用可能なすべてのモデルに適用されます。一部のモデルはデータ保持をデフォルトで必要とします。[ZDR でのモデル利用可能性](#model-availability-under-zdr)を参照してください。

### ZDR がカバーしない内容

ZDR は、ZDR が有効化されている組織であっても、以下には適用されません。これらの機能は[標準データ保持ポリシー](/docs/ja/data-usage.md#data-retention)に従います：

| 機能 | 詳細 |
| - | - |
| claude.ai 上のチャット | Claude for Enterprise ウェブインターフェース経由のチャット会話は ZDR でカバーされません。 |
| Cowork | Cowork セッションは ZDR でカバーされません。 |
| Claude Code Analytics | プロンプトまたはモデル応答を保存しませんが、アカウントメールや使用統計などの生産性メタデータを収集します。貢献メトリクスは ZDR 組織では利用できません。[analytics ダッシュボード](/docs/ja/analytics.md)は使用メトリクスのみを表示します。 |
| ユーザーとシート管理 | アカウントメールやシート割り当てなどの管理データは標準ポリシーの下で保持されます。 |
| サードパーティ統合 | サードパーティツール、MCP servers、またはその他の外部統合によって処理されたデータは ZDR でカバーされません。これらのサービスのデータ処理慣行を独立して確認してください。 |

## ZDR の下で無効化される機能

Claude for Enterprise 上の Claude Code 組織に対して ZDR が有効化されると、プロンプトまたは完了を保存する必要がある特定の機能はバックエンドレベルで自動的に無効化されます：

| 機能 | 理由 |
| - | - |
| [Web 上の Claude Code](/docs/ja/claude-code-on-the-web.md)（[Desktop アプリ](/docs/ja/desktop.md#cloud-sessions)から開始されたものを含む） | セッションデータのサーバー側ストレージが必要です。これには、プロンプトと完了を含む会話履歴が含まれます。 |
| [Chat と Cowork の統合](https://support.claude.com/en/articles/17444462-set-up-and-manage-the-new-unified-claude-experience-for-your-enterprise-organization) | クラウドセッションが必要です。 |
| [Claude Tag](https://claude.com/docs/claude-tag) | チャネルメモリとセッショントランスクリプトを保持します。 |
| [Artifacts](/docs/ja/artifacts.md) | Anthropic が運用するインフラストラクチャに公開されたページコンテンツを保存する必要があります。 |
| フィードバック送信（`/feedback`、`/bug`、`/share`） | フィードバックを送信すると、会話データが Anthropic に送信されます。 |
| [Remote Control](/docs/ja/remote-control.md) | Anthropic サーバーにセッショントランスクリプトを保存して、デバイス間で会話を同期します。 |

これらの機能はクライアント側の表示に関係なく、バックエンドでブロックされます。Claude Code ターミナルの起動中に無効化された機能が表示される場合、それを使用しようとするとエラーが返され、組織のポリシーがそのアクションを許可していないことが示されます。

プロンプトまたは完了を保存する必要がある場合、将来の機能も無効化される可能性があります。

### ZDR の下でのモデルの利用可能性

Claude Fable 5.1 と Fable 5 は、[対象モデル](https://support.claude.com/en/articles/15425695-covered-models)であり、デフォルトで[データ保持が必要](https://platform.claude.com/docs/en/manage-claude/api-and-data-retention#model-specific-data-retention-requirements)です。ZDR 組織またはワークスペースがそれらを使用できるかどうかは、Claude Code ではなく対象モデルポリシーによって管理されます。組織がそれらを使用できない場合、モデルは `/model` ピッカーに表示されないか、無効化として表示され、クライアント設定に関係なくサーバーはそれに対するリクエストを拒否します。

その他のモデルは ZDR の下で利用可能なままです。Fable モデルはデフォルトではなく、利用可能な場所では最新の Fable モデルに解決される `best` エイリアスは、利用できない組織では Opus に解決されます。

## ポリシー違反のためのデータ保持

ZDR が有効化されている場合でも、法律で必要な場合または Usage Policy 違反に対処するために、Anthropic はデータを保持する場合があります。セッションがポリシー違反でフラグが立てられた場合、Anthropic は関連する入力と出力を最大 2 年間保持する場合があり、これは Anthropic の標準 ZDR ポリシーと一致しています。

## ZDR をリクエストする

Claude for Enterprise 上の Claude Code に対して ZDR をリクエストするには、[営業に連絡](https://www.anthropic.com/contact-sales?utm_source=claude_code\&utm_medium=docs\&utm_content=zero_data_retention_request)するか、Anthropic アカウントチームに連絡してください。アカウントチームが内部でリクエストを送信し、Anthropic は適格性を確認した後、組織に対して ZDR を確認して有効化します。すべての有効化アクションは監査ログに記録されます。

現在、従量課金制 API キーを介して Claude Code に対して ZDR を使用している場合、Claude for Enterprise に移行して、Claude Code の ZDR を維持しながら管理機能にアクセスできます。移行を調整するには、アカウントチームに連絡してください。
