> ## Documentation Index
> Fetch the complete documentation index at: https://code.claude.com/docs/llms.txt
> Use this file to discover all available pages before exploring further.

# Claude Code 用にターミナルを設定する

> Shift+Enter で改行を挿入する、Claude の処理完了時にターミナルベルを鳴らす、tmux を設定する、カラーテーマを合わせる、Claude Code CLI で Vim モードを有効にする方法を説明します。

Claude Code はターミナル設定なしで任意のターミナルで動作します。このページは、特定の動作が期待通りに機能していない場合のためのものです。以下から症状を見つけてください。すべてが既に正常に動作している場合は、このページは不要です。

* [Shift+Enter が改行を挿入する代わりに送信する](#enter-multiline-prompts)
* [macOS でオプションキーのショートカットが機能しない](#enable-option-key-shortcuts-on-macos)
* [Claude の処理完了時に音またはアラートが出ない](#get-a-terminal-bell-or-notification)
* [Claude Code を tmux 内で実行している](#configure-tmux)
* [Windows でバックスペースが単語全体を削除する](#fix-backspace-deleting-a-whole-word-on-windows)
* [表示がちらつくまたはスクロールバックがジャンプする](#switch-to-fullscreen-rendering)
* [プロンプトで Vim キーを使いたい](#edit-prompts-with-vim-keybindings)

このページは、ターミナルが Claude Code に正しい信号を送信するようにするためのものです。Claude Code 自体が応答するキーを変更するには、代わりに [キーバインディング](https://code.claude.com/docs/ja/keybindings.md) を参照してください。

## 複数行のプロンプトを入力する

Enter キーを押すとメッセージが送信されます。送信せずに改行を追加するには、Ctrl+J を押すか、`\` を入力してから Enter を押してください。どちらの方法もセットアップなしですべてのターミナルで機能します。

ほとんどのターミナルでは Shift+Enter を押すこともできますが、サポートはターミナルエミュレータによって異なります。

| ターミナル | 改行用の Shift+Enter |
| :- | :- |
| Ghostty、Kitty、iTerm2、WezTerm、Warp、Apple Terminal、Windows Terminal | セットアップなしで機能 |
| kitty キーボードプロトコルをサポートする他のターミナル（foot や Alacritty 0.16 以降など） | セットアップなしで機能。Claude Code v2.1.269 以降が必要です |
| VS Code、Cursor、Devin Desktop、Alacritty 0.16 より前のバージョン、Zed | 1 回 `/terminal-setup` を実行 |
| gnome-terminal、PyCharm や Android Studio などの JetBrains IDE | 利用不可。Ctrl+J または `\` の後に Enter を使用 |

VS Code、Cursor、Devin Desktop、Alacritty 0.16 より前のバージョン、Zed の場合、`/terminal-setup` はターミナルの設定ファイルに Shift+Enter キーバインディングを書き込みます。初回実行時には `Installed VSCode terminal Shift+Enter key binding` などの確認メッセージが表示されます。既存のバインディングはそのまま保持されます。`VSCode terminal Shift+Enter key binding already configured` などのメッセージが表示される場合は、変更は加えられていません。`/terminal-setup` は tmux または screen の内部ではなく、ホストターミナル内で直接実行してください。ホストターミナルの設定に書き込む必要があるためです。

VS Code、Cursor、Devin Desktop では、`/terminal-setup` は 2 つのエディタ設定も更新します。統合ターミナルでのテキストの乱れを防ぐために `terminal.integrated.gpuAcceleration` を `"off"` に設定し、[フルスクリーンモード](https://code.claude.com/docs/ja/fullscreen.md)でのスムーズなスクロールのために `terminal.integrated.mouseWheelScrollSensitivity` を設定します。GPU アクセラレーション変更を元に戻すには、`"auto"` に設定し直してエディタウィンドウをリロードしてください。

Zed では、`/terminal-setup` は `keymap.json` をその場で更新します。

* キーマップに既にバインディングがあり、そのいずれもターミナルの `shift-enter` ではない場合、Claude Code はまずそれを同じディレクトリ内のコピー（`keymap.json.1a2b3c4d.bak` など）にバックアップしてから、Shift+Enter バインディングをキーマップにマージし、他のキーバインディングとコメントを保持します
* Claude Code がキーマップを読み込めない、解析できない、バックアップできない、またはマージされた結果を検証できない場合、[ファイルを変更せず、追加するキーバインディングブロックを出力します](https://code.claude.com/docs/ja/errors.md#terminal-setup-left-your-zed-keymap-unchanged)

tmux 内で実行している場合、外側のターミナルがサポートしている場合でも、Shift+Enter には以下の [tmux 設定](#configure-tmux)が必要です。

改行を別のキーにバインドするか、Enter が改行を挿入し Shift+Enter が送信するように動作を入れ替えるには、[キーバインディングファイル](https://code.claude.com/docs/ja/keybindings.md)で `chat:newline` および `chat:submit` アクションをマップしてください。

## macOS で Option キーショートカットを有効にする

Claude Code の一部のショートカットは Option キーを使用します。例えば、Option+Enter で改行したり、Option+P でモデルを切り替えたりします。macOS では、ほとんどのターミナルはデフォルトで Option を修飾キーとして送信しないため、これを有効にするまでこれらのショートカットは機能しません。ターミナル設定は通常「Use Option as Meta Key」というラベルが付いています。Meta は、現在 Option または Alt というラベルが付いているキーの歴史的な Unix 名です。

**Apple Terminal**

設定 → プロファイル → キーボードを開き、「Use Option as Meta Key」をチェックします。

Claude Code の初回実行時のターミナルセットアッププロンプトを受け入れた場合、これはすでに完了しています。そのプロンプトは `/terminal-setup` を実行し、Option を Meta として有効にし、Apple Terminal プロファイルで可聴ベルをオフにします。

[スクリーンリーダーモード](https://code.claude.com/docs/ja/accessibility.md)では、`/terminal-setup` はベル設定を変更しないままにするため、ターミナルベルは可聴のままです。以前の実行でベルがオフになった場合は、設定 → プロファイル → 詳細 → 「可聴ベル」でオンに戻してください。

**iTerm2**

設定 → プロファイル → キー → 一般を開き、左 Option キーと右 Option キーを「Esc+」に設定します。

iTerm2 で `/terminal-setup` を実行すると、設定 → 一般 → 選択の下で「Applications in terminal may access clipboard」が有効になり、`/copy` コマンドがシステムクリップボードに書き込むことができます。このコマンドは tmux 内から実行された場合でも iTerm2 を検出します。変更を有効にするために iTerm2 を再起動してください。

**VS Code**

VS Code 設定に `"terminal.integrated.macOptionIsMeta": true` を追加します。

Ghostty、Kitty、およびその他のターミナルについては、ターミナルの設定ファイルで Option-as-Alt または Option-as-Meta 設定を探してください。

## ターミナルベルまたは通知を取得する

Claude がタスクを完了するか権限プロンプトで一時停止し、ターミナルから離れているように見える場合、通知イベントが発火します。[各通知タイプが発火するタイミング](https://code.claude.com/docs/ja/hooks.md#notification)を参照して、正確なタイミングを確認してください。これをターミナルベルまたはデスクトップ通知として表示することで、長いタスクが実行されている間に他の作業に切り替えることができます。

デフォルトでは、Claude Code は一部のターミナルではデスクトップ通知を送信し、それ以外のターミナルではベル文字を送信するか、何も送信しません：

* **Ghostty、Kitty、および iTerm2**：デスクトップ通知を送信します。iTerm2 では、アラート設定をオンにした後にのみ表示されます。
* **Apple Terminal**：音は鳴りません。Claude Code が最前面の Terminal ウィンドウのプロファイルで「Audible bell」がオフになっていることを検出した場合は無音のベル文字を送信し、それ以外の場合は何も送信しません。このベル文字は、そのプロファイルの「Visual bell」または Dock のバウンスオプションがオンになっている場合、ウィンドウのフラッシュとして、または Terminal がバックグラウンドにあるときは Dock アイコンのバウンスとして表示されます。
* **その他のターミナル**：何も送信しません。

ターミナルやプロファイルに関係なく Claude Code にベル文字を送信させるには、[`preferredNotifChannel`](https://code.claude.com/docs/ja/settings-reference#preferrednotifchannel) を `"terminal_bell"` に設定します。Apple Terminal では、音を聞くために **Settings > Profiles > Advanced** で **Audible bell** もオンにしてください。次の設定エントリでチャネルを設定します：

```json ~/.claude/settings.json theme={null}
{
  "preferredNotifChannel": "terminal_bell"
}
```

デスクトップ通知は SSH 経由でローカルマシンに到達するため、リモートセッションでもアラートを受け取ることができます。Ghostty と Kitty はさらなるセットアップなしで OS 通知センターに転送します。iTerm2 では転送を有効にする必要があります：

**1. Open iTerm2 notification settings**

Go to Settings → Profiles → Terminal.

**2. Enable alerts**

Check "Notification Center Alerts", then click "Filter Alerts" and enable "Send escape sequence-generated alerts".

通知がまだ表示されない場合は、ターミナルアプリケーションが OS 設定で通知権限を持っていることを確認し、tmux 内で実行している場合は[パススルーを有効にしてください](#configure-tmux)。

### 通知フックで音を再生する

任意のターミナルで[通知フック](https://code.claude.com/docs/ja/hooks-guide.md#get-notified-when-claude-needs-input)を設定して、Claude があなたの注意が必要な場合に音を再生するか、カスタムコマンドを実行できます。フックは組み込み通知と並行して実行され、それを置き換えるのではなく、Warp や VS Code 統合ターミナルなどのデスクトップ通知を受け取らないターミナルは、フックを使用するか、代わりに`preferredNotifChannel`を`"terminal_bell"`に設定できます。

以下の例は macOS でシステム音を再生します。リンクされたガイドには、macOS、Linux、および Windows のデスクトップ通知コマンドがあります。

```json ~/.claude/settings.json theme={null}
{
  "hooks": {
    "Notification": [
      {
        "hooks": [{ "type": "command", "command": "afplay /System/Library/Sounds/Glass.aiff" }]
      }
    ]
  }
}
```

## ターミナルでセッションのステータスを確認する

ターミナルが OSC 7501 Program Status Protocol を実装している場合、対話型の各 Claude Code セッションが作業中か、ユーザーの応答待ちか、完了したかを表示できます。これは、長時間のタスクを実行する場合や複数のセッションを同時に実行する場合に役立ちます。Claude Code 側でオンにする設定はありません。ターミナルがこのプロトコルを実装しているかどうか、またどこにステータスが表示されるかについては、ターミナルのドキュメントを確認してください。

ターミナルがプロトコルを実装しているにもかかわらず、セッションのステータスが表示されない場合は、次の各原因を確認してください。

* **Claude Code のバージョン**：ステータスの報告には Claude Code v2.1.295 以降が必要です。シェルで `claude --version` を実行して確認してください。
* **tmux**：tmux 内では、Claude Code はターミナルではなく tmux に対してサポートの有無を確認します。また、[`allow-passthrough`](#configure-tmux) はこの確認には影響しません。tmux の外でセッションを開始してください。
* **バックグラウンドセッション**：[バックグラウンドセッション](https://code.claude.com/docs/ja/agent-view.md)は、アタッチしている間であっても、ターミナルにステータスを報告しません。代わりにエージェントビューにステータスが表示されます。
* **[`CLAUDE_CODE_DISABLE_TERMINAL_TITLE`](https://code.claude.com/docs/ja/env-vars#variables)**：この変数を `1` に設定している場合、Claude Code はサポートの有無を確認せず、ステータスも報告しません。この変数の設定を解除してください。

プロトコルのサポートを報告するターミナルでは、タブのタイトルの先頭にステータスのグリフは付きません。ターミナル自体がセッションの状態を表示するため、Claude Code は他のターミナルでタイトルの前に付けるグリフを省略します。

## tmux を設定する

Claude Code が tmux 内で実行される場合、デフォルトでは Shift+Enter が改行を挿入する代わりに送信してしまい、デスクトップ通知と[プログレスバー](https://code.claude.com/docs/ja/settings-reference.md#terminalprogressbarenabled)が外側のターミナルに到達しません。これらの行を `~/.tmux.conf` に追加してから、`tmux source-file ~/.tmux.conf` を実行して、実行中のサーバーに適用してください。

```bash ~/.tmux.conf theme={null}
set -g allow-passthrough on
set -g focus-events on
set -s extended-keys on
set -as terminal-features 'xterm*:extkeys'
```

`allow-passthrough` 行により、通知とプログレス更新が tmux に飲み込まれるのではなく、外側のターミナルに到達できるようになります。`extended-keys` 行により、tmux が Shift+Enter と通常の Enter を区別できるようになり、改行ショートカットが機能するようになります。

[mod の `Image`](https://code.claude.com/docs/ja/plugins/mods/reference#elements) には、`allow-passthrough` 行と `focus-events` 行に加えて、その他の [tmux 内で描画するための要件](https://code.claude.com/docs/ja/plugins/mods/gallery.md#draw-an-image-inside-tmux)が必要です。これらの行を追加した後は、tmux からデタッチして再度アタッチし、Claude Code を再起動してください。

## Windows で Backspace がワード全体を削除する問題を修正する

Windows では、Claude Code は Backspace として到着した `^H` を Ctrl+Backspace として読み込み、[前のワードを削除します](https://code.claude.com/docs/ja/interactive-mode.md#text-editing)。ただし、`TERM_PROGRAM` が `mintty` または `TERM` が `cygwin` の場合は除きます。macOS と Linux では、Claude Code はこれをプレーン Backspace として読み込みます。

Backspace を押すたびにワード全体が削除される場合、ターミナルはプレーン Backspace に対して `^H` を送信しています。[`CLAUDE_CODE_BS_AS_CTRL_BACKSPACE=0`](https://code.claude.com/docs/ja/env-vars) を設定してください。その後、Backspace と Ctrl+H は各々 1 文字を削除します。macOS または Linux で Ctrl+Backspace が 1 文字だけを削除する場合、ターミナルが `^H` を送信しているため、代わりに変数を `1` に設定してください。

## カラーテーマを合わせる

`/theme` コマンド、または `/config` 内のテーマピッカーを使用して、ターミナルに合う Claude Code のテーマを選択します。auto オプションを選択すると、ターミナルのライトまたはダークの背景が検出されるため、ターミナルが OS の外観の変更に追従するたびにテーマも追従します。Claude Code はターミナル自体の配色を制御しません。配色はターミナルアプリケーションによって設定されます。

インターフェースの下部に表示される内容をカスタマイズするには、現在のモデル、作業ディレクトリ、git ブランチ、またはその他のコンテキストを表示する[カスタムステータスライン](https://code.claude.com/docs/ja/statusline.md)を設定します。

### カスタムテーマを作成する

組み込みのプリセットに加えて、`/theme` には定義済みのカスタムテーマと、インストール済みの[プラグイン](https://code.claude.com/docs/ja/plugins/components.md#themes-and-output-styles)が提供するテーマが一覧表示されます。リストの末尾にある **New custom theme…** を選択すると、対話形式でテーマを作成できます。テーマに名前を付けてから、上書きする個々のカラートークンを選択します。カスタムテーマがハイライトされている状態で `Ctrl+E` を押すと、そのテーマを編集できます。

各カスタムテーマは `~/.claude/themes/` 内の JSON ファイルです。`.json` 拡張子を除いたファイル名がテーマのスラッグとなり、テーマを選択するとテーマ設定として `custom:<slug>` が保存されます。ファイルには 3 つのオプションフィールドがあります。

| フィールド | 型 | 説明 |
| :- | :- | :- |
| `name` | string | `/theme` に表示される表示ラベル。デフォルトはファイル名のスラッグです |
| `base` | string | テーマのベースとなる組み込みプリセット：`dark`、`light`、`dark-daltonized`、`light-daltonized`、`dark-ansi`、または `light-ansi`。デフォルトは `dark` です |
| `overrides` | object | カラートークン名とカラー値のマップ。ここに記載されていないトークンはベースプリセットの値が使用されます |

カラー値には `#rrggbb`、`#rgb`、`rgb(r,g,b)`、`ansi256(n)`、または `ansi:<name>` を指定できます。`<name>` は `red` や `cyanBright` などの 16 種類の標準 ANSI カラー名のいずれかです。不明なトークンや無効なカラー値は無視されるため、タイプミスによって表示が壊れることはありません。

次の例では、dark プリセットを維持しつつ、プロンプトのアクセント、エラーテキスト、成功テキストの色を変更するテーマを定義しています。

```json ~/.claude/themes/dracula.json theme={null}
{
  "name": "Dracula",
  "base": "dark",
  "overrides": {
    "claude": "#bd93f9",
    "error": "#ff5555",
    "success": "#50fa7b"
  }
}
```

Claude Code は `~/.claude/themes/` を監視しており、ファイルが追加または変更されると再読み込みするため、エディターで行った編集は再起動なしで実行中のセッションに適用されます。Claude Code の起動時に `~/.claude/themes/` フォルダー自体が存在しなかった場合は、最初のテーマファイルを作成した後に一度再起動してください。それ以降は、変更が再起動なしで適用されます。

以下のリファレンスでは、`overrides` で設定できるトークンについて説明します。`/theme` の対話型エディターでは、同じトークンがライブプレビュー付きで表示されるほか、ここでは省略しているオンボーディング画面の色などの単一用途のアクセントもいくつか表示されます。

> **カラートークンリファレンス**
>
> 次の例では、以下のいくつかのグループのトークンを組み合わせています：ブランドアクセント、plan モードの枠線、差分の背景、メッセージの背景です。
>
> ```json ~/.claude/themes/midnight.json theme={null}
> {
>   "name": "Midnight",
>   "base": "dark",
>   "overrides": {
>     "claude": "#a78bfa",
>     "planMode": "#38bdf8",
>     "diffAdded": "#14532d",
>     "diffRemoved": "#7f1d1d",
>     "userMessageBackground": "#1e1b4b"
>   }
> }
> ```
>
> #### テキストとアクセントの色
>
> インターフェース全体で使用される主要なブランドアクセントと前景テキストの色合いを制御します。
>
> | トークン | 制御対象 |
> | :- | :- |
> | `claude` | 主要なブランドアクセント。スピナーとアシスタントラベルに使用されます |
> | `text` | デフォルトの前景テキスト |
> | `inverseText` | ステータスバッジなど、色付きの背景の上に描画されるテキスト |
> | `inactive` | ヒント、タイムスタンプ、無効な項目などの補助テキスト |
> | `subtle` | 薄い枠線と目立たない補助テキスト |
> | `suggestion` | オートコンプリートの候補とピッカー内の選択ハイライト |
> | `permission` | 権限プロンプトやピッカーを含むダイアログの枠線 |
> | `remember` | メモリと `CLAUDE.md` のインジケーター |
>
> #### ステータスの色
>
> メッセージやインジケーター全体で、成功、失敗、警告の状態を示します。
>
> | トークン | 制御対象 |
> | :- | :- |
> | `success` | 成功メッセージと合格したチェック |
> | `error` | エラーメッセージと失敗 |
> | `warning` | 警告、注意メッセージ、auto モードのインジケーター |
> | `merged` | マージ済みのプルリクエストのステータス |
>
> #### 入力ボックスとモードインジケーター
>
> 入力ボックスの枠線の色と、権限モードまたはインジケーターがアクティブな間に表示されるアクセントを設定します。
>
> | トークン | 制御対象 |
> | :- | :- |
> | `promptBorder` | 入力ボックスの枠線 |
> | `planMode` | plan モードのアクセント、plan メッセージ、plan モードのダイアログ |
> | `autoAccept` | accept-edits モードのアクセント |
> | `bashBorder` | `!` シェルコマンドを入力しているときの入力ボックスの枠線 |
> | `ide` | IDE 接続インジケーター |
> | `fastMode` | fast mode インジケーター |
> | `effortUltra` | [ultracode](https://code.claude.com/docs/ja/model-config.md#adjust-effort-level) がオンの間、入力ボックスの枠線に表示される `ultracode` タグ。この色の上書きは Claude Code v2.1.239 以降で有効になります |
>
> #### 差分の表示
>
> ファイル編集やレビューで追加および削除されたコードに色を付けます。
>
> | トークン | 制御対象 |
> | :- | :- |
> | `diffAdded` | 追加された行の背景 |
> | `diffRemoved` | 削除された行の背景 |
> | `diffAddedDimmed` | 編集を拒否した後に表示される淡色表示の差分における、追加された行の背景 |
> | `diffRemovedDimmed` | 編集を拒否した後に表示される淡色表示の差分における、削除された行の背景 |
> | `diffAddedWord` | 追加された行内の単語レベルのハイライト |
> | `diffRemovedWord` | 削除された行内の単語レベルのハイライト |
>
> #### フルスクリーンモード
>
> Claude Code は、`userMessageBackgroundHover`、`selectionBg`、`composerSidebarBackground` を[フルスクリーンレンダリングモード](https://code.claude.com/docs/ja/fullscreen.md)でのみ使用します。`userMessageBackground`、`bashMessageBackgroundColor`、`memoryBackgroundColor` は、デフォルトとフルスクリーンの両方のレンダラーで描画されます。
>
> | トークン | 制御対象 |
> | :- | :- |
> | `userMessageBackground` | トランスクリプト内のユーザーのメッセージの背景 |
> | `userMessageBackgroundHover` | ホバー中または展開中のメッセージの背景 |
> | `bashMessageBackgroundColor` | トランスクリプト内の `!` シェルコマンドエントリの背景 |
> | `memoryBackgroundColor` | トランスクリプト内の `#` メモリエントリの背景 |
> | `selectionBg` | マウスで選択したテキストの背景 |
> | `composerSidebarBackground` | [差分パネル](https://code.claude.com/docs/ja/fullscreen.md#watch-your-changes-in-the-diff-panel)や [mod のペイン](https://code.claude.com/docs/ja/plugins/mods/interface.md)など、会話の横にあるパネルの背景 |
>
> #### 使用量メーターと話者ラベル
>
> `/usage` ビューに表示されるバーと、ユーザーのメッセージと Claude のメッセージを区別するラベルを調整します。
>
> | トークン | 制御対象 |
> | :- | :- |
> | `rate_limit_fill` | 使用量メーターの塗りつぶされた部分 |
> | `rate_limit_empty` | 使用量メーターの塗りつぶされていない部分 |
> | `briefLabelYou` | ユーザーのメッセージに付く `You` ラベルの色 |
> | `briefLabelClaude` | アシスタントのメッセージに付く `Claude` ラベルの色 |
>
> #### シマーのバリアントとサブエージェントの色
>
> いくつかのトークンには対になるシマーのバリアントがあり、スピナーのアニメーショングラデーションで使用される明るい色を提供します。アニメーションの色が合わない場合は、ベーストークンと合わせてシマーも上書きしてください。
>
> * `claude` と `claudeShimmer`
> * `warning` と `warningShimmer`
> * `permission` と `permissionShimmer`
> * `promptBorder` と `promptBorderShimmer`
> * `inactive` と `inactiveShimmer`
> * `fastMode` と `fastModeShimmer`
>
> 各[サブエージェント](https://code.claude.com/docs/ja/sub-agents.md)と並列タスクは、トランスクリプト内で区別できるように 8 つの名前付きカラーのいずれかで表示されます。トークン名は `<color>_FOR_SUBAGENTS_ONLY` というパターンに従い、`<color>` は `red`、`blue`、`green`、`yellow`、`purple`、`orange`、`pink`、または `cyan` です。これらを上書きすると、各名前付きカラーの見た目を変更できます。たとえば、定義に `color: blue` を持つサブエージェントは、`blue_FOR_SUBAGENTS_ONLY` の値を使用して描画されます。
>
> [`ultrathink`](https://code.claude.com/docs/ja/model-config#use-ultrathink-for-one-off-deep-reasoning) がターンの effort を引き上げられる場合、Claude Code はプロンプト入力内のその単語を 7 色の虹色グラデーションで表示します。トークン名は `rainbow_<color>` および `rainbow_<color>_shimmer` というパターンに従い、`<color>` は `red`、`orange`、`yellow`、`green`、`blue`、`indigo`、または `violet` です。

## フルスクリーンレンダリングに切り替える

[スクリーンリーダーモード](https://code.claude.com/docs/ja/accessibility.md)では、このセクションは適用されません。Claude Code は、添付された[バックグラウンドセッション](https://code.claude.com/docs/ja/agent-view.md)を除き、常にプレーンなスクロールテキストとしてレンダリングされます。また、他のセッションで `/tui fullscreen` を実行した場合、Claude Code はレンダラーを切り替える代わりに説明を出力します。

ディスプレイがちらつくか、Claude が作業中にスクロール位置がジャンプする場合は、[フルスクリーンレンダリングモード](https://code.claude.com/docs/ja/fullscreen.md)に切り替えてください。このモードでは、ターミナルのネイティブスクロールバックではなく、マウスまたは PageUp を使用して Claude Code 内でスクロールします。検索とコピーの方法については、[フルスクリーンページ](https://code.claude.com/docs/ja/fullscreen.md#search-and-review-the-conversation)を参照してください。

ちらつきが唯一の問題で、ターミナルが同期出力をサポートしているが自動検出されていない場合（Emacs `eat` など）、[`CLAUDE_CODE_FORCE_SYNC_OUTPUT=1`](https://code.claude.com/docs/ja/env-vars)を設定して、レンダラーを変更せずにちらつきを停止します。

`/tui fullscreen` を実行して切り替え、設定を保存します。会話はそのまま再起動され、[フルスクリーン開始に失敗](https://code.claude.com/docs/ja/fullscreen.md#fullscreen-renderer-didnt-finish-starting)しない限り、今後のセッションはフルスクリーンで開始されます。Claude Code を起動する前に、`CLAUDE_CODE_NO_FLICKER` 環境変数を設定することもできます。

```bash Bash and Zsh theme={null}
CLAUDE_CODE_NO_FLICKER=1 claude
```

```powershell PowerShell theme={null}
$env:CLAUDE_CODE_NO_FLICKER = "1"; claude
```

```json ~/.claude/settings.json theme={null}
{
  "env": {
    "CLAUDE_CODE_NO_FLICKER": "1"
  }
}
```

## 幅広いターミナルでレスポンス幅を制限する

幅広いターミナルでは、Claude のレスポンス内の各行のテキストがウィンドウの全幅に渡ります。代わりに設定した列数でテキストを折り返すには、設定で [`maxProseWidth`](https://code.claude.com/docs/ja/settings-reference#maxprosewidth) を設定してください。

## 大量のコンテンツを貼り付ける

800 文字以上または 3 行以上をプロンプトに貼り付けると、Claude Code は入力を `[Pasted text #1 +120 lines]` などのプレースホルダーに折りたたんで、入力ボックスが使用可能な状態を保ちます。送信時に完全なコンテンツを送信します。ファイル全体やログが長いなど、非常に大きな入力の場合は、コンテンツをファイルに書き込んで、貼り付けの代わりに Claude にそれを読むよう依頼してください。会話トランスクリプトが読みやすくなり、Claude が後のターンでパスによってファイルを参照できます。VS Code 統合ターミナルは、非常に大きな貼り付けから Claude Code に到達する前に文字をドロップできるため、そこではファイルを使用してください。

貼り付けに [目に見えない Unicode 文字](https://code.claude.com/docs/ja/interactive-mode.md#invisible-characters-in-prompts) が含まれている場合、Claude Code は Enter キーを押すときにそれらを削除し、クリーンアップされたプロンプトを入力ボックスに戻して、別の Enter で送信できるようにします。

### Claude が貼り付けたテキストをどのように処理するか

送信すると、Claude は各 `[Pasted text #N]` プレースホルダーの背後にあるコンテンツを、他の場所から貼り付けたテキストとして表示され、入力したテキストではなく表示されます。Claude には、貼り付けには入力していない指示が含まれる可能性があり、入力したメッセージがそれを要求する場所でのみ指示に従うよう指示されます。[機能フラグを取得](https://code.claude.com/docs/ja/env-vars.md#features-that-need-feature-flag-fetching) しないセッションでは、貼り付けはマークされません。

### 折りたたまれた貼り付けを削除して復元する

`Ctrl+W` や `Ctrl+K` などの単語または行ショートカットで削除するか、`df]` などの `f`/`t` モーションを使用した vim 削除で削除し、削除範囲が `[Pasted text #N]` プレースホルダー内に達する場合、Claude Code はプレースホルダー全体を削除します。復元するには、単語または行ショートカットの後に [`Ctrl+Y`](https://code.claude.com/docs/ja/interactive-mode#text-editing) で削除を貼り付け直すか、vim 削除の後に [`p` NORMAL モード](https://code.claude.com/docs/ja/interactive-mode#editing-normal-mode) で復元してください。

### 貼り付けたテキストを含むプロンプトを呼び出す

Claude Code は折りたたまれたコンテンツを各 `[Pasted text #N]` プレースホルダーの背後に `~/.claude/paste-cache/` に保持するため、[コマンド履歴](https://code.claude.com/docs/ja/interactive-mode.md#command-history) からプロンプトを呼び出して再送信すると、完全な貼り付けコンテンツが再度送信され、後のセッションでも含まれます。

[保持期間スイープルール](https://code.claude.com/docs/ja/claude-directory.md#cleaned-up-automatically) に従い、[`cleanupPeriodDays`](https://code.claude.com/docs/ja/settings-reference#cleanupperioddays) より古いキャッシュファイルは削除されるため、呼び出されたプロンプトは存在しなくなった貼り付けテキストを参照できます。そのようなプロンプトを送信すると、Claude Code はリテラル `[Pasted text #N]` 文字列を送信することはなく、不足している貼り付けの名前を示す通知を表示します。

* テキストが残っているプレーンプロンプトでは、Claude Code はプレースホルダーを削除して残りのテキストを送信します。
* [シェルモード](https://code.claude.com/docs/ja/interactive-mode.md#shell-mode-with-prefix) コマンドまたは `/` コマンドでは、削除が実行内容を変更する可能性があり、プロンプトの削除が空のままになる場合、Claude Code は送信をキャンセルし、元のテキストを入力に保持します。プレースホルダーはまだ含まれています。プレースホルダーを削除するか、コマンドを編集してから再送信してください。

## Vim キーバインディングでプロンプトを編集する

Claude Code には、プロンプト入力用の Vim スタイルの編集モードが含まれています。`/config` → Editor mode から有効にするか、`~/.claude/settings.json` で [`editorMode`](https://code.claude.com/docs/ja/settings-reference#editormode) を `"vim"` に設定することで有効にできます。Editor mode を `normal` に戻すと、オフになります。

Vim モードは、NORMAL モードと VISUAL モードのモーション演算子のサブセットをサポートしており、`hjkl` ナビゲーション、`v`/`V` 選択、テキストオブジェクトを使用した `d`/`c`/`y` などが含まれます。完全なキーテーブルについては、[Vim エディタモードリファレンス](https://code.claude.com/docs/ja/interactive-mode.md#vim-editor-mode)を参照してください。

Vim モーションはキーバインディングファイルを通じて再マップできません。`jj` を Escape にマップするなどの 2 キー INSERT モードシーケンスをマップするには、ユーザー設定で [`vimInsertModeRemaps`](https://code.claude.com/docs/ja/interactive-mode#remap-insert-mode-key-sequences) を設定してください。

INSERT モードで Enter キーを押すと、標準的な Vim とは異なり、プロンプトが送信されます。代わりに NORMAL モードで `o` または `O` を使用するか、Ctrl+J を使用して改行を挿入してください。

## 関連リソース

* [インタラクティブモード](https://code.claude.com/docs/ja/interactive-mode.md)：完全なキーボードショートカットリファレンスと Vim キーテーブル
* [キーバインディング](https://code.claude.com/docs/ja/keybindings.md)：Enter と Shift+Enter を含む任意の Claude Code ショートカットを再マップ
* [フルスクリーンレンダリング](https://code.claude.com/docs/ja/fullscreen.md)：フルスクリーンモードでのスクロール、検索、コピーの詳細
* [フック ガイド](https://code.claude.com/docs/ja/hooks-guide.md)：Linux と Windows の詳細な通知フック例
* [トラブルシューティング](https://code.claude.com/docs/ja/troubleshooting.md)：ターミナル設定外の問題の修正
