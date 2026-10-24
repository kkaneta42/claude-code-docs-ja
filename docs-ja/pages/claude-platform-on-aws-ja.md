> ## Documentation Index
> Fetch the complete documentation index at: https://code.claude.com/docs/llms.txt
> Use this file to discover all available pages before exploring further.

# AWS 上の Claude Platform での Claude Code

> AWS 認証、IAM アクセス制御、AWS Marketplace 請求を使用して、Anthropic が運営する Claude API を使用するように Claude Code を設定します。

AWS 上の Claude Platform は、AWS 認証、IAM アクセス制御、AWS Marketplace 請求を備えた Anthropic が運営する Claude API です。リクエストは Anthropic の API に直接到達するため、[Claude API](https://platform.claude.com/docs) と同じモデルと API 機能を同じリリーススケジュールで取得できます。AWS 認証情報またはワークスペース API キーで認証し、AWS Marketplace を通じて支払います。

Claude Code が Anthropic の機能フラグサービスを通じてオンにするクライアント側機能はデフォルトではオフであり、[アドバイザーツール](https://code.claude.com/docs/ja/advisor.md)は利用できません。完全なリストについては、[機能可用性マトリックス](https://code.claude.com/docs/ja/feature-availability.md#summary-by-provider)を参照してください。

このガイドを使用して、AWS 上の Claude Platform を通じてすでにプロビジョニングしたワークスペースに Claude Code をポイントします。このガイドの前に行う AWS サブスクリプションとワークスペースのセットアップについては、[AWS 上の Claude Platform ドキュメント](https://platform.claude.com/docs/en/build-with-claude/claude-platform-on-aws)を参照してください。

> [!NOTE]
>
> AWS Marketplace を通じてサブスクリプションすると、AWS アカウントに関連付けられた新しい Anthropic 組織がプロビジョニングされます。この組織は、Anthropic で既に持っている組織とは別であり、認証情報はそれらの間で転送されません。AWS にリンクされた組織のワークスペース ID と API キーを使用してください。既存の Claude Console アカウントからではなく。

## 前提条件

Claude Code を設定する前に、以下が必要です。

* AWS Marketplace を通じた有効な AWS 上の Claude Platform サブスクリプション
* AWS にリンクされた Anthropic 組織内のワークスペース（ワークスペース ID 付き）
* Anthropic サービスを呼び出す権限を持つ IAM プリンシパル、またはワークスペースにスコープされた API キー
* 環境内、`~/.aws/credentials` 内、または SigV4 認証が必要な場合は接続された IAM ロールからの AWS 認証情報。AWS CLI は SSO ログインフローにのみ必要です。

## セットアップ

### AWS 認証情報を設定する

Claude Code は AWS 上の Claude Platform に対して 2 つの認証方法をサポートしています。チームがアクセスを管理する方法に合った方法を選択してください。

* [SigV4 を使用した AWS 認証情報](#use-aws-credentials-with-sigv4): 標準的な AWS 認証情報チェーンから取得した認証情報を使用し、IAM プリンシパルとして認証します
* [ワークスペース API キー](#use-a-workspace-api-key): AWS Console で生成した長期間有効なキーで認証します

#### SigV4 を使用した AWS 認証情報を使用する

Claude Code は標準的な AWS 認証情報チェーンを使用して SigV4 でリクエストに署名します。環境変数、`~/.aws/credentials` の共有認証情報、IAM ロール、AWS SSO セッション、および AWS SDK がサポートするその他のソース。

ローカル使用の場合、Claude Code を開始する前に AWS CLI でログインしてください。以下の例は SSO プロファイルを使用していますが、標準的な場所に認証情報を生成する任意の方法が機能します。

```bash theme={null}
aws sso login --profile my-profile
export AWS_PROFILE=my-profile
```

CI と自動化の場合、Anthropic サービスを呼び出す権限を持つ IAM ロールをランナーに付与し、`AWS_REGION` を設定します。認証情報チェーンはロールを自動的に取得します。

SSO 認証情報がセッション中に期限切れになった場合、[`awsAuthRefresh`](https://code.claude.com/docs/ja/amazon-bedrock#advanced-credential-configuration) を設定して、Claude Code がログインコマンドを再実行し、失敗する代わりに再試行するようにします。コマンドを [設定ファイル](https://code.claude.com/docs/ja/settings.md)（`~/.claude/settings.json` など）に追加します。

```json theme={null}
{
  "awsAuthRefresh": "aws sso login --profile my-profile"
}
```

Claude Code は起動時にこのコマンドを実行して既存の AWS 認証情報を検証できない場合も実行し、ログインが完了するまで `Authentication` パネルにコマンドの出力を表示します。

`awsAuthRefresh` が設定されている場合、`/login` を実行し、**3rd-party platform** を選択してから、**Using 3rd-party platforms** の下で **Claude Platform on AWS · refresh credentials** を選択します。Claude Code は設定されたコマンドを実行し、再起動せずに AWS 認証情報を再度読み込みます。

#### ワークスペース API キーを使用する

ワークスペース API キーは長期間有効なシークレットで、フェデレーション AWS 認証情報を管理したくない場合に便利です。AWS Console の **Claude Platform on AWS → API keys** で生成し、`ANTHROPIC_AWS_API_KEY` として設定します。

```bash theme={null}
export ANTHROPIC_AWS_API_KEY=sk-ant-xxxxx
```

キーは `x-api-key` として送信され、SigV4 よりも優先されるため、環境内の AWS 認証情報は無視されます。別の Claude Console 組織からの API キーはここでは機能しません。

ワークスペース API キーは他の本番認証情報と同様に扱ってください。[ユーザー設定ファイル](https://code.claude.com/docs/ja/settings.md) の `env` ブロックは、グローバルにエクスポートせずにキーをマシンにスコープするための便利な方法です。

> [!NOTE]
>
> `/login` および `/logout` コマンドは Claude.ai サブスクリプションに対して Claude Platform on AWS にサインインしません。認証は AWS 認証情報またはワークスペース API キーを通じて実行されます。

### Claude Code を設定する

Claude Code をデフォルトの Anthropic API ではなく AWS 上の Claude Platform を通じてルーティングする環境変数を設定します。

```bash theme={null}
export CLAUDE_CODE_USE_ANTHROPIC_AWS=1
export ANTHROPIC_AWS_WORKSPACE_ID=wrkspc_01ABCDEFGHIJKLMN
export AWS_REGION=us-east-1
```

`ANTHROPIC_AWS_WORKSPACE_ID` は必須です。Claude Code はすべてのリクエストで `anthropic-workspace-id` ヘッダーとして送信します。例の `wrkspc_01ABCDEFGHIJKLMN` 値を AWS 上の Claude Platform セットアップから取得した独自のワークスペース ID に置き換えます。

Claude Code はベース URL を AWS リージョンから `https://aws-external-anthropic.{region}.api.aws` として計算します。これは [Amazon Bedrock と同じ優先度](https://code.claude.com/docs/ja/amazon-bedrock.md#3-configure-claude-code) で解決されます。URL を直接オーバーライドするには、`ANTHROPIC_AWS_BASE_URL` を設定します。

AWS 上の Claude Platform は、環境に AWS 認証情報が存在する場合でもオプトインです。Amazon Bedrock と Microsoft Foundry はプロバイダールーティングで優先されるため、設定されている場合は `CLAUDE_CODE_USE_BEDROCK` と `CLAUDE_CODE_USE_FOUNDRY` をアンセットします。

### モデルバージョンをピン留めする

AWS 上の Claude Platform は、直接 Claude API と同じモデル ID を使用します。

デフォルトのエイリアス `fable`、`opus`、`sonnet`、`haiku` は Claude Code の AWS 上の Claude Platform 用の組み込みデフォルトに解決されます。これは最新リリースより遅れる可能性があります。`ANTHROPIC_DEFAULT_OPUS_MODEL` がない場合、`opus` エイリアスは Opus 5.5 に解決されます。v2.1.280 より前は、v2.1.219 以降では Opus 5 に、v2.1.207 以降では Opus 4.8 に解決されていました。

Claude Code をチームにデプロイする場合、モデル ID を明示的にピン留めして、新しいリリースがすべてのユーザーを一度に移動しないようにします。

```bash theme={null}
export ANTHROPIC_DEFAULT_FABLE_MODEL=claude-fable-5
export ANTHROPIC_DEFAULT_OPUS_MODEL=claude-opus-4-8
export ANTHROPIC_DEFAULT_SONNET_MODEL=claude-sonnet-5
export ANTHROPIC_DEFAULT_HAIKU_MODEL=claude-haiku-4-5
```

モデル ID とエイリアスの完全なリストについては、[モデル概要](https://platform.claude.com/docs/en/about-claude/models/overview) を参照してください。その他のモデル関連の変数については、[モデル設定](https://code.claude.com/docs/ja/model-config.md) を参照してください。

[プロンプトキャッシング](https://code.claude.com/docs/ja/prompt-caching.md) は自動的に有効になります。5 分のデフォルトの代わりに 1 時間のキャッシュ TTL をリクエストするには、`ENABLE_PROMPT_CACHING_1H=1` を設定します。API は 1 時間のキャッシュ書き込みをより高いレートで請求します。レートについては、[プロンプトキャッシング価格](https://platform.claude.com/docs/en/build-with-claude/prompt-caching#pricing) を参照してください。

メインの会話と Claude Code が実行するリクエストに異なる TTL を設定するには、[TTL を自分で選択](https://code.claude.com/docs/ja/prompt-caching.md#choose-the-ttl-yourself) してください。

### 起動して検証する

Claude Code を起動し、ルーティングを確認します。

```bash theme={null}
claude
```

起動バナーはプロバイダーがアクティブな場合に `Claude Platform on AWS` を表示します。`/status` を実行して詳細を確認します。`API provider` 行は `Claude Platform on AWS` を読み取り、出力には `Workspace ID`、`AWS region`、およびオーバーライドを設定した場合は `Claude Platform on AWS base URL` が含まれます。

## Agent SDK を使用する

[Agent SDK](https://code.claude.com/docs/ja/agent-sdk/overview.md) は CLI と同じ環境変数を読み取るため、Claude Code サブプロセスを生成するプログラムは、呼び出しの前に `CLAUDE_CODE_USE_ANTHROPIC_AWS`、`ANTHROPIC_AWS_WORKSPACE_ID`、および `ANTHROPIC_AWS_API_KEY` または AWS 認証情報をエクスポートすることで AWS 上の Claude Platform をターゲットにできます。

```typescript theme={null}
import { query } from "@anthropic-ai/claude-agent-sdk";

process.env.CLAUDE_CODE_USE_ANTHROPIC_AWS = "1";
process.env.ANTHROPIC_AWS_WORKSPACE_ID = "wrkspc_01ABCDEFGHIJKLMN";
process.env.AWS_REGION = "us-east-1";

for await (const msg of query({ prompt: "What's in this repo?" })) {
  console.log(msg);
}
```

この例は SigV4 のアンビエント AWS 認証情報チェーンに依存しています。代わりにワークスペース API キーで認証するには、同じ方法で `ANTHROPIC_AWS_API_KEY` を設定します。より広い Agent SDK サーフェスについては、[Agent SDK 概要](https://code.claude.com/docs/ja/agent-sdk/overview.md)を参照してください。

## 企業プロキシを通じてルーティングする

プロキシまたは [LLM ゲートウェイ](https://code.claude.com/docs/ja/llm-gateway)を通じてトラフィックをルーティングするには、`ANTHROPIC_AWS_BASE_URL` をプロキシのアドレスに設定します。Claude Code は同じワークスペースと認証ヘッダーを使用してそのアドレスにリクエストを送信するため、それらを変更せずに転送するゲートウェイが機能します。

```bash theme={null}
export CLAUDE_CODE_USE_ANTHROPIC_AWS=1
export ANTHROPIC_AWS_WORKSPACE_ID=wrkspc_01ABCDEFGHIJKLMN
export ANTHROPIC_AWS_BASE_URL=https://anthropic-proxy.example.com
```

ゲートウェイがリクエストに自身で署名する場合、`CLAUDE_CODE_SKIP_ANTHROPIC_AWS_AUTH=1` を設定して、Claude Code が署名なしのリクエストを送信し、ゲートウェイが AWS に転送する前に SigV4 ヘッダーを追加するようにします。ゲートウェイが独自のトークンを必要とする場合は、`ANTHROPIC_AUTH_TOKEN` に設定します。

```bash theme={null}
export CLAUDE_CODE_USE_ANTHROPIC_AWS=1
export CLAUDE_CODE_SKIP_ANTHROPIC_AWS_AUTH=1
export ANTHROPIC_AWS_WORKSPACE_ID=wrkspc_01ABCDEFGHIJKLMN
export ANTHROPIC_AWS_BASE_URL=https://anthropic-proxy.example.com
```

## トラブルシューティング

`/status` を実行して、解決されたプロバイダーと明示的に設定されたワークスペース ID、リージョン、ベース URL オーバーライド、および認証スキップ設定を確認します。これは Claude Code が AWS 上の Claude Platform をターゲットにしているかどうかを確認する最速の方法です。

### すべてのリクエストで `403 Forbidden` または `AccessDenied`

Claude Code が解決した IAM プリンシパルは、ワークスペースで Anthropic サービスを呼び出す権限がない可能性があります。AWS プロファイルに接続されたロール、または Claude Code を開始したランナーを確認し、[IAM アクション参照](https://platform.claude.com/docs/ja/api/claude-platform-on-aws-iam-actions)に記載されている `aws-external-anthropic` アクションがあることを確認します。

`ANTHROPIC_AWS_API_KEY` を設定した場合、キーは SigV4 よりも優先され、古いキーは同じエラーを生成します。AWS Console の **Claude Platform on AWS → API keys** でキーを再生成するか、変数をアンセットして AWS 認証情報にフォールバックします。

### リクエストがワークスペース不足エラーで失敗する

`ANTHROPIC_AWS_WORKSPACE_ID` がアンセットまたは空の可能性があります。すべての AWS 上の Claude Platform リクエストにはワークスペース ID を含める必要があります。AWS 認証情報によって暗示されません。Claude Platform on AWS セットアップで ID を見つけ、Claude Code を開始する前にエクスポートします。

### リクエストが依然として `api.anthropic.com` に送信される

`CLAUDE_CODE_USE_ANTHROPIC_AWS` がアンセットまたは truthy として解析されない値に設定されている可能性があります。`1` に設定し、`/status` を実行して解決されたプロバイダーを確認します。`CLAUDE_CODE_USE_BEDROCK` または `CLAUDE_CODE_USE_FOUNDRY` も設定されている場合、それらは AWS 上の Claude Platform よりも優先されます。

## 追加リソース

Claude Code を設定する前に行う AWS 上の Claude Platform サブスクリプション、ワークスペース、IAM セットアップはプラットフォームドキュメントで説明されています。

* [AWS 上の Claude Platform 概要](https://platform.claude.com/docs/ja/build-with-claude/claude-platform-on-aws): サブスクリプション、ワークスペースセットアップ、製品リファレンス
* [IAM アクション参照](https://platform.claude.com/docs/ja/api/claude-platform-on-aws-iam-actions): 権限とマネージドポリシー
