function ll
    exa --color auto --all --group-directories-first --long --group --header --modified --sort=name --git --time-style=long-iso --classify $argv
end

abbr -a gs git status
abbr -a gds git diff --staged
abbr -a gcmsg git commit -m
abbr -a gcm git checkout master
abbr -a gs git status

function ...
  ../..
end
function ....
  ../../..
end

starship init fish | source
