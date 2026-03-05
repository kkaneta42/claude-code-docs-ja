> ## Documentation Index
> Fetch the complete documentation index at: https://code.claude.com/docs/llms.txt
> Use this file to discover all available pages before exploring further.

# ウェブ上の Claude Code

> セキュアなクラウドインフラストラクチャで Claude Code タスクを非同期に実行します

<Note>
  ウェブ上の Claude Code は現在リサーチプレビュー段階です。
</Note>

## ウェブ上の Claude Code とは？

ウェブ上の Claude Code を使用すると、開発者は Claude アプリから Claude Code を開始できます。これは以下の場合に最適です：

* **質問への回答**：コードアーキテクチャと機能の実装方法について質問する
* **バグ修正とルーチンタスク**：頻繁な操舵が不要な明確に定義されたタスク
* **並列作業**：複数のバグ修正を並列で処理する
* **ローカルマシンにないリポジトリ**：ローカルにチェックアウトしていないコードで作業する
* **バックエンド変更**：Claude Code がテストを作成してからそのテストに合格するコードを作成できる場所

Claude Code は Claude アプリの [iOS](https://apps.apple.com/us/app/claude-by-anthropic/id6473753684) および [Android](https://play.google.com/store/apps/details?id=com.anthropic.claude) でも利用可能で、移動中にタスクを開始し、進行中の作業を監視できます。

ターミナルから `--remote` を使用して[ウェブで新しいタスクを開始](#from-terminal-to-web)したり、[ウェブセッションをターミナルにテレポート](#from-web-to-terminal)してローカルで続行したりできます。クラウドインフラストラクチャの代わりに自分のマシンで Claude Code を実行しながらウェブインターフェースを使用するには、[リモートコントロール](/ja/remote-control)を参照してください。

## ウェブ上の Claude Code は誰が使用できますか？

ウェブ上の Claude Code はリサーチプレビューで以下のユーザーが利用できます：

* **Pro ユーザー**
* **Max ユーザー**
* **Team ユーザー**
* **Enterprise ユーザー**（プレミアムシートまたは Chat + Claude Code シート付き）

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
3. **ネットワーク設定**：設定に基づいてインターネットアクセスが構成されます
4. **タスク実行**：Claude がコードを分析し、変更を加え、テストを実行し、作業を確認します
5. **完了**：完了時に通知され、変更を含むプルリクエストを作成できます
6. **結果**：変更がブランチにプッシュされ、プルリクエスト作成の準備ができます

## diff ビューで変更を確認する

Diff ビューを使用すると、プルリクエストを作成する前に Claude が何を変更したかを正確に確認できます。GitHub でプルリクエストを確認するために「PR を作成」をクリックする代わりに、アプリで diff を直接表示し、変更の準備ができるまで Claude と反復処理できます。

Claude がファイルに変更を加えると、追加および削除された行数を示す diff 統計インジケーター（例：`+12 -1`）が表示されます。このインジケーターを選択して diff ビューアを開くと、左側にファイルリストが表示され、右側に各ファイルの変更が表示されます。

diff ビューから、以下のことができます：

* ファイルごとに変更を確認する
* 特定の変更にコメントして修正をリクエストする
* 表示内容に基づいて Claude との反復処理を続ける

これにより、ドラフト PR を作成したり GitHub に切り替えたりすることなく、複数ラウンドのフィードバックを通じて変更を改善できます。

## ウェブとターミナル間でタスクを移動する

ターミナルからウェブで新しいタスクを開始したり、ウェブセッションをターミナルに取り込んでローカルで続行したりできます。ウェブセッションはラップトップを閉じても保持され、Claude モバイルアプリを含む任意の場所から監視できます。

<Note>
  セッションハンドオフは一方向です：ウェブセッションをターミナルに取り込むことはできますが、既存のターミナルセッションをウェブにプッシュすることはできません。`--remote` フラグは現在のリポジトリの*新しい*ウェブセッションを作成します。
</Note>

### ターミナルからウェブへ

`--remote` フラグを使用してコマンドラインからウェブセッションを開始します：

```bash  theme={null}
claude --remote "Fix the authentication bug in src/auth/login.ts"
```

これにより claude.ai に新しいウェブセッションが作成されます。タスクはクラウドで実行され、ローカルで作業を続けることができます。`/tasks` を使用して進捗を確認するか、claude.ai または Claude モバイルアプリでセッションを開いて直接対話します。そこから Claude を操舵したり、フィードバックを提供したり、他の会話と同じように質問に答えたりできます。

#### リモートタスクのヒント

**ローカルで計画し、リモートで実行**：複雑なタスクの場合、Claude をプランモードで開始してアプローチについて協力し、ウェブに作業を送信します：

```bash  theme={null}
claude --permission-mode plan
```

プランモードでは、Claude はファイルの読み取りとコードベースの探索のみができます。計画に満足したら、自律実行のためにリモートセッションを開始します：

```bash  theme={null}
claude --remote "Execute the migration plan in docs/migration-plan.md"
```

このパターンにより、戦略を制御しながら Claude がクラウドで自律的に実行できます。

**タスクを並列で実行**：各 `--remote` コマンドは独立して実行される独自のウェブセッションを作成します。複数のタスクを開始でき、すべて別々のセッションで同時に実行されます：

```bash  theme={null}
claude --remote "Fix the flaky test in auth.spec.ts"
claude --remote "Update the API documentation"
claude --remote "Refactor the logger to use structured output"
```

`/tasks` ですべてのセッションを監視します。セッションが完了したら、ウェブインターフェースから PR を作成するか、セッションを[テレポート](#from-web-to-terminal)してターミナルで作業を続けることができます。

### ウェブからターミナルへ

ウェブセッションをターミナルに取り込むにはいくつかの方法があります：

* **`/teleport` を使用**：Claude Code 内から `/teleport`（または `/tp`）を実行して、ウェブセッションのインタラクティブピッカーを表示します。コミットされていない変更がある場合は、最初にそれらをスタッシュするよう求められます。
* **`--teleport` を使用**：コマンドラインから `claude --teleport` を実行してインタラクティブセッションピッカーを表示するか、`claude --teleport <session-id>` を実行して特定のセッションを直接再開します。
* **`/tasks` から**：`/tasks` を実行してバックグラウンドセッションを表示し、`t` を押してセッションにテレポートします
* **ウェブインターフェースから**：「CLI で開く」をクリックしてターミナルに貼り付けられるコマンドをコピーします

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

セッションを共有するには、以下のアカウントタイプに従ってその可視性を切り替えます。その後、セッションリンクをそのまま共有します。共有セッションを開いた受信者は、読み込み時にセッションの最新状態を表示しますが、受信者のページはリアルタイムで更新されません。

#### Enterprise または Teams アカウントから共有

Enterprise および Teams アカウントの場合、2 つの可視性オプションは**プライベート**と**チーム**です。チーム可視性により、セッションは Claude.ai 組織の他のメンバーに表示されます。リポジトリアクセス検証は、受信者のアカウントに接続された GitHub アカウントに基づいて、デフォルトで有効になっています。アカウントの表示名は、アクセス権を持つすべての受信者に表示されます。[Claude in Slack](/ja/slack) セッションは自動的にチーム可視性で共有されます。

#### Max または Pro アカウントから共有

Max および Pro アカウントの場合、2 つの可視性オプションは**プライベート**と**パブリック**です。パブリック可視性により、セッションは claude.ai にログインしているすべてのユーザーに表示されます。

共有する前にセッションで機密コンテンツを確認してください。セッションには、プライベート GitHub リポジトリのコードと認証情報が含まれる場合があります。リポジトリアクセス検証はデフォルトで有効になっていません。

設定 > Claude Code > 共有設定に移動して、リポジトリアクセス検証を有効にしたり、共有セッションから名前を保留したりできます。

## セッションの管理

### セッションのアーカイブ

セッションをアーカイブして、セッションリストを整理できます。アーカイブされたセッションはデフォルトのセッションリストから非表示になりますが、アーカイブされたセッションをフィルタリングして表示できます。

セッションをアーカイブするには、サイドバーのセッションにマウスを合わせてアーカイブアイコンをクリックします。

### セッションの削除

セッションを削除すると、セッションとそのデータが永久に削除されます。このアクションは取り消せません。セッションは 2 つの方法で削除できます：

* **サイドバーから**：アーカイブされたセッションをフィルタリングし、削除するセッションにマウスを合わせて削除アイコンをクリックします
* **セッションメニューから**：セッションを開き、セッションタイトルの横のドロップダウンをクリックして、**削除**を選択します

セッションが削除される前に確認するよう求められます。

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
* **Java**：Maven および Gradle を備えた OpenJDK
* **Go**：モジュールサポート付きの最新安定版
* **Rust**：cargo を備えた Rust ツールチェーン
* **C++**：GCC および Clang コンパイラ

#### データベース

汎用イメージには以下のデータベースが含まれます：

* **PostgreSQL**：バージョン 16
* **Redis**：バージョン 7.0

### 環境設定

ウェブ上の Claude Code でセッションを開始すると、内部で以下が発生します：

1. **環境準備**：リポジトリをクローンし、初期化用に構成された Claude フックを実行します。リポジトリは GitHub リポジトリのデフォルトブランチでクローンされます。特定のブランチをチェックアウトする場合は、プロンプトで指定できます。

2. **ネットワーク設定**：エージェント用のインターネットアクセスを構成します。インターネットアクセスはデフォルトで制限されていますが、ニーズに基づいて環境をインターネットなしまたは完全なインターネットアクセスを持つように構成できます。

3. **Claude Code 実行**：Claude Code を実行してタスクを完了し、コードを作成し、テストを実行し、作業を確認します。ウェブインターフェースを通じてセッション全体で Claude をガイドおよび操舵できます。Claude は `CLAUDE.md` で定義したコンテキストを尊重します。

4. **結果**：Claude が作業を完了すると、ブランチをリモートにプッシュします。ブランチの PR を作成できるようになります。

<Note>
  Claude は環境で利用可能なターミナルおよび CLI ツールを完全に通じて動作します。汎用イメージのプリインストールツールと、フックまたは依存関係管理を通じてインストールする追加ツールを使用します。
</Note>

**新しい環境を追加するには**：現在の環境を選択して環境セレクターを開き、「環境を追加」を選択します。これにより、環境名、ネットワークアクセスレベル、および設定するすべての環境変数を指定できるダイアログが開きます。

**既存の環境を更新するには**：現在の環境を選択し、環境名の右側で設定ボタンを選択します。これにより、環境名、ネットワークアクセス、および環境変数を更新できるダイアログが開きます。

**ターミナルからデフォルト環境を選択するには**：複数の環境が構成されている場合、`/remote-env` を実行して、`--remote` でターミナルからウェブセッションを開始するときに使用するものを選択します。単一の環境では、このコマンドは現在の設定を表示します。

<Note>
  環境変数は [`.env` 形式](https://www.dotenv.org/)のキーと値のペアとして指定する必要があります。例：

  ```text  theme={null}
  API_KEY=your_api_key
  DEBUG=true
  ```
</Note>

### 依存関係管理

カスタム環境イメージとスナップショットはまだサポートされていません。回避策として、[SessionStart フック](/ja/hooks#sessionstart)を使用してセッション開始時にパッケージをインストールできます。このアプローチには[既知の制限](#dependency-management-limitations)があります。

自動依存関係インストールを構成するには、リポジトリの `.claude/settings.json` ファイルに SessionStart フックを追加します：

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

# Only run in remote environments
if [ "$CLAUDE_CODE_REMOTE" != "true" ]; then
  exit 0
fi

npm install
pip install -r requirements.txt
exit 0
```

実行可能にします：`chmod +x scripts/install_pkgs.sh`

#### 環境変数を永続化する

SessionStart フックは、`CLAUDE_ENV_FILE` 環境変数で指定されたファイルに書き込むことで、後続の Bash コマンド用に環境変数を永続化できます。詳細については、フックリファレンスの [SessionStart フック](/ja/hooks#sessionstart)を参照してください。

#### 依存関係管理の制限

* **すべてのセッションでフックが実行される**：SessionStart フックはローカルおよびリモート環境の両方で実行されます。フックをリモートセッションのみにスコープするフック設定はありません。ローカル実行をスキップするには、上記のように `CLAUDE_CODE_REMOTE` 環境変数をスクリプトで確認してください。
* **ネットワークアクセスが必要**：インストールコマンドはパッケージレジストリに到達するためにネットワークアクセスが必要です。環境が「インターネットなし」アクセスで構成されている場合、これらのフックは失敗します。「制限」（デフォルト）または「完全」ネットワークアクセスを使用してください。[デフォルト許可リスト](#default-allowed-domains)には npm、PyPI、RubyGems、crates.io などの一般的なレジストリが含まれています。
* **プロキシ互換性**：リモート環境のすべての送信トラフィックは[セキュリティプロキシ](#security-proxy)を通じて渡されます。一部のパッケージマネージャーはこのプロキシで正しく動作しません。Bun は既知の例です。
* **セッション開始時に実行される**：フックはセッションが開始または再開されるたびに実行され、スタートアップレイテンシーが追加されます。依存関係が既に存在するかどうかを確認してから再インストールすることで、インストールスクリプトを高速に保ちます。

## ネットワークアクセスとセキュリティ

### ネットワークポリシー

#### GitHub プロキシ

セキュリティのため、すべての GitHub 操作は git インタラクションをすべて透過的に処理する専用プロキシサービスを通じて行われます。サンドボックス内では、git クライアントはカスタムビルドのスコープ認証情報を使用して認証します。このプロキシは：

* Git 認証をセキュアに管理します。git クライアントはサンドボックス内のスコープ認証情報を使用し、プロキシはそれを検証して実際の GitHub 認証トークンに変換します
* 安全性のため、git プッシュ操作を現在のワーキングブランチに制限します
* セキュリティ境界を維持しながら、シームレスなクローン、フェッチ、PR 操作を有効にします

#### セキュリティプロキシ

環境はセキュリティと不正使用防止のため HTTP/HTTPS ネットワークプロキシの背後で実行されます。すべての送信インターネットトラフィックはこのプロキシを通じて渡され、以下を提供します：

* 悪意のあるリクエストからの保護
* レート制限と不正使用防止
* 強化されたセキュリティのためのコンテンツフィルタリング

### アクセスレベル

デフォルトでは、ネットワークアクセスは[許可リストドメイン](#default-allowed-domains)に制限されています。

カスタムネットワークアクセスを構成でき、ネットワークアクセスを無効にすることもできます。

### デフォルト許可ドメイン

「制限」ネットワークアクセスを使用する場合、以下のドメインはデフォルトで許可されます：

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

#### 開発ツール＆プラットフォーム

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

#### クラウドサービス＆モニタリング

* statsig.com
* [www.statsig.com](http://www.statsig.com)
* api.statsig.com
* sentry.io
* \*.sentry.io
* http-intake.logs.datadoghq.com
* \*.datadoghq.com
* \*.datadoghq.eu

#### コンテンツ配信＆ミラー

* sourceforge.net
* \*.sourceforge.net
* packagecloud.io
* \*.packagecloud.io

#### スキーマ＆設定

* json-schema.org
* [www.json-schema.org](http://www.json-schema.org)
* json.schemastore.org
* [www.schemastore.org](http://www.schemastore.org)

#### Model Context Protocol

* \*.modelcontextprotocol.io

<Note>
  `*` でマークされたドメインはワイルドカードサブドメインマッチングを示します。例えば、`*.gcr.io` は gcr.io のすべてのサブドメインへのアクセスを許可します。
</Note>

### カスタマイズされたネットワークアクセスのセキュリティベストプラクティス

1. **最小権限の原則**：必要な最小限のネットワークアクセスのみを有効にします
2. **定期的に監査**：許可されたドメインを定期的に確認します
3. **HTTPS を使用**：常に HTTP エンドポイントより HTTPS エンドポイントを優先します

## セキュリティと分離

ウェブ上の Claude Code は強力なセキュリティ保証を提供します：

* **分離された仮想マシン**：各セッションは分離された Anthropic 管理の VM で実行されます
* **ネットワークアクセス制御**：ネットワークアクセスはデフォルトで制限され、無効にできます

<Note>
  ネットワークアクセスが無効で実行する場合、Claude Code は Anthropic API と通信することが許可されており、これにより分離された Claude Code VM からデータが出ることがあります。
</Note>

* **認証情報保護**：機密認証情報（git 認証情報や署名キーなど）はサンドボックス内の Claude Code と一緒にありません。認証はスコープ認証情報を使用するセキュアプロキシを通じて処理されます
* **セキュアな分析**：コードは PR を作成する前に分離された VM 内で分析および変更されます

## 価格とレート制限

ウェブ上の Claude Code は、アカウント内のすべての他の Claude および Claude Code 使用とレート制限を共有します。複数のタスクを並列で実行すると、レート制限がそれに応じてより多く消費されます。

## 制限

* **リポジトリ認証**：同じアカウントに認証されている場合にのみ、ウェブからローカルにセッションを移動できます
* **プラットフォーム制限**：ウェブ上の Claude Code は GitHub でホストされているコードでのみ機能します。GitLab およびその他の非 GitHub リポジトリはクラウドセッションで使用できません

## ベストプラクティス

1. **Claude Code フックを使用**：[SessionStart フック](/ja/hooks#sessionstart)を構成して、環境セットアップと依存関係インストールを自動化します。
2. **要件を文書化**：`CLAUDE.md` ファイルで依存関係とコマンドを明確に指定します。`AGENTS.md` ファイルがある場合は、`@AGENTS.md` を使用して `CLAUDE.md` でソースすることで、単一の情報源を維持できます。

## 関連リソース

* [フック設定](/ja/hooks)
* [設定リファレンス](/ja/settings)
* [セキュリティ](/ja/security)
* [データ使用](/ja/data-usage)
