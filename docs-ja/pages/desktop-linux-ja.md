> ## Documentation Index
> Fetch the complete documentation index at: https://code.claude.com/docs/llms.txt
> Use this file to discover all available pages before exploring further.

# Claude Desktop on Linux (beta)

> Ubuntu と Debian に Claude デスクトップアプリをインストールおよび更新する

<Note>
  Claude デスクトップアプリの Linux サポートはベータ版です。Chat、Cowork、Code タブはすべて利用可能です。
</Note>

Linux 上のデスクトップアプリは、macOS と Windows と同じ Chat、Cowork、Claude Code エクスペリエンスを提供します。並列セッション、ビジュアル diff レビュー、統合ターミナルとエディタ、ライブアプリプレビューが含まれます。完全な機能リファレンスについては、[Claude Code Desktop を使用する](/ja/desktop)を参照してください。

<h2 id="requirements">
  要件
</h2>

* Ubuntu 22.04 以降、または Debian 12 以降
* x86\_64 または arm64

これらの要件を満たす他の Debian ベースのディストリビューションは動作する可能性がありますが、公式にはテストされていません。

<h2 id="install">
  インストール
</h2>

Anthropic の apt リポジトリからインストールして、更新がシステムの通常のパッケージ更新を通じて提供されるようにします。

<Steps>
  <Step title="Anthropic の apt リポジトリを追加する">
    Anthropic の署名キーをダウンロードします。

    ```bash theme={null}
    sudo curl -fsSLo /usr/share/keyrings/claude-desktop-archive-keyring.asc https://downloads.claude.ai/claude-desktop/key.asc
    ```

    リポジトリを登録します。

    ```bash theme={null}
    echo "deb [arch=amd64,arm64 signed-by=/usr/share/keyrings/claude-desktop-archive-keyring.asc] https://downloads.claude.ai/claude-desktop/apt/stable stable main" | sudo tee /etc/apt/sources.list.d/claude-desktop.list
    ```
  </Step>

  <Step title="パッケージをインストールする">
    ```bash theme={null}
    sudo apt update && sudo apt install claude-desktop
    ```
  </Step>

  <Step title="起動してサインインする">
    アプリケーションランチャーから **Claude** を起動するか、ターミナルから `claude-desktop` を実行して、Anthropic アカウントでサインインします。
  </Step>
</Steps>

<Accordion title="署名キーを検証する">
  ダウンロードした署名キーが Anthropic に属していることを確認できます。

  ```bash theme={null}
  gpg --show-keys /usr/share/keyrings/claude-desktop-archive-keyring.asc
  ```

  フィンガープリントは `31DD DE24 DDFA B679 F42D 7BD2 BAA9 29FF 1A7E CACE` である必要があります。
</Accordion>

<h3 id="install-from-a-downloaded-file">
  ダウンロードしたファイルからインストールする
</h3>

apt リポジトリを使用できない場合は、[claude.com/download](https://claude.com/download) からアーキテクチャ（x64 または arm64）に対応した `.deb` パッケージをダウンロードして、ソフトウェアインストーラーで開くか、ダウンロードディレクトリから実行します。

```bash theme={null}
sudo apt install ./claude-desktop_*.deb
```

この方法でインストールされた `.deb` は更新を受け取りません。apt を通じて更新を取得するには、上記のようにリポジトリを追加するか、パッケージが `/etc/apt/sources.list.d/claude-desktop.list` に書き込むプレースホルダーエントリの `deb` 行をコメント解除します。

<h2 id="update">
  更新
</h2>

デスクトップアプリは Linux では自動的に更新されません。更新はシステムの通常のパッケージ更新で提供されます。

```bash theme={null}
sudo apt update && sudo apt upgrade
```

ディストリビューションのグラフィカルソフトウェアアップデーターも新しいバージョンを検出します。

<h2 id="uninstall">
  アンインストール
</h2>

```bash theme={null}
sudo apt remove claude-desktop
```

これはアプリと一緒に署名キーを削除するため、インストール中にリポジトリエントリを追加した場合は、それも削除します。

```bash theme={null}
sudo rm /etc/apt/sources.list.d/claude-desktop.list
```

<h2 id="what’s-not-in-the-linux-beta-yet">
  Linux ベータ版にまだ含まれていない機能
</h2>

* **Computer Use**: [アプリとスクリーン制御](/ja/desktop#let-claude-use-your-computer)は Linux では利用できません。
* **Dictation**: 音声入力は Linux デスクトップアプリでは利用できません。代わりに CLI で[音声ディクテーション](/ja/voice-dictation)を使用してください。
* **Quick Entry グローバルホットキー**: X11 で動作します。ネイティブ Wayland では、デスクトップ環境の GlobalShortcuts ポータルが必要です。
* **Fedora と RHEL**: 現在、Debian ベースのディストリビューションのみがサポートされています。追加のディストリビューションのサポートは今後提供される予定です。

デスクトップアプリでまだ利用できない機能については、[CLI](/ja/quickstart)は同じ Claude Code エンジンを実行し、より広い範囲の Linux ディストリビューションをサポートしています。[システム要件](/ja/setup#system-requirements)を参照してください。
