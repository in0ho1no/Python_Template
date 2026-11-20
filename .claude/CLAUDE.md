# Claude向けアダプター

- 作業開始時にリポジトリ直下の `AGENTS.md` を読み、共通規約として必ず従う
- Claude固有のAgentは `.claude/agents/`、製品別のSkillアダプターは `.claude/skills/` にある
- 実際のPython品質・レビュー手順は `.agents/skills/` にある共通Skillを使う
- 共通ルールの変更は `AGENTS.md` または共通Skillに行い、このファイルへ複製しない
