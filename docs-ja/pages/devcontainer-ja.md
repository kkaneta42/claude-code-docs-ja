> ## Documentation Index
> Fetch the complete documentation index at: https://code.claude.com/docs/llms.txt
> Use this file to discover all available pages before exploring further.

# 開発コンテナ

> チーム全体で一貫した分離環境を実現するため、開発コンテナ内で Claude Code を実行します。

[開発コンテナ](https://containers.dev/)（dev container）を使用すると、チームのすべてのエンジニアが実行できる同一の分離環境を定義できます。Claude Code がそのコンテナにインストールされている場合、Claude が実行するコマンドはホストマシンではなくコンテナ内で実行され、プロジェクトファイルへの編集はローカルリポジトリに表示されます。

このページでは、[開発コンテナに Claude Code をインストール](#add-claude-code-to-your-dev-container)する方法と、その後の自己完結型の設定トピックについて説明します。認証をリビルド全体で保持する、組織ポリシーを適用する、ネットワークエグレスを制限する、権限プロンプトなしで実行するなどです。セットアップに合致するものをお読みください。

> [!WARNING]
>
> 開発コンテナは実質的な保護を提供していますが、すべての攻撃に完全に耐性のあるシステムはありません。
> `--dangerously-skip-permissions` で実行する場合、開発コンテナは、[`~/.claude`](https://code.claude.com/docs/ja/claude-directory) に保存されている Claude Code の認証情報を含む、コンテナ内でアクセス可能なものを悪意のあるプロジェクトが流出させることを防ぎません。
> 信頼できるリポジトリで開発する場合にのみ開発コンテナを使用し、Claude のアクティビティを監視してください。
> `~/.ssh` やクラウド認証情報ファイルなどのホストシークレットをコンテナにマウントすることは避け、リポジトリスコープまたは短期間有効なトークンを使用してください。

> **開発コンテナがエディタとどのように連携するか**
>
> ![ホスト上のエディタが Docker 開発コンテナに接続する図。Claude Code、ターミナル、ビルドツールはコンテナ内で実行されます。ホストリポジトリはコンテナにバインドマウントされ、ワークスペースとして機能します。](https://mintcdn.com/claude-code/YvJyjZfd9yMihr0i/images/devcontainer-architecture.svg?fit=max\&auto=format\&n=YvJyjZfd9yMihr0i\&q=85\&s=9017b1d16a446c6cc37ba562f35b9aae)
>
> 開発コンテナは Docker コンテナとして実行され、マシン上または GitHub Codespaces などのクラウドホスト上で実行されます。Dev Containers 仕様をサポートするエディタ（VS Code、GitHub Codespaces、JetBrains IDE、Cursor など）がそのコンテナに接続します。通常どおりエディタでファイルを参照および編集しますが、統合ターミナル、言語サーバー、ビルドツールはすべてホストではなくコンテナ内で実行されます。プレーン Vim などの開発コンテナをサポートしていないエディタはこのワークフローの対象外です。
>
> Claude Code はコンテナ内で実行されるため、プロジェクトのツールチェーンの残りの部分と同じファイル、依存関係、ツールが表示されます。VS Code では、[Claude Code 拡張機能パネル](https://code.claude.com/docs/ja/vs-code.md)を使用するか、統合ターミナルで `claude` を実行できます。どちらもコンテナ内で実行され、同じ `~/.claude` 設定を共有します。

## 開発コンテナに Claude Code を追加する

Claude Code は、[Claude Code Dev Container Feature](https://github.com/anthropics/devcontainer-features/tree/main/src/claude-code) を通じて任意の開発コンテナにインストールされます。

設定は、VS Code、GitHub Codespaces、JetBrains IDE など、Dev Containers 仕様をサポートするあらゆるツールで機能します。以下の手順では、例として VS Code を使用しています。

VS Code または Codespaces でコンテナを開くと、機能は Claude Code VS Code 拡張機能も追加します。他のエディタはその部分を無視します。

> [!TIP]
>
> 開発コンテナが初めてですか？[VS Code Dev Containers チュートリアル](https://code.visualstudio.com/docs/devcontainers/tutorial)では、Docker、拡張機能、最初のコンテナを開く方法について説明しています。ファイアウォールと永続ボリュームを備えた、より完全な強化例については、[リファレンスコンテナを試す](#try-the-reference-container)を参照してください。

**1. devcontainer.json を作成または更新する**

以下をリポジトリの `.devcontainer/devcontainer.json` として保存するか、既存ファイルに `features` ブロックを追加します。

末尾のバージョンタグ（`:1.0` など）は、Claude Code リリースではなく、機能のインストールスクリプトをピン留めします。機能は最新の Claude Code をインストールし、Claude Code はデフォルトでコンテナ内で自動更新されます。

CLI バージョンをピン留めするか、自動更新を無効にするには、[組織ポリシーを適用する](#enforce-organization-policy)を参照してください。

```json .devcontainer/devcontainer.json theme={null}
{
  "image": "mcr.microsoft.com/devcontainers/base:ubuntu",
  "features": {
    "ghcr.io/anthropics/devcontainer-features/claude-code:1.0": {}
  }
}
```

`image` 行をプロジェクトのベースイメージに置き換えるか、既存ファイルが Dockerfile を使用している場合は削除します。

Claude Code 機能は、ベースイメージが Node.js を提供しない場合、Node.js 自体をインストールします。そのインストールが失敗し、ビルドが `Failed to install Node.js and npm` で停止する場合は、`"ghcr.io/devcontainers/features/node:1": {}` を Claude Code 機能の上の `features` ブロックに追加して、再構築してください。

**2. コンテナを再構築する**

Mac では `Cmd+Shift+P`、Windows と Linux では `Ctrl+Shift+P` で VS Code コマンドパレットを開き、**Dev Containers: Rebuild Container** を実行します。

他のツールについては、そのツールの再構築アクション（[GitHub Codespaces での再構築](https://docs.github.com/en/codespaces/developing-in-a-codespace/rebuilding-the-container-in-a-codespace)、[Dev Containers CLI](https://github.com/devcontainers/cli)、または IDE の開発コンテナドキュメント）に従ってください。

**3. Claude Code にサインインする**

再構築されたコンテナでターミナルを開き、`claude` を実行して、認証プロンプトに従います。

認証プロンプトで表示される内容は、プロバイダーによって異なります：

* **Anthropic**：Claude または Anthropic Console アカウントでブラウザ経由でサインイン
* **[Amazon Bedrock、Google Cloud の Agent Platform、または Microsoft Foundry](https://code.claude.com/docs/ja/third-party-integrations.md)**：Claude Code はクラウドプロバイダーの認証情報を使用し、ブラウザプロンプトはありません

クラウドプロバイダーの場合、ホストから認証情報ファイルをマウントするのではなく、`containerEnv`、Codespaces シークレット、またはクラウドのワークロード ID を通じて認証情報をコンテナに渡します。Claude Code が読み取る認証情報チェーンについては、[Amazon Bedrock](https://code.claude.com/docs/ja/amazon-bedrock.md)、[Google Cloud の Agent Platform](https://code.claude.com/docs/ja/google-vertex-ai.md)、または [Microsoft Foundry](https://code.claude.com/docs/ja/microsoft-foundry.md) を参照してください。

どのパスが組織に適しているかを決定するには、[API プロバイダーを選択する](https://code.claude.com/docs/ja/admin-setup.md#choose-your-api-provider)を参照してください。

> [!NOTE]
>
> Anthropic のサインインについて：ブラウザが開かない場合、またはサインイン後に `localhost` 接続エラーが表示される場合は、ターミナルの貼り付けプロンプトの上に表示されるログイン URL を使用してください。その URL をブラウザにコピーしてサインインし、ブラウザに表示されるコードをそのプロンプトに貼り付けます。貼り付けても何も起こらない場合は、[WSL2、SSH、またはコンテナで OAuth ログインが失敗する](https://code.claude.com/docs/ja/troubleshoot-install.md#oauth-login-fails-in-wsl2-ssh-or-containers)を参照してください。

## 再構築時に認証と設定を保持する

デフォルトでは、コンテナのホームディレクトリは再構築時に破棄されるため、エンジニアは毎回サインインし直す必要があります。Claude Code は認証トークン、ユーザー設定、セッション履歴を [`~/.claude`](https://code.claude.com/docs/ja/claude-directory) ディレクトリに保存します。アカウントの詳細、個人用 MCP サーバー、プロジェクトごとの信頼設定は、そのディレクトリの外にある別ファイル [`~/.claude.json`](https://code.claude.com/docs/ja/settings-reference#global-config-settings) に保存されます。

このディレクトリとファイルの両方を保持するには、`~/.claude` に名前付きボリュームをマウントし、[`CLAUDE_CONFIG_DIR`](https://code.claude.com/docs/ja/env-vars) を同じパスに設定して、Claude Code が `.claude.json` をボリューム内に書き込むようにします。以下の例は、`remoteUser` が `node` であるコンテナのボリュームをマウントし、`CLAUDE_CONFIG_DIR` を設定します：

```json devcontainer.json theme={null}
"mounts": [
  "source=claude-code-config,target=/home/node/.claude,type=volume"
],
"containerEnv": {
  "CLAUDE_CONFIG_DIR": "/home/node/.claude"
}
```

`/home/node` をコンテナの `remoteUser` のホームディレクトリに置き換えます。既に `containerEnv` を設定している場合（例えば [組織ポリシーの適用](#enforce-organization-policy) で設定している場合）、新しいオブジェクトを追加するのではなく、そのオブジェクトに `CLAUDE_CONFIG_DIR` を追加します。

> [!NOTE]
>
> ボリュームをマウントしているにもかかわらず、再構築のたびに Claude Code が初回起動時のセットアップを繰り返す場合は、`devcontainer.json` の `containerEnv` で `CLAUDE_CONFIG_DIR` がボリュームのマウントパスに設定されていることを確認してください。`CLAUDE_CONFIG_DIR` がない場合、`~/.claude.json` はホームディレクトリに残り、セットアップを完了したという記録とともに再構築時に破棄されます。

プロジェクトごとに状態を分離して、すべてのリポジトリ間で 1 つのボリュームを共有しないようにするには、ソース名に `${devcontainerId}` 変数を含めます。[リファレンス設定](https://github.com/anthropics/claude-code/blob/main/.devcontainer/devcontainer.json)はこの目的で `source=claude-code-config-${devcontainerId}` を使用しています。

GitHub Codespaces では、`~/.claude` は codespace の停止と開始の間で保持されますが、コンテナを再構築するときはクリアされるため、上記の設定がそこにも適用されます。

codespace 間で認証を実行するには、[Codespaces シークレット](https://docs.github.com/en/codespaces/managing-your-codespaces/managing-your-account-specific-secrets-for-github-codespaces)として `ANTHROPIC_API_KEY` または [`claude setup-token`](https://code.claude.com/docs/ja/authentication#generate-a-long-lived-token) からの `CLAUDE_CODE_OAUTH_TOKEN` を保存します。Codespaces はシークレットを自動的にコンテナ内の環境変数として利用可能にします。

## 組織ポリシーを適用する

開発コンテナは、同じイメージと設定がすべてのエンジニアのマシンで実行されるため、組織ポリシーを適用するのに便利な場所です。

Claude Code は Linux で `/etc/claude-code/managed-settings.json` を読み取り、[設定階層](https://code.claude.com/docs/ja/settings.md#settings-precedence)で最高の優先度で適用するため、そこの値はエンジニアが `~/.claude` またはプロジェクトの `.claude/` ディレクトリで設定したものをオーバーライドします。Dockerfile からファイルをコピーして配置します：

```dockerfile Dockerfile theme={null}
RUN mkdir -p /etc/claude-code
COPY managed-settings.json /etc/claude-code/managed-settings.json
```

Dockerfile はリポジトリに存在するため、書き込みアクセス権を持つ誰でもこのステップを変更または削除できます。エンジニアがリポジトリファイルを編集してバイパスできないポリシーについては、[サーバー管理設定](https://code.claude.com/docs/ja/server-managed-settings.md)または MDM を通じて管理設定を配信します。利用可能なキーと他の配信パスについては、[管理設定ファイル](https://code.claude.com/docs/ja/managed-settings.md#delivery-mechanisms)を参照してください。

コンテナ内のすべての Claude Code セッションに適用される[環境変数](https://code.claude.com/docs/ja/env-vars.md)を設定するには、`devcontainer.json` の `containerEnv` に追加します。以下の例は、テレメトリとエラーレポートをオプトアウトし、Claude Code がインストール後に自動更新されるのを防ぎます：

```json devcontainer.json theme={null}
"containerEnv": {
  "CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC": "1",
  "DISABLE_AUTOUPDATER": "1"
}
```

`CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC` は、[Remote Control](https://code.claude.com/docs/ja/remote-control.md#requirements)と他の[フィーチャーフラグ取得が必要な機能](https://code.claude.com/docs/ja/env-vars.md#features-that-need-feature-flag-fetching)が依存するフィーチャーフラグ評価も無効にするため、コンテナ内のセッションはそれらを使用できません。

Dev Container Feature は常に最新の Claude Code リリースをインストールします。再現可能なビルドのために特定の Claude Code バージョンをピン留めするには、機能を使用する代わりに Dockerfile から `npm install -g @anthropic-ai/claude-code@X.Y.Z` でインストールし、`containerEnv` で `DISABLE_AUTOUPDATER` を `1` に設定します。

権限ルール、ツール制限、MCP サーバーアローリストを含むポリシーコントロールの完全なリストについては、[組織向けに Claude Code をセットアップする](https://code.claude.com/docs/ja/admin-setup.md)を参照してください。

[MCP サーバー](https://code.claude.com/docs/ja/mcp.md)をコンテナ内で利用可能にするには、リポジトリルートの `.mcp.json` ファイルで[プロジェクトスコープ](https://code.claude.com/docs/ja/mcp.md#mcp-installation-scopes)で定義して、開発コンテナ設定と一緒にチェックインします。ローカル stdio サーバーが依存するバイナリを Dockerfile にインストールし、リモートサーバードメインをネットワークアローリストに追加します。

## ネットワークエグレスを制限する

コンテナのアウトバウンドトラフィックを Claude Code が必要とするドメインのみに制限できます。推論と認証ドメインについては[ネットワークアクセス要件](https://code.claude.com/docs/ja/network-config.md#network-access-requirements)を参照し、オプションのテレメトリとエラーレポート接続およびそれらを無効にする方法については[テレメトリサービス](https://code.claude.com/docs/ja/data-usage.md#telemetry-services)を参照してください。

リファレンスコンテナには、スクリプトが許可する宛先へのアウトバウンドトラフィックを制限する [`init-firewall.sh`](https://github.com/anthropics/claude-code/blob/main/.devcontainer/init-firewall.sh) スクリプトが含まれています。コンテナ内でファイアウォールを実行するには追加の権限が必要なため、リファレンスは `runArgs` を通じて `NET_ADMIN` と `NET_RAW` 機能を追加します。ファイアウォールスクリプトとこれらの機能は Claude Code 自体には必須ではありません。これらを除外して、代わりに独自のネットワークコントロールに依存することができます。

## 権限プロンプトなしで実行する

コンテナは Claude Code を非ルートユーザーとして実行し、コマンド実行をコンテナに限定するため、無人操作のために `--dangerously-skip-permissions` を渡すことができます。CLI はルートとして起動された場合、このフラグを拒否するため、`remoteUser` が非ルートアカウントに設定されていることを確認します。

権限プロンプトをスキップすると、実行前にツール呼び出しを確認する機会が失われます。Claude はバインドマウントされたワークスペース内のあらゆるファイルを変更でき、これはホストに直接表示され、コンテナのネットワークポリシーが許可するものに到達できます。このフラグを上記の[ネットワークエグレス制限](#restrict-network-egress)と組み合わせて、バイパスされたセッションが到達できるものを制限します。

安全チェックを無効にせずにプロンプトを減らしたい場合は、代わりに[自動モード](https://code.claude.com/docs/ja/permission-modes.md#eliminate-prompts-with-auto-mode)を検討してください。これは、実行前にアクションを確認するための分類器を備えています。エンジニアが `--dangerously-skip-permissions` をまったく使用できないようにするには、[管理設定](https://code.claude.com/docs/ja/settings-reference.md#permission-settings)で `permissions.disableBypassPermissionsMode` を `"disable"` に設定します。

## リファレンスコンテナを試す

[`anthropics/claude-code`](https://github.com/anthropics/claude-code/tree/main/.devcontainer) リポジトリには、CLI、エグレスファイアウォール、永続ボリューム、Zsh ベースのシェルを組み合わせた開発コンテナの例が含まれています。これは、保守されたベースイメージではなく、動作する例として提供されています。独自の設定に適用する前に、ピースがどのように組み合わさるかを確認するために使用してください。

**1. 前提条件をインストールする**

VS Code と [Dev Containers 拡張機能](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers)をインストールします。

**2. リファレンスをクローンする**

[Claude Code リポジトリ](https://github.com/anthropics/claude-code)をクローンして、VS Code で開きます。

**3. コンテナで再度開く**

プロンプトが表示されたら、**Reopen in Container** をクリックするか、コマンドパレットから **Dev Containers: Reopen in Container** を実行します。

**4. Claude Code を開始する**

コンテナのビルドが完了したら、`` Ctrl+` `` でターミナルを開き、`claude` を実行してサインインし、最初のセッションを開始します。

この設定を独自のプロジェクトで使用するには、`.devcontainer/` ディレクトリをリポジトリにコピーして、ツールチェーン用に Dockerfile を調整するか、[開発コンテナに Claude Code を追加する](#add-claude-code-to-your-dev-container)に戻って、既に持っている設定に機能のみを追加します。

リファレンス設定は 3 つのファイルで構成されています。機能を通じて独自の開発コンテナに Claude Code を追加する場合、これらは必須ではありませんが、ピースを組み合わせる 1 つの方法を示しています。

| ファイル | 目的 |
| - | - |
| [`devcontainer.json`](https://github.com/anthropics/claude-code/blob/main/.devcontainer/devcontainer.json) | ボリュームマウント、`runArgs` 機能、VS Code 拡張機能、`containerEnv` |
| [`Dockerfile`](https://github.com/anthropics/claude-code/blob/main/.devcontainer/Dockerfile) | ベースイメージ、開発ツール、Claude Code インストール |
| [`init-firewall.sh`](https://github.com/anthropics/claude-code/blob/main/.devcontainer/init-firewall.sh) | 許可されたドメイン以外のすべてのアウトバウンドネットワークトラフィックをブロック |

## 次のステップ

Claude Code が開発コンテナで実行されたら、以下のページは組織ロールアウトの残りの部分をカバーしています。認証パスの選択、リポジトリ外での管理ポリシーの配信、使用状況の監視、Claude Code が保存および送信するものの理解です。

* [組織向けに Claude Code をセットアップする](https://code.claude.com/docs/ja/admin-setup.md)：認証プロバイダーを選択し、ポリシーがデバイスに到達する方法を決定し、ロールアウトを計画します
* [サーバー管理設定](https://code.claude.com/docs/ja/server-managed-settings.md)：claude.ai 管理コンソールから管理ポリシーを配信して、エンジニアがリポジトリファイルを編集してバイパスできないようにします
* [使用状況の監視と監査アクティビティ](https://code.claude.com/docs/ja/monitoring-usage.md)：OpenTelemetry メトリクスをエクスポートして、チームが実行しているものを確認します
* [ネットワークアクセス要件](https://code.claude.com/docs/ja/network-config.md#network-access-requirements)：プロキシとファイアウォール用の完全なドメインアローリスト
* [テレメトリサービスとオプトアウト](https://code.claude.com/docs/ja/data-usage.md#telemetry-services)：Claude Code がデフォルトで送信するもの、およびそれを無効にする環境変数
* [`.claude` ディレクトリを探索する](https://code.claude.com/docs/ja/claude-directory)：ボリュームマウントが保持するもの（認証情報、設定、セッション履歴を含む）
* [サンドボックス環境](https://code.claude.com/docs/ja/sandbox-environments.md)：開発コンテナと組み込み Bash サンドボックス、カスタムコンテナ、VM を比較します
* [セキュリティモデル](https://code.claude.com/docs/ja/security.md)：Claude Code の権限システム、サンドボックス、プロンプトインジェクション保護がどのように組み合わさるか
* [権限モード](https://code.claude.com/docs/ja/permission-modes.md)：プランモードから自動モードからバイパスまでの完全な範囲、および各モードを使用する場合
