function ll
    exa --color auto --all --group-directories-first --long --group --header --modified --sort=name --git --time-style=long-iso --classify $argv
end

function gs
    git status
end

function gds
    git diff --staged
end

function gcmsg
    git commit -m $argv
end

function gcm
    git checkout master
end

function ...
  ../..
end
function ....
  ../../..
end

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
eval /Users/joshfriedlander/anaconda3/bin/conda "shell.fish" "hook" $argv | source
# <<< conda initialize <<<

starship init fish | source
