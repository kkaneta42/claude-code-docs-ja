> ## Documentation Index
> Fetch the complete documentation index at: https://code.claude.com/docs/llms.txt
> Use this file to discover all available pages before exploring further.

# Amazon Bedrock 上の Claude Code

> Amazon Bedrock を通じた Claude Code の設定方法（セットアップ、IAM 設定、トラブルシューティングを含む）について学習します。

## 前提条件

Claude Code を Bedrock で設定する前に、以下を確認してください。

* Bedrock アクセスが有効になっている AWS アカウント
* Bedrock で目的の Claude モデル（例：Claude Sonnet 4.5）へのアクセス
* AWS CLI がインストールされ、設定されていること（オプション - 別の認証情報取得メカニズムがない場合のみ必要）
* 適切な IAM 権限

## セットアップ

### 1. ユースケースの詳細を送信

Anthropic モデルの初回ユーザーは、モデルを呼び出す前にユースケースの詳細を送信する必要があります。これはアカウントごとに 1 回行われます。

1. 適切な IAM 権限があることを確認してください（詳細は以下を参照）
2. [Amazon Bedrock コンソール](https://console.aws.amazon.com/bedrock/)に移動します
3. **Chat/Text playground** を選択します
4. 任意の Anthropic モデルを選択すると、ユースケースフォームの入力を求められます

### 2. AWS 認証情報を設定

Claude Code は、デフォルトの AWS SDK 認証情報チェーンを使用します。以下のいずれかの方法を使用して認証情報を設定してください。

**オプション A：AWS CLI 設定**

```bash  theme={null}
aws configure
```

**オプション B：環境変数（アクセスキー）**

```bash  theme={null}
export AWS_ACCESS_KEY_ID=your-access-key-id
export AWS_SECRET_ACCESS_KEY=your-secret-access-key
export AWS_SESSION_TOKEN=your-session-token
```

**オプション C：環境変数（SSO プロファイル）**

```bash  theme={null}
aws sso login --profile=<your-profile-name>

export AWS_PROFILE=your-profile-name
```

**オプション D：AWS Management Console 認証情報**

```bash  theme={null}
aws login
```

`aws login` について[詳細を確認](https://docs.aws.amazon.com/signin/latest/userguide/command-line-sign-in.html)してください。

**オプション E：Bedrock API キー**

```bash  theme={null}
export AWS_BEARER_TOKEN_BEDROCK=your-bedrock-api-key
```

Bedrock API キーは、完全な AWS 認証情報を必要としない、より簡単な認証方法を提供します。[Bedrock API キーについて詳細を確認](https://aws.amazon.com/blogs/machine-learning/accelerate-ai-development-with-amazon-bedrock-api-keys/)してください。

#### 高度な認証情報設定

Claude Code は、AWS SSO および企業 ID プロバイダーの自動認証情報更新をサポートしています。これらの設定を Claude Code 設定ファイルに追加してください（ファイルの場所については[設定](/ja/settings)を参照）。

Claude Code が AWS 認証情報の有効期限が切れていることを検出した場合（ローカルのタイムスタンプに基づくか、Bedrock が認証情報エラーを返した場合）、設定された `awsAuthRefresh` および/または `awsCredentialExport` コマンドを自動的に実行して、リクエストを再試行する前に新しい認証情報を取得します。

##### 設定例

```json  theme={null}
{
  "awsAuthRefresh": "aws sso login --profile myprofile",
  "env": {
    "AWS_PROFILE": "myprofile"
  }
}
```

##### 設定の説明

**`awsAuthRefresh`**：`.aws` ディレクトリを変更するコマンド（認証情報の更新、SSO キャッシュ、設定ファイルの更新など）に使用します。コマンドの出力はユーザーに表示されますが、対話的な入力はサポートされていません。これは、CLI が URL またはコードを表示し、ブラウザで認証を完了するブラウザベースの SSO フローに適しています。

**`awsCredentialExport`**：`.aws` を変更できず、認証情報を直接返す必要がある場合にのみ使用します。出力は静かにキャプチャされ、ユーザーに表示されません。コマンドは以下の形式で JSON を出力する必要があります。

```json  theme={null}
{
  "Credentials": {
    "AccessKeyId": "value",
    "SecretAccessKey": "value",
    "SessionToken": "value"
  }
}
```

### 3. Claude Code を設定

Bedrock を有効にするために、以下の環境変数を設定します。

```bash  theme={null}
# Bedrock 統合を有効にする
export CLAUDE_CODE_USE_BEDROCK=1
export AWS_REGION=us-east-1  # または希望するリージョン

# オプション：小型/高速モデル（Haiku）のリージョンをオーバーライド
export ANTHROPIC_SMALL_FAST_MODEL_AWS_REGION=us-west-2
```

Claude Code で Bedrock を有効にする場合、以下の点に注意してください。

* `AWS_REGION` は必須の環境変数です。Claude Code はこの設定について `.aws` 設定ファイルから読み込みません。
* Bedrock を使用する場合、`/login` および `/logout` コマンドは無効になります。認証は AWS 認証情報を通じて処理されるためです。
* 他のプロセスに漏らしたくない `AWS_PROFILE` などの環境変数に対して、設定ファイルを使用できます。詳細については[設定](/ja/settings)を参照してください。

### 4. モデル設定

Claude Code は Bedrock に対して以下のデフォルトモデルを使用します。

| モデルタイプ   | デフォルト値                                             |
| :------- | :------------------------------------------------- |
| プライマリモデル | `global.anthropic.claude-sonnet-4-5-20250929-v1:0` |
| 小型/高速モデル | `us.anthropic.claude-haiku-4-5-20251001-v1:0`      |

<Note>
  Bedrock ユーザーの場合、Claude Code は Haiku 3.5 から Haiku 4.5 に自動的にアップグレードされません。新しい Haiku モデルに手動で切り替えるには、`ANTHROPIC_DEFAULT_HAIKU_MODEL` 環境変数をフルモデル名に設定します（例：`us.anthropic.claude-haiku-4-5-20251001-v1:0`）。
</Note>

モデルをカスタマイズするには、以下のいずれかの方法を使用します。

```bash  theme={null}
# 推論プロファイル ID を使用
export ANTHROPIC_MODEL='global.anthropic.claude-sonnet-4-5-20250929-v1:0'
export ANTHROPIC_SMALL_FAST_MODEL='us.anthropic.claude-haiku-4-5-20251001-v1:0'

# アプリケーション推論プロファイル ARN を使用
export ANTHROPIC_MODEL='arn:aws:bedrock:us-east-2:your-account-id:application-inference-profile/your-model-id'

# オプション：必要に応じてプロンプトキャッシングを無効にする
export DISABLE_PROMPT_CACHING=1
```

<Note>[プロンプトキャッシング](https://platform.claude.com/docs/ja/build-with-claude/prompt-caching)はすべてのリージョンで利用できない場合があります。</Note>

### 5. 出力トークン設定

Amazon Bedrock で Claude Code を使用するための推奨トークン設定は以下の通りです。

```bash  theme={null}
# Bedrock の推奨出力トークン設定
export CLAUDE_CODE_MAX_OUTPUT_TOKENS=4096
export MAX_THINKING_TOKENS=1024
```

**これらの値の理由：**

* **`CLAUDE_CODE_MAX_OUTPUT_TOKENS=4096`**：Bedrock のバーンダウンスロットリングロジックは、`max_token` ペナルティの最小値として 4096 トークンを設定します。これを低く設定しても、コストは削減されませんが、長いツール使用がカットオフされ、Claude Code エージェントループが永続的に失敗する可能性があります。Claude Code は通常、拡張思考なしで 4096 出力トークン未満を使用しますが、ファイル作成やライトツール使用に関連するタスクでこのヘッドルームが必要な場合があります。

* **`MAX_THINKING_TOKENS=1024`**：これは、ツール使用応答をカットオフすることなく拡張思考のためのスペースを提供しながら、焦点を絞った推論チェーンを維持します。このバランスは、コーディングタスク特有には常に有用とは限らない軌跡の変更を防ぐのに役立ちます。

## IAM 設定

Claude Code に必要な権限を持つ IAM ポリシーを作成します。

```json  theme={null}
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "AllowModelAndInferenceProfileAccess",
      "Effect": "Allow",
      "Action": [
        "bedrock:InvokeModel",
        "bedrock:InvokeModelWithResponseStream",
        "bedrock:ListInferenceProfiles"
      ],
      "Resource": [
        "arn:aws:bedrock:*:*:inference-profile/*",
        "arn:aws:bedrock:*:*:application-inference-profile/*",
        "arn:aws:bedrock:*:*:foundation-model/*"
      ]
    },
    {
      "Sid": "AllowMarketplaceSubscription",
      "Effect": "Allow",
      "Action": [
        "aws-marketplace:ViewSubscriptions",
        "aws-marketplace:Subscribe"
      ],
      "Resource": "*",
      "Condition": {
        "StringEquals": {
          "aws:CalledViaLast": "bedrock.amazonaws.com"
        }
      }
    }
  ]
}
```

より制限的な権限の場合、リソースを特定の推論プロファイル ARN に制限できます。

詳細については、[Bedrock IAM ドキュメント](https://docs.aws.amazon.com/bedrock/latest/userguide/security-iam.html)を参照してください。

<Note>
  Claude Code のコスト追跡とアクセス制御を簡素化するために、専用の AWS アカウントを作成することをお勧めします。
</Note>

## AWS Guardrails

[Amazon Bedrock Guardrails](https://docs.aws.amazon.com/bedrock/latest/userguide/guardrails.html) を使用すると、Claude Code のコンテンツフィルタリングを実装できます。[Amazon Bedrock コンソール](https://console.aws.amazon.com/bedrock/)で Guardrail を作成し、バージョンを公開してから、Guardrail ヘッダーを[設定ファイル](/ja/settings)に追加します。クロスリージョン推論プロファイルを使用している場合は、Guardrail でクロスリージョン推論を有効にします。

設定例：

```json  theme={null}
{
  "env": {
    "ANTHROPIC_CUSTOM_HEADERS": "X-Amzn-Bedrock-GuardrailIdentifier: your-guardrail-id\nX-Amzn-Bedrock-GuardrailVersion: 1"
  }
}
```

## トラブルシューティング

リージョンの問題が発生した場合：

* モデルの可用性を確認します：`aws bedrock list-inference-profiles --region your-region`
* サポートされているリージョンに切り替えます：`export AWS_REGION=us-east-1`
* クロスリージョンアクセスのために推論プロファイルの使用を検討します

「オンデマンドスループットはサポートされていません」というエラーが表示される場合：

* モデルを[推論プロファイル](https://docs.aws.amazon.com/bedrock/latest/userguide/inference-profiles-support.html) ID として指定します

Claude Code は Bedrock [Invoke API](https://docs.aws.amazon.com/bedrock/latest/APIReference/API_runtime_InvokeModelWithResponseStream.html) を使用し、Converse API はサポートしていません。

## 追加リソース

* [Bedrock ドキュメント](https://docs.aws.amazon.com/bedrock/)
* [Bedrock 価格](https://aws.amazon.com/bedrock/pricing/)
* [Bedrock 推論プロファイル](https://docs.aws.amazon.com/bedrock/latest/userguide/inference-profiles-support.html)
* [Claude Code on Amazon Bedrock：クイックセットアップガイド](https://community.aws/content/2tXkZKrZzlrlu0KfH8gST5Dkppq/claude-code-on-amazon-bedrock-quick-setup-guide)
* [Claude Code 監視実装（Bedrock）](https://github.com/aws-solutions-library-samples/guidance-for-claude-code-with-amazon-bedrock/blob/main/assets/docs/MONITORING.md)
