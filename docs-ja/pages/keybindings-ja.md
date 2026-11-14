> ## Documentation Index
> Fetch the complete documentation index at: https://code.claude.com/docs/llms.txt
> Use this file to discover all available pages before exploring further.

# キーボードショートカットのカスタマイズ

> キーボードショートカットをカスタマイズして、Claude Code でキーバインディング設定ファイルを使用します。

Claude Code はカスタマイズ可能なキーボードショートカットをサポートしています。`/keybindings` を実行して、`~/.claude/keybindings.json` に設定ファイルを作成または開きます。

## 設定ファイル

キーボードショートカットの設定ファイルは、`bindings` 配列を持つオブジェクトです。各ブロックでは、コンテキストと、キー入力からアクションへのマッピングを指定します。

> [!NOTE]
>
> キーボードショートカットファイルへの変更は自動的に検出され、Claude Code を再起動しなくても適用されます。

| フィールド | 説明 |
| :- | :- |
| `$schema` | エディターでの自動補完用のオプションの JSON Schema URL |
| `$docs` | オプションのドキュメント URL |
| `bindings` | コンテキストごとのバインディングブロックの配列 |

この例では、チャットコンテキストで `Ctrl+E` に外部エディターを開く操作を割り当て、`Ctrl+S` の割り当てを解除しています。

```json theme={null}
{
  "$schema": "https://www.schemastore.org/claude-code-keybindings.json",
  "$docs": "https://code.claude.com/docs/en/keybindings",
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

アクションは `namespace:action` 形式に従います。たとえば、メッセージを送信する `chat:submit` や、タスクリストを表示する `app:toggleTodos` などです。各コンテキストには、それぞれ利用可能なアクションがあります。

### アプリアクション

`Global` コンテキストで利用可能なアクション：

| アクション | デフォルト | 説明 |
| :- | :- | :- |
| `app:interrupt` | Ctrl+C | 現在の操作をキャンセルします |
| `app:exit` | Ctrl+D | Claude Code を終了します。確認のため 800ms 以内に 2 回押します |
| `app:redraw` | （未割り当て） | ターミナルを強制的に再描画します |
| `app:toggleTodos` | Ctrl+T | Claude の To-Do チェックリストの表示を切り替えます。これは [`/tasks`](https://code.claude.com/docs/ja/commands) のバックグラウンドタスクビューではありません |
| `app:toggleTranscript` | Ctrl+O | 詳細なトランスクリプトの表示を切り替えます |

### 履歴アクション

コマンド履歴を移動するためのアクション：

| アクション | デフォルト | 説明 |
| :- | :- | :- |
| `history:search` | Ctrl+R | 履歴検索を開きます |
| `history:previous` | Up | 前の履歴項目 |
| `history:next` | Down | 次の履歴項目 |

### チャットアクション

`Chat` コンテキストで利用可能なアクション：

| アクション | デフォルト | 説明 |
| :- | :- | :- |
| `chat:cancel` | Escape | 現在の入力をキャンセルします |
| `chat:clearInput` | Ctrl+L | 入力と会話を保持したまま、画面全体を強制的に再描画します |
| `chat:clearScreen` | Cmd+K | `chat:clearInput` と同じです。iTerm2 と Terminal.app での Cmd+K の動作については、[会話をクリアする](https://code.claude.com/docs/ja/fullscreen.md#clear-the-conversation)を参照してください |
| `chat:killAgents` | Ctrl+X Ctrl+K | このセッションで実行中のすべての[バックグラウンドサブエージェント](https://code.claude.com/docs/ja/sub-agents.md#run-subagents-in-foreground-or-background)を停止し、セッションの残りの間は[アーティファクトの自動返信](https://code.claude.com/docs/ja/artifacts.md#let-claude-reply-to-comments-on-its-own)をオフにします。確認のため、3 秒以内にショートカットを 2 回押します。バックグラウンドサブエージェントの権限プロンプトが開いている間も押すことができます |
| `chat:cycleMode` | Shift+Tab\* | 権限モードを順に切り替えます |
| `chat:modelPicker` | Meta+P | モデルピッカーを開きます |
| `chat:fastMode` | Meta+O | fast mode を切り替えます |
| `chat:thinkingToggle` | Meta+T | 拡張思考を切り替えます |
| `chat:submit` | Enter | メッセージを送信します |
| `chat:queueSubmit` | Ctrl+X Enter | メッセージを、順番を待つよう印を付けて送信します。Claude が作業中の場合、Claude Code はそのメッセージを[キューに入れ](https://code.claude.com/docs/ja/interactive-mode.md#queue-messages-while-claude-works)、ターンを中断することはありません。`chat:submit` とは異なり、オートコンプリートの候補がハイライトされている間もドラフトを送信します。v2.1.247 以降が必要です |
| `chat:sendNow` | Ctrl+Enter, Ctrl+X Ctrl+S | [キューに入れたメッセージ](https://code.claude.com/docs/ja/interactive-mode.md#queue-messages-while-claude-works)を、ドラフトと一緒にすぐに送信します。Claude が作業中のターンがどうなるかについては、[Claude Code がキューに入れた内容を送信するタイミング](https://code.claude.com/docs/ja/interactive-mode.md#when-claude-code-sends-what-you-queued)で説明しています。何も実行されていない場合、このキーはドラフトを送信します。[シェルモード](https://code.claude.com/docs/ja/interactive-mode.md#shell-mode-with-prefix)では、コマンドをキューに入れるだけです。拡張キーを報告しないターミナルでは `Ctrl+Enter` が通常の `Enter` として送られるため、どのターミナルでも機能するバインディングは `Ctrl+X Ctrl+S` です。v2.1.275 以降が必要です |
| `chat:newline` | Ctrl+J | 送信せずに改行を挿入します |
| `chat:undo` | Ctrl+\_, Ctrl+Shift+- | 最後の操作を元に戻します |
| `chat:externalEditor` | Ctrl+G, Ctrl+X Ctrl+E | 外部エディタで開きます。[エージェントビューのディスパッチ入力](https://code.claude.com/docs/ja/agent-view.md#keyboard-shortcuts)も、このアクションの単一キーストロークのバインディングに従います |
| `chat:stash` | Ctrl+S | 現在のプロンプトを一時退避（stash）します |
| `chat:imagePaste` | Ctrl+V（Windows と WSL では Alt+V） | クリップボードから画像を貼り付けます。WSL では、両方のショートカットがデフォルトでバインドされています |
| `command:<name>` | （未割り当て） | [コマンド](https://code.claude.com/docs/ja/commands.md) `/<name>` を実行します。たとえば、`Chat` ブロックに `"meta+g": "command:compact"` を記述すると、`Meta+G` で `/compact` が実行されます |

\*VT モードのない Windows（Node \<24.2.0/\<22.17.0、Bun \<1.2.23）では、デフォルトは Meta+M です。

### オートコンプリートアクション

`Autocomplete` コンテキストで利用可能なアクション：

| アクション | デフォルト | 説明 |
| :- | :- | :- |
| `autocomplete:accept` | Tab | 候補を確定します |
| `autocomplete:dismiss` | Escape | メニューを閉じます |
| `autocomplete:previous` | Up | 前の候補 |
| `autocomplete:next` | Down | 次の候補 |

### 確認アクション

`Confirmation` コンテキストで利用可能なアクション：

| アクション | デフォルト | 説明 |
| :- | :- | :- |
| `confirm:yes` | Enter | 操作を確定します |
| `confirm:no` | Escape | 操作を拒否します |
| `confirm:previous` | Up | 前のオプション |
| `confirm:next` | Down | 次のオプション |
| `confirm:nextField` | Tab | `/fast` ダイアログで、fast mode をオンまたはオフにします |
| `confirm:previousField` | （未割り当て） | Claude Code はこのアクションに反応しません。このアクションを指定した `keybindings.json` も引き続き有効です |
| `confirm:toggle` | Space | 選択を切り替えます |
| `confirm:cycleMode` | Shift+Tab\* | ファイルの権限プロンプトで、開いている[コメントフィールド](https://code.claude.com/docs/ja/permissions.md#add-a-comment-when-you-answer-a-permission-prompt)を閉じます。フィールドが開いていない場合は、プロンプトにそのオプションがあれば、セッションの残りの間その操作を許可するオプションを選択します |

\*VT モードのない Windows（Node \<24.2.0/\<22.17.0、Bun \<1.2.23）では、デフォルトは Meta+M です。

v2.1.257 より前は、デフォルトで `Ctrl+E` にバインドされた `confirm:toggleExplanation` アクションがあり、Bash と PowerShell の権限プロンプトで、モデルが生成したコマンドの説明を表示していました。

ダイアログは、はい/いいえを尋ねるものでない場合でも、確定とキャンセルに `confirm:yes` と `confirm:no` を使用します。このコンテキストで `y` や `n` のような単一の文字をバインドすると、その文字は、キーとして表示していないダイアログでも機能します。`y` と `n` をキーとして表示するダイアログは、それらの文字を自身で読み取るため、バインディングは不要です。

ほとんどのダイアログでは、`Ctrl+C` または `Ctrl+D` を 2 回押すと、Claude Code を終了するのではなくダイアログが閉じます。1 回目に押した後に表示されるヒントで、2 回目に押したときにダイアログが閉じるのか終了するのかがわかります。どちらのキーも[予約済み](#reserved-shortcuts)であり、再バインドできません。

次の例では、`y` を `confirm:yes` に、`n` を `confirm:no` にバインドしています：

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

これらのバインディングを設定しても、[テキストフィールド](#text-fields)にフォーカスがある間は、`y` と `n` は引き続き文字として入力されます。

v2.1.280 より前は、デフォルトで `y` も `confirm:yes` に、`n` も `confirm:no` にバインドされていました。v2.1.280 より前に `/keybindings` で `keybindings.json` を作成した場合、ファイルには両方のバインディングが記載されており、それらの 2 行を削除するまで有効なままです。

### 権限アクション

権限ダイアログ用に `Confirmation` コンテキストで利用可能なアクション：

| アクション | デフォルト | 説明 |
| :- | :- | :- |
| `permission:toggleDebug` | （未割り当て） | Claude Code はこのアクションに反応しません。このアクションを指定した `keybindings.json` も引き続き有効です |

### トランスクリプトアクション

`Transcript` コンテキストで利用可能なアクション：

| アクション | デフォルト | 説明 |
| :- | :- | :- |
| `transcript:toggleShowAll` | Ctrl+E | すべてのコンテンツの表示を切り替えます |
| `transcript:exit` | q, Ctrl+C, Escape | トランスクリプトビューを終了します |

`transcript:toggleShowAll` はクラシックレンダラーでのみ適用されます。[フルスクリーンレンダリング](https://code.claude.com/docs/ja/fullscreen.md)では、トランスクリプトビューアにすべて表示の切り替えはありません。

### 履歴検索アクション

`HistorySearch` コンテキストで利用可能なアクション：

| アクション | デフォルト | 説明 |
| :- | :- | :- |
| `historySearch:next` | Ctrl+R | 次の一致 |
| `historySearch:accept` | Escape, Tab | 選択を確定します |
| `historySearch:cancel` | Ctrl+C | 検索をキャンセルします |
| `historySearch:execute` | Enter | 選択したコマンドを実行します |
| `historySearch:cycleScope` | Ctrl+S | スコープを順に切り替えます：セッション、プロジェクト、すべて |

`historySearch:next`、`historySearch:accept`、`historySearch:cancel`、`historySearch:execute` のデフォルトは、クラシックレンダラーのインライン履歴検索に適用されます。この検索は常にすべてのプロジェクトのプロンプトを対象とします。`historySearch:cycleScope` は[フルスクリーンレンダリング](https://code.claude.com/docs/ja/fullscreen.md)でのみ有効です。フルスクリーンレンダリングでは、`Ctrl+R` で代わりに検索ダイアログが開き、`Ctrl+S` でそのスコープを順に切り替えます。ダイアログのその他のキーは固定されており、再バインドできません：`Enter` または `Tab` でハイライトされた一致をプロンプト入力に配置し、`Esc` でキャンセルします。

### タスクアクション

`Task` コンテキストで利用可能なアクション：

| アクション | デフォルト | 説明 |
| :- | :- | :- |
| `task:background` | Ctrl+B, Ctrl+X Ctrl+B | 現在のタスクをバックグラウンドに移します |

### テーマアクション

`ThemePicker` コンテキストで利用可能なアクション：

| アクション | デフォルト | 説明 |
| :- | :- | :- |
| `theme:toggleSyntaxHighlighting` | Ctrl+T | シンタックスハイライトを切り替えます |

### ヘルプアクション

`Help` コンテキストで利用可能なアクション：

| アクション | デフォルト | 説明 |
| :- | :- | :- |
| `help:dismiss` | Escape | ヘルプメニューを閉じます |

### タブアクション

`Tabs` コンテキストで利用可能なアクション：

| アクション | デフォルト | 説明 |
| :- | :- | :- |
| `tabs:next` | Tab, Right | 次のタブ |
| `tabs:previous` | Shift+Tab, Left | 前のタブ |

タブ付きダイアログでは、タブの行にフォーカスがある間、`tabs:next` と `tabs:previous` でタブを切り替えます。`/help` や `/sandbox` などの一部のダイアログでは、タブの切り替えキーはタブのコンテンツ内からも機能します。

`Up` と `Down` でタブの行とタブのコンテンツの間でフォーカスを移動します。コンテンツ内のリストは、フォーカスがある間のみキーに反応します。

### 添付ファイルアクション

`Attachments` コンテキストで利用可能なアクション：

| アクション | デフォルト | 説明 |
| :- | :- | :- |
| `attachments:next` | Right | 次の添付ファイル |
| `attachments:previous` | Left | 前の添付ファイル |
| `attachments:remove` | Backspace, Delete | 選択した添付ファイルを削除します |
| `attachments:exit` | Down, Escape | 添付ファイルのナビゲーションを終了します |

### フッターアクション

`Footer` コンテキストで利用可能なアクション：

| アクション | デフォルト | 説明 |
| :- | :- | :- |
| `footer:next` | Right | 次のフッター項目 |
| `footer:previous` | Left | 前のフッター項目 |
| `footer:up` | Up, Ctrl+P | フッター内で上に移動します（一番上では選択を解除します） |
| `footer:down` | Down, Ctrl+N | フッター内で下に移動します |
| `footer:openSelected` | Enter | 選択したフッター項目を開きます |
| `footer:clearSelection` | Escape | フッターの選択を解除します |
| `footer:close` | x | 選択した[エージェント](https://code.claude.com/docs/ja/sub-agents.md#observe-and-steer-running-forks)または[ワークフロー](https://code.claude.com/docs/ja/workflows.md#manage-runs)を停止します。すでに実行されていない場合は、その行を閉じます |
| `footer:dismiss` | （未割り当て） | このアクションにキーをバインドしても効果はありません。このアクションを指定した `keybindings.json` も引き続き有効です。v2.1.281 より前は、Backspace と Delete がこのアクションにバインドされており、選択したアーティファクトリンクをフッターから閉じていました。 |

プロンプトの下にあるエージェントパネルの行など、フッター項目が選択されている間は、`Chat` コンテキストで `Enter` を `chat:queueSubmit` や `chat:newline` に再バインドしていても、`Enter` でその項目が開きます。

`chat:cycleMode` の `Shift+Tab` のように、`Footer` コンテキストがバインドしていないキーに対する `Chat` のバインディングは、項目が選択されている間も引き続き機能します。

### メッセージセレクターアクション

[巻き戻しメニュー](https://code.claude.com/docs/ja/checkpointing.md)のメッセージリストでは、[Select アクション](#select-actions)とそのデフォルトキーを使用して、メッセージ間を移動し、1 つを選択します。これらのアクションに対する `Select` のバインディングもここに適用されます。`MessageSelector` コンテキストには、独自のアクションやデフォルトのバインディングはありません。このリストに限ってキーを変更するには、`MessageSelector` ブロックで `select:accept` などの Select アクションをバインドします。

次の例では、他のリストを変更せずに、巻き戻しメニューでハイライトされたメッセージを選択するキーとして `o` をバインドしています：

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

v2.1.283 より前は、このリストは `Select` のバインディングを無視し、独自のアクションとして `messageSelector:up`、`messageSelector:down`、`messageSelector:top`、`messageSelector:bottom`、`messageSelector:select` を持っていました。`keybindings.json` でこれらの名前のいずれかをバインドしている場合、そのバインディングはこのリストで、同じ動作をする Select アクションとして引き続き機能します。`Home` と `End` でリストの両端にジャンプします。v2.1.283 より前は、デフォルトで `Shift+K` や `Shift+J` などのキーがこれを行っていました。

### 差分アクション

これらのアクションは、Claude Code の以前の差分ビューアにのみ作用します。このビューアは、`/plugin` で [`cc-plugin-diff` mod](https://code.claude.com/docs/ja/plugins/mods/overview#mods-built-into-claude-code) を無効にした後、[フルスクリーンレンダリング](https://code.claude.com/docs/ja/fullscreen.md)以外で `/diff` を実行すると開きます。この mod が有効な間は、`/diff` で代わりに[差分ダイアログ](https://code.claude.com/docs/ja/interactive-mode.md#diff-dialog)が開きます。

`DiffDialog` コンテキストで利用可能なアクション：

| アクション | デフォルト | 説明 |
| :- | :- | :- |
| `diff:dismiss` | Escape | 差分ビューアを閉じます。ただし詳細ビューからは、ビューアを閉じる代わりにファイル一覧に戻ります |
| `diff:previousSource` | Left | 前の差分ソース |
| `diff:nextSource` | Right | 次の差分ソース |
| `diff:previousFile` | Up, K | ファイル一覧では前のファイル、詳細ビューでは 1 行上にスクロールします |
| `diff:nextFile` | Down, J | ファイル一覧では次のファイル、詳細ビューでは 1 行下にスクロールします |
| `diff:back` | （未割り当て） | 差分ビューアで戻ります。Escape は `diff:dismiss` を介して戻る操作を実行します。詳細ビューでの以前のデフォルトである Left は v2.1.203 で削除されました |

ファイル一覧は、[Select アクション](#select-actions)にも、そのデフォルトキーと `Select` のバインディングを通じて反応します。`select:previous` と `select:next` で前後のファイルに移動し、`Enter` で `select:accept` を通じて選択したファイルの差分を開きます。ファイル一覧に限ってこれらのキーのいずれかを変更するには、`DiffDialog` ブロックで Select アクションをバインドします。

v2.1.283 より前は、ファイル一覧は `Select` のバインディングを無視し、`Enter` は別の `diff:viewDetails` アクションを通じて選択したファイルの差分を開いていました。`keybindings.json` で `diff:viewDetails` をバインドしている場合、そのバインディングはファイル一覧で `select:accept` として引き続き機能します。

差分の詳細ビューでは、ページャー形式のキーも標準の[スクロールアクション](#scroll-actions)にバインドされています。これらのバインディングは `DiffDialog` コンテキストの一部であり、詳細ビューでのみ適用されます。[スクロールアクション](#scroll-actions)に記載されている `Scroll` コンテキストのデフォルトは変わりません。

| アクション | デフォルト | 説明 |
| :- | :- | :- |
| `scroll:pageUp` | PageUp | ビューポートの半分だけ上にスクロールします |
| `scroll:pageDown` | PageDown | ビューポートの半分だけ下にスクロールします |
| `scroll:fullPageUp` | Shift+Space, B | ビューポート 1 つ分上にスクロールします |
| `scroll:fullPageDown` | Space | ビューポート 1 つ分下にスクロールします |
| `scroll:top` | G, Home | 先頭にジャンプします |
| `scroll:bottom` | Shift+G, End | 末尾にジャンプします |

### 差分パネルアクション

フルスクリーンレンダリングで `/diff` が開く[差分パネル](https://code.claude.com/docs/ja/interactive-mode.md#diff-panel)用のアクションです。`app:cycleDiffBase` は、パネルが開いている間アクティブになる `DiffPanel` コンテキストにあり、その他は `Global` です。

組み込みの [`cc-plugin-diff` mod](https://code.claude.com/docs/ja/plugins/mods/overview#mods-built-into-claude-code) がこのパネルを描画し、`app:cycleDiffBase`、`app:diffFileListUp`、`app:diffFileListDown` を処理します。`app:toggleReplTab`、`app:toggleDiffNoiseFilter`、`app:toggleDiffPreSession` は、Claude Code の以前のパネルにのみ作用します。このパネルは、`/plugin` で `cc-plugin-diff` を無効にした後に `/diff` を実行すると開きます。

| アクション | デフォルト | 説明 |
| :- | :- | :- |
| `app:toggleReplTab` | （未割り当て） | 差分パネルを開閉します |
| `app:cycleDiffBase` | Ctrl+X B | パネルの比較基準を順に切り替えます：このセッション、未コミット、ブランチの順 |
| `app:diffFileListUp` | Ctrl+Up, Meta+Up | パネルのファイル一覧があふれている場合に上にスクロールします |
| `app:diffFileListDown` | Ctrl+Down, Meta+Down | パネルのファイル一覧があふれている場合に下にスクロールします |
| `app:toggleDiffNoiseFilter` | （未割り当て） | パネル内のテストファイルと生成ファイルを表示または非表示にします |
| `app:toggleDiffPreSession` | （未割り当て） | このセッションより前の変更を展開または折りたたみます |

### モデルピッカーアクション

`ModelPicker` コンテキストで利用可能なアクション：

| アクション | デフォルト | 説明 |
| :- | :- | :- |
| `modelPicker:decreaseEffort` | Left | effort レベルを下げます |
| `modelPicker:increaseEffort` | Right | effort レベルを上げます |
| `modelPicker:thisSessionOnly` | s | ハイライトされたモデルをこのセッションのみに適用します |

### effort スライダーアクション

`EffortSlider` コンテキストで利用可能なアクションです。これは、引数なしで `/effort` を実行したときに開くスライダーです。スライダーの Enter キーと Escape キーは再バインドできません。

| アクション | デフォルト | 説明 |
| :- | :- | :- |
| `effortSlider:decreaseEffort` | Left | スライダーを 1 つ下の effort レベルに移動します。v2.1.284 以降が必要です |
| `effortSlider:increaseEffort` | Right | スライダーを 1 つ上の effort レベルに移動します。v2.1.284 以降が必要です |
| `effortSlider:toggleUltracode` | Tab | スライダーが [ultracode を提供している](https://code.claude.com/docs/ja/model-config.md#when-ultracode-is-available)場合に、このセッションの [ultracode](https://code.claude.com/docs/ja/workflows.md#let-claude-decide-with-ultracode) をオンまたはオフにします。v2.1.284 以降が必要です |
| `effortSlider:thisSessionOnly` | s | フォーカスされている [effort レベル](https://code.claude.com/docs/ja/model-config.md#adjust-effort-level)をこのセッションのみに適用します。v2.1.257 以降が必要です |

### Select アクション

`Select` コンテキストで利用可能なアクション：

| アクション | デフォルト | 説明 |
| :- | :- | :- |
| `select:next` | Down, J, Ctrl+N | 次のオプション |
| `select:previous` | Up, K, Ctrl+P | 前のオプション |
| `select:pageUp` | PageUp | オプションを 1 ページ分上に移動します |
| `select:pageDown` | PageDown | オプションを 1 ページ分下に移動します |
| `select:first` | Home | 最初のオプション |
| `select:last` | End | 最後のオプション |
| `select:accept` | Enter | 選択を確定します |
| `select:cancel` | Escape | 選択をキャンセルします |

`/skills`、`/mcp`、`/tasks` などのリストパネルでは、Claude Code は `select:pageUp`、`select:pageDown`、`select:first`、`select:last` のバインディングを適用します。`/model` ピッカーなど、その他のほとんどのリストでは、`select:first` と `select:last` のバインディングが適用されます。これらのリストでは、バインディングに関係なく PageUp と PageDown でオプションをページ送りします。

v2.1.280 より前は、これらのその他のリストは Home、End、および `select:first` と `select:last` のバインディングを無視していました。

v2.1.283 より前は、`/mcp` のツールリストは、バインディングに関係なく固定の PageUp キーと PageDown キーでページ送りしていました。

### プラグインアクション

`Plugin` コンテキストで利用可能なアクション：

| アクション | デフォルト | 説明 |
| :- | :- | :- |
| `plugin:toggle` | Space | プラグインの選択を切り替えます |
| `plugin:install` | I | 選択したプラグインをインストールします |
| `plugin:favorite` | F | 選択したプラグインをお気に入りに登録し、Installed タブの上部近くに並ぶようにします |

### プロンプト上部アクション

プロンプトの上にあるバンド用のアクションです。このバンドは、[mod](https://code.claude.com/docs/ja/plugins/mods/interface.md#pick-where-to-draw) がボタン、入力フィールド、セレクトを描画する共有の帯です。`abovePrompt:toggle` と `abovePrompt:focus` は `Chat` コンテキストで適用されます。その他のアクションは、バンドまたはペイン内でキーボードフォーカスを持っているものの[コンテキスト](#contexts)で適用されます。

| アクション | デフォルト | 説明 |
| :- | :- | :- |
| `abovePrompt:toggle` | Ctrl+X Ctrl+A | バンドを 1 行のヒントに折りたたむか、再び展開します |
| `abovePrompt:focus` | Ctrl+X Tab | キーボードフォーカスをバンドに移動し、次に開いている各[ペイン](#pane-actions)に移動し、最後のペインからプロンプトに戻します |
| `abovePrompt:next` | Tab | 次のコントロールにフォーカスします |
| `abovePrompt:previous` | Shift+Tab | 前のコントロールにフォーカスします |
| `abovePrompt:press` | Enter | フォーカスされたボタンを押すか、フォーカスされた入力フィールドを送信するか、セレクトでハイライトされたオプションを選択します |
| `abovePrompt:leave` | Escape | キーボードフォーカスをプロンプトに戻します |
| `abovePrompt:highlightNext` | Down | フォーカスされたセレクトで次のオプションをハイライトします |
| `abovePrompt:highlightPrevious` | Up | フォーカスされたセレクトで前のオプションをハイライトします |

[`AbovePrompt` コンテキスト](#contexts)では、デフォルトで Right と Left も `abovePrompt:next` と `abovePrompt:previous` を実行し、Space も `abovePrompt:press` を実行します。

`AbovePrompt` コンテキストは、Up、Down、PageUp、PageDown、Home、End も [ペインのスクロールアクション](#pane-actions) `pane:scrollUp` から `pane:bottom` にバインドしています。そのため、バンドでこれらのキーのいずれかを変更するには、`AbovePrompt` ブロックでスクロールアクションをバインドします。

### ペインアクション

[mod](https://code.claude.com/docs/ja/plugins/mods/interface.md#know-which-keys-your-mod-can-receive) が描画するペイン用のアクションです。スクロール、サイズ変更、閉じるアクションは `Pane` [コンテキスト](#contexts)で適用されます。`pane:close` は `PaneField` コンテキストでも適用されるため、ペインのフィールドのいずれかにフォーカスがある間も機能します。`pane:next` と `pane:previous` は、複数のペインが開いている間、`Global` コンテキストで適用されます。

| アクション | デフォルト | 説明 |
| :- | :- | :- |
| `pane:scrollUp` | Up | 表示できる以上の行がある場合に、ペインを上にスクロールします |
| `pane:scrollDown` | Down | 表示できる以上の行がある場合に、ペインを下にスクロールします |
| `pane:pageUp` | PageUp | ペインを 1 ページ上にスクロールします |
| `pane:pageDown` | PageDown | ペインを 1 ページ下にスクロールします |
| `pane:top` | Home | ペインの先頭にジャンプします |
| `pane:bottom` | End | ペインの末尾にジャンプします |
| `pane:grow` | Ctrl+X Left, Ctrl+X Up | ペインの領域を広げます：トランスクリプトの横にある場合は幅を、プロンプトの上にある場合は高さを広げます |
| `pane:shrink` | Ctrl+X Right, Ctrl+X Down | ペインの領域を狭めます：トランスクリプトの横にある場合は幅を、プロンプトの上にある場合は高さを狭めます |
| `pane:close` | Ctrl+X X | ペインを閉じます |
| `pane:next` | （未割り当て） | 次に開いているペインを表示します |
| `pane:previous` | （未割り当て） | 前に開いているペインを表示します |

`Pane` コンテキストは、Tab、Shift+Tab、Enter、Escape も、バンドと同じ[プロンプト上部アクション](#above-prompt-actions)にバインドしています。また、ペインの入力フィールドとセレクトは `AbovePromptInput` と `AbovePromptSelect` コンテキストを使用します。ペイン内で各キーが何をするかについては、[キーボードフォーカスとホットキー](https://code.claude.com/docs/ja/plugins/mods/interface.md#know-which-keys-your-mod-can-receive)に記載されています。

### 設定アクション

`Settings` コンテキストで利用可能なアクションです。`select:accept` と `confirm:no` のアクションは、[Select](#select-actions) と [Confirmation](#confirmation-actions) のコンテキストから再利用されていますが、Settings 固有の動作をします：変更は各設定項目を変更した時点ですぐに適用されるため、Escape は拒否するのではなく、変更を保存した状態でパネルを閉じます。

| アクション | デフォルト | 説明 |
| :- | :- | :- |
| `settings:search` | / | 検索モードに入ります |
| `settings:retry` | R | エラー時に使用状況データの読み込みを再試行します |
| `settings:fixUsage` | F | `/usage` のフッターに修正が表示されている場合に、Claude Code が適用できる [`/usage` の推奨事項](https://code.claude.com/docs/ja/costs#apply-recommendations-with-the-fix-shortcut)をセッションに送信します。v2.1.305 以降が必要です |
| `select:accept` | Enter, Space | 選択した設定項目を変更するか、そのサブメニューを開きます |
| `confirm:no` | Escape | パネルを閉じます。変更はすでに保存されています |

### エージェントアクション

`Agents` コンテキストで利用可能なアクションです。このコンテキストは、`claude agents` で開く[エージェントビュー](https://code.claude.com/docs/ja/agent-view.md)で適用されます。v2.1.257 以降が必要です。

| アクション | デフォルト | 説明 |
| :- | :- | :- |
| `agents:switchView` | Ctrl+S | [セッションのグループ化](https://code.claude.com/docs/ja/agent-view.md#organize-the-list)を状態とディレクトリの間で切り替えます |
| `agents:togglePin` | Ctrl+T | 選択したセッションを[ピン留めまたはピン留め解除](https://code.claude.com/docs/ja/agent-view.md#organize-the-list)します |
| `agents:find` | Ctrl+F | [`n:` フィルター](https://code.claude.com/docs/ja/agent-view#filter-sessions)を使用して、名前でセッションを検索します。v2.1.288 以降が必要です |
| `agents:rename` | Ctrl+R | 選択したセッションの[名前を変更](https://code.claude.com/docs/ja/agent-view.md#organize-the-list)します。v2.1.288 以降が必要です |
| `agents:previousGroup` | Ctrl+Up, Meta+Up | 前の[グループヘッダー](https://code.claude.com/docs/ja/agent-view.md#organize-the-list)にジャンプします。v2.1.288 以降が必要です |
| `agents:nextGroup` | Ctrl+Down, Meta+Down | 次のグループヘッダーにジャンプします。v2.1.288 以降が必要です |

エージェントビューが開いている間、Claude Code は `Agents` コンテキストがバインドしているキーに対して `Agents` のバインディングを使用し、同じキーに対する `Chat` や `Global` のバインディングを無視します。たとえば、エージェントビューで Ctrl+S を押すと、デフォルトの `chat:stash` がトリガーされるのではなく、セッションのグループ化が切り替わります。

ディスパッチ入力の外部エディタショートカットは `Agents` アクションではありません。エージェントビューは、`Chat` コンテキストの `chat:externalEditor` バインディング（デフォルトは Ctrl+G）に従います。

エージェントビューではバインディングは単一のキーストロークで発火するため、`chat:externalEditor` にバインドされた Ctrl+X Ctrl+E のコードでは、そこでエディタは開きません。

### 音声アクション

[音声入力](https://code.claude.com/docs/ja/voice-dictation.md)が有効な場合に `Chat` コンテキストで利用可能なアクション：

| アクション | デフォルト | 説明 |
| :- | :- | :- |
| `voice:pushToTalk` | Space | プロンプトを音声入力します。`/voice` のモードに応じて長押しまたはタップします |

### スクロールアクション

[フルスクリーンレンダリング](https://code.claude.com/docs/ja/fullscreen.md)が有効な場合に `Scroll` コンテキストで利用可能なアクション：

| アクション | デフォルト | 説明 |
| :- | :- | :- |
| `scroll:lineUp` | `wheelup` | 1 行上にスクロールします。マウスホイールでのスクロールがこのアクションをトリガーします |
| `scroll:lineDown` | `wheeldown` | 1 行下にスクロールします。マウスホイールでのスクロールがこのアクションをトリガーします |
| `scroll:pageUp` | PageUp | ビューポートの高さの半分だけ上にスクロールします |
| `scroll:pageDown` | PageDown | ビューポートの高さの半分だけ下にスクロールします |
| `scroll:top` | Ctrl+Home | 会話の先頭にジャンプします |
| `scroll:bottom` | Ctrl+End | 最新のメッセージにジャンプし、自動追従を再び有効にします |
| `scroll:halfPageUp` | （未割り当て） | ビューポートの高さの半分だけ上にスクロールします。`scroll:pageUp` と同じ動作で、vi 形式の再バインド用に提供されています |
| `scroll:halfPageDown` | （未割り当て） | ビューポートの高さの半分だけ下にスクロールします。`scroll:pageDown` と同じ動作で、vi 形式の再バインド用に提供されています |
| `scroll:fullPageUp` | （未割り当て） | ビューポートの高さ全体分上にスクロールします |
| `scroll:fullPageDown` | （未割り当て） | ビューポートの高さ全体分下にスクロールします |
| `selection:copy` | Ctrl+Shift+C / Cmd+C | 選択したテキストをクリップボードにコピーします |
| `selection:clear` | （未割り当て） | アクティブなテキスト選択を解除します。v2.1.234 以降が必要です |
| `selection:extendLeft` | Shift+Left | アクティブな選択を 1 列左に拡張します |
| `selection:extendRight` | Shift+Right | アクティブな選択を 1 列右に拡張します |
| `selection:extendUp` | Shift+Up | アクティブな選択を 1 行上に拡張します。選択が上端に達するとビューポートをスクロールします |
| `selection:extendDown` | Shift+Down | アクティブな選択を 1 行下に拡張します。選択が下端に達するとビューポートをスクロールします |
| `selection:extendLineStart` | Shift+Home | アクティブな選択を行頭まで拡張します |
| `selection:extendLineEnd` | Shift+End | アクティブな選択を行末まで拡張します |

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

* `Chat`：`ctrl+x ctrl+k`、`ctrl+x ctrl+e`、`ctrl+x enter`、`ctrl+x ctrl+a`、`ctrl+x ctrl+s`、`ctrl+x tab`、`ctrl+x ctrl+=`、`ctrl+x ctrl+-`、`ctrl+x ctrl+_`、`ctrl+x =`、`ctrl+x -`
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
        "ctrl+x ctrl+=": null,
        "ctrl+x ctrl+-": null,
        "ctrl+x ctrl+_": null,
        "ctrl+x =": null,
        "ctrl+x -": null,
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

`/config` のエディタモード設定で Vim モードを有効にすると、キーボードショートカットと Vim モードは独立して動作します。

* **Vim モード**はテキスト入力レベルで入力を処理します：カーソル移動、モード、モーション
* **キーボードショートカット** はコンポーネントレベルでアクションを処理します（todo の切り替えやメッセージの送信など）
* vim モードでは、Escape キーは INSERT モードから NORMAL モードに切り替えます。`chat:cancel` はトリガーされません
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
* スペルミスのあるモディファイア（例：`ctl+k`）。Claude Code はバインディング全体を無視します。モディファイアを修正してください（この例では `ctrl+k`）。
* キー文字列内の `+` の隣にあるスペース（例：`ctrl+ k`）。Claude Code はこの文字列を、`ctrl+` の後に `k` が続く[コード](#chords)として読み取ります。`ctrl+` 単独に一致するキー入力はないため、このバインディングは発火しません。スペースを削除してください。
* 無効なコンテキスト名
* 無効なアクション値（アクションが文字列または `null` ではない場合など）
* 不明なアクション名（登録されたアクションのタイプミスなど）。Claude Code はバインディングをスキップし、そのキーのデフォルトバインディングを有効に保ちます。
* 予約済みショートカットの競合
* 同じコンテキスト内の重複バインディング

Claude Code を [`--debug`](https://code.claude.com/docs/ja/cli-reference#cli-flags) で起動して、詳細を確認してください。
