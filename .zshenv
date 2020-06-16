path+=/usr/local/sbin
typeset -U path
# adding some aliases here (which are already present in interactive shells via oh-my-zsh git plugin) for use in vim
# so...might screw some stuff up. but has anyone ever *wanted* to use GhostScript?
alias gs='git status'
alias gd='git diff'
alias gds='git diff --staged'
alias gcmsg='git commit -m'
alias gp='git push'
alias glo='git log --oneline --decorate'
alias ll='exa --color auto --all --group-directories-first --long --group --header --modified --sort=name --git --time-style=long-iso --classify'
