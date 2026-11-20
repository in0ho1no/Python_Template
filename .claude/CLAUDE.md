# CLAUDE.md

## Python利用時の注意事項

### パッケージ追加について

- ライブラリ・パッケージを勝手に追加することは禁止
- pipコマンドを直接利用することは禁止
- パッケージ追加が必要な場合はユーザーに確認し、承認を得た上で `uv add <package>` を使用する

### コーディング時の注意点

- コーディング規約（型ヒント・docstringスタイル・命名規則など）は `pyproject.toml` に定義されているため参照すること
- ツールで自動検出できないルールとして、必要な変数には型ヒントを付けること
- uvで仮想環境を構築してあるので、Pythonスクリプトを実行する場合は`uv run`を利用する
- ファイルパスの操作は `os.path` ではなく `pathlib.Path` を使用する

### ディレクトリ構成

- `src/` には配布・利用されるプロダクトコードを配置する
- `src/` の配布コードは `src/<package_name>/` のようにパッケージ単位で構成する
- `scripts/` にはリポジトリ運用や開発を補助するコードを配置する
- `scripts/` は必ず `scripts/<feature>/` のように機能単位で分割し、単一ファイルの機能でも直下へ配置しない
- 後からファイルが増えた場合にフォルダ分けする方式は採用しない
- すべてのテストは `tests/` に配置する
- テストは実装と対応する構造にし、`scripts/<feature>/` のテストは `tests/scripts/<feature>/` に配置する

### コード品質チェック

- Ruff（lint）: `uv run ruff check src/ scripts/ tests/`
- Ruff（format）: `uv run ruff format src/ scripts/ tests/`
- mypy: `uv run mypy src/ scripts/ tests/`
- pyright: `uv run pyright`
- コード変更後は必ず上記を実行してエラーがないことを確認する
- pyright は mise で固定した Node.js を PATH から使う。`nodeenv failed` で失敗した場合は `pyright[nodejs]` の導入案内に従わず、`intro_temp_py.md` に沿って mise と PATH を確認する

### テスト

- テストフレームワークは pytest を使用する
- テストは `tests/` に配置し、`test_*.py` の命名規則に従う
- スクリプトのテストは `tests/scripts/<feature>/` に配置する
- 実行: `uv run pytest`
