> ## Documentation Index
> Fetch the complete documentation index at: https://code.claude.com/docs/llms.txt
> Use this file to discover all available pages before exploring further.

# キーボードショートカットのカスタマイズ

> キーボードショートカットをカスタマイズして、Claude Code でキーバインディング設定ファイルを使用します。

Claude Code はカスタマイズ可能なキーボードショートカットをサポートしています。`/keybindings` を実行して、`~/.claude/keybindings.json` に設定ファイルを作成または開きます。

## 設定ファイル

キーバインディング設定ファイルは、`bindings` 配列を持つオブジェクトです。各ブロックはコンテキストとキーストロークからアクションへのマップを指定します。

> [!NOTE]
>
> キーバインディングファイルへの変更は自動的に検出され、Claude Code を再起動することなく適用されます。

| フィールド | 説明 |
| :- | :- |
| `$schema` | エディタのオートコンプリート用のオプション JSON スキーマ URL |
| `$docs` | オプションのドキュメント URL |
| `bindings` | コンテキスト別のバインディングブロックの配列 |

この例では、チャットコンテキストで `Ctrl+E` を外部エディタを開くにバインドし、`Ctrl+S` をアンバインドします。

```json theme={null}
{
  "$schema": "https://www.schemastore.org/claude-code-keybindings.json",
  "$docs": "https://code.claude.com/docs/ja/keybindings",
  "bindings": [
    {
      "context": "Chat",
      "bindings": {
        "ctrl+e": "chat:externalEditor",
        "ctrl+s": null
      }
    }
  ]
}
```

## コンテキスト

各バインディングブロックは、バインディングが適用される**コンテキスト**を指定します。

| コンテキスト | 説明 |
| :- | :- |
| `Global` | アプリ全体に適用 |
| `Chat` | メインチャット入力エリア |
| `Autocomplete` | オートコンプリートメニューが開いている |
| `Settings` | 設定メニュー |
| `Confirmation` | 権限と確認ダイアログ |
| `Tabs` | タブナビゲーションコンポーネント |
| `Help` | ヘルプメニューが表示されている |
| `Transcript` | トランスクリプトビューア |
| `HistorySearch` | 履歴検索モード（Ctrl+R） |
| `Task` | フォアグラウンドで実行中のタスク |
| `ThemePicker` | テーマピッカーダイアログ |
| `Attachments` | 選択ダイアログ内の画像添付ファイルナビゲーション |
| `Footer` | フッターインジケータナビゲーション（タスク、チーム、diff、Artifacts） |
| `MessageSelector` | 巻き戻しと要約ダイアログのメッセージ選択 |
| `DiffDialog` | [差分ビューア](#diff-actions)のナビゲーション |
| `DiffPanel` | [diff パネル](https://code.claude.com/docs/ja/interactive-mode.md#diff-panel)が開いている |
| `ModelPicker` | モデルピッカー努力レベル |
| `EffortSlider` | `/effort` で開かれた努力スライダー |
| `Select` | 汎用選択/リストコンポーネント |
| `Plugin` | プラグインダイアログ（参照、発見、管理） |
| `AbovePrompt` | [プロンプトの上の帯](#above-prompt-actions)、またはその中のボタンにキーボードフォーカスがある |
| `AbovePromptInput` | プロンプトの上の帯または mod のペイン内の入力フィールドにキーボードフォーカスがある |
| `AbovePromptSelect` | プロンプトの上の帯または mod のペイン内の選択にキーボードフォーカスがある |
| `Pane` | [mod](https://code.claude.com/docs/ja/plugins/mods/interface.md#know-which-keys-your-mod-can-receive) が描画したペインにキーボードフォーカスがある |
| `PaneField` | mod のペイン内の入力フィールドまたは選択にキーボードフォーカスがある |
| `Agents` | [エージェントビュー](https://code.claude.com/docs/ja/agent-view.md)（`claude agents`） |
| `Scroll` | 会話スクロールとフルスクリーンモードでのテキスト選択 |

v2.1.205 より前では、`Doctor` コンテキストと `/doctor` 診断スクリーン用の `doctor:fix` アクションが存在していました。

## 利用可能なアクション

アクションは `namespace:action` 形式に従います。例えば、メッセージを送信する `chat:submit` や、タスクリストを表示する `app:toggleTodos` などです。各コンテキストには特定のアクションが利用可能です。

### アプリケーションアクション

`Global` コンテキストで利用可能なアクション：

| アクション | デフォルト | 説明 |
| :- | :- | :- |
| `app:interrupt` | Ctrl+C | 現在の操作をキャンセル |
| `app:exit` | Ctrl+D | Claude Code を終了します。800ms 以内に 2 回押して確認 |
| `app:redraw` | （バインドなし） | ターミナルの再描画を強制 |
| `app:toggleTodos` | Ctrl+T | Claude のやることリストの表示を切り替えます。これは [`/tasks`](https://code.claude.com/docs/ja/commands) バックグラウンドタスクビューではありません |
| `app:toggleTranscript` | Ctrl+O | 詳細トランスクリプトの表示を切り替え |

### 履歴アクション

コマンド履歴をナビゲートするためのアクション：

| アクション | デフォルト | 説明 |
| :- | :- | :- |
| `history:search` | Ctrl+R | 履歴検索を開く |
| `history:previous` | Up | 前の履歴項目 |
| `history:next` | Down | 次の履歴項目 |

### チャットアクション

`Chat` コンテキストで利用可能なアクション：

| アクション | デフォルト | 説明 |
| :- | :- | :- |
| `chat:cancel` | Escape | 現在の入力をキャンセル |
| `chat:clearInput` | Ctrl+L | 入力と会話を保持したまま、フルスクリーン再描画を強制 |
| `chat:clearScreen` | Cmd+K | `chat:clearInput` と同じです。Cmd+K が iTerm2 と Terminal.app でどのように動作するかについては、[会話をクリア](https://code.claude.com/docs/ja/fullscreen.md#clear-the-conversation) を参照してください |
| `chat:killAgents` | Ctrl+X Ctrl+K | このセッション内のすべての実行中の [バックグラウンドサブエージェント](https://code.claude.com/docs/ja/sub-agents.md#run-subagents-in-foreground-or-background) を停止し、残りのセッションの [アーティファクト自動返信](https://code.claude.com/docs/ja/artifacts.md#let-claude-reply-to-comments-on-its-own) をオフにします。確認のため、3 秒以内にショートカットを 2 回押します。バックグラウンドサブエージェントの権限プロンプトが開いている間も押すことができます |
| `chat:cycleMode` | Shift+Tab\* | 権限モードをサイクル |
| `chat:modelPicker` | Meta+P | モデルピッカーを開く |
| `chat:fastMode` | Meta+O | 高速モードを切り替え |
| `chat:thinkingToggle` | Meta+T | 拡張思考を切り替え |
| `chat:submit` | Enter | メッセージを送信 |
| `chat:queueSubmit` | Ctrl+X Enter | メッセージを送信し、順番を待つようにマーク：Claude が作業中の場合、Claude Code は [それをキューに入れ](https://code.claude.com/docs/ja/interactive-mode.md#queue-messages-while-claude-works)、ターンを中断することはありません。`chat:submit` とは異なり、オートコンプリート候補がハイライトされている場合でもドラフトを送信します。v2.1.247 以降が必要 |
| `chat:sendNow` | Ctrl+Enter、Ctrl+X Ctrl+S | [キューに入れたメッセージ](https://code.claude.com/docs/ja/interactive-mode.md#queue-messages-while-claude-works) とドラフトをすぐに送信します。[Claude Code がキューに入れたものを送信する場合](https://code.claude.com/docs/ja/interactive-mode.md#when-claude-code-sends-what-you-queued) は、Claude が作業中のターンに何が起こるかについて説明しています。何も実行されていない場合、キーはドラフトを送信し、[シェルモード](https://code.claude.com/docs/ja/interactive-mode.md#shell-mode-with-prefix) ではコマンドのみをキューに入れます。拡張キーを報告しないターミナルは `Ctrl+Enter` をプレーン `Enter` として配信するため、`Ctrl+X Ctrl+S` はどのターミナルでも機能するバインディングです。v2.1.275 以降が必要 |
| `chat:newline` | Ctrl+J | 送信せずに改行を挿入 |
| `chat:undo` | Ctrl+\_、Ctrl+Shift+- | 最後のアクションを元に戻す |
| `chat:externalEditor` | Ctrl+G、Ctrl+X Ctrl+E | 外部エディタで開きます。[エージェントビューディスパッチ入力](https://code.claude.com/docs/ja/agent-view.md#keyboard-shortcuts) もこのアクションの単一キーストロークバインディングに従います |
| `chat:stash` | Ctrl+S | 現在のプロンプトを保存 |
| `chat:imagePaste` | Ctrl+V （Windows と WSL では Alt+V） | クリップボードから画像を貼り付けます。WSL では、両方のショートカットがデフォルトでバインドされています |
| `command:<name>` | （バインドなし） | [コマンド](https://code.claude.com/docs/ja/commands.md) `/<name>` を実行します。例えば、`Chat` ブロック内で `"meta+g": "command:compact"` と指定すると、`Meta+G` で `/compact` が実行されます |

\*VT モードなし Windows （Node \<24.2.0/\<22.17.0、Bun \<1.2.23） では、デフォルトは Meta+M です。

### オートコンプリートアクション

`Autocomplete` コンテキストで利用可能なアクション：

| アクション | デフォルト | 説明 |
| :- | :- | :- |
| `autocomplete:accept` | Tab | 候補を受け入れ |
| `autocomplete:dismiss` | Escape | メニューを閉じる |
| `autocomplete:previous` | Up | 前の候補 |
| `autocomplete:next` | Down | 次の候補 |

### 確認アクション

`Confirmation` コンテキストで利用可能なアクション：

| アクション | デフォルト | 説明 |
| :- | :- | :- |
| `confirm:yes` | Enter | アクションを確認 |
| `confirm:no` | Escape | アクションを拒否 |
| `confirm:previous` | Up | 前のオプション |
| `confirm:next` | Down | 次のオプション |
| `confirm:nextField` | Tab | `/fast` ダイアログで fast mode をオンまたはオフにする |
| `confirm:previousField` | （バインドなし） | Claude Code はこのアクションに応答しません。このアクションを指定する `keybindings.json` は引き続き有効です |
| `confirm:toggle` | Space | 選択を切り替え |
| `confirm:cycleMode` | Shift+Tab\* | ファイル権限プロンプトでは、開いている [コメントフィールド](https://code.claude.com/docs/ja/permissions.md#add-a-comment-when-you-answer-a-permission-prompt) を閉じます。フィールドが開いていない場合は、プロンプトがそのオプションを提供していれば、セッションの残りの間アクションを許可するオプションを選択します |

\*VT モードなし Windows （Node \<24.2.0/\<22.17.0、Bun \<1.2.23） では、デフォルトは Meta+M です。

v2.1.257 より前では、`confirm:toggleExplanation` アクション（デフォルトでは `Ctrl+E` にバインド）が Bash と PowerShell 権限プロンプトでモデル生成の説明を表示していました。

ダイアログは `confirm:yes` と `confirm:no` を使用して、はい/いいえの質問をしていない場合でも受け入れてキャンセルします。このコンテキストで `y` や `n` などのベアレターをバインドすると、そのレターをキーとして表示しないダイアログにも作用します。`y` と `n` をキーとして表示するダイアログはそれらのレターを自分で読み取り、バインディングは必要ありません。

ほとんどのダイアログでは、`Ctrl+C` または `Ctrl+D` を 2 回押すと、Claude Code を終了する代わりにダイアログを閉じます。最初の押下後のヒントは、2 番目の押下がダイアログを閉じるか Claude Code を終了するかを示します。両方のキーは [予約済み](#reserved-shortcuts) であり、再バインドできません。

この例は `y` を `confirm:yes` に、`n` を `confirm:no` にバインドします：

```json theme={null}
{
  "bindings": [
    {
      "context": "Confirmation",
      "bindings": {
        "y": "confirm:yes",
        "n": "confirm:no"
      }
    }
  ]
}
```

これらのバインディングを使用すると、[テキストフィールド](#text-fields) がフォーカスを持つ間、`y` と `n` はまだレターとして入力されます。

v2.1.280 より前では、`y` はデフォルトで `confirm:yes` に、`n` は `confirm:no` にバインドされていました。v2.1.280 より前に `/keybindings` で `keybindings.json` を作成した場合、ファイルは両方のバインディングをリストし、それらの 2 行を削除するまで有効なままです。

### 権限アクション

権限ダイアログの `Confirmation` コンテキストで利用可能なアクション：

| アクション | デフォルト | 説明 |
| :- | :- | :- |
| `permission:toggleDebug` | （バインドなし） | Claude Code はこのアクションに応答しません。このアクションを指定する `keybindings.json` は引き続き有効です |

### トランスクリプトアクション

`Transcript` コンテキストで利用可能なアクション：

| アクション | デフォルト | 説明 |
| :- | :- | :- |
| `transcript:toggleShowAll` | Ctrl+E | すべてのコンテンツの表示を切り替え |
| `transcript:exit` | q、Ctrl+C、Escape | トランスクリプトビューを終了 |

`transcript:toggleShowAll` はクラシックレンダラーのみで適用されます。[フルスクリーンレンダリング](https://code.claude.com/docs/ja/fullscreen.md) では、トランスクリプトビューアは show-all トグルを提供しません。

### 履歴検索アクション

`HistorySearch` コンテキストで利用可能なアクション：

| アクション | デフォルト | 説明 |
| :- | :- | :- |
| `historySearch:next` | Ctrl+R | 次のマッチ |
| `historySearch:accept` | Escape、Tab | 選択を受け入れ |
| `historySearch:cancel` | Ctrl+C | 検索をキャンセル |
| `historySearch:execute` | Enter | 選択したコマンドを実行 |
| `historySearch:cycleScope` | Ctrl+S | スコープをサイクル：セッション、プロジェクト、すべて |

`historySearch:next`、`historySearch:accept`、`historySearch:cancel`、および `historySearch:execute` のデフォルトは、クラシックレンダラーのインライン履歴検索に適用されます。これは常にすべてのプロジェクトからプロンプトを検索します。`historySearch:cycleScope` は [フルスクリーンレンダリング](https://code.claude.com/docs/ja/fullscreen.md) でのみ有効です。ここで `Ctrl+R` は検索ダイアログを開き、`Ctrl+S` はそのスコープをサイクルします。ダイアログの他のキーは固定されており、再バインドできません：`Enter` または `Tab` はハイライトされたマッチをプロンプト入力に配置し、`Esc` はキャンセルします。

### タスクアクション

`Task` コンテキストで利用可能なアクション：

| アクション | デフォルト | 説明 |
| :- | :- | :- |
| `task:background` | Ctrl+B、Ctrl+X Ctrl+B | 現在のタスクをバックグラウンドに移動 |

### テーマアクション

`ThemePicker` コンテキストで利用可能なアクション：

| アクション | デフォルト | 説明 |
| :- | :- | :- |
| `theme:toggleSyntaxHighlighting` | Ctrl+T | 構文ハイライトを切り替え |

### ヘルプアクション

`Help` コンテキストで利用可能なアクション：

| アクション | デフォルト | 説明 |
| :- | :- | :- |
| `help:dismiss` | Escape | ヘルプメニューを閉じる |

### タブアクション

`Tabs` コンテキストで利用可能なアクション：

| アクション | デフォルト | 説明 |
| :- | :- | :- |
| `tabs:next` | Tab、Right | 次のタブ |
| `tabs:previous` | Shift+Tab、Left | 前のタブ |

タブ付きダイアログでは、タブ行がフォーカスを持つ間、`tabs:next` と `tabs:previous` がタブを切り替えます。`/help` や `/sandbox` などの一部のダイアログでは、タブ切り替えキーはタブのコンテンツ内からも機能します。

`Up` と `Down` はタブ行とタブのコンテンツ間でフォーカスを移動し、コンテンツ内のリストはフォーカスを持つ間のみキーに応答します。

### 添付ファイルアクション

`Attachments` コンテキストで利用可能なアクション：

| アクション | デフォルト | 説明 |
| :- | :- | :- |
| `attachments:next` | Right | 次の添付ファイル |
| `attachments:previous` | Left | 前の添付ファイル |
| `attachments:remove` | Backspace、Delete | 選択した添付ファイルを削除 |
| `attachments:exit` | Down、Escape | 添付ファイルナビゲーションを終了 |

### フッターアクション

`Footer` コンテキストで利用可能なアクション：

| アクション | デフォルト | 説明 |
| :- | :- | :- |
| `footer:next` | Right | 次のフッター項目 |
| `footer:previous` | Left | 前のフッター項目 |
| `footer:up` | Up、Ctrl+P | フッター内を上に移動（上部で選択解除） |
| `footer:down` | Down、Ctrl+N | フッター内を下に移動 |
| `footer:openSelected` | Enter | 選択したフッター項目を開く |
| `footer:clearSelection` | Escape | フッター選択をクリア |
| `footer:close` | x | 選択した [エージェント](https://code.claude.com/docs/ja/sub-agents.md#observe-and-steer-running-forks) または [ワークフロー](https://code.claude.com/docs/ja/workflows.md#manage-runs) を停止します。すでに実行中でない場合は、その行を閉じます |
| `footer:dismiss` | （バインドなし） | このアクションにキーをバインドしても効果がなく、それを名前付けする `keybindings.json` は有効なままです。v2.1.281 より前では、Backspace と Delete はフッターから選択したアーティファクトリンクを削除しました。 |

フッター項目が選択されている間（プロンプトの下のエージェントパネルの行など）は、`Chat` コンテキストで `Enter` を `chat:queueSubmit` または `chat:newline` に再バインドしていても、`Enter` はその項目を開きます。

`Chat` バインディングは、`Shift+Tab` を `chat:cycleMode` のように `Footer` コンテキストがバインドしないキーで機能し、項目が選択されている間も機能します。

### メッセージセレクターアクション

[リワインドメニュー](https://code.claude.com/docs/ja/checkpointing.md) のメッセージリストでは、[選択アクション](#select-actions) とそのデフォルトキーを使用してメッセージを移動して選択します。これらのアクションの `Select` バインディングもそこに適用されます。`MessageSelector` コンテキストには、独自のアクションまたはデフォルトバインディングはありません。このリストのみのキーを変更するには、`MessageSelector` ブロックで `select:accept` などの選択アクションをバインドします。

この例は、リワインドメニューでハイライトされたメッセージを選択するために `o` を `select:accept` にバインドします。他のリストは変更しません：

```json theme={null}
{
  "bindings": [
    {
      "context": "MessageSelector",
      "bindings": {
        "o": "select:accept"
      }
    }
  ]
}
```

v2.1.283 より前では、このリストは `Select` バインディングを無視し、独自のアクション `messageSelector:up`、`messageSelector:down`、`messageSelector:top`、`messageSelector:bottom`、および `messageSelector:select` を持っていました。`keybindings.json` がそれらの名前の 1 つをバインドする場合、バインディングはこのリストで同じことを行う選択アクションとして機能し続けます。`Home` と `End` はリストのいずれかの端にジャンプします。v2.1.283 より前では、`Shift+K` や `Shift+J` などのキーがデフォルトでそれを行いました。

### 差分アクション

これらのアクションは、Claude Code の以前の差分ビューアにのみ作用します。このビューアは、`/plugin` で [`cc-plugin-diff` mod](https://code.claude.com/docs/ja/plugins/mods/overview#mods-built-into-claude-code) を無効にした後、[フルスクリーンレンダリング](https://code.claude.com/docs/ja/fullscreen.md) 以外で `/diff` を実行すると開きます。この mod が有効な間は、`/diff` は代わりに [差分ダイアログ](https://code.claude.com/docs/ja/interactive-mode.md#diff-dialog) を開きます。これらのアクションを指定する `keybindings.json` は、どちらの場合でもエラーなく読み込まれます。

`DiffDialog` コンテキストで利用可能なアクション：

| アクション | デフォルト | 説明 |
| :- | :- | :- |
| `diff:dismiss` | Escape | 差分ビューアを閉じます。詳細ビューから、ファイルリストに戻ります |
| `diff:previousSource` | Left | 前の差分ソース |
| `diff:nextSource` | Right | 次の差分ソース |
| `diff:previousFile` | Up、K | ファイルリスト内の前のファイル。詳細ビューで 1 行上にスクロール |
| `diff:nextFile` | Down、J | ファイルリスト内の次のファイル。詳細ビューで 1 行下にスクロール |
| `diff:back` | （バインドなし） | 差分ビューアで戻ります。Escape は `diff:dismiss` を介してバック アクションを実行します。詳細ビューの Left の以前のデフォルトは v2.1.203 で削除されました |

ファイルリストは [選択アクション](#select-actions) にも応答し、そのデフォルトキーと `Select` バインディングを通じて応答します。`select:previous` と `select:next` は前のファイルと次のファイルに移動し、`Enter` は `select:accept` を通じて選択したファイルの差分を開きます。ファイルリストのみのそれらのキーの 1 つを変更するには、`DiffDialog` ブロックで選択アクションをバインドします。

v2.1.283 より前では、ファイルリストは `Select` バインディングを無視し、`Enter` は別の `diff:viewDetails` アクションを通じて選択したファイルの差分を開きました。`keybindings.json` が `diff:viewDetails` をバインドする場合、バインディングはファイルリストで `select:accept` として機能し続けます。

差分詳細ビューは、ページャースタイルキーを標準 [スクロールアクション](#scroll-actions) にバインドします。これらのバインディングは `DiffDialog` コンテキストの一部であり、詳細ビューのみで適用されます。[スクロールアクション](#scroll-actions) の下にリストされている `Scroll` コンテキストのデフォルトは変更されません。

| アクション | デフォルト | 説明 |
| :- | :- | :- |
| `scroll:pageUp` | PageUp | ビューポートの半分上にスクロール |
| `scroll:pageDown` | PageDown | ビューポートの半分下にスクロール |
| `scroll:fullPageUp` | Shift+Space、B | フルビューポート上にスクロール |
| `scroll:fullPageDown` | Space | フルビューポート下にスクロール |
| `scroll:top` | G、Home | トップにジャンプ |
| `scroll:bottom` | Shift+G、End | ボトムにジャンプ |

### 差分パネルアクション

`/diff` がフルスクリーンレンダリングで開く [差分パネル](https://code.claude.com/docs/ja/interactive-mode.md#diff-panel) のアクション。`app:cycleDiffBase` は `DiffPanel` コンテキストにあり、パネルが開いている間はアクティブです。その他は `Global` です。

組み込みの [`cc-plugin-diff` mod](https://code.claude.com/docs/ja/plugins/mods/overview#mods-built-into-claude-code) がこのパネルを描画し、`app:cycleDiffBase`、`app:diffFileListUp`、`app:diffFileListDown` を処理します。`app:toggleReplTab`、`app:toggleDiffNoiseFilter`、`app:toggleDiffPreSession` は、Claude Code の以前のパネルにのみ作用します。このパネルは、`/plugin` で `cc-plugin-diff` を無効にした後に `/diff` で開きます。

| アクション | デフォルト | 説明 |
| :- | :- | :- |
| `app:toggleReplTab` | （バインドなし） | 差分パネルを開くか閉じる |
| `app:cycleDiffBase` | Ctrl+X B | パネルの比較ベースをサイクル：このセッション、コミットされていない、その後ブランチ |
| `app:diffFileListUp` | Ctrl+Up、Meta+Up | パネルのファイルリストがオーバーフローするときに上にスクロール |
| `app:diffFileListDown` | Ctrl+Down、Meta+Down | パネルのファイルリストがオーバーフローするときに下にスクロール |
| `app:toggleDiffNoiseFilter` | （バインドなし） | パネルのテストファイルと生成ファイルを表示または非表示 |
| `app:toggleDiffPreSession` | （バインドなし） | このセッション前の変更を展開または折りたたむ |

### モデルピッカーアクション

`ModelPicker` コンテキストで利用可能なアクション：

| アクション | デフォルト | 説明 |
| :- | :- | :- |
| `modelPicker:decreaseEffort` | Left | 努力レベルを低下 |
| `modelPicker:increaseEffort` | Right | 努力レベルを増加 |
| `modelPicker:thisSessionOnly` | s | ハイライトされたモデルをこのセッションのみに適用 |

### 努力スライダーアクション

`EffortSlider` コンテキストで利用可能なアクション。引数なしで `/effort` を実行するときに開くスライダー。スライダーの Enter と Escape キーは再バインドできません。

| アクション | デフォルト | 説明 |
| :- | :- | :- |
| `effortSlider:decreaseEffort` | Left | スライダーを次の低い努力レベルに移動します。v2.1.284 以降が必要 |
| `effortSlider:increaseEffort` | Right | スライダーを次の高い努力レベルに移動します。v2.1.284 以降が必要 |
| `effortSlider:toggleUltracode` | Tab | このセッションの [ultracode](https://code.claude.com/docs/ja/workflows.md#let-claude-decide-with-ultracode) をオンまたはオフにします。スライダーが [それを提供する](https://code.claude.com/docs/ja/model-config.md#when-ultracode-is-available) 場合。v2.1.284 以降が必要 |
| `effortSlider:thisSessionOnly` | s | フォーカスされた [努力レベル](https://code.claude.com/docs/ja/model-config.md#adjust-effort-level) をこのセッションのみに適用します。v2.1.257 以降が必要 |

### 選択アクション

`Select` コンテキストで利用可能なアクション：

| アクション | デフォルト | 説明 |
| :- | :- | :- |
| `select:next` | Down、J、Ctrl+N | 次のオプション |
| `select:previous` | Up、K、Ctrl+P | 前のオプション |
| `select:pageUp` | PageUp | オプションの 1 ページ上に移動 |
| `select:pageDown` | PageDown | オプションの 1 ページ下に移動 |
| `select:first` | Home | 最初のオプション |
| `select:last` | End | 最後のオプション |
| `select:accept` | Enter | 選択を受け入れ |
| `select:cancel` | Escape | 選択をキャンセル |

`/skills`、`/mcp`、`/tasks` などのリストパネルでは、Claude Code は `select:pageUp`、`select:pageDown`、`select:first`、および `select:last` バインディングを適用します。`/model` ピッカーなどのほとんどの他のリストでは、`select:first` と `select:last` バインディングが適用されます。PageUp と PageDown は、バインディングに関係なく、これらのリストのオプションをページングします。

v2.1.280 より前では、これらの他のリストは Home、End、および `select:first` と `select:last` バインディングを無視していました。

v2.1.283 より前では、`/mcp` ツールリストは、バインディングに関係なく固定 PageUp と PageDown キーでページングしました。

### プラグインアクション

`Plugin` コンテキストで利用可能なアクション：

| アクション | デフォルト | 説明 |
| :- | :- | :- |
| `plugin:toggle` | Space | プラグイン選択を切り替え |
| `plugin:install` | I | 選択したプラグインをインストール |
| `plugin:favorite` | F | 選択したプラグインをお気に入りにして、インストール済みタブの上部付近でソート |

### プロンプト上部アクション

プロンプトの上にある帯のアクション。この帯は、[mod](https://code.claude.com/docs/ja/plugins/mods/interface.md#pick-where-to-draw) がボタン、入力フィールド、セレクトを描画する共有ストリップです。`abovePrompt:toggle` と `abovePrompt:focus` は `Chat` コンテキストで適用されます。その他のアクションは、帯またはペイン内でキーボードフォーカスを持っているものの [コンテキスト](#contexts) で適用されます。

| アクション | デフォルト | 説明 |
| :- | :- | :- |
| `abovePrompt:toggle` | Ctrl+X Ctrl+A | 帯を 1 行のヒントに折りたたむか、再び展開する |
| `abovePrompt:focus` | Ctrl+X Tab | キーボードフォーカスを帯に移動し、次に開いている各 [ペイン](#pane-actions) に移動し、最後のペインからプロンプトに戻す |
| `abovePrompt:next` | Tab | 次のコントロールにフォーカス |
| `abovePrompt:previous` | Shift+Tab | 前のコントロールにフォーカス |
| `abovePrompt:press` | Enter | フォーカスされたボタンを押す、フォーカスされた入力フィールドを送信する、またはセレクト内のハイライトされたオプションを選択する |
| `abovePrompt:leave` | Escape | キーボードフォーカスをプロンプトに戻す |
| `abovePrompt:highlightNext` | Down | フォーカスされたセレクト内の次のオプションをハイライト |
| `abovePrompt:highlightPrevious` | Up | フォーカスされたセレクト内の前のオプションをハイライト |

[`AbovePrompt` コンテキスト](#contexts) では、デフォルトで Right と Left も `abovePrompt:next` と `abovePrompt:previous` を実行し、Space も `abovePrompt:press` を実行します。

`AbovePrompt` コンテキストは、Up、Down、PageUp、PageDown、Home、End も [ペインのスクロールアクション](#pane-actions) `pane:scrollUp` から `pane:bottom` にバインドしています。そのため、帯でこれらのキーのいずれかを変更するには、`AbovePrompt` ブロックでスクロールアクションをバインドします。

### ペインアクション

[mod](https://code.claude.com/docs/ja/plugins/mods/interface.md#know-which-keys-your-mod-can-receive) が描画するペインのアクション。スクロール、サイズ変更、閉じるの各アクションは `Pane` [コンテキスト](#contexts) で適用されます。`pane:close` は `PaneField` コンテキストでも適用されるため、ペインのフィールドのいずれかがフォーカスを持っている間も機能します。`pane:next` と `pane:previous` は、複数のペインが開いている間、`Global` コンテキストで適用されます。

| アクション | デフォルト | 説明 |
| :- | :- | :- |
| `pane:scrollUp` | Up | ペインが表示できる行数より多くの行を持つ場合に、ペインを上にスクロール |
| `pane:scrollDown` | Down | ペインが表示できる行数より多くの行を持つ場合に、ペインを下にスクロール |
| `pane:pageUp` | PageUp | ペインを 1 ページ上にスクロール |
| `pane:pageDown` | PageDown | ペインを 1 ページ下にスクロール |
| `pane:top` | Home | ペインのトップにジャンプ |
| `pane:bottom` | End | ペインのボトムにジャンプ |
| `pane:grow` | Ctrl+X Left、Ctrl+X Up | ペインの領域を広げる：トランスクリプトの横にある場合は幅、プロンプトの上にある場合は高さ |
| `pane:shrink` | Ctrl+X Right、Ctrl+X Down | ペインの領域を狭める：トランスクリプトの横にある場合は幅、プロンプトの上にある場合は高さ |
| `pane:close` | Ctrl+X X | ペインを閉じる |
| `pane:next` | （バインドなし） | 次の開いているペインを表示 |
| `pane:previous` | （バインドなし） | 前の開いているペインを表示 |

`Pane` コンテキストは、Tab、Shift+Tab、Enter、Escape も帯と同じ [プロンプト上部アクション](#above-prompt-actions) にバインドしており、ペインの入力フィールドとセレクトは `AbovePromptInput` と `AbovePromptSelect` コンテキストを使用します。ペイン内で各キーが何をするかは、[キーボードフォーカスとホットキー](https://code.claude.com/docs/ja/plugins/mods/interface.md#know-which-keys-your-mod-can-receive) に記載されています。

### 設定アクション

`Settings` コンテキストで利用可能なアクション。`select:accept` と `confirm:no` アクションは [選択](#select-actions) と [確認](#confirmation-actions) コンテキストから再利用されます。設定固有の動作：変更は各設定を変更するとすぐに適用されるため、Escape はパネルを閉じ、変更を保存します。拒否するのではなく。

| アクション | デフォルト | 説明 |
| :- | :- | :- |
| `settings:search` | / | 検索モードに入る |
| `settings:retry` | R | エラー時に使用データの読み込みを再試行 |
| `settings:fixUsage` | F | `/usage` フッターが修正を提示している場合に、Claude Code が適用できる [`/usage` の推奨事項](https://code.claude.com/docs/ja/costs#apply-recommendations-with-the-fix-shortcut) をセッションに送信します。v2.1.305 以降が必要 |
| `select:accept` | Enter、Space | 選択した設定を変更またはそのサブメニューを開く |
| `confirm:no` | Escape | パネルを閉じます。変更は既に保存されています |

### エージェントアクション

`Agents` コンテキストで利用可能なアクション。`claude agents` で開く [エージェントビュー](https://code.claude.com/docs/ja/agent-view.md) で適用されます。v2.1.257 以降が必要です。

| アクション | デフォルト | 説明 |
| :- | :- | :- |
| `agents:switchView` | Ctrl+S | [セッショングループ化](https://code.claude.com/docs/ja/agent-view.md#organize-the-list) を状態とディレクトリ間で切り替え |
| `agents:togglePin` | Ctrl+T | 選択したセッションを [ピン留めまたはピン留め解除](https://code.claude.com/docs/ja/agent-view.md#organize-the-list) |
| `agents:find` | Ctrl+F | [`n:` フィルター](https://code.claude.com/docs/ja/agent-view#filter-sessions) を使って名前でセッションを検索します。v2.1.288 以降が必要 |
| `agents:rename` | Ctrl+R | 選択したセッションの [名前を変更](https://code.claude.com/docs/ja/agent-view.md#organize-the-list) します。v2.1.288 以降が必要 |
| `agents:previousGroup` | Ctrl+Up、Meta+Up | 前の [グループヘッダー](https://code.claude.com/docs/ja/agent-view.md#organize-the-list) にジャンプします。v2.1.288 以降が必要 |
| `agents:nextGroup` | Ctrl+Down、Meta+Down | 次のグループヘッダーにジャンプします。v2.1.288 以降が必要 |

エージェントビューが開いている間、Claude Code は `Agents` コンテキストがバインドするキーに対して `Agents` バインディングを使用し、同じキーの `Chat` または `Global` バインディングを無視します。例えば、エージェントビューで Ctrl+S を押すと、デフォルトの `chat:stash` をトリガーするのではなく、セッショングループ化を切り替えます。

ディスパッチ入力の外部エディタショートカットは `Agents` アクションではありません。エージェントビューは `Chat` コンテキストの `chat:externalEditor` バインディング（デフォルトでは Ctrl+G）に従います。

バインディングはエージェントビューで単一キーストロークで発火するため、`chat:externalEditor` にバインドされた Ctrl+X Ctrl+E コードはエディタをそこで開きません。

### 音声アクション

[音声ディクテーション](https://code.claude.com/docs/ja/voice-dictation.md) が有効な場合、`Chat` コンテキストで利用可能なアクション：

| アクション | デフォルト | 説明 |
| :- | :- | :- |
| `voice:pushToTalk` | Space | プロンプトをディクテーション。`/voice` モードに応じて保持またはタップ |

### スクロールアクション

[フルスクリーンレンダリング](https://code.claude.com/docs/ja/fullscreen.md) が有効な場合、`Scroll` コンテキストで利用可能なアクション：

| アクション | デフォルト | 説明 |
| :- | :- | :- |
| `scroll:lineUp` | `wheelup` | 1 行上にスクロール。マウスホイールスクロールはこのアクションをトリガー |
| `scroll:lineDown` | `wheeldown` | 1 行下にスクロール。マウスホイールスクロールはこのアクションをトリガー |
| `scroll:pageUp` | PageUp | ビューポート高さの半分上にスクロール |
| `scroll:pageDown` | PageDown | ビューポート高さの半分下にスクロール |
| `scroll:top` | Ctrl+Home | 会話の開始にジャンプ |
| `scroll:bottom` | Ctrl+End | 最新のメッセージにジャンプして自動フォローを再度有効化 |
| `scroll:halfPageUp` | （バインドなし） | ビューポート高さの半分上にスクロール。`scroll:pageUp` と同じ動作。vi スタイルの再バインドのために提供 |
| `scroll:halfPageDown` | （バインドなし） | ビューポート高さの半分下にスクロール。`scroll:pageDown` と同じ動作。vi スタイルの再バインドのために提供 |
| `scroll:fullPageUp` | （バインドなし） | フルビューポート高さ上にスクロール |
| `scroll:fullPageDown` | （バインドなし） | フルビューポート高さ下にスクロール |
| `selection:copy` | Ctrl+Shift+C / Cmd+C | 選択したテキストをクリップボードにコピー |
| `selection:clear` | （バインドなし） | アクティブなテキスト選択をクリア。v2.1.234 以降が必要 |
| `selection:extendLeft` | Shift+Left | アクティブな選択を 1 列左に拡張 |
| `selection:extendRight` | Shift+Right | アクティブな選択を 1 列右に拡張 |
| `selection:extendUp` | Shift+Up | アクティブな選択を 1 行上に拡張。選択が上端に達するとビューポートをスクロール |
| `selection:extendDown` | Shift+Down | アクティブな選択を 1 行下に拡張。選択が下端に達するとビューポートをスクロール |
| `selection:extendLineStart` | Shift+Home | アクティブな選択を行の開始に拡張 |
| `selection:extendLineEnd` | Shift+End | アクティブな選択を行の終了に拡張 |

## キーストロークシンタックス

### モディファイア

`+` セパレータでモディファイアキーを使用します。

* `ctrl` または `control` - Control キー
* `shift` - Shift キー
* `alt`、`opt`、`option`、または `meta` - Windows と Linux の Alt キー、macOS の Option キー
* `cmd`、`command`、`super`、または `win` - macOS の Command キー、Windows の Windows キー、Linux の Super キー

`cmd` グループは Super モディファイアを報告するターミナル（Kitty キーボードプロトコルまたは xterm の `modifyOtherKeys` モードをサポートするターミナルなど）でのみ検出されます。ほとんどのターミナルはこれを送信しないため、すべての場所で機能するバインディングには `ctrl` または `meta` を使用してください。

例えば：

```text theme={null}
ctrl+k          Ctrl + K
shift+tab       Shift + Tab
meta+p          macOS の Option + P、その他の場所では Alt + P
ctrl+shift+c    複数のモディファイア
```

### 大文字

Claude Code はキー名を大文字と小文字を区別せずに解析するため、`K` は `k` と同じバインディングであり、`ctrl+K` は `ctrl+k` と同じです。Shift とレターをバインドするには、`shift+k` と記述します。

### 非 US キーボードレイアウト

Ctrl ショートカットのキー名は、アクティブなキーボードレイアウトが他の文字を入力する場合でも、ラテン文字として記述してください。

Claude Code がキーボードで押したキーをバインディングにマッチさせる方法は、レイアウトの種類によって異なります。

* キリル文字などの非ラテンレイアウトの場合、Claude Code はターミナルが Kitty キーボードプロトコルを使用し、その位置を報告する場合、キーの US レイアウト位置で Ctrl ショートカットをマッチさせます。そのようなターミナルでロシア語レイアウトがアクティブな場合、Ctrl キーと物理的な W キーを押すと `ctrl+w` がトリガーされます。位置を報告しないターミナルでは、Claude Code はターミナルがキープレスに対して送信するものをマッチさせます。ASCII 制御コードは Latin ショートカットをトリガーし、キリル文字として到着するキープレスはバインディングにマッチしません。
* AZERTY などのラテン文字を並べ替えるレイアウトの場合、Claude Code はキーが入力する文字をマッチさせるため、Ctrl キーと A というラベルのキーを押すと `ctrl+a` がトリガーされます。

### コード

コードはスペースで区切られたキーストロークのシーケンスです。

```text theme={null}
ctrl+k ctrl+s   Ctrl+K を押して、リリースしてから Ctrl+S
```

各キーストロークは、その前のキーストロークから 3 秒以内に押してください。それより長く待つと、Claude Code はコードをキャンセルし、そのことを示す簡潔な通知を表示します。

### 特殊キー

* `escape` または `esc` - Escape キー
* `enter` または `return` - Enter キー
* `tab` - Tab キー
* `space` - スペースバー
* `up`、`down`、`left`、`right` - 矢印キー
* `pageup`、`pagedown` - Page Up キーと Page Down キー
* `home`、`end` - Home キーと End キー
* `backspace`、`delete` - Delete キー
* `wheelup`、`wheeldown` - マウスホイールスクロールイベント

## デフォルトのショートカットのバインドを解除する

アクションを `null` に設定すると、デフォルトのショートカットのバインドを解除できます。

```json theme={null}
{
  "bindings": [
    {
      "context": "Chat",
      "bindings": {
        "ctrl+s": null
      }
    }
  ]
}
```

これは chord（連続キー入力）バインディングにも有効です。プレフィックスを共有するすべての chord のバインドを解除すると、そのプレフィックスを単一キーのバインディングとして使用できるようになります。アクティブなコンテキストのいずれかに chord が 1 つでも残っていれば、そのプレフィックスは予約されたままになります。そのため、各 chord は、それを定義しているコンテキストでバインドを解除する必要があります。

Claude Code は、`ctrl+x` プレフィックスに以下のデフォルトの chord をコンテキストごとにバインドしています。

* `Chat`：`ctrl+x ctrl+k`、`ctrl+x ctrl+e`、`ctrl+x enter`、`ctrl+x ctrl+a`、`ctrl+x ctrl+s`、`ctrl+x tab`
* `Task`：`ctrl+x ctrl+b`
* `DiffPanel`：`ctrl+x b`
* `Pane`：`ctrl+x left`、`ctrl+x right`、`ctrl+x up`、`ctrl+x down`、`ctrl+x x`
* `PaneField`：`ctrl+x x`

`ctrl+x enter` の chord には v2.1.247 以降が、`ctrl+x b`、`ctrl+x ctrl+a`、`ctrl+x tab` には v2.1.260 以降が、`ctrl+x ctrl+s` には v2.1.275 以降が必要です。

`ctrl+x` 自体を単一キーのバインディングとして取り戻すには、これらすべてのバインドを解除します。

```json theme={null}
{
  "bindings": [
    {
      "context": "Task",
      "bindings": {
        "ctrl+x ctrl+b": null
      }
    },
    {
      "context": "DiffPanel",
      "bindings": {
        "ctrl+x b": null
      }
    },
    {
      "context": "Pane",
      "bindings": {
        "ctrl+x left": null,
        "ctrl+x right": null,
        "ctrl+x up": null,
        "ctrl+x down": null,
        "ctrl+x x": null
      }
    },
    {
      "context": "PaneField",
      "bindings": {
        "ctrl+x x": null
      }
    },
    {
      "context": "Chat",
      "bindings": {
        "ctrl+x ctrl+k": null,
        "ctrl+x ctrl+e": null,
        "ctrl+x enter": null,
        "ctrl+x ctrl+a": null,
        "ctrl+x ctrl+s": null,
        "ctrl+x tab": null,
        "ctrl+x": "chat:newline"
      }
    }
  ]
}
```

プレフィックス上の chord の一部だけのバインドを解除し、すべてを解除しなかった場合、そのプレフィックスを押すと、残りのバインディングのために引き続き chord 待機モードに入ります。

## 予約済みショートカット

これらのショートカットは再バインドできません。

| ショートカット | 理由 |
| :- | :- |
| Ctrl+C | ハードコードされた割り込み/キャンセル |
| Ctrl+D | ハードコードされた終了 |
| Ctrl+M | Claude Code は常に Enter として受け取ります |
| Ctrl+\[ | Claude Code は常に Escape として受け取ります。Kitty キーボードプロトコルを使用するターミナルでは、v2.1.242 以降が必要です |
| Ctrl+I | Claude Code は常に Tab として受け取ります |
| Ctrl+H | ASCII バックスペースバイトを送信します。[Claude Code が Windows で読み込む方法](https://code.claude.com/docs/ja/terminal-config.md#fix-backspace-deleting-a-whole-word-on-windows)は、ターミナルと [`CLAUDE_CODE_BS_AS_CTRL_BACKSPACE`](https://code.claude.com/docs/ja/env-vars) 環境変数によって異なります |
| Caps Lock | ターミナルアプリケーションに配信されない |

## ターミナルの競合

一部のショートカットはターミナルマルチプレクサと競合する可能性があります。

| ショートカット | 競合 |
| :- | :- |
| Ctrl+B | tmux プレフィックス（2 回押して送信） |
| Ctrl+A | GNU screen プレフィックス |
| Ctrl+Z | Unix プロセス一時停止（SIGTSTP） |

## テキストフィールド

ベアレター、数字、またはスペースをバインドした場合でも、ダイアログまたはパネル内のテキストフィールドでそのキャラクターを入力できます。このようなフィールドの 1 つは、Claude が質問する「Other」の回答です。フィールドがフォーカスを持っている間、Ctrl、Alt、または Cmd なしで押したプリント可能なキーはフィールドに送られ、Claude Code はそれをバインディングと照合しません。

これらのキーはフィールドがフォーカスを持っている間でもバインディングを実行します。

* Enter、Escape、Tab、矢印キーなど、キャラクターを入力しないキー
* Ctrl、Alt、または Cmd で押されたキー
* 既に進行中の[コード](#chords)の 2 番目のキーストローク

メインプロンプトでは、Claude Code はすべてのキーを `Chat` などのアクティブなコンテキストと照合し、バインディングがそれを取らない場合にのみキーを入力します。

## Vim モードの相互作用

Vim モードが `/config` → エディタモードで有効な場合、キーバインディングと Vim モードは独立して動作します。

* **Vim モード** はテキスト入力レベルで入力を処理します（カーソル移動、モード、モーション）
* **キーバインディング** はコンポーネントレベルでアクションを処理します（todos を切り替え、送信など）
* Vim モードの Escape キーは INSERT から NORMAL モードに切り替わります。`chat:cancel` をトリガーしません
* ほとんどの Ctrl+key ショートカットは Vim モードを通過してキーバインディングシステムに渡されます
* Vim キーはキーバインディングファイルを通じて再マップできません。`jj` を Escape にマップするような 2 キーの INSERT モードシーケンスをマップするには、[`vimInsertModeRemaps`](https://code.claude.com/docs/ja/interactive-mode#remap-insert-mode-key-sequences) 設定を使用してください
* Vim NORMAL モードでは、`?` はヘルプメニューを表示します（Vim の動作）
* Vim NORMAL モードでは、`/` は履歴検索を開きます。標準モードの Ctrl+R と同じです

Claude が尋ねる質問の `Other` 行では、Vim モードで Escape を押しても質問はすぐにはキャンセルされません。[スクリーンリーダーモード](https://code.claude.com/docs/ja/accessibility.md)の場合を除き、この行はフォーカスするたびに INSERT モードで開始されます。`Other` 行で Escape を押すと、行が NORMAL モードに切り替わるか、入力途中の Vim コマンドが破棄され、質問は開いたままになります。質問をキャンセルするには、NORMAL モードで Escape をもう一度押してください。

### 1 回のキー操作で質問をキャンセルする

Vim モードで 1 回のキー操作で質問をキャンセルするには、`Select` コンテキストで別のキーを `select:cancel` にバインドします。この方法では、1 つのオプションを選択する質問の `Other` 行からキャンセルできます。[スクリーンリーダーモード](https://code.claude.com/docs/ja/accessibility.md)や、複数のオプションを選択できる質問では、バインドしたキーではキャンセルされないため、代わりに Escape でキャンセルしてください。

Ctrl または Alt と組み合わせて押すキーを選んでください。修飾キーなしの文字や数字は代わりに [`Other` 行に入力され](#text-fields)、設定したバインディングには届きません。たとえば `Ctrl+Q` をバインドするには、`~/.claude/keybindings.json` に次の内容を追加します。

```json theme={null}
{
  "bindings": [
    {
      "context": "Select",
      "bindings": {
        "ctrl+q": "select:cancel"
      }
    }
  ]
}
```

ファイルを保存したら、1 つのオプションを選択する質問の `Other` 行で `Ctrl+Q` を押します。行が INSERT モードでも NORMAL モードでも、質問は閉じます。

## 検証

Claude Code はキーバインディングを検証し、以下の警告をデバッグログに書き込みます。

* 解析エラー（無効な JSON または構造）
* スペルミスのあるモディファイア（例：`ctl+k`）。Claude Code は認識できない部分を削除し、残りのキーストロークにバインディングを適用します。この例では `k` です。
* キー文字列内の `+` の隣にあるスペース（例：`ctrl+ k`）。Claude Code はこの文字列を、`ctrl+` の後に `k` が続く[コード](#chords)として読み取ります。`ctrl+` 単独に一致するキー入力はないため、このバインディングは発火しません。スペースを削除してください。
* 無効なコンテキスト名
* 無効なアクション値（アクションが文字列または `null` ではない場合など）
* 不明なアクション名（登録されたアクションのタイプミスなど）。Claude Code はバインディングをスキップし、そのキーのデフォルトバインディングを有効に保ちます。
* 予約済みショートカットの競合
* 同じコンテキスト内の重複バインディング

Claude Code を [`--debug`](https://code.claude.com/docs/ja/cli-reference#cli-flags) で起動して、詳細を確認してください。
