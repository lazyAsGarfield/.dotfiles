abbr -a gcmsg       git commit -m
abbr -a guc         git reset --soft HEAD^
abbr -a grm         git reset --mixed HEAD^
abbr -a gdp         git diff HEAD^
abbr -a gdcap       git diff --cached HEAD^
abbr -a gapp        git apply
abbr -a gignore     git update-index --skip-worktree
abbr -a gunignore   git update-index --no-skip-worktree
abbr -a gloga       git log --oneline --decorate --color --graph --all
abbr -a gpsup       git push --set-upstream origin (git rev-parse --abbrev-ref HEAD)
abbr -a gpsup!      git push --set-upstream --force-with-lease origin (git rev-parse --abbrev-ref HEAD)

abbr -a cd.         cd ..
abbr -a cd..        cd ..
abbr -a cd-         cd -
abbr -a ..          cd ..
abbr -a ...         cd ../..
abbr -a ....        cd ../../..

abbr -a j           jump

abbr -a c           cd_hist
abbr -a c-          cd -
