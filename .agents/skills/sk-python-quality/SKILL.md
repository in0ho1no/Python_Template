---
name: sk-python-quality
description: >-
  Pythonコードの静的解析を行い品質を確認する。
  「コードをチェックして」「品質確認して」「ruffで見て」「mypyで型チェック」「pyrightで見て」「Lintして」
  「このコード問題ある?」「静的解析して」のようにPythonコードの確認を依頼されたとき、
  またはPythonファイルを開いた状態で品質に関する質問があるときは、
  明示されなくても必ずこのスキルを使うこと。
---

# Python品質チェッカー

ruff・mypy・pyrightを使ってPythonコードを静的解析し、問題点を優先度付きで報告する。
コマンドはすべて `uv run` で実行する。

## 対象パスを決める

以下の優先順位で決定する:

| 優先順位 | 条件 | 対象パス |
|---|---|---|
| 1 | ユーザーが明示した | 指定されたパス |
| 2 | 直前に編集操作がある | 編集したファイル(複数なら含む最小ディレクトリ) |
| 3 | 上記いずれも該当しない | `src scripts tests` |

対象が広すぎてチェックに時間がかかりそうな場合はユーザーに確認してから実行する。

## ツールが見つからない場合

ruff・mypy・pyrightは `pyproject.toml` の dev 依存に含まれている。
見つからない場合は依存が同期されていないため、`uv sync` の実行を案内して終了する。
パッケージの追加(`uv add`)やpipでの導入は行わない。

## 実行手順

### ruffでスタイル・バグ検出

```
uv run ruff check <対象パス>
```

- `--fix` オプションは **ユーザーから明示的に依頼された場合のみ** 使用する

### ruffでフォーマットチェック

```
uv run ruff format --check <対象パス>
```

- ファイルを変更せず、フォーマットが必要なファイル名のみを検出する
- 実際のフォーマット適用(`ruff format`)は **ユーザーから明示的に依頼された場合のみ** 実行する

### mypyで型チェック

```
uv run mypy <対象パス>
```

- `pyproject.toml` の `[tool.mypy]` セクションが自動的に読み込まれる

### pyrightで型チェック

```
uv run pyright <対象パス>
```

- pyrightはmiseで固定したNode.jsをPATHから使う。PATHに`node`がないと`nodeenv failed`で失敗する。このとき表示される`pyright[nodejs]`の導入案内には従わず、`intro_temp_py.md`に沿ってmiseとPATHの準備状況を確認し、未実行として報告する
- `pyproject.toml` の `[tool.pyright]` セクションが自動的に読み込まれる

## レポート形式

以下のフォーマットで出力する。問題が0件のセクションは省略してよい。

```
## Python品質チェック結果

### 🔴 ruff check
- `src/xxxx/main.py:12` E501 行が長すぎます(160文字 > 150文字)
- `src/xxxx/utils.py:34` F401 `os`がインポートされているが使用されていません

### 🔵 ruff format
- `src/xxxx/utils.py` フォーマットが必要です

### 🟡 mypy
- `src/xxxx/main.py:8` error: 引数の型が一致しません (expected "str", got "int")

### 🟡 pyright
- `src/xxxx/main.py:8` Argument of type "Literal[1]" cannot be assigned to parameter of type "str"

### ✅ サマリー
| ツール        | 件数 |
|---------------|------|
| ruff check    | 2件  |
| ruff format   | 1件  |
| mypy          | 1件  |
| pyright       | 1件  |
```

問題が一切ない場合は「✅ ruff check・ruff format・mypy・pyright ともに問題は検出されませんでした」とだけ出力する。

## 注意事項

- ファイルパスは相対パスで表示する
- ruff check の warning(W系)は🟡で表示し、error(E/F系)は🔴で表示する
- 自動修正を提案する場合は「`uv run ruff check --fix <対象パス>` で自動修正できます」と添えるにとどめ、勝手に実行しない
- 自動フォーマットを提案する場合は「`uv run ruff format <対象パス>` で自動フォーマットできます」と添えるにとどめ、勝手に実行しない
- mypyのエラーが多い場合(20件超)は件数のみ示し、上位5件を抜粋する
- pyrightのエラーが多い場合(20件超)は件数のみ示し、上位5件を抜粋する
