---
applyTo: "{src,scripts}/**/*.py"
description: "Python のプロダクトコード・補助スクリプトを編集・作成・レビューするときに使う。"
---

- 共通規約は `AGENTS.md` に従う
- `src/` の変更では公開APIやパッケージ構成への影響を確認する
- `scripts/` の変更ではCI・手順書から参照される実行パスへの影響を確認する
- スクリプトを追加するときは `scripts/<feature>/` と対応する `tests/scripts/<feature>/` を同時に作成する
- Pythonコード変更後は共通の `sk-python-quality` Skillを使う
