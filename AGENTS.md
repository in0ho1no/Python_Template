# AIエージェント向けリポジトリ規約

このファイルは、Claude、GitHub Copilot、ChatGPT Codex、Antigravityを含む全AIコーディングツールに共通する規約の正本です。
ルールの競合時は、ユーザーの直接指示、リポジトリの実行可能な設定、アダプター固有の補足ルールの順に扱います。

## AI設定

- 常時適用する共通規約はこの `AGENTS.md` に記載する
- 複数手順の再利用可能なワークフローは `.agents/skills/` に配置する
- Claude固有の設定は `.claude/`、GitHub Copilot固有の設定は `.github/` に配置する
- Codex固有の実行設定・Agentが必要になった場合のみ `.codex/` を利用する
- Antigravity固有の条件付きルールが必要になった場合のみ `.agents/rules/` を利用する
- CodexとAntigravityはこの `AGENTS.md` を直接読み込むため、専用の参照ファイルを作らない
- `AGENTS.md` と重複注入されるため、`GEMINI.md` は作成しない
- 共通ルールをツール固有ファイルへ複製せず、必要ならこのファイルへの参照と製品固有事項だけを記載する

## ディレクトリ構成

- `src/<package_name>/` には配布・利用されるプロダクトコードを配置する
- `scripts/<feature>/` にはリポジトリ運用や開発を補助するコードを配置する
- `scripts/` は単一ファイルの機能でも必ず機能単位のフォルダを作り、直下へ機能ファイルを置かない
- 後からファイルが増えた場合にフォルダ分けする方式は採用しない
- すべてのテストは `tests/` に配置する
- テストは実装側の構造をミラーし、`scripts/<feature>/` のテストは `tests/scripts/<feature>/` に配置する
- ドキュメントと設定以外に、ルート直下へ用途不明のファイルを追加しない

## Python

- Pythonの実行・検証には `uv run` を使う
- パッケージ追加はユーザーの承認を得てから `uv add` で行い、pipコマンドを直接使わない
- コーディング規約の正本は `pyproject.toml` とする
- 必要な変数や関数には型ヒントを付ける
- ファイルパス操作には `os.path` ではなく `pathlib.Path` を使う
- broad catchやエラーの握りつぶしを避け、失敗は明示的に報告する

## テストと品質

- テストフレームワークはpytestを使い、ファイル名は `test_*.py` とする
- Python変更後は変更範囲に応じて最小限のテストを実行する
- 最終検証では可能な限り以下を実行する
  - `uv run pytest`
  - `uv run ruff check src scripts tests`
  - `uv run ruff format --check src scripts tests`
  - `uv run mypy src scripts tests`
  - `uv run pyright`
- Pythonコードの品質確認や修正には `.agents/skills/sk-python-quality/SKILL.md` を使う
- Pythonコードのレビューには `.agents/skills/sk-python-review/SKILL.md` を使う
- pyrightはmiseで固定したNode.jsを使う。`nodeenv failed` の案内に従って `pyright[nodejs]` を導入しない

## Gitと外部サービス

- ユーザーの未コミット変更を取り消さない
- 破壊的なGit操作や公開操作を、明示的な依頼なく行わない
- commitを作成するときは、変更内容に合った小さな単位にし、既存履歴のスタイルを確認する
- トークン、パスワード、個人情報などの秘密をリポジトリへ追加しない
- Issue、Pull Request、ワークフローなどへの変更は、既存テンプレートとリポジトリ規約に従う

