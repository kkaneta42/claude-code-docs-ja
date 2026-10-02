> ## Documentation Index
> Fetch the complete documentation index at: https://code.claude.com/docs/llms.txt
> Use this file to discover all available pages before exploring further.

# Chrome で Claude Code を使用する

> Claude Code を Chrome ブラウザに接続して、Web アプリをテストし、コンソールログでデバッグし、フォーム入力を自動化し、Web ページからデータを抽出します。

Claude Code は [Claude in Chrome ブラウザ拡張機能](https://chromewebstore.google.com/detail/claude/fcoeoabgfenejglbffodgkkbkcdhcgfn) と統合され、CLI または [VS Code 拡張機能](/docs/ja/vs-code#automate-browser-tasks-with-chrome) からブラウザ自動化機能を提供します。コードをビルドしてから、コンテキストを切り替えることなくブラウザでテストおよびデバッグできます。

Claude はブラウザタスク用に新しいタブを開き、ブラウザのログイン状態を共有するため、既にサインインしているサイトにアクセスできます。ブラウザアクションはリアルタイムで表示される Chrome ウィンドウで実行されます。Claude がログインページまたは CAPTCHA に遭遇した場合、一時停止して手動で処理するよう求めます。

拡張機能は、Claude が開いたタブをセッションに紐付けられた Chrome タブグループにまとめます。ローカルセッションでは、セッション終了時に Claude Code がそのグループを閉じるかどうかは、セッションの終了方法によって異なります。

* `/clear` と入力すると、クリア後も継続する作業がまだ実行中でない限り、Claude Code は開いているページを含めてグループを閉じます
* `/resume` などのコマンドでセッションを切り替えた場合、Claude Code を終了した場合、またはクリア後も継続する作業がまだ実行中の状態で `/clear` を実行した場合、Claude Code はグループに空の新しいタブしか含まれていないときにのみグループを閉じます。そのため、まだ読んでいる可能性のあるページは開いたままになります

<Note>
  Chrome 統合は Google Chrome と Microsoft Edge で動作します。Claude Code は、Brave、Arc、Vivaldi、Opera など、その他の Chromium ベースのブラウザでも拡張機能を検出して接続を設定します。Chrome 統合は Windows Subsystem for Linux（WSL）ではサポートされていません。
</Note>

<h2 id="capabilities">
  機能
</h2>

Chrome が接続されている場合、単一のワークフロー内でブラウザアクションとコーディングタスクをチェーンできます。

* **ライブデバッグ**：コンソールエラーと DOM 状態を直接読み取り、それらを引き起こしたコードを修正します
* **デザイン検証**：Figma モックから UI をビルドしてから、ブラウザで開いて一致することを確認します
* **Web アプリテスト**：フォーム検証をテストし、ビジュアルリグレッションをチェックするか、ユーザーフローを検証します
* **認証済み Web アプリ**：API コネクタなしで、ログインしている Google Docs、Gmail、Notion、またはその他のアプリと対話します
* **データ抽出**：Web ページから構造化情報を取得してローカルに保存します
* **タスク自動化**：データ入力、フォーム入力、またはマルチサイトワークフローなどの反復的なブラウザタスクを自動化します
* **ファイルのアップロード**：マシン上のファイルを Web ページのアップロードフィールドに添付します
* **セッション記録**：ブラウザインタラクションを GIF として記録して、何が起こったかを文書化または共有します

<h2 id="prerequisites">
  前提条件
</h2>

Claude Code を Chrome で使用する前に、以下が必要です。

* [Google Chrome](https://www.google.com/chrome/)、[Microsoft Edge](https://www.microsoft.com/edge)、または Brave、Arc、Vivaldi、Opera などのその他の Chromium ベースのブラウザ
* [Claude in Chrome 拡張機能](https://chromewebstore.google.com/detail/claude/fcoeoabgfenejglbffodgkkbkcdhcgfn) バージョン 1.0.36 以上（Chrome Web Store で入手可能）
* [Claude Code](/docs/ja/quickstart#step-1-install-claude-code)
* 直接 Anthropic プラン（Pro、Max、Team、または Enterprise）

Chrome 統合を使用するには、`/login` でサインインする必要もあります。API キーまたは [`claude setup-token`](/docs/ja/authentication#generate-a-long-lived-token) で発行した長期間有効なトークンで認証している場合、ブラウザ拡張機能はこれらの認証情報では認証できないため、`--chrome` を渡しても Claude Code は Chrome 統合を無効のままにします。v2.1.216 より前のバージョンでは、これらのセッションでも Chrome 統合を有効にできましたが、ブラウザ拡張機能への接続はすべて 403 エラーで失敗していました。

<Note>
  Chrome 統合は Amazon Bedrock、Google Cloud の Agent Platform、Microsoft Foundry などのサードパーティプロバイダーを通じては利用できません。Claude にサードパーティプロバイダーを通じてのみアクセスする場合、この機能を使用するには別の claude.ai アカウントが必要です。
</Note>

<h2 id="get-started-in-the-cli">
  CLI で開始する
</h2>

<Steps>
  <Step title="Chrome で Claude Code を起動する">
    `--chrome` フラグで Claude Code を起動します。

    ```bash theme={null}
    claude --chrome
    ```

    Chrome で初めて起動すると、Claude Code は統合の紹介とサイト権限の仕組みを説明する 1 回限りのダイアログを表示します。Enter キーを押して続行します。

    フラグなしで今後のセッションでも Chrome を有効にするには、[Chrome をデフォルトで有効にする](#enable-chrome-by-default)を参照してください。
  </Step>

  <Step title="Claude にブラウザを使用するよう依頼する">
    この例では、ページに移動してそのページを操作し、見つけた内容を報告します。これらはすべてターミナルまたはエディターから行えます。

    ```text wrap theme={null}
    Go to code.claude.com/docs, click on the search box,
    type "hooks", and tell me what results appear
    ```

    ブラウザアクションの前に Claude Code が権限を求めた場合は、承認してください。ダイアログは `Claude in Chrome wants to` で始まり、そのサイトでのすべてのアクションをセッション中許可するオプションが表示されます。Claude は新しいタブを開いてタスクを開始します。
  </Step>
</Steps>

いつでも `/chrome` を実行して、接続ステータスの確認、権限の管理、拡張機能の再接続、または使用する接続済みブラウザの選択を行えます。ステータスパネルに「ステータス: 有効」と「拡張機能: インストール済み」が表示されていれば、統合は正常に動作しています。

複数のブラウザが接続されている場合は、Claude が使用するブラウザを選択します。選択する前にブラウザアクションが開始されると、Claude はいずれかを選択するよう促します。後でブラウザを切り替えるには、`/chrome` を実行して **ブラウザを選択…** を選びます。別のブラウザが接続された場合でも、Claude は選択したブラウザを使い続けます。

VS Code については、[VS Code でのブラウザ自動化](/docs/ja/vs-code#automate-browser-tasks-with-chrome) を参照してください。

<h3 id="install-the-extension-when-claude-asks">
  Claude から求められたときに拡張機能をインストールする
</h3>

対話型セッションで Claude がブラウザを必要とし、Claude Code が拡張機能を検出できない場合、Claude Code は「Claude がブラウザの使用を求めています」というタイトルのインストールプロンプトを表示します。Claude Code が確認するのは 1 セッションにつき最大 1 回です。

プロンプトには 3 つの選択肢があります。

* **拡張機能をインストール**: ブラウザで拡張機能のインストールページを開き、ガイド付きセットアップを開始します。Claude Code はインストールを待機し、拡張機能を接続して、同じセッション内でブラウザツールを有効にします。接続の準備ができたら「ブラウザツールを使用して続行」を選択すると、Claude はブラウザでタスクを再開します。「ブラウザツールなしで続行」を選択してセットアップを中断し、後で `/chrome` で完了することもできます。
* **今はしない**: ブラウザツールなしでタスクを続行します。Claude Code は後のセッションで再度確認することがあります。
* **今後確認しない**: 今後のセッションでプロンプトを表示しないようにします。`/chrome` を使えば、いつでも統合をセットアップできます。

次の 2 つの管理 MCP ポリシーによってプロンプトはオフになります。

* 組織が [`deniedMcpServers` 管理設定](/docs/ja/managed-mcp#policy-based-control-with-allowlists-and-denylists)で `claude-in-chrome` MCP サーバーをブロックしている場合、Claude Code はインストールプロンプトを表示しません。
* 組織が [`managed-mcp.json`](/docs/ja/managed-mcp#exclusive-control-with-managed-mcp-json) ファイルをデプロイしており、[管理対象セットと併せて Claude in Chrome を許可](/docs/ja/managed-mcp#allow-claude-in-chrome-alongside-the-managed-set)していない場合、Claude Code はインストールプロンプトを表示しません。

<h3 id="enable-chrome-by-default">
  Chrome をデフォルトで有効にする
</h3>

各セッションで `--chrome` を渡すことを避けるには、`/chrome` を実行して「デフォルトで有効」を選択します。

Chrome が実行されていない場合でも、Claude Code は通常どおり起動します。v2.1.211 より前では、Chrome 統合が有効で Chrome が実行されていない場合に、起動が停止することがありました。

[VS Code 拡張機能](/docs/ja/vs-code#automate-browser-tasks-with-chrome) では、Chrome 拡張機能がインストールされている場合、Chrome はいつでも利用可能です。追加のフラグは必要ありません。

<Note>
  CLI で Chrome をデフォルトで有効にすると、ブラウザツールが常にロードされるため、コンテキスト使用量が増加します。コンテキスト消費の増加に気付いた場合、この設定を無効にして、必要な場合にのみ `--chrome` を使用してください。
</Note>

<h3 id="manage-site-permissions">
  サイト権限を管理する
</h3>

サイトレベルの権限は Chrome 拡張機能から継承されます。Chrome 拡張機能の設定で権限を管理して、Claude がブラウズ、クリック、入力できるサイトを制御します。[auto モード](/docs/ja/permission-modes#eliminate-prompts-with-auto-mode)では、auto モードの分類器自体があるサイトへのブラウザ呼び出しを承認した場合、権限ルールで Claude in Chrome に対していずれかのサイトを拒否していない限り、拡張機能はその呼び出しについて独自のサイトごとのチェックを省略します。

<h3 id="browser-tools-in-plan-mode">
  plan モードでのブラウザツール
</h3>

[plan モード](/docs/ja/permission-modes#analyze-before-you-edit-with-plan-mode)では、Claude が GIF を記録する、新しいタブを開く、またはショートカットを実行する前に権限プロンプトが表示されます。セッションで [bypassPermissions モードが利用可能](/docs/ja/permission-modes#skip-all-checks-with-bypasspermissions-mode)で、かつ[機能フラグの取得](/docs/ja/env-vars#features-that-need-feature-flag-fetching)がオフの場合、これらの呼び出しはプロンプトなしで実行されます。

`createIfEmpty` を設定する `tabs_context_mcp` 呼び出しや、これらのアクションのいずれかを含む `browser_batch` 呼び出しでもプロンプトが表示されます。

<h2 id="example-workflows">
  ワークフロー例
</h2>

これらの例は、ブラウザアクションとコーディングタスクを組み合わせる一般的な方法を示しています。`/mcp` を実行して `claude-in-chrome` を選択し、**View tools** を選択すると、利用可能なブラウザツールの完全なリストが表示されます。

<h3 id="test-a-local-web-application">
  ローカル Web アプリケーションをテストする
</h3>

Web アプリを開発する場合、変更が正しく機能することを確認するよう Claude に依頼します。

```text wrap theme={null}
I just updated the login form validation. Can you open localhost:3000,
try submitting the form with invalid data, and check if the error
messages appear correctly?
```

Claude はローカルサーバーに移動し、フォームと対話し、観察したことを報告します。

<h3 id="debug-with-console-logs">
  コンソールログでデバッグする
</h3>

Claude はコンソール出力を読み取って問題の診断を支援できます。ログが詳細になる可能性があるため、すべてのコンソール出力を要求するのではなく、探すパターンを Claude に伝えます。

```text wrap theme={null}
Open the dashboard page and check the console for any errors when
the page loads.
```

Claude はコンソールメッセージを読み取り、特定のパターンまたはエラータイプでフィルタリングできます。

<h3 id="automate-form-filling">
  フォーム入力を自動化する
</h3>

反復的なデータ入力タスクを高速化します。

```text wrap theme={null}
I have a spreadsheet of customer contacts in contacts.csv. For each row,
go to the CRM at crm.example.com, click "Add Contact", and fill in the
name, email, and phone fields.
```

Claude はローカルファイルを読み取り、Web インターフェースをナビゲートし、各レコードのデータを入力します。

<h3 id="upload-files-to-web-pages">
  Web ページにファイルをアップロードする
</h3>

Claude は、マシン上のファイルをページ上のアップロードフィールドに添付できます。Claude Code がファイルを読み取ってその内容をブラウザに送信するため、アップロードはローカルセッションとリモートセッションの両方で機能します。Claude Code v2.1.211 以降が必要です。

この例では、ログファイルをフォームに添付します。

```text wrap theme={null}
Open the bug tracker at bugs.example.com, create a new issue,
and attach logs/session.log to it
```

アップロードには次の 3 つの制限が適用されます。

* **権限**: Claude がファイルをアップロードできるのは、セッションがそのファイルの読み取りを許可されている場合のみです。そのため、ファイルへの `Read` アクセスを拒否する[権限ルール](/docs/ja/settings-reference#permission-settings)は、そのファイルのアップロードもブロックします。
* **サイズ**: 1 回のアップロードに含められるファイルは合計 10 MB までです。
* **ハードリンク**: Claude は複数のハードリンクを持つファイルを拒否します。これは `node_modules` などのパッケージマネージャーのストア内でよく見られます。ファイルをコピーし、そのコピーをアップロードしてください。

<h3 id="draft-content-in-google-docs">
  Google Docs でコンテンツをドラフトする
</h3>

API セットアップなしで Claude を使用してドキュメントに直接書き込みます。

```text wrap theme={null}
Draft a project update based on the recent commits and add it to my
Google Doc at docs.google.com/document/d/abc123
```

Claude はドキュメントを開き、エディターをクリックしてコンテンツを入力します。これは、ログインしているあらゆる Web アプリで機能します。Gmail、Notion、Sheets など。

<h3 id="extract-data-from-web-pages">
  Web ページからデータを抽出する
</h3>

Web サイトから構造化情報を取得します。

```text wrap theme={null}
Go to the product listings page and extract the name, price, and
availability for each item. Save the results as a CSV file.
```

Claude はページに移動し、コンテンツを読み取り、データを構造化形式にコンパイルします。

<h3 id="run-multi-site-workflows">
  マルチサイトワークフローを実行する
</h3>

複数の Web サイト間でタスクを調整します。

```text wrap theme={null}
Check my calendar for meetings tomorrow, then for each meeting with
an external attendee, look up their company website and add a note
about what they do.
```

Claude はタブ間で動作して情報を収集し、ワークフローを完了します。

<h3 id="record-a-demo-gif">
  デモ GIF を記録する
</h3>

ブラウザインタラクションの共有可能な記録を作成します。

```text wrap theme={null}
Record a GIF showing how to complete the checkout flow, from adding
an item to the cart through to the confirmation page.
```

Claude はインタラクションシーケンスを記録し、GIF ファイルとして保存します。記録にはブラウザに表示されるすべてのもの（ログイン済みページのアカウント詳細を含む）が含まれるため、チーム外と共有する前に内容を確認してください。

<h3 id="save-screenshots-to-disk">
  スクリーンショットをディスクに保存する
</h3>

スクリーンショットをファイルとして保存するよう Claude に依頼します。

```text wrap theme={null}
Take a screenshot of the checkout page and save it to disk
```

Claude は画像をディスクに保存し、ファイルパスを報告します。v2.1.211 より前では、スクリーンショットツールの `save_to_disk` オプションはファイルを書き込みませんでした。

<h2 id="troubleshooting">
  トラブルシューティング
</h2>

<h3 id="extension-not-detected">
  拡張機能が検出されない
</h3>

Claude Code が Chrome 拡張機能を検出できない場合：

1. Chrome 拡張機能が `chrome://extensions` にインストールされ、有効になっていることを確認します
2. `claude --version` を実行して Claude Code が最新であることを確認します
3. Chrome が実行されていることを確認します
4. `/chrome` を実行して「Reconnect extension」を選択し、接続を再確立します
5. 問題が解決しない場合、Claude Code と Chrome の両方を再起動します

Chrome 統合を初めて有効にすると、Claude Code はネイティブメッセージングホスト設定ファイルをインストールします。Chrome はスタートアップ時にこのファイルを読み取るため、最初の試行で拡張機能が検出されない場合、Chrome を再起動して新しい設定を取得します。

Claude Code は、初回インストール時にのみ拡張機能の接続を促すブラウザタブを開きます。後続のセッションで設定ファイルが書き直された場合（例えばビルドや設定ディレクトリを切り替えた後）、Claude Code はタブを再度開きません。

接続がまだ失敗する場合、ホスト設定ファイルが以下の場所に存在することを確認します。

Chrome の場合：

* **macOS**：`~/Library/Application Support/Google/Chrome/NativeMessagingHosts/com.anthropic.claude_code_browser_extension.json`
* **Linux**：`~/.config/google-chrome/NativeMessagingHosts/com.anthropic.claude_code_browser_extension.json`
* **Windows**：Windows レジストリで `HKCU\Software\Google\Chrome\NativeMessagingHosts\` を確認します

Edge の場合：

* **macOS**：`~/Library/Application Support/Microsoft Edge/NativeMessagingHosts/com.anthropic.claude_code_browser_extension.json`
* **Linux**：`~/.config/microsoft-edge/NativeMessagingHosts/com.anthropic.claude_code_browser_extension.json`
* **Windows**：Windows レジストリで `HKCU\Software\Microsoft\Edge\NativeMessagingHosts\` を確認します

その他の Chromium ベースのブラウザは、ブラウザ名にちなんだ独自の設定ディレクトリから同じファイルを読み取ります。例えば、macOS 上の Brave は `~/Library/Application Support/BraveSoftware/Brave-Browser/NativeMessagingHosts/` を使用し、Windows では各ブラウザが `HKCU\Software\BraveSoftware\Brave-Browser\NativeMessagingHosts\` のような独自のレジストリキーを持ちます。

<h3 id="browser-not-responding">
  ブラウザが応答しない
</h3>

Claude のブラウザコマンドが機能しなくなった場合：

1. モーダルダイアログ（alert、confirm、prompt）がページをブロックしているかどうかを確認します。JavaScript ダイアログはブラウザイベントをブロックし、Claude がコマンドを受け取るのを防ぎます。ダイアログを手動で閉じてから、Claude に続行するよう伝えます。
2. Claude に新しいタブを作成して再度試すよう依頼します
3. `chrome://extensions` で拡張機能を無効にしてから再度有効にして Chrome 拡張機能を再起動します

<h3 id="connection-drops-during-long-sessions">
  長いセッション中に接続が切れる
</h3>

Chrome 拡張機能のサービスワーカーは長時間のセッション中にアイドル状態になる可能性があり、接続が切れます。非アクティブ期間後にブラウザツールが機能しなくなった場合、`/chrome` を実行して「Reconnect extension」を選択します。

<h3 id="windows-specific-issues">
  Windows 固有の問題
</h3>

Windows では、以下の問題が発生する可能性があります。

* **名前付きパイプの競合（EADDRINUSE）**：別のプロセスが同じ名前付きパイプを使用している場合、Claude Code を再起動します。Chrome を使用している他の Claude Code セッションを閉じます。
* **ネイティブメッセージングホストエラー**：ネイティブメッセージングホストがスタートアップ時にクラッシュする場合、Claude Code を再インストールしてホスト設定を再生成してみてください。
* **セットアップページが開かない**：Claude Code を更新します。v2.1.211 より前では、Windows で拡張機能の接続を促すブラウザタブが開かないことがありました。

<h3 id="common-error-messages">
  一般的なエラーメッセージ
</h3>

これらは最も頻繁に遭遇するエラーと、それらを解決する方法です。

| エラー | 原因 | 修正 |
| - | - | - |
| "Browser extension is not connected" | ネイティブメッセージングホストが拡張機能に到達できない、または組織の IP 許可リストが `bridge.claudeusercontent.com` への接続を拒否している | Chrome と Claude Code を再起動してから、`/chrome` を実行して再接続します。組織が IP 許可リストを使用しており、エラーが解決しない場合は、[組織の IP 許可リストとプロキシのエグレス](/docs/ja/network-config#organization-ip-allowlists-and-proxy-egress)を参照してください |
| `/chrome` で拡張機能に「Not detected」と表示される | Chrome 拡張機能がインストールされていないか、無効になっている | `chrome://extensions` で拡張機能をインストールまたは有効にします |
| "No tab available" | Claude がタブの準備ができる前に動作しようとした | Claude に新しいタブを作成して再度試すよう依頼します |
| "Receiving end does not exist" | 拡張機能サービスワーカーがアイドル状態になった | `/chrome` を実行して「Reconnect extension」を選択します |

<h2 id="see-also">
  関連項目
</h2>

* [コンピュータ使用](/docs/ja/computer-use)：ブラウザでタスクを実行できない場合にネイティブ macOS アプリを制御します
* [VS Code で Claude Code を使用する](/docs/ja/vs-code#automate-browser-tasks-with-chrome)：VS Code 拡張機能でのブラウザ自動化
* [CLI リファレンス](/docs/ja/cli-reference)：`--chrome` を含むコマンドラインフラグ
* [一般的なワークフロー](/docs/ja/common-workflows)：Claude Code を使用するその他の方法
* [データとプライバシー](/docs/ja/data-usage)：Claude Code がデータを処理する方法
* [Chrome で Claude を使い始める](https://support.claude.com/en/articles/12012173-getting-started-with-claude-in-chrome)：ショートカット、スケジューリング、権限を含む Chrome 拡張機能の完全なドキュメント
