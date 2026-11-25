> ## Documentation Index
> Fetch the complete documentation index at: https://code.claude.com/docs/llms.txt
> Use this file to discover all available pages before exploring further.

# コードベースの脆弱性をスキャンする

> Claude Security プラグインをインストールして、Claude Code セッション内でコードベースの脆弱性をスキャンし、検出結果をレビューして適用できるパッチに変換します。

Claude Security プラグインは、Claude Code セッション内でコードベースに対してマルチエージェントによる脆弱性スキャンを実行します。[デフォルト](#choose-a-scan-effort)では、リポジトリ全体をスキャンすると、Claude エージェントがアーキテクチャを把握し、脆弱性を探索し、すべての検出結果を個別にレビューしてからレポートを作成します。

このプラグインを使用して、リポジトリ全体をスキャンすることも、ブランチの差分、プルリクエストの差分、単一のコミットなど、[一部の変更のみ](#scan-only-your-changes)をスキャンすることもできます。その後、選択した検出結果を、自分でレビューして適用するパッチに変換します。スキャンするのは、自分が所有しているコード、またはテストする権限を持っているコードのみにしてください。

スキャンは、セッション、シェル、または GitHub Actions で実行できます。

* **セッション内**: [Claude Code で利用できる任意のモデル](#models-and-providers)を使用して、[コードベースをスキャンして修正](#scan-and-fix-your-codebase)します
* **シェルから**: [`claude-security` コマンド](#scan-from-your-shell)を使用します
* **GitHub Actions 内**: プラグインのジョブを追加して[プルリクエストをスキャン](#scan-pull-requests-in-github-actions)します

セッションまたはシェルでのスキャンはユーザーの[使用量](https://code.claude.com/docs/ja/costs.md)にカウントされ、GitHub Actions でのスキャンはジョブのモデル認証情報を所有するアカウントの使用量にカウントされます。

> [!NOTE]
>
> リポジトリを監視するマネージドサービスを利用したい場合や、[Claude Mythos](https://platform.claude.com/docs/en/about-claude/models/introducing-claude-fable-5-and-claude-mythos-5) でスキャンを実行したい場合は、Enterprise プランで利用できる [Claude Security](https://claude.com/product/claude-security) 製品を参照してください。

このプラグインは、Claude Code にすでに備わっているレビューツールとも異なります。[セキュリティガイダンスプラグイン](https://code.claude.com/docs/ja/security-guidance.md)は Claude がコードを書く際にそのコードをレビューし、[Code Review](https://code.claude.com/docs/ja/code-review.md) はプルリクエストをレビューします。これらのレイヤーがどのように組み合わさるかについては、[プラグインと他のセキュリティツールとの関係](#how-the-plugin-fits-with-other-security-tools)を参照してください。

## 前提条件

プラグインを実行するには、次のものが必要です。

* スキャンがエージェントのオーケストレーションに使用する[動的ワークフロー](https://code.claude.com/docs/ja/workflows.md)のための、有料プラン、Anthropic API アクセス、または[サードパーティプロバイダー](#models-and-providers)。Pro では、`/config` の Dynamic workflows の行からオンにします。
* `PATH` 上で `python3` として利用できる Python 3.9 以降。`python3 --version` で確認できます。プラグインのツールは Python 標準ライブラリのみを使用します。
* Linux、macOS、または Windows。
* 変更スキャンと、検出結果をパッチに変換するための Git。これらの処理は他のバージョン管理システムをサポートしていません。フルスキャンは、バージョン管理の有無にかかわらず、任意のディレクトリで動作します。

## モデルとプロバイダー

プラグイン自体はモデルを呼び出さないため、セッション内でのスキャンに別途 API キーやプロバイダーの設定は必要ありません。

* **モデル**: 脆弱性を探索し、検出結果を検証し、パッチを作成・レビューするエージェントは、[セッションのモデル](https://code.claude.com/docs/ja/sub-agents.md#choose-a-model)で実行されます。モデルを変更するには、スキャンを開始する前にセッションで [`/model`](https://code.claude.com/docs/ja/model-config#setting-your-model) を実行します。一部の補助的なステップでは、代わりに [`sonnet` エイリアス](https://code.claude.com/docs/ja/model-config#model-aliases)が使用されます。
* **プロバイダー**: スキャンは、有料プラン、Anthropic API アクセス、または [Amazon Bedrock](https://code.claude.com/docs/ja/amazon-bedrock.md)、[Google Cloud の Agent Platform](https://code.claude.com/docs/ja/google-vertex-ai.md)、[Microsoft Foundry](https://code.claude.com/docs/ja/microsoft-foundry.md) などの[サードパーティプロバイダー](https://code.claude.com/docs/ja/third-party-integrations.md)で実行されます。

サードパーティプロバイダーでは、`sonnet` エイリアスが Anthropic API とは異なるバージョンに解決される場合があります。アカウントでそのバージョンを使用できない場合は、`ANTHROPIC_DEFAULT_SONNET_MODEL` を含め、[モデルのバージョンを固定](https://code.claude.com/docs/ja/model-config.md#pin-models-for-third-party-deployments)してください。

[自動モデルフォールバック](https://code.claude.com/docs/ja/model-config.md#automatic-model-fallback)は、モデルのセーフガードによって警告されたリクエストを再実行します。Amazon Bedrock、Google Cloud の Agent Platform、Microsoft Foundry では、[デプロイの設定方法](https://code.claude.com/docs/ja/model-config.md#enable-fallback-on-bedrock-agent-platform-and-foundry)によっては、代わりにリクエストが拒否メッセージで終了する場合があります。

## プラグインをインストールする

VS Code 拡張機能またはデスクトップアプリでは、[プラグインをインストールする](https://code.claude.com/docs/ja/plugins/install.md#install-a-plugin)の手順に従ってインストールします。

ターミナルでは、`claude` を実行して Claude Code を起動し、そのプロンプトで次のように入力して[公式 Anthropic マーケットプレイス](https://code.claude.com/docs/ja/plugins/anthropic-marketplaces.md)からインストールします。

```text theme={null}
/plugin install claude-security@claude-plugins-official
```

このコマンドを実行するとプラグインの詳細が開き、そこで[インストールスコープ](https://code.claude.com/docs/ja/plugins/install.md#install-a-plugin)を選択するとインストールが開始されます。すべてのプロジェクトでプラグインを使用するには、ユーザースコープを選択してください。

インストールが失敗した場合は、Claude Code が表示するメッセージに応じて対処してください。

* `Marketplace "claude-plugins-official" not found`：`/plugin marketplace add anthropics/claude-plugins-official` でマーケットプレイスを追加してから、インストールを再試行します。
* `Plugin "claude-security" not found in marketplace "claude-plugins-official"`：マーケットプレイスカタログのローカルコピーが古くなっている可能性があります。`/plugin marketplace update claude-plugins-official` で更新してから、インストールを再試行します。再試行しても同じメッセージが表示される場合は、[Plugin not found in marketplace](https://code.claude.com/docs/ja/plugins/troubleshooting.md#plugin-not-found-in-marketplace) を参照してください。

インストールの概要を確認します。`Run /reload-plugins to apply.` と表示された場合は、[再起動せずにプラグインの変更を適用する](https://code.claude.com/docs/ja/plugins/cli-reference.md#reload-plugins)を参照して、現在のセッションでプラグインを有効にしてください。

プラグインが有効になったら、[コードベースをスキャンして修正する](#scan-and-fix-your-codebase)準備は完了です。

### プラグインを更新する

コマンドやオプションが動作しない場合は、プラグインのバージョンが 0.13.0 以降であることを[確認](https://code.claude.com/docs/ja/plugins/install.md#install-a-plugin)してください。

プラグインを自分で更新するには、[プラグインを今すぐ更新する](https://code.claude.com/docs/ja/plugins/install.md#update-plugins-now)を参照してください。また、自動更新がオフになっている場合を除き、Claude Code は[プラグインを自動的に更新](https://code.claude.com/docs/ja/plugins/install.md#keep-plugins-updated)します。

### プラグインをアンインストールする

プラグインを削除するには、`/plugin` メニューからアンインストールするか、ターミナルで `claude plugin uninstall claude-security` を実行します。

## コードベースをスキャンして修正する

Claude Code のプロンプトで `/claude-security` を実行すると、コードベースのスキャン、一連の変更のスキャン、パッチの提案といったジョブのメニューが開きます。基本的な流れでは、フルスキャンを実行し、その検出結果をパッチに変換します。

**1. クリーンな作業ツリーから始める**

後でパッチが必要な場合は、すべての変更と未追跡ファイルをコミットするか、スキャンが終わるまでシェルから `git stash -u` でスタッシュしておきます。

**2. Claude Security メニューを開く**

リポジトリで Claude Code を起動し、`/claude-security` を実行して **Scan codebase** を選択します。

**3. スキャン対象を選ぶ**

プラグインはまずリポジトリを読み込み、リポジトリ全体または特定の領域を選択肢として提示します。リポジトリ全体を選ぶか、「I don't know」と答えると、プラグインがリポジトリのサイズに応じた妥当なデフォルトを選択します。

**4. 実行を確認する**

スキャンには時間がかかる場合があり、大量のトークンを使用することがあります。また、完了するまで Claude Code を開いたままにしておく必要があります。確認するまで何も実行されません。

**5. レポートを読む**

ターミナルセッションでスキャンを開始すると、デフォルトでオンになっているプラグインの[ライブビュー](#watch-a-running-scan)が開き、コードのライブマップが表示されます。ターミナルで [`/workflows`](https://code.claude.com/docs/ja/workflows#watch-the-run) を使って各ステージを追うこともできます。結果は Claude Code を起動したフォルダ内のタイムスタンプ付きディレクトリに書き込まれます。詳しくは[スキャン結果を読む](#read-the-scan-results)を参照してください。

**6. 検出結果をパッチに変換する**

`/claude-security` を再度実行して **Suggest patches** を選択し、対処する検出結果を選びます。レビュー済みのパッチはレポートの `patches/` フォルダに書き込まれます。各パッチがどのように作成・レビューされるか、またその後に何を確認すべきかについては、[検出結果を修正する](#fix-findings)を参照してください。

**7. 受け入れるパッチを適用する**

各パッチの[注記](#patches-are-never-applied-automatically)を読み、リポジトリのルートでシェルから `git apply` を使ってパッチを適用し、それぞれ個別のプルリクエストにします。パッチが自動的に適用されることはありません。

`/claude-security scan my branch` のように、コマンドの引数としてジョブを直接指定することもできます。また、「Claude Security プラグインでリポジトリ全体をスキャンして」のように自然な言葉で依頼することもできます。プラグインは [auto モード](https://code.claude.com/docs/ja/permission-modes.md)で最もよく機能します。auto モードでは、各ステップで権限プロンプトを表示せずにスキャンを進められます。

### 実行中のスキャンを監視する

ターミナルセッションでスキャンを開始すると、プラグインの [mod](https://code.claude.com/docs/ja/plugins/mods/overview.md) が、ペインまたはプロンプト上部のバンドにスキャンのライブビューを開きます。Claude Code v2.1.292 以降が必要です。

* **閉じる**: `Ctrl+X X` を押すとペインがバンドに縮小され、もう一度押すとバンドが非表示になります
* **再度開く**: スキャンの実行中に `/claude-security-view` と入力します
* **オフにする**: `/plugin configure claude-security` と入力して **Live scan view** を変更します

### 停止したスキャンを続行する

セッション内のスキャンがレポートを書き込む前に停止した場合は、続行できます。ただし、セーフガードによってスキャンのエージェントのいずれかが停止されたとセッションに表示されている場合は除きます。その場合は、代わりに新しいスキャンを開始してください。

続行するには、チェックアウトとスキャンの `CLAUDE-SECURITY-<timestamp>/` ディレクトリを変更せずにおき、スキャンを実行したセッションで `/claude-security continue the scan` と入力します。そのセッションを閉じてしまった場合は、先に[セッションを再開](https://code.claude.com/docs/ja/sessions.md#resume-a-session)してください。

### 変更のみをスキャンする

ブランチにベースにないコミットがある場合、`/claude-security` メニューでその差分のみをスキャンするオプションが提示されるため、マージ前にブランチをチェックできます。変更スキャンの前に、スキャン対象にしたい編集をコミットし、残りを `git stash -u` でスタッシュするか、作業ツリーを読み込む[フルスキャン](#scan-and-fix-your-codebase)を実行してください。

自分のオープンなプルリクエストや単一のコミットをスキャンするには、まずシェルからそれをチェックアウトし、その後 Claude Code のプロンプトで依頼します。

* **プルリクエスト**: プルリクエストのブランチを指定して `git checkout feature-auth` を実行し、次に `/claude-security scan my branch` を実行します
* **単一のコミット**: `git checkout abc1234` を実行し、次に `/claude-security scan commit abc1234` を実行します

### 大規模なリポジトリのスコープを絞る

大規模なリポジトリでは、ツリー全体ではなく一度に 1 つの領域をスキャンします。API レイヤーや認証コードなど、プラグインが提示する特定のスコープのいずれかを選ぶと、実行はその選択に合わせた規模になります。レポートのカバレッジセクションには、何が調査され、何が調査されなかったかが記載されます。別の領域に対するスキャンはいつでも実行できます。

### スキャンの労力を選ぶ

スキャンの労力によって、スキャンの深さが決まります。`low`、`medium`、`high` のいずれでも、検出結果は同じ独立した検証を経ます。

* **`low`**: 手早い初回チェック。コードベースをスキャンする際にアーキテクチャマップをスキップします。
* **`medium`**: デフォルト。
* **`high`**: `medium` の内容に加えて、同じコード内の脆弱性をさらに探索します。

Claude Code のプロンプトでの依頼の中で、コードベースの一部や変更に対してなど、スキャンの労力を指定します。

* **コードベースの一部**: `/claude-security scan my public API code at high`
* **自分の変更**: `/claude-security scan my branch at high`

大規模なリポジトリのスキャンで期待より検出結果が少ない場合は、`high` のスキャンの労力を選ぶか、2 回目のスキャンを行うか、その両方を行ってください。いずれの方法でも、1 回の `medium` スキャンでは報告されない検出結果が報告される可能性があります。

コードベースのスキャンは大量のトークンを消費する可能性があり、そのコストはリポジトリのサイズ、スキャンの労力、モデルに応じて増加します。コストを抑えるには、開始前に[より小さな領域](#scope-large-repositories)をスキャンするか、`low` を選ぶか、[モデルを変更](#models-and-providers)してください。

### より徹底的な変更スキャンを実行する

[スキャンの労力](#choose-a-scan-effort)の代わりに `--change-scan-effort high` を指定します。たとえば `/claude-security scan my branch --change-scan-effort high` のようにします。`high` のスキャンの労力よりも多くのエージェントが変更を読み込むため、スキャンに時間がかかり、コストも数倍になります。そのレポートには、変更より前から存在する脆弱性も記載されます。

### システムについてスキャンに伝える

システムに関する事実をスキャンに伝えるには、スキャン対象のフォルダ内のファイルを最大 10 個指定するか、独自のメモを入力します。

それらは依頼の中で、またはスキャンから求められたときに渡します。

```text theme={null}
/claude-security scan this repository, and read docs/arch.md first
```

誤った記述は脆弱性を見逃す原因になり得るため、最新かつ信頼できるメモやファイルのみを渡してください。スキャンは信頼されたユーザーや意図された動作について README や `SECURITY.md` に書かれている内容を考慮するため、これらも最新の状態に保ってください。

このスキャンから[パッチを取得する](#scan-and-fix-your-codebase)には、指定したファイルをスタッシュせずにコミットしてください。

### スキャン結果を読む

セッションでスキャンを実行すると、Claude Code を起動したフォルダ内のタイムスタンプ付き `CLAUDE-SECURITY-<timestamp>/` ディレクトリに結果が出力されます。

* **`CLAUDE-SECURITY-RESULTS.md`**: レポート。各検出結果の ID（`F1` など）に加えて、その影響、悪用シナリオ、深刻度、確信度、推奨事項が含まれます
* **`CLAUDE-SECURITY-RESULTS.jsonl`**: 同じ検出結果を機械可読な形式で、1 行に 1 つの JSON オブジェクトとして記載したもの
* **`CLAUDE-SECURITY-RESULTS.sarif`**: 同じ検出結果を、GitHub code scanning やこの標準を読み込むその他のツール向けに [SARIF 2.1.0](https://docs.oasis-open.org/sarif/sarif/v2.1.0/sarif-v2.1.0.html) ログとして記載したもの。スキャンは検出結果を [CWE](https://cwe.mitre.org/) の弱点カテゴリに分類します
* **`CLAUDE-SECURITY-REVISION-<commit>.json`**: リビジョンスタンプ。どのコミットがスキャンされたか、どの[スキャンの労力](#choose-a-scan-effort)で実行されたか、未コミットの変更がスキャン対象のツリーに含まれていたか、実行がどの程度徹底的に検証されたかを記録します。バージョン管理外のスキャンでは、コミットの代わりに `UNVERSIONED` が記録されます

このディレクトリはスキャンがチェックアウトに加える唯一の変更であり、独自の `.gitignore` を持っているため、うっかり `git add` してもレポートがコミットに含まれることはありません。パッケージングツールやデプロイツールの中にはこのファイルを読み込まないものもあるため、パッケージングやデプロイの間はレポートディレクトリを移動させておいてください。監査証跡としてレポートを履歴に残すには、その `.gitignore` ファイルを削除してディレクトリをコミットします。

検出結果は、独立した検証エージェントが分析した後にのみレポートに記載されるため、レポートは簡潔で読む価値のあるものになります。スキャンは非決定的であり、同じコードを 2 回スキャンしても異なる検出結果が得られることがあります。定期的にスキャンを実行してください。

## 検出結果を修正する

修正フローを開始するには、`/claude-security` メニューから **Suggest patches** を選択するか、「fix finding F3」のように自然な言葉で依頼し、レポート内のどの検出結果に対処するかを選択します。各パッチは、リポジトリの作業用コピー内で作成されます。それでもエージェントが誤ってユーザー自身のファイルを編集する可能性があるため、ジョブの終了時に `git status` を実行してください。

パッチを提供する前に、パッチを作成したエージェントとは独立したエージェントがそのパッチをレビューします。このエージェントは、可能な場合はプロジェクトのテストを実行し、パッチによって新たに持ち込まれる可能性のある問題がないか、独自の観点で差分を読みます。

このレビューでは、パッチが以下を満たしていることを保証する必要があります。

* 対象となる 1 件の検出結果に対処している
* 新たな脆弱性を持ち込んでいない
* それ以外の動作を変更していない

レビューで 3 つすべてを保証できない場合、プラグインはパッチの代わりに、その理由を説明する短いメモを作成します。

### 古いレポートからのパッチ

新しいコミットの後でもスキャンのレポートを使用できますが、スキャンされたコミットが現在の履歴に含まれている場合に限ります。含まれていない場合は、プラグインが提案する新しいスキャンを実行してください。

### パッチが自動的に適用されることはありません

パッチを適用するかどうかはユーザーが判断します。パッチはレポートの `patches/` フォルダーに書き込まれ、パッチが作成された検出結果ごとに 1 つの `F<n>.patch` と、その横に変更内容を説明するメモが置かれます。Claude にパッチの適用とプルリクエストの作成を依頼するか、リポジトリのルートでシェルから適用してください。

まずパッチのメモ `F<n>.md` を読んでください。そこには、次のような正確なコマンドが記載されています。

```bash theme={null}
git -C "$(git rev-parse --show-toplevel)" apply CLAUDE-SECURITY-<timestamp>/patches/F1.patch
```

各パッチを個別にレビューおよびテストできるように、パッチごとに別々のプルリクエストで適用してください。`git apply` がパッチを拒否した場合は、そのパッチのメモを読んでください。

## 既存の検出結果をトリアージする

Vulnerability Triage は、リスト内の検出結果がコードに照らして妥当かどうかを確認します。リストには、別のスキャナーが出力した SARIF 2.1.0 ファイル、または以前のスキャンで作成された `CLAUDE-SECURITY-<timestamp>/` ディレクトリを使用できます。トリアージするのは、信頼できるソースから得たリストだけにしてください。

後でパッチを作成する場合は、リスト自体を除き、未コミットのファイルや未追跡のファイルを残さないでください。検出結果のファイルパスの基準となるディレクトリ（通常はリポジトリのルート）で Claude Code を起動します。

次に、リストのパスを指定してコマンドを入力します。

```text theme={null}
/claude-security triage results.sarif
```

レポートは `FINDINGS-TRIAGE.md` で、新しい `CLAUDE-SECURITY-<timestamp>/` ディレクトリ内に作成されます。トリアージで却下された検出結果は **Not validated** の下に記載されます。リスト内でわずかな言葉でしか説明されていない実際の検出結果は、トリアージで却下される可能性が高くなるため、このセクションは自分で確認してください。レポートと同じ場所にある `FINDINGS-TRIAGE.sarif` は、元のリストに判定結果を追加したものです。

レポートの有効な検出結果をパッチにするには、トリアージの最後に表示される提案を承諾します。その前にコミット、プル、またはブランチの切り替えを行った場合は、新しいトリアージを開始してください。パッチジョブの後に確認すべき事項については、[検出結果を修正する](#fix-findings)を参照してください。

## 脅威モデルを作成する

`/claude-security:threat-model` コマンドは、脅威モデルの草案を作成します。脅威モデルは、後続のスキャンに渡せるファイルです。

リポジトリのルートで Claude Code を起動し、次のように入力します。

```text theme={null}
/claude-security:threat-model
```

Claude はコードとスキャンレポートがあればそれを読み込み、システムについて、またほかに何を読み込んでよいか（フォルダ、[コネクタ](https://code.claude.com/docs/ja/mcp.md)、貼り付けたテキスト）を尋ねます。

> [!WARNING]
>
> Claude にコネクタの読み込みを許可すると、その検索語句がマシンの外に送信され、検索語句にはそのレポートの語句が含まれる場合があります。Claude は、そこで読み込んだ内容や貼り付けたテキストによって誤った方向に導かれる可能性があります。

Claude が草案を表示したら、次の手順を行います。

1. **Yes** を選択して `.claude-security/threat-model.md` として保存する前に、内容を確認してください。誤った記述があると、後続のスキャンで脆弱性が見落とされる可能性があるためです。
2. スキャンレポートがある場合は、Claude がレポートのフォルダに `CLAUDE-SECURITY-PRECONDITIONS.md` を書き込むかどうかを選択します。このファイルには、Claude が読み込んだソースにおいて、各検出結果の前提条件が `met`、`not met`、`not shown` のいずれであるかが記載されます。
3. Claude の処理が完了したら、このプラグインの別のコマンドを実行する前に [`/clear`](https://code.claude.com/docs/ja/commands#all-commands) を入力します。

スキャンで確実に脅威モデルが読み込まれるようにするには、[リクエストの中で脅威モデルを指定してください](#tell-a-scan-about-your-system)。

## アタックサーフェスを分析する

アタックサーフェス分析では、プロジェクトのうち攻撃者が到達できる部分を調べ、そのアタックサーフェスを縮小するための変更を提案します。

リポジトリのルートで Claude Code を起動し、[利用可能](https://code.claude.com/docs/ja/permission-modes.md#eliminate-prompts-with-auto-mode)な場合は [auto モード](https://code.claude.com/docs/ja/permission-modes.md#switch-permission-modes)で次のように入力します。

```text theme={null}
/claude-security:attack-surface-analysis
```

分析には長い時間がかかり、大量のトークンを使用する場合があります。分析が終わるまでは Claude Code を開いたままにし、コミット、ブランチの切り替え、ファイルの編集は行わないでください。

分析は、脆弱性を探す[スキャン](#scan-and-fix-your-codebase)の代わりにはなりません。分析では次のものを探します。

* デフォルト設定で到達可能だが、どのデフォルト機能も使用していないコード
* ログイン前、またはユーザーの操作なしで到達可能な機密性の高いコード
* セキュリティ機能を暗黙のうちにオフにしてしまうオプションの組み合わせ

レポートは、Claude Code を起動したフォルダ内の `CLAUDE-SECURITY-<timestamp>/CLAUDE-SECURITY-RESULTS.md` です。分析でパッチが作成された場合は、その横にある `attack-surface-patches/PATCHES.md` にパッチの説明が記載されています。検出結果とパッチは、自分で確認するまでは未検証のものとして扱ってください。

## シェルからスキャンする

`claude-security` コマンドは、実行したフォルダをスキャンし、[同じレポート](#read-the-scan-results)をそのフォルダに書き込みます。スキャンは[プラグインのサンドボックス](https://github.com/anthropics/claude-plugins-official/blob/main/plugins/claude-security/README.md#running-in-a-sandbox)内で実行されます。Claude Code のログイン情報、またはプロバイダーの環境変数を使用してサインインします。

サンドボックスは Linux でのみ動作します。

* **Linux**：x86-64 または arm64 上のカーネル 5.19 以降、Python 3.10 以降、および root 以外のユーザーが必要です。Ubuntu 24.04 以降では `--sudo` を追加してください。これにより `sudo` でサンドボックスがセットアップされます。システムがこれらの要件を満たしていない場合は、[セッション内でスキャン](#scan-and-fix-your-codebase)してください。
* **Windows**：`--no-sandbox` を追加してください。追加しない場合、コマンドは停止します
* **macOS および WSL 2**：このコマンドはサポートされていないため、[セッション内でスキャン](#scan-and-fix-your-codebase)してください

> [!WARNING]
>
> このコマンドはリポジトリの `.claude/` の設定やフックを読み込まないため、そこにある拒否ルールは適用されません。サンドボックス内では、組織の[サーバー管理設定](https://code.claude.com/docs/ja/server-managed-settings.md#security-considerations)も適用されません。`--no-sandbox` を追加した場合、スキャンはユーザーのアクセス権限で [auto モード](https://code.claude.com/docs/ja/permission-modes.md#eliminate-prompts-with-auto-mode)で実行されます。プラグインの[信頼モデル](https://github.com/anthropics/claude-plugins-official/blob/main/plugins/claude-security/SECURITY.md#trust-model)を参照してください。

このコマンドはプラグインに含まれています。`PATH` に追加するには、Claude Code で `/claude-security:install-cli` と入力し、表示される指示に従ってください。

次に、リポジトリ内で実行します。システムで必要な場合は `--sudo` または `--no-sandbox` を付けてください。

* **コードベースをスキャンする**：`claude-security`
* **このブランチの変更をスキャンする**：`claude-security --changes`
* **フルスクリーン表示でスキャンする**：`claude-security --tui`（Node.js 18 以降が必要）
* **その他のオプションを一覧表示する**：`claude-security --help`

このコマンドは [auto モード](https://code.claude.com/docs/ja/permission-modes.md#eliminate-prompts-with-auto-mode)で実行され、auto モードが利用できない場合は停止します。Claude Code のモデルが auto モードをサポートしていない場合は、`--model` でサポートしているモデルを指定してください。それ以外の原因の場合は、[セッション内でスキャン](#scan-and-fix-your-codebase)してください。

## GitHub Actions でプルリクエストをスキャンする

プルリクエストでは、プラグインの GitHub Actions ジョブが変更をスキャンし、レビューと修正案を投稿して、マージをブロックすることもできます。また、スケジュールに従ってリポジトリ全体をスキャンすることもできます。

> [!WARNING]
>
> このジョブは、プッシュできるすべての人を信頼できるリポジトリでのみ使用してください。プルリクエストのブランチにテキストやコードを追加できる人は誰でも、スキャンを誘導し、そのコードを実行させ、ジョブの認証情報を使ってモデルリクエストを送信させることができます。デフォルトでは、フォークからのプルリクエストに対してジョブは失敗します。
>
> パブリックリポジトリでは、レビュー、ジョブサマリー、またはジョブのレポートアーティファクトによって、修正されていない脆弱性が開示される可能性があります。検出結果を非公開にしておくには、代わりに[セッション内でスキャン](#scan-only-your-changes)してください。

このジョブには、GitHub.com 上の GitHub ホストの Linux ランナーと、[Anthropic API アクセス](https://platform.claude.com/docs/en/get-api-key)または[サードパーティプロバイダー](https://code.claude.com/docs/ja/third-party-integrations.md)が必要です。これは、有料プランではサインインできないためです。プラグインの [GitHub Actions ガイド](https://github.com/anthropics/claude-plugins-official/blob/main/plugins/claude-security/CI.md)に従ってワークフローを追加し、このジョブ専用の認証情報を作成してください。バージョン 0.13.0 に移行するには、各ワークフローの `@` の後にそのコミットを記述します：`d0d514288960e7a78e1a76e4a3ec694416458726`。

ガイドのサンプルワークフローでは、リポジトリのブランチからのドラフトプルリクエストは、レビュー準備完了としてマークするまでスキャンされずに通過します。Dependabot からのプルリクエストもスキャンされずに通過するため、その変更はご自身でレビューしてください。

## プラグインと他のセキュリティツールとの関係

Claude Security プラグインは、多層防御スタックにおけるディープスキャン層であり、[セキュリティガイダンスプラグイン](https://code.claude.com/docs/ja/security-guidance.md)、[Code Review](https://code.claude.com/docs/ja/code-review.md)、マネージド製品の [Claude Security](https://claude.com/product/claude-security)、および既存のスキャナーと併用します。

| ステージ | ツール | 対象範囲 |
| :- | :- | :- |
| セッション内 | [セキュリティガイダンスプラグイン](https://code.claude.com/docs/ja/security-guidance.md) | Claude が書いたコードに含まれる一般的な脆弱性を、同じセッション内で修正 |
| オンデマンド、ディープスキャン | Claude Security プラグイン | リポジトリまたは差分のマルチエージェントスキャン。検出結果とパッチは個別にレビューされる |
| プルリクエスト時 | [Code Review](https://code.claude.com/docs/ja/code-review.md)、Team および Enterprise プラン | コードベース全体のコンテキストを用いたマルチエージェントによる正確性とセキュリティのレビュー |
| プルリクエスト時、ディープスキャン | [GitHub Actions での Claude Security プラグイン](#scan-pull-requests-in-github-actions) | プルリクエストの変更のマルチエージェントスキャン |
| マネージド | [Claude Security](https://claude.com/product/claude-security)、Enterprise プラン | 接続されたリポジトリを監視するホスト型スキャン |
| CI 内 | 既存の静的解析および依存関係スキャナー | 言語固有のルール、サプライチェーンのチェック、ポリシーの適用 |

このプラグインは、既存のソースコードセキュリティツールを置き換えるものではありません。静的解析、依存関係スキャン、コードレビューと併用してください。このプラグインは人間のセキュリティ研究者と同じようにコードについて推論するため、これらのツールが提供する決定論的なチェックを補完します。

組織でマネージド製品の Claude Security を使用している場合、`/claude-security:hosted` を使うとその検出結果をセッション内に表示できます。使用する前に、[要件](https://github.com/anthropics/claude-plugins-official/blob/main/plugins/claude-security/README.md#findings-from-hosted-claude-security)と[リスク](https://github.com/anthropics/claude-plugins-official/blob/main/plugins/claude-security/SECURITY.md#findings-from-hosted-claude-security)をお読みください。

## トラブルシューティング

**`/claude-security` メニューを開くと Python の警告が表示される。** このプラグインには、`PATH` 上に `python3` 3.9 以降が必要です。`python3` がまったく見つからない場合、メニューには Python をインストールするまで Claude Security が動作しないという警告が表示されます。`PATH` 上で最初に見つかる `python3` が古い場合は、検出されたバージョンが警告に示されます。Python 3 をインストールするか、より新しい `python3` が `PATH` の先頭に来るように設定してから、新しいセッションを開始してください。

**Fable モデルでスキャンすると「safeguards flagged this message」という通知が表示されることがある。** このメッセージには、実行中のモデル名が示されます。Fable のサイバーセキュリティ安全性分類器は特定のリクエストを警告対象とし、Claude Code は警告対象となったリクエストを[自動モデルフォールバック](https://code.claude.com/docs/ja/model-config.md#automatic-model-fallback)によって Opus モデルで再実行します。これは想定どおりの動作です。リクエストが再実行されても、スキャンは通常どおり正常に完了するはずです。スキャンが停止した場合は、[停止したスキャンを続行する](#continue-a-stopped-scan)を参照してください。

## 関連リソース

このページが触れるピースについてさらに詳しく知るには：

* [セキュリティガイダンスプラグイン](https://code.claude.com/docs/ja/security-guidance.md)：Claude がコードを書くときにコード内の問題をキャッチします。同じセッション内で
* [Code Review](https://code.claude.com/docs/ja/code-review.md)：PR 時のマルチエージェントレビューをセットアップします
* [Claude Security](https://claude.com/product/claude-security)：接続されたリポジトリを監視するマネージドサービス
* [Claude Code セキュリティ](https://code.claude.com/docs/ja/security.md)：Claude Code がトラスト、権限、セーフガードにどのようにアプローチするか
* [プラグインをインストールして管理](https://code.claude.com/docs/ja/plugins/install.md)：公式マーケットプレイスから他のプラグインを検索してインストールします
