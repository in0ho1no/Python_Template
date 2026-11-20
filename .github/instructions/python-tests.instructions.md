---
applyTo: "tests/**/*.py"
description: "Python の pytest ベースのテストファイルを編集・作成するときの補足ルール。"
---

- テストは pytest を使用する
- テストはすべてリポジトリ直下の `tests/` に配置し、実装側のディレクトリ構造をミラーする
- `scripts/<feature>/` のテストは `tests/scripts/<feature>/` に配置する
- テストファイル名は test_*.py とする
- テストは読みやすさを優先し、必要な前提だけを明示する
- テスト追加・変更後は必要最小限の pytest を実行して確認する
