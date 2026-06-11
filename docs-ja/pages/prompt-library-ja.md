> ## Documentation Index
> Fetch the complete documentation index at: https://code.claude.com/docs/llms.txt
> Use this file to discover all available pages before exploring further.

# プロンプトライブラリ

> Claude Code 用のコピー＆ペーストプロンプト。タスクと役割でタグ付けされています。

これは Claude Code にコピーして使用するプロンプトのライブラリです。試したことのない作業方法を探索したり、どこから始めたらよいかわからない場合に使用してください。

プロンプトは、[一般的なワークフロー](/ja/common-workflows)、[ベストプラクティス](/ja/best-practices)、[Anthropic チームが Claude Code をどのように使用しているか](https://claude.com/blog/how-anthropic-teams-use-claude-code)など、様々な Anthropic ガイドから収集されています。これらはスクリプトではなく、出発点です。任意のプロンプトの下にある **このプロンプトが機能する理由** を開くと、その背後にあるパターンを確認できるため、独自のプロンプトを作成できます。

<h2 id="what-makes-these-prompts-work">
  これらのプロンプトを機能させるもの
</h2>

上記のプロンプトはいくつかのパターンを共有しています。それらを認識することは、ここで任意のプロンプトを独自のタスクに適応させるのに役立ちます。

**ステップではなく結果を説明してください。** 何をしたいかを言い、Claude にファイルを見つけさせてください。以下のプロンプトは、単一のファイルパスを名前付けなくても機能します。

```text theme={null}
add rate limiting to the public API and make sure existing tests still pass
```

**自分の作業をチェックする方法を与えてください。** 同じプロンプトで実行、テスト、比較、または検証を依頼して、Claude が 1 回の試行後に停止する代わりに反復するようにしてください。

```text theme={null}
write the migration, run it against the dev database, and confirm the schema matches
```

**参照を指してください。** 既存のファイル、テスト、またはパターンに名前を付けて、新しいコードが既に持っているものと一致するようにしてください。

```text theme={null}
add a settings page that follows the same layout as the profile page
```

**測定可能なターゲットを述べてください。** 目標がパフォーマンスまたはカバレッジの場合、メトリックとしきい値を指定して、完了が明確になるようにしてください。

```text theme={null}
get the bundle size under 200KB and show me what you removed
```

**アーティファクトを与えてください。** エラー、ログ、スクリーンショット、プラン出力をプロンプトに直接ペーストするか、`@` を入力してファイルを参照してください。Claude はあなたの説明ではなくソースを読みます。

```text theme={null}
why is the build failing? @build.log
```

**答えてほしい方法を言ってください。** 形式、長さ、または対象者に名前を付けて、説明がどのように使用するかに適合するようにしてください。すべての応答のデフォルトとして形式を作成するには、[出力スタイル](/ja/output-styles)を設定してください。

```text theme={null}
explain how the payment retry logic works as an HTML page with a diagram, then open it in my browser
```

各パターンの詳細については、[ベストプラクティス](/ja/best-practices)を参照してください。

<h2 id="where-these-come-from">
  これらはどこから来ているのか
</h2>

これらのプロンプトは、公開されている Anthropic リソースのパターンに基づいています。各カードはそのソースにリンクしています:

* [一般的なワークフロー](/ja/common-workflows): コアタスクのステップバイステップガイド
* [ベストプラクティス](/ja/best-practices): プロンプティングパターンとプロジェクトセットアップ
* [Anthropic チームが Claude Code をどのように使用しているか](https://claude.com/blog/how-anthropic-teams-use-claude-code): エンジニアリング、プロダクト、デザイン、データチームからの実際のワークフロー。[法務](https://claude.com/blog/how-anthropic-uses-claude-legal)、[マーケティング](https://claude.com/blog/how-anthropic-uses-claude-marketing)、[サイバーセキュリティ](https://claude.com/blog/how-anthropic-uses-claude-cybersecurity)の詳細なダイブ
* [agentic coding スケーリングガイド](https://resources.anthropic.com/hubfs/Scaling%20agentic%20coding%20across%20your%20organization.pdf): エンタープライズ採用ガイド

これらのパターンのビデオウォークスルーについては、Anthropic Academy の無料 [Claude Code in Action](https://anthropic.skilljar.com/claude-code-in-action)コースを参照してください。

<h2 id="related-resources">
  関連リソース
</h2>

このページのプロンプトは出発点です。1 つがプロジェクトで機能したら、次のステップはそれを繰り返し可能にすることです。[スキル](/ja/skills)として保存して、チーム内の誰でも `/command` として実行でき、Claude が学習したコンベンションを [CLAUDE.md](/ja/memory)に記録して、すべてのセッションがその文脈で開始されるようにしてください。より大きなまたはより危険な変更については、[プランモード](/ja/permission-modes#analyze-before-you-edit-with-plan-mode)は編集が発生する前にファイルリストを表示します。

チーム全体に Claude Code を導入している場合は、管理設定とポリシーについては [管理](/ja/admin-setup)を、このワークがプランでどのように請求されるかについては [コストと使用状況](/ja/costs)を参照してください。
