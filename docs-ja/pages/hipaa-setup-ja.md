> ## Documentation Index
> Fetch the complete documentation index at: https://code.claude.com/docs/llms.txt
> Use this file to discover all available pages before exploring further.

# HIPAA 対応組織向けに Claude Code（ローカルモード）をセットアップする

> HIPAA 設定の下で Claude Code（ローカルモード）を実行できるよう、開発者のコンピューターを準備します。バージョン、ネットワークアクセス、管理設定、ローカルデータについて説明します。

HIPAA 設定は Claude Enterprise プランの組織設定で、保護対象医療情報（PHI）を扱い、Anthropic と[事業提携契約（BAA）](https://support.claude.com/en/articles/8114513-business-associate-agreements-baa-for-commercial-customers)を締結している組織を対象としています。この設定は Claude Code（ローカルモード）と Cowork（ローカルモード）に適用され、両製品の機能を制限します。

> [!NOTE]
>
> 「（ローカルモード）」とは、[クラウドセッション](https://code.claude.com/docs/ja/claude-code-on-the-web.md)ではなくローカルセッションを意味します。ローカルセッションは次のいずれかで実行されます。
>
> * ターミナルの Claude Code
> * Claude Desktop の Code タブの Claude Code
> * Claude Desktop の Cowork
>
> VS Code および JetBrains 向けの Claude Code 拡張機能は（ローカルモード）には含まれません。HIPAA 設定が適用された後も引き続き動作しますが、BAA の対象外です。対象サービス（Eligible Services）の完全な一覧については、[実装ガイド](https://trust.anthropic.com/resources?s=l1wrssd9hsbi4gak0tp5a6\&name=%5Banthropic%5D-hipaa-ready-offering-implementation-guide)を参照してください。

このページは、開発者のコンピューターを準備する IT 管理者またはセキュリティ管理者を対象としています。設定そのものは Claude 組織の Primary Owner が適用します。BAA に含まれる内容、設定の適用方法、適用日のスケジュール方法については、[HIPAA 対応 Enterprise プランで Claude Code（ローカルモード）と Cowork（ローカルモード）を使用する](https://support.claude.com/en/articles/17318731)で説明しています。

組織のメンバーが Cowork も使用している場合は、[HIPAA 対応組織向けに Cowork（ローカルモード）をセットアップする](https://claude.com/docs/cowork/hipaa-setup)の手順にも従ってください。こちらでは Claude Desktop のポリシーと Cowork のローカルデータについて説明しています。

次の表は、セットアップの各作業をいつ行うかを示しています。

| 時期 | 行うこと |
| :- | :- |
| 設定が適用される前 | [コンピューターを準備する](#prepare-computers-before-the-hipaa-configuration-is-applied)：開発者の接続方法を確認し、アプリを更新し、ネットワークアクセスを許可し、管理設定をデプロイし、Claude Desktop へのサインインを制限します |
| 適用された後 | Owner が再びオンにするまで Code タブはオフになります。[コンピューター上で設定を確認する](#confirm-the-configuration-on-a-computer) |
| 継続的に | [ローカルセッションデータを管理する](#manage-local-session-data) |

## HIPAA 設定が適用される前にコンピューターを準備する

このセクションの作業から始め、設定が適用される前に完了しておくことをお勧めします。

### 開発者のサインイン方法と接続方法を確認する

HIPAA 設定が有効になるのは、開発者が Claude Enterprise アカウントでサインインし、Claude Code が Claude API に直接接続しているセッションのみです。それ以外の接続でも開発者は Claude Code を引き続き使用できますが、[HIPAA 設定](#what-developers-see-in-claude-code)は適用されません。

次の表は、どの接続が対象となるかを示しています。「いいえ」の行に該当するセッションが BAA の対象となるかどうかについては、[HIPAA 対応 Enterprise プランで Claude Code（ローカルモード）と Cowork（ローカルモード）を使用する](https://support.claude.com/en/articles/17318731)を参照してください。

| Claude Code の接続方法 | HIPAA 設定の対象 |
| :- | :- |
| Claude Enterprise アカウントで Claude API に直接接続 | はい |
| Amazon Bedrock、Google Cloud の Agent Platform、Microsoft Foundry、Claude Platform on AWS、または [Claude apps ゲートウェイ](https://code.claude.com/docs/ja/claude-apps-gateway) | いいえ |
| [LLM ゲートウェイ](https://code.claude.com/docs/ja/llm-gateway)またはその他のカスタム `ANTHROPIC_BASE_URL` | いいえ |
| Claude Enterprise のサインインがないコンピューター上での `ANTHROPIC_AUTH_TOKEN` または `apiKeyHelper` | いいえ |
| Claude Console の API キーまたは[フェデレーション認証情報](https://code.claude.com/docs/ja/authentication.md#anthropic-profiles-and-federation-credentials) | いいえ。これらのセッションは Claude Console 組織に属し、独自の契約と設定を持ちます |

#### コンピューターの接続方法を確認する

コンピューターでターミナルを開き、`claude` を実行して、プロンプトで `/status` と入力します。**Status** タブには次の行が表示されます。

| 行 | 表示される条件 |
| :- | :- |
| `Login method` と `Organization` | セッションが claude.ai アカウントでサインインしている場合。Claude Enterprise アカウントの場合、`Login method` は `Claude Enterprise account` となり、`Organization` には組織が表示されます |
| `API provider` | セッションがクラウドプロバイダーまたは Claude apps ゲートウェイを使用している場合のみ |
| `Anthropic base URL` | `ANTHROPIC_BASE_URL` が設定されている場合のみ |

コンピューターが HIPAA 設定の対象外の接続を使用している場合は、[管理設定](#deploy-managed-settings)を使用して、クラウドプロバイダー、ゲートウェイ、および `ANTHROPIC_API_KEY`、`ANTHROPIC_AUTH_TOKEN`、`apiKeyHelper` で設定された認証情報をブロックできます。

### Claude Code と Claude Desktop を更新する

HIPAA 設定には、Claude Code v2.1.285 以降と Claude Desktop v2.19675.0 以降が必要です。組織でターミナルと [Claude Desktop アプリ](https://code.claude.com/docs/ja/desktop.md)の両方を使用している場合は、両方を更新してください。

インストールされている Claude Code のバージョンを確認するには、ターミナルで次のコマンドを実行します。Bash、Zsh、PowerShell で共通です。

```bash theme={null}
claude --version
```

サポートされているインストールでは、`2.1.285 (Claude Code)` またはそれ以上の番号が出力されます。

インストールされている Claude Desktop のバージョンを確認するには、[バージョンを確認する](https://code.claude.com/docs/ja/desktop.md#check-your-version)を参照してください。

#### 古いバージョンで開発者に表示される内容

HIPAA 設定が適用された組織では、Anthropic のサーバーは最小バージョンより古いバージョンからのリクエストを拒否します。Anthropic は最小バージョンを随時引き上げますが、ユーザー側で設定する必要はありません。

| アプリ | 古いバージョンで開発者に表示される内容 |
| :- | :- |
| Claude Code | 各リクエストが [`API Error`](https://code.claude.com/docs/ja/errors#claude-code-does-not-support-this-model) で失敗し、バージョンが組織のポリシーで必要な最小バージョンより古いことが示されます |
| Claude Desktop | **Update required** ダイアログが表示され、**Code** タブを引き続き使用するには Claude Desktop を更新するよう開発者に求めます |

開発者がサポートされているバージョンを使い続けるようにするには、[Claude Code を最新の状態に保ちます](https://code.claude.com/docs/ja/setup.md#update-claude-code)。Claude Desktop については、[Claude Desktop を更新する](https://claude.com/docs/cowork/hipaa-setup#update-claude-desktop)を参照してください。

### ネットワークアクセスを許可する

この表のホストを、プロキシとファイアウォールでポート 443 の HTTPS 経由で許可してください。個別のパスではなく、ホスト全体を許可します。

| ホスト | 用途 |
| :- | :- |
| `api.anthropic.com` | Claude API リクエスト、テレメトリ、および HIPAA 設定がオンであることを Claude Code に伝える組織ポリシー |
| `claude.ai`、`claude.com`、`platform.claude.com` | サインインとトークンの更新 |
| `sso.claude.com` | 組織でシングルサインオンを使用している場合のサインイン |
| `downloads.claude.ai` | ネイティブインストーラーとその更新 |
| `mcp-proxy.anthropic.com` | [claude.ai のコネクタ](https://code.claude.com/docs/ja/mcp.md#use-mcp-servers-from-claude-ai) |

この表は、ターミナルで Claude Code のネイティブインストールがサインイン、実行、更新に必要とするホストを示しています。その他のホストは次のページに記載されています。

* **その他のインストール方法とオプション機能**：[ネットワークアクセス要件](https://code.claude.com/docs/ja/network-config.md#network-access-requirements)には、npm と Homebrew のインストールが更新を確認するホストや、プラグインのインストールなどの機能で使用されるホストが記載されています
* **Code タブと Cowork**：[Desktop のネットワークアクセス要件](https://code.claude.com/docs/ja/desktop.md#network-access-requirements)には、Claude Desktop が追加で必要とするホストが記載されています
* **TLS を検査するプロキシ**：[カスタム CA 証明書](https://code.claude.com/docs/ja/network-config.md#custom-ca-certificates)では、プロキシの証明書を信頼する方法を説明しています

企業の HTTPS プロキシを経由するセッションも、プロキシが表のホストに到達できる限り、HIPAA 設定の対象となります。

Claude Code は、起動時と、セッションが使用されている間は約 1 時間ごとに `api.anthropic.com` から組織のポリシーを取得することで、組織に HIPAA 設定が適用されていることを認識します。ポリシーは、組織の HIPAA ステータスと、それに伴う機能制限の記録です。

特定のコンピューターがポリシーを取得したかどうかを確認するには、[コンピューター上で設定を確認する](#confirm-the-configuration-on-a-computer)を参照してください。

### 管理設定をデプロイする

[管理設定](https://code.claude.com/docs/ja/managed-settings.md)を使用すると、開発者に Claude Enterprise アカウントでサインインさせ、クラウドプロバイダーとゲートウェイをブロックし、すべてのコンピューターがローカルセッションデータを保持する日数を設定できます。これらの設定は、HIPAA 設定が有効かどうかにかかわらず適用されます。

このセクションの設定は、出発点としてお勧めするサンプルです。自組織の環境に何が必要かを判断し、その設定がそれらの要件を満たしていることを確認する責任は組織にあります。

次のサンプルでは、組織がデプロイする[管理設定](https://code.claude.com/docs/ja/managed-settings.md#choose-a-delivery-mechanism)に追加できる 4 つのキーを設定しています。

```json theme={null}
{
  "forceLoginMethod": "claudeai",
  "forceLoginOrgUUID": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx",
  "allowedProviders": ["anthropic"],
  "cleanupPeriodDays": 30
}
```

サンドボックス化、ネットワーク許可リスト、認証情報の保護、ローカルデータの保持を含むより完全な `managed-settings.json` については、[設定例リポジトリ](https://github.com/anthropics/claude-code/tree/main/examples/settings)の `settings-hipaa.json` と `README-hipaa.md` を参照してください。

#### 各キーの役割

次の表は、各キーに設定する値と、それに対して Claude Code が適用する内容を示しています。

| キー | 設定値 | Claude Code が適用する内容 |
| :- | :- | :- |
| [`forceLoginMethod`](https://code.claude.com/docs/ja/settings-reference#forceloginmethod) | `"claudeai"` | Claude Code は開発者を Claude Console ではなく claude.ai のサインインに誘導します |
| [`forceLoginOrgUUID`](https://code.claude.com/docs/ja/settings-reference#forceloginorguuid) | 組織 ID。[Owner](https://code.claude.com/docs/ja/server-managed-settings.md#access-control) が [claude.ai の管理設定](https://claude.ai/admin-settings/organization)からコピーできます | claude.ai のサインインが別の組織に属している場合、Claude Code は起動時に終了します |
| [`allowedProviders`](https://code.claude.com/docs/ja/settings-reference#allowedproviders) | `["anthropic"]` | Claude Code はクラウドプロバイダーまたはゲートウェイ上での起動を拒否します |
| [`cleanupPeriodDays`](https://code.claude.com/docs/ja/settings-reference#cleanupperioddays) | 記録管理ポリシーでコンピューターがセッションデータを保持できる日数 | すべてのコンピューターが同じ日数の経過後に古いセッションデータを削除します |

> [!WARNING]
>
> デプロイする前に `forceLoginOrgUUID` の値を確認してください。組織 ID と一致しない場合、claude.ai アカウントでサインインするすべての開発者に対して Claude Code が起動時に終了します。

HIPAA 設定は `cleanupPeriodDays` を制限しないため、開発者は自分の設定でこの値を引き上げることができます。管理設定でこれを設定すると、Claude Code は開発者の値を無視します。

`forceLoginMethod` または `forceLoginOrgUUID` が設定されている場合、Claude Code は `ANTHROPIC_API_KEY`、`ANTHROPIC_AUTH_TOKEN`、`apiKeyHelper` で認証するセッションも拒否します。

#### 設定が読み込まれたことを確認する

設定が適用されたコンピューターで `claude` を実行し、Claude Enterprise アカウントでサインインして、`/status` と入力します。`Setting sources` 行には `Enterprise managed settings` と、その後に `(file)` などの括弧付きのソースが表示され、`Allowed providers` 行には `Anthropic API (managed allowedProviders)` と表示されます。`Setting sources` に表示されない場合や、`Allowed providers` 行がない場合は、[ポリシーが適用されていることを確認する](https://code.claude.com/docs/ja/managed-settings.md#check-that-a-policy-is-in-force)を参照してください。

#### 管理設定のキーでブロックされないセッション

これらのキーをデプロイしても、一部のセッションは HIPAA 設定なしで実行される可能性があります。

* **Claude Console のサインインとフェデレーション認証情報**：`forceLoginOrgUUID` は claude.ai のサインインのみを確認します。[ログインを組織に制限する](https://code.claude.com/docs/ja/authentication.md#restrict-login-to-your-organization)には、サインイン方法と認証情報ごとに Claude Code が確認する内容が記載されています。
* **サーバー管理設定**：組織で[サーバー管理設定](https://code.claude.com/docs/ja/server-managed-settings.md)も使用している場合は、Owner に同じキーをそこにも追加してもらってください。どのソースが適用されるかについては、[Claude Code が管理ソースを組み合わせる方法](https://code.claude.com/docs/ja/managed-settings.md#how-claude-code-combines-managed-sources)で説明しています。
* **v2.1.285 より古いバージョン**：これらのバージョンは `allowedProviders` を無視するため、クラウドプロバイダーやゲートウェイ上で起動できてしまいます。v2.1.163 から v2.1.284 までのバージョンで起動を拒否させるには、[サンプルのキー](#deploy-managed-settings)と同じ管理設定に、`"2.1.285"` を設定した [`requiredMinimumVersion`](https://code.claude.com/docs/ja/settings-reference#requiredminimumversion) を追加できます。v2.1.163 より前のバージョンは `allowedProviders` だけでなく `requiredMinimumVersion` も無視するため、[それらのコンピューターを更新してください](#update-claude-code-and-claude-desktop)。

HIPAA 設定なしで実行されるセッションが BAA の対象となるかどうかについては、[HIPAA 対応 Enterprise プランで Claude Code（ローカルモード）と Cowork（ローカルモード）を使用する](https://support.claude.com/en/articles/17318731)を参照してください。

### Claude Desktop のサインインを制限する

開発者が Claude Desktop の Code タブを使用する場合は、[サインインを組織に制限する](https://code.claude.com/docs/ja/desktop.md#restrict-sign-in-to-your-organization)の説明に従って、Claude Desktop のポリシーにも `forceLoginOrgUUID` を設定してください。管理設定で `forceLoginMethod` と `forceLoginOrgUUID` をデプロイしても、Claude Desktop のサインイン画面は変わりません。

## コンピューター上で設定を確認する

組織に設定が適用された後、管理対象のコンピューター 1 台でこの確認を行ってください。

**1. Claude Code を再起動する**

実行中のセッションを終了し、ターミナルを開いて `claude` を実行します。使用中の実行中セッションは、再起動しなくても約 1 時間以内に設定を取得します。再起動すると、Claude Code はすぐに設定を取得します。

**2. 起動時の通知を確認する**

Claude Code の起動時に `Per your organization's policy, some features are limited · /status for details` と表示されることを確認します。

**3. フッターを確認する**

プロンプトの下にあるフッターの右側に `HIPAA configured` タグが表示されることを確認します。v2.1.286 より前は、タグは `HIPAA` と表示されていました。

**4. /status を実行する**

プロンプトで `/status` と入力します。**Status** タブの `Organization configuration` 行に `HIPAA` が表示されていることを確認します。

**5. Claude Desktop を確認する**

HIPAA 設定を適用すると、組織の Code タブはオフになります。組織で Code タブを使用している場合は、Owner に [**Organization settings > Claude Code**](https://claude.ai/admin-settings/claude-code) に移動して **Desktop** トグルをオンにするよう依頼してください。Cowork については、[Claude Desktop で HIPAA 設定を確認する](https://claude.com/docs/cowork/hipaa-setup#confirm-the-hipaa-configuration-in-claude-desktop)を参照してください。

Claude Desktop を再読み込みするか、再度サインインします。タイトルバーに **HIPAA configured** ラベルが表示されることを確認します。Mac では、サイドバーを開くと表示されます。

`/status` に `HIPAA` が表示されない場合は、次の原因を順に確認してください。

1. **アカウントまたは接続が誤っている**：`/status` の `Organization` 行に組織が表示され、`API provider` 行や `Anthropic base URL` 行が表示されていないことを確認します。設定の対象外となるサインイン方法と接続方法は、[開発者のサインイン方法と接続方法を確認する](#check-how-developers-sign-in-and-connect)に記載されています。
2. **ポリシーの取得がブロックされている**：`/status` で `Organization policy` 行を探します。この行に原因が示されます。セッション外では `claude doctor` を実行して同じ行を確認します。この行には、Claude Code がポリシーをどこから読み込んだか、またはポリシーが読み込まれなかった理由が示されます。プロキシで `api.anthropic.com` を許可してから、Claude Code を再起動してください。
3. **設定がまだ適用されていない**：Primary Owner に設定を適用したかどうかを確認してください。

## Claude Code で開発者に表示される内容

HIPAA 設定が適用されると、ターミナルで一部の Claude Code 機能がオフになるか、動作が変わります。次の表は、開発者から問い合わせを受ける可能性が高い変更を示しています。[HIPAA 機能の利用可否の表](https://support.claude.com/en/articles/8114513-business-associate-agreements-baa-for-commercial-customers)には、Owner が再びオンにできる機能を含め、Claude Code と Cowork のすべての機能が記載されています。

| 開発者が気付くこと | 理由 |
| :- | :- |
| WebFetch ツールが使用できない | WebFetch はオフです。Web 検索は引き続き機能します |
| `--cloud`、`/teleport`、[Remote Control](https://code.claude.com/docs/ja/remote-control.md) が拒否される | [クラウドセッション](https://code.claude.com/docs/ja/claude-code-on-the-web.md)と Remote Control はオフです |
| `/feedback` と `/bug` が使用できない | フィードバックの送信はオフです |
| Claude が[アーティファクト](https://code.claude.com/docs/ja/artifacts.md)を公開できない | アーティファクトの公開はオフです |
| MCP ツールが最初からコンテキストに読み込まれる | [MCP ツール検索](https://code.claude.com/docs/ja/mcp.md#configure-tool-search)はオフです。`ENABLE_TOOL_SEARCH` でも管理設定でも再びオンにすることはできません |
| `ANTHROPIC_API_KEY` を読み取る MCP サーバーやフックが認証できなくなる | Claude Code は、自身が起動するプロセスから [Anthropic の認証情報を削除します](#anthropic-credentials-in-commands-hooks-and-mcp-servers) |
| 別の組織に `/login` した後も制限が残る | HIPAA ステータスは Claude Code が再起動するまで維持されます |

### コマンド、フック、MCP サーバーにおける Anthropic の認証情報

HIPAA 設定が適用されると、Claude Code は、自身が起動するシェルコマンド、フック、MCP サーバーの環境から、`ANTHROPIC_API_KEY` や `ANTHROPIC_AUTH_TOKEN` など、Anthropic への接続に使用する認証情報を削除します。

HIPAA 設定はクラウドプロバイダーや GitHub の認証情報は削除しないため、GitHub にプッシュしたり他のサービスを呼び出したりするコマンドは、その開発者のアクセス権で引き続き機能します。そこに送信されるデータは、Anthropic との BAA の対象外です。対象サービスの完全な一覧については、[実装ガイド](https://trust.anthropic.com/resources?s=l1wrssd9hsbi4gak0tp5a6\&name=%5Banthropic%5D-hipaa-ready-offering-implementation-guide)を参照してください。

Claude が使用できるコマンドとホストを制限するには、[権限ルール](https://code.claude.com/docs/ja/permissions.md)と[サンドボックス](https://code.claude.com/docs/ja/sandboxing.md)を参照してください。

## ローカルセッションデータを管理する

Claude Code（ローカルモード）と Cowork（ローカルモード）は、各開発者のコンピューターにセッションデータを保存します。そのデータの保護と削除は組織の責任です。

### Claude Code のデータ

[アプリケーションデータ](https://code.claude.com/docs/ja/claude-directory.md#application-data)には、Claude Code（ローカルモード）がコンピューターに保存する内容、保持期間のスイープが `cleanupPeriodDays` の経過後に削除する内容、および誰かが削除するまで残る内容が記載されています。同じページには、HIPAA 設定が適用された組織で何が異なるかも記載されています。

保持期間のスイープは誰かが Claude Code を起動したときにのみ実行されるため、誰も起動しないコンピューターではデータが保持されたままになります。

### Code タブのデータ

Code タブは次の場所にデータを保存します。

* **トランスクリプト**：ターミナルのトランスクリプトと同じく `~/.claude/projects/` に保存されます。保持期間のスイープがそれらを削除するタイミングは、[自動的にクリーンアップされるもの](https://code.claude.com/docs/ja/claude-directory.md#cleaned-up-automatically)に記載されています。
* **Claude Desktop のデータフォルダ**：macOS では `~/Library/Application Support/Claude` です。Windows では `%APPDATA%\Claude`、または Anthropic からダウンロードしたインストーラーの場合は `%LOCALAPPDATA%\Packages\Claude_pzs8sxrjxfjjc\LocalCache\Roaming\Claude` であるため、両方を確認してください。HIPAA 設定が適用されると、Claude Desktop は、スター付きのものも含め、`cleanupPeriodDays` より長く非アクティブなローカルの Code タブセッションを削除します。削除は Claude Desktop の実行中にのみ行われます。Claude Desktop は、削除されたセッションの worktree を次のいずれかの方法で処理します。
  * **コミットされていない変更がなく、セッションにスターやピン留めがなく、他のセッションがその worktree を使用していない場合**：Claude Desktop は worktree を削除します
  * **それ以外の場合**：worktree はコンピューターに残ります

Windows では、`~` は `%USERPROFILE%` を意味します。

### Cowork のデータ

[各コンピューターの Cowork データを管理する](https://claude.com/docs/cowork/hipaa-setup#manage-cowork-data-on-each-computer)には、Cowork（ローカルモード）がデータを保存する場所と、Claude Desktop が削除する内容が記載されています。

### セッションデータをすぐに削除する

保持期間のスイープで削除される前に開発者のセッションデータを削除する必要がある場合は、1 つのコマンドでその大部分を削除できます。その開発者としてコンピューターにサインインし、任意のシェルを開いて、インストールされている Claude Code のバージョンに対応するコマンドを実行します。

Claude Code v2.1.288 以降では、`claude purge` を実行します。

```bash theme={null}
claude purge --all --yes
```

v2.1.126 から v2.1.287 では、同じフラグを受け付ける `claude project purge` を実行します。

```bash theme={null}
claude project purge --all --yes
```

どちらのコマンドも、すべてのプロジェクトのトランスクリプトと自動メモリ、`tasks/`、`debug/`、`file-history/` 内のエントリ、`history.jsonl`、および `~/.claude.json` 内のプロジェクトエントリを削除します。`--yes` を指定しない場合は、計画を表示してから確認を求めます。

パージでは、`paste-cache/` 内の貼り付けられたテキストなど、セッションの内容を保持する可能性のある他のパスは残ります。手動で削除できるパスは、[ローカルデータを消去する](https://code.claude.com/docs/ja/claude-directory.md#clear-local-data)に記載されています。再割り当ての前などにコンピューターを完全に消去するには、[コンピューターをワイプします](#offboard-a-developer)。

### 開発者をオフボーディングする

開発者のシートやアカウントを削除しても、そのコンピューター上のものは何も削除されず、`/logout` でもセッションデータは削除されません。すべてを削除するには、デバイス管理ツールでコンピューターをワイプできます。

## 関連リソース

* [HIPAA 対応組織向けに Cowork（ローカルモード）をセットアップする](https://claude.com/docs/cowork/hipaa-setup)
* [管理設定をデプロイする](https://code.claude.com/docs/ja/managed-settings.md)
* [HIPAA 設定の例](https://github.com/anthropics/claude-code/tree/main/examples/settings)
* [エンタープライズネットワーク設定](https://code.claude.com/docs/ja/network-config.md)
* [ゼロデータ保持](https://code.claude.com/docs/ja/zero-data-retention.md)
* [法務とコンプライアンス](https://code.claude.com/docs/ja/legal-and-compliance.md)
* [データの使用](https://code.claude.com/docs/ja/data-usage.md)
