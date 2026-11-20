<!-- BEGIN TEMPLATE: Python-template -->
## Python

Python のコード・テスト・設定 (`src/`、`scripts/`、`tests/`、`pyproject.toml`) を扱うときに適用する。
このセクションは Python 固有の規約だけを定め、Git 操作やセキュリティなどリポジトリ全体の共通規約は扱わない。

### ディレクトリ構成

- `src/<package_name>/` には配布・利用されるプロダクトコードを配置する
- `scripts/<feature>/` にはリポジトリ運用や開発を補助するコードを配置する
- `scripts/` は単一ファイルの機能でも必ず機能単位のフォルダを作り、直下へ機能ファイルを置かない
- 後からファイルが増えた場合にフォルダ分けする方式は採用しない
- すべてのテストは `tests/` に配置し、実装側の構造をミラーする
  - `scripts/<feature>/` のテストは `tests/scripts/<feature>/` に配置する
  - スクリプトを追加するときは `scripts/<feature>/` と `tests/scripts/<feature>/` を同時に作成する
- Python ファイルをリポジトリ直下に置かない

### 実装

- Python の実行・検証には `uv run` を使う
- パッケージ追加はユーザーの承認を得てから `uv add` で行い、pip コマンドを直接使わない
- コーディング規約の正本は `pyproject.toml` とする
- 必要な変数や関数には型ヒントを付ける
- ファイルパス操作には `os.path` ではなく `pathlib.Path` を使う
- broad catch やエラーの握りつぶしを避け、失敗は明示的に報告する
- `src/` の変更では、公開 API やパッケージ構成への影響を確認する
- `scripts/` の変更では、CI や手順書から参照される実行パスへの影響を確認する

### テストと品質

- テストフレームワークは pytest を使い、ファイル名は `test_*.py` とする
- テストは読みやすさを優先し、必要な前提だけを明示する
- Python の変更後は、変更範囲に応じて最小限のテストを実行する
- 最終検証では可能な限り以下を実行する
  - `uv run pytest`
  - `uv run ruff check src scripts tests`
  - `uv run ruff format --check src scripts tests`
  - `uv run mypy src scripts tests`
  - `uv run pyright`
- pyright は mise で固定した Node.js を使う。`nodeenv failed` の案内に従って `pyright[nodejs]` を導入しない

### Skill と Agent

- Python コードの品質確認や修正には `sk-python-quality` Skill (`.agents/skills/sk-python-quality/SKILL.md`) を使う
- Python コードのレビューには `sk-python-review` Skill (`.agents/skills/sk-python-review/SKILL.md`) を使う
- `.claude/` と `.github/` にある Python 用の Skill・Agent はツール別のアダプターで、手順の正本は `.agents/skills/` とする
- Python 向けの規約や手順を変更するときは、このセクションまたは `.agents/skills/` を更新し、アダプターへ内容を複製しない
<!-- END TEMPLATE: Python-template -->
