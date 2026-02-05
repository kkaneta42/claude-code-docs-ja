# Claude Code 日本語ドキュメント

Claude Code公式ドキュメントの日本語版。

## ドキュメント一覧

[index.md](index.md) を参照。

## フォルダ構成

```
docs-ja/
├── index.md          # ドキュメント一覧
├── README.md         # このファイル
├── .cache            # 更新日時キャッシュ
├── diffs/            # 差分ファイル
├── scripts/
│   ├── check-updates.sh  # 更新チェック・ダウンロード
│   └── show-dates.sh     # 更新日時表示
└── pages/            # 日本語ドキュメント（50ファイル）
```

## 更新

```bash
# 通常モード
./scripts/check-updates.sh

# サイレントモード
./scripts/check-updates.sh --quiet

# 更新日時一覧
./scripts/show-dates.sh
```

## 自動更新

`/Users/k/Claude` でClaude Code起動時に自動チェック（`.claude/settings.json` で設定済み）。

## ソース

https://code.claude.com/docs/ja/
