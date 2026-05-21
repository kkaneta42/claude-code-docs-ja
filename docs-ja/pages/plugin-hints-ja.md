> ## Documentation Index
> Fetch the complete documentation index at: https://code.claude.com/docs/llms.txt
> Use this file to discover all available pages before exploring further.

# CLI からプラグインを推奨する

> CLI から 1 行のマーカーを出力して、Claude Code ユーザーに公式プラグインのインストールを促します。

CLI または SDK を保守していて、公式の Anthropic マーケットプレイスにプラグインがある場合、ツールは Claude Code ユーザーにそのプラグインのインストールを促すことができます。CLI は Claude Code 内で実行されていることを検出すると、stderr に 1 行のマーカーを書き込みます。Claude Code はマーカーを読み取り、出力から削除し、ユーザーに 1 回限りのインストールプロンプトを表示します。

Claude Code はコマンド出力からヒント行を削除してからモデルに送信するため、マーカーは会話に表示されず、トークン使用量にカウントされません。このプロトコルは追加のコマンドを必要とせず、Claude Code の外でユーザーが実行する場合に CLI が出力する内容を変更しません。

このページは CLI および SDK メンテナー向けです。プラグインのインストールを探している場合は、[プラグインの発見とインストール](/ja/discover-plugins)を参照してください。

## 仕組み

Claude Code は、Bash および PowerShell ツールを通じて実行するすべてのコマンド、および [hook](/ja/hooks) コマンドに対して、[`CLAUDECODE`](/ja/env-vars) 環境変数を `1` に設定します。CLI がその変数を検出すると、自己終了型の `<claude-code-hint />` タグを stderr に書き込みます。hook コマンドではヒントタグは削除され、無視されます。Bash および PowerShell ツール出力のみがインストールプロンプトをトリガーします。

Claude Code がコマンド出力を受け取ると、以下を実行します。

1. ヒント行をスキャンし、出力がモデルに到達する前に削除します
2. ヒントが公式 Anthropic マーケットプレイスのプラグインをターゲットにしていることを確認します
3. プラグインがまだインストールされていないこと、および以前にプロンプトが表示されていないことを確認します
4. ヒントを出力したコマンドの名前を表示するインストールプロンプトをユーザーに表示します

Claude Code はプラグインを自動的にインストールすることはありません。ユーザーが常に確認します。

## ヒントを出力する

`CLAUDECODE` 環境変数でゲートを設定して、マーカーが人間のユーザーのターミナルに表示されないようにします。次に、タグを stderr に独立した行として書き込みます。

以下の例は、公式マーケットプレイスの `example-cli` という名前のプラグインのヒントを出力します。

<CodeGroup>
  ```javascript Node.js theme={null}
  if (process.env.CLAUDECODE) {
    process.stderr.write(
      '<claude-code-hint v="1" type="plugin" value="example-cli@claude-plugins-official" />\n',
    )
  }
  ```

  ```python Python theme={null}
  import os, sys

  if os.environ.get("CLAUDECODE"):
      print(
          '<claude-code-hint v="1" type="plugin" value="example-cli@claude-plugins-official" />',
          file=sys.stderr,
      )
  ```

  ```go Go theme={null}
  if os.Getenv("CLAUDECODE") != "" {
      fmt.Fprintln(os.Stderr,
          `<claude-code-hint v="1" type="plugin" value="example-cli@claude-plugins-official" />`)
  }
  ```

  ```shell Shell theme={null}
  [ -n "$CLAUDECODE" ] &&
    printf '%s\n' '<claude-code-hint v="1" type="plugin" value="example-cli@claude-plugins-official" />' >&2
  ```
</CodeGroup>

公式マーケットプレイスのプラグイン名で `example-cli` を置き換えます。

## 出力場所を選択する

ヒントを出力するコードパスを制御します。Claude Code はプラグイン別に重複排除するため、すべての呼び出しで出力しても欠点はありません。うまく機能するタッチポイントは以下の通りです。

| 配置             | 機能する理由                                 |
| :------------- | :------------------------------------- |
| `--help` 出力    | Claude は不慣れな CLI を探索するときにヘルプを実行することが多い |
| 不明なサブコマンドエラー   | Claude がインターフェイスについて混乱している瞬間に到達します     |
| ログインまたは認証成功    | ユーザーはすでにセットアップの心構えができています              |
| 初回実行ウェルカムメッセージ | 自然なオンボーディングの瞬間                         |

## ユーザーに表示される内容

ヒントがすべてのチェックに合格すると、Claude Code は以下のようなプロンプトを表示します。

```text theme={null}
─────────────────────────────────────────────────────────────
  プラグイン推奨

    example-cli コマンドはプラグインのインストールを提案しています。

    プラグイン: example-cli
    マーケットプレイス: claude-plugins-official
    example-cli デプロイメント向けの公式統合

    インストールしますか？
    ❯ 1. はい、example-cli をインストール
      2. いいえ
      3. いいえ、プラグインインストールヒントを再度表示しない

─────────────────────────────────────────────────────────────
```

プロンプトはヒントを生成したコマンドの名前を表示するため、ユーザーはツールと推奨するプラグイン間の不一致を検出できます。ユーザーが 30 秒以内に応答しない場合、プロンプトは**いいえ**として却下されます。

プロンプト頻度は制限されています。

* **プラグインごとに 1 回**: プロンプトが表示された後、Claude Code はプラグインを記録し、ユーザーの回答に関係なく、二度とそのプラグインのプロンプトを表示しません。
* **セッションごとに 1 回**: マシン上のすべての CLI にわたって、Claude Code セッションごとに最大 1 つのヒントプロンプトが表示されます。

**はい**を選択するとプラグインがユーザースコープにインストールされます。**いいえ、プラグインインストールヒントを再度表示しない**を選択すると、ユーザーのすべての将来のヒントプロンプトが無効になります。

## ヒント形式

ヒントは 3 つの必須属性を持つ自己終了型タグです。

```text theme={null}
<claude-code-hint v="1" type="plugin" value="example-cli@claude-plugins-official" />
```

| 属性      | 必須 | 説明                              |
| :------ | :- | :------------------------------ |
| `v`     | はい | プロトコルバージョン。`1` が唯一サポートされている値です  |
| `type`  | はい | ヒントの種類。`plugin` が唯一サポートされている値です |
| `value` | はい | `name@marketplace` 形式のプラグイン識別子  |

属性値は二重引用符で引用するか、引用符なしで残すことができます。引用符なしの値は空白を含むことはできません。エスケープシーケンスはサポートされていません。

## 要件

Claude Code はヒントに対して行動する前に 2 つの条件を適用します。どちらかのチェックに失敗したヒントは削除されます。

* **独立した行**: タグは独立した行を占める必要があります。ログステートメント内など、行の途中に埋め込まれたタグは無視されます。行の先頭と末尾の空白は許可されます。
* **公式マーケットプレイス**: `value` は `claude-plugins-official` などの Anthropic 管理マーケットプレイスのプラグインを参照する必要があります。他のマーケットプレイスを指すヒントは静かに削除されます。

ヒント行は、バージョンまたはタイプが認識されない場合でも、常に出力からモデルに到達する前に削除されるため、マーカーはトークン使用量にカウントされません。

残りのガイダンスは推奨されていますが、強制されていません。Claude Code は CLI がそれに従っているかどうかを観察することはできません。

* **stderr に書き込む**: stderr は `example-cli deploy | jq` などのシェルパイプラインからタグを除外します。Claude Code は両方のストリームをスキャンするため、stdout も機能します。
* **`CLAUDECODE` でゲートを設定する**: `CLAUDECODE` 環境変数が設定されている場合のみ出力します。これにより、ユーザーが CLI を直接実行するときにマーカーが表示されるのを防ぎます。

## 公式マーケットプレイスにプラグインを取得する

ヒントプロトコルは、公式 Anthropic マーケットプレイス `claude-plugins-official` にリストされているプラグインに対してのみ有効です。Anthropic はそのマーケットプレイスを裁量で管理し、アプリ内送信フォームはプラグインを[コミュニティマーケットプレイス](/ja/plugins#submit-your-plugin-to-the-community-marketplace)に追加します。これはヒントプロトコルがチェックしません。Anthropic パートナー連絡先と協力している場合は、公式マーケットプレイスのリストを調整するために彼らに連絡してください。

## 関連項目

* [プラグインを作成する](/ja/plugins): CLI が推奨するプラグインを構築します
* [プラグインマーケットプレイスを作成および配布する](/ja/plugin-marketplaces): 公式マーケットプレイスの外でプラグインをホストします
* [環境変数](/ja/env-vars): `CLAUDECODE` および関連変数の完全なリファレンス
