> ## Documentation Index
> Fetch the complete documentation index at: https://code.claude.com/docs/llms.txt
> Use this file to discover all available pages before exploring further.

# クラウドセッションまたは Remote Control セッションを共有する

> 共有した Claude Code セッションで受信者が読める内容を確認し、リンクを開けるユーザーを選択し、共有を停止します。

[クラウドセッション](https://code.claude.com/docs/ja/claude-code-on-the-web.md)または [Remote Control](https://code.claude.com/docs/ja/remote-control.md) セッションをリンクで共有すると、他のユーザーが会話を読めるようになります。

> [!NOTE]
>
> claude.ai のチャットを共有する方法については、[Share and unshare chats](https://support.claude.com/en/articles/10593882-share-and-unshare-chats) を参照してください。

## 受信者に表示される内容

クラウドセッションまたは Remote Control セッションを共有すると、受信者にはそれまでの会話が、Claude のツール呼び出しとその結果とともに表示されます。これには次のような内容が含まれます。

* **メッセージ**：ユーザーのプロンプト、追加した画像、添付したファイルの名前、Claude の返信と思考
* **コードとコマンド**：Claude が読み取り、書き込み、または編集したファイルの内容、およびユーザーまたは Claude が実行したコマンドとその出力
* **認証情報**：メッセージ、ファイル、またはコマンド出力に含まれるキーやトークン
* **他のリポジトリ**：Claude による GitHub 検索の結果。受信者が開けないプライベートリポジトリが含まれる場合があります
* **コネクタの結果**：[コネクタ](https://code.claude.com/docs/ja/mcp.md#use-mcp-servers-from-claude-ai)が返した内容（メール、ドキュメント、Slack メッセージなど）
* **Web コンテンツ**：Claude が読み取ったページと撮影したスクリーンショット
* **ユーザーの設定**：Claude が使用したコネクタの名前、および Claude が参照したコネクタ、[スキル](https://code.claude.com/docs/ja/skills.md)、[プラグイン](https://code.claude.com/docs/ja/plugins/overview.md)の名前と説明

共有セッションにはユーザーの表示名が表示されます。Max、Ultra、または Pro プランでは、[表示名を非表示にできます](#share-from-a-max-or-pro-account)。

受信者の表示はリアルタイムでは更新されません。受信者がページを再読み込みするかリンクを再度開くと、[共有を停止](#stop-sharing-a-session)するまでは、共有後にセッションに追加されたメッセージが表示されます。

### Remote Control セッションで受信者に表示される内容

Remote Control セッションを共有すると、受信者には次の内容も表示されます。

* セッション中に Claude がユーザーのコンピューター上で読み取ったファイルの内容（セッションを開始したフォルダー外のファイルを含む）
* セッション中に Claude が [Claude in Chrome 拡張機能](https://code.claude.com/docs/ja/chrome.md)を通じて開いたページのテキストとスクリーンショット（ユーザーがサインインしているサイトを含む）

## セッションを共有する

まず[セッションを確認](#check-a-session-before-you-share)します。次に、セッション上部の **Share** を選択し、プランで利用できる **Team** または **Public** のいずれかを選び、**Copy link** を選択してリンクを送信します。

### 共有前にセッションを確認する

会話を読み、ツール呼び出しを展開して、[受信者に表示される内容](#what-recipients-see)に記載されている内容がないか確認します。受信者に見せるべきでない内容が会話に含まれている場合は、セッションを **Private** のままにしてください。

サーバーは[一部のケースで共有をブロック](#unshareable-sessions)しますが、共有が許可されたセッションにも機密性の高い内容が含まれている可能性があります。

### Enterprise または Team アカウントから共有する

Enterprise プランと Team プランでは、claude.ai 組織の他のメンバーが、ユーザーが共有したセッションを開ける場合があります。

* **公開範囲のオプション**：**Private** と **Team**
* **リポジトリへのアクセス**：共有されたクラウドセッションを開くには、受信者は[接続済みの GitHub アカウント](https://code.claude.com/docs/ja/web-quickstart.md#connect-github)を通じて、そのセッションの各プライベートリポジトリへのアクセス権を持っている必要があります。リポジトリへのアクセス権を持たないメンバーでも、Remote Control セッションのリンクは開ける場合があります。

### Max、Ultra、または Pro アカウントから共有する

Max、Ultra、Pro プランでは、リンクを持ち claude.ai にサインインしているユーザーであれば誰でも、共有されたセッションを開ける場合があります。

* **公開範囲のオプション**：**Private** と **Public**
* **リポジトリへのアクセス**：**Require repository access** はデフォルトでオフです。オンにすると、共有するクラウドセッションを、各セッションのプライベートリポジトリへのアクセス権を持つ受信者に限定できます。リポジトリへのアクセス権を持たないユーザーでも、Remote Control セッションのリンクは開ける場合があります。

**Require repository access** をオンにする、または **Show your name** をオフにするには、claude.ai で [**Settings > Privacy**](https://claude.ai/settings/data-privacy-controls) に移動し、**Shared Code sessions** の横にある **Manage** をクリックします。

## セッションの共有を停止する

共有したセッションの共有を停止するには、公開範囲を **Private** に戻します。次の操作を行った後もリンクは引き続き有効なため、セッションや組織から離れる前にこの操作を行ってください。

* セッションをアーカイブする
* Remote Control をオフにする、またはターミナルを閉じる
* 組織から脱退する、または組織から削除される（**Team** として共有したリンクの場合）

**Private** に設定しなくてもリンクが無効になるケースについては、[リンクが開けなくなる場合](#links-that-stop-opening)を参照してください。

## 共有のトラブルシューティング

組織が共有をオフにしている場合や、サーバーがそのセッションを拒否した場合は、セッションを共有できません。また、共有後にリンクが開けなくなることもあります。

### 組織で共有がオフになっている

**Share** が淡色表示され、「Sharing is disabled by your organization.」と表示される場合は、[Owner](https://code.claude.com/docs/ja/server-managed-settings.md#access-control) に依頼して、[**Organization settings > Data and privacy**](https://claude.ai/admin-settings/data-privacy-controls) で **Share cloud sessions** をオンにしてもらってください。Remote Control セッションを共有する場合にも、この設定をオンにする必要があります。

一部のコンプライアンス設定では、この設定がオンでもセッションを共有できません。

### 共有できないセッション

受信者に見せるべきでない内容が含まれている可能性があるため、一部のセッションは共有できません。「This session can't be shared.」などのメッセージで共有に失敗した場合、再試行しても解決しません。

たとえば、Enterprise プランと Team プランでは、[アップロードされたコード](https://code.claude.com/docs/ja/claude-code-on-the-web.md#send-local-repositories-without-github)を使用するクラウドセッションは共有できません。そのコードを閲覧できるユーザーを確認する方法がないためです。そのコードに関する作業を共有するには、リポジトリが github.com 上にあり、アップロードされたものではない新しいセッションを開始してください。

### リンクが開けなくなる場合

受信者がリンクを開けない場合は、次の原因を確認してください。

* **公開範囲**：セッションが **Private** になっている、または受信者が claude.ai にサインインしていない、あるいは **Team** リンクで受信者が組織外のユーザーである。[リンクを開けるユーザー](#share-a-session)を確認してください。
* **リポジトリへのアクセス**：リンクで[リポジトリへのアクセスが必要](#share-a-session)とされており、受信者の GitHub アカウントがそのリポジトリを読み取れない。読み取り可能な[アカウントを接続する](https://code.claude.com/docs/ja/web-quickstart.md#connect-github)よう依頼してください。
* **アップロードされたコードまたは GitHub 以外のコード**：リンクでリポジトリへのアクセスが必要とされており、コードが[アップロードされた](https://code.claude.com/docs/ja/claude-code-on-the-web.md#send-local-repositories-without-github)ものであるか、GitLab や Bitbucket などの Git ホスト上にある。リポジトリが github.com 上にあり、アップロードされたものではないセッションから共有してください。
* **無効なリンク**：共有リンクがブラウザーのアドレスと一致していない可能性があります。また、**Public** リンクは、共有を停止して再度共有すると変更されます。**Share** から現在のリンクをコピーして送信してください。
* **組織の設定**：組織で [**Share cloud sessions** がオフになっている](#sharing-is-turned-off-for-your-organization)。Owner に依頼して、再度オンにしてもらってください。
* **プランのアップグレード**：**Public** リンクを共有した後、プランを Team または Enterprise にアップグレードした。リンクには [Enterprise および Team アカウント](#share-from-an-enterprise-or-team-account)のルールが適用されます。
* **プランのダウングレード**：**Public** リンクを共有した後、Free プランに移行した。Max、Ultra、または Pro プランに[アップグレード](https://claude.ai/upgrade)すると、追加の手順なしで同じリンクを開けるようになります。

次の場合、リンクを復元することはできません。

* セッションが削除された
* セッションが[共有できないセッション](#unshareable-sessions)になった
* **Public** リンクを共有した後、[個人アカウントを既存の組織に移行した](https://support.claude.com/en/articles/9267400-move-your-personal-claude-account-to-a-team-or-enterprise-organization)
* 不正利用や著作権の審査後などに、Anthropic がリンクを無効にした。この場合、セッションは **Private** と表示され、再度共有しようとすると「Couldn't share this session. Try again.」と表示されて失敗します。

## 関連リソース

* [クラウドで Claude Code を使用する](https://code.claude.com/docs/ja/claude-code-on-the-web.md)：クラウドセッションのアーカイブ、削除、移動
* [Remote Control](https://code.claude.com/docs/ja/remote-control.md)：別のデバイスからローカルセッションを続行する
