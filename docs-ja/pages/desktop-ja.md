> ## Documentation Index
> Fetch the complete documentation index at: https://code.claude.com/docs/llms.txt
> Use this file to discover all available pages before exploring further.

# デスクトップ上の Claude Code

> Claude デスクトップアプリを使用して、Claude Code タスクをローカルで実行するか、セキュアなクラウドインフラストラクチャで実行します

<img src="https://mintcdn.com/claude-code/zEGbGSbinVtT3BLw/images/desktop-interface.png?fit=max&auto=format&n=zEGbGSbinVtT3BLw&q=85&s=c4e9dc9737b437d36ab253b75a1cc595" alt="デスクトップインターフェース上の Claude Code" data-og-width="4132" width="4132" data-og-height="2620" height="2620" data-path="images/desktop-interface.png" data-optimize="true" data-opv="3" srcset="https://mintcdn.com/claude-code/zEGbGSbinVtT3BLw/images/desktop-interface.png?w=280&fit=max&auto=format&n=zEGbGSbinVtT3BLw&q=85&s=b1a8421a544c3e8c78679fa1a7b56190 280w, https://mintcdn.com/claude-code/zEGbGSbinVtT3BLw/images/desktop-interface.png?w=560&fit=max&auto=format&n=zEGbGSbinVtT3BLw&q=85&s=79cf4ea0923098cc429198678ea50903 560w, https://mintcdn.com/claude-code/zEGbGSbinVtT3BLw/images/desktop-interface.png?w=840&fit=max&auto=format&n=zEGbGSbinVtT3BLw&q=85&s=14bcbcd569d179770fe656686ffbf6bf 840w, https://mintcdn.com/claude-code/zEGbGSbinVtT3BLw/images/desktop-interface.png?w=1100&fit=max&auto=format&n=zEGbGSbinVtT3BLw&q=85&s=b873274db1e9ff8585ba545032aa24a5 1100w, https://mintcdn.com/claude-code/zEGbGSbinVtT3BLw/images/desktop-interface.png?w=1650&fit=max&auto=format&n=zEGbGSbinVtT3BLw&q=85&s=25553dced783c3a8c2a1134a53295f7e 1650w, https://mintcdn.com/claude-code/zEGbGSbinVtT3BLw/images/desktop-interface.png?w=2500&fit=max&auto=format&n=zEGbGSbinVtT3BLw&q=85&s=9ad49e6468c2f87b1895093deeea7bb2 2500w" />

## デスクトップ上の Claude Code（プレビュー）

Claude デスクトップアプリは、ローカルマシン上で複数の Claude Code セッションを実行し、ウェブ上の Claude Code とシームレスに統合するためのネイティブインターフェースを提供します。

## インストール

お使いのプラットフォーム用の Claude デスクトップアプリをダウンロードしてください：

<CardGroup cols={2}>
  <Card title="macOS" icon="apple" href="https://claude.ai/api/desktop/darwin/universal/dmg/latest/redirect?utm_source=claude_code&utm_medium=docs">
    Intel と Apple Silicon 用のユニバーサルビルド
  </Card>

  <Card title="Windows" icon="windows" href="https://claude.ai/api/desktop/win32/x64/exe/latest/redirect?utm_source=claude_code&utm_medium=docs">
    x64 プロセッサ用
  </Card>
</CardGroup>

Windows ARM64 の場合は、[ここからダウンロード](https://claude.ai/api/desktop/win32/arm64/exe/latest/redirect?utm_source=claude_code\&utm_medium=docs)してください。

<Note>
  ローカルセッションは Windows ARM64 では利用できません。
</Note>

## 機能

デスクトップ上の Claude Code は以下を提供します：

* **`git` ワークツリーを使用した並列ローカルセッション**：同じリポジトリ内で複数の Claude Code セッションを同時に実行でき、各セッションは独立した `git` ワークツリーを持ちます
* **`.gitignore` にリストされたファイルをワークツリーに含める**：`.env` のような `.gitignore` 内のファイルを `.worktreeinclude` を使用して新しいワークツリーに自動的にコピーします
* **ウェブ上で Claude Code を起動**：デスクトップアプリから直接セキュアなクラウドセッションを開始します

## Git ワークツリーの使用

デスクトップ上の Claude Code は、Git ワークツリーを使用して同じリポジトリ内で複数の Claude Code セッションを実行できます。各セッションは独立したワークツリーを取得し、Claude が競合なく異なるタスクで作業できるようにします。ワークツリーのデフォルトの場所は `~/.claude-worktrees` ですが、Claude デスクトップアプリの設定で構成できます。

<Note>
  Git が初期化されていないフォルダでローカルセッションを開始する場合、デスクトップアプリは新しいワークツリーを作成しません。
</Note>

### `.gitignore` で無視されたファイルのコピー

Claude Code がワークツリーを作成する場合、`.gitignore` を介して無視されたファイルは自動的に利用できません。`.worktreeinclude` ファイルを含めることでこれを解決し、どの無視されたファイルを新しいワークツリーにコピーするかを指定します。

リポジトリルートに `.worktreeinclude` ファイルを作成します：

```
.env
.env.local
.env.*
**/.claude/settings.local.json
```

ファイルは `.gitignore` スタイルのパターンを使用します。ワークツリーが作成されるとき、これらのパターンに一致し、かつ `.gitignore` にもリストされているファイルがメインリポジトリからワークツリーにコピーされます。

<Tip>
  `.worktreeinclude` と `.gitignore` の両方に一致するファイルのみがコピーされます。これにより、追跡されたファイルが誤ってコピーされるのを防ぎます。
</Tip>

### ウェブ上で Claude Code を起動

デスクトップアプリから、Anthropic のセキュアなクラウドインフラストラクチャ上で実行される Claude Code セッションを開始できます。

デスクトップからウェブセッションを開始するには、新しいセッションを作成するときにリモート環境を選択します。

詳細については、[ウェブ上の Claude Code](/ja/claude-code-on-the-web) を参照してください。

## バンドルされた Claude Code バージョン

デスクトップ上の Claude Code には、すべてのデスクトップユーザーに一貫したエクスペリエンスを確保するためのバンドルされた安定版の Claude Code が含まれています。バンドルされたバージョンは必須であり、コンピュータに Claude Code のバージョンが存在する場合でも、初回起動時にダウンロードされます。デスクトップは自動的にバージョン更新を管理し、古いバージョンをクリーンアップします。

<Note>
  デスクトップのバンドルされた Claude Code バージョンは、最新の CLI バージョンと異なる場合があります。デスクトップは安定性を優先し、CLI はより新しい機能を持つ場合があります。
</Note>

## 環境構成

ローカル環境の場合、デスクトップ上の Claude Code はシェル構成から `$PATH` 環境変数を自動的に抽出します。これにより、ローカルセッションは追加のセットアップなしに、ターミナルで利用可能な `yarn`、`npm`、`node` などの開発ツールやその他のコマンドにアクセスできます。

### カスタム環境変数

「ローカル」環境を選択してから、右側の設定ボタンを選択します。これにより、ローカル環境変数を更新できるダイアログが開きます。これは、プロジェクト固有の変数や開発ワークフローに必要な API キーを設定するのに役立ちます。環境変数の値はセキュリティ上の理由から UI でマスクされます。

<Note>
  環境変数は [`.env` 形式](https://www.dotenv.org/)のキーと値のペアとして指定する必要があります。例えば：

  ```
  API_KEY=your_api_key
  DEBUG=true

  # 複数行の値 - 引用符で囲む
  CERT="---BEGIN CERT---
  MIIE...
  ---END CERT---"
  ```
</Note>

## エンタープライズ構成

組織は、`isClaudeCodeForDesktopEnabled` [エンタープライズポリシーオプション](https://support.claude.com/en/articles/12622667-enterprise-configuration#h_003283c7cb)を使用して、デスクトップアプリケーション内のローカル Claude Code の使用を無効にできます。さらに、ウェブ上の Claude Code は [管理者設定](https://claude.ai/admin-settings/claude-code)で無効にできます。

## 関連リソース

* [ウェブ上の Claude Code](/ja/claude-code-on-the-web)
* [Claude デスクトップサポート記事](https://support.claude.com/en/collections/16163169-claude-desktop)
* [エンタープライズ構成](https://support.claude.com/en/articles/12622667-enterprise-configuration)
* [一般的なワークフロー](/ja/common-workflows)
* [設定リファレンス](/ja/settings)
