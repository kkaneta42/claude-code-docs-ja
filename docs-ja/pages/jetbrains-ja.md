> ## Documentation Index
> Fetch the complete documentation index at: https://code.claude.com/docs/llms.txt
> Use this file to discover all available pages before exploring further.

# JetBrains IDEs

> Claude CodeをIntelliJ、PyCharm、WebStormなどのJetBrains IDEで使用する

Claude CodeはJetBrains IDEsと専用プラグインを通じて統合され、インタラクティブなdiff表示、選択コンテキスト共有などの機能を提供します。

## サポートされているIDE

Claude CodeプラグインはほとんどのJetBrains IDEで動作します。以下を含みます：

* IntelliJ IDEA
* PyCharm
* Android Studio
* WebStorm
* PhpStorm
* GoLand

## 機能

* **クイック起動**: `Cmd+Esc`（Mac）または`Ctrl+Esc`（Windows/Linux）を使用してエディタから直接Claude Codeを開くか、UIのClaude Codeボタンをクリックします
* **Diff表示**: コードの変更はターミナルではなくIDE diffビューアに直接表示できます
* **選択コンテキスト**: IDEの現在の選択/タブは自動的にClaude Codeと共有されます
* **ファイル参照ショートカット**: `Cmd+Option+K`（Mac）または`Alt+Ctrl+K`（Linux/Windows）を使用してファイル参照を挿入します（例：@File#L1-99）
* **診断共有**: IDE からの診断エラー（lint、構文など）は自動的にClaude と共有されます

## インストール

### マーケットプレイスからのインストール

JetBrainsマーケットプレイスから[Claude Codeプラグイン](https://plugins.jetbrains.com/plugin/27310-claude-code-beta-)を見つけてインストールし、IDEを再起動します。

Claude Codeをまだインストールしていない場合は、[クイックスタートガイド](/ja/quickstart)でインストール手順を確認してください。

<Note>
  プラグインをインストールした後、IDEを完全に再起動して有効にする必要がある場合があります。
</Note>

## 使用方法

### IDEから

IDEの統合ターミナルから`claude`を実行すると、すべての統合機能がアクティブになります。

### 外部ターミナルから

任意の外部ターミナルで`/ide`コマンドを使用して、Claude CodeをJetBrains IDEに接続し、すべての機能をアクティブにします：

```bash  theme={null}
claude
> /ide
```

Claude CodeがIDEと同じファイルにアクセスできるようにしたい場合は、IDEプロジェクトルートと同じディレクトリからClaude Codeを起動してください。

## 設定

### Claude Code設定

Claude Codeの設定を通じてIDE統合を設定します：

1. `claude`を実行します
2. `/config`コマンドを入力します
3. diffツールを`auto`に設定して自動IDE検出を有効にします

### プラグイン設定

\*\*Settings → Tools → Claude Code \[Beta]\*\*に移動してClaude Codeプラグインを設定します：

#### 一般設定

* **Claude command**: Claude を実行するカスタムコマンドを指定します（例：`claude`、`/usr/local/bin/claude`、または`npx @anthropic/claude`）
* **Suppress notification for Claude command not found**: Claude コマンドが見つからないことに関する通知をスキップします
* **Enable using Option+Enter for multi-line prompts**（macOSのみ）: 有効にすると、Option+EnterはClaude Codeプロンプトに新しい行を挿入します。Optionキーが予期せずキャプチャされる問題が発生している場合は無効にします（ターミナルの再起動が必要）
* **Enable automatic updates**: プラグインの更新を自動的にチェックしてインストールします（再起動時に適用）

<Tip>
  WSLユーザー向け：Claude commandとして`wsl -d Ubuntu -- bash -lic "claude"`を設定します（`Ubuntu`をWSLディストリビューション名に置き換えます）
</Tip>

#### ESCキー設定

ESCキーがJetBrainsターミナルでClaude Code操作を中断しない場合：

1. **Settings → Tools → Terminal**に移動します
2. 以下のいずれかを実行します：
   * 「Move focus to the editor with Escape」のチェックを外すか、
   * 「Configure terminal keybindings」をクリックして「Switch focus to Editor」ショートカットを削除します
3. 変更を適用します

これにより、ESCキーがClaude Code操作を適切に中断できるようになります。

## 特別な設定

### リモート開発

<Warning>
  JetBrains Remote Developmentを使用する場合、\*\*Settings → Plugin (Host)\*\*を通じてリモートホストにプラグインをインストールする必要があります。
</Warning>

プラグインはローカルクライアントマシンではなく、リモートホストにインストールする必要があります。

### WSL設定

<Warning>
  WSLユーザーはIDE検出が正常に機能するために追加の設定が必要な場合があります。詳細なセットアップ手順については、[WSLトラブルシューティングガイド](/ja/troubleshooting#jetbrains-ide-not-detected-on-wsl2)を参照してください。
</Warning>

WSL設定には以下が必要な場合があります：

* 適切なターミナル設定
* ネットワークモード調整
* ファイアウォール設定の更新

## トラブルシューティング

### プラグインが機能しない

* プロジェクトルートディレクトリからClaude Codeを実行していることを確認します
* JetBrainsプラグインがIDE設定で有効になっていることを確認します
* IDEを完全に再起動します（複数回実行する必要がある場合があります）
* リモート開発の場合、プラグインがリモートホストにインストールされていることを確認します

### IDEが検出されない

* プラグインがインストールされて有効になっていることを確認します
* IDEを完全に再起動します
* 統合ターミナルからClaude Codeを実行していることを確認します
* WSLユーザーの場合は、[WSLトラブルシューティングガイド](/ja/troubleshooting#jetbrains-ide-not-detected-on-wsl2)を参照してください

### コマンドが見つからない

Claude Codeアイコンをクリックして「command not found」が表示される場合：

1. Claude Codeがインストールされていることを確認します：`npm list -g @anthropic-ai/claude-code`
2. プラグイン設定でClaude Codeコマンドパスを設定します
3. WSLユーザーの場合は、設定セクションで説明されているWSLコマンド形式を使用します

## セキュリティに関する考慮事項

Claude CodeがJetBrains IDEで自動編集権限を有効にして実行される場合、IDEによって自動的に実行される可能性のあるIDE設定ファイルを変更できる場合があります。これにより、自動編集モードでClaude Codeを実行するリスクが増加し、bash実行のためのClaude Codeの権限プロンプトをバイパスできる可能性があります。

JetBrains IDEで実行する場合は、以下を検討してください：

* 編集に対して手動承認モードを使用する
* Claude が信頼できるプロンプトでのみ使用されることを確認するために特に注意する
* Claude Codeが変更できるファイルを認識する

追加のヘルプについては、[トラブルシューティングガイド](/ja/troubleshooting)を参照してください。
