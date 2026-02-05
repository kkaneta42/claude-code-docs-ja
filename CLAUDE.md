# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## プロジェクト概要

Claude Code公式ドキュメントの日本語版を自動更新・管理するリポジトリ。

## コマンド

```bash
# ドキュメント更新チェック・ダウンロード
./docs-ja/scripts/check-updates.sh
```

## 構成

```
docs-ja/
├── index.md          # ドキュメント一覧・ナビゲーション
├── pages/            # 日本語ドキュメント
├── .cache            # Last-Modifiedキャッシュ
└── scripts/          # 更新スクリプト

.github/workflows/
└── update-docs.yml   # 自動更新ワークフロー（毎日9時JST）
```

## 更新システム

- **ソース**: https://code.claude.com/docs/ja/
- **自動実行**: GitHub Actions（毎日UTC 0時 = 日本時間9時）
- **処理**: llms.txt解析 → 日本語版存在チェック → Last-Modified比較 → ダウンロード
- **履歴**: Gitコミット履歴で管理

## 命名規則

- ドキュメント: `{page-name}-ja.md`（例: `overview-ja.md`, `cli-reference-ja.md`）
- キャッシュ形式: `page-name=Last-Modified日時`
