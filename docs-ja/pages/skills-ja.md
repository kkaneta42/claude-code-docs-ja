> ## Documentation Index
> Fetch the complete documentation index at: https://code.claude.com/docs/llms.txt
> Use this file to discover all available pages before exploring further.

# Claude をスキルで拡張する

> Claude Code でスキルを作成、管理、共有して Claude の機能を拡張します。カスタムコマンドとバンドルされたスキルが含まれます。

スキルは Claude ができることを拡張します。`SKILL.md` ファイルに指示を記述すると、Claude はそれをツールキットに追加します。Claude は関連する場合にスキルを使用するか、`/skill-name` で直接呼び出すことができます。

同じ指示、チェックリスト、または複数ステップの手順をチャットに何度も貼り付けている場合、または CLAUDE.md のセクションが事実ではなく手順に成長している場合は、スキルを作成してください。CLAUDE.md のコンテンツとは異なり、スキルの本体は使用される場合にのみ読み込まれるため、長い参考資料は必要になるまでほぼコストがかかりません。

> [!NOTE]
>
> `/help` や `/compact` などの組み込みコマンド、および `/debug` や `/code-review` などのバンドルされたスキルについては、[コマンドリファレンス](https://code.claude.com/docs/ja/commands.md)を参照してください。
>
> **カスタムコマンドはスキルにマージされました。** `.claude/commands/deploy.md` のファイルと `.claude/skills/deploy/SKILL.md` のスキルの両方が `/deploy` を作成し、同じように機能します。既存の `.claude/commands/` ファイルは引き続き機能します。スキルはオプション機能を追加します。サポートファイル用のディレクトリ、[スキルを呼び出すユーザーを制御する](#control-who-invokes-a-skill)ためのフロントマター、および Claude が関連する場合に自動的にスキルを読み込む機能です。

Claude Code スキルは [Agent Skills](https://agentskills.io) オープンスタンダードに従い、複数の AI ツール全体で機能します。Claude Code は [呼び出し制御](#control-who-invokes-a-skill)、[サブエージェント実行](#run-skills-in-a-subagent)、[動的コンテキスト注入](#inject-dynamic-context)などの追加機能でスタンダードを拡張します。[Claude Code 外でスキルフロントマターを使用する](#using-skill-frontmatter-outside-claude-code)を参照して、どのフロントマターフィールドがスタンダードの一部であり、どれが Claude Code 拡張機能であるかを確認してください。

## バンドルされたスキル

Claude Code には、`/doctor`、`/code-review`、`/batch`、`/debug`、`/loop`、`/claude-api` などのバンドルされたスキルが含まれています。バンドルされたスキルはプロンプトベースです。Claude に詳細な指示を与え、ツールを使用して作業を調整させます。ほとんどの組み込みコマンドは、代わりに固定ロジックを直接実行します。

バンドルされたスキルは、他のスキルと同じ方法で呼び出します。`/` の後にスキル名を入力します。Claude は関連する場合、一部のバンドルされたスキルを自動的に呼び出します。`/verify` を含む他のスキルは、呼び出した場合にのみ実行されます。これにより、これらの長時間実行されるチェックが時間とトークンを費やすタイミングを制御できます。

ほとんどのバンドルされたスキルはすべてのセッションで利用可能です。いくつかは特定の機能に依存しています。たとえば、`/workflow-authoring` は [動的ワークフロー](https://code.claude.com/docs/ja/workflows.md) が有効な場合にのみ利用可能です。

バンドルされたスキルをオフにするには、[`disableBundledSkills`](https://code.claude.com/docs/ja/settings-reference#disablebundledskills) 設定を使用します。

> [!NOTE]
>
> [`/doctor`](https://code.claude.com/docs/ja/commands#all-commands) セットアップチェックアップは、`disableBundledSkills` がオンの場合でも入力可能なままです。これを非表示にするには、`DISABLE_DOCTOR_COMMAND` 環境変数を設定するか、[`skillOverrides`](#override-skill-visibility-from-settings) エントリ `"doctor": "off"` を設定します。

バンドルされたスキルは、[コマンドリファレンス](https://code.claude.com/docs/ja/commands.md) に組み込みコマンドと一緒にリストされており、目的列に **Skill** とマークされています。

### `/doctor` でセットアップを確認する

Claude Code プロンプトで `/doctor` を実行すると、問題を診断して修正できるセットアップチェックアップが行われます。Claude はまず調査結果を報告し、何かを変更する前に確認を求めます。チェックアップは次の領域を対象とします。

* **インストールの健全性**: 重複したインストールや残存しているインストール、`PATH` の問題、解析できない設定ファイル、および[リリースチャネル](https://code.claude.com/docs/ja/setup.md#configure-release-channel)で新しいバージョンが利用可能かどうか
* **拡張機能**: コンテキストコストと比較した未使用のスキル、MCP サーバー、プラグイン、および低速な[フック](https://code.claude.com/docs/ja/hooks.md)
* **`CLAUDE.md` ファイル**: チェックイン済みのものと重複するローカルの `CLAUDE.md` ファイル、チェックイン済みの [Claude がコードベースから導出できる `CLAUDE.md` の内容](https://code.claude.com/docs/ja/memory#my-claude-md-is-too-large)、および残りの常時読み込まれるガイダンス。Claude は、このガイダンスをオンデマンドで読み込まれるスキルやネストされた `CLAUDE.md` ファイルに移行することを提案します
* **権限**: [auto モード](https://code.claude.com/docs/ja/permissions.md#permission-modes)をデフォルトの権限モードにすることと、頻繁に拒否している読み取り専用コマンドを[事前承認](https://code.claude.com/docs/ja/permissions.md)することの提案
* **使用量**: Pro、Max、Team、または Enterprise プランの場合、プランの使用量を減らすために [`/usage` が推奨する変更](https://code.claude.com/docs/ja/costs#plan-usage-breakdown)（過去 7 日間で測定）。Claude は自身で行える変更を提案し、残りはユーザーが実行するコマンドなどのアドバイスとして報告します。使用量のチェックには Claude Code v2.1.305 以降が必要です。また、[Remote Control](https://code.claude.com/docs/ja/remote-control.md) が接続されている間、`/doctor` はこのチェックを省略します。

セッションを開始せずに読み取り専用のインストール診断を行うには、代わりにターミナルで `claude doctor` を実行します。

セットアップではなく指示を監査するには、Claude Code プロンプトで `/doctor prompt-audit` を実行します。Claude はチェックアップを実行する代わりに、[`CLAUDE.md` ファイル、スキル、その他の設定をチェック](https://code.claude.com/docs/ja/memory#audit-your-instruction-files)して、古くなった指示や矛盾する指示がないかを確認します。`prompt-audit` サブコマンドには Claude Code v2.1.283 以降が必要です。

### アプリを実行して検証する

3 つのバンドルスキルが連携して、アプリを起動し、テストだけでなく実行中のアプリに対して変更を確認します。

| スキル | 目的 |
| :- | :- |
| `/run` | アプリを起動して駆動し、変更が機能していることを確認する |
| `/verify` | アプリをビルドして実行し、コード変更が意図したことを実行していることを確認する。テストまたは型チェックにフォールバックしない |
| `/run-skill-generator` | `/run` と `/verify` にプロジェクトをビルドして起動する方法を教える |

`/run` と `/verify` はセットアップなしで動作します。プロジェクトタイプ（CLI、サーバー、TUI、ブラウザ駆動）と README、`package.json`、または `Makefile` の内容から起動を推測します。その推測は、標準的な起動を超えて何かが必要なプロジェクト（データベース、env ファイル、グラフィカルセッション、マルチステップビルド）では信頼性が低くなります。

`/run-skill-generator` は代わりにレシピを記録します。クリーン環境からアプリを実行し、機能したもの（インストールコマンド、環境変数、起動スクリプト）をキャプチャし、`.claude/skills/run-<name>/` でプロジェクトごとのスキルとしてコミットします。その後、`/run`、`/verify`、およびリポジトリ内の他のエージェントは、記録されたレシピに従い、再度発見することはありません。プロジェクトごとに 1 回 `/run-skill-generator` を実行し、ビルドまたは起動プロセスが変更された場合は再度実行します。

`/verify` は独自のレシピを記録することもできます。記録されたレシピなしでアプリをビルドして駆動する必要がある場合、機能した内容をリポジトリルートの `.claude/skills/verify/SKILL.md`、またはモノレポの場合は変更されたパッケージディレクトリに書き込みます。これにより、後の実行や他のエージェントも同じステップに従います。リポジトリルートでは、記録されたスキルがバンドルスキルの `/verify` を置き換えます。

Claude は、失敗したコマンドや欠落したステップなど、実行を誤った場合にのみ記録されたファイルを編集するため、セッションごとの差分なしでファイルをコミットできます。

### 各コミットの前にチェックを実行する

`verify` または `simplify` という名前のスキルが存在する状態でセッションが開始されると、Claude Code のコミット指示により、Claude はドキュメントやテストへの変更を除き、各コミットの直前にそのスキルを実行します。これには Claude Code v2.1.286 以降が必要です。セッション開始時に次の条件を満たしている場合、Claude はその指示を受け取ります。

* **場所**: スキルがエンタープライズ、個人、プロジェクト、または追加ディレクトリの[場所](#where-skills-live)から読み込まれるか、その名前の `.claude/commands/` ファイルから読み込まれること。`/verify` がリポジトリルートに記録するレシピはプロジェクトスキルであるため、対象になります。バンドルされた `/verify` と `/simplify`、プラグインスキル、claude.ai アカウントのスキルは対象外です。
* **呼び出し**: Claude がスキルを呼び出せること。たとえば `disable-model-invocation: true` などで [Claude による呼び出しを停止した](#control-who-invokes-a-skill) 場合、Claude はこの指示を受け取りません。
* **Git の指示**: [`includeGitInstructions`](https://code.claude.com/docs/ja/settings-reference#includegitinstructions) をオフにしていないこと。オフにすると、組み込みのコミットおよび PR に関するその他の指示とともに、この指示も削除されます。

### Claude API プロジェクトで作業する

バンドルされた `/claude-api` スキルは、プロジェクトの言語に対して [Claude API](https://platform.claude.com/docs/en/api/overview) および [Managed Agents](https://platform.claude.com/docs/en/managed-agents/overview) リファレンス資料を読み込みます。コードが `anthropic` または `@anthropic-ai/sdk` をインポートする場合、Claude はこれを自動的にアクティベートします。

スキルのワークフローの 1 つを開始するには、Claude Code プロンプトでスキル名の後にサブコマンドを入力します。たとえば `/claude-api migrate` です。表は各サブコマンドが何をするか、およびそれを含む最も古い Claude Code バージョンをリストしています。`migrate` と `managed-agents-onboard` は v2.1.221 より前のバージョンです。これは表が追跡する最も古いバージョンです。

| サブコマンド | 実行内容 | 最小バージョン |
| :- | :- | :- |
| `migrate` | 既存の Claude API コードを新しいモデルに更新する | v2.1.221 より前 |
| `upgrade` | プロジェクトの Anthropic SDK 依存関係をメジャーバージョン間で移動します。現在は Python `anthropic` パッケージを 0.x から 1.x に移動します | v2.1.236 以降 |
| `api-version` | Claude API コードを新しい [API バージョン](https://platform.claude.com/docs/en/api/versioning)向けに更新し、リクエストをそのバージョンに切り替える | v2.1.307 以降 |
| `managed-agents-onboard` | 新しい Managed Agent の作成をウォークスルーする | v2.1.221 より前 |
| `managed-agents-onboard <url>` | URL のページが説明する Managed Agent を構築する。たとえば [Managed Agents ドキュメント](https://platform.claude.com/docs/en/managed-agents/overview) 内のページなど | v2.1.290 以降 |
| `managed-agents-onboard <quickstart-name>` | `deep-researcher` など、Console のクイックスタートテンプレートの 1 つを構築する。テンプレート名ではない単語を 1 つ指定した場合、Claude は有効な名前を一覧表示します | v2.1.290 以降 |
| `managed-agents-secure [<agent-id>]` | 1 つの Managed Agent の設定を読み取り、[Secure your Managed Agents deployment](https://platform.claude.com/docs/en/managed-agents/secure-deployment) ガイドと一致する点と異なる点を報告する。[`ant` CLI](https://platform.claude.com/docs/en/cli-sdks-libraries/cli/quickstart) が必要です | v2.1.304 以降 |
| `prompt-audit` | プロンプト、スキル、ツール説明に書かれた古いモデル向けの指示にフラグを立て、差分として修正を提案する | v2.1.221 以降 |
| `cost-optimize` | プロジェクトの Claude API 支出がどこに行くかをプロファイルし、プロンプトキャッシング、不要な入出力トークンの削減、バッチ処理、努力、モデル選択などのオプションから節約を提案します。一度に 1 つの変更 | v2.1.247 以降 |
| `build-eval` | Claude を搭載したアプリ用の eval セットをビルドする | v2.1.259 以降 |
| `hillclimb` | 既存の eval に対してアプリを反復的に改善する | v2.1.259 以降 |
| `preserved-thinking-migration` | 統合が以前のターン、システムプロンプト、またはツールリストに対して行う編集を見つけます。これは [preserved thinking](https://platform.claude.com/docs/en/build-with-claude/preserved-thinking) ブロックを無効にし、各ブロックがどの程度の推論を削除するかを測定し、一度に 1 つずつ修正を提案します。各変更後に再測定します | v2.1.282 以降 |

## はじめに

### 最初のスキルを作成する

この例では、Git リポジトリ内のコミットされていない変更を要約し、危険な点にフラグを付けるスキルを作成します。ライブ diff をプロンプトに取り込んでから Claude が読むため、Claude が開いているファイルから推測できるものではなく、実際の作業ツリーに基づいた応答が得られます。Claude は、変更について質問するときに自動的にスキルを読み込むか、`/summarize-changes` で直接呼び出すことができます。

**1. スキルディレクトリを作成する**

個人用スキルフォルダにスキル用のディレクトリを作成します。個人用スキルはすべてのプロジェクト全体で利用できます。

```bash theme={null}
mkdir -p ~/.claude/skills/summarize-changes
```

**2. SKILL.md を作成する**

すべてのスキルには `SKILL.md` ファイルが必要です。このファイルには 2 つの部分があります。Claude がスキルをいつ使用するかを指定する `---` マーカー間の YAML frontmatter と、スキルが実行されるときに Claude が従う指示を含む markdown コンテンツです。ディレクトリ名、またはフロントマターの `name` を設定した場合はそれが、入力するコマンドになり、`description` は Claude がスキルを自動的に読み込むかどうかを決定するのに役立ちます。

これを `~/.claude/skills/summarize-changes/SKILL.md` に保存します。

```yaml theme={null}
---
description: Summarizes uncommitted changes and flags anything risky. Use when the user asks what changed, wants a commit message, or asks to review their diff.
---

## Current changes

!`git diff HEAD`

## Instructions

Summarize the changes above in two or three bullet points, then list any risks you notice such as missing error handling, hardcoded values, or tests that need updating. If the diff is empty, say there are no uncommitted changes.
```

`` !`git diff HEAD` `` 行は[動的コンテキスト注入](#inject-dynamic-context)を使用します。Claude Code はコマンドを実行し、Claude がスキルコンテンツを見る前にこの行をその出力に置き換えるため、指示は現在の diff がすでにインライン化された状態で到着します。

**3. スキルをテストする**

Git プロジェクトを開き、任意のファイルに小さな編集を加えて、`claude` を実行して Claude Code を起動します。スキルは 2 つの方法でテストできます。

**説明に一致する内容を質問して Claude に自動的に呼び出させます。**

```text theme={null}
What did I change?
```

**またはスキル名で直接呼び出します。**

```text theme={null}
/summarize-changes
```

どちらの方法でも、Claude は編集内容の短い要約とリスクのリストで応答する必要があります。

## スキルの読み込み場所を選ぶ

スキルを保存する場所によって、どのセッションがそのスキルを読み込むかが決まります。ホームディレクトリ配下に保存するとすべてのプロジェクトで使え、リポジトリにコミットするとそこで作業する全員と共有でき、プラグインや管理設定で配布するとチーム全体に届けられます。

| 場所 | パス | 読み込まれる場所 |
| :- | :- | :- |
| エンタープライズ | [管理設定ディレクトリ](https://code.claude.com/docs/ja/managed-settings.md#delivery-mechanisms)内の `.claude/skills/<skill-name>/SKILL.md` | 組織がデプロイしたマシン上のすべてのユーザー |
| 個人 | `~/.claude/skills/<skill-name>/SKILL.md` | このマシン上のすべてのプロジェクト（ただし [Cowork やクラウドセッション](#skills-in-cowork-and-cloud-sessions)を除く） |
| プロジェクト | `.claude/skills/<skill-name>/SKILL.md` | このリポジトリでのセッション（ただし[プロジェクト内のクラウドスレッド](https://code.claude.com/docs/ja/claude-projects.md#what-threads-pick-up-from-your-repositories)を除く）。コミットすればチームも利用できます |
| ネスト | `<subdir>/.claude/skills/<skill-name>/SKILL.md` | `<subdir>` またはその配下で開始したセッション（ただしプロジェクト内のクラウドスレッドを除く）。それらのスレッド以外では、上位ディレクトリで開始したセッションも、Claude がそこのファイルを扱った時点でスキルを読み込みます。[モノレポとサブディレクトリ](#discovery-from-parent-and-nested-directories)を参照してください |
| 追加ディレクトリ | `--add-dir` で渡したディレクトリ内の `.claude/skills/<skill-name>/SKILL.md` | そのセッション。[プロジェクト外のディレクトリ](#skills-from-additional-directories)を参照してください |
| プラグイン | `<plugin>/skills/<skill-name>/SKILL.md` | [プラグイン](https://code.claude.com/docs/ja/plugins/overview.md)が有効になっている場所で、`/plugin-name:skill-name` として |
| claude.ai アカウント | claude.ai アカウントで有効にしたスキル | Cowork セッション、クラウドセッション、およびそのアカウントでサインインしたターミナルセッション。[claude.ai から同期されたスキル](#how-synced-skills-behave)を参照してください |

スキルフォルダには、次のルールも適用されます。

* **シンボリックリンクされたフォルダ**：エンタープライズ、個人、プロジェクトの各場所にある `<skill-name>` エントリは、ディスク上の別の場所にあるディレクトリへのシンボリックリンクにできます。Claude Code はリンク先から `SKILL.md` を読み込み、複数の場所が同じリンク先を指していてもスキルを 1 回だけ読み込みます。プラグインスキルは[シンボリックリンクの扱いが異なります](https://code.claude.com/docs/ja/plugins/host-marketplace.md#share-files-within-a-marketplace-with-symlinks)。
* **予約名 `synced`**：大文字・小文字を問わず、スキルフォルダに `synced` という名前を付けないでください。Claude Code は [claude.ai からダウンロードしたスキル](#where-synced-skills-load)に `~/.claude/skills/synced/` を使用し、エンタープライズ、個人、プロジェクトの各場所でその名前で作成したスキルをスキップします。
* **予約名 `anthropic-skills`**：プラグイン以外では、名前が `anthropic-skills` であるか `anthropic-skills:` で始まるスキルフォルダやコマンドファイルは読み込まれません。[同期スキル用に予約された名前](#names-reserved-for-synced-skills)を参照してください。
* **名前に使える文字**：プラグイン以外では、名前にゼロ幅スペースや `<` などの文字を含むスキルフォルダは読み込まれません。[スキル名に使えない文字](#characters-a-skill-name-cant-hold)を参照してください。
* **コマンドファイル**：`.claude/commands/` 内の Markdown ファイルは旧形式ですが、引き続き動作します。`name` と `paths` を除き、同じ[フロントマター](#frontmatter-reference)をサポートします。呼び出す際に入力する名前を確認するには、[スキルのコマンド名の決まり方](#how-a-skill-gets-its-command-name)を参照してください。スキルは[サポートファイル](#add-supporting-files)にも対応しているため、新規作成にはスキルを使うことをお勧めします。
* **プラグインとしてのスキルフォルダ**：個人またはプロジェクトのスキルフォルダに `.claude-plugin/plugin.json` を追加すると、Claude Code はそれを独自のエージェント、フック、MCP サーバーを持つ `<name>@skills-dir` という名前の[プラグイン](https://code.claude.com/docs/ja/plugins/loading.md#plugins-shared-through-a-repository)として読み込めます。プロジェクトの `.claude/skills/` では、事前にワークスペースの信頼ダイアログを承認する必要があります。また、どちらの場所でも、管理者が[スキルディレクトリのプラグインをブロック](https://code.claude.com/docs/ja/plugins/loading.md#skills-directory-plugins-blocked-by-managed-settings)していないことが条件です。

### モノレポとサブディレクトリでスキルを読み込む

Claude Code は、起動したディレクトリと、そこからリポジトリルートまでのすべての親ディレクトリにある `.claude/skills/` からプロジェクトスキルを読み込みます。そのため、`packages/frontend/` で起動してもルートで定義されたスキルが読み込まれます。v2.1.246 以降で [`/cd` でセッションを移動](https://code.claude.com/docs/ja/permissions#move-the-session-to-another-directory)すると、Claude Code は移動先ディレクトリのプロジェクトスキルを追加します。

`--worktree` または `git worktree add` で作成したリンク済み [Git worktree](https://code.claude.com/docs/ja/worktrees.md) で実行中のセッションでは、Claude Code は worktree のルートまでしか親ディレクトリを検索しません。Claude Code v2.1.277 以降では、worktree のチェックアウトのルートに `.claude/skills` ディレクトリがない場合、代わりにメインチェックアウトのプロジェクトスキルを読み込みます。[worktree がメインチェックアウトと共有するもの](https://code.claude.com/docs/ja/worktrees.md#what-worktrees-share-with-the-main-checkout)を参照してください。

起動したディレクトリより下にある `.claude/skills/` ディレクトリのスキルは、起動時には読み込まれません。Claude がそのサブディレクトリ内のファイルを初めて読み取りまたは編集した時点で読み込まれ、セッションの残りの間は利用可能なままです。それまでは `/` メニューに表示されず、名前で呼び出すこともできません。より早く読み込むには、サブディレクトリのパスを指定して `/add-dir` を実行します。これには Claude Code v2.1.257 以降が必要です。デスクトップアプリから開始する worktree セッションについては、[worktree がメインチェックアウトと共有するもの](https://code.claude.com/docs/ja/worktrees.md#what-worktrees-share-with-the-main-checkout)を参照してください。

ネストされたスキルのディレクトリ名が別のスキルの名前と一致する場合、両方とも利用可能なままです。リポジトリルートに `deploy` スキルがあり、`apps/web/.claude/skills/` にももう 1 つある場合は次のようになります。

* `/deploy` はルートのスキルを実行します。Claude Code は、ディレクトリで修飾したバリアントも Claude に対して一覧表示し、作業中のファイルを含むディレクトリのものを呼び出すよう指示するため、`apps/web/` での作業にはネストされたスキルが引き続き適用されます。
* `/apps/web:deploy` は、ネストされたスキルを単独で実行します。その説明には、適用対象のディレクトリが記載されます。

### プロジェクト外のディレクトリからスキルを読み込む

`--add-dir` または `/add-dir` でディレクトリを追加すると、Claude Code はそのディレクトリの `.claude/skills/` にあるスキルを、`.claude/commands/` および `.claude/agents/` とともに読み込みます。Agent SDK が TypeScript の [`additionalDirectories`](https://code.claude.com/docs/ja/agent-sdk/typescript#options) または Python の [`add_dirs`](https://code.claude.com/docs/ja/agent-sdk/python#claudeagentoptions) で追加したディレクトリも、SDK がそれらを `--add-dir` として渡すため、同じように読み込まれます。`settings.json` の `permissions.additionalDirectories` 設定はファイルアクセスを許可するだけで、これらはいずれも読み込みません。

[セッション中にスキルを編集する](#live-change-detection)で説明しているとおり、Claude Code は起動時に `--add-dir` で渡したディレクトリ内の `.claude/skills/` を監視します。追加したディレクトリの `.claude/commands/` や `.claude/agents/` は監視しないため、そこでファイルを変更した後はセッションを再起動してください。

これらの読み込みは、デフォルトでオンになっている `project` [設定ソース](https://code.claude.com/docs/ja/agent-sdk/claude-code-features.md#control-filesystem-settings-with-settingsources)に依存します。[`strictPluginOnlyCustomization`](https://code.claude.com/docs/ja/settings-reference#strictpluginonlycustomization) ポリシー、[bare モード](https://code.claude.com/docs/ja/headless.md#start-faster-with-bare-mode)、[`--safe-mode`](https://code.claude.com/docs/ja/cli-reference#cli-flags) は、それぞれのページで説明しているとおり、これらをさらに制限します。`CLAUDE.md` やプラグイン設定を含め、追加したディレクトリが何を読み込むかの一覧表については、[追加ディレクトリは設定ではなくファイルアクセスを許可する](https://code.claude.com/docs/ja/permissions.md#additional-directories-grant-file-access-not-configuration)を参照してください。

#### 追加ディレクトリから同じ名前のスキルを実行する

追加ディレクトリのスキルは、そのフォルダ名がエンタープライズ、個人、プロジェクトのスキル、または先に追加したディレクトリのスキルと衝突する場合、プレフィックスが付きます。実行するには、Claude Code のプロンプトで `/<prefix>:<skill-name>` と入力します。`/` メニューではプレフィックス付きの名前でスキルが一覧表示され、プレフィックスの由来については[スキルのコマンド名の決まり方](#how-a-skill-gets-its-command-name)で説明しています。この名前には Claude Code v2.1.309 以降が必要です。

たとえば、`--add-dir ../cli` を指定し、プロジェクトと `../cli` の両方に `verify` スキルがある場合は次のようになります。

* `/verify` はプロジェクトのスキルを実行します
* `/cli:verify` は `../cli` のスキルを実行します

### 同じ名前のスキルを解決する

2 つのスキルでディレクトリ名やファイル名が同じ場合、それぞれの由来によって `/name` がどちらを実行するかが決まります。フロントマターの `name` フィールドで設定された名前については、[スキルのコマンド名の決まり方](#how-a-skill-gets-its-command-name)を参照してください。

| 同じ名前がある場所 | 実行されるもの |
| :- | :- |
| エンタープライズ、個人、プロジェクトのうち 2 つ | 個人よりエンタープライズ、プロジェクトより個人が優先されます。`~/.claude/skills/` とプロジェクトの `.claude/skills/` の両方に `deploy` がある場合、`/deploy` は個人のものを実行します |
| これらのいずれかの場所と[バンドルスキル](#bundled-skills) | ユーザーのスキルがバンドルされたコマンドを置き換えますが、そのエイリアスは置き換えません。プロジェクトの `code-review` スキルは `/code-review` を置き換え、バンドルされたエイリアス `/review` がユーザーのスキルを実行することはありません |
| これらのいずれかの場所と[組み込みコマンド](https://code.claude.com/docs/ja/commands.md) | ローカルのターミナルセッションでは、ユーザーのスキルが組み込みコマンドを置き換えますが、そのエイリアスは置き換えません。プロジェクトの `usage` スキルは `/usage` を置き換え、組み込みのエイリアス `/cost` は引き続き組み込みコマンドを実行します |
| スキルと `.claude/commands/` 内のファイル | スキル |
| プロジェクトルートのスキルとネストされたスキル | 両方とも読み込まれます。[モノレポとサブディレクトリ](#discovery-from-parent-and-nested-directories)を参照してください |
| エンタープライズ、個人、またはプロジェクトのスキルと、[プロジェクト外の追加ディレクトリ](#skills-from-additional-directories)内のスキル | エンタープライズ、個人、またはプロジェクトのスキル。追加ディレクトリのスキルはプレフィックス付きの名前で実行されます。[追加ディレクトリから同じ名前のスキルを実行する](#run-a-same-named-skill-from-an-added-directory)を参照してください |
| プロジェクト外の 2 つの[追加ディレクトリ](#skills-from-additional-directories) | `--add-dir` または `/add-dir` の順序で先に追加したディレクトリのスキル。もう一方は[プレフィックス付きの名前](#run-a-same-named-skill-from-an-added-directory)で実行されます |
| プラグインスキルと上記いずれかの場所のスキル | プラグインスキルは `/plugin-name:skill-name` として名前空間が分けられるため、両方とも読み込まれます |
| 上記のいずれかと、[claude.ai アカウントから同期された](#how-synced-skills-behave)スキルの短い名前 | もう一方のスキルまたはコマンド。同期スキルはその場合、完全な名前でのみ一覧表示・実行されます。[同期スキルの名前が別のコマンドと一致する場合](#when-a-synced-skill-name-matches-another-command)を参照してください |

### Cowork とクラウドセッションでスキルを使う

[Cowork](https://claude.com/product/cowork) セッションと、[クラウドスケジュールタスク](https://code.claude.com/docs/ja/routines.md)を含む[クラウドセッション](https://code.claude.com/docs/ja/cloud-environments.md#what-carries-over-from-your-setup)は、マシン上の `~/.claude/skills/` を読み込みません。対話型とスケジュール型のどちらの Cowork セッションも、セッション開始時に同期された、claude.ai アカウントで有効なスキルを読み込みます。これらは Desktop アプリのサイドバーの **Customize** から、または claude.ai のスキル設定から管理します。

スキルがマシン上の `~/.claude/skills/` にしか存在しない場合、[クラウドスケジュールタスク](https://code.claude.com/docs/ja/routines.md)がそれを呼び出すと、Claude Code はスキルが見つからないと報告します。これは、各実行が新しいクラウドセッションとして開始されるためです。個人のスキルをこれらのセッションで利用できるようにするには、次のようにします。

* Cowork セッション、クラウドセッション、および[プロジェクト](https://code.claude.com/docs/ja/claude-projects.md#what-threads-pick-up-from-your-repositories)内のクラウドスレッドでは、claude.ai アカウントでスキルを有効にします。プロジェクトのクラウドスレッドでは、リポジトリの `.claude/skills/` にコミットされたスキルは利用できません。[セルフホスト環境の一部のセッション](https://code.claude.com/docs/ja/self-hosted-environments-configuration.md#how-each-session’s-config-is-assembled)は、アカウントのスキルを読み込みません。
* プロジェクトスレッド以外のクラウドセッションでは、代わりにスキルをリポジトリの `.claude/skills/` にコミットすることもできます。リポジトリの `.claude/settings.json` で宣言されたプラグインや、ユーザー設定でのみ有効にしたプラグインは、[クラウドセッションでは読み込まれません](https://code.claude.com/docs/ja/cloud-environments.md#what-carries-over-from-your-setup)。

[Desktop スケジュールタスク](https://code.claude.com/docs/ja/desktop-scheduled-tasks.md)はマシン上でローカルに実行されるため、`~/.claude/skills/` を読み込みます。

### claude.ai から同期されたスキル

このセクションは、Cowork やクラウドセッションを使用している場合、またはターミナルで claude.ai アカウントを使って Claude Code にサインインしている場合に該当します。これらのセッションでは、[同期スキルの読み込み場所](#where-synced-skills-load)で説明しているとおり、ユーザー側での設定なしに、Claude Code が claude.ai アカウントで有効なスキルを読み込みます。これらのスキルには、claude.ai の設定で作成またはオンにしたもの、組織がそこで提供するスキル、`pdf` や `xlsx` などの Anthropic の組み込みスキルが含まれます。

Claude Code は、セッションが実行されるマシン上でユーザーが作成したファイルを読み込むのではなく、アカウントから同期スキルをダウンロードします。そのため、[スキルの保存場所](#where-skills-live)に保存したスキルには適用されないルールを、同期スキルには適用します。

#### 同期スキルの読み込み場所

Cowork またはクラウドセッションでは、Claude Code は claude.ai アカウントで有効なスキルを読み込みます。これらのセッションがどのスキルを取得するかの選び方は、[Cowork とクラウドセッションでのスキル](#skills-in-cowork-and-cloud-sessions)で説明しています。

ターミナルでは、Claude Code は claude.ai アカウントでサインインしたセッションでこれらのスキルを同期します。セッション開始時に、Claude Code はアカウントのスキルをバックグラウンドで `~/.claude/skills/synced/` にダウンロードし、その後セッション実行中に claude.ai の変更を確認します。確認によって claude.ai でスキルが追加、編集、またはオフにされたことが分かると、Claude Code は再起動なしで、実行中のセッションでそれを追加、更新、または削除します。ターミナルセッションでの同期には Claude Code v2.1.273 以降が必要です。

セッションがアイドル状態の間は、確認の頻度が下がります。

* **ユーザーまたは Claude がセッションで作業している間**：約 10 分ごとに確認が実行されます。
* **セッションがアイドル状態の間**：約 40 分ごとに確認が実行されます。セッションで再び入力したとき、前回の確認から 10 分以上経過していれば、Claude Code は数分以内に確認します。

Claude はスキルを呼び出すときにのみそのスキルのダウンロードを待つため、同期によって起動が遅れることはありません。そのため、短い[非対話型](https://code.claude.com/docs/ja/headless.md)の実行は、新しく追加されたスキルのダウンロード前に終了することがあり、その場合は後のセッションでダウンロードされます。非対話型の実行でスキルをダウンロードし、プロンプトに応答する前に一覧を待つようにするには、[`CLAUDE_CODE_SYNC_SKILLS`](https://code.claude.com/docs/ja/env-vars#variables) を `1` に設定します。v2.1.273 より前は、ターミナルセッションでスキルがダウンロードされるのは、この変数を設定した `-p` 実行の場合のみでした。

Claude Code が同期するのは、claude.ai アカウントでサインインし、かつ [Anthropic から機能フラグを取得する](https://code.claude.com/docs/ja/env-vars.md#features-that-need-feature-flag-fetching)セッションのみです。次のセッションでは同期しません。

* `/login` で保存されたサインインを使用しないセッション。たとえば、API キーで認証するセッションや、`ANTHROPIC_AUTH_TOKEN`、`CLAUDE_CODE_OAUTH_TOKEN`、または `apiKeyHelper` スクリプトが認証情報を提供するセッション
* 機能フラグを取得しないセッション。たとえば、Amazon Bedrock 上のセッションや、`CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC` を設定したセッション
* [bare モード](https://code.claude.com/docs/ja/headless.md#start-faster-with-bare-mode)のセッション、または `--safe-mode` で開始したセッション
* 組織の管理設定が[スキルをプラグインソースに限定](https://code.claude.com/docs/ja/settings-reference.md#strictpluginonlycustomization-skills)しているセッション、または `user` を含まない [`--setting-sources`](https://code.claude.com/docs/ja/cli-reference#cli-flags) リストで開始したセッション

セッション中に `/login` でサインインした場合は、同期を開始するために Claude Code を再起動してください。

以前のセッションで同期したスキルはディスク上に残ります。Claude Code は、claude.ai に接続できない場合でも、同じアカウントでサインインした後のセッションでそれらを読み込みます。

Claude Code は同期スキルをダウンロードするだけで、アップロードすることはありません。ユーザーまたは Claude が `~/.claude/skills/synced/` 配下のファイルを編集しても、その変更は claude.ai アカウントには保存されず、後の同期で上書きまたは削除される可能性があります。同期スキルを変更するには、claude.ai で更新してください。次回の同期で新しいバージョンがダウンロードされます。

どのスキルが同期されたかを確認するには、`/skills` を実行します。メニューでは `claude.ai sync` の下に一覧表示されます。

`pdf` や `xlsx` など、Anthropic のスキルの一部は常に同期されます。それ以外のスキルは、claude.ai のスキル設定でオン・オフを切り替えることで、同期するかどうかを変更できます。

マシンでの同期を停止するには、ユーザー設定で [`syncClaudeAiSkills`](https://code.claude.com/docs/ja/settings-reference#syncclaudeaiskills) を `false` に設定します。Claude Code はダウンロードを停止し、次回起動時に、すでに同期したスキルを `~/.claude/skills/.trash/` に移動して読み込まなくなります。組織は、claude.ai で Skills をオフにすることで、全員の同期をオフにできます。Skills をオンにしたまま同期を停止するには、[管理設定](https://code.claude.com/docs/ja/managed-settings.md)で同じキーを設定できます。

組織が claude.ai で Skills をオフにすると、Claude Code はダウンロード済みのスキルを削除し、それらは読み込まれなくなります。削除されたスキルは `~/.claude/skills/.trash/` に移動され、[保持期間によるクリーンアップ](https://code.claude.com/docs/ja/claude-directory.md#cleaned-up-automatically)で削除されるまではファイルを復元できます。組織が Skills を再びオンにすると、Claude Code は次回の同期で、ユーザーが有効にしたスキルをダウンロードします。

#### 同期スキルの名前が別のコマンドと一致する場合

同期スキルは、短い名前 `/<name>` でも、完全な名前 `/anthropic-skills:<name>` でも呼び出せます。別のコマンドが短い名前を使用している場合、`/<name>` はその別のコマンドを実行し、同期スキルは `/anthropic-skills:<name>` としてのみ実行されます。ローカルの `deploy` スキルと同期された `deploy` がある場合、`/deploy` はローカルのスキルを実行し、`/anthropic-skills:deploy` は同期されたものを実行します。v2.1.269 より前は、同期スキルには短い名前しかありませんでした。

`/` メニュー、`/skills`、`/context` では、同期スキルは短い名前で表示されますが、別のコマンドが短い名前を使用している間は完全な名前で表示されます。セッションで `/skills` を実行してください。一覧の下の注記で、短い名前を失った各同期スキルについて説明されます。`~/.claude/` 内の個人スキルやコマンドファイルのいずれかがその名前を使用している場合、その名前を解放するために何の名前を変更または削除すればよいかも注記に示されます。

v2.1.269 から v2.1.280 までは、これらの一覧ではすべての同期スキルが完全な名前で表示され、`/skills` にはこのような注記がありませんでした。どちらも v2.1.281 で変更されました。

短い名前を使用するコマンドは、次のいずれかです。

* 組み込みコマンドまたは[バンドルスキル](#bundled-skills)。バンドルスキルをオフにした後など、セッションで利用できないものも含みます
* いずれかの[ローカルレベル](#where-skills-live)のスキル、または `.claude/commands/` 内のファイル
* プラグインスキル
* [MCP プロンプト](https://code.claude.com/docs/ja/mcp.md#use-mcp-prompts-as-commands)

Claude Code は、由来が分かるように同期スキルにラベルを付けます。`/skills` メニューと `/context` は同期スキルを `claude.ai sync` の下にグループ化し、`/` コマンドメニューは claude.ai 由来であることを示します。

名前を比較する際、Claude Code は大文字・小文字、スペース、不可視文字を無視し、全角文字やダッシュのバリアントなどの互換形式を、対応する通常の文字として扱います。たとえば、`Commit` という名前の同期スキルと `commit` という名前のローカルスキルは同じ名前とみなされるため、`/commit` は引き続きローカルスキルを実行します。

別のアルファベットの似た文字だけが異なる名前は別の名前とみなされ、`claude.ai sync` ラベルによって両者を区別できます。これらのチェックとラベルには Claude Code v2.1.228 以降が必要です。

#### 同期スキル用に予約された名前

Claude Code は、`anthropic-skills` という名前と、`anthropic-skills:pdf` のようなその名前空間内のすべての名前を claude.ai から同期されたスキル用に予約しているため、同期スキルの完全な名前が他のものを実行することはありません。この名前は、claude.ai アカウントでサインインしているかどうかにかかわらず、すべてのセッションで予約されています。

* **スキルフォルダ、フロントマターの `name`、`.claude/commands/` 内のファイルやサブフォルダ、または[保存されたワークフロー](https://code.claude.com/docs/ja/workflows.md#save-the-workflow-for-reuse)**：読み込まれません。[起動時の通知](https://code.claude.com/docs/ja/errors.md#a-skill-command-or-workflow-wasnt-loaded-because-its-name-is-reserved)で、名前の変更または編集が必要な最初の項目が示されます。
* **`anthropic-skills` という名前のプラグイン**：読み込まれます。そのスキルの 1 つと同期スキルの両方が `<name>` という名前の場合、`/anthropic-skills:<name>` は同期スキルを実行します。
* **`anthropic-skills` という名前の MCP サーバー**：接続され、ツールも動作しますが、[そのプロンプトはコマンドとして表示されません](https://code.claude.com/docs/ja/mcp.md#use-mcp-prompts-as-commands)。一覧に表示するには、MCP 設定でサーバー名を変更してください。

#### Claude Code が同期スキルのフロントマターを扱う方法

Claude Code は、同期スキルのフロントマターに 2 つのルールを適用します。

* フロントマターはあらゆる種類のセッションで適用されるため、`allowed-tools` による許可は通常の[権限フロー](https://code.claude.com/docs/ja/permissions.md)を経由します。組織が `allowManagedPermissionRulesOnly` を設定している場合、その許可は[適用されません](#when-only-managed-permission-rules-apply)。
* Claude Code は、説明など、スキルが提供する表示テキストをサニタイズします。制御文字を削除し、説明など Claude に届くテキストでは、テキストが Claude Code の内部フォーマットを模倣できないように、山括弧もエスケープします。このサニタイズには Claude Code v2.1.228 以降が必要です。

#### Claude Code が同期スキルの本文を扱う方法

Claude Code が同期スキルの本文をどう扱うかは、セッションの実行場所によって異なります。

* クラウドセッションでは、セッションが隔離されたコンテナで実行されるため、本文はローカルスキルと同じ動作を保ちます。
* デスクトップ上の Cowork セッションでは、本文はローカルスキルと同じ動作を保ちます。ただし、そこで提供するすべてのスキルと同様に、Claude Code はすべての `!` コマンド行を [`disableSkillShellExecution` のプレースホルダー](#inject-dynamic-context)に置き換えます。
* マシン上のその他のセッションでは、Claude Code は [`!` コマンド](#inject-dynamic-context)を実行せず、ローカルスキルの場合のように `@` 参照が指すファイルを添付せず、`${CLAUDE_PROJECT_DIR}` と `${CLAUDE_SESSION_ID}` のプレースホルダーも置換しません。そのため、`@` 参照と両方のプレースホルダーはリテラルテキストとして Claude に届きます。`!` コマンド行もリテラルテキストとして、または `disableSkillShellExecution` がオンの場合はそのプレースホルダーとして Claude に届きます。この扱いには Claude Code v2.1.228 以降が必要です。

### セッション中にスキルを編集する

Claude Code は、[bare モード](https://code.claude.com/docs/ja/headless.md#start-faster-with-bare-mode)の場合を除き、スキルディレクトリのファイル変更を監視します。`~/.claude/skills/`、プロジェクトの `.claude/skills/`、または `--add-dir` ディレクトリ内の `.claude/skills/` でスキルを追加、編集、削除すると、Claude Code は再起動なしで、現在のセッション内で変更を反映します。

セッション開始時に存在しなかったトップレベルのスキルディレクトリを作成した場合は、[`/reload-skills`](https://code.claude.com/docs/ja/commands#all-commands) を実行して、そこに置いたスキルを読み込みます。Claude Code はまだそのディレクトリを監視していないため、その後そこで変更するたびに `/reload-skills` を再度実行してください。

ライブ変更検出の対象は `SKILL.md` のテキストのみです。[プラグイン](https://code.claude.com/docs/ja/plugins/loading.md#plugins-shared-through-a-repository)でもあるスキルフォルダでは、`hooks/`、`.mcp.json`、`agents/`、`output-styles/` の変更を反映するには `/reload-plugins` が必要です。

### スキルを削除する

スキルの削除方法は、その由来によって異なります。

* **個人またはプロジェクトのスキル**：スキルのディレクトリ `~/.claude/skills/<skill-name>/` または `.claude/skills/<skill-name>/` を削除します。Claude Code は[現在のセッションで `/skills` からそれを除外します](#live-change-detection)。Claude Code がすでにそこから読み込んだ内容は、[スキルコンテンツのライフサイクル](#skill-content-lifecycle)に従います。
* **エンタープライズスキル**：管理者が、[管理設定ディレクトリ](https://code.claude.com/docs/ja/managed-settings.md#delivery-mechanisms)内の `.claude/skills/` からスキルのディレクトリを削除します。たとえば Linux では `/etc/claude-code/.claude/skills/<skill-name>/` です。
* **プラグインスキル**：`/plugin` メニューから、または `/plugin uninstall <plugin-name>@<marketplace-name>` で、そのスキルを提供するプラグインを無効化またはアンインストールします。Claude Code は、[変更が適用された](https://code.claude.com/docs/ja/plugins/cli-reference.md#reload-plugins)とき、または再起動したときに、プラグインのスキルをアンロードします。
* **claude.ai から同期されたスキル**：[有効にした](#skills-in-cowork-and-cloud-sessions)のと同じ場所で、claude.ai アカウントのスキルをオフにします。Claude Code は、次回[スキルを同期する](#where-synced-skills-load)ときに、`~/.claude/skills/synced/` からそれを削除します。代わりにディレクトリを手動で削除した場合、claude.ai でスキルが有効なままであれば、次回の同期で再びダウンロードされます。
* **バンドルスキル**：[`disableBundledSkills`](#bundled-skills) を `true` に設定するとバンドルスキルがオフになります。また、[`skillOverrides`](#override-skill-visibility-from-settings) で特定のスキルを `"off"` に設定すると、そのスキルを非表示にできます。

個人またはプロジェクトのスキルを残したまま、Claude が自らそれを呼び出さないようにするには、フロントマターで [`disable-model-invocation: true`](#control-who-invokes-a-skill) を設定します。ファイルを編集したくない場合は、[`skillOverrides`](#override-skill-visibility-from-settings) で `"user-invocable-only"` を設定します。

## スキルを設定する

スキルは、`SKILL.md` の先頭にある YAML フロントマターと、それに続く markdown コンテンツによって設定します。

### スキルコンテンツの種類

スキルファイルにはどのような指示でも記述できますが、スキルをどのように呼び出したいかを考えると、何を含めるべきかの指針になります。

**参照コンテンツ**は、Claude が現在の作業に適用する知識を追加します。規約、パターン、スタイルガイド、ドメイン知識などです。このコンテンツはインラインで実行されるため、Claude は会話のコンテキストと併せてこれを利用できます。

```yaml theme={null}
---
name: api-conventions
description: API design patterns for this codebase
---

When writing API endpoints:
- Use RESTful naming conventions
- Return consistent error formats
- Include request validation
```

**タスクコンテンツ**は、デプロイ、コミット、コード生成など、特定のアクションについての手順を Claude に与えます。これらは多くの場合、Claude に実行タイミングを判断させるのではなく、`/skill-name` で直接呼び出したいアクションです。Claude が自動的にトリガーしないようにするには、`disable-model-invocation: true` を追加します。以下の例では `context: fork` を追加しており、これによりスキルは独自のサブエージェントコンテキストで実行されます。[サブエージェントでスキルを実行する](#run-skills-in-a-subagent)を参照してください。

```yaml theme={null}
---
name: deploy
description: Deploy the application to production
context: fork
disable-model-invocation: true
---

Deploy the application:
1. Run the test suite
2. Build the application
3. Push to the deployment target
```

本文自体は簡潔にしてください。スキルが読み込まれると、そのコンテンツは[ターンをまたいでコンテキストに残る](#skill-content-lifecycle)ため、すべての行が繰り返し発生するトークンコストになります。どのように、またはなぜ行うかを説明するのではなく、何をすべきかを記述し、[CLAUDE.md のコンテンツ](https://code.claude.com/docs/ja/best-practices.md#keep-claude-md-short)と同じ簡潔さの基準を適用してください。

### フロントマターリファレンス

スキルは、`SKILL.md` の先頭にある `---` マーカーで囲まれた YAML [フロントマター](https://code.claude.com/docs/ja/glossary.md#frontmatter)で設定し、スキルの指示は閉じの `---` の後に Markdown で記述します。フィールド名は、`when_to_use` を除き、ハイフンで区切られた小文字の単語を使用します。`.claude/commands/` 内の[コマンドファイル](#where-skills-live)は、`name` と `paths` を除いて同じフィールドを受け付けます。この例では 4 つのフィールドを設定しています。

```yaml theme={null}
---
name: my-skill
description: What this skill does
disable-model-invocation: true
allowed-tools: Read Grep
---

Your skill instructions here...
```

すべてのフィールドは省略可能です。Claude がスキルを使用するタイミングを判断できるよう、`description` のみ推奨されます。フィールド名はハイフンを含めて表と完全に一致する必要があります。Claude Code は認識できないフィールドをエラーを報告せずに無視します。

Claude Code がフロントマターを読み取るのは、開始の `---` がファイルの最初の行である場合のみです。それ以外の場合は、`---` マーカーを含むファイル全体をスキルコンテンツとして扱います。マーカー間の YAML が解析できない場合でも、スキルはフィールドが何も設定されていない状態で読み込まれます。エラーを見つけて修正するには、[スキルがトリガーされない](#skill-not-triggering)を参照してください。

真偽値のフィールドは、`true` と `false` に加えて、大文字小文字を問わず `yes`、`no`、`on`、`off`、`1`、`0` を受け付けます。v2.1.218 より前は、Claude Code は `true` と `false` のみを認識していました。

| フィールド | 必須 | 説明 |
| :- | :- | :- |
| `name` | いいえ | `/` メニューに表示されるコマンド名。デフォルトはディレクトリ名です。このフィールドと、スキルを呼び出すために入力する名前との関係については、[スキルのコマンド名の決まり方](#how-a-skill-gets-its-command-name)を参照してください。 |
| `description` | 推奨 | スキルが何をするか、いつ使用するか。Claude はこれを使ってスキルを適用するタイミングを判断します。省略した場合は、markdown コンテンツの最初の空でない行が使用されます。主要なユースケースを先頭に記述してください。コンテキストの使用量を減らすため、スキル一覧では `description` と `when_to_use` を合わせたテキストが 1,536 文字で切り詰められます。 |
| `when_to_use` | いいえ | トリガーとなるフレーズやリクエストの例など、Claude がスキルを呼び出すべきタイミングについての追加のコンテキスト。スキル一覧で `description` に追加され、1,536 文字の上限に含まれます。 |
| `argument-hint` | いいえ | 想定される引数を示すためにオートコンプリート中に表示されるヒント。例：`[issue-number]` または `[filename] [format]`。 |
| `arguments` | いいえ | スキルコンテンツでの [`$name` 置換](#available-string-substitutions)に使う名前付き位置引数。スペース区切りの文字列または YAML リストを受け付けます。名前は順番に引数の位置に対応付けられます。 |
| `disable-model-invocation` | いいえ | `true` に設定すると、Claude がこのスキルを自動的に読み込まなくなります。`/name` で手動でトリガーしたいワークフローに使用します。また、スキルが[サブエージェントにプリロード](https://code.claude.com/docs/ja/sub-agents.md#preload-skills-into-subagents)されることや、このスキルをプロンプトとする[セッションスコープのスケジュールタスク](https://code.claude.com/docs/ja/scheduled-tasks.md)が起動したときに実行されることも防ぎます。デフォルト：`false`。 |
| `user-invocable` | いいえ | Claude だけがスキルを呼び出すべき場合は `false` に設定します。Claude Code は `/` メニューからスキルを非表示にし、`/name` と入力しても実行しません。ユーザーが直接呼び出すべきではない背景知識に使用します。デフォルト：`true`。 |
| `allowed-tools` | いいえ | このスキルを呼び出したターンの間、Claude が権限を求めずに使用できるツール。この付与は次のメッセージを送信するとクリアされます。スペース区切りまたはカンマ区切りの文字列、あるいは YAML リストを受け付けます。[スキルのツールを事前承認する](#pre-approve-tools-for-a-skill)を参照してください。 |
| `disallowed-tools` | いいえ | このスキルがアクティブな間、Claude が使用可能なツールから除外されるツール。バックグラウンドループにおける `AskUserQuestion` など、特定のツールを決して呼び出すべきではない自律型スキルに使用します。スペース区切りまたはカンマ区切りの文字列、あるいは YAML リストを受け付けます。この制限は次のメッセージを送信するとクリアされます。拒否ルールと同様に、他のツールが残っている間はこのフィールドで [`EndConversation`](https://code.claude.com/docs/ja/tools-reference#endconversation-tool-behavior) を除外することはできません。 |
| `model` | いいえ | このスキルがアクティブなときに使用するモデル。この上書きは現在のターンの残りの間に適用され、設定には保存されません。次のプロンプトを送信すると、セッションのモデルに戻ります。[`/model`](https://code.claude.com/docs/ja/model-config) と同じ値、またはアクティブなモデルを維持する `inherit` を受け付けます。組織の [`availableModels`](https://code.claude.com/docs/ja/model-config#restrict-model-selection) 許可リストで除外されている値は使用されず、セッションは現在のモデルを維持します。[auto モード](https://code.claude.com/docs/ja/permission-modes.md#eliminate-prompts-with-auto-mode)、および[分類器がコマンドをレビューしている間の plan モード](https://code.claude.com/docs/ja/permission-modes.md#analyze-before-you-edit-with-plan-mode)では、auto モードがサポートしていないモデルも使用されず、セッションは現在のモデルを維持します。`context: fork` の場合、この値は代わりに[フォークされたサブエージェントのモデル](#run-skills-in-a-subagent)を設定し、除外された値は[サブエージェントのモデル上書きと同じルール](https://code.claude.com/docs/ja/model-config.md#restrict-model-selection)に従います。 |
| `effort` | いいえ | このスキルがアクティブなときの [effort レベル](https://code.claude.com/docs/ja/model-config.md#adjust-effort-level)。セッションの effort レベルを上書きします。省略した場合、レベルは [effort の解決順序](https://code.claude.com/docs/ja/model-config.md#adjust-effort-level)によって決まります。オプション：`low`、`medium`、`high`、`xhigh`、`max`。使用可能なレベルはモデルによって異なります。 |
| `context` | いいえ | `fork` に設定すると、フォークされたサブエージェントコンテキストで実行されます。[サブエージェントでスキルを実行する](#run-skills-in-a-subagent)を参照してください。 |
| `agent` | いいえ | `context: fork` が設定されている場合に使用するサブエージェントの種類。 |
| `background` | いいえ | `context: fork` の場合にのみ適用されます。`false` に設定すると、[バックグラウンドで実行する](#run-skills-in-a-subagent)代わりに、スキルを呼び出したターンでフォークされたサブエージェントの結果を待ちます。デフォルト：`true`。Claude Code v2.1.218 以降が必要です。 |
| `hooks` | いいえ | スキルが呼び出されたときに Claude Code が登録し、セッションの残りの間実行し続けるフック。設定形式、`once` オプション、および[スキルフックの制限](https://code.claude.com/docs/ja/hooks.md#limits-on-skill-hooks)については、[スキルとエージェントのフック](https://code.claude.com/docs/ja/hooks.md#hooks-in-skills-and-agents)を参照してください。 |
| `paths` | いいえ | このスキルがアクティブになるタイミングを制限する glob パターン。カンマ区切りの文字列または YAML リストを受け付けます。設定すると、Claude はパターンに一致するファイルを扱っている場合にのみスキルを自動的に読み込みます。パターンは Claude の現在の作業ディレクトリからの相対パスであり、そのディレクトリ外のファイルは一致しません。[パス固有のルール](https://code.claude.com/docs/ja/memory.md#path-specific-rules)と同じ glob 形式を使用します。 |
| `shell` | いいえ | このスキル内の `` !`command` `` および ` ```! ` ブロックに使用するシェル。`bash`（デフォルト）または `powershell` を受け付けます。`powershell` を設定すると、[PowerShell ツール](https://code.claude.com/docs/ja/tools-reference.md#powershell-tool)が有効な場合にインラインのシェルコマンドが PowerShell 経由で実行されます。このツールは、Git Bash のない Windows ではデフォルトでオン、Git Bash のある環境では claude.ai および Console アカウントでデフォルトでオンであり、Amazon Bedrock、Google Cloud の Agent Platform、Microsoft Foundry のセッション、および macOS、Linux、WSL では `CLAUDE_CODE_USE_POWERSHELL_TOOL=1` が必要です。ツールをオフにするには `0` に設定します。 |
| `metadata` | いいえ | エンタイトルメントやカタログのフィールドなど、独自のツールが `SKILL.md` から読み取る独自のキーと値のデータのための自由形式の YAML マップ。Claude Code はその内容に基づいて動作せず、マップではない値は破棄します。`paths` などのフロントマターのフィールド名をキーとして再利用しないでください。 |
| `license` | いいえ | スキルに適用されるライセンス。[Agent Skills](https://agentskills.io) 仕様の一部です。[Claude Code 以外でスキルのフロントマターを使用する](#using-skill-frontmatter-outside-claude-code)を参照してください。Claude Code はこのフィールドを受け付けますが、それに基づいて動作はしません。 |
| `compatibility` | いいえ | [Agent Skills](https://agentskills.io) 仕様で定義されている、想定される製品やシステムの前提条件などのスキルの環境要件。[Claude Code 以外でスキルのフロントマターを使用する](#using-skill-frontmatter-outside-claude-code)を参照してください。最大 500 文字の文字列を受け付けます。Claude Code はこのフィールドを受け付けますが、それに基づいて動作はしません。 |

#### Claude Code 以外でスキルのフロントマターを使用する

Claude Code は上の表のすべてのフィールドを受け付けます。Claude Code 以外では、[Agent Skills](https://agentskills.io) 仕様に含まれるフィールドのみを使用できます。

| 配布経路 | 使用できるフロントマターのフィールド |
| :- | :- |
| [プラグイン](https://code.claude.com/docs/ja/plugins/overview.md)スキルを含む、[あらゆるレベル](#where-skills-live)の Claude Code スキル | 上の表のすべてのフィールド |
| claude.ai へのスキルのアップロード、Skills API、および [anthropics/skills](https://github.com/anthropics/skills) の `package_skill.py` によるパッケージ化 | `name`、`description`、`license`、`compatibility`、`metadata`、`allowed-tools` |

たとえば [Cowork とクラウドセッション](#skills-in-cowork-and-cloud-sessions)やスケジュールタスクで使用するために claude.ai アカウントで個人スキルを有効にすると、そのスキルは claude.ai にアップロードされます。このアップロードにも同じルールが適用されます。

仕様で許可されていないフィールドを含めると、パッケージ化やアップロードはそのフィールドを無視するのではなく、致命的なエラーで失敗します。

```
Unexpected key(s) in SKILL.md frontmatter: argument-hint. Allowed properties are: allowed-tools, compatibility, description, license, metadata, name
```

フロントマターを仕様の 6 つのフィールドに限定すれば、上記の予期しないキーのエラーを回避できます。これらの経路で検証されるその他すべての項目は、[Agent Skills 仕様](https://agentskills.io)と [Skills API の要件](https://docs.claude.com/en/api/skills-guide)で定義されています。[動的コンテキストの挿入](#inject-dynamic-context)など、Claude Code 専用の本文機能は、claude.ai のチャットや API 経由では機能しません。Claude Code は 6 つのフィールドすべてを受け付けるため、仕様に従ったフロントマターは変更なしで Claude Code に読み込まれます。

#### スキルのコマンド名の決まり方

スキルを呼び出すために入力するコマンドは、スキルファイルの配置場所と、スキルディレクトリおよびプラグインスキルの場合はフロントマターの `name` フィールドによって決まります。個人またはプロジェクトのスキルディレクトリでは、別のコマンドがすでにその名前を使用していない限り、`name` によって `/` メニューに表示され、入力するコマンドが設定されます。ディレクトリ名でもスキルを呼び出せます。プラグインスキルでは、`name` はコマンドの最後のセグメントを設定し、プラグインのプレフィックスはそのまま残ります。

以下の表は、各レイアウトでコマンド名がどこから決まるかを示しています。

| スキルの場所 | コマンド名の由来 | 例 |
| :- | :- | :- |
| `~/.claude/skills/` または `.claude/skills/` 配下のスキルディレクトリ | フロントマターの `name` またはディレクトリ名 | `.claude/skills/deploy-staging/SKILL.md` → `/deploy-staging`、または `name: deploy` の場合は `/deploy` |
| [ネストされた](#where-skills-live) `.claude/skills/` ディレクトリで、ディレクトリ名が別のスキルと衝突する場合 | 作業ディレクトリからの相対サブディレクトリパス、その後にスキルディレクトリ名 | `apps/web/.claude/skills/deploy/SKILL.md` → `/apps/web:deploy` |
| [プロジェクト外の追加ディレクトリ](#skills-from-additional-directories)内の `.claude/skills/` で、スキルディレクトリ名がエンタープライズ、個人、またはプロジェクトのスキル、あるいはそれより前に追加されたディレクトリ内のスキルと衝突する場合 | 追加ディレクトリのフォルダー名、その後にスキルディレクトリ名。2 つの追加ディレクトリが同じフォルダー名を持つ場合、プレフィックスは親フォルダーの名前から始まります。v2.1.309 以降が必要 | `--add-dir ../cli` を指定した場合の `../cli/.claude/skills/verify/SKILL.md` → `/cli:verify`。`--add-dir ../a/cli --add-dir ../b/cli` を指定し、それぞれに `verify` スキルがあり、他の場所にはない場合、`../a/cli` 内のもの → `/verify`、もう一方 → `/b/cli:verify` |
| `.claude/commands/` 配下のファイル | 拡張子を除いたファイル名 | `.claude/commands/deploy.md` → `/deploy` |
| `.claude/commands/` のサブディレクトリ内のファイル | `commands/` からの相対サブディレクトリパス（各 `/` を `:` に置換）、その後に拡張子を除いたファイル名 | `.claude/commands/frontend/component.md` → `/frontend:component` |
| プラグインの `skills/` サブディレクトリ | フロントマターの `name` またはディレクトリ名（プラグインで名前空間化） | `my-plugin/skills/review/SKILL.md` → `/my-plugin:review`、または `name: fancy` の場合は `/my-plugin:fancy` |
| プラグインルートの `SKILL.md` | フロントマターの `name`（フォールバックとしてプラグインのディレクトリ名） | `name: review` を持つ `my-plugin/SKILL.md` → `/my-plugin:review`。[プラグインルートの単一スキル](https://code.claude.com/docs/ja/plugins/components.md#skills)を参照 |
| [claude.ai から同期された](#how-synced-skills-behave)スキル | claude.ai アカウント上のスキル名に `anthropic-skills:` のプレフィックスを付けたもの | アカウントのスキル `deploy` → `/anthropic-skills:deploy`、または他のコマンドがその名前を使用していない間は `/deploy` |

プラグインスキルでは、フロントマターの `name` がコマンドの最後のセグメントにあるディレクトリ名を置き換えるため、`name: fancy` を持つ `my-plugin/skills/review/SKILL.md` は `/my-plugin:fancy` になります。別のコマンドがすでにその名前を使用していない限り、プレフィックスなしの `/fancy` でもスキルを呼び出せます。記述した `name` がすでにプラグイン自身のプレフィックスで始まっている場合、v2.1.246 以降の Claude Code はプレフィックスを再度追加しません。たとえば、`name: my-plugin:fancy` は `/my-plugin:fancy` のままになります。v2.1.216 から v2.1.245 までは、`name` がすでにプレフィックスを含んでいる場合、Claude Code はプレフィックスを二重に付けていました。

[非対話型セッション](https://code.claude.com/docs/ja/headless.md)では、`help` と `feedback` という名前はターミナル専用の組み込みコマンドのために予約されていないため、これらのいずれかの名前を持つプラグインスキルはそこでプレフィックスなしのコマンドを維持します。`/login` など、その他のターミナル専用の組み込みコマンドの名前は、それらのセッションではコマンドを実行できないにもかかわらず予約されたままです。

プラグインルートの `SKILL.md` の場合、名前の取得元となるスキルディレクトリがないため、`name` が最後のセグメント全体を提供します。`name` フィールドがない場合、Claude Code はプラグインのディレクトリ名にフォールバックします。

#### スキル名に使用できない文字

スキルやカスタムコマンドが `/` メニューに表示されない場合、またはメニューにスキルのフロントマターの `name` が表示されない場合は、名前を確認してください。Claude Code は、次のような文字を含むコマンド名やフロントマターの `name` を拒否します。

* ゼロ幅スペースまたは制御文字
* アイコンフォントのグリフなど、私用領域の文字または未割り当ての文字
* 周囲のテキストの方向を変更する文字
* 単語間の半角スペース 1 つ以外の空白（ノーブレークスペース、連続する 2 つのスペース、先頭または末尾のスペースなど）
* `<` または `>`

Claude Code がディレクトリ名またはファイル名を拒否した場合、そのカスタムコマンドやスキルは読み込まれません。これらの文字を取り除くように、そのフォルダーまたはファイルの名前を変更してください。これらの文字がプラグインスキルのフォルダー名またはそのフロントマターの `name` にのみ含まれている場合、スキルは引き続き読み込まれます。

* **プラグインの `skills/` ディレクトリまたはマニフェストの [`skills` パス](https://code.claude.com/docs/ja/plugins/components#skills)内のフォルダー**：フォルダー名を変更する必要はありません。これらの文字はスキルのコマンド名でハイフンになるため、ハイフンを使ってコマンドを入力してください。
* **フロントマターの `name`**：`/` メニューには `name` の値が表示されず、それを入力してもスキルは呼び出されません。`name:` の行を編集して文字を取り除いてください。

Claude Code がどの名前を拒否したかを確認するには、シェルから [`claude --debug`](https://code.claude.com/docs/ja/cli-reference#cli-flags) で起動し、[デバッグログ](https://code.claude.com/docs/ja/debug-your-config.md)で `[names]` を検索します。対話型セッションでは、[起動時の通知](https://code.claude.com/docs/ja/errors.md#skill-or-command-name-refused)でも名前が拒否されたことが通知されます。名前の変更や `name:` の編集を行った後は、ファイルが Claude Code が[変更を監視している](#live-change-detection)ディレクトリにある場合を除き、セッションを再起動してください。

#### 利用可能な文字列置換

スキルは、スキルコンテンツ内の動的な値に対する文字列置換をサポートしています。

| 変数 | 説明 |
| :- | :- |
| `$ARGUMENTS` | スキルを呼び出す際に渡されたすべての引数。どのプレースホルダーも引数を受け取らない場合、Claude Code は引数を `ARGUMENTS: <value>` として末尾に追加します。[スキルに引数を渡す](#pass-arguments-to-skills)を参照してください。 |
| `$ARGUMENTS[N]` | 0 始まりのインデックスで特定の引数にアクセスします（最初の引数なら `$ARGUMENTS[0]`）。 |
| `$N` | `$ARGUMENTS[N]` の短縮形です（最初の引数なら `$0`、2 番目の引数なら `$1`）。 |
| `$name` | [`arguments`](#frontmatter-reference) フロントマターのリストで宣言された名前付き引数。名前は順番に位置に対応付けられるため、`arguments: [issue, branch]` の場合、プレースホルダー `$issue` は最初の引数に、`$branch` は 2 番目の引数に展開されます。 |
| `${CLAUDE_SESSION_ID}` | 現在のセッション ID。ログへの記録、セッション固有のファイルの作成、スキルの出力とセッションの関連付けに便利です。 |
| `${CLAUDE_EFFORT}` | 現在の effort レベル：`low`、`medium`、`high`、`xhigh`、または `max`。アクティブな effort 設定にスキルの指示を適応させるために使用します。 |
| `${CLAUDE_SKILL_DIR}` | スキルの `SKILL.md` ファイルを含むディレクトリ。プラグインスキルの場合、これはプラグインルートではなく、プラグイン内のスキルのサブディレクトリです。現在の作業ディレクトリに関係なく、スキルにバンドルされたスクリプトやファイルを参照するために、bash インジェクションコマンドで使用します。 |
| `${CLAUDE_PROJECT_DIR}` | プロジェクトのルートディレクトリ。これは、[フック](https://code.claude.com/docs/ja/hooks.md#reference-scripts-by-path)や MCP サーバーが `CLAUDE_PROJECT_DIR` として受け取るのと同じパスです。スキルのインストール場所に関係なく、`${CLAUDE_PROJECT_DIR}/.claude/hooks/helper.sh` のようなプロジェクトローカルのスクリプトやファイルを参照するために使用します。 |
| `${CLAUDE_PLUGIN_ROOT}` | プラグインのインストールディレクトリ。プラグインスキルでのみ置換されます。プラグインのスキル間で共有されるリソースを含め、プラグイン内のどこにバンドルされたスクリプトやファイルでも参照するために使用します。[プラグインの環境変数](https://code.claude.com/docs/ja/plugins/manifest-reference.md#environment-variables)を参照してください。 |
| `${CLAUDE_PLUGIN_DATA}` | プラグインの更新後も保持される、プラグインの[永続データディレクトリ](https://code.claude.com/docs/ja/plugins/components.md#path-variables-and-persistent-data)。プラグインスキルでのみ置換されます。インストール済みの依存関係、生成されたファイル、更新後も残す必要があるキャッシュを参照するために使用します。 |

Claude Code は、`${CLAUDE_SKILL_DIR}` と `${CLAUDE_PROJECT_DIR}` を 2 つの場所で置換します。スキルの markdown コンテンツと、[`allowed-tools`](#frontmatter-reference) フロントマター内の Bash ルールです。プラグインスキルでは、Claude Code は `${CLAUDE_PLUGIN_ROOT}` と `${CLAUDE_PLUGIN_DATA}` を同じ 2 つの場所で置換します。両方の場所で同じ変数を使用することで、スキルは権限プロンプトなしでバンドルされたスクリプトを実行できます。次のスキルはこのパターンを示しています。

```yaml theme={null}
---
name: render-chart
description: Render a chart from a CSV file
allowed-tools: Bash(${CLAUDE_SKILL_DIR}/scripts/render.sh *)
---

Run `${CLAUDE_SKILL_DIR}/scripts/render.sh <csv-file>` to render the chart.
```

このスキルが `~/.claude/skills/render-chart/` にインストールされている場合、`${CLAUDE_SKILL_DIR}` の両方の出現箇所がそのディレクトリに展開されます。すると、`allowed-tools` ルールはスキル本文が Claude に実行するよう指示する正確なコマンドに一致するため、スクリプトはプロンプトなしで実行されます。

インデックス付きの引数はシェル形式のクォートを使用するため、複数の単語からなる値を 1 つの引数として渡すには引用符で囲みます。たとえば、`/my-skill "hello world" second` とすると、`$0` は `hello world` に、`$1` は `second` に展開されます。`$ARGUMENTS` プレースホルダーは常に、入力された引数文字列全体に展開されます。

対応する引数がないインデックス付きプレースホルダー（引数が 1 つしか渡されていない場合の `$2` など）は、コンテンツ内でそのまま残ります。[`arguments`](#frontmatter-reference) フロントマターの名前付きプレースホルダーで、一致する引数がないものは空文字列に展開されます。

`$1` や `$ARGUMENTS` などのテキスト自体を含む引数値を渡した場合、Claude Code はそれをリテラルテキストとして挿入し、展開しません。たとえば、スキルの本文に `Summarize $0` が含まれていて、`/summarize "$ARGUMENTS from yesterday"` を実行すると、Claude は `Summarize $ARGUMENTS from yesterday` を受け取ります。Claude Code は引数を挿入した後も、`${CLAUDE_SKILL_DIR}` などの `${CLAUDE_*}` 変数を置換します。

数字、`ARGUMENTS`、または宣言された引数名の前にリテラルの `$` を含めるには（本文中の `$1.00` など）、バックスラッシュでエスケープします：`\$1.00`。それ以外の `$` の前にあるバックスラッシュはそのまま残ります。トークンの直前にある単一のバックスラッシュのみがエスケープとして機能します。`\\$1` のような二重のバックスラッシュでは両方のバックスラッシュがそのまま残り、`$1` は引き続き引数値に展開されます。バックスラッシュによるエスケープは、これらの引数プレースホルダーのみが対象です。変数が適用される場所では、バックスラッシュによって `${CLAUDE_*}` 変数の置換が妨げられることはありません。

**置換を使用した例：**

```yaml theme={null}
---
name: session-logger
description: Log activity for this session
---

Log the following to logs/${CLAUDE_SESSION_ID}.log:

$ARGUMENTS
```

### サポートファイルを追加する

スキルのディレクトリには複数のファイルを含めることができます。これにより、`SKILL.md` を要点に絞りつつ、Claude が必要なときにだけ詳細な参照資料にアクセスできるようになります。大きな参照ドキュメント、API 仕様、サンプル集などを、スキルが実行されるたびにコンテキストに読み込む必要はありません。

```text theme={null}
my-skill/
├── SKILL.md (required - overview and navigation)
├── reference.md (detailed API docs - loaded when needed)
├── examples.md (usage examples - loaded when needed)
└── scripts/
    └── helper.py (utility script - executed, not loaded)
```

Claude が各ファイルの内容と読み込むタイミングを把握できるよう、`SKILL.md` からサポートファイルを参照してください。

```markdown theme={null}
## Additional resources

- For complete API details, see [reference.md](reference.md)
- For usage examples, see [examples.md](examples.md)
```

> [!TIP]
>
> `SKILL.md` は 500 行未満に保ってください。詳細な参照資料は別のファイルに移動してください。

### スキルを呼び出せる対象を制御する

デフォルトでは、ユーザーと Claude の両方があらゆるスキルを呼び出せます。`/skill-name` と入力して直接呼び出すことができ、Claude は会話に関連する場合に自動的に読み込むことができます。2 つのフロントマターのフィールドでこれを制限できます。

* **`disable-model-invocation: true`**：Claude は自らスキルを呼び出せません。`/commit`、`/deploy`、`/send-slack-message` など、副作用のあるワークフローや、タイミングを制御したいワークフローに使用します。コードの準備ができているように見えるからといって、Claude にデプロイを決定させたくはないでしょう。

* **`user-invocable: false`**：Claude だけがスキルを呼び出せます。コマンドとして実行できるものではない背景知識に使用します。`legacy-system-context` スキルは、古いシステムの仕組みを説明します。Claude は関連する場合にこれを知っておくべきですが、`/legacy-system-context` はユーザーが実行する意味のあるアクションではありません。

この例ではデプロイスキルを作成します。`disable-model-invocation: true` を設定すると、Claude はスキルを自動的に実行できません。

```yaml theme={null}
---
name: deploy
description: Deploy the application to production
disable-model-invocation: true
---

Deploy $ARGUMENTS to production:

1. Run the test suite
2. Build the application
3. Push to the deployment target
4. Verify the deployment succeeded
```

それでも Claude が実行しようとした場合、Claude Code はその呼び出しをブロックし、デプロイの手順を別の方法で再現しないよう指示します。そのため、Claude はユーザー自身で `/deploy` を実行するよう提案することになります。

2 つのフィールドが呼び出しとコンテキストの読み込みに与える影響は次のとおりです。

| フロントマター | ユーザーが呼び出せる | Claude が呼び出せる | コンテキストに読み込まれるタイミング |
| :- | :- | :- | :- |
| （デフォルト） | はい | はい | 説明は常にコンテキストにあり、スキル全体は呼び出されたときに読み込まれる |
| `disable-model-invocation: true` | はい | 自らは不可 | 説明はコンテキストになく、スキル全体は呼び出されたときに読み込まれる |
| `user-invocable: false` | いいえ | はい | 説明は常にコンテキストにあり、スキル全体は呼び出されたときに読み込まれる |

> [!NOTE]
>
> 通常のセッションでは、Claude が利用可能なものを把握できるようスキルの説明がコンテキストに読み込まれますが、スキルの完全なコンテンツは呼び出されたときにのみ読み込まれます。[スキルがプリロードされたサブエージェント](https://code.claude.com/docs/ja/sub-agents.md#preload-skills-into-subagents)は動作が異なり、起動時にスキルの完全なコンテンツが挿入されます。

#### スキル名を書く位置

スキルを直接実行するには、メッセージの先頭にその名前を置きます。プレーンテキストの後に置いた場合、名前は Claude にスキルを実行する権限を与えますが、スキルを実行はしません。

| 位置 | 例 | 何が起こるか |
| :- | :- | :- |
| メッセージの先頭 | `/deploy staging` | Claude Code がスキルを直接実行する |
| プレーンテキストの後に、句読点が付かない独立した単語として | `go ahead and /deploy to staging` | 直接は何も実行されない。名前はそのメッセージに対するユーザーの許可とみなされる。Claude は応答中にスキルを実行でき、ユーザーの言葉遣いからスキルの実行を求められたかどうかを判断する |

実行を許可せずにスキルについて書くには、スラッシュを付けないでください。

### スキルコンテンツのライフサイクル

ユーザーまたは Claude がスキルを呼び出すと、レンダリングされた `SKILL.md` のコンテンツが単一のメッセージとして会話に入り、以降のターンにわたってそこに残ります。この永続性はスキルの指示に適用されるもので、権限には適用されません。[`allowed-tools`](#pre-approve-tools-for-a-skill) による付与は、次のメッセージを送信するとクリアされます。Claude Code は以降のターンでスキルファイルを再読み込みしないため、タスク全体を通じて適用されるべきガイダンスは、1 回限りの手順ではなく、常設の指示として記述してください。

Claude がスキルを再度呼び出し、レンダリングされたコンテンツがすでにコンテキストにあるコピーと同一である場合、Claude Code はコンテンツの 2 つ目のコピーではなく、スキルがすでに読み込まれていることを示す短い注記を追加します。引数が変わった、または[動的コンテキスト](#inject-dynamic-context)のコマンドが新しい出力を生成したためにレンダリングされたコンテンツが異なる場合、Claude Code は完全なコンテンツを再度追加します。

[自動圧縮](https://code.claude.com/docs/ja/how-claude-code-works.md#when-context-fills-up)は、呼び出されたスキルをトークン予算の範囲内で引き継ぎます。コンテキストを解放するために会話が要約されると、Claude Code は各スキルの最新の呼び出しを要約の後に再添付し、それぞれ最初の 5,000 トークンを保持します。再添付されるスキルは、合計 25,000 トークンの予算を共有します。Claude Code はこの予算を最も新しく呼び出されたスキルから順に埋めていくため、1 つのセッションで多くのスキルを呼び出した場合、古いスキルはコンテキスト圧縮後に完全に削除されることがあります。

セッションの途中で Claude がスキルに従わなくなった場合は、[Claude がスキルに従わなくなる](#claude-stops-following-a-skill)を参照してください。

### スキルのツールを事前承認する

`allowed-tools` フィールドは、スキルを呼び出したターンの間、リストされたツールに権限を付与します。これにより、Claude はユーザーに承認を求めることなくそれらのツールを使用できます。スキルのコンテンツは[コンテキストに残り続けます](#skill-content-lifecycle)が、この付与は次のメッセージを送信するとクリアされます。スキルを再度呼び出すと、そのターンに対して再び適用されます。このフィールドは利用可能なツールを制限するものではありません。すべてのツールは引き続き呼び出し可能であり、リストされていないツールには引き続き[権限設定](https://code.claude.com/docs/ja/permissions.md)が適用されます。単一のターンではなくセッション全体でツールを事前承認するには、代わりにその権限設定に許可ルールを追加してください。

このフィールドは、ワークスペースの信頼によって制限されません。Claude Code は、一度も信頼したことのないフォルダーでの `-p` 実行であっても、プロジェクトスキルの `allowed-tools` を適用します。スキルは自身に広範なツールアクセスを付与できるため、リポジトリで Claude Code を実行する前に、そのリポジトリにチェックインされているスキルの `allowed-tools` を確認してください。組織全体でリポジトリのスキルからこのフィールドを無効にするには、[管理された権限ルールのみが適用される場合](#when-only-managed-permission-rules-apply)を参照してください。

このスキルを呼び出すと、Claude は使用のたびに承認を得ることなく git コマンドを実行できます。

```yaml theme={null}
---
name: commit
description: Stage and commit the current changes
disable-model-invocation: true
allowed-tools: Bash(git add *) Bash(git commit *) Bash(git status *)
---
```

スキルがアクティブな間、Claude が使用可能なツールからツールを除外するには、スキルのフロントマターの `disallowed-tools` にそれらをリストします。この制限は次のメッセージを送信するとクリアされます。拒否ルールと同様に、他のツールが残っている間はこのフィールドで [`EndConversation`](https://code.claude.com/docs/ja/tools-reference#endconversation-tool-behavior) を除外することはできません。すべてのスキルとプロンプトにわたってツールをブロックするには、[権限設定](https://code.claude.com/docs/ja/permissions.md)に拒否ルールを追加してください。

#### 管理設定によってフックがプラグインに限定される場合

組織の管理設定で `strictPluginOnlyCustomization` に `hooks` がリストされている場合、フロントマターで `hooks` を宣言している個人またはプロジェクトのスキルは、[事前承認を維持するスキル](https://code.claude.com/docs/ja/settings-reference.md#strictpluginonlycustomization-hooks)を除き、`allowed-tools` による事前承認を失います。

* **確認**：Claude Code セッションで `/status` と入力します。`/status` に [`Enterprise managed settings`](https://code.claude.com/docs/ja/settings#check-what-your-organization-enforces) が表示される場合は、`strictPluginOnlyCustomization` に `hooks` がリストされているかどうかを管理者に確認してください。
* **修正**：その設定下ではスキルのフックは実行されないため、スキルのフロントマターから `hooks` を削除します。フックを維持するには、マーケットプレイスからインストールする[プラグインにスキルを移動](https://code.claude.com/docs/ja/hooks.md#limits-on-skill-hooks)してください。

#### 管理された権限ルールのみが適用される場合

組織が管理設定で `allowManagedPermissionRulesOnly` を設定している場合、Claude Code はプロジェクトおよび個人のスキル、ならびに[この設定の項目に記載されているその他のソース](https://code.claude.com/docs/ja/settings-reference.md#allowmanagedpermissionrulesonly)にある `allowed-tools` を無視します。これには Claude Code v2.1.282 以降が必要です。

影響を受けるスキルがリストしているツールは、代わりに組織の管理ルールと通常の権限プロンプトを経由します。`/status` を実行すると、セッション内でこれまでに Claude Code が `allowed-tools` を無視した各スキルが一覧表示されます。スキル内の挿入されたコマンドのうち、どの管理ルールでも許可されていないものは、[挿入されたコマンドの権限チェック](#permission-checks-on-injected-commands)に従います。

### スキルに引数を渡す

ユーザーと Claude のどちらも、スキルを呼び出す際に引数を渡せます。引数は `$ARGUMENTS` プレースホルダーで利用できます。

このスキルは、番号を指定して GitHub の issue を修正します。`$ARGUMENTS` プレースホルダーは、スキル名の後に続く内容に置き換えられます。

```yaml theme={null}
---
name: fix-issue
description: Fix a GitHub issue
disable-model-invocation: true
---

Fix GitHub issue $ARGUMENTS following our coding standards.

1. Read the issue description
2. Understand the requirements
3. Implement the fix
4. Write tests
5. Create a commit
```

`/fix-issue 123` を実行すると、Claude は「Fix GitHub issue 123 following our coding standards...」を受け取ります。

引数を指定してスキルを呼び出したものの、スキルのコンテンツ内のどのプレースホルダーも引数を受け取らない場合、Claude Code はスキルコンテンツの末尾に `ARGUMENTS: <your input>` を追加し、Claude が入力内容を確認できるようにします。プレースホルダーとは、`$ARGUMENTS`、`$1` のようなインデックス形式、または名前付き引数のことです。その位置に引数がないインデックス付きプレースホルダーはリテラルテキストのまま残り、引数を受け取ったとはみなされません。名前付きプレースホルダーは空文字列に展開されるため、その位置に引数がない場合でも受け取ったとみなされます。

個々の引数に位置でアクセスするには、`$ARGUMENTS[N]` または短縮形の `$N` を使用します。

```yaml theme={null}
---
name: migrate-component
description: Migrate a component from one language to another
---

Migrate the $ARGUMENTS[0] component from $ARGUMENTS[1] to $ARGUMENTS[2].
Preserve all existing behavior and tests.
```

`/migrate-component SearchBar JavaScript TypeScript` を実行すると、`$ARGUMENTS[0]` が `SearchBar` に、`$ARGUMENTS[1]` が `JavaScript` に、`$ARGUMENTS[2]` が `TypeScript` に置き換えられます。`$N` の短縮形を使用した同じスキルは次のとおりです。

```yaml theme={null}
---
name: migrate-component
description: Migrate a component from one language to another
---

Migrate the $0 component from $1 to $2.
Preserve all existing behavior and tests.
```

#### 1 つのメッセージで複数のスキルを重ねる

ターミナルの Claude Code プロンプトで入力する場合、1 つのメッセージの先頭に複数のスキルを重ねて指定できます。Agent SDK または `claude -p` 経由では、Claude Code は最初のスキルのみを読み込み、行の残りをその引数とします。ターミナルのプロンプトで `/write-tests /fix-issue 123` と入力すると、両方のスキルが読み込まれ、末尾のテキスト `123` がそれぞれに `$ARGUMENTS` として渡されます。

Claude Code は、最初のスキルと、その後に重ねられた最大 5 つのスキルを展開します。展開は、インラインのユーザー呼び出し可能なスキルではない最初のトークンで停止します。[`/code-review`](https://code.claude.com/docs/ja/code-review-local) のように[フォークされたサブエージェント](#run-skills-in-a-subagent)として実行されるスキルや、`/loop` のように引数が別のコマンドで始まる可能性があるスキルを重ねた場合、展開はそこで終了します。そのトークンとそれ以降のすべてが、展開されたすべてのスキルの引数テキストになります。

## 高度なパターン

### 動的コンテキストを注入する

`` !`<command>` `` 構文は、スキルの内容が Claude に送信される前にシェルコマンドを実行します。コマンドの出力がプレースホルダーを置き換えるため、Claude はコマンドそのものではなく実際のデータを受け取ります。スキルが [claude.ai アカウントから同期](#how-claude-code-handles-the-body-of-a-synced-skill)されている場合、Claude Code はこれらのコマンドをユーザーのマシン上で実行しません。この制限には Claude Code v2.1.228 以降が必要です。

次のスキルは、GitHub CLI でライブの PR データを取得してプルリクエストを要約します。`` !`gh pr diff` `` などのコマンドが最初に実行され、その出力がプロンプトに挿入されます。

```yaml theme={null}
---
name: pr-summary
description: Summarize changes in a pull request
context: fork
agent: Explore
allowed-tools: Bash(gh *)
---

## Pull request context
- PR diff: !`gh pr diff`
- PR comments: !`gh pr view --comments`
- Changed files: !`gh pr diff --name-only`

## Your task
Summarize this pull request...
```

置換は元のファイルに対して 1 回だけ実行されます。コマンドの出力はプレーンテキストとして挿入され、さらに `` !`<command>` `` プレースホルダーがないか再スキャンされることはありません。そのため、コマンドが後続のパスで展開されるプレースホルダーを出力することはできません。

インライン形式は、`!` が行頭または空白の直後にある場合にのみ認識されます。`` KEY=!`cmd` `` のように `!` が別の文字の後に続く場合、プレースホルダーはリテラルテキストとして残され、コマンドは実行されません。

複数行のコマンドには、インライン形式の代わりに ` ```! ` で開始するフェンス付きコードブロックを使用します。

````markdown theme={null}
## Environment
```!
node --version
git status --short
```
````

ユーザー、プロジェクト、プラグイン、または[追加ディレクトリ](#skills-from-additional-directories)をソースとするスキルとカスタムコマンドでこの動作を無効にするには、[設定](https://code.claude.com/docs/ja/settings.md)で `"disableSkillShellExecution": true` を設定します。各コマンドは実行される代わりに `[shell command execution disabled by policy]` に置き換えられます。バンドルスキルと管理スキルは影響を受けません。この設定は、ユーザーが上書きできない[管理設定](https://code.claude.com/docs/ja/managed-settings.md)で使用すると特に効果的です。

この設定に関係なく、[claude.ai アカウントから同期](#how-synced-skills-behave)されたスキルにこれらのコマンドが含まれている場合、Claude Code がユーザーのマシン上でそれらを実行することはありません。この制限には Claude Code v2.1.228 以降が必要です。各種セッションで Claude がコマンドの代わりに何を受け取るかについては、[同期されたスキルの本文を Claude Code がどのように扱うか](#how-claude-code-handles-the-body-of-a-synced-skill)を参照してください。

> [!TIP]
>
> スキルの実行時により深い推論を求めるには、スキルの内容のどこかに `ultrathink` を含めます。[一回限りの深い推論に ultrathink を使用する](https://code.claude.com/docs/ja/model-config.md#use-ultrathink-for-one-off-deep-reasoning)を参照してください。

#### 注入されたコマンドの実行方法

Claude Code は、スキルのフロントマターの `shell` キーとユーザーの環境から、スキルの注入されたコマンドを実行するツールを選択します。どの組み合わせでもコマンドは Bash ツールまたは PowerShell ツールを通じて実行されますが、呼び出しが即座に失敗する組み合わせが 1 つだけあります。

* `shell: powershell` で、[PowerShell ツール](https://code.claude.com/docs/ja/tools-reference.md#powershell-tool)が有効な場合: コマンドは PowerShell ツールを通じて実行されます。
* `shell: bash` で bash が利用できない場合: コマンドが実行される前に呼び出しが失敗します。これは Git Bash のない Windows で発生します。Claude Code は ``Skill <name> requires bash (`shell: bash` in frontmatter) but Git Bash was not found`` と表示します。
* その他の組み合わせ: bash が利用できる場合、コマンドは Bash ツールを通じて実行されます。利用できない場合は PowerShell ツールを通じて実行されます。

どちらのツールも、Claude 自身のシェルコマンドを実行するのと同じ方法でコマンドを実行します。作業ディレクトリ、タイムアウト、出力の処理は共通です。

* **作業ディレクトリ**: Claude Code は各コマンドをセッションのシェルの現在の作業ディレクトリで実行します。このディレクトリは Claude が `cd` を実行すると移動します。毎回同じように解決される必要があるパスには [`${CLAUDE_SKILL_DIR}` または `${CLAUDE_PROJECT_DIR}`](#available-string-substitutions) を使用してください。
* **stderr**: デフォルトの `bash` シェルでは、Claude Code は stderr を stdout にマージします。コマンドが stderr に書き込んだ内容はすべて、注入されるテキストに表示されます。
* **タイムアウト**: 各コマンドは Bash ツールのデフォルトの 2 分の[タイムアウト](https://code.claude.com/docs/ja/tools-reference.md#timeout-and-output-limits)の下で実行されます。Bash ツールが[タイムアウトしたコマンドをバックグラウンドに移動](https://code.claude.com/docs/ja/tools-reference.md#foreground-commands-that-move-to-the-background)した場合でも、スキルはレンダリングされます。注入されるテキストにはその移動が報告され、バックグラウンドタスクとコマンドの出力を収集しているファイルの名前が示されます。Bash ツールが自動的にバックグラウンドに移動することのないコマンドの場合、Claude Code はタイムアウト時にそのコマンドを終了させます。この失敗は[呼び出しを中止します](#when-an-injected-command-fails)。
* **出力サイズ**: Bash ツールのインライン上限を超える出力は、切り詰められたテキストではなく、ファイルパスと短いプレビューとして届きます。上限と各境界の調整方法については[出力の制限](https://code.claude.com/docs/ja/tools-reference.md#output-limits)を参照してください。

PowerShell ツールも、実行するコマンドに同じタイムアウト、バックグラウンド移動、出力上限の動作を適用します。詳細については [PowerShell ツール](https://code.claude.com/docs/ja/tools-reference.md#powershell-tool)のセクションを参照してください。

#### 注入されたコマンドが失敗した場合

コマンドが失敗すると、そのプレースホルダーだけでなくスキルの呼び出し全体が中止されます。その呼び出しでは、Claude がスキルの内容を目にすることはありません。中止時には `Shell command failed for pattern "..."` と表示されます。エラーメッセージにはコマンドの出力が含まれます。

デフォルトの `bash` シェルでは、0 以外の終了コードはすべて失敗とみなされます。ただし例外が 1 つあります。Claude Code は[検索コマンドと比較コマンド](https://code.claude.com/docs/ja/tools-reference.md#output-limits)からの終了コード 1 を通常の結果として扱い、その出力を注入します。これらのコマンドでも、終了コードが 2 以上の場合は失敗となります。

どのコマンドがこの例外の対象になるかはシェルによって異なります。

* デフォルトの `bash` シェル: [出力の制限](https://code.claude.com/docs/ja/tools-reference.md#output-limits)に記載されているコマンド
* `shell: powershell` で PowerShell ツールが有効な場合: `grep` と `git diff` を含み、`find` と `diff` を含まない[別のセット](https://code.claude.com/docs/ja/tools-reference.md#exit-code-1-from-searches-and-git-diff-in-powershell)

デフォルトの `bash` シェルでは、0 以外で終了することが想定されるその他のコマンドには `|| true` を追加してください。問題を検出したときに 1 で終了するチェックスクリプトがその一例です。

#### 注入されたコマンド内の制御文字

`No shell command in <name> was run` は、ファイル内の `!` コマンドのいずれかにタブや改行以外の生の制御文字が含まれているため、どのコマンドも実行されないことを意味します。[その文字を見つけて削除する方法](https://code.claude.com/docs/ja/errors.md#no-shell-command-was-run)を参照してください。

#### 注入されたコマンドの権限チェック

注入されたコマンドは、スキルのレンダリング中に権限を求めることはありません。Claude Code はまず各コマンドを[権限ルール](https://code.claude.com/docs/ja/permissions.md)と照合します。拒否ルールに一致するコマンドは、`Shell command permission check failed for pattern "..."` で呼び出しを中止します。

[auto モード](https://code.claude.com/docs/ja/permission-modes.md#eliminate-prompts-with-auto-mode)以外では、コマンドの権限チェックが許可以外の結果を返した場合、Claude Code は同じエラーで呼び出しを中止します。これには、通常であればユーザーに確認を求めるルールも含まれます。一致しないコマンドがここで中止されないようにするには、[`allowed-tools`](#pre-approve-tools-for-a-skill) で事前に承認してください。組織が権限ルールを管理設定に限定している場合は、[管理された権限ルールのみが適用される場合](#when-only-managed-permission-rules-apply)を参照してください。拒否ルールと確認ルールは引き続き `allowed-tools` より優先されます。[権限を管理する](https://code.claude.com/docs/ja/permissions.md#manage-permissions)を参照してください。

auto モードでは、本来ユーザーの承認が必要なコマンドでも呼び出しは中止されません。スキルは、最初にそのコマンドを実行するよう Claude に指示する内容とともに読み込まれ、Claude 自身による呼び出しは [auto モードの通常のチェック](https://code.claude.com/docs/ja/permission-modes.md#how-the-classifier-evaluates-actions)を経由します。ただし、`agent` を設定する[フォークされたスキル](#run-skills-in-a-subagent)や、Claude が[注入されたコマンドを実行するシェルツール](#how-injected-commands-run)を持たないセッションでは、引き続き呼び出しが中止されます。

### サブエージェントでスキルを実行する

スキルを分離された環境で実行したい場合は、フロントマターに `context: fork` を追加します。Claude Code は `agent` フィールドで設定されたタイプの新しいサブエージェントを起動し、スキルの内容をそのプロンプトとして渡します。サブエージェントはユーザーの会話履歴を参照しないため、スキルの指示はそれ単体で完結している必要があります。

> [!NOTE]
>
> 名前に反して、`context: fork` を持つスキルは[現在の会話のフォーク](https://code.claude.com/docs/ja/sub-agents.md#fork-the-current-conversation)では実行されません。会話のフォークでは、これまでに話し合った内容がすべてサブエージェントに引き渡されます。タスクがその履歴に依存する場合は、`context: fork` を使用する代わりに会話をフォークしてください。

フォークされたサブエージェントは[バックグラウンド](https://code.claude.com/docs/ja/sub-agents.md#run-subagents-in-foreground-or-background)で実行されます。実行中も作業を続けることができ、完了すると結果が会話に届きます。代わりにスキルを呼び出したターンで結果を待つには、フロントマターで `background: false` を設定します。v2.1.218 より前は、フォークされたスキルは完了するまで常にターンをブロックしていました。

次のような場合には、スキルで `background: false` を設定していなくても、Claude Code は結果を待ちます。

* 非対話モードで、`-p` フラグまたは Agent SDK を使用している場合
* [`CLAUDE_CODE_DISABLE_BACKGROUND_TASKS`](https://code.claude.com/docs/ja/env-vars) を `1` に設定した場合（これにより、他のバックグラウンドタスク機能もオフになります）
* 同じスキルの以前の呼び出しがまだ実行中のときに、フォークされたスキルを呼び出した場合
* スキルをプロンプトとする[セッションスコープのスケジュールタスク](https://code.claude.com/docs/ja/scheduled-tasks.md)が実行された場合

[動的ワークフロー](https://code.claude.com/docs/ja/workflows.md)内のエージェントがフォークされたスキルを呼び出した場合、スキルで `background: false` を設定していなくても、そのエージェントは結果を待って受け取ります。v2.1.295 より前は、スキルがバックグラウンドで実行された場合、そのエージェントはスキルを待機しませんでした。その場合、スキルの結果はエージェントに届かず、メインの会話に届いていました。

バックグラウンドで実行されるフォークは、[バックグラウンドのサブエージェントに適用される、より限定されたツールセット](https://code.claude.com/docs/ja/sub-agents.md#run-subagents-in-foreground-or-background)でも実行されます。スキルのサブエージェントは通常のエージェントタイプであるため、会話をフォークするサブエージェント向けの例外は適用されません。スキルの手順がそのセット外のツールに依存する場合は、`background: false` を設定して完全なツールセットを維持してください。

バックグラウンドで実行されるフォークされたスキルは、セッションの[チェックポイント](https://code.claude.com/docs/ja/checkpointing.md#subagent-edits-not-restored)の外で編集を適用します。その後、`/rewind` で復元されるのは、Claude が会話内ですでに編集していたファイルのみです。スキルによるその他のファイルへの編集は残るため、git を使用して元に戻してください。

> [!WARNING]
>
> `context: fork` は、明示的な指示を持つスキルでのみ意味があります。スキルにタスクがなく「これらの API 規約を使用する」のようなガイドラインしか含まれていない場合、サブエージェントはガイドラインを受け取るものの実行可能なプロンプトがないため、意味のある出力を返さずに終了します。

スキルと[サブエージェント](https://code.claude.com/docs/ja/sub-agents.md)は、2 つの方向で連携します。

| アプローチ | システムプロンプト | タスク | 追加で読み込まれるもの |
| :- | :- | :- | :- |
| `context: fork` を持つスキル | エージェントタイプから | SKILL.md の内容 | CLAUDE.md（エージェントの[起動時コンテキスト](https://code.claude.com/docs/ja/sub-agents.md#what-loads-at-startup)に従う） |
| `skills` フィールドを持つサブエージェント | サブエージェントの markdown 本文 | Claude の委任メッセージ | プリロードされたスキル + CLAUDE.md（サブエージェントの[起動時コンテキスト](https://code.claude.com/docs/ja/sub-agents.md#what-loads-at-startup)に従う） |

`context: fork` では、スキルにタスクを記述し、それを実行するエージェントタイプを選択します。組み込みの Explore エージェントと Plan エージェントは、コンテキストを小さく保つために [CLAUDE.md と git status なしで起動します](https://code.claude.com/docs/ja/sub-agents.md#what-loads-at-startup)。タスクに必要なものはすべて SKILL.md に記述してください。`agent: Explore` を使用するフォークされたスキルは、その内容とエージェント自身のシステムプロンプトで起動し、CLAUDE.md ファイルは一切含まれません。

逆に、スキルを参考資料として使用するカスタムサブエージェントを定義する場合については、[サブエージェント](https://code.claude.com/docs/ja/sub-agents.md#preload-skills-into-subagents)を参照してください。

#### 例: Explore エージェントを使用するリサーチスキル

このスキルは、フォークされた Explore エージェントでリサーチを実行します。スキルの内容がタスクとなり、エージェントはコードベースの探索に最適化された読み取り専用ツールを提供します。

```yaml theme={null}
---
name: deep-research
description: Research a topic thoroughly
context: fork
agent: Explore
---

Research $ARGUMENTS thoroughly:

1. Find relevant files using Glob and Grep
2. Read and analyze the code
3. Summarize findings with specific file references
```

このスキルが実行されると、次のようになります。

1. 新しい分離されたコンテキストが作成されます
2. サブエージェントがスキルの内容（「Research \$ARGUMENTS thoroughly」の指示）をプロンプトとして受け取ります
3. `agent` フィールドが実行環境（モデル、ツール、権限）を決定します
4. サブエージェントは完了すると結果を要約し、メインの会話に返します

`agent` フィールドは、使用するサブエージェントの設定を指定します。選択肢には組み込みエージェント（`Explore`、`Plan`、`general-purpose`）や `.claude/agents/` 内の任意のカスタムサブエージェントがあります。省略した場合は `general-purpose` が使用されます。

### Claude のスキルへのアクセスを制限する

デフォルトでは、Claude は `disable-model-invocation: true` が設定されていないすべてのスキルを呼び出せます。[`allowed-tools`](#pre-approve-tools-for-a-skill) を定義するスキルは、そのスキルを呼び出したターンの間、使用ごとの承認なしでそれらのツールへのアクセスを Claude に付与します。この付与は、ユーザーが次のメッセージを送信するとクリアされます。その他すべてのツールについては、引き続き[権限設定](https://code.claude.com/docs/ja/permissions.md)が基本的な承認動作を制御します。`/init` や `/security-review` など、いくつかの組み込みコマンドも Skill ツールを通じて利用できます。`/compact` などのその他の組み込みコマンドは利用できません。

Claude が呼び出せるスキルを制御する方法は 3 つあります。

**すべてのスキルを無効にする**には、`/permissions` で Skill ツールを拒否します。

```text theme={null}
# Add to deny rules:
Skill
```

**特定のスキルを許可または拒否する**には、[権限ルール](https://code.claude.com/docs/ja/permissions.md)を使用します。

```text theme={null}
# Allow only specific skills
Skill(commit)
Skill(review-pr *)

# Deny specific skills
Skill(deploy *)
```

権限の構文: 完全一致には `Skill(name)`、任意の引数を伴う前方一致には `Skill(name *)` を使用します。

次の表は、ルールに記述する名前の種類ごとに、`deny` ルールが記述した名前以外に何をブロックするかを示しています。

| `deny` ルールで指定する名前 | ルールの例 | Claude Code が追加でブロックするもの |
| :- | :- | :- |
| エイリアス | `Skill(review)` | `/review` エイリアスを介したバンドルの `/code-review` |
| 修飾されていない名前 | `Skill(deploy)` | `apps/web:deploy` として一覧表示される[ネストされたスキル](#where-skills-live) |
| [claude.ai から同期されたスキル](#how-synced-skills-behave) | `Skill(anthropic-skills:deploy)` | Claude Desktop がプラグインとしてセッションに配信する場合のそのスキル |
| 同期されたスキルのプラグイン形式 | `Skill(deploy:deploy)` | 同期されたスキル |
| [パラメーター形式](https://code.claude.com/docs/ja/permissions.md#match-by-input-parameter)で指定したスキル | `Skill(skill:deploy)` | Claude がどの名前（エイリアスや表示名を含む）で呼び出しても、そのスキル |

v2.1.260 より前は、拒否ルールで修飾されていない名前のみを指定した場合、修飾名で一覧表示されるネストされたスキルを Claude Code はブロックしませんでした。

Claude Code は、`allow` ルールをスキル自身の名前と Claude の呼び出しにおける名前とのみ照合します。[同期されたスキル](#how-synced-skills-behave)をプロンプトなしで承認するには、その[予約済み名前空間](#names-reserved-for-synced-skills)内で名前を指定します。

* `Skill(anthropic-skills:pdf)` は同期された `pdf` スキルを承認します
* `Skill(anthropic-skills *)` はすべての同期されたスキルを承認します
* `Skill(anthropic *)` は `anthropic-skills:pdf` を対象としません。名前空間外のプレフィックスは、その内部の名前に一致しないためです

**個々のスキルを非表示にする**には、そのフロントマターに `disable-model-invocation: true` を追加します。これにより、スキルは Claude のコンテキストから完全に削除されます。

> [!NOTE]
>
> `user-invocable: false` を設定すると、ユーザーはスキルを呼び出せなくなりますが、Claude は引き続き呼び出せます。Claude が Skill ツールを通じて呼び出せないようにするには、`disable-model-invocation: true` を設定してください。

### 設定からスキルの表示を上書きする

`skillOverrides` 設定は、スキル自身のフロントマターではなく[設定](https://code.claude.com/docs/ja/settings.md)からスキルの表示を制御します。共有プロジェクトリポジトリにチェックインされているものなど、SKILL.md を編集したくないスキルに使用してください。`/skills` メニューがこの設定を書き込んでくれます。スキルをハイライトして `Space` を押すと状態が切り替わり、`Esc` を押すと `.claude/settings.local.json` に保存されます。

各キーはスキル名で、各値は次の 4 つの状態のいずれかです。

| 値 | Claude への一覧表示 | `/` メニュー内 |
| :- | :- | :- |
| `"on"` | 名前と説明 | はい |
| `"name-only"` | 名前のみ | はい |
| `"user-invocable-only"` | 非表示 | はい |
| `"off"` | 非表示 | 非表示 |

`/skills` メニューでは、`"user-invocable-only"` 状態は `user-only` と表示されます。

`"off"` は、ターミナルの `/` メニューに加えて、[Remote Control](https://code.claude.com/docs/ja/remote-control.md) クライアントや [Agent SDK](https://code.claude.com/docs/ja/agent-sdk/skills.md#discover-available-commands) の呼び出し元に公開されるコマンド一覧からもスキルを非表示にします。非表示のスキルをフルネームで呼び出すと、実行されずに `skillOverrides` のエラーが返されます。

`skillOverrides` に含まれていないスキルは `"on"` として扱われます。次の例では、一方のスキルを名前のみに縮小し、もう一方を完全にオフにしています。

```json theme={null}
{
  "skillOverrides": {
    "legacy-context": "name-only",
    "deploy": "off"
  }
}
```

一部のバンドルスキルには、`/doctor` に対する `checkup` のようなエイリアスがあります。[管理設定](https://code.claude.com/docs/ja/managed-settings.md)または `--settings` フラグで渡すファイルでエイリアスの下に `skillOverrides` エントリを設定すると、Claude Code はそのエイリアスの背後にあるスキルに適用します。エイリアスを通じてできるのはスキルをさらに制限することだけで、より表示されるようにすることはできません。また、管理設定でスキル自身の名前の下にもエントリを設定した場合は、そのエントリが優先されます。v2.1.260 より前は、Claude Code はどの設定ソースでも、エイリアスの下のエントリをスキルに適用していませんでした。

ユーザー設定、プロジェクト設定、ローカル設定では、Claude Code はエントリをスキル名とのみ照合します。そこで `review` のエントリを設定した場合、それは `review` という名前のスキルに適用され、`/review` エイリアスを介したバンドルの `/code-review` には適用されません。

プラグインのスキルは `skillOverrides` の影響を受けません。それらは代わりに `/plugin` で管理してください。

### 使用されていないスキルを見つける

[スキル一覧](#skill-descriptions-are-cut-short)に含まれるすべてのスキルは、Claude が実際に使用するかどうかにかかわらず、毎ターンのコンテキストを増やします。`/skill-doctor` を実行すると、各スキルのコストと使用頻度を確認でき、どのスキルをオフにするかを判断できます。対話セッションでは、レポートは `/plugin` マネージャーの **Stats** タブで開きます。`-p` を使用した[非対話モード](https://code.claude.com/docs/ja/headless.md)では、Claude Code はレポートをテキストとして出力します。

レポートは、バンドルスキルとエンタープライズスキル以外の、セッション内のスキルを対象とします。一覧に含まれていながら一度も呼び出されていないスキルを指摘し、それらをオフにする場所を示します。オフにする場所が示されたスキルのうち、コンテキストコストが最も高いものから始めてください。レポートには、最近使用していないプラグインも一覧表示されます。

`/skill-doctor` には Claude Code v2.1.252 以降が必要で、[フィーチャーフラグの取得](https://code.claude.com/docs/ja/env-vars.md#features-that-need-feature-flag-fetching)をスキップするセッションでは利用できません。スマートフォンやブラウザから [Remote Control](https://code.claude.com/docs/ja/remote-control.md) 経由で `/skill-doctor` を実行した場合、Claude Code は代わりに [`Skill usage reports are not available on this connection.`](https://code.claude.com/docs/ja/errors#skill-usage-reports-are-not-available-on-this-connection) と応答します。セッションが実行されているマシンのターミナルで `/skill-doctor` を実行してください。

## スキルを評価して反復する

スキルがトリガーされたことを確認することは、Claude がそれを見つけたことを意味しますが、意図した動作をしたことを意味しません。スキルが機能していることを知るには、Claude がそれを呼び出すべきプロンプトで実際に呼び出すかどうか、および呼び出す場合に出力が期待と一致するかどうかを個別に測定する必要があります。

両方をチェックするには、ベースライン比較を行います。現実的なプロンプトをいくつか収集し、スキルが利用可能な新しいセッションで各プロンプトを実行し、スキルをオフにした状態でも実行して、結果を比較します。新しいセッションが重要なのは、スキルの作成時に残されたコンテキストが、書かれた指示のギャップをマスクするためです。

2 番目の実行でスキルをオフにする方法は、スキルの出所によって異なります。

* **個人用またはプロジェクトスキル**：[`skillOverrides`](#override-skill-visibility-from-settings) で `"off"` に設定します。
* **プラグインが提供するスキル**：`skillOverrides` はプラグインスキルには適用されません。代わりに [`claude plugin eval`](https://code.claude.com/docs/ja/plugin-evals#the-no-plugin-baseline) を使用します。これはプラグインが読み込まれていない状態で各実行を繰り返します。

ベースライン比較を自動化する 2 つのツールがあります。[プラグイン](https://code.claude.com/docs/ja/plugins/overview.md) で配布されるスキルの場合、[`claude plugin eval`](https://code.claude.com/docs/ja/plugin-evals) は各プロンプトを分離されたセッションでプラグインの有無で実行し、定義したグレーダーまたはそれが作成したグレーダーでスコアリングし、閾値以下の場合はゼロ以外で終了するため、CI でそれをゲートできます。Claude Code 会話内の単一スキルを反復する場合、以下のスキル作成者プラグインは独自の `evals/evals.json` 形式で同様のループを実行します。2 つの形式は相互交換可能ではありません。

### skill-creator でエバルを実行する

[`skill-creator` プラグイン](https://github.com/anthropics/claude-plugins-official/tree/main/plugins/skill-creator) は Claude Code 内の比較ループを自動化します。VS Code 拡張機能またはデスクトップアプリでは、[プラグインをインストールする](https://code.claude.com/docs/ja/plugins/install.md#install-a-plugin) の手順に従って公式マーケットプレイスからインストールします。ターミナルでは、`claude` を実行して Claude Code を起動し、そのプロンプトで次のように入力します。

```text theme={null}
/plugin install skill-creator@claude-plugins-official
```

インストールが失敗した場合は、Claude Code が報告するメッセージと一致させます。

* `Marketplace "claude-plugins-official" not found`：`/plugin marketplace add anthropics/claude-plugins-official` でマーケットプレイスを追加してから、インストールを再試行します。
* `Plugin "<name>" not found in marketplace "claude-plugins-official"`：マーケットプレイスカタログのローカルコピーが古くなっている可能性があります。`/plugin marketplace update claude-plugins-official` で更新してから、インストールを再試行します。再試行しても同じメッセージが表示される場合は、[プラグインがマーケットプレイスで見つからない](https://code.claude.com/docs/ja/plugins/troubleshooting.md#plugin-not-found-in-marketplace) を参照してください。

インストール概要が `Run /reload-plugins to apply.` を報告する場合、Claude Code はそのリロードを実行します。リロードが次のメッセージが会話を再読み込みすることを警告する場合は、`/reload-plugins --force` を実行してプラグインのスキルを現在のセッションで利用可能にします。その後、Claude に既存のスキルを評価するよう依頼します。例えば `evaluate my summarize-changes skill with skill-creator` です。プラグインはテストケースの作成をガイドし、ループを実行します。

* **テストケース**：プロンプト、入力ファイル、および期待される動作をスキルディレクトリ内の `evals/evals.json` に保存します
* **分離された実行**：テストケースごとに [サブエージェント](https://code.claude.com/docs/ja/sub-agents.md) を生成して、各実行がクリーンなコンテキストで開始され、トークン数と期間を記録します
* **グレーディング**：各アサーションを出力に対してチェックし、`grading.json` に証拠とともに合格または不合格を書き込みます
* **ベンチマーク**：スキルあり対スキルなしの合格率、時間、トークンを `benchmark.json` に集約して、トークンと時間のオーバーヘッドに対する合格率の改善を比較できます
* **バージョン比較**：スキルの 2 つのバージョン間でブラインド A/B テストを実行して、編集をコミットする前に改善であることを確認できます
* **説明チューニング**：トリガーすべきおよびトリガーすべきでないプロンプトを生成し、ヒット率を測定し、スキルが間違ったリクエストで起動する場合は説明編集を提案します
* **レビュービューアー**：各出力を検査し、次の反復が読み込む定性的フィードバックを記録できる HTML レポートを開きます

エバルファイル形式と完全な反復ワークフローについては、agentskills.io の [スキル出力品質の評価](https://agentskills.io/skill-creation/evaluating-skills) を参照してください。ベンチマークと比較モードの背景については、[skill-creator アナウンスメント](https://claude.com/blog/improving-skill-creator-test-measure-and-refine-agent-skills) を参照してください。

## スキルを共有する

スキルはオーディエンスに応じて異なるスコープで配布できます。

* **プロジェクトスキル**: `.claude/skills/` をバージョン管理にコミットする
* **プラグイン**: [プラグイン](https://code.claude.com/docs/ja/plugins/overview.md)に `skills/` ディレクトリを作成する
* **マネージド**: [マネージド設定](https://code.claude.com/docs/ja/managed-settings.md)を通じて組織全体にデプロイする

### ビジュアル出力を生成する

スキルは任意の言語でスクリプトをバンドルして実行でき、Claude に単一のプロンプトでは不可能な機能を提供します。1 つのパターンはビジュアル出力を生成することです。つまり、ブラウザで開いてデータを探索したり、デバッグしたり、レポートを作成したりするためのインタラクティブな HTML ファイルです。

この例は、コードベースエクスプローラーを作成します。これはインタラクティブなツリービューで、ディレクトリを展開・折りたたんだり、ファイルサイズを一目で確認したり、ファイルタイプを色で識別したりできます。

スキルディレクトリを作成します。

```bash theme={null}
mkdir -p ~/.claude/skills/codebase-visualizer/scripts
```

これを `~/.claude/skills/codebase-visualizer/SKILL.md` に保存します。説明は Claude にこのスキルをいつ有効化するかを伝え、指示は Claude にバンドルされたスクリプトを実行するよう伝えます。スクリプトパスは [`${CLAUDE_SKILL_DIR}`](#available-string-substitutions) を使用するため、スキルが個人、プロジェクト、またはプラグインレベルでインストールされているかどうかに関わらず正しく解決されます。

````yaml theme={null}
---
name: codebase-visualizer
description: Generate an interactive collapsible tree visualization of your codebase. Use when exploring a new repo, understanding project structure, or identifying large files.
allowed-tools: Bash(python3 *)
---

# Codebase Visualizer

Generate an interactive HTML tree view that shows your project's file structure with collapsible directories.

## Usage

Run the visualization script from your project root:

```bash
python3 ${CLAUDE_SKILL_DIR}/scripts/visualize.py .
```

This creates `codebase-map.html` in the current directory and opens it in your default browser.

## What the visualization shows

- **Collapsible directories**: Click folders to expand/collapse
- **File sizes**: Displayed next to each file
- **Colors**: Different colors for different file types
- **Directory totals**: Shows aggregate size of each folder
````

これを `~/.claude/skills/codebase-visualizer/scripts/visualize.py` に保存します。このスクリプトはディレクトリツリーをスキャンし、以下を含む自己完結型の HTML ファイルを生成します。

* ファイル数、ディレクトリ数、合計サイズ、ファイルタイプ数を表示する**サマリーサイドバー**
* コードベースをファイルタイプ別（サイズ上位 8 つ）に分類する**棒グラフ**
* ディレクトリを展開・折りたたんだり、色分けされたファイルタイプインジケーターを表示したりできる**折りたたみ可能なツリー**

スクリプトは Python 3 を必要としますが、組み込みライブラリのみを使用するため、インストールするパッケージはありません。

```python expandable theme={null}
#!/usr/bin/env python3
"""Generate an interactive collapsible tree visualization of a codebase."""

import json
import sys
import webbrowser
from html import escape
from pathlib import Path
from collections import Counter

IGNORE = {'.git', 'node_modules', '__pycache__', '.venv', 'venv', 'dist', 'build'}

def scan(path: Path, stats: dict) -> dict:
    result = {"name": path.name, "children": [], "size": 0}
    try:
        for item in sorted(path.iterdir()):
            if item.name in IGNORE or item.name.startswith('.'):
                continue
            if item.is_file():
                size = item.stat().st_size
                ext = item.suffix.lower() or '(no ext)'
                result["children"].append({"name": item.name, "size": size, "ext": ext})
                result["size"] += size
                stats["files"] += 1
                stats["extensions"][ext] += 1
                stats["ext_sizes"][ext] += size
            elif item.is_dir():
                stats["dirs"] += 1
                child = scan(item, stats)
                if child["children"]:
                    result["children"].append(child)
                    result["size"] += child["size"]
    except PermissionError:
        pass
    return result

def generate_html(data: dict, stats: dict, output: Path) -> None:
    ext_sizes = stats["ext_sizes"]
    total_size = sum(ext_sizes.values()) or 1
    sorted_exts = sorted(ext_sizes.items(), key=lambda x: -x[1])[:8]
    colors = {
        '.js': '#f7df1e', '.ts': '#3178c6', '.py': '#3776ab', '.go': '#00add8',
        '.rs': '#dea584', '.rb': '#cc342d', '.css': '#264de4', '.html': '#e34c26',
        '.json': '#6b7280', '.md': '#083fa1', '.yaml': '#cb171e', '.yml': '#cb171e',
        '.mdx': '#083fa1', '.tsx': '#3178c6', '.jsx': '#61dafb', '.sh': '#4eaa25',
    }
    lang_bars = "".join(
        f'<div class="bar-row"><span class="bar-label">{ext}</span>'
        f'<div class="bar" style="width:{(size/total_size)*100}%;background:{colors.get(ext,"#6b7280")}"></div>'
        f'<span class="bar-pct">{(size/total_size)*100:.1f}%</span></div>'
        for ext, size in sorted_exts
    )
    def fmt(b):
        if b < 1024: return f"{b} B"
        if b < 1048576: return f"{b/1024:.1f} KB"
        return f"{b/1048576:.1f} MB"

    html = f'''<!DOCTYPE html>
<html><head>
  <meta charset="utf-8"><title>Codebase Explorer</title>
  <style>
    body {{ font: 14px/1.5 system-ui, sans-serif; margin: 0; background: #1a1a2e; color: #eee; }}
    .container {{ display: flex; height: 100vh; }}
    .sidebar {{ width: 280px; background: #252542; padding: 20px; border-right: 1px solid #3d3d5c; overflow-y: auto; flex-shrink: 0; }}
    .main {{ flex: 1; padding: 20px; overflow-y: auto; }}
    h1 {{ margin: 0 0 10px 0; font-size: 18px; }}
    h2 {{ margin: 20px 0 10px 0; font-size: 14px; color: #888; text-transform: uppercase; }}
    .stat {{ display: flex; justify-content: space-between; padding: 8px 0; border-bottom: 1px solid #3d3d5c; }}
    .stat-value {{ font-weight: bold; }}
    .bar-row {{ display: flex; align-items: center; margin: 6px 0; }}
    .bar-label {{ width: 55px; font-size: 12px; color: #aaa; }}
    .bar {{ height: 18px; border-radius: 3px; }}
    .bar-pct {{ margin-left: 8px; font-size: 12px; color: #666; }}
    .tree {{ list-style: none; padding-left: 20px; }}
    details {{ cursor: pointer; }}
    summary {{ padding: 4px 8px; border-radius: 4px; }}
    summary:hover {{ background: #2d2d44; }}
    .folder {{ color: #ffd700; }}
    .file {{ display: flex; align-items: center; padding: 4px 8px; border-radius: 4px; }}
    .file:hover {{ background: #2d2d44; }}
    .size {{ color: #888; margin-left: auto; font-size: 12px; }}
    .dot {{ width: 8px; height: 8px; border-radius: 50%; margin-right: 8px; }}
  </style>
</head><body>
  <div class="container">
    <div class="sidebar">
      <h1>📊 Summary</h1>
      <div class="stat"><span>Files</span><span class="stat-value">{stats["files"]:,}</span></div>
      <div class="stat"><span>Directories</span><span class="stat-value">{stats["dirs"]:,}</span></div>
      <div class="stat"><span>Total size</span><span class="stat-value">{fmt(data["size"])}</span></div>
      <div class="stat"><span>File types</span><span class="stat-value">{len(stats["extensions"])}</span></div>
      <h2>By file type</h2>
      {lang_bars}
    </div>
    <div class="main">
      <h1>📁 {escape(data["name"])}</h1>
      <ul class="tree" id="root"></ul>
    </div>
  </div>
  <script>
    const data = {json.dumps(data)};
    const colors = {json.dumps(colors)};
    function fmt(b) {{ if (b < 1024) return b + ' B'; if (b < 1048576) return (b/1024).toFixed(1) + ' KB'; return (b/1048576).toFixed(1) + ' MB'; }}
    function esc(s) {{ return s.replace(/[&<>"']/g, c => ({{"&":"&amp;","<":"&lt;",">":"&gt;",'"':"&quot;","'":"&#39;"}}[c])); }}
    function render(node, parent) {{
      if (node.children) {{
        const det = document.createElement('details');
        det.open = parent === document.getElementById('root');
        det.innerHTML = `<summary><span class="folder">📁 ${{esc(node.name)}}</span><span class="size">${{fmt(node.size)}}</span></summary>`;
        const ul = document.createElement('ul'); ul.className = 'tree';
        node.children.sort((a,b) => (b.children?1:0)-(a.children?1:0) || a.name.localeCompare(b.name));
        node.children.forEach(c => render(c, ul));
        det.appendChild(ul);
        const li = document.createElement('li'); li.appendChild(det); parent.appendChild(li);
      }} else {{
        const li = document.createElement('li'); li.className = 'file';
        li.innerHTML = `<span class="dot" style="background:${{colors[node.ext]||'#6b7280'}}"></span>${{esc(node.name)}}<span class="size">${{fmt(node.size)}}</span>`;
        parent.appendChild(li);
      }}
    }}
    data.children.forEach(c => render(c, document.getElementById('root')));
  </script>
</body></html>'''
    output.write_text(html)

if __name__ == '__main__':
    target = Path(sys.argv[1] if len(sys.argv) > 1 else '.').resolve()
    stats = {"files": 0, "dirs": 0, "extensions": Counter(), "ext_sizes": Counter()}
    data = scan(target, stats)
    out = Path('codebase-map.html')
    generate_html(data, stats, out)
    print(f'Generated {out.absolute()}')
    webbrowser.open(f'file://{out.absolute()}')
```

テストするには、任意のプロジェクトで Claude Code を開き、「Visualize this codebase.」と尋ねます。Claude はスクリプトを実行し、生成されたファイルのパス（例：`Generated /path/to/codebase-map.html`）を出力し、ブラウザで開きます。ブラウザが開かないヘッドレス環境で作業している場合、出力されたパスはスクリプトが成功したことを確認します。

このパターンはあらゆるビジュアル出力に対応します。依存関係グラフ、テストカバレッジレポート、API ドキュメント、またはデータベーススキーマの可視化です。バンドルされたスクリプトが作業を行い、Claude がオーケストレーションを処理します。

## トラブルシューティング

### スキルがトリガーされない

Claude がスキルを期待通りに使用しない場合：

1. 説明にユーザーが自然に言うキーワードが含まれているか確認してください
2. スキルが `What skills are available?` に表示されているか確認してください
3. 説明により密接に一致するようにリクエストを言い換えてみてください
4. スキルがユーザー呼び出し可能な場合は、`/skill-name` で直接呼び出してください
5. `/skill-name` も認識されない場合は、Claude Code が[スキルの名前を拒否した](#characters-a-skill-name-cant-hold)かどうかを確認してください
6. スキルが `paths` を設定している場合は、Claude が読み取り、編集、または書き込むファイルが Claude の現在の作業ディレクトリ内にあることを確認してください。スキルはその外にあるファイル（兄弟関係にある git worktree 内のファイルなど。`/add-dir` で追加したものであっても同様です）に対してはアクティブになりません。それらのファイルでスキルをアクティブにするには、その worktree で Claude Code を起動するか、[`/cd` でセッションをそこに移動](https://code.claude.com/docs/ja/permissions#move-the-session-to-another-directory)してください。

frontmatter YAML が不正な形式の場合、Claude Code はスキル本体を空のメタデータで読み込むため、`/skill-name` は機能しますが Claude は `description` と照合できません。`--debug` で実行してパースエラーを確認してください。

スキルがプラグインに含まれている場合、1 つずつ確認するのではなく、現実的なプロンプト全体でスキルがどのくらいの頻度でトリガーされるかを測定できます。[`tool_used: Skill` グレーダー](https://code.claude.com/docs/ja/plugin-evals#create-your-first-eval-suite)を使用して eval ケースを作成し、説明を変更するたびに `claude plugin eval` で実行してください。

frontmatter がパースされない `SKILL.md` ファイルを見つけるには、スキルディレクトリで [`claude plugin validate`](https://code.claude.com/docs/ja/plugins/cli-reference#validate-a-directory) を実行してください。例えば、プロジェクトスキルの場合は `claude plugin validate .claude/skills`、個人スキルの場合は `claude plugin validate ~/.claude/skills` です。Claude Code v2.1.233 以降が必要です。

### スキルが頻繁にトリガーされる

Claude がスキルを不要な時に使用する場合：

1. 説明をより具体的にしてください
2. 手動呼び出しのみが必要な場合は `disable-model-invocation: true` を追加してください

### Claude がスキルに従わなくなる

Claude が最初の応答でスキルに従い、その後に従わなくなった場合は、以下のいずれかのケースに該当するもので始めてください：

* **Claude が毎回成立する必要があるルールをスキップした**：ルールを [hook](https://code.claude.com/docs/ja/hooks-guide.md) に移動してください。Claude Code は hook をそのイベントが発生するたびに実行します。例えば、ファイル編集の前など、Claude がスキルに従っているかどうかに関わらず実行されます。ルールをスキルと一緒に保つには、スキルの [`hooks` frontmatter](https://code.claude.com/docs/ja/hooks#hooks-in-skills-and-agents) で hook を定義してください。その hook はスキルが呼び出された時点からセッション終了まで適用されます。
* **Claude が判断を伴って適用すべきガイダンスをスキップした**：ガイダンスが全体的なタスクに適用されるように言い換えてください。例えば「すべての編集後にテストを実行する」ではなく「テストを実行する」ではなく、「すべての編集後にテストを実行する」と言ってください。Claude Code はスキルが呼び出された時点で会話にスキルのコンテンツを追加し、[後の段階ではファイルを再読み込みしません](#skill-content-lifecycle)。
* **会話がコンパクト化された**：スキルを再度呼び出してコンテンツを復元してください。[コンパクト化](https://code.claude.com/docs/ja/how-claude-code-works.md#when-context-fills-up)後、Claude Code は [呼び出されたスキルの開始部分のみを保持できます](#skill-content-lifecycle)。そのため、最も重要な指示を `SKILL.md` の上部に配置してください。

### スキルの説明が短くカットされている

Claude Code はスキル名と説明のリストをコンテキストに読み込み、Claude が利用可能なものを知ることができるようにします。リストには常にすべてのスキル名が含まれていますが、スキルが多い場合、Claude Code はリストの文字予算に合わせるために一部の説明を削除し、Claude が要求と照合するために必要なキーワードが削除されます。予算はモデルのコンテキストウィンドウの 1% でスケーリングされます。リストが予算を超える場合、Claude Code は最も呼び出しが少ないスキルから説明を削除するため、最も使用するスキルは完全なテキストを保持します。

`/doctor` を実行してリストのコンテキストコストとその最大の貢献者の推定値を取得してください。オフにする価値のあるスキルを見つけるには、[`/skill-doctor`](#find-unused-skills) を実行してください。リストが予算を超える場合、Claude Code はデバッグログに警告も書き込みます。これは [`--debug`](https://code.claude.com/docs/ja/cli-reference#cli-flags) で表示できます。

`/context` の Skills 行は、予算が適用された後のリストのサイズを報告するため、モデルが受け取るものと一致します。v2.1.196 より前は、この行はすべての説明の完全なテキストをカウントし、設定された予算の数倍大きい値を表示できました。

予算を増やすには、[`skillListingBudgetFraction`](https://code.claude.com/docs/ja/settings-reference#skilllistingbudgetfraction) 設定（例えば `0.02` = 2%）または `SLASH_COMMAND_TOOL_CHAR_BUDGET` 環境変数を固定文字数に設定してください。他のスキルのために予算を解放するには、[`skillOverrides`](#override-skill-visibility-from-settings) で低優先度のエントリを `"name-only"` に設定して、説明なしでリストされるようにしてください。また、ソースで `description` と `when_to_use` テキストをトリミングすることもできます。各エントリの結合テキストは予算に関わらず 1,536 文字でキャップされているため、主要なユースケースを最初に配置してください。キャップは [`skillListingMaxDescChars`](https://code.claude.com/docs/ja/settings-reference#skilllistingmaxdescchars) で設定可能です。

### 個人スキルが消えた

`~/.claude/skills/` に作成したスキルフォルダが消えている場合は、`~/.claude/skills/.trash/` を確認してください。Claude Code が [claude.ai からスキルを同期](#how-synced-skills-behave)する場合、それらを別の `synced` サブフォルダにダウンロードし、作成したフォルダを移動または削除しません。

v2.1.280 より前は、`~/.claude/skills/` に `manifest.json` という名前のファイルがあると、Claude Code はそのファイルがリストしたスキルフォルダを `~/.claude/skills/.trash/` の下のタイムスタンプ付きフォルダに移動し、それらのスキルは読み込まれなくなりました。

スキルを復元するには、タイムスタンプ付きフォルダからそのフォルダを `~/.claude/skills/` に戻してください。これは [保持期間スイープ](https://code.claude.com/docs/ja/claude-directory.md#cleaned-up-automatically) がゴミ箱エントリを削除する前に行ってください。デフォルトではゴミ箱に移動されてから 30 日後に削除されます。

## 関連リソース

* **[設定をデバッグする](https://code.claude.com/docs/ja/debug-your-config.md)**：スキルが表示されない、またはトリガーされない理由を診断する
* **[スキル出力品質の評価](https://agentskills.io/skill-creation/evaluating-skills)**：agentskills.io の eval ファイル形式と反復ワークフロー
* **[スキル作成のベストプラクティス](https://platform.claude.com/docs/en/agents-and-tools/agent-skills/best-practices)**：Claude 製品全体に適用される作成ガイダンス
* **[サブエージェント](https://code.claude.com/docs/ja/sub-agents.md)**：特化したエージェントにタスクを委任する
* **[プラグイン](https://code.claude.com/docs/ja/plugins/overview.md)**：他の拡張機能でスキルをパッケージ化して配布する
* **[フック](https://code.claude.com/docs/ja/hooks.md)**：ツールイベント周辺のワークフローを自動化する
* **[メモリ](https://code.claude.com/docs/ja/memory.md)**：永続的なコンテキストのための CLAUDE.md ファイルを管理する
* **[コマンド](https://code.claude.com/docs/ja/commands.md)**：組み込みコマンドとバンドルされたスキルのリファレンス
* **[権限](https://code.claude.com/docs/ja/permissions.md)**：ツールとスキルアクセスを制御する
* **[Claude Tag スキル](https://claude.com/docs/claude-tag/admins/skills-repo)**：リポジトリにコミットされたプロジェクトスキルは、そのリポジトリが Claude Tag チャネルで使用される場合にも読み込まれます
