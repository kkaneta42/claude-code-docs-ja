> ## Documentation Index
> Fetch the complete documentation index at: https://code.claude.com/docs/llms.txt
> Use this file to discover all available pages before exploring further.

# キーボードショートカットのカスタマイズ

> キーボードショートカットをカスタマイズして、Claude Code でキーバインディング設定ファイルを使用します。

Claude Code はカスタマイズ可能なキーボードショートカットをサポートしています。`/keybindings` を実行して、`~/.claude/keybindings.json` に設定ファイルを作成または開きます。

<h2 id="configuration-file">
  設定ファイル
</h2>

キーバインディング設定ファイルは、`bindings` 配列を持つオブジェクトです。各ブロックはコンテキストとキーストロークからアクションへのマップを指定します。

<Note>キーバインディングファイルへの変更は自動的に検出され、Claude Code を再起動することなく適用されます。</Note>

| フィールド      | 説明                                  |
| :--------- | :---------------------------------- |
| `$schema`  | エディタのオートコンプリート用のオプション JSON スキーマ URL |
| `$docs`    | オプションのドキュメント URL                    |
| `bindings` | コンテキスト別のバインディングブロックの配列              |

この例では、チャットコンテキストで `Ctrl+E` を外部エディタを開くにバインドし、`Ctrl+U` をアンバインドします。

```json theme={null}
{
  "$schema": "https://www.schemastore.org/claude-code-keybindings.json",
  "$docs": "https://code.claude.com/docs/ja/keybindings",
  "bindings": [
    {
      "context": "Chat",
      "bindings": {
        "ctrl+e": "chat:externalEditor",
        "ctrl+u": null
      }
    }
  ]
}
```

<h2 id="contexts">
  コンテキスト
</h2>

各バインディングブロックは、バインディングが適用される**コンテキスト**を指定します。

| コンテキスト            | 説明                                                |
| :---------------- | :------------------------------------------------ |
| `Global`          | アプリ全体に適用                                          |
| `Chat`            | メインチャット入力エリア                                      |
| `Autocomplete`    | オートコンプリートメニューが開いている                               |
| `Settings`        | 設定メニュー                                            |
| `Confirmation`    | 権限と確認ダイアログ                                        |
| `Tabs`            | タブナビゲーションコンポーネント                                  |
| `Help`            | ヘルプメニューが表示されている                                   |
| `Transcript`      | トランスクリプトビューア                                      |
| `HistorySearch`   | 履歴検索モード（Ctrl+R）                                   |
| `Task`            | バックグラウンドタスクが実行中                                   |
| `ThemePicker`     | テーマピッカーダイアログ                                      |
| `Attachments`     | 選択ダイアログ内の画像添付ファイルナビゲーション                          |
| `Footer`          | フッターインジケータナビゲーション（タスク、チーム、diff、Artifacts）         |
| `MessageSelector` | 巻き戻しと要約ダイアログのメッセージ選択                              |
| `DiffDialog`      | Diff ビューアナビゲーション                                  |
| `DiffPanel`       | [diff パネル](/docs/ja/interactive-mode#diff-panel)が開いている |
| `ModelPicker`     | モデルピッカー努力レベル                                      |
| `EffortSlider`    | `/effort` で開かれた努力スライダー                            |
| `Select`          | 汎用選択/リストコンポーネント                                   |
| `Plugin`          | プラグインダイアログ（参照、発見、管理）                              |
| `Agents`          | [エージェントビュー](/docs/ja/agent-view)（`claude agents`）      |
| `Scroll`          | 会話スクロールとフルスクリーンモードでのテキスト選択                        |

v2.1.205 より前では、`Doctor` コンテキストと `/doctor` 診断スクリーン用の `doctor:fix` アクションが存在していました。

<h2 id="available-actions">
  利用可能なアクション
</h2>

アクションは `namespace:action` 形式に従います。例えば、`chat:submit` はメッセージを送信し、`app:toggleTodos` はタスクリストを表示します。各コンテキストには特定のアクションが利用可能です。

<h3 id="app-actions">
  アプリアクション
</h3>

`Global` コンテキストで利用可能なアクション：

| アクション                  | デフォルト    | 説明                                                                          |
| :--------------------- | :------- | :-------------------------------------------------------------------------- |
| `app:interrupt`        | Ctrl+C   | 現在の操作をキャンセル                                                                 |
| `app:exit`             | Ctrl+D   | Claude Code を終了します。800ms 以内に 2 回押して確認                                       |
| `app:redraw`           | （アンバインド） | ターミナルを強制的に再描画                                                               |
| `app:toggleTodos`      | Ctrl+T   | Claude のタスクリストの表示を切り替えます。これは [`/tasks`](/docs/ja/commands) バックグラウンドタスクビューではありません |
| `app:toggleTranscript` | Ctrl+O   | 詳細トランスクリプトの表示を切り替え                                                          |

<h3 id="history-actions">
  履歴アクション
</h3>

コマンド履歴をナビゲートするためのアクション：

| アクション              | デフォルト  | 説明      |
| :----------------- | :----- | :------ |
| `history:search`   | Ctrl+R | 履歴検索を開く |
| `history:previous` | Up     | 前の履歴項目  |
| `history:next`     | Down   | 次の履歴項目  |

<h3 id="chat-actions">
  チャットアクション
</h3>

`Chat` コンテキストで利用可能なアクション：

| アクション                 | デフォルト                             | 説明                                                                                                                                                                                                     |
| :-------------------- | :-------------------------------- | :----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `chat:cancel`         | Escape                            | 現在の入力をキャンセル                                                                                                                                                                                            |
| `chat:clearInput`     | Ctrl+L                            | 入力と会話を保持したまま全画面再描画を強制します。[フルスクリーンレンダリング](/docs/ja/fullscreen#clear-the-conversation)では、スクリーンもクリア                                                                                                            |
| `chat:clearScreen`    | Cmd+K                             | `chat:clearInput` と同じです。[会話をクリア](/docs/ja/fullscreen#clear-the-conversation)で Cmd+K が iTerm2 と Terminal.app でどのように動作するかを参照してください                                                                            |
| `chat:killAgents`     | Ctrl+X Ctrl+K                     | このセッション内のすべての実行中の[バックグラウンドサブエージェント](/docs/ja/sub-agents#run-subagents-in-foreground-or-background)を停止し、このセッションの残りの[アーティファクト自動返信](/docs/ja/artifacts#let-claude-reply-to-comments-on-its-own)をオフにします              |
| `chat:cycleMode`      | Shift+Tab\*                       | 権限モードをサイクル                                                                                                                                                                                             |
| `chat:modelPicker`    | Meta+P                            | モデルピッカーを開く                                                                                                                                                                                             |
| `chat:fastMode`       | Meta+O                            | 高速モードを切り替え                                                                                                                                                                                             |
| `chat:thinkingToggle` | Meta+T                            | 拡張思考を切り替え                                                                                                                                                                                              |
| `chat:submit`         | Enter                             | メッセージを送信                                                                                                                                                                                               |
| `chat:queueSubmit`    | Ctrl+X Enter                      | メッセージを送信し、順番を待つようにマークします：Claude が作業中の場合、Claude Code は[それをキューに入れ](/docs/ja/interactive-mode#queue-messages-while-claude-works)、ターンを中断しません。`chat:submit` とは異なり、オートコンプリート提案が開いている場合でもドラフトを送信します。v2.1.247 以降が必要 |
| `chat:newline`        | Ctrl+J                            | 送信せずに改行を挿入                                                                                                                                                                                             |
| `chat:undo`           | Ctrl+\_、Ctrl+Shift+-              | 最後のアクションを元に戻す                                                                                                                                                                                          |
| `chat:externalEditor` | Ctrl+G、Ctrl+X Ctrl+E              | 外部エディタで開きます。[エージェントビューディスパッチ入力](/docs/ja/agent-view#keyboard-shortcuts)もこのアクションの単一キーストロークバインディングに従います                                                                                                       |
| `chat:stash`          | Ctrl+S                            | 現在のプロンプトを保存                                                                                                                                                                                            |
| `chat:imagePaste`     | Ctrl+V（Windows では Alt+V、WSL では両方） | クリップボードから画像を貼り付けます。WSL では、両方のショートカットがデフォルトでバインドされています                                                                                                                                                  |

\*VT モードなし（Node \<24.2.0/\<22.17.0、Bun \<1.2.23）の Windows では、デフォルトは Meta+M です。

<h3 id="autocomplete-actions">
  オートコンプリートアクション
</h3>

`Autocomplete` コンテキストで利用可能なアクション：

| アクション                   | デフォルト  | 説明       |
| :---------------------- | :----- | :------- |
| `autocomplete:accept`   | Tab    | 提案を受け入れ  |
| `autocomplete:dismiss`  | Escape | メニューを閉じる |
| `autocomplete:previous` | Up     | 前の提案     |
| `autocomplete:next`     | Down   | 次の提案     |

<h3 id="confirmation-actions">
  確認アクション
</h3>

`Confirmation` コンテキストで利用可能なアクション：

| アクション                   | デフォルト       | 説明                                                                                                                                                                                          |
| :---------------------- | :---------- | :------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| `confirm:yes`           | Y、Enter     | アクションを確認                                                                                                                                                                                    |
| `confirm:no`            | N、Escape    | アクションを拒否                                                                                                                                                                                    |
| `confirm:previous`      | Up          | 前のオプション                                                                                                                                                                                     |
| `confirm:next`          | Down        | 次のオプション                                                                                                                                                                                     |
| `confirm:nextField`     | Tab         | 次のフィールド                                                                                                                                                                                     |
| `confirm:previousField` | （アンバインド）    | 前のフィールド                                                                                                                                                                                     |
| `confirm:toggle`        | Space       | 選択を切り替え                                                                                                                                                                                     |
| `confirm:cycleMode`     | Shift+Tab\* | 権限モードをサイクルします。ファイル権限プロンプトでは、開いている[コメントフィールド](/docs/ja/permissions#add-a-comment-when-you-answer-a-permission-prompt)を閉じます。フィールドが開いていない場合は、プロンプトがそのオプションを提供するときに、セッションの残りの期間アクションを許可するオプションを選択します |

\*VT モードなし（Node \<24.2.0/\<22.17.0、Bun \<1.2.23）の Windows では、デフォルトは Meta+M です。

v2.1.257 より前では、`confirm:toggleExplanation` アクション（デフォルトでは Ctrl+E にバインド）が Bash および PowerShell 権限プロンプトでモデルが生成したコマンドの説明を表示していました。

<h3 id="permission-actions">
  権限アクション
</h3>

権限ダイアログの `Confirmation` コンテキストで利用可能なアクション：

| アクション                    | デフォルト    | 説明                                                                               |
| :----------------------- | :------- | :------------------------------------------------------------------------------- |
| `permission:toggleDebug` | （アンバインド） | 権限デバッグ情報を切り替えます。Ctrl+D の以前のデフォルトは v2.1.146 で削除されました。これは `app:exit` をシャドウしていたためです |

<h3 id="transcript-actions">
  トランスクリプトアクション
</h3>

`Transcript` コンテキストで利用可能なアクション：

| アクション                      | デフォルト           | 説明                |
| :------------------------- | :-------------- | :---------------- |
| `transcript:toggleShowAll` | Ctrl+E          | すべてのコンテンツの表示を切り替え |
| `transcript:exit`          | q、Ctrl+C、Escape | トランスクリプトビューを終了    |

`transcript:toggleShowAll` はクラシックレンダラーにのみ適用されます。[フルスクリーンレンダリング](/docs/ja/fullscreen)では、トランスクリプトビューアは表示切り替えオプションを提供しません。

<h3 id="history-search-actions">
  履歴検索アクション
</h3>

`HistorySearch` コンテキストで利用可能なアクション：

| アクション                      | デフォルト      | 説明                         |
| :------------------------- | :--------- | :------------------------- |
| `historySearch:next`       | Ctrl+R     | 次のマッチ                      |
| `historySearch:accept`     | Escape、Tab | 選択を受け入れ                    |
| `historySearch:cancel`     | Ctrl+C     | 検索をキャンセル                   |
| `historySearch:execute`    | Enter      | 選択したコマンドを実行                |
| `historySearch:cycleScope` | Ctrl+S     | スコープをサイクル：セッション、プロジェクト、すべて |

`historySearch:next`、`historySearch:accept`、`historySearch:cancel`、`historySearch:execute` のデフォルトはクラシックレンダラーのインライン履歴検索に適用され、常にすべてのプロジェクトからプロンプトを検索します。`historySearch:cycleScope` は[フルスクリーンレンダリング](/docs/ja/fullscreen)でのみ有効です。ここで Ctrl+R は検索ダイアログを開き、Ctrl+S はそのスコープをサイクルします。ダイアログの他のキーは固定されており、再バインドできません：Enter または Tab はハイライトされたマッチをプロンプト入力に配置し、Esc はキャンセルします。

<h3 id="task-actions">
  タスクアクション
</h3>

`Task` コンテキストで利用可能なアクション：

| アクション             | デフォルト                | 説明                                                        |
| :---------------- | :------------------- | :-------------------------------------------------------- |
| `task:background` | Ctrl+B、Ctrl+X Ctrl+B | 現在のタスクをバックグラウンドに。Ctrl+X Ctrl+B コードは tmux プレフィックスの競合を回避します |

<h3 id="theme-actions">
  テーマアクション
</h3>

`ThemePicker` コンテキストで利用可能なアクション：

| アクション                            | デフォルト  | 説明               |
| :------------------------------- | :----- | :--------------- |
| `theme:toggleSyntaxHighlighting` | Ctrl+T | シンタックスハイライトを切り替え |

<h3 id="help-actions">
  ヘルプアクション
</h3>

`Help` コンテキストで利用可能なアクション：

| アクション          | デフォルト  | 説明          |
| :------------- | :----- | :---------- |
| `help:dismiss` | Escape | ヘルプメニューを閉じる |

<h3 id="tabs-actions">
  タブアクション
</h3>

`Tabs` コンテキストで利用可能なアクション：

| アクション           | デフォルト          | 説明   |
| :-------------- | :------------- | :--- |
| `tabs:next`     | Tab、Right      | 次のタブ |
| `tabs:previous` | Shift+Tab、Left | 前のタブ |

<h3 id="attachments-actions">
  添付ファイルアクション
</h3>

`Attachments` コンテキストで利用可能なアクション：

| アクション                  | デフォルト            | 説明               |
| :--------------------- | :--------------- | :--------------- |
| `attachments:next`     | Right            | 次の添付ファイル         |
| `attachments:previous` | Left             | 前の添付ファイル         |
| `attachments:remove`   | Backspace、Delete | 選択した添付ファイルを削除    |
| `attachments:exit`     | Down、Escape      | 添付ファイルナビゲーションを終了 |

<h3 id="footer-actions">
  フッターアクション
</h3>

`Footer` コンテキストで利用可能なアクション：

| アクション                   | デフォルト            | 説明                                                                                                             |
| :---------------------- | :--------------- | :------------------------------------------------------------------------------------------------------------- |
| `footer:next`           | Right            | 次のフッター項目                                                                                                       |
| `footer:previous`       | Left             | 前のフッター項目                                                                                                       |
| `footer:up`             | Up               | フッター内で上に移動（最上部で選択解除）                                                                                           |
| `footer:down`           | Down             | フッター内で下に移動                                                                                                     |
| `footer:openSelected`   | Enter            | 選択したフッター項目を開く                                                                                                  |
| `footer:clearSelection` | Escape           | フッター選択をクリア                                                                                                     |
| `footer:dismiss`        | Backspace、Delete | 選択した[アーティファクト](/docs/ja/artifacts)リンクをフッターから削除します。公開されたアーティファクト自体は影響を受けません。他のフッター行では、これらのキーは効果がありません。v2.1.217 以降が必要 |

<h3 id="message-selector-actions">
  メッセージセレクタアクション
</h3>

`MessageSelector` コンテキストで利用可能なアクション：

| アクション                    | デフォルト                                  | 説明       |
| :----------------------- | :------------------------------------- | :------- |
| `messageSelector:up`     | Up、K、Ctrl+P                            | リストで上に移動 |
| `messageSelector:down`   | Down、J、Ctrl+N                          | リストで下に移動 |
| `messageSelector:top`    | Ctrl+Up、Shift+Up、Meta+Up、Shift+K       | 最上部にジャンプ |
| `messageSelector:bottom` | Ctrl+Down、Shift+Down、Meta+Down、Shift+J | 最下部にジャンプ |
| `messageSelector:select` | Enter                                  | メッセージを選択 |

<h3 id="diff-actions">
  Diff アクション
</h3>

`DiffDialog` コンテキストで利用可能なアクション：

| アクション                 | デフォルト    | 説明                                                                                                |
| :-------------------- | :------- | :------------------------------------------------------------------------------------------------ |
| `diff:dismiss`        | Escape   | Diff ビューアを閉じます。詳細ビューからは、ファイルリストに戻ります                                                              |
| `diff:previousSource` | Left     | 前の Diff ソース                                                                                       |
| `diff:nextSource`     | Right    | 次の Diff ソース                                                                                       |
| `diff:previousFile`   | Up、K     | ファイルリストの前のファイル。詳細ビューで 1 行上にスクロール                                                                  |
| `diff:nextFile`       | Down、J   | ファイルリストの次のファイル。詳細ビューで 1 行下にスクロール                                                                  |
| `diff:viewDetails`    | Enter    | Diff の詳細を表示                                                                                       |
| `diff:back`           | （アンバインド） | Diff ビューアで戻ります。Escape は `diff:dismiss` を通じて戻るアクションを実行します。詳細ビューの Left の以前のデフォルトは v2.1.203 で削除されました |

Diff 詳細ビューは、ページャースタイルのキーを標準的な[スクロールアクション](#scroll-actions)にバインドします。これらのバインディングは `DiffDialog` コンテキストの一部であり、詳細ビューにのみ適用されます。[スクロールアクション](#scroll-actions)の下に記載されている `Scroll` コンテキストのデフォルトは変わりません。

| アクション                 | デフォルト         | 説明                 |
| :-------------------- | :------------ | :----------------- |
| `scroll:pageUp`       | PageUp        | ビューポートの半分だけ上にスクロール |
| `scroll:pageDown`     | PageDown      | ビューポートの半分だけ下にスクロール |
| `scroll:fullPageUp`   | Shift+Space、B | ビューポート全体だけ上にスクロール  |
| `scroll:fullPageDown` | Space         | ビューポート全体だけ下にスクロール  |
| `scroll:top`          | G、Home        | 最上部にジャンプ           |
| `scroll:bottom`       | Shift+G、End   | 最下部にジャンプ           |

<h3 id="diff-panel-actions">
  Diff パネルアクション
</h3>

`/diff` がフルスクリーンレンダリングで開く[Diff パネル](/docs/ja/interactive-mode#diff-panel)のアクション。`app:cycleDiffBase` は `DiffPanel` コンテキストにあり、パネルが開いている間はアクティブです。他は `Global` です。パネルは Claude Code v2.1.260 以降が必要です。

| アクション                       | デフォルト               | 説明                                     |
| :-------------------------- | :------------------ | :------------------------------------- |
| `app:toggleReplTab`         | （アンバインド）            | Diff パネルを開くか閉じます。`/diff` を実行するのと同じです   |
| `app:cycleDiffBase`         | Ctrl+X B            | パネルの比較ベースをサイクル：このセッション、コミットされていない、ブランチ |
| `app:diffFileListUp`        | Ctrl+Up、Meta+Up     | パネルのファイルリストがオーバーフローするときに上にスクロール        |
| `app:diffFileListDown`      | Ctrl+Down、Meta+Down | パネルのファイルリストがオーバーフローするときに下にスクロール        |
| `app:toggleDiffNoiseFilter` | （アンバインド）            | パネルのテストファイルと生成ファイルを表示または非表示            |
| `app:toggleDiffPreSession`  | （アンバインド）            | このセッション前の変更を展開または折りたたむ                 |

<h3 id="model-picker-actions">
  モデルピッカーアクション
</h3>

`ModelPicker` コンテキストで利用可能なアクション：

| アクション                         | デフォルト | 説明                       |
| :---------------------------- | :---- | :----------------------- |
| `modelPicker:decreaseEffort`  | Left  | 努力レベルを低下                 |
| `modelPicker:increaseEffort`  | Right | 努力レベルを増加                 |
| `modelPicker:thisSessionOnly` | s     | ハイライトされたモデルをこのセッションのみに適用 |

<h3 id="effort-slider-actions">
  努力スライダーアクション
</h3>

`EffortSlider` コンテキストで利用可能なアクション。引数なしで `/effort` を実行するときに開くスライダー。スライダーの Left、Right、Enter、Escape キーは再バインドできません。

| アクション                          | デフォルト | 説明                                                                                   |
| :----------------------------- | :---- | :----------------------------------------------------------------------------------- |
| `effortSlider:thisSessionOnly` | s     | フォーカスされた[努力レベル](/docs/ja/model-config#adjust-effort-level)をこのセッションのみに適用します。v2.1.257 以降が必要 |

<h3 id="select-actions">
  選択アクション
</h3>

`Select` コンテキストで利用可能なアクション：

| アクション             | デフォルト         | 説明               |
| :---------------- | :------------ | :--------------- |
| `select:next`     | Down、J、Ctrl+N | 次のオプション          |
| `select:previous` | Up、K、Ctrl+P   | 前のオプション          |
| `select:pageUp`   | PageUp        | オプションの 1 ページ上に移動 |
| `select:pageDown` | PageDown      | オプションの 1 ページ下に移動 |
| `select:first`    | Home          | 最初のオプション         |
| `select:last`     | End           | 最後のオプション         |
| `select:accept`   | Enter         | 選択を受け入れ          |
| `select:cancel`   | Escape        | 選択をキャンセル         |

Claude Code は `/skills` メニューで `select:pageUp`、`select:pageDown`、`select:first`、`select:last` バインディングを適用します。`/model` ピッカーなどほとんどの他のリストでは、Claude Code はバインディングに関係なく PageUp と PageDown でページングし、Home と End を無視します。

<h3 id="plugin-actions">
  プラグインアクション
</h3>

`Plugin` コンテキストで利用可能なアクション：

| アクション             | デフォルト | 説明                                              |
| :---------------- | :---- | :---------------------------------------------- |
| `plugin:toggle`   | Space | プラグイン選択を切り替え                                    |
| `plugin:install`  | I     | 選択したプラグインをインストール                                |
| `plugin:favorite` | F     | 選択したプラグインをお気に入りにして、インストール済みタブの上部付近にソートされるようにします |

<h3 id="settings-actions">
  設定アクション
</h3>

`Settings` コンテキストで利用可能なアクション。`select:accept` と `confirm:no` アクションは[選択](#select-actions)と[確認](#confirmation-actions)コンテキストから再利用されており、設定固有の動作があります：変更は設定を変更するとすぐに各設定に適用されるため、Escape は変更を破棄するのではなく、変更を保存して閉じます。

| アクション             | デフォルト       | 説明                       |
| :---------------- | :---------- | :----------------------- |
| `settings:search` | /           | 検索モードに入る                 |
| `settings:retry`  | R           | 使用状況データの読み込みを再試行（エラー時）   |
| `select:accept`   | Enter、Space | 選択した設定を変更するか、そのサブメニューを開く |
| `confirm:no`      | Escape      | パネルを閉じます。変更は既に保存されています   |

<h3 id="agents-actions">
  エージェントアクション
</h3>

`Agents` コンテキストで利用可能なアクション。`claude agents` で開く[エージェントビュー](/docs/ja/agent-view)に適用されます。v2.1.257 以降が必要です。

| アクション               | デフォルト  | 説明                                                              |
| :------------------ | :----- | :-------------------------------------------------------------- |
| `agents:switchView` | Ctrl+S | [セッショングループ化](/docs/ja/agent-view#organize-the-list)を状態とディレクトリの間で切り替え |
| `agents:togglePin`  | Ctrl+T | 選択したセッションを[ピン留めまたはピン留め解除](/docs/ja/agent-view#organize-the-list)     |

エージェントビューが開いている間、Claude Code は `Agents` コンテキストがキーをバインドする場合、そのキーに対して `Agents` バインディングを使用し、同じキーの `Chat` または `Global` バインディングを無視します。例えば、エージェントビューで Ctrl+S を押すと、デフォルトの `chat:stash` をトリガーするのではなく、セッショングループ化を切り替えます。

ディスパッチ入力の外部エディタショートカットは `Agents` アクションではありません。エージェントビューは `Chat` コンテキストの `chat:externalEditor` バインディング（デフォルトでは Ctrl+G）に従います。

エージェントビューではバインディングが単一キーストロークで発火するため、`chat:externalEditor` にバインドされた Ctrl+X Ctrl+E コードはエディタを開きません。

<h3 id="voice-actions">
  音声アクション
</h3>

[音声ディクテーション](/docs/ja/voice-dictation)が有効な場合、`Chat` コンテキストで利用可能なアクション：

| アクション              | デフォルト | 説明                                            |
| :----------------- | :---- | :-------------------------------------------- |
| `voice:pushToTalk` | Space | プロンプトをディクテートします。`/voice` モードに応じて押し続けるか、タップします |

<h3 id="scroll-actions">
  スクロールアクション
</h3>

[フルスクリーンレンダリング](/docs/ja/fullscreen)が有効な場合、`Scroll` コンテキストで利用可能なアクション：

| アクション                       | デフォルト                | 説明                                                                |
| :-------------------------- | :------------------- | :---------------------------------------------------------------- |
| `scroll:lineUp`             | `wheelup`            | 1 行上にスクロール。マウスホイールスクロールがこのアクションをトリガー                              |
| `scroll:lineDown`           | `wheeldown`          | 1 行下にスクロール。マウスホイールスクロールがこのアクションをトリガー                              |
| `scroll:pageUp`             | PageUp               | ビューポート高さの半分だけ上にスクロール                                              |
| `scroll:pageDown`           | PageDown             | ビューポート高さの半分だけ下にスクロール                                              |
| `scroll:top`                | Ctrl+Home            | 会話の開始位置にジャンプ                                                      |
| `scroll:bottom`             | Ctrl+End             | 最新メッセージにジャンプして自動フォローを再度有効化                                        |
| `scroll:halfPageUp`         | （アンバインド）             | ビューポート高さの半分だけ上にスクロール。`scroll:pageUp` と同じ動作で、vi スタイルの再バインドのために提供   |
| `scroll:halfPageDown`       | （アンバインド）             | ビューポート高さの半分だけ下にスクロール。`scroll:pageDown` と同じ動作で、vi スタイルの再バインドのために提供 |
| `scroll:fullPageUp`         | （アンバインド）             | ビューポート高さ全体だけ上にスクロール                                               |
| `scroll:fullPageDown`       | （アンバインド）             | ビューポート高さ全体だけ下にスクロール                                               |
| `selection:copy`            | Ctrl+Shift+C / Cmd+C | 選択したテキストをクリップボードにコピー                                              |
| `selection:clear`           | （アンバインド）             | アクティブなテキスト選択をクリアします。v2.1.234 以降が必要                                |
| `selection:extendLeft`      | Shift+Left           | アクティブな選択を 1 列左に拡張                                                 |
| `selection:extendRight`     | Shift+Right          | アクティブな選択を 1 列右に拡張                                                 |
| `selection:extendUp`        | Shift+Up             | アクティブな選択を 1 行上に拡張。選択が上端に達するとビューポートをスクロール                          |
| `selection:extendDown`      | Shift+Down           | アクティブな選択を 1 行下に拡張。選択が下端に達するとビューポートをスクロール                          |
| `selection:extendLineStart` | Shift+Home           | アクティブな選択を行の開始位置に拡張                                                |
| `selection:extendLineEnd`   | Shift+End            | アクティブな選択を行の終了位置に拡張                                                |

<h2 id="keystroke-syntax">
  キーストロークシンタックス
</h2>

<h3 id="modifiers">
  モディファイア
</h3>

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

<h3 id="uppercase-letters">
  大文字
</h3>

Claude Code はキー名を大文字と小文字を区別せずに解析するため、`K` は `k` と同じバインディングであり、`ctrl+K` は `ctrl+k` と同じです。Shift とレターをバインドするには、`shift+k` と記述します。

<h3 id="non-us-keyboard-layouts">
  非 US キーボードレイアウト
</h3>

Ctrl ショートカットのキー名は、アクティブなキーボードレイアウトが他の文字を入力する場合でも、ラテン文字として記述してください。

Claude Code がキーボードで押したキーをバインディングにマッチさせる方法は、レイアウトの種類によって異なります。

* キリル文字などの非ラテンレイアウトの場合、Claude Code はターミナルが Kitty キーボードプロトコルを使用し、その位置を報告する場合、キーの US レイアウト位置で Ctrl ショートカットをマッチさせます。そのようなターミナルでロシア語レイアウトがアクティブな場合、Ctrl キーと物理的な W キーを押すと `ctrl+w` がトリガーされます。位置を報告しないターミナルでは、Claude Code はターミナルがキープレスに対して送信するものをマッチさせます。ASCII 制御コードは Latin ショートカットをトリガーし、キリル文字として到着するキープレスはバインディングにマッチしません。
* AZERTY などのラテン文字を並べ替えるレイアウトの場合、Claude Code はキーが入力する文字をマッチさせるため、Ctrl キーと A というラベルのキーを押すと `ctrl+a` がトリガーされます。

v2.1.247 より前では、Ghostty、Kitty、WezTerm、iTerm2 などの Kitty キーボードプロトコルを使用するターミナルで、非ラテンレイアウトの下で Ctrl ショートカットを押してもそのバインディングはトリガーされませんでした。

<h3 id="chords">
  コード
</h3>

コードはスペースで区切られたキーストロークのシーケンスです。

```text theme={null}
ctrl+k ctrl+s   Ctrl+K を押して、リリースしてから Ctrl+S
```

<h3 id="special-keys">
  特殊キー
</h3>

* `escape` または `esc` - Escape キー
* `enter` または `return` - Enter キー
* `tab` - Tab キー
* `space` - スペースバー
* `up`、`down`、`left`、`right` - 矢印キー
* `pageup`、`pagedown` - Page Up キーと Page Down キー
* `home`、`end` - Home キーと End キー
* `backspace`、`delete` - Delete キー
* `wheelup`、`wheeldown` - マウスホイールスクロールイベント

<h2 id="unbind-default-shortcuts">
  デフォルトショートカットをアンバインド
</h2>

アクションを `null` に設定して、デフォルトショートカットをアンバインドします。

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

これはコード バインディングでも機能します。プレフィックスを共有するすべてのコードをアンバインドすると、そのプレフィックスを単一キー バインディングとして使用できるようになります。コード バインディングは任意のアクティブなコンテキストに存在し、そのプレフィックスを予約したままにするため、それを定義するコンテキストで各コードをアンバインドする必要があります。

Claude Code は `ctrl+x` プレフィックスに以下のデフォルトコードをバインドします。`Chat` では `ctrl+x ctrl+k`、`ctrl+x ctrl+e`、`ctrl+x enter`、`Task` では `ctrl+x ctrl+b`、`DiffPanel` では `ctrl+x b` です。`ctrl+x enter` コードは v2.1.247 以降が必要で、`ctrl+x b` は v2.1.260 以降が必要です。`ctrl+x` 自体を単一キー バインディングとして再利用するには、すべてをアンバインドします。

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
      "context": "Chat",
      "bindings": {
        "ctrl+x ctrl+k": null,
        "ctrl+x ctrl+e": null,
        "ctrl+x enter": null,
        "ctrl+x": "chat:newline"
      }
    }
  ]
}
```

プレフィックス上の一部のコードをアンバインドしても、すべてをアンバインドしない場合、プレフィックスを押すと残りのバインディングのコード待機モードに入ります。

<h2 id="reserved-shortcuts">
  予約済みショートカット
</h2>

これらのショートカットは再バインドできません。

| ショートカット   | 理由                                                                                                                                                                                                  |
| :-------- | :-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Ctrl+C    | ハードコードされた割り込み/キャンセル                                                                                                                                                                                 |
| Ctrl+D    | ハードコードされた終了                                                                                                                                                                                         |
| Ctrl+M    | Claude Code は常に Enter として受け取ります                                                                                                                                                                     |
| Ctrl+\[   | Claude Code は常に Escape として受け取ります。Kitty キーボードプロトコルを使用するターミナルでは、v2.1.242 以降が必要です                                                                                                                      |
| Ctrl+I    | Claude Code は常に Tab として受け取ります                                                                                                                                                                       |
| Ctrl+H    | ASCII バックスペースバイトを送信します。[Claude Code が Windows で読み込む方法](/docs/ja/terminal-config#fix-backspace-deleting-a-whole-word-on-windows)は、ターミナルと [`CLAUDE_CODE_BS_AS_CTRL_BACKSPACE`](/docs/ja/env-vars) 環境変数によって異なります |
| Caps Lock | ターミナルアプリケーションに配信されない                                                                                                                                                                                |

<h2 id="terminal-conflicts">
  ターミナルの競合
</h2>

一部のショートカットはターミナルマルチプレクサと競合する可能性があります。

| ショートカット | 競合                     |
| :------ | :--------------------- |
| Ctrl+B  | tmux プレフィックス（2 回押して送信） |
| Ctrl+A  | GNU screen プレフィックス     |
| Ctrl+Z  | Unix プロセス一時停止（SIGTSTP） |

<h2 id="vim-mode-interaction">
  Vim モードの相互作用
</h2>

Vim モードが `/config` → エディタモードで有効な場合、キーバインディングと Vim モードは独立して動作します。

* **Vim モード** はテキスト入力レベルで入力を処理します（カーソル移動、モード、モーション）
* **キーバインディング** はコンポーネントレベルでアクションを処理します（todos を切り替え、送信など）
* Vim モードの Escape キーは INSERT から NORMAL モードに切り替わります。`chat:cancel` をトリガーしません
* ほとんどの Ctrl+key ショートカットは Vim モードを通過してキーバインディングシステムに渡されます
* Vim キーはキーバインディングファイルを通じて再マップできません。`jj` を Escape にマップするような 2 キーの INSERT モードシーケンスをマップするには、[`vimInsertModeRemaps`](/docs/ja/interactive-mode#remap-insert-mode-key-sequences) 設定を使用してください
* Vim NORMAL モードでは、`?` はヘルプメニューを表示します（Vim の動作）
* Vim NORMAL モードでは、`/` は履歴検索を開きます。標準モードの Ctrl+R と同じです

<h2 id="validation">
  検証
</h2>

Claude Code はキーバインディングを検証し、以下の警告を表示します。

* 解析エラー（無効な JSON または構造）
* 無効なコンテキスト名
* 無効なアクション値（アクションが文字列または `null` ではない場合など）
* 不明なアクション名（登録されたアクションのタイプミスなど）。Claude Code はバインディングをスキップし、そのキーのデフォルトバインディングを有効に保ちます。v2.1.246 より前では、不明なアクション名を持つバインディングはそのキーを静かに無効化していました
* 予約済みショートカットの競合
* 同じコンテキスト内の重複バインディング

Claude Code はファイルが読み込まれるときに警告を報告し、各警告をデバッグログに書き込みます。Claude Code を [`--debug`](/docs/ja/cli-reference#cli-flags) で起動して、詳細を確認してください。
