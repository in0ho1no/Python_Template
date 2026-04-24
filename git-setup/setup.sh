#!/bin/sh

echo "============================================="
echo " Git ローカル設定セットアップ (Mac/Linux)"
echo "============================================="
echo ""

# コミット時にエディタへ書き方の雛形を表示する
echo "コミット時にエディタへ書き方の雛形を表示します。"
git config --local commit.template git-setup/COMMIT_TEMPLATE.md
echo "[設定] commit.template"
echo ""

# fetch 時にリモートで削除済みのブランチを自動削除する
echo "fetch 時にリモートで削除済みのブランチを自動削除します。"
git config --local fetch.prune true
echo "[設定] fetch.prune"
echo ""

# pull 時にマージコミットを作成し、変更の取り込み履歴を残す
echo "pull 時にマージコミットを作成し、変更の取り込み履歴を残します。"
git config --local pull.rebase false
echo "[設定] pull.rebase"
echo ""

# merge 時に必ずマージコミットを作成し、ブランチ単位の履歴を残す
echo "merge 時に必ずマージコミットを作成し、ブランチ単位の履歴を残します。"
git config --local merge.ff false
echo "[設定] merge.ff"
echo ""

# 改行コードをリポジトリ内では LF に統一し、チェックアウト時は変換しない
echo "改行コードをリポジトリ内では LF に統一します。"
git config --local core.autocrlf input
echo "[設定] core.autocrlf"
echo ""

echo "============================================="
echo " セットアップが完了しました"
echo "============================================="
