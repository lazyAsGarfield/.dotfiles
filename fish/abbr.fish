abbr -a gapp        git apply

abbr -a gbd         git branch -d
abbr -a gbd!        git branch -D
abbr -a gbda        git branch --no-color --merged \| command grep -vE '\'^(\+|\*|\s*(master|develop|dev)\s*$)\'' \| command xargs -n 1 git branch -d

abbr -a gcl         git clone --recurse-submodules
abbr -a gcls        git clone --recurse-submodules --depth 1 --shallow-submodules
abbr -a gcmsg       git commit -m
abbr -a gcpa        git cherry-pick --abort
abbr -a gcpc        git cherry-pick --continue

abbr -a gdcap       git diff --cached HEAD^
abbr -a gdp         git diff HEAD^

abbr -a gignore     git update-index --skip-worktree

abbr -a gloga       git log --oneline --decorate --color --graph --all

abbr -a gpsup       git push --set-upstream origin "(git_current_branch)"
abbr -a gpsup!      git push --set-upstream --force-with-lease origin "(git_current_branch)"

abbr -a grm         git reset --mixed HEAD^

abbr -a gstaa       git stash apply
abbr -a gstl        git stash list

abbr -a guc         git reset --soft HEAD^
abbr -a gunignore   git update-index --no-skip-worktree

function git_current_branch
  git rev-parse --abbrev-ref HEAD 2>/dev/null
end

abbr -a cd.         cd ..
abbr -a cd..        cd ..
abbr -a cd-         cd -
abbr -a ..          cd ..
abbr -a ...         cd ../..
abbr -a ....        cd ../../..

abbr -a j           jump

abbr -a c           cd_hist
abbr -a c-          cd -
