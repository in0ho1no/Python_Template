@echo off
chcp 65001 > nul

echo =============================================
echo  Git ローカル設定セットアップ
echo =============================================
echo.


rem ---------------------------------------------------
rem コミットメッセージのテンプレートを設定します。
rem git commit 時にエディタへ書き方の雛形が表示されます。
rem ---------------------------------------------------
git config --local commit.template git-setup/COMMIT_TEMPLATE.md
echo [設定] コミットテンプレート


rem ---------------------------------------------------
rem fetch 時にリモートで削除済みのブランチを
rem ローカルからも自動で削除します。
rem ---------------------------------------------------
git config --local fetch.prune true
echo [設定] fetch.prune


rem ---------------------------------------------------
rem git pull 時にマージコミットを作成します。
rem 誰がいつ変更を取り込んだかを履歴に残すためです。
rem ---------------------------------------------------
git config --local pull.rebase false
echo [設定] pull.rebase


rem ---------------------------------------------------
rem git merge 時に fast-forward を行わず、
rem 必ずマージコミットを作成します。
rem ブランチ単位の作業履歴を明確に残すためです。
rem ---------------------------------------------------
git config --local merge.ff false
echo [設定] merge.ff


rem ---------------------------------------------------
rem WinMerge がインストールされている場合のみ、
rem git windiff コマンドを使えるように設定します。
rem インストールされていない場合はスキップします。
rem ---------------------------------------------------
set WINMERGE=C:\Program Files\WinMerge\WinMergeU.exe
if exist "%WINMERGE%" (
    git config --local diff.tool WinMerge
    git config --local difftool.prompt false
    git config --local difftool.WinMerge.cmd "\"C:/Program Files/WinMerge/WinMergeU.exe\" -e -r -u -x -wl -wr -dl \"a/$MERGED\" -dr \"b/$MERGED\" \"$LOCAL\" \"$REMOTE\""
    git config --local difftool.WinMerge.trustExitCode false
    git config --local alias.windiff "difftool -y -d -t WinMerge"
    echo [設定] WinMerge    ^(git windiff が使用可能です^)
) else (
    echo git windiffコマンドの設定は行いませんでした。（スキップ）
)

echo.
echo =============================================
echo  セットアップが完了しました
echo =============================================
echo.
pause
