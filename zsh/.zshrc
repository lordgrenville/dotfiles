unsetopt correct_all
setopt correct  # don't correct argument names
autoload -U select-word-style
select-word-style bash

# history options, mostly from OMZ
setopt extended_history       # record timestamp of command in HISTFILE
setopt hist_expire_dups_first # delete duplicates first when HISTFILE size exceeds HISTSIZE
setopt hist_ignore_dups       # ignore duplicated commands history list
setopt hist_ignore_space      # ignore commands that start with space
setopt hist_verify            # show command with history expansion to user before running it
setopt share_history          # share command history data
SAVEHIST=9999999
export HISTFILE=~/.zsh_history

# case-insensitive autocomplete if no match on case
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}'

setopt auto_cd
DIRSTACKSIZE=20    
setopt autopushd pushdsilent pushdtohome
## Remove duplicate entries
setopt pushdignoredups
## This reverts the +/- operators.
setopt pushdminus

alias ll="exa --color auto --all --group-directories-first --long --group --header --modified --sort=name --git --time-style=long-iso --classify"

bindkey "^[f" forward-word
bindkey "^[b" backward-word
bindkey -e
bindkey \^U backward-kill-line

export LC_ALL=en_US.UTF-8
export VIRTUAL_ENV_DISABLE_PROMPT=0

# the below is a function. functions are defined either by the word function, or by the syntax foo ()
# it calls git credential-osxkeychain and begins a HERE DOCUMENT, a way to put interactive content into a shell
# it uses <<, which means "keep listening until you see this character" (in this case the Unix special char EOF)
# $1 and $2 are the username and password args

switch_git_cred () {
git credential-osxkeychain erase <<EOF
host=github.com
protocol=https
EOF

if [ "$1" = "lordgrenville" ]; then
  password=$(<~/ghpwpers.txt)
elif  [ "$1" = "josh-medorion" ]; then
  password=$(<~/ghpw.txt)
fi

git credential-osxkeychain store <<EOF
host=github.com
protocol=https
username=$1
password=$password
EOF

if [ "$1" = "lordgrenville" ]; then
  git config --global user.username "lordgrenville" && git config --global user.email "16547083+lordgrenville@users.noreply.github.com"
elif  [ "$1" = "josh-medorion" ]; then
  git config --global user.username "josh-medorion" && git config --global user.email "josh@medorion.com"
fi
} 

# quick search downloaded epub: unzip latest file in Downloads (if not already there)
# unzip quietly, then (recursive, case-insensitive) grep for first argument
book () {
cd ~/Downloads
if [ *(om[1]) != "foo" ]; then
    cp *(om[1]) foo.zip
fi
unzip -qq -o foo.zip -d foo/
cd foo/
grep -RIi $1 .
}

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/Users/josh/miniforge3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/Users/josh/miniforge3/etc/profile.d/conda.sh" ]; then
        . "/Users/josh/miniforge3/etc/profile.d/conda.sh"
    else
        export PATH="/Users/josh/miniforge3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

[ -f "${GHCUP_INSTALL_BASE_PREFIX:=$HOME}/.ghcup/env" ] && source "${GHCUP_INSTALL_BASE_PREFIX:=$HOME}/.ghcup/env"

# search joplin DB with rga
# rg is fast grep, rga expands it to  sqlite files
# case insensitive, include 3 lines after
notes() {
    rga -iA 3 $1 ~/.config/joplin/database.sqlite
}

# search a directory with files you don't have permission to, ignore noise
ffind() {
    find . -name $1 2>&1 | grep -v "Permission denied" | grep -v "Operation not permitted"
}

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# create venv, silently update pip
create_env() {python3 -m venv temp_env/; source temp_env/bin/activate}
# create_env() {python3 -m venv temp_env/; source temp_env/bin/activate; echo 'Updating pip...'; $(which python3.9) -m pip install --upgrade pip 1>/dev/null}

destroy_env() {deactivate && rm -rf temp_env/}

# use fzf to switch conda env!!!
co() {
  conda deactivate && conda activate $(ls ~/anaconda3/envs/ | fzf)
}

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

eval "$(starship init zsh)"

# plugins
source /opt/homebrew/share/zsh-abbr/zsh-abbr.zsh
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
