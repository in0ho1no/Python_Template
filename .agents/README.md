# AIツール設定

## 正本

- 常時適用する共通規約: `AGENTS.md`
- 再利用可能な複数手順のワークフロー: `.agents/skills/`

## ツール別の追加設定

- Claude: `.claude/`
- GitHub Copilot: `.github/`
- Codex: 必要な場合のみ `.codex/`
- Antigravity: `AGENTS.md` と `.agents/` を直接利用

CodexとAntigravityは `AGENTS.md` と `.agents/skills/` を直接探索できるため、専用の参照ファイルは置きません。
Antigravityでも重複読み込みを避けるため、`GEMINI.md` は作成しません。

ClaudeとGitHub Copilotの専用ディレクトリには、製品の検出形式に必要なアダプターとAgentを置きます。
共通ルールやワークフローを変更するときは、それぞれ `AGENTS.md` または `.agents/skills/` を更新してください。
