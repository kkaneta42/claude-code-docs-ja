> ## Documentation Index
> Fetch the complete documentation index at: https://code.claude.com/docs/llms.txt
> Use this file to discover all available pages before exploring further.

# オートモードの設定

> オートモード分類器に、組織が信頼するリポジトリ、バケット、ドメインを指定します。環境コンテキストを設定し、デフォルトのブロックルールと許可ルールをオーバーライドし、オートモード CLI サブコマンドで有効な設定を確認します。

[オートモード](/ja/permission-modes#eliminate-prompts-with-auto-mode)を使用すると、Claude Code は各ツール呼び出しを分類器にルーティングして、不可逆的、破壊的、または環境外を対象とした操作をブロックすることで、権限プロンプトなしで実行できます。`autoMode` 設定ブロックを使用して、その分類器に、組織が信頼するリポジトリ、バケット、ドメインを指定すると、ルーチンの内部操作のブロックが停止します。

デフォルトでは、分類器は作業ディレクトリと現在のリポジトリの設定されたリモートのみを信頼します。会社のソース管理組織へのプッシュやチームクラウドバケットへの書き込みなどのアクションは、`autoMode.environment` に追加するまでブロックされます。

オートモードを有効にする方法とデフォルトでブロックされる内容については、[権限モード](/ja/permission-modes#eliminate-prompts-with-auto-mode)を参照してください。このページは設定リファレンスです。

このページでは、以下の方法について説明します。

* [ルールを設定する場所を選択する](#where-the-classifier-reads-configuration)（CLAUDE.md、ユーザー設定、管理設定全体）
* [`autoMode.environment` で信頼できるインフラストラクチャを定義する](#define-trusted-infrastructure)
* [デフォルトが適切でない場合、ブロックルールと許可ルールをオーバーライドする](#override-the-block-and-allow-rules)
* [`claude auto-mode` サブコマンドで有効な設定を確認する](#inspect-the-defaults-and-your-effective-config)
* [拒否を確認する](#review-denials)（次に何を追加するかを知るため）

## 分類器が設定を読み込む場所

分類器は Claude 自体が読み込む同じ [CLAUDE.md](/ja/memory) コンテンツを読み込むため、プロジェクトの CLAUDE.md の「force push を絶対にしない」のような指示は、Claude と分類器の両方を同時に制御します。プロジェクト規約と動作ルールはここから始めてください。

信頼できるインフラストラクチャや組織全体の拒否ルールなど、プロジェクト全体に適用されるルールについては、`autoMode` 設定ブロックを使用します。分類器は以下のスコープから `autoMode` を読み込みます。

| スコープ                          | ファイル                                | 用途                                   |
| :---------------------------- | :---------------------------------- | :----------------------------------- |
| 1 人の開発者                       | `~/.claude/settings.json`           | 個人の信頼できるインフラストラクチャ                   |
| 1 つのプロジェクト、1 人の開発者            | `.claude/settings.local.json`       | プロジェクトごとの信頼できるバケットまたはサービス、gitignored |
| 組織全体                          | [管理設定](/ja/server-managed-settings) | すべての開発者に配布される信頼できるインフラストラクチャ         |
| `--settings` フラグまたは Agent SDK | インライン JSON                          | 自動化のための呼び出しごとのオーバーライド                |

分類器は `.claude/settings.json` の共有プロジェクト設定から `autoMode` を読み込まないため、チェックインされたリポジトリは独自の許可ルールを注入できません。

各スコープのエントリは結合されます。開発者は個人エントリで `environment`、`allow`、`soft_deny` を拡張できますが、管理設定が提供するエントリを削除することはできません。許可ルールは分類器内のブロックルールの例外として機能するため、開発者が追加した `allow` エントリは組織の `soft_deny` エントリをオーバーライドできます。組み合わせは加算的であり、ハードポリシー境界ではありません。

<Note>
  分類器は[権限システム](/ja/permissions)の後に実行される 2 番目のゲートです。ユーザーの意図または分類器の設定に関係なく、実行してはいけないアクションについては、管理設定で `permissions.deny` を使用します。これは分類器が参照される前にアクションをブロックし、オーバーライドできません。
</Note>

## 信頼できるインフラストラクチャを定義する

ほとんどの組織では、`autoMode.environment` が設定する必要がある唯一のフィールドです。これは、分類器に、どのリポジトリ、バケット、ドメインが信頼できるかを指定します。分類器はこれを使用して「外部」が何を意味するかを決定するため、リストに記載されていない宛先は潜在的な流出ターゲットです。

`environment` を設定すると、デフォルトの環境リストが置き換わります。デフォルトには、作業リポジトリとそのリモートを信頼するエントリが含まれます。`claude auto-mode defaults` を実行してデフォルトを出力し、リストを狭めるのではなく拡張するように、独自のエントリと一緒に含めます。

```json theme={null}
{
  "autoMode": {
    "environment": [
      "Source control: github.example.com/acme-corp and all repos under it",
      "Trusted cloud buckets: s3://acme-build-artifacts, gs://acme-ml-datasets",
      "Trusted internal domains: *.corp.example.com, api.internal.example.com",
      "Key internal services: Jenkins at ci.example.com, Artifactory at artifacts.example.com"
    ]
  }
}
```

エントリは散文であり、正規表現またはツールパターンではありません。分類器はそれらを自然言語ルールとして読み込みます。新しいエンジニアにインフラストラクチャを説明する方法で記述してください。十分な環境セクションは以下をカバーします。

* **組織**: 会社名と Claude Code が主に使用される用途（ソフトウェア開発、インフラストラクチャ自動化、データエンジニアリングなど）
* **ソース管理**: 開発者がプッシュするすべての GitHub、GitLab、または Bitbucket 組織
* **クラウドプロバイダーと信頼できるバケット**: Claude が読み取りおよび書き込みできるバケット名またはプレフィックス
* **信頼できる内部ドメイン**: ネットワーク内の API、ダッシュボード、サービスのホスト名（`*.internal.example.com` など）
* **主要な内部サービス**: CI、アーティファクトレジストリ、内部パッケージインデックス、インシデント対応ツール
* **追加コンテキスト**: 規制業界の制約、マルチテナントインフラストラクチャ、または分類器がリスクとして扱うべき内容に影響するコンプライアンス要件

有用な開始テンプレート。括弧内のフィールドを入力し、適用されない行を削除します。

```json theme={null}
{
  "autoMode": {
    "environment": [
      "Organization: {COMPANY_NAME}. Primary use: {PRIMARY_USE_CASE, e.g. software development, infrastructure automation}",
      "Source control: {SOURCE_CONTROL, e.g. GitHub org github.example.com/acme-corp}",
      "Cloud provider(s): {CLOUD_PROVIDERS, e.g. AWS, GCP, Azure}",
      "Trusted cloud buckets: {TRUSTED_BUCKETS, e.g. s3://acme-builds, gs://acme-datasets}",
      "Trusted internal domains: {TRUSTED_DOMAINS, e.g. *.internal.example.com, api.example.com}",
      "Key internal services: {SERVICES, e.g. Jenkins at ci.example.com, Artifactory at artifacts.example.com}",
      "Additional context: {EXTRA, e.g. regulated industry, multi-tenant infrastructure, compliance requirements}"
    ]
  }
}
```

より具体的なコンテキストを提供するほど、分類器はルーチンの内部操作と流出の試みをより良く区別できます。

すべてを一度に入力する必要はありません。合理的なロールアウト。デフォルトから始めて、ソース管理組織と主要な内部サービスを追加します。これにより、独自のリポジトリへのプッシュなど、最も一般的な誤検知が解決されます。次に信頼できるドメインとクラウドバケットを追加します。ブロックが発生したら残りを入力します。

## ブロックルールと許可ルールをオーバーライドする

2 つの追加フィールドを使用すると、分類器の組み込みルールリストを置き換えることができます。`autoMode.soft_deny` はブロックされる内容を制御し、`autoMode.allow` は適用される例外を制御します。各フィールドは散文説明の配列であり、自然言語ルールとして読み込まれます。`autoMode.deny` フィールドはありません。意図に関係なくアクションをハードブロックするには、分類器の前に実行される [`permissions.deny`](/ja/permissions) を使用します。

分類器内では、優先順位は 3 つのレベルで機能します。

* `soft_deny` ルールが最初にブロック
* `allow` ルールが一致するブロックを例外としてオーバーライド
* 明示的なユーザーの意図が両方をオーバーライド。ユーザーのメッセージが Claude が実行しようとしている正確なアクションを直接かつ具体的に説明する場合、`soft_deny` ルールが一致しても分類器はそれを許可します

一般的なリクエストは明示的な意図としてカウントされません。Claude に「リポジトリをクリーンアップする」ように依頼することは force push を認可しませんが、「このブランチを force push する」ように依頼することは認可します。

<Danger>
  `environment`、`allow`、`soft_deny` のいずれかを設定すると、そのセクション全体のデフォルトリストが置き換わります。単一のエントリで `soft_deny` を設定すると、すべての組み込みブロックルール（force push、データ流出、`curl | bash`、本番環境へのデプロイ、その他すべてのデフォルトブロックルール）が破棄されて許可されます。安全にカスタマイズするには、`claude auto-mode defaults` を実行して組み込みルールを出力し、それらを設定ファイルにコピーしてから、各ルールを独自のパイプラインとリスク許容度に対して確認します。インフラストラクチャが既に軽減しているリスクのルールのみを削除します。
</Danger>

緩和するには。デフォルトがパイプラインが既に PR レビュー、CI、またはステージング環境で保護しているものをブロックする場合、`soft_deny` からルールを削除するか、分類器がデフォルトの例外がカバーしていないルーチンパターンを繰り返しフラグする場合、`allow` に追加します。厳しくするには。環境に固有で、デフォルトが見落としているリスクについて `soft_deny` に追加するか、デフォルトの例外をブロックルールに保持するために `allow` から削除します。すべての場合において、`claude auto-mode defaults` を実行して完全なデフォルトリストを取得し、コピーして編集します。空のリストから開始しないでください。

```json theme={null}
{
  "autoMode": {
    "environment": [
      "Source control: github.example.com/acme-corp and all repos under it"
    ],
    "allow": [
      "Deploying to the staging namespace is allowed: staging is isolated from production and resets nightly",
      "Writing to s3://acme-scratch/ is allowed: ephemeral bucket with a 7-day lifecycle policy"
    ],
    "soft_deny": [
      "Never run database migrations outside the migrations CLI, even against dev databases",
      "Never modify files under infra/terraform/prod/: production infrastructure changes go through the review workflow",
      "...copy full default soft_deny list here first, then add your rules..."
    ]
  }
}
```

各セクションは独自のデフォルトのみを置き換えるため、`environment` のみを設定すると、デフォルトの `allow` および `soft_deny` リストはそのままになります。

## デフォルトと有効な設定を確認する

3 つの配列のいずれかを設定するとそのデフォルトが置き換わるため、カスタマイズを開始する前に完全なデフォルトリストをコピーします。3 つの CLI サブコマンドは、検査と検証に役立ちます。

組み込みの `environment`、`allow`、`soft_deny` ルールを JSON として出力します。

```bash theme={null}
claude auto-mode defaults
```

分類器が実際に使用する内容を JSON として出力します。設定が設定されている場合はそれを適用し、そうでない場合はデフォルトを適用します。

```bash theme={null}
claude auto-mode config
```

カスタム `allow` および `soft_deny` ルールに関する AI フィードバックを取得します。

```bash theme={null}
claude auto-mode critique
```

`claude auto-mode defaults` の出力をファイルに保存し、リストを編集してポリシーに一致させ、結果を設定ファイルに貼り付けます。保存後、`claude auto-mode config` を実行して、有効なルールが期待通りであることを確認します。カスタムルールを記述した場合、`claude auto-mode critique` はそれらを確認し、曖昧、冗長、または誤検知を引き起こす可能性があるエントリにフラグを付けます。

## 拒否を確認する

オートモードがツール呼び出しを拒否すると、拒否は `/permissions` の「最近拒否されたもの」タブに記録されます。拒否されたアクションで `r` を押してリトライ用にマークします。ダイアログを終了すると、Claude Code はモデルにそのツール呼び出しを再試行できることを伝えるメッセージを送信し、会話を再開します。

同じ宛先への繰り返しの拒否は、通常、分類器がコンテキストを欠いていることを意味します。その宛先を `autoMode.environment` に追加し、`claude auto-mode config` を実行して、それが有効になったことを確認します。

プログラムで拒否に対応するには、[`PermissionDenied` フック](/ja/hooks#permissiondenied)を使用します。

## 関連項目

* [権限モード](/ja/permission-modes#eliminate-prompts-with-auto-mode)。オートモードとは何か、デフォルトでブロックされる内容、有効にする方法
* [管理設定](/ja/server-managed-settings)。組織全体に `autoMode` 設定をデプロイ
* [権限](/ja/permissions)。分類器が実行される前に適用される許可、質問、拒否ルール
* [設定](/ja/settings)。`autoMode` キーを含む完全な設定リファレンス
