# GitHub Copilot向けアダプター

- 作業開始時にリポジトリ直下の `AGENTS.md` を読み、共通規約として必ず従う
- `.github/instructions/` は対象パス固有の追加ルールとして適用する
- 製品固有のAgentは `.github/agents/`、Skillアダプターは `.github/skills/` にある
- Python品質・レビューの実行手順は `.agents/skills/` にある共通Skillを使う
- 共通ルールの変更は `AGENTS.md` または共通Skillに行い、このファイルや `.github/instructions/` へ複製しない

