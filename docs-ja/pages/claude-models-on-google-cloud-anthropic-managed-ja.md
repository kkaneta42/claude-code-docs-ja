> ## Documentation Index
> Fetch the complete documentation index at: https://code.claude.com/docs/llms.txt
> Use this file to discover all available pages before exploring further.

# Google Cloud 上の Claude モデル（Anthropic 管理）で Claude Code を使用する

> Google Cloud の認証情報、IAM、Marketplace での請求を利用して、Anthropic が Google Cloud プロジェクト経由で運用する Claude API を使用するように Claude Code を設定します。

Google Cloud 上の Claude モデル（Anthropic 管理）は、Anthropic が運用し、Google Cloud プロジェクト経由でアクセスする Claude API です。Claude Code から使用するには、Google Cloud にサインインし、3 つの環境変数を設定します。

> [!NOTE]
>
> Google Cloud では、Google が管理する Google Cloud の Agent Platform（旧 Vertex AI）を通じても Claude を提供しています。Agent Platform を使用している場合は、代わりに [Google Cloud の Agent Platform 上の Claude Code](https://code.claude.com/docs/ja/google-vertex-ai.md) の手順に従ってください。どちらを使用しているかを確認するには、[Which offering are you using?](https://platform.claude.com/docs/en/build-with-claude/claude-models-on-google-cloud/overview#which-offering-are-you-using) を参照してください。

始める前に、Claude Code v2.1.307 以降を[インストール](https://code.claude.com/docs/ja/setup.md#install-claude-code)してください。バージョンを確認するには、シェルで `claude --version` を実行します。アップデートするには、`claude update` を実行します。

## 前提条件

* [アカウントのセットアップ](https://platform.claude.com/docs/en/build-with-claude/claude-models-on-google-cloud/anthropic-managed#set-up-your-account)が完了している Google Cloud プロジェクト
* Claude Code を実行する各 Google アカウントまたはサービスアカウントに対する、そのプロジェクトの `roles/claude.user` [IAM ロール](https://platform.claude.com/docs/en/build-with-claude/claude-models-on-google-cloud/anthropic-managed#iam-roles)
* プロジェクト ID と、`wrkspc_` で始まる[ワークスペース ID](https://platform.claude.com/docs/en/build-with-claude/claude-models-on-google-cloud/anthropic-managed#find-your-workspace-id)
* サービスアカウントキーファイルではなく Google アカウントでサインインする場合は、[gcloud CLI](https://cloud.google.com/sdk/docs/install)

## Claude Code をセットアップする

**1. アプリケーションのデフォルト認証情報を作成する**

> [tab] Google アカウント
>
> シェルで次のコマンドを実行し、`roles/claude.user` ロールを持つ Google アカウントでサインインします。
>
> ```bash theme={null}
> gcloud auth application-default login
> ```
>
> すでに `gcloud auth login` を実行している場合でも、このコマンドを実行してください。
>
> `GOOGLE_APPLICATION_CREDENTIALS` が設定されている場合は、設定を解除してください。この変数が設定されている間、Claude Code はその変数で指定されたファイルを使用し、このコマンドで保存された認証情報を無視します。

> [tab] サービスアカウントキーファイル
>
> Claude Code を実行するシェルまたは CI ジョブで、`GOOGLE_APPLICATION_CREDENTIALS` に[サービスアカウントキーファイル](https://docs.cloud.google.com/iam/docs/keys-create-delete)のパスを設定します。その他の認証情報ソースについては、[認証方法](https://platform.claude.com/docs/en/build-with-claude/claude-models-on-google-cloud/anthropic-managed#authentication)を参照してください。

**2. 設定に変数を追加する**

[ユーザー設定ファイル](https://code.claude.com/docs/ja/settings.md) `~/.claude/settings.json` の `env` ブロックに 3 つの変数を追加します。ファイルが存在しない場合は、次の内容で作成します。

```json theme={null}
{
  "env": {
    "CLAUDE_CODE_USE_ANTHROPIC_GOOGLE_CLOUD": "1",
    "ANTHROPIC_GOOGLE_CLOUD_PROJECT": "my-project-id",
    "ANTHROPIC_GOOGLE_CLOUD_WORKSPACE_ID": "wrkspc_01ABCDEFGHIJKLMN"
  }
}
```

`my-project-id` と `wrkspc_` の値の代わりに、自分のプロジェクト ID と[ワークスペース ID](https://platform.claude.com/docs/en/build-with-claude/claude-models-on-google-cloud/anthropic-managed#find-your-workspace-id) を使用してください。代わりに単一のシェルまたは CI ジョブを設定するには、その環境で同じ 3 つの変数を設定します。

Anthropic アカウントにログインする必要も、ログアウトする必要もありません。

**3. Claude Code を起動してプロバイダーを確認する**

シェルで `claude` を実行し、Claude Code のプロンプトで `/status` を実行します。`API provider` の行には `on Google Cloud` が含まれ、その後の行には `Workspace ID`、`GCP project`、`GCP location` が表示されます。同じ行をシェルまたは CI ジョブから出力するには、[`claude auth status --text`](https://code.claude.com/docs/ja/cli-reference) を実行します。

`on Google Cloud` が表示された場合は、プロンプトを送信するか、CI ジョブで `claude -p "hello"` を実行します。応答が返れば、認証情報と IAM ロールが機能していることを確認できます。表示されない場合、または Claude Code にエラーが表示される場合は、[プロバイダーのセットアップをトラブルシューティング](#troubleshooting)してください。

### チーム向けに Claude Code をセットアップする

[Claude Code をセットアップする](#set-up-claude-code)のステップ 2 の `env` ブロックを、各開発者のマシン上の[管理設定](https://code.claude.com/docs/ja/managed-settings.md)ファイルに記述します。各開発者にプロジェクトの `roles/claude.user` ロールを付与し、各自のマシンで `gcloud auth application-default login` を実行してもらいます。

## モデルバージョンを固定する

チームにデプロイする場合は、Claude Code のアップデートによって全員が一斉に新しいモデルへ移行しないように、[モデル ID を固定](https://code.claude.com/docs/ja/model-config.md#pin-models-for-third-party-deployments)してください。[Claude Code をセットアップする](#set-up-claude-code)の 3 つの変数を含む `env` ブロックに、次の変数を追加します。

```json theme={null}
{
  "env": {
    "ANTHROPIC_DEFAULT_OPUS_MODEL": "claude-opus-5-5",
    "ANTHROPIC_DEFAULT_SONNET_MODEL": "claude-sonnet-5-5",
    "ANTHROPIC_DEFAULT_FABLE_MODEL": "claude-fable-5-1",
    "ANTHROPIC_DEFAULT_HAIKU_MODEL": "claude-haiku-4-5-20251001"
  }
}
```

例の値の代わりに、[モデルの概要](https://platform.claude.com/docs/en/about-claude/models/overview)から使用したい Claude API のモデル ID を指定してください。

## 環境変数

| 変数 | 必須 | 説明 |
| - | - | - |
| `CLAUDE_CODE_USE_ANTHROPIC_GOOGLE_CLOUD` | はい | `1` に設定すると、モデルリクエストを Google Cloud 上の Claude モデル（Anthropic 管理）に送信します |
| `ANTHROPIC_GOOGLE_CLOUD_WORKSPACE_ID` | はい（`ANTHROPIC_GOOGLE_CLOUD_BASE_URL` を設定する場合を除く） | ワークスペース ID |
| `ANTHROPIC_GOOGLE_CLOUD_PROJECT` | 推奨 | Google Cloud プロジェクト ID。指定しない場合、Claude Code は `GOOGLE_CLOUD_PROJECT` を使用します |
| `ANTHROPIC_GOOGLE_CLOUD_LOCATION` | いいえ | リクエスト URL 内の[ロケーション](https://platform.claude.com/docs/en/build-with-claude/claude-models-on-google-cloud/anthropic-managed#project-location-and-workspace-resolution)。デフォルトは `global` です |
| `ANTHROPIC_GOOGLE_CLOUD_BASE_URL` | いいえ | Claude Code がプロジェクト、ロケーション、ワークスペース ID から組み立てるベース URL を、たとえば [LLM ゲートウェイ](https://code.claude.com/docs/ja/llm-gateway)のアドレスなどに置き換えます。Claude Code は `/v1/messages` などの API パスを末尾に追加します |
| `CLAUDE_CODE_SKIP_ANTHROPIC_GOOGLE_CLOUD_AUTH` | いいえ | ゲートウェイ自体が Google の認証情報を付与する場合に `1` に設定すると、Claude Code は Google アクセストークンを送信しません |

## 利用できない Claude Code の機能

Claude Models on Google Cloud（Anthropic 管理）では、次の機能を使用できません。

* [Fast mode](https://code.claude.com/docs/ja/fast-mode.md): `/fast` や `fastMode` 設定でオンにすることはできません
* [Remote Control](https://code.claude.com/docs/ja/remote-control.md) と[クラウドセッション](https://code.claude.com/docs/ja/claude-code-on-the-web.md)
* [claude.ai の MCP コネクタ](https://code.claude.com/docs/ja/mcp.md#use-mcp-servers-from-claude-ai)
* [チャネル](https://code.claude.com/docs/ja/channels.md)
* [`/design-sync` コマンドと `/import` コマンド](https://code.claude.com/docs/ja/commands#all-commands)
* [サーバー管理設定](https://code.claude.com/docs/ja/server-managed-settings.md)。チームに設定を強制するには、代わりに各マシンで[管理設定](https://code.claude.com/docs/ja/managed-settings.md)を使用してください

利用できない、または部分的にサポートされているその他の機能を確認するには、[機能の利用可否の概要](https://code.claude.com/docs/ja/feature-availability.md#summary-by-provider)で **Google Cloud (Anthropic managed)** タブを選択してください。

## トラブルシューティング

Claude Code からログインを求められる場合、または `/status` の `API provider` の行に `on Google Cloud` が含まれない場合:

* `CLAUDE_CODE_USE_ANTHROPIC_GOOGLE_CLOUD` が `1` であることを確認します
* `claude --version` が 2.1.307 以降を出力することを確認します
* シェルと[設定ファイル](https://code.claude.com/docs/ja/settings.md#find-or-create-your-settings-files)から `CLAUDE_CODE_USE_BEDROCK`、`CLAUDE_CODE_USE_FOUNDRY`、`CLAUDE_CODE_USE_ANTHROPIC_AWS` を削除します

`CLAUDE_CODE_USE_VERTEX` は設定したままでかまいません。変数を変更したら、Claude Code を再起動してください。`/status` に変更が反映されない場合は、[設定した値が無視される](https://code.claude.com/docs/ja/settings.md#a-value-you-set-is-ignored)を参照してください。

### `No workspace ID found`

`ANTHROPIC_GOOGLE_CLOUD_WORKSPACE_ID` に[ワークスペース ID](https://platform.claude.com/docs/en/build-with-claude/claude-models-on-google-cloud/anthropic-managed#find-your-workspace-id) を設定し、Claude Code を再起動します。メッセージに記載されている `workspaceId` コンストラクターオプションは無視してください。これは自分のコードから Anthropic の SDK を呼び出すユーザー向けのものです。

### `No project was given`

`ANTHROPIC_GOOGLE_CLOUD_PROJECT` に Google Cloud プロジェクト ID を設定し、Claude Code を再起動します。

### `Could not load Google Cloud credentials`

[Claude Code をセットアップする](#set-up-claude-code)のステップ 1 をやり直します。サービスアカウントキーファイルを使用している場合は、新しいキーを使用してください。

### `Google Cloud credentials expired or invalid`

メッセージで Google Cloud の認証情報を更新するよう指示されている場合は、[Claude Code をセットアップする](#set-up-claude-code)のステップ 1 をやり直します。サービスアカウントキーファイルを使用している場合は、新しいキーを使用してください。

### `Google Cloud authentication failed`

[`Google Cloud credentials expired or invalid`](#google-cloud-credentials-expired-or-invalid) の手順に従います。それでもエラーが解消しない場合:

* **プロジェクト**: `/status` で、`GCP project` の行に自分のプロジェクトが表示されていることを確認します。別のプロジェクトが表示されている場合、またはその行がない場合は、[`No project was given`](#no-project-was-given) の手順に従います
* **ワークスペース**: `/status` で、`Workspace ID` の行に自分のワークスペース ID が表示されていることを確認します。別の ID が表示されている場合は、[`No workspace ID found`](#no-workspace-id-found) の手順に従います
* **IAM ロール**: Claude Code を実行する Google アカウントまたはサービスアカウントが、`GCP project` の行に表示されているプロジェクトで `roles/claude.user` または `roles/claude.admin` を持っていることを確認します。ロールを付与するには、[サービスの付与コマンド](https://platform.claude.com/docs/en/build-with-claude/claude-models-on-google-cloud/anthropic-managed#before-making-api-calls)を使用するか、プロジェクト管理者に付与を依頼してください
* **サービス**: `GCP project` の行に表示されているプロジェクトで `claude.googleapis.com` サービスが有効になっていることを確認します。有効にするには、[サービスのアカウントセットアップ手順](https://platform.claude.com/docs/en/build-with-claude/claude-models-on-google-cloud/anthropic-managed#set-up-your-account)に従うか、プロジェクト管理者に有効化を依頼してください

## 関連リソース

* [Google Cloud 上の Claude モデル（Anthropic 管理）](https://platform.claude.com/docs/en/build-with-claude/claude-models-on-google-cloud/anthropic-managed): アカウントのセットアップ、IAM ロール、請求、データ保持、機能のサポート
* [エンタープライズデプロイの概要](https://code.claude.com/docs/ja/third-party-integrations.md): Claude Code を導入するその他の方法、およびプロキシとゲートウェイのセットアップ
* [モデル設定](https://code.claude.com/docs/ja/model-config.md): モデルエイリアス、モデルバージョンの固定、ユーザーが選択できるモデルの制限
