# 環境構築

## Python セットアップ

以下更新すること。

- pyproject.tomlのname

### UVによる環境作成

pyproject.tomlの存在するフォルダ内で以下コマンドを実行することで作成済み環境と同期する

```powershell
uv sync
```

ライブラリ追加も同時に行う場合、後述の証明書エラーの対応が必要になるケースもある

### pyright が使う Node.js

pyright は、[mise.toml](mise.toml) で固定した Node.js を PATH から使う。
後述の「依存の更新監視」の手順で Node.js を導入し、mise の shims フォルダ (Windows の既定は `%LOCALAPPDATA%\mise\shims`) を PATH に追加するか、シェルで `mise activate` を有効にする。
管理外の Node.js を使わないよう、pyright が Node.js を自動取得する nodeenv は依存から除外している。
PATH に `node` がない場合、pyright は `nodeenv failed` で失敗する。表示される `pyright[nodejs]` の導入案内には従わず、PATH を確認する。
以前に作られた `~/.cache/pyright-python/nodeenv` が残っていると、PATH に `node` がないときにその Node.js が使われるため、削除する。

### パッケージ追加

#### シンプルな追加手段

パッケージを追加する場合は以下

```powershell
uv add <パッケージ名>
```

バージョン指定が必要なら以下

```powershell
uv add "<パッケージ名>==<バージョン>"
```

#### 証明書エラーの対応

uvはMozillaの証明書を利用しているため、環境によってはエラーになる場合がある。
対策として`--native-tls`フラグと共にコマンドを実行する。

```powershell
uv add <パッケージ名> --native-tls
```

uv syncでエラーが生じる場合も同様である。

```powershell
uv sync --native-tls
```

#### ローカルパッケージの追加

ローカルのパッケージを直接追加する場合は、`pyproject.toml`に追記する。
追記後、内容を反映するために`uv sync`を実行する。

```text
[project]
dependencies = [
    # 相対パスまたは絶対パスで記述
    "package_name @ file:///path/to/package.whl",
]
```

#### requirementsから追加する場合

requirements.txtから追加するなら以下

```powershell
uv add -r requirements.txt
```

### パッケージ削除

パッケージを除外するなら以下

```powershell
uv remove <パッケージ名>
```

## CI

pull request と `main` への push で、[Tests](.github/workflows/tests.yml) が次を実行する。

- mise で固定した Node.js と uv を導入し、`uv sync` で依存を同期する。
- ruff・mypy・pyright・pytest を実行する。
- `mise.toml` の Node.js より新しい版があれば、失敗にせず警告を表示する。

テンプレートでは `uv.lock` を管理しないため、CI は実行時点の最新の依存で検証する。
テンプレートから作成したプロジェクトでは `uv.lock` をコミットし、Tests の `uv sync` に `--locked` を付ける。
`tests` を必須チェックにする場合は、GitHub のブランチ保護またはルールセットで設定する。

## 依存の更新監視

依存の更新漏れを防ぐため、毎週金曜 17:30 (Asia/Tokyo) に次の確認を行う。

- Dependabot が GitHub Actions と Python 依存 (uv) の更新を PR にする。設定は [dependabot.yml](.github/dependabot.yml) を参照する。
- [Node.js Version](.github/workflows/node-version.yml) が [mise.toml](mise.toml) で固定した Node.js を同じメジャーの最新版と比べ、新しい版があれば Issue を作成・更新する。

テンプレートから新しい環境を作成したときは、`mise.toml` のあるフォルダで次を実行する。

```powershell
mise trust
mise install
```

`mise install` は `mise.toml` で固定した Node.js を導入する。
現在の `mise.toml` は `[tools]` に版だけを書いているため、mise の仕様上は信頼しなくても読み込まれる。
環境変数の設定など、コードを実行したり環境に影響したりする設定を追加すると信頼が必要になるため、作成時に `mise trust` も実行しておく。

定期実行は既定ブランチにある workflow だけが起動し、既定ブランチの `mise.toml` を確認する。
公開リポジトリでは、60日間リポジトリの活動がないと定期実行が自動で停止する。書き込み権限を持つ利用者のコミットで再開する。
