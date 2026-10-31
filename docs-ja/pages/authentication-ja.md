> ## Documentation Index
> Fetch the complete documentation index at: https://code.claude.com/docs/llms.txt
> Use this file to discover all available pages before exploring further.

# 認証

> Claude Code にログインし、個人、チーム、組織向けの認証を設定します。

Claude Code は、セットアップに応じて複数の認証方法をサポートしています。個人ユーザーは claude.ai アカウントでログインでき、チームは Claude for Teams または Enterprise、Claude Console、または Amazon Bedrock、Google Cloud の Agent Platform、Microsoft Foundry などのクラウドプロバイダーを使用できます。

## Claude Code にログインする

[Claude Code をインストール](https://code.claude.com/docs/ja/setup.md#install-claude-code)した後、ターミナルで `claude` を実行します。初回起動時に、Claude Code はログインするためのブラウザウィンドウを開きます。ただし、次のような場合はログインプロンプトをスキップできます。

* **API キー**: `ANTHROPIC_API_KEY` 環境変数を設定していて、そのキーを使用するかどうかを Claude Code に尋ねられたときにキーを承認した場合
* **以前のサインイン**: 最初のセッションの前にシェルで [`claude auth login`](https://code.claude.com/docs/ja/cli-reference#cli-commands) を実行した場合、または認証情報を[ボリューム](https://code.claude.com/docs/ja/devcontainer.md#persist-authentication-and-settings-across-rebuilds)に保持する開発コンテナを再ビルドした場合。それでもログインプロンプトが表示される場合は、[考えられる原因を確認してください](#login-prompt-still-appears-after-an-earlier-sign-in)。

ブラウザが自動的に開かない場合は、`c` を押してログイン URL をクリップボードにコピーし、ブラウザに貼り付けます。

ブラウザがサインイン後にリダイレクトされずにログインコードを表示する場合は、`Paste code here if prompted` プロンプトでそれをターミナルに貼り付けます。

ログインが完了すると、ターミナルに `Login successful` と表示され、`Enter` キーを押して続行するよう求められます。

以下のいずれかのアカウントタイプで認証できます。

* **Claude Pro、Max、または Ultra サブスクリプション**: claude.ai アカウントでログインします。[claude.com/pricing](https://claude.com/pricing?utm_source=claude_code\&utm_medium=docs\&utm_content=authentication_pro_max) で購読してください。
* **Claude for Teams または Enterprise**: チーム管理者が招待した claude.ai アカウントでログインします。
* **Claude Console**: Console 認証情報でログインします。管理者が事前に[招待](#claude-console-authentication)している必要があります。[API キーを作成せずにサインイン](#sign-in-without-an-api-key)することも、API キーを作成することもできます。
* **クラウドプロバイダー**: 組織が [Amazon Bedrock](https://code.claude.com/docs/ja/amazon-bedrock.md)、[Google Cloud の Agent Platform](https://code.claude.com/docs/ja/google-vertex-ai.md)、または [Microsoft Foundry](https://code.claude.com/docs/ja/microsoft-foundry.md) を使用している場合は、`claude` を実行する前に必要な環境変数を設定するか、ログインプロンプトで **3rd-party platform** を選択してください。これにより、Bedrock と Vertex AI 向けのインタラクティブセットアップウィザードが起動します。ブラウザログインは不要です。
* **Cloud gateway**: 組織がセルフホストされた [Claude apps gateway](https://code.claude.com/docs/ja/claude-apps-gateway) を実行している場合は、`/login` を通じて企業 SSO でサインインします。ゲートウェイが発行したトークンはセッションの唯一の認証情報です。

管理者は、どのログイン方法を開発者が使用するかを指定し、claude.ai ログインが特定の組織に属することを要求できます。[ログインを組織に制限する](#restrict-login-to-your-organization)を参照してください。

ログアウトして再認証するには、Claude Code プロンプトで `/logout` と入力します。ログアウトすると、初回起動セットアップ状態もリセットされるため、次回 `claude` を実行するときはログインとセットアップを再度実行します。

ログインに問題がある場合は、[認証のトラブルシューティング](https://code.claude.com/docs/ja/troubleshoot-install.md#login-and-authentication)を参照してください。

### 以前にサインインしたのにログインプロンプトが表示される

以前にサインインしたにもかかわらず、初回起動セットアップでログインプロンプトが[スキップされず](#log-in-to-claude-code)に表示される場合は、次のような原因がないか確認してください。

* **サインインの有効期限切れ**: 以前のサインインの有効期限が切れており、Claude Code がそれを更新できません。プロンプトで再度ログインしてください。
* **組織に制限されたログイン**: 管理者が管理設定で [`forceLoginOrgUUID`](https://code.claude.com/docs/ja/settings-reference#forceloginorguuid) を設定し、[特定の組織からのログインを要求](#restrict-login-to-your-organization)しています。このプロンプトは、アカウントがそれらの組織のいずれかに属しているかどうかにかかわらず表示されます。要求されている組織のアカウントでログインしてください。該当するアカウントがない場合は、管理者に追加を依頼してください。
* **必須のログイン方法**: サインインが、設定ファイル内の [`forceLoginMethod`](https://code.claude.com/docs/ja/settings-reference#forceloginmethod) が要求する種類ではありません。`"claudeai"` の場合、以前の Claude Console ログインによる API キーは既存のサインインとして扱われません。`"console"` の場合、claude.ai アカウントは既存のサインインとして扱われません。その設定で指定された種類のアカウントでログインしてください。
* **古いバージョン**: v2.1.290 より前では、サインインしているかどうかにかかわらず、セットアップ中にプロンプトが表示されていました。スキップするには [Claude Code を更新](https://code.claude.com/docs/ja/setup.md#update-claude-code)してください。

### 複数のアカウントでログインする

複数のアカウント（仕事用と個人用など）に同時にログインしたままにするには、各アカウントに独自の設定ディレクトリを指定します。`claude` を起動するときに、[`CLAUDE_CONFIG_DIR`](https://code.claude.com/docs/ja/env-vars#variables) 環境変数を使用するアカウントのディレクトリに設定します。各ディレクトリには、独自の設定、セッション履歴、および claude.ai ログインまたは API キーがあります。たとえば、Bash または Zsh では、`~/.bashrc` または `~/.zshrc` に次のエイリアスを追加して、`claude-work` が仕事用アカウントを使用し、`claude` が個人用アカウントを保持するようにできます。

```bash theme={null}
alias claude-work='CLAUDE_CONFIG_DIR=~/.claude-work claude'
```

新しいターミナルを開いて初めて `claude-work` を実行した後、Claude Code は新しいディレクトリのログインとセットアップを実行します。別のディレクトリは、Claude Code がそのような種類のサインインを設定ディレクトリの外に保存するため、2 つの Claude Console サインイン[API キーなし](#sign-in-without-an-api-key)を区別しません。

## チーム認証を設定する

チームと組織の場合、Claude Code アクセスを以下のいずれかの方法で設定できます。

* [Claude for Teams または Enterprise](#claude-for-teams-or-enterprise)（ほとんどのチームに推奨）
* [Claude Console](#claude-console-authentication)
* [Claude apps gateway](https://code.claude.com/docs/ja/claude-apps-gateway)（開発者を IdP でサインインさせ、設定したクラウドプロバイダーに推論をルーティングする自己ホスト型ゲートウェイ）
* [Amazon Bedrock](https://code.claude.com/docs/ja/amazon-bedrock.md)
* [Google Cloud の Agent Platform](https://code.claude.com/docs/ja/google-vertex-ai.md)
* [Microsoft Foundry](https://code.claude.com/docs/ja/microsoft-foundry.md)

### Claude for Teams または Enterprise

[Claude for Teams](https://claude.com/pricing?utm_source=claude_code\&utm_medium=docs\&utm_content=authentication_teams#team-&-enterprise) と [Claude for Enterprise](https://anthropic.com/contact-sales?utm_source=claude_code\&utm_medium=docs\&utm_content=authentication_enterprise) は、Claude Code を使用する組織に最適なエクスペリエンスを提供します。チームメンバーは Claude Code と Web 上の Claude の両方にアクセスでき、一元化された請求とチーム管理が可能です。

* **Claude for Teams**: コラボレーション機能、管理ツール、SSO、請求管理、および組織全体の Claude Code 設定のための [サーバー管理設定](https://code.claude.com/docs/ja/server-managed-settings.md)を備えたセルフサービスプラン。小規模なチームに最適です。
* **Claude for Enterprise**: ドメインキャプチャ、ロールベースの権限、およびコンプライアンス API を追加します。セキュリティとコンプライアンス要件を持つ大規模な組織に最適です。

**1. 購読**

[Claude for Teams](https://claude.com/pricing?utm_source=claude_code\&utm_medium=docs\&utm_content=authentication_teams_step#team-&-enterprise) に購読するか、[Claude for Enterprise](https://anthropic.com/contact-sales?utm_source=claude_code\&utm_medium=docs\&utm_content=authentication_enterprise_step) の営業に連絡してください。

**2. チームメンバーを招待**

管理ダッシュボードからチームメンバーを招待します。

**3. インストールしてログイン**

チームメンバーは Claude Code をインストールし、claude.ai アカウントでログインします。

### Claude Console 認証

API ベースの請求を希望する組織の場合、Claude Console を通じてアクセスを設定できます。

**1. Console アカウントを作成または使用**

既存の Claude Console アカウントを使用するか、新しいアカウントを作成します。

**2. ユーザーを追加**

以下のいずれかの方法でユーザーを追加できます。

* [platform.claude.com/settings/members](https://platform.claude.com/settings/members) にある Console の Members ページからユーザーを一括招待します。**Invite** をクリックします
* [SSO を設定](https://support.claude.com/en/articles/13132885-setting-up-single-sign-on-sso)

**3. ロールを割り当て**

ユーザーを招待する際に、以下のいずれかを割り当てます。

* **Claude Code** ロール: ユーザーは Claude Code API キーのみを作成できます
* **Developer** ロール: ユーザーはあらゆる種類の API キーを作成できます

**4. ユーザーがセットアップを完了**

招待された各ユーザーは以下を実行する必要があります。

* Console 招待を受け入れる
* [システム要件を確認](https://code.claude.com/docs/ja/setup.md#system-requirements)
* [Claude Code をインストール](https://code.claude.com/docs/ja/setup.md#install-claude-code)
* Console アカウント認証情報でログイン

#### API キーなしでサインイン

API キーを作成しなくても Console アカウントにサインインできます。組織が開発者による API キーの作成を許可していない場合でも可能です。`/login` プロンプトで Anthropic Console アカウントを選択すると、Claude Code はサインイン方法を尋ねます。Claude Code v2.1.242 以降が必要です。両方のルートは Console にブラウザーでサインインしますが、Claude Code がその後に保存する内容が異なります。

* **Console アカウントでサインイン**（`(recommended)` とラベル付け）: Claude Code はそのサインインから OAuth トークンを保持し、[Anthropic プロファイル](#anthropic-profiles-and-federation-credentials)として保存します。API キーは作成されません
* **API キーを作成**（`(legacy)` とラベル付け）: Claude Code は Console API キーを作成し、他の認証情報と一緒に保存します

実際には、プロファイルは OAuth ログインを保存し、API キーは静的な認証情報です。Claude Code はプロファイルのログインを自動的に更新し、更新に失敗すると、再度サインインするまで [Anthropic プロファイルログイン期限切れ](https://code.claude.com/docs/ja/errors.md#anthropic-profile-login-expired) でリクエストが失敗します。

すべてのマシンで選択肢が得られるわけではありません。Claude Code は以下の場合、確認なしに API キーを作成します。

* Amazon Bedrock、Google Cloud の Agent Platform、Microsoft Foundry などの [クラウドプロバイダーに対して実行](https://code.claude.com/docs/ja/third-party-integrations.md)するか、[AWS 上の Claude Platform](https://code.claude.com/docs/ja/claude-platform-on-aws.md) に対して実行する
* 任意の設定ファイルが [`forceLoginOrgUUID`](#restrict-login-to-your-organization) を設定するか、`forceLoginMethod` を `"claudeai"` に設定する
* `forceLoginMethod` が `"console"` で、どの設定ファイルも `forceLoginOrgUUID` を設定していない場合（サインインに失敗した後にエラー画面から再試行するまで）
* マシン上に管理設定ファイル、MDM プロファイル、キャッシュされたサーバー管理設定などの管理設定ソースが存在しますが、Claude Code が [それを読み取ることができず](https://code.claude.com/docs/ja/managed-settings.md#invalid-entries-in-managed-settings)、他の管理ソースがポリシーを提供していない

キーなしでサインインする前に `ANTHROPIC_API_KEY` を設定解除してください。

キーなしでサインインした後、保存された API キーの代わりにプロファイルが得られます。

* **書き込まれるプロファイル**: Claude Code は `ANTHROPIC_PROFILE` で指定されたプロファイル、またはアクティブなプロファイル、または `default` を書き込みます。そのプロファイルがフェデレーションプロファイルの場合、Claude Code はそれを上書きする代わりにサインインを拒否します
* **サインアウトする対象**: Claude Code はマシンに保存されている claude.ai ログインからサインアウトします
* **元に戻す方法**: `/logout` を実行します。これにより、このサインインが書き込んだ認証情報が削除および取り消されます

プロファイルに関するその他すべてのことがこのサインインに適用されます。これには、他の認証情報に対するランク付け、`/status` で取得される `Profile` 行、および claude.ai ログインが必要な機能が含まれます。[Anthropic プロファイルとフェデレーション認証情報](#anthropic-profiles-and-federation-credentials)を参照してください。

#### 管理対象マシンでキーレスサインインの提供を停止する

Claude Code が [キーレスサインイン](#sign-in-without-an-api-key)を提供しないようにするには、デバイス管理ツールを使用して、[管理設定](https://code.claude.com/docs/ja/managed-settings.md)の [`forceLoginOrgUUID`](https://code.claude.com/docs/ja/settings-reference#forceloginorguuid) を各開発者のマシンにデプロイします。値には [Console の組織 ID](https://platform.claude.com/settings/organization) を設定します。デプロイする前に、各開発者が [API キーを作成できるロール](#claude-console-authentication)を持っていることを確認してください。デプロイ後は、そのロールを持たない開発者は `/login` で Console にサインインできなくなります。

`forceLoginMethod` を `"console"` に設定しただけの場合、開発者は失敗したサインインを再試行してキーレスのオプションを選択できます。`forceLoginOrgUUID` をデプロイすると、ログイン画面からそのオプションはなくなりますが、開発者は既に持っている、または [`ant auth login`](https://platform.claude.com/docs/en/cli-sdks-libraries/cli/authentication) で作成した [Anthropic プロファイル](#anthropic-profiles-and-federation-credentials)を引き続き使用できます。デプロイ後は、各マシンで以下の認証情報とログインに対処してください。

* **キーレスサインイン**: 開発者を API キーに移行するには、いったんログアウトしてから Console に再度ログインしてもらいます。これによりキーが作成されます。キーレスサインインの場合は、シェルで `claude auth logout` を実行します。`ant auth login` のプロファイルの場合は、`ant auth logout` を実行します。プロファイルと API キーの両方がマシン上にあると Claude Code はセッションを拒否するため、先にログアウトしてもらいます。
* **環境変数およびヘルパーの認証情報**: Claude Code は、`ANTHROPIC_API_KEY`、`ANTHROPIC_AUTH_TOKEN`、または `apiKeyHelper` で認証するセッションを、管理設定がそれらを提供している場合でも拒否します。これらの認証情報を削除してから、開発者に `/login` を実行して保存済みの API キーを作成してもらいます。
* **claude.ai ログイン**: Claude Code は、リストにない組織への [ログインを拒否](#restrict-login-to-your-organization)します。これにはマシン上で既に使用中の組織も含まれます。その組織を維持するには、`forceLoginOrgUUID` 配列に追加します。

### クラウドプロバイダー認証

Amazon Bedrock、Google Cloud の Agent Platform、または Microsoft Foundry を使用するチームの場合。

**1. プロバイダーセットアップに従う**

[Amazon Bedrock ドキュメント](https://code.claude.com/docs/ja/amazon-bedrock.md)、[Google Cloud の Agent Platform ドキュメント](https://code.claude.com/docs/ja/google-vertex-ai.md)、または [Microsoft Foundry ドキュメント](https://code.claude.com/docs/ja/microsoft-foundry.md)に従ってください。

**2. 設定を配布**

環境変数とクラウド認証情報を生成するための手順をユーザーに配布します。[ここで設定を管理する方法](https://code.claude.com/docs/ja/settings.md)についてさらに詳しく読んでください。

**3. Claude Code をインストール**

ユーザーは [Claude Code をインストール](https://code.claude.com/docs/ja/setup.md#install-claude-code)できます。

### ログインを組織に制限する

開発者の claude.ai ログインが特定の Anthropic 組織に属することを要求するには、[管理設定](https://code.claude.com/docs/ja/managed-settings.md)で [`forceLoginMethod`](https://code.claude.com/docs/ja/settings-reference#forceloginmethod) と [`forceLoginOrgUUID`](https://code.claude.com/docs/ja/settings-reference#forceloginorguuid) を設定します。`forceLoginOrgUUID` を組織 ID に設定します。組織 ID は Claude for Teams または Enterprise 組織の [claude.ai 管理設定](https://claude.ai/admin-settings/organization)に表示されます。Claude Code は他の組織への claude.ai ログインについてエラーを報告し、使用中の claude.ai 認証情報がリストされていない組織に属している場合、起動時に終了します。

Claude Console ログインの場合、Claude Code は `forceLoginOrgUUID` を使用して、単一の Console 組織 ID に設定した場合、Console サインインページで組織を事前選択します。組織 ID は [platform.claude.com/settings/organization](https://platform.claude.com/settings/organization) に表示されます。ログイン時または起動時に、結果の Console 認証情報がどの組織に属しているかを確認しません。キーをデプロイする前に Console アカウントでログインした開発者はログインしたままになり、その保存されたキーは [ゲートウェイ](https://code.claude.com/docs/ja/claude-apps-gateway)サインインも必要とするマシン上、またはクラウドプロバイダーを選択するセッション内でブロックされます。

任意の設定ファイルで `forceLoginOrgUUID` を設定した場合、Claude Code はそのファイルが適用されるセッションで [キーレス Console サインイン](#sign-in-without-an-api-key)の提供を停止し、代わりに API キーを作成します。開発者を claude.ai サインインに向かわせるには、`forceLoginMethod` を `"claudeai"` に設定します。

Claude Code v2.1.212 以降では、ここにリストされているすべてのログインパスが `forceLoginMethod` を適用します。ターミナルのインタラクティブログイン画面（`/login` または初回オンボーディングで到達）では、Claude Code は `claudeai` または `console` メソッドを強制せずに事前選択するため、`forceLoginMethod` が `"claudeai"` に設定されている場合でも、開発者は Console ログインをそこで完了できます。

パスは `forceLoginOrgUUID` で異なります。

* **ターミナル、[VS Code 拡張機能](https://code.claude.com/docs/ja/vs-code.md)、および Agent SDK ログイン**: claude.ai アカウントログインの `forceLoginOrgUUID` を確認します
* **`claude setup-token` および `/install-github-app`**: `forceLoginMethod` のみを強制するため、別の組織でトークンを生成できます
* **[ゲートウェイ](https://code.claude.com/docs/ja/claude-apps-gateway)サインイン**: `forceLoginMethod: "gateway"` によって選択され、それによって制限されず、Anthropic 組織に対して認証されないため、`forceLoginOrgUUID` は適用されません。ゲートウェイ ID プロバイダーを使用してアクセスを制限します

`forceLoginMethod` と `forceLoginOrgUUID` はデバイス管理ツールを通じてデプロイします。開発者が [サーバー管理設定](https://code.claude.com/docs/ja/server-managed-settings.md)を受け取るのは組織への認証後に限られるため、これらの設定で最初のログインをリダイレクトすることはできません。claude.ai からサーバー管理設定も配布している場合は、すべてのクライアントが v2.1.299 以降を実行するようになるまで、そちらにも両方のキーを設定してください。その後キーを設定する場所と、どのソースの値が適用されるかについては、[ログインキーを提供する管理ソース](https://code.claude.com/docs/ja/managed-settings.md#which-managed-source-supplies-login-keys)を参照してください。

[ゲートウェイ](https://code.claude.com/docs/ja/claude-apps-gateway)デプロイメントでは、`forceLoginMethod` と `forceLoginOrgUUID` を [ゲートウェイが提供する設定](https://code.claude.com/docs/ja/claude-apps-gateway-config.md#managed)から除外したままにしてください。

キーはまた、ログイン認証情報を使用しないセッションが開始できるかどうかも決定します。設定リファレンスの [`forceLoginOrgUUID`](https://code.claude.com/docs/ja/settings-reference#forceloginorguuid) を参照して、完全な動作を確認してください。

* **`ANTHROPIC_API_KEY`、`ANTHROPIC_AUTH_TOKEN`、または `apiKeyHelper`**: 起動時にブロックされます。`forceLoginOrgUUID` では、環境認証情報の組織メンバーシップを確認できず、`forceLoginMethod` では認証情報が必要なサインインの代わりになります。管理設定が [ゲートウェイ](https://code.claude.com/docs/ja/claude-apps-gateway)サインインも必要とする場合、Claude Code は以前の Claude Console ログインによって保存された API キーを同じ方法でブロックします。[管理者ポリシーがクラウドゲートウェイサインインを必要とします](https://code.claude.com/docs/ja/errors.md#administrator-policy-requires-a-cloud-gateway-sign-in)を参照してください
* **Amazon Bedrock などのクラウドプロバイダーセッション**: `ANTHROPIC_API_KEY`、`ANTHROPIC_AUTH_TOKEN`、または `apiKeyHelper` 認証情報、または以前の Claude Console ログインによって保存された API キーがマシン上にまだ存在する間のみブロックされます。それを削除するとセッションが開始します。これらのセッションはクラウドプロバイダーに対して認証され、クラウドプロバイダーのアクセスポリシーがそれらを管理します
* **[Anthropic プロファイルまたはフェデレーション認証情報](#anthropic-profiles-and-federation-credentials)**: `ANTHROPIC_API_KEY`、`ANTHROPIC_AUTH_TOKEN`、または `apiKeyHelper` 認証情報、または以前の Claude Console ログインによって保存された API キーもマシン上に存在する場合を除き、ブロックされません。キーはプロファイルが属する組織を確認しません

### マシンが使用できる API プロバイダーを制限する

[管理設定](https://code.claude.com/docs/ja/managed-settings.md)の [`allowedProviders`](https://code.claude.com/docs/ja/settings-reference#allowedproviders) は、Anthropic API、Amazon Bedrock、LLM ゲートウェイなど、管理マシンが Claude に到達できるサービスをリストします。これは `forceLoginMethod` と `forceLoginOrgUUID` を補完します。これらは、セッションが Anthropic と通信するときに使用するアカウントを管理します。Claude Code v2.1.285 以降が必要です。

```json managed-settings.json theme={null}
{
  "forceLoginMethod": "claudeai",
  "forceLoginOrgUUID": ["xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"],
  "allowedProviders": ["anthropic", "bedrock"]
}
```

このファイルを使用すると、claude.ai 組織にサインインした開発者または Amazon Bedrock 用に設定された開発者は正常に起動します。他のプロバイダー用に設定されたセッションは起動時に拒否され、実行中のセッションがそのセッションに切り替わると、次のリクエストで拒否されます。[管理設定がこの API プロバイダーを許可していません](https://code.claude.com/docs/ja/errors.md#managed-settings-dont-allow-this-api-provider)は各メッセージを表示します。

* **LLM ゲートウェイまたはプロキシを許可する**: `"customEndpoint"` をリストし、同じソースの管理 `env` ブロックでゲートウェイの URL を設定します。[設定リファレンス](https://code.claude.com/docs/ja/settings-reference.md#allowedproviders)はすべての値をリストし、どのエンドポイント変数が管理 `env` ピンを必要とするかを示します。
* **管理マシンにデプロイする**: リストをポリシーの残りを含む管理ソースに配置します。エントリの [スコープ注記](https://code.claude.com/docs/ja/settings-reference.md#allowedproviders)は、サーバー管理リストがそれとどのように組み合わされるかを示します。
* **サーバー管理設定のみ**: [サーバー管理設定](https://code.claude.com/docs/ja/server-managed-settings.md)でのみ設定するリストは、組織の設定を取得するセッションにのみ到達するため、デバイス管理で到達できないマシンの利便性として扱い、強制として扱わないでください。[プラットフォーム可用性](https://code.claude.com/docs/ja/server-managed-settings.md#platform-availability)はどのセッションがそれらを取得するかをリストします。

## 認証情報管理

Claude Code は認証情報を安全に管理します。

* **保存場所**:
  * macOS では、認証情報は暗号化された macOS Keychain に保存されます。Keychain が SSH セッションでロックされている場合など、書き込みを拒否する場合、Claude Code はログインを `~/.claude/.credentials.json` に保存し、ファイルモードは `0600` です。これは Linux で使用するのと同じストレージです。Keychain が書き込み可能になるまで、Console ログインで API キーを作成すると失敗します。ログインを Keychain に戻すには、[復旧手順](https://code.claude.com/docs/ja/troubleshoot-install.md#not-logged-in-or-token-expired)に従ってください。
  * Linux では、認証情報は `~/.claude/.credentials.json` に保存され、ファイルモードは `0600` です。
  * Windows では、認証情報は `%USERPROFILE%\.claude\.credentials.json` に保存され、ユーザープロファイルディレクトリのアクセス制御を継承します。これにより、ファイルはデフォルトでユーザーアカウントに制限されます。
  * `CLAUDE_CONFIG_DIR` 環境変数を設定している場合、Claude Code は `.credentials.json` ファイルをそのディレクトリの下に保存します。これには macOS フォールバックが書き込むファイルも含まれ、macOS Keychain エントリもそのディレクトリをキーとします。そのため、異なる `CLAUDE_CONFIG_DIR` を持つセッションは異なるエントリを読み込みます。
  * Claude Code は `/login` と `/logout` を通じて `.credentials.json` を管理します。リクエストをカスタム API エンドポイント経由でルーティングするには、代わりに [`ANTHROPIC_BASE_URL`](https://code.claude.com/docs/ja/env-vars) 環境変数を設定してください。
* **サポートされている認証タイプ**: claude.ai 認証情報、Claude API 認証情報、Microsoft Foundry Auth、Bedrock Auth、Vertex Auth、Anthropic プロファイルおよび [Workload Identity Federation](https://platform.claude.com/docs/en/manage-claude/workload-identity-federation) 認証情報、および [Claude apps gateway](https://code.claude.com/docs/ja/claude-apps-gateway) セッショントークン。
* **カスタム認証情報スクリプト**: [`apiKeyHelper`](https://code.claude.com/docs/ja/settings-reference#apikeyhelper) 設定を構成して、API キーを返すシェルスクリプトを実行します。
* **更新間隔**: [`apiKeyHelper`](https://code.claude.com/docs/ja/settings-reference#apikeyhelper) の場合を参照してください。Claude Code はヘルパーを再実行する場合があります。
* **遅いヘルパー通知**: `apiKeyHelper` がキーを返すのに 10 秒以上かかる場合、Claude Code はプロンプトバーに経過時間を表示する警告通知を表示します。この通知が定期的に表示される場合は、認証情報スクリプトを最適化できるかどうかを確認してください。
* **ヘルパーの失敗**: スクリプトがエラーで終了したり、タイムアウトしたり、何も出力しない場合、リクエストは 3 回の試行内に [`Your apiKeyHelper script is failing`](https://code.claude.com/docs/ja/errors#your-apikeyhelper-script-is-failing) で失敗します。

`apiKeyHelper`、`ANTHROPIC_API_KEY`、および `ANTHROPIC_AUTH_TOKEN` は CLI およびそれをラップするサーフェス（VS Code 拡張機能、Agent SDK、GitHub Actions を含む）に適用されます。Claude Desktop とクラウドセッションは `apiKeyHelper` を呼び出したり、これらの環境変数を読み込んだりしません。OAuth を使用します。ただし、[サードパーティ推論設定](https://code.claude.com/docs/ja/llm-gateway-connect.md#desktop-app)を実行しているデスクトップセッションは、その設定の認証情報で認証します。

### 期限切れ間近のログインを更新する

`/login` で作成したログインが期限切れまで 3 日以内になると、Claude Code はスタートアップ時に警告を表示します。`Your login expires in 3 days · run /login to renew`。

`/login` を実行して更新します。警告は情報提供のみであり、リクエストをブロックすることはありません。ログインが実際に期限切れになるまで認証は機能し続けます。

保存されたログインが期限切れになり、更新できなくなると、再度サインインするまで、各モデルリクエストは [`Login expired · Please run /login`](https://code.claude.com/docs/ja/errors#login-expired) で失敗します。

リクエストが失敗する前にこの状態を確認できます。[`/status`](https://code.claude.com/docs/ja/commands) は `Login` 行に `Expired — log in again` を表示し、期限切れのログインに保存されている組織とメールアドレスを表示します。この行は、保存されている claude.ai ログインがアクティブな認証情報である場合にのみ表示されます。この行には Claude Code v2.1.210 以降が必要です。

警告は claude.ai ログインがアクティブな認証情報である場合にのみ表示され、クラウドプロバイダー、`ANTHROPIC_API_KEY`、`ANTHROPIC_AUTH_TOKEN`、または `apiKeyHelper` が認証情報を提供する場合には表示されません。

更新を早期に行うことは、無人で実行されるセッションにとって最も重要です。[agent view のバックグラウンドセッション](https://code.claude.com/docs/ja/agent-view.md)または [Remote Control](https://code.claude.com/docs/ja/remote-control.md) セッションがログインより長く実行される場合、認証情報が期限切れになると進行が停止し、再度サインインするまで復旧できません。

### 認証の優先順位

複数の認証情報が存在する場合、Claude Code は以下の順序で 1 つを選択します。

1. `CLAUDE_CODE_USE_BEDROCK`、`CLAUDE_CODE_USE_VERTEX`、または `CLAUDE_CODE_USE_FOUNDRY` が設定されている場合のクラウドプロバイダー認証情報。セットアップについては、[サードパーティ統合](https://code.claude.com/docs/ja/third-party-integrations.md)を参照してください。
2. `ANTHROPIC_AUTH_TOKEN` 環境変数。`Authorization: Bearer` ヘッダーとして送信されます。Anthropic API キーではなくベアラートークンで認証する [LLM ゲートウェイまたはプロキシ](https://code.claude.com/docs/ja/llm-gateway)を通じてルーティングする場合に使用します。
3. `ANTHROPIC_API_KEY` 環境変数。`X-Api-Key` ヘッダーとして送信されます。[Claude Console](https://platform.claude.com) からのキーを使用して Anthropic API に直接アクセスする場合に使用します。対話モードでは、キーを承認または拒否するよう 1 回プロンプトが表示され、選択が記憶されます。後で変更するには、`/config` の「Use custom API key」トグルを使用します。トグルは `ANTHROPIC_API_KEY` が環境に設定されている間のみ表示されます。非対話モード（`-p`）では、キーが存在する場合は常に使用されます。
4. [`apiKeyHelper`](https://code.claude.com/docs/ja/settings-reference#apikeyhelper) スクリプト出力。動的または回転する認証情報（ボルトから取得した短期トークンなど）に使用します。
5. `CLAUDE_CODE_OAUTH_TOKEN` 環境変数。[`claude setup-token`](#generate-a-long-lived-token) によって生成された長期 OAuth トークン。ブラウザログインが利用できない CI パイプラインとスクリプトに使用します。この変数が設定されている間に `/login` を実行すると、Claude Code は現在のセッションを新しいログインに切り替えますが、シェルプロファイルまたは[設定ファイル](https://code.claude.com/docs/ja/settings.md)の `env` ブロックから変数を削除するまで、新しいセッションのたびに変数を再度読み込みます。
6. Anthropic プロファイルおよびフェデレーション認証情報。`ant` CLI および Workload Identity Federation が使用する認証情報。`ant auth login` が書き込んだプロファイルは、`ANTHROPIC_PROFILE` で名前を付けた場合にのみここにランク付けされます。そうでない場合は `/login` より下にランク付けされます。[Anthropic プロファイルおよびフェデレーション認証情報](#anthropic-profiles-and-federation-credentials)を参照してください。
7. `/login` からのサブスクリプション OAuth 認証情報。これは Claude Pro、Max、Ultra、Team、および Enterprise ユーザーのデフォルトです。

署名済みの [Claude apps gateway](https://code.claude.com/docs/ja/claude-apps-gateway) セッションはこのリストの外に位置します。これは Amazon Bedrock または Google Cloud の Agent Platform のようなプロバイダー選択であり、それらより優先されます。ゲートウェイセッションが存在する場合、CLI は `CLAUDE_CODE_USE_BEDROCK`、`CLAUDE_CODE_USE_VERTEX`、または `CLAUDE_CODE_USE_FOUNDRY` が設定されていても、ゲートウェイトークンで認証され、ベアラートークン、API キー、`apiKeyHelper`、およびプロファイルなどの上記の認証情報ソースは使用されません。

マシンの[管理設定](https://code.claude.com/docs/ja/managed-settings.md)が [`forceLoginMethod`](https://code.claude.com/docs/ja/settings-reference#forceloginmethod) を `"gateway"` に設定するか、[`forceLoginGatewayUrl`](https://code.claude.com/docs/ja/settings-reference#forcelogingatewayurl) を設定しており、`CLAUDE_CODE_USE_BEDROCK` や `CLAUDE_CODE_USE_VERTEX` などの変数を通じてクラウドプロバイダーを選択していない場合、セッションはゲートウェイサインインのみを使用します。Claude Code は他の認証情報ソースをスキップし、`/login` でサインインするよう求めます。残っている各認証情報で表示される内容については、[Administrator policy requires a Cloud gateway sign-in](https://code.claude.com/docs/ja/errors.md#administrator-policy-requires-a-cloud-gateway-sign-in) を参照してください。Claude Code v2.1.261 以降が必要です。`forceLoginGatewayUrl` のみを設定するマシンでは v2.1.265 以降が必要です。

アクティブな Claude サブスクリプションがあり、環境に `ANTHROPIC_API_KEY` も設定されている場合、API キーは承認されると優先されます。キーが無効または期限切れの組織に属している場合、これは認証エラーを引き起こす可能性があります。

`unset ANTHROPIC_API_KEY` を実行してサブスクリプションにフォールバックし、`/status` をチェックしてどの方法がアクティブであるかを確認します。ログインと API キーの両方が設定されている場合、`/status` は使用中でない認証情報をマークします。

[Cloud sessions](https://code.claude.com/docs/ja/claude-code-on-the-web.md) は常にサブスクリプション認証情報を使用します。クラウド環境で `ANTHROPIC_API_KEY` または `ANTHROPIC_AUTH_TOKEN` を設定しても、サブスクリプション認証情報はオーバーライドされません。

#### Anthropic プロファイルおよびフェデレーション認証情報

プロファイルは、[Anthropic 設定ディレクトリ](https://platform.claude.com/docs/en/manage-claude/wif-reference#configuration-directory)内の名前付き認証情報設定ファイルです。デフォルトでは macOS および Linux では `~/.config/anthropic`、Windows では `%APPDATA%\Anthropic` です。プロファイルの認証モードは、[Workload Identity Federation（WIF）](https://platform.claude.com/docs/en/manage-claude/workload-identity-federation)用に設定した場合は `oidc_federation`、または [`ant auth login`](https://platform.claude.com/docs/en/cli-sdks-libraries/cli/authentication) が書き込んだ場合、または [API キーなしで Console アカウントにサインイン](#sign-in-without-an-api-key)した場合は `user_oauth` です。

Claude Code は [ベアモード](https://code.claude.com/docs/ja/headless.md#start-faster-with-bare-mode)、Claude Desktop、またはクラウドセッションではプロファイルまたはフェデレーション変数を読み込みません。これらのセッションでは、`/status` は `Profile` 行を表示しません。

Claude Code は 3 つのソースをこの順序でチェックし、設定されている最初のソースで停止します。表は各ソースを設定するものと、`/login` 認証情報に対するランク付けを示しています。

| ソース | 設定者 | `/login` に対するランク |
| :- | :- | :- |
| 名前付きプロファイル | `ANTHROPIC_PROFILE` | 上、プロファイルが持つ認証モードに関係なく |
| フェデレーション変数 | `ANTHROPIC_FEDERATION_RULE_ID` および `ANTHROPIC_ORGANIZATION_ID`、両方設定 | 上 |
| アクティブプロファイル | 設定ディレクトリ内の [`active_config` ファイル](https://platform.claude.com/docs/en/manage-claude/wif-reference#active-profile)、または `default` という名前のプロファイル | 認証モードが `oidc_federation` の場合は上。認証モードが `user_oauth` の場合は、機能している `/login` 認証情報より下 |

フェデレーション変数の場合、Claude Code は ID トークンを交換する際に [WIF リファレンス](https://platform.claude.com/docs/en/manage-claude/wif-reference#environment-variables)の `ANTHROPIC_IDENTITY_TOKEN_FILE` などの他の変数も読み込みます。プロファイルファイル形式については、[WIF リファレンス](https://platform.claude.com/docs/en/manage-claude/wif-reference#profile-configuration-file)を参照してください。

Claude Code が選択したソースを確認するには、`/status` を実行してください。`Profile` 行は `Login method` 行の代わりにソースを名前で表示し、プロファイルが使用中の認証情報である場合、`Organization` および `Email` 行はそのアカウントを表示します。

`user_oauth` プロファイルのログインが期限切れになり、Claude Code がそれを更新できない場合、リクエストは[プロファイルログインの期限切れエラー](https://code.claude.com/docs/ja/errors.md#anthropic-profile-login-expired)で失敗します。

[claude.ai コネクタ](https://code.claude.com/docs/ja/mcp.md#use-mcp-servers-from-claude-ai)および [`/schedule`](https://code.claude.com/docs/ja/routines)などの claude.ai ログインが必要な機能は、これらのソースの 1 つが選択されている間は利用できません。Claude Code がソースを選択するのを停止するには、以下を実行してください。

* **名前付きプロファイルまたはフェデレーション変数**: `ANTHROPIC_PROFILE` をアンセットするか、フェデレーション変数のいずれかをアンセットします
* **アクティブプロファイル**: [API キーなしで Console アカウントにサインイン](#sign-in-without-an-api-key)して現在の認証情報を書き込んだ `user_oauth` プロファイルの場合は `/logout` を実行し、`ant auth login` が現在の認証情報を書き込んだプロファイルの場合は `ant auth logout` を実行し、どちらの認証モードでも設定ディレクトリの `configs/` からプロファイルのファイルを削除します

### 長期トークンを生成する

CI パイプライン、スクリプト、または対話的なブラウザログインが利用できない他の環境の場合、`claude setup-token` で 1 年間の OAuth トークンを生成します。

```bash theme={null}
claude setup-token
```

このコマンドは `/login` と同じブラウザ認可フローを開き、ブラウザでアクセスを承認した後、トークンはターミナルに出力されます。トークンはどこにも保存されません。トークンをコピーして、認証したい場所で `CLAUDE_CODE_OAUTH_TOKEN` 環境変数として設定します。

> [tab] macOS, Linux, WSL
>
> ```bash theme={null}
> export CLAUDE_CODE_OAUTH_TOKEN=your-token
> ```

> [tab] Windows PowerShell
>
> ```powershell theme={null}
> $env:CLAUDE_CODE_OAUTH_TOKEN = "your-token"
> ```

> [tab] Windows CMD
>
> ```batch theme={null}
> set CLAUDE_CODE_OAUTH_TOKEN=your-token
> ```

このトークンは Claude サブスクリプションで認証され、Pro、Max、Ultra、Team、または Enterprise プランが必要です。モデルリクエストのみを実行できるため、[Remote Control](https://code.claude.com/docs/ja/remote-control.md) セッションを確立したり、[claude.ai コネクタ](https://code.claude.com/docs/ja/mcp.md#use-mcp-servers-from-claude-ai)をフェッチしたりすることはできません。ローカルで設定した MCP サーバーは引き続き機能します。

[ベアモード](https://code.claude.com/docs/ja/headless.md#start-faster-with-bare-mode)は `CLAUDE_CODE_OAUTH_TOKEN` を読み込みません。スクリプトが `--bare` を渡す場合は、`ANTHROPIC_API_KEY` または `apiKeyHelper` で認証します。
