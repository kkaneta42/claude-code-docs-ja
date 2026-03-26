> ## Documentation Index
> Fetch the complete documentation index at: https://code.claude.com/docs/llms.txt
> Use this file to discover all available pages before exploring further.

# 組み込みコマンド

> Claude Code で利用可能な組み込みコマンドの完全なリファレンス。

Claude Code で `/` と入力すると、利用可能なすべてのコマンドが表示されます。または `/` の後に任意の文字を入力してフィルタリングできます。すべてのコマンドがすべてのユーザーに表示されるわけではありません。プラットフォーム、プラン、または環境によって異なります。たとえば、`/desktop` は macOS と Windows にのみ表示され、`/upgrade` と `/privacy-settings` は Pro プランと Max プランでのみ利用可能で、`/terminal-setup` はターミナルがネイティブにキーバインディングをサポートしている場合は非表示になります。

Claude Code には、`/` と入力したときに組み込みコマンドと一緒に表示される `/simplify`、`/batch`、`/debug`、`/loop` などの[バンドルされたスキル](/ja/skills#bundled-skills)も含まれています。独自のコマンドを作成するには、[スキル](/ja/skills)を参照してください。

以下の表では、`<arg>` は必須引数を示し、`[arg]` はオプション引数を示します。

| コマンド                                     | 目的                                                                                                                                                                                         |
| :--------------------------------------- | :----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `/add-dir <path>`                        | 現在のセッションに新しい作業ディレクトリを追加                                                                                                                                                                    |
| `/agents`                                | [エージェント](/ja/sub-agents)設定を管理                                                                                                                                                              |
| `/btw <question>`                        | 会話に追加せずに[サイドクエスチョン](/ja/interactive-mode#side-questions-with-btw)として素早く質問                                                                                                                  |
| `/chrome`                                | [Chrome の Claude](/ja/chrome)設定を構成                                                                                                                                                         |
| `/clear`                                 | 会話履歴をクリアしてコンテキストを解放。エイリアス: `/reset`、`/new`                                                                                                                                                 |
| `/color [color\|default]`                | 現在のセッションのプロンプトバーの色を設定。利用可能な色: `red`、`blue`、`green`、`yellow`、`purple`、`orange`、`pink`、`cyan`。`default` を使用してリセット                                                                            |
| `/compact [instructions]`                | オプションのフォーカス指示付きで会話をコンパクト化                                                                                                                                                                  |
| `/config`                                | [設定](/ja/settings)インターフェースを開いて、テーマ、モデル、[出力スタイル](/ja/output-styles)、およびその他の設定を調整。エイリアス: `/settings`                                                                                         |
| `/context`                               | 現在のコンテキスト使用状況をカラーグリッドとして視覚化。コンテキストが多いツール、メモリ肥大化、容量警告の最適化提案を表示                                                                                                                              |
| `/copy [N]`                              | 最後のアシスタント応答をクリップボードにコピー。数字 `N` を渡して N 番目に新しい応答をコピー: `/copy 2` は 2 番目に新しい応答をコピー。コードブロックが存在する場合、個別ブロックまたは完全な応答を選択するインタラクティブピッカーを表示。ピッカーで `w` を押して、クリップボードの代わりにファイルに選択内容を書き込み。SSH 経由で便利       |
| `/cost`                                  | トークン使用統計を表示。サブスクリプション固有の詳細については、[コスト追跡ガイド](/ja/costs#using-the-cost-command)を参照                                                                                                            |
| `/desktop`                               | 現在のセッションを Claude Code デスクトップアプリで続行。macOS と Windows のみ。エイリアス: `/app`                                                                                                                        |
| `/diff`                                  | コミットされていない変更と各ターンの diff を表示するインタラクティブ diff ビューアを開く。左右矢印を使用して現在の git diff と個別の Claude ターンを切り替え、上下矢印でファイルをブラウズ                                                                               |
| `/doctor`                                | Claude Code のインストールと設定を診断および検証                                                                                                                                                             |
| `/effort [low\|medium\|high\|max\|auto]` | モデルの[努力レベル](/ja/model-config#adjust-effort-level)を設定。`low`、`medium`、`high` はセッション間で保持されます。`max` は現在のセッションにのみ適用され、Opus 4.6 が必要です。`auto` はモデルのデフォルトにリセット。引数なしで現在のレベルを表示。現在の応答の完了を待たずに即座に有効   |
| `/exit`                                  | CLI を終了。エイリアス: `/quit`                                                                                                                                                                     |
| `/export [filename]`                     | 現在の会話をプレーンテキストとしてエクスポート。ファイル名を指定すると、そのファイルに直接書き込み。指定しない場合、クリップボードにコピーするか、ファイルに保存するダイアログを開く                                                                                                 |
| `/extra-usage`                           | レート制限に達したときに作業を続行するための追加使用量を構成                                                                                                                                                             |
| `/fast [on\|off]`                        | [高速モード](/ja/fast-mode)のオン/オフを切り替え                                                                                                                                                          |
| `/feedback [report]`                     | Claude Code に関するフィードバックを送信。エイリアス: `/bug`                                                                                                                                                   |
| `/branch [name]`                         | この時点で現在の会話のブランチを作成。エイリアス: `/fork`                                                                                                                                                          |
| `/help`                                  | ヘルプと利用可能なコマンドを表示                                                                                                                                                                           |
| `/hooks`                                 | ツールイベント用の[フック](/ja/hooks)設定を表示                                                                                                                                                             |
| `/ide`                                   | IDE 統合を管理し、ステータスを表示                                                                                                                                                                        |
| `/init`                                  | `CLAUDE.md` ガイドでプロジェクトを初期化。スキル、フック、個人メモリファイルをウォークスルーするインタラクティブフローについては、`CLAUDE_CODE_NEW_INIT=true` を設定                                                                                     |
| `/insights`                              | Claude Code セッションを分析するレポートを生成。プロジェクト領域、相互作用パターン、および摩擦点を含む                                                                                                                                  |
| `/install-github-app`                    | リポジトリ用の [Claude GitHub Actions](/ja/github-actions) アプリをセットアップ。リポジトリを選択して統合を構成するプロセスをガイド                                                                                                   |
| `/install-slack-app`                     | Claude Slack アプリをインストール。OAuth フローを完了するためにブラウザを開く                                                                                                                                           |
| `/keybindings`                           | キーバインディング設定ファイルを開くか作成                                                                                                                                                                      |
| `/login`                                 | Anthropic アカウントにサインイン                                                                                                                                                                      |
| `/logout`                                | Anthropic アカウントからサインアウト                                                                                                                                                                    |
| `/mcp`                                   | MCP サーバー接続と OAuth 認証を管理                                                                                                                                                                    |
| `/memory`                                | `CLAUDE.md` メモリファイルを編集し、[自動メモリ](/ja/memory#auto-memory)を有効または無効にし、自動メモリエントリを表示                                                                                                             |
| `/mobile`                                | Claude モバイルアプリをダウンロードするための QR コードを表示。エイリアス: `/ios`、`/android`                                                                                                                              |
| `/model [model]`                         | AI モデルを選択または変更。サポートしているモデルの場合、左右矢印を使用して[努力レベルを調整](/ja/model-config#adjust-effort-level)。変更は現在の応答の完了を待たずに即座に有効                                                                              |
| `/passes`                                | Claude Code の無料 1 週間を友人と共有。アカウントが対象の場合のみ表示                                                                                                                                                 |
| `/permissions`                           | [権限](/ja/permissions#manage-permissions)を表示または更新。エイリアス: `/allowed-tools`                                                                                                                   |
| `/plan [description]`                    | プロンプトから直接 Plan Mode に入る。オプションの説明を渡して Plan Mode に入り、すぐにそのタスクで開始。例: `/plan fix the auth bug`                                                                                                 |
| `/plugin`                                | Claude Code [プラグイン](/ja/plugins)を管理                                                                                                                                                        |
| `/pr-comments [PR]`                      | GitHub プルリクエストからコメントを取得して表示。現在のブランチの PR を自動検出するか、PR URL または番号を渡す。`gh` CLI が必要                                                                                                              |
| `/privacy-settings`                      | プライバシー設定を表示および更新。Pro および Max プランサブスクライバーのみ利用可能                                                                                                                                             |
| `/release-notes`                         | 完全な変更ログを表示。最新バージョンがプロンプトに最も近い位置に表示                                                                                                                                                         |
| `/reload-plugins`                        | すべてのアクティブな[プラグイン](/ja/plugins)を再読み込みして、再起動せずに保留中の変更を適用。読み込まれた各コンポーネントのカウントを報告し、読み込みエラーをフラグ                                                                                                 |
| `/remote-control`                        | このセッションを claude.ai から[リモートコントロール](/ja/remote-control)できるようにする。エイリアス: `/rc`                                                                                                                 |
| `/remote-env`                            | [`--remote` で開始されたウェブセッション](/ja/claude-code-on-the-web#environment-configuration)のデフォルトリモート環境を構成                                                                                           |
| `/rename [name]`                         | 現在のセッションの名前を変更してプロンプトバーに名前を表示。名前を指定しない場合、会話履歴から自動生成                                                                                                                                        |
| `/resume [session]`                      | ID または名前で会話を再開するか、セッションピッカーを開く。エイリアス: `/continue`                                                                                                                                          |
| `/review`                                | 非推奨。代わりに [`code-review` プラグイン](https://github.com/anthropics/claude-code-marketplace/blob/main/code-review/README.md) をインストール: `claude plugin install code-review@claude-code-marketplace` |
| `/rewind`                                | 会話またはコードを前の時点に巻き戻すか、選択したメッセージから要約。[チェックポイント](/ja/checkpointing)を参照。エイリアス: `/checkpoint`                                                                                                    |
| `/sandbox`                               | [サンドボックスモード](/ja/sandboxing)を切り替え。サポートされているプラットフォームでのみ利用可能                                                                                                                                 |
| `/schedule [description]`                | [クラウドスケジュール済みタスク](/ja/web-scheduled-tasks)を作成、更新、リスト表示、または実行。Claude がセットアップを会話形式でガイド                                                                                                       |
| `/security-review`                       | 現在のブランチの保留中の変更をセキュリティ脆弱性について分析。git diff をレビューし、インジェクション、認証の問題、データ露出などのリスクを特定                                                                                                               |
| `/skills`                                | 利用可能な[スキル](/ja/skills)をリスト表示                                                                                                                                                               |
| `/stats`                                 | 日次使用状況、セッション履歴、ストリーク、およびモデル設定を視覚化                                                                                                                                                          |
| `/status`                                | 設定インターフェース（ステータスタブ）を開いて、バージョン、モデル、アカウント、および接続性を表示。Claude が応答中でも機能し、現在の応答の完了を待たない                                                                                                           |
| `/statusline`                            | Claude Code の[ステータスライン](/ja/statusline)を構成。必要な内容を説明するか、引数なしで実行してシェルプロンプトから自動構成                                                                                                             |
| `/stickers`                              | Claude Code ステッカーを注文                                                                                                                                                                       |
| `/tasks`                                 | バックグラウンドタスクをリストおよび管理                                                                                                                                                                       |
| `/terminal-setup`                        | Shift+Enter およびその他のショートカットのターミナルキーバインディングを構成。VS Code、Alacritty、Warp などの必要なターミナルでのみ表示                                                                                                       |
| `/theme`                                 | カラーテーマを変更。ライトおよびダークバリアント、色覚異常対応（ダルトン化）テーマ、およびターミナルのカラーパレットを使用する ANSI テーマを含む                                                                                                                |
| `/upgrade`                               | アップグレードページを開いて、より高いプランティアに切り替え                                                                                                                                                             |
| `/usage`                                 | プラン使用制限とレート制限ステータスを表示                                                                                                                                                                      |
| `/vim`                                   | Vim モードと通常編集モード間を切り替え                                                                                                                                                                      |
| `/voice`                                 | プッシュトゥトーク[音声ディクテーション](/ja/voice-dictation)を切り替え。Claude.ai アカウントが必要                                                                                                                         |

## MCP プロンプト

MCP サーバーはコマンドとして表示されるプロンプトを公開できます。これらは `/mcp__<server>__<prompt>` 形式を使用し、接続されたサーバーから動的に検出されます。詳細については、[MCP プロンプト](/ja/mcp#use-mcp-prompts-as-commands)を参照してください。

## 関連項目

* [スキル](/ja/skills): 独自のコマンドを作成
* [インタラクティブモード](/ja/interactive-mode): キーボードショートカット、Vim モード、およびコマンド履歴
* [CLI リファレンス](/ja/cli-reference): 起動時フラグ
