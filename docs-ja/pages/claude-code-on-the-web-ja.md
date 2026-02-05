> ## Documentation Index
> Fetch the complete documentation index at: https://code.claude.com/docs/llms.txt
> Use this file to discover all available pages before exploring further.

# ウェブ上の Claude Code

> セキュアなクラウドインフラストラクチャで Claude Code タスクを非同期に実行します

<Note>
  ウェブ上の Claude Code は現在リサーチプレビュー中です。
</Note>

## ウェブ上の Claude Code とは？

ウェブ上の Claude Code を使用すると、開発者は Claude アプリから Claude Code を開始できます。これは以下の場合に最適です：

* **質問への回答**：コードアーキテクチャと機能の実装方法について質問する
* **バグ修正とルーチンタスク**：頻繁なステアリングを必要としない明確に定義されたタスク
* **並列作業**：複数のバグ修正を並列で処理する
* **ローカルマシンにないリポジトリ**：ローカルにチェックアウトしていないコードで作業する
* **バックエンド変更**：Claude Code がテストを作成してからそのテストに合格するコードを作成できる場所

Claude Code は Claude iOS アプリでも利用可能で、移動中にタスクを開始したり、進行中の作業を監視したりできます。

ローカルとリモート開発の間を移動できます：`&` プレフィックスで[ターミナルからウェブへタスクを送信](#from-terminal-to-web)して実行するか、[ウェブセッションをターミナルにテレポート](#from-web-to-terminal)してローカルで続行します。

## ウェブ上の Claude Code は誰が使用できますか？

ウェブ上の Claude Code はリサーチプレビューで以下のユーザーが利用できます：

* **Pro ユーザー**
* **Max ユーザー**
* **Team プレミアムシートユーザー**
* **Enterprise プレミアムシートユーザー**

## はじめに

1. [claude.ai/code](https://claude.ai/code) にアクセスします
2. GitHub アカウントを接続します
3. リポジトリに Claude GitHub アプリをインストールします
4. デフォルト環境を選択します
5. コーディングタスクを送信します
6. diff ビューで変更を確認し、コメントで反復処理してから、プルリクエストを作成します

## 仕組み

ウェブ上の Claude Code でタスクを開始すると：

1. **リポジトリのクローン**：リポジトリが Anthropic 管理の仮想マシンにクローンされます
2. **環境セットアップ**：Claude がコードを含むセキュアなクラウド環境を準備します
3. **ネットワーク設定**：インターネットアクセスが設定に基づいて構成されます
4. **タスク実行**：Claude がコードを分析し、変更を加え、テストを実行し、作業を確認します
5. **完了**：完了時に通知され、変更を含むプルリクエストを作成できます
6. **結果**：変更がブランチにプッシュされ、プルリクエスト作成の準備ができます

## diff ビューで変更を確認する

Diff ビューを使用すると、プルリクエストを作成する前に Claude が何を変更したかを正確に確認できます。GitHub で変更を確認するために「Create PR」をクリックする代わりに、アプリで diff を直接表示し、変更の準備ができるまで Claude と反復処理します。

Claude がファイルに変更を加えると、追加および削除された行数を示す diff 統計インジケーター（例：`+12 -1`）が表示されます。このインジケーターを選択して diff ビューアを開くと、左側にファイルリストが表示され、右側に各ファイルの変更が表示されます。

diff ビューから、以下のことができます：

* ファイルごとに変更を確認する
* 特定の変更にコメントして修正をリクエストする
* 表示内容に基づいて Claude との反復処理を続行する

これにより、ドラフト PR を作成したり GitHub に切り替えたりすることなく、複数ラウンドのフィードバックを通じて変更を改善できます。

## ウェブとターミナル間でタスクを移動する

ウェブでタスクを開始してターミナルで続行するか、ターミナルからウェブで実行するタスクを送信できます。ウェブセッションはラップトップを閉じても保持され、Claude iOS アプリを含む任意の場所から監視できます。

<Note>
  セッションハンドオフは一方向です：ウェブセッションをターミナルにプルできますが、既存のターミナルセッションをウェブにプッシュすることはできません。[`&` プレフィックス](#from-terminal-to-web)は現在の会話コンテキストで*新しい*ウェブセッションを作成します。
</Note>

### ターミナルからウェブへ

Claude Code 内でメッセージを `&` で開始して、ウェブで実行するタスクを送信します：

```
& Fix the authentication bug in src/auth/login.ts
```

これにより、現在の会話コンテキストで claude.ai に新しいウェブセッションが作成されます。タスクはクラウドで実行され、ローカルで作業を続行できます。`/tasks` を使用して進捗を確認するか、claude.ai または Claude iOS アプリでセッションを開いて直接対話します。そこから Claude をステアリングしたり、フィードバックを提供したり、他の会話と同じように質問に答えたりできます。

コマンドラインから直接ウェブセッションを開始することもできます：

```bash  theme={null}
claude --remote "Fix the authentication bug in src/auth/login.ts"
```

#### バックグラウンドタスクのヒント

**ローカルで計画、リモートで実行**：複雑なタスクの場合、Claude をプランモードで開始して、ウェブに送信する前にアプローチについて協力します：

```bash  theme={null}
claude --permission-mode plan
```

プランモードでは、Claude はファイルの読み取りとコードベースの探索のみができます。計画に満足したら、自律実行のためにウェブに送信します：

```
& Execute the migration plan we discussed
```

このパターンにより、戦略を制御しながら Claude がクラウドで自律的に実行できます。

**タスクを並列で実行**：各 `&` コマンドは独立して実行される独自のウェブセッションを作成します。複数のタスクを開始でき、すべて別々のセッションで同時に実行されます：

```
& Fix the flaky test in auth.spec.ts
& Update the API documentation
& Refactor the logger to use structured output
```

`/tasks` ですべてのセッションを監視します。セッションが完了したら、ウェブインターフェースから PR を作成するか、セッションを[テレポート](#from-web-to-terminal)してターミナルで作業を続行できます。

### ウェブからターミナルへ

ウェブセッションをターミナルにプルするにはいくつかの方法があります：

* **`/teleport` を使用**：Claude Code 内から `/teleport`（または `/tp`）を実行して、ウェブセッションのインタラクティブピッカーを表示します。コミットされていない変更がある場合は、最初にそれらをスタッシュするよう求められます。
* **`--teleport` を使用**：コマンドラインから `claude --teleport` を実行してインタラクティブセッションピッカーを表示するか、`claude --teleport <session-id>` を実行して特定のセッションを直接再開します。
* **`/tasks` から**：`/tasks` を実行してバックグラウンドセッションを表示し、`t` を押してセッションにテレポートします
* **ウェブインターフェースから**：「Open in CLI」をクリックして、ターミナルに貼り付けられるコマンドをコピーします

セッションをテレポートすると、Claude は正しいリポジトリにいることを確認し、リモートセッションからブランチをフェッチしてチェックアウトし、完全な会話履歴をターミナルに読み込みます。

#### テレポートの要件

テレポートはセッションを再開する前にこれらの要件をチェックします。要件が満たされていない場合は、エラーが表示されるか、問題を解決するよう求められます。

| 要件           | 詳細                                                                |
| ------------ | ----------------------------------------------------------------- |
| クリーンな git 状態 | ワーキングディレクトリにコミットされていない変更がないことが必要です。テレポートは必要に応じて変更をスタッシュするよう求めます。  |
| 正しいリポジトリ     | フォークではなく、同じリポジトリのチェックアウトから `--teleport` を実行する必要があります。             |
| ブランチが利用可能    | ウェブセッションからのブランチがリモートにプッシュされている必要があります。テレポートは自動的にフェッチしてチェックアウトします。 |
| 同じアカウント      | ウェブセッションで使用された同じ Claude.ai アカウントに認証される必要があります。                    |

### セッションの共有

セッションを共有するには、以下のアカウントタイプに従ってその可視性を切り替えます。その後、セッションリンクをそのまま共有します。共有セッションを開く受信者は、読み込み時にセッションの最新状態を表示しますが、受信者のページはリアルタイムで更新されません。

#### Enterprise または Teams アカウントから共有

Enterprise および Teams アカウントの場合、2 つの可視性オプションは**プライベート**と**チーム**です。チーム可視性により、セッションが Claude.ai 組織の他のメンバーに表示されます。リポジトリアクセス検証はデフォルトで有効になっており、受信者のアカウントに接続された GitHub アカウントに基づいています。アカウントの表示名はアクセス権を持つすべての受信者に表示されます。[Claude in Slack](/ja/slack) セッションは自動的にチーム可視性で共有されます。

#### Max または Pro アカウントから共有

Max および Pro アカウントの場合、2 つの可視性オプションは**プライベート**と**パブリック**です。パブリック可視性により、セッションが claude.ai にログインしているすべてのユーザーに表示されます。

共有する前にセッションで機密コンテンツをチェックします。セッションにはプライベート GitHub リポジトリのコードと認証情報が含まれる場合があります。リポジトリアクセス検証はデフォルトでは有効になっていません。

Settings > Claude Code > Sharing settings に移動して、リポジトリアクセス検証を有効にしたり、共有セッションから名前を保留したりします。

## クラウド環境

### デフォルトイメージ

一般的なツールチェーンと言語エコシステムがプリインストールされた汎用イメージを構築および保守しています。このイメージには以下が含まれます：

* 一般的なプログラミング言語とランタイム
* 一般的なビルドツールとパッケージマネージャー
* テストフレームワークとリンター

#### 利用可能なツールの確認

環境にプリインストールされているものを確認するには、Claude Code に以下を実行するよう依頼します：

```bash  theme={null}
check-tools
```

このコマンドは以下を表示します：

* プログラミング言語とそのバージョン
* 利用可能なパッケージマネージャー
* インストールされた開発ツール

#### 言語固有のセットアップ

汎用イメージには以下の事前構成環境が含まれます：

* **Python**：pip、poetry、および一般的な科学ライブラリを備えた Python 3.x
* **Node.js**：npm、yarn、pnpm、および bun を備えた最新 LTS バージョン
* **Ruby**：バージョン 3.1.6、3.2.6、3.3.6（デフォルト：3.3.6）、gem、bundler、およびバージョン管理用の rbenv
* **PHP**：バージョン 8.4.14
* **Java**：Maven と Gradle を備えた OpenJDK
* **Go**：モジュールサポート付きの最新安定版
* **Rust**：cargo を備えた Rust ツールチェーン
* **C++**：GCC および Clang コンパイラ

#### データベース

汎用イメージには以下のデータベースが含まれます：

* **PostgreSQL**：バージョン 16
* **Redis**：バージョン 7.0

### 環境設定

ウェブ上の Claude Code でセッションを開始すると、内部で以下が発生します：

1. **環境準備**：リポジトリをクローンし、初期化用に構成された Claude フックを実行します。リポジトリは GitHub リポジトリのデフォルトブランチでクローンされます。特定のブランチをチェックアウトしたい場合は、プロンプトで指定できます。

2. **ネットワーク設定**：エージェント用のインターネットアクセスを構成します。インターネットアクセスはデフォルトで制限されていますが、ニーズに基づいて環境をインターネットアクセスなしまたは完全なインターネットアクセスを持つように構成できます。

3. **Claude Code 実行**：Claude Code が実行されてタスクを完了し、コードを作成し、テストを実行し、作業を確認します。ウェブインターフェースを通じてセッション全体で Claude をガイドしてステアリングできます。Claude は `CLAUDE.md` で定義したコンテキストを尊重します。

4. **結果**：Claude が作業を完了すると、ブランチをリモートにプッシュします。ブランチの PR を作成できるようになります。

<Note>
  Claude はターミナルと環境で利用可能な CLI ツールを通じて完全に動作します。汎用イメージのプリインストールツールと、フックまたは依存関係管理を通じてインストールした追加ツールを使用します。
</Note>

**新しい環境を追加するには**：現在の環境を選択して環境セレクターを開き、「Add environment」を選択します。これにより、環境名、ネットワークアクセスレベル、および設定したい環境変数を指定できるダイアログが開きます。

**既存の環境を更新するには**：現在の環境を選択し、環境名の右側にある設定ボタンを選択します。これにより、環境名、ネットワークアクセス、および環境変数を更新できるダイアログが開きます。

**ターミナルからデフォルト環境を選択するには**：複数の環境が構成されている場合、`/remote-env` を実行して、`&` または `--remote` でターミナルからウェブセッションを開始するときに使用する環境を選択します。単一の環境では、このコマンドは現在の設定を表示します。

<Note>
  環境変数は [`.env` 形式](https://www.dotenv.org/)でキーと値のペアとして指定する必要があります。例：

  ```
  API_KEY=your_api_key
  DEBUG=true
  ```
</Note>

### 依存関係管理

[SessionStart フック](/ja/hooks#sessionstart)を使用して自動依存関係インストールを構成します。これはリポジトリの `.claude/settings.json` ファイルで構成できます：

```json  theme={null}
{
  "hooks": {
    "SessionStart": [
      {
        "matcher": "startup",
        "hooks": [
          {
            "type": "command",
            "command": "\"$CLAUDE_PROJECT_DIR\"/scripts/install_pkgs.sh"
          }
        ]
      }
    ]
  }
}
```

`scripts/install_pkgs.sh` に対応するスクリプトを作成します：

```bash  theme={null}
#!/bin/bash
npm install
pip install -r requirements.txt
exit 0
```

実行可能にします：`chmod +x scripts/install_pkgs.sh`

#### ローカルとリモート実行

デフォルトでは、すべてのフックはローカルとリモート（ウェブ）環境の両方で実行されます。フックを 1 つの環境でのみ実行するには、フックスクリプトで `CLAUDE_CODE_REMOTE` 環境変数をチェックします。

```bash  theme={null}
#!/bin/bash

# 例：リモート環境でのみ実行
if [ "$CLAUDE_CODE_REMOTE" != "true" ]; then
  exit 0
fi

npm install
pip install -r requirements.txt
```

#### 環境変数の永続化

SessionStart フックは、`CLAUDE_ENV_FILE` 環境変数で指定されたファイルに書き込むことで、後続の bash コマンド用に環境変数を永続化できます。詳細については、フックリファレンスの [SessionStart フック](/ja/hooks#sessionstart)を参照してください。

## ネットワークアクセスとセキュリティ

### ネットワークポリシー

#### GitHub プロキシ

セキュリティのため、すべての GitHub 操作は、すべての git インタラクションを透過的に処理する専用プロキシサービスを通じて行われます。サンドボックス内では、git クライアントはカスタムビルドのスコープ付き認証情報を使用して認証します。このプロキシは：

* GitHub 認証をセキュアに管理します。git クライアントはサンドボックス内のスコープ付き認証情報を使用し、プロキシはそれを検証して実際の GitHub 認証トークンに変換します
* 安全性のため、git プッシュ操作を現在のワーキングブランチに制限します
* セキュリティ境界を維持しながら、シームレスなクローン、フェッチ、PR 操作を有効にします

#### セキュリティプロキシ

環境はセキュリティと不正使用防止のため HTTP/HTTPS ネットワークプロキシの背後で実行されます。すべてのアウトバウンドインターネットトラフィックはこのプロキシを通じて渡され、以下を提供します：

* 悪意のあるリクエストからの保護
* レート制限と不正使用防止
* 強化されたセキュリティのためのコンテンツフィルタリング

### アクセスレベル

デフォルトでは、ネットワークアクセスは[許可リストに登録されたドメイン](#default-allowed-domains)に制限されています。

カスタムネットワークアクセスを構成でき、ネットワークアクセスを無効にすることもできます。

### デフォルトで許可されたドメイン

「Limited」ネットワークアクセスを使用する場合、以下のドメインはデフォルトで許可されます：

#### Anthropic サービス

* api.anthropic.com
* statsig.anthropic.com
* platform.claude.com
* code.claude.com
* claude.ai

#### バージョン管理

* github.com
* [www.github.com](http://www.github.com)
* api.github.com
* npm.pkg.github.com
* raw\.githubusercontent.com
* pkg-npm.githubusercontent.com
* objects.githubusercontent.com
* codeload.github.com
* avatars.githubusercontent.com
* camo.githubusercontent.com
* gist.github.com
* gitlab.com
* [www.gitlab.com](http://www.gitlab.com)
* registry.gitlab.com
* bitbucket.org
* [www.bitbucket.org](http://www.bitbucket.org)
* api.bitbucket.org

#### コンテナレジストリ

* registry-1.docker.io
* auth.docker.io
* index.docker.io
* hub.docker.com
* [www.docker.com](http://www.docker.com)
* production.cloudflare.docker.com
* download.docker.com
* gcr.io
* \*.gcr.io
* ghcr.io
* mcr.microsoft.com
* \*.data.mcr.microsoft.com
* public.ecr.aws

#### クラウドプラットフォーム

* cloud.google.com
* accounts.google.com
* gcloud.google.com
* \*.googleapis.com
* storage.googleapis.com
* compute.googleapis.com
* container.googleapis.com
* azure.com
* portal.azure.com
* microsoft.com
* [www.microsoft.com](http://www.microsoft.com)
* \*.microsoftonline.com
* packages.microsoft.com
* dotnet.microsoft.com
* dot.net
* visualstudio.com
* dev.azure.com
* \*.amazonaws.com
* \*.api.aws
* oracle.com
* [www.oracle.com](http://www.oracle.com)
* java.com
* [www.java.com](http://www.java.com)
* java.net
* [www.java.net](http://www.java.net)
* download.oracle.com
* yum.oracle.com

#### パッケージマネージャー - JavaScript/Node

* registry.npmjs.org
* [www.npmjs.com](http://www.npmjs.com)
* [www.npmjs.org](http://www.npmjs.org)
* npmjs.com
* npmjs.org
* yarnpkg.com
* registry.yarnpkg.com

#### パッケージマネージャー - Python

* pypi.org
* [www.pypi.org](http://www.pypi.org)
* files.pythonhosted.org
* pythonhosted.org
* test.pypi.org
* pypi.python.org
* pypa.io
* [www.pypa.io](http://www.pypa.io)

#### パッケージマネージャー - Ruby

* rubygems.org
* [www.rubygems.org](http://www.rubygems.org)
* api.rubygems.org
* index.rubygems.org
* ruby-lang.org
* [www.ruby-lang.org](http://www.ruby-lang.org)
* rubyforge.org
* [www.rubyforge.org](http://www.rubyforge.org)
* rubyonrails.org
* [www.rubyonrails.org](http://www.rubyonrails.org)
* rvm.io
* get.rvm.io

#### パッケージマネージャー - Rust

* crates.io
* [www.crates.io](http://www.crates.io)
* index.crates.io
* static.crates.io
* rustup.rs
* static.rust-lang.org
* [www.rust-lang.org](http://www.rust-lang.org)

#### パッケージマネージャー - Go

* proxy.golang.org
* sum.golang.org
* index.golang.org
* golang.org
* [www.golang.org](http://www.golang.org)
* goproxy.io
* pkg.go.dev

#### パッケージマネージャー - JVM

* maven.org
* repo.maven.org
* central.maven.org
* repo1.maven.org
* jcenter.bintray.com
* gradle.org
* [www.gradle.org](http://www.gradle.org)
* services.gradle.org
* plugins.gradle.org
* kotlin.org
* [www.kotlin.org](http://www.kotlin.org)
* spring.io
* repo.spring.io

#### パッケージマネージャー - その他の言語

* packagist.org（PHP Composer）
* [www.packagist.org](http://www.packagist.org)
* repo.packagist.org
* nuget.org（.NET NuGet）
* [www.nuget.org](http://www.nuget.org)
* api.nuget.org
* pub.dev（Dart/Flutter）
* api.pub.dev
* hex.pm（Elixir/Erlang）
* [www.hex.pm](http://www.hex.pm)
* cpan.org（Perl CPAN）
* [www.cpan.org](http://www.cpan.org)
* metacpan.org
* [www.metacpan.org](http://www.metacpan.org)
* api.metacpan.org
* cocoapods.org（iOS/macOS）
* [www.cocoapods.org](http://www.cocoapods.org)
* cdn.cocoapods.org
* haskell.org
* [www.haskell.org](http://www.haskell.org)
* hackage.haskell.org
* swift.org
* [www.swift.org](http://www.swift.org)

#### Linux ディストリビューション

* archive.ubuntu.com
* security.ubuntu.com
* ubuntu.com
* [www.ubuntu.com](http://www.ubuntu.com)
* \*.ubuntu.com
* ppa.launchpad.net
* launchpad.net
* [www.launchpad.net](http://www.launchpad.net)

#### 開発ツールとプラットフォーム

* dl.k8s.io（Kubernetes）
* pkgs.k8s.io
* k8s.io
* [www.k8s.io](http://www.k8s.io)
* releases.hashicorp.com（HashiCorp）
* apt.releases.hashicorp.com
* rpm.releases.hashicorp.com
* archive.releases.hashicorp.com
* hashicorp.com
* [www.hashicorp.com](http://www.hashicorp.com)
* repo.anaconda.com（Anaconda/Conda）
* conda.anaconda.org
* anaconda.org
* [www.anaconda.com](http://www.anaconda.com)
* anaconda.com
* continuum.io
* apache.org（Apache）
* [www.apache.org](http://www.apache.org)
* archive.apache.org
* downloads.apache.org
* eclipse.org（Eclipse）
* [www.eclipse.org](http://www.eclipse.org)
* download.eclipse.org
* nodejs.org（Node.js）
* [www.nodejs.org](http://www.nodejs.org)

#### クラウドサービスと監視

* statsig.com
* [www.statsig.com](http://www.statsig.com)
* api.statsig.com
* sentry.io
* \*.sentry.io
* http-intake.logs.datadoghq.com
* \*.datadoghq.com
* \*.datadoghq.eu

#### コンテンツ配信とミラー

* sourceforge.net
* \*.sourceforge.net
* packagecloud.io
* \*.packagecloud.io

#### スキーマと設定

* json-schema.org
* [www.json-schema.org](http://www.json-schema.org)
* json.schemastore.org
* [www.schemastore.org](http://www.schemastore.org)

#### Model Context Protocol

* \*.modelcontextprotocol.io

<Note>
  `*` でマークされたドメインはワイルドカードサブドメインマッチングを示します。例えば、`*.gcr.io` は `gcr.io` のすべてのサブドメインへのアクセスを許可します。
</Note>

### カスタマイズされたネットワークアクセスのセキュリティベストプラクティス

1. **最小権限の原則**：必要な最小限のネットワークアクセスのみを有効にします
2. **定期的に監査**：許可されたドメインを定期的に確認します
3. **HTTPS を使用**：常に HTTP エンドポイントより HTTPS エンドポイントを優先します

## セキュリティと分離

ウェブ上の Claude Code は強力なセキュリティ保証を提供します：

* **分離された仮想マシン**：各セッションは分離された Anthropic 管理の VM で実行されます
* **ネットワークアクセス制御**：ネットワークアクセスはデフォルトで制限され、無効にすることができます

<Note>
  ネットワークアクセスが無効な状態で実行する場合、Claude Code は Anthropic API と通信することが許可されており、これにより分離された Claude Code VM からデータが出ることがあります。
</Note>

* **認証情報保護**：機密認証情報（git 認証情報や署名キーなど）はサンドボックス内の Claude Code と一緒にありません。認証はスコープ付き認証情報を使用するセキュアプロキシを通じて処理されます
* **セキュアな分析**：コードは PR を作成する前に分離された VM 内で分析および変更されます

## 価格とレート制限

ウェブ上の Claude Code は、アカウント内のすべての他の Claude および Claude Code 使用とレート制限を共有します。複数のタスクを並列で実行すると、レート制限がそれに応じてより多く消費されます。

## 制限事項

* **リポジトリ認証**：同じアカウントに認証されている場合にのみ、ウェブからローカルにセッションを移動できます
* **プラットフォーム制限**：ウェブ上の Claude Code は GitHub でホストされているコードでのみ機能します。GitLab およびその他の非 GitHub リポジトリはクラウドセッションで使用できません

## ベストプラクティス

1. **Claude Code フックを使用**：[SessionStart フック](/ja/hooks#sessionstart)を構成して、環境セットアップと依存関係インストールを自動化します。
2. **要件を文書化**：`CLAUDE.md` ファイルに依存関係とコマンドを明確に指定します。`AGENTS.md` ファイルがある場合は、`@AGENTS.md` を使用して `CLAUDE.md` でソースすることで、単一の情報源を維持できます。

## 関連リソース

* [フック設定](/ja/hooks)
* [設定リファレンス](/ja/settings)
* [セキュリティ](/ja/security)
* [データ使用](/ja/data-usage)
