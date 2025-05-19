# Step of create work enviromental

## 開発

### テンプレートから作成後に実行する

workspace名の変更

    git mv wsXXX.code-workspace wsDST.code-workspace

README.mdのタイトルを変更する

### 環境準備

仮想環境を作成する

    pipenv --python 3.10

uvの方が早い

    uv venv --python 3.13

## UVによる環境作成

適当なフォルダにて以下でプロジェクトを作成する

    uv init <プロジェクト名>
