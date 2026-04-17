> ## Documentation Index
> Fetch the complete documentation index at: https://code.claude.com/docs/llms.txt
> Use this file to discover all available pages before exploring further.

# クラウドで Ultraplan を使用して計画を立てる

> CLI から計画を開始し、ウェブ上の Claude Code で下書きを作成してから、リモートで実行するか、ターミナルで実行します

<Note>
  Ultraplan はリサーチプレビュー段階であり、Claude Code v2.1.91 以降が必要です。フィードバックに基づいて、動作と機能が変更される可能性があります。
</Note>

Ultraplan は、ローカル CLI からの計画タスクを、[plan mode](/ja/permission-modes#analyze-before-you-edit-with-plan-mode) で実行されている[ウェブ上の Claude Code](/ja/claude-code-on-the-web) セッションに渡します。Claude はクラウドで計画を下書きしている間、ターミナルで作業を続けることができます。計画の準備ができたら、ブラウザで開いて特定のセクションにコメントを付けたり、修正をリクエストしたり、実行場所を選択したりできます。

これは、ターミナルが提供するよりも豊富なレビュー画面が必要な場合に便利です。

* **ターゲット化されたフィードバック**: 全体に返信する代わりに、計画の個別セクションにコメントを付けることができます
* **ハンズオフ下書き**: 計画はリモートで生成されるため、ターミナルは他の作業に使用できます
* **柔軟な実行**: ウェブで実行するプルリクエストを承認するか、ターミナルに送り返すことができます

Ultraplan には、[ウェブ上の Claude Code](/ja/claude-code-on-the-web) アカウントと GitHub リポジトリが必要です。Anthropic のクラウドインフラストラクチャで実行されるため、Amazon Bedrock、Google Cloud Vertex AI、または Microsoft Foundry を使用している場合は利用できません。クラウドセッションは、アカウントのデフォルト[クラウド環境](/ja/claude-code-on-the-web#the-cloud-environment)で実行されます。クラウド環境がまだない場合、ultraplan は初回起動時に自動的に作成します。

## CLI から ultraplan を起動する

ローカル CLI セッションから、ultraplan を 3 つの方法で起動できます。

* **コマンド**: `/ultraplan` の後にプロンプトを実行します
* **キーワード**: 通常のプロンプトの任意の場所に `ultraplan` という単語を含めます
* **ローカル計画から**: Claude がローカル計画を完了して承認ダイアログを表示したときに、**いいえ、Claude Code on the web の Ultraplan で改善する** を選択して、下書きをクラウドにさらに反復するために送信します

たとえば、コマンドでサービス移行を計画するには、次のようにします。

```
/ultraplan migrate the auth service from sessions to JWTs
```

コマンドとキーワードのパスは、起動前に確認ダイアログを開きます。ローカル計画パスはこのダイアログをスキップします。これは、その選択がすでに確認として機能するためです。[Remote Control](/ja/remote-control) がアクティブな場合、ultraplan の開始時に切断されます。これは、両方の機能が claude.ai/code インターフェイスを占有し、一度に 1 つだけ接続できるためです。

クラウドセッションが起動した後、CLI のプロンプト入力は、リモートセッションが動作している間、ステータスインジケータを表示します。

| ステータス                          | 意味                                       |
| :----------------------------- | :--------------------------------------- |
| `◇ ultraplan`                  | Claude はコードベースを調査し、計画を下書きしています           |
| `◇ ultraplan needs your input` | Claude に明確化の質問があります。セッションリンクを開いて応答してください |
| `◆ ultraplan ready`            | 計画はブラウザでレビューする準備ができています                  |

`/tasks` を実行して ultraplan エントリを選択し、セッションリンク、エージェントアクティビティ、および **Stop ultraplan** アクションを含む詳細ビューを開きます。Ultraplan を停止すると、クラウドセッションがアーカイブされ、インジケータがクリアされます。ターミナルには何も保存されません。

## ブラウザで計画をレビューして修正する

ステータスが `◆ ultraplan ready` に変わったら、セッションリンクを開いて claude.ai で計画を表示します。計画は専用レビュービューに表示されます。

* **インラインコメント**: 任意のパッセージをハイライトして、Claude に対処するようにコメントを残します
* **絵文字リアクション**: セクションに反応して、完全なコメントを書かずに承認または懸念を示します
* **アウトラインサイドバー**: 計画のセクション間をジャンプします

Claude にコメントに対処するよう依頼すると、計画が修正され、更新されたドラフトが表示されます。実行場所を選択する前に、必要な回数だけ反復できます。

## 実行場所を選択する

計画が正しく見えたら、ブラウザから Claude がそれを同じクラウドセッションで実装するか、待機中のターミナルに送り返すかを選択します。

### ウェブで実行する

ブラウザで **Approve Claude's plan and start coding** を選択して、Claude が同じ Claude Code on the web セッションで実装するようにします。ターミナルに確認が表示され、ステータスインジケータがクリアされ、作業がクラウドで続行されます。実装が完了したら、[変更をレビュー](/ja/claude-code-on-the-web#review-changes)して、ウェブインターフェイスからプルリクエストを作成します。

### 計画をターミナルに送り返す

ブラウザで **Approve plan and teleport back to terminal** を選択して、環境への完全なアクセスで計画をローカルに実装します。このオプションは、セッションが CLI から起動され、ターミナルがまだポーリングしている場合に表示されます。ウェブセッションはアーカイブされるため、並行して作業を続けません。

ターミナルに **Ultraplan approved** というタイトルのダイアログに計画が表示され、3 つのオプションがあります。

* **Implement here**: 計画を現在の会話に挿入し、中断したところから続行します
* **Start new session**: 現在の会話をクリアし、計画のみをコンテキストとして新しく開始します
* **Cancel**: 計画をファイルに保存して実行しません。Claude はファイルパスを出力するため、後で戻ることができます

新しいセッションを開始する場合、Claude は上部に `claude --resume` コマンドを出力するため、後で前の会話に戻ることができます。

## 関連リソース

* [Claude Code on the web](/ja/claude-code-on-the-web): ultraplan が実行されるクラウドインフラストラクチャ
* [Plan mode](/ja/permission-modes#analyze-before-you-edit-with-plan-mode): ローカルセッションで計画がどのように機能するか
* [Find bugs with ultrareview](/ja/ultrareview): マージ前に問題をキャッチするための ultraplan のコードレビューカウンターパート
* [Remote Control](/ja/remote-control): 独自のマシンで実行されているセッションで claude.ai/code インターフェイスを使用します
