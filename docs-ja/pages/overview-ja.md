> ## Documentation Index
> Fetch the complete documentation index at: https://code.claude.com/docs/llms.txt
> Use this file to discover all available pages before exploring further.

# Claude Code 概要

> Anthropic の agentic coding ツール Claude Code について学びます。Claude Code はターミナルで動作し、アイデアをコードに変えるのを今までより速く支援します。

## 30 秒で始める

前提条件：

* [システム要件](/ja/setup#system-requirements)を満たしていること
* [Claude サブスクリプション](https://claude.com/pricing)（Pro、Max、Teams、または Enterprise）または [Claude Console](https://console.anthropic.com/) アカウント

**Claude Code をインストール：**

To install Claude Code, use one of the following methods:

<Tabs>
  <Tab title="Native Install (Recommended)">
    **macOS, Linux, WSL:**

    ```bash  theme={null}
    curl -fsSL https://claude.ai/install.sh | bash
    ```

    **Windows PowerShell:**

    ```powershell  theme={null}
    irm https://claude.ai/install.ps1 | iex
    ```

    **Windows CMD:**

    ```batch  theme={null}
    curl -fsSL https://claude.ai/install.cmd -o install.cmd && install.cmd && del install.cmd
    ```

    <Info>
      Native installations automatically update in the background to keep you on the latest version.
    </Info>
  </Tab>

  <Tab title="Homebrew">
    ```sh  theme={null}
    brew install --cask claude-code
    ```

    <Info>
      Homebrew installations do not auto-update. Run `brew upgrade claude-code` periodically to get the latest features and security fixes.
    </Info>
  </Tab>

  <Tab title="WinGet">
    ```powershell  theme={null}
    winget install Anthropic.ClaudeCode
    ```

    <Info>
      WinGet installations do not auto-update. Run `winget upgrade Anthropic.ClaudeCode` periodically to get the latest features and security fixes.
    </Info>
  </Tab>
</Tabs>

**Claude Code を使い始める：**

```bash  theme={null}
cd your-project
claude
```

初回使用時にログインするよう促されます。以上です！[クイックスタート（5 分）に進む →](/ja/quickstart)

<Tip>
  [高度なセットアップ](/ja/setup)でインストールオプション、手動更新、またはアンインストール手順を確認してください。問題が発生した場合は、[トラブルシューティング](/ja/troubleshooting)を参照してください。
</Tip>

## Claude Code があなたのためにすること

* **説明からフィーチャーを構築**: Claude に平易な英語で構築したいものを伝えます。計画を立て、コードを書き、動作を確認します。
* **バグをデバッグして問題を修正**: バグを説明するか、エラーメッセージを貼り付けます。Claude Code はコードベースを分析し、問題を特定し、修正を実装します。
* **任意のコードベースをナビゲート**: チームのコードベースについて何でも質問し、思慮深い回答を得ます。Claude Code はプロジェクト全体の構造を認識し、ウェブから最新情報を見つけることができ、[MCP](/ja/mcp)を使用すると Google Drive、Figma、Slack などの外部データソースから取得できます。
* **退屈なタスクを自動化**: 厄介な lint の問題を修正し、マージコンフリクトを解決し、リリースノートを作成します。開発者マシンから単一のコマンドで、または CI で自動的にすべてを実行します。

## 開発者が Claude Code を愛する理由

* **ターミナルで動作**: 別のチャットウィンドウではありません。別の IDE ではありません。Claude Code はあなたが既に作業している場所で、既に愛用しているツールで、あなたに会います。
* **アクションを実行**: Claude Code はファイルを直接編集し、コマンドを実行し、コミットを作成できます。さらに必要ですか？[MCP](/ja/mcp)により Claude は Google Drive のデザインドキュメントを読み、Jira のチケットを更新し、または\_あなたの\_カスタム開発者ツーリングを使用できます。
* **Unix 哲学**: Claude Code は構成可能でスクリプト化可能です。`tail -f app.log | claude -p "Slack me if you see any anomalies appear in this log stream"` *動作します*。CI は `claude -p "If there are new text strings, translate them into French and raise a PR for @lang-fr-team to review"` を実行できます。
* **エンタープライズ対応**: Claude API を使用するか、AWS または GCP でホストします。エンタープライズグレードの[セキュリティ](/ja/security)、[プライバシー](/ja/data-usage)、および[コンプライアンス](https://trust.anthropic.com/)が組み込まれています。

## Claude Code をどこでも使用

Claude Code は開発環境全体で動作します：ターミナル、IDE、クラウド、Slack で。

* **[ターミナル（CLI）](/ja/quickstart)**: コア Claude Code エクスペリエンス。任意のターミナルで `claude` を実行してコーディングを開始します。
* **[ウェブ上の Claude Code](/ja/claude-code-on-the-web)**: [claude.ai/code](https://claude.ai/code) または Claude iOS アプリのブラウザから Claude Code を使用し、ローカルセットアップは不要です。タスクを並列実行し、ローカルにないリポジトリで作業し、組み込みの diff ビューで変更を確認します。
* **[デスクトップアプリ](/ja/desktop)**: diff レビュー、git worktrees を使用した並列セッション、クラウドセッションを起動する機能を備えたスタンドアロンアプリケーション。
* **[VS Code](/ja/vs-code)**: インラインの diff、@-mentions、プランレビューを備えたネイティブ拡張機能。
* **[JetBrains IDE](/ja/jetbrains)**: IntelliJ IDEA、PyCharm、WebStorm、および他の JetBrains IDE 用のプラグイン（IDE diff ビューとコンテキスト共有機能付き）。
* **[GitHub Actions](/ja/github-actions)**: `@claude` mentions を使用して CI/CD でコードレビュー、issue トリアージ、およびその他のワークフローを自動化します。
* **[GitLab CI/CD](/ja/gitlab-ci-cd)**: GitLab マージリクエストと issue のイベント駆動型自動化。
* **[Slack](/ja/slack)**: Slack で Claude にメンションして、コーディングタスクを Claude Code on the web にルーティングし、PR を取得します。
* **[Chrome](/ja/chrome)**: Claude Code をブラウザに接続して、ライブデバッグ、デザイン検証、ウェブアプリテストを行います。

## 次のステップ

<CardGroup>
  <Card title="クイックスタート" icon="rocket" href="/ja/quickstart">
    実践的な例で Claude Code の動作を確認
  </Card>

  <Card title="一般的なワークフロー" icon="graduation-cap" href="/ja/common-workflows">
    一般的なワークフローのステップバイステップガイド
  </Card>

  <Card title="トラブルシューティング" icon="wrench" href="/ja/troubleshooting">
    Claude Code の一般的な問題の解決策
  </Card>

  <Card title="デスクトップアプリ" icon="laptop" href="/ja/desktop">
    Claude Code をスタンドアロンアプリケーションとして実行
  </Card>
</CardGroup>

## 追加リソース

<CardGroup>
  <Card title="Claude Code について" icon="sparkles" href="https://claude.com/product/claude-code">
    claude.com で Claude Code の詳細を確認
  </Card>

  <Card title="Agent SDK で構築" icon="code-branch" href="https://platform.claude.com/docs/en/agent-sdk/overview">
    Claude Agent SDK でカスタム AI エージェントを作成
  </Card>

  <Card title="AWS または GCP でホスト" icon="cloud" href="/ja/third-party-integrations">
    Amazon Bedrock または Google Vertex AI で Claude Code を構成
  </Card>

  <Card title="設定" icon="gear" href="/ja/settings">
    ワークフロー用に Claude Code をカスタマイズ
  </Card>

  <Card title="コマンド" icon="terminal" href="/ja/cli-reference">
    CLI コマンドとコントロールについて学ぶ
  </Card>

  <Card title="リファレンス実装" icon="code" href="https://github.com/anthropics/claude-code/tree/main/.devcontainer">
    開発コンテナリファレンス実装をクローン
  </Card>

  <Card title="セキュリティ" icon="shield" href="/ja/security">
    Claude Code のセーフガードと安全な使用のベストプラクティスを発見
  </Card>

  <Card title="プライバシーとデータ使用" icon="lock" href="/ja/data-usage">
    Claude Code がデータをどのように処理するかを理解
  </Card>
</CardGroup>
