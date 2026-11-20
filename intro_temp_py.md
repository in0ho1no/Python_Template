# 環境構築

## Python セットアップ

以下更新すること。

- pyproject.tomlのname
- 仮のパッケージ名 `xxxx`。name に合わせて次の箇所を変更する
  - [src/xxxx/](src/xxxx/) のフォルダ名
  - [tests/xxxx/](tests/xxxx/) のフォルダ名と、[test_main.py](tests/xxxx/test_main.py) の `from xxxx.main import`
  - [.vscode/launch.json](.vscode/launch.json) の `program`

### UVによる環境作成

pyproject.tomlの存在するフォルダ内で以下コマンドを実行することで作成済み環境と同期する

```powershell
uv sync
```

Python は [.python-version](.python-version) で 3.14 系に固定している。`uv sync` は 3.14 系の Python で仮想環境を作成する。
pyproject.toml の requires-python と、ruff・mypy・pyright が前提とする版も 3.14 に揃えている。

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

## AIエージェント設定

Claude Code、GitHub Copilot、Codex、Antigravity の4つで同じ規約が使えるように、正本を1か所に集めている。

| ファイル | 役割 | 読み込むツール |
|---|---|---|
| [AGENTS.md](AGENTS.md) | Python 規約の正本 (Python セクション1つだけ) | Copilot、Codex、Antigravity は直接読む。Claude は `.claude/CLAUDE.md` の import 経由で読む |
| [.claude/CLAUDE.md](.claude/CLAUDE.md) | `@../AGENTS.md` を import するだけのファイル | Claude |
| `.agents/skills/sk-python-*/` | Skill 手順の正本 | Codex、Antigravity |
| `.claude/skills/sk-python-*/`、`.github/skills/sk-python-*/` | 正本を参照するだけの Skill アダプター | Claude、Copilot |
| `.claude/agents/`、`.github/agents/` | ツール別の Agent 定義 (モデル・権限だけを持つ) | Claude、Copilot |

規約や手順を変更するときは、`AGENTS.md` か `.agents/skills/` の正本を更新し、アダプターへ内容を複製しない。
`GEMINI.md` は作らない。Antigravity は `AGENTS.md` と `GEMINI.md` を両方読むため、重複して読み込まれる。

### 他テンプレートとの統合

このテンプレートは [integlate_template](https://github.com/in0ho1no/integlate_template) で他のテンプレートと組み合わせて使う前提で、次のように作っている。

- `AGENTS.md` は `BEGIN TEMPLATE` / `END TEMPLATE` コメントで囲んだ Python セクションだけを持つ。共通規約を持つ Git_Template の `AGENTS.md` の後ろに追記しても、意味が衝突しない
- `.claude/CLAUDE.md` は Git_Template と同じ内容にしている
- Skill・Agent はファイル名に `python` を含めて、他テンプレートと名前が衝突しないようにしている
- `.github/copilot-instructions.md` は置かない。Copilot は `AGENTS.md` を直接読む

統合ツールが `AGENTS.md` を追記対象として扱わない場合は、`AGENTS.md.merge.python` の内容を `AGENTS.md` の末尾へ手で追記する。
`.claude/CLAUDE.md.merge.python` は Git_Template 側と同じ内容なので削除してよい。
