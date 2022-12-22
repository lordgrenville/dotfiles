# uncomment at top and bottom for profiling
# zmodload zsh/zprof
export LANG="en_US.UTF-8"
export JAVA_HOME="/Users/josh/jdk-17.0.1.jdk/Contents/Home"
# export EDITOR="/opt/homebrew/bin/vi"
export BAT_THEME="Sublime Snazzy"

HISTFILE="$HOME/.zsh_history"
HISTSIZE=10000000
SAVEHIST=10000000
# setopt SHARE_HISTORY             # Share history between all sessions.
# removeing this one since it adds timestamp to HISTFILE temporarily
setopt HIST_IGNORE_ALL_DUPS      # ignores even non-consecutive dupes, unlike ginore_dups
setopt HIST_FIND_NO_DUPS         # Do not display a line previously found.
setopt HIST_IGNORE_SPACE         # Don't record an entry starting with a space.
setopt HIST_SAVE_NO_DUPS         # Don't write duplicate entries in the history file.
setopt HIST_EXPIRE_DUPS_FIRST    # old dups will be wiped
setopt HIST_REDUCE_BLANKS        # Remove superfluous blanks before recording entry.
setopt HIST_VERIFY               # Don't execute immediately upon history expansion.
setopt NO_BEEP                   # Don't beep
unsetopt FLOWCONTROL             # enable C-q to "park"

# Report CPU usage for commands running longer than 10 seconds
REPORTTIME=10

unsetopt correct_all
setopt correct  # don't correct argument names
autoload -U select-word-style
select-word-style bash
# case-insensitive autocomplete if no match on case
autoload -Uz compinit && compinit
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}'

setopt auto_cd
DIRSTACKSIZE=20    
setopt autopushd pushdsilent pushdtohome
# Remove duplicate entries
setopt pushdignoredups
# This reverts the +/- operators.
setopt pushdminus

PYTHONSTARTUP=~/.pythonrc

alias ll="exa --color auto --all --group-directories-first --long --group --header --modified --sort=name --git --time-style=long-iso --classify"
alias ...="cd ../.."
alias ....="cd ../../.."
# ensure mac uses the homebrew version
alias vi=/opt/homebrew/bin/vi
alias expand="source /opt/homebrew/share/zsh-abbr/zsh-abbr.zsh"

bindkey "^[f" forward-word
bindkey "^[b" backward-word
bindkey -e
bindkey \^U backward-kill-line

export LC_ALL=en_US.UTF-8
export VIRTUAL_ENV_DISABLE_PROMPT=0

# use cd~wo<TAB> to get to work folder
export work=/Users/josh/Documents/work

# the below is a function. functions are defined either by the word function, or by the syntax foo ()
# it calls git credential-osxkeychain and begins a HERE DOCUMENT, a way to put interactive content into a shell
# it uses <<, which means "keep listening until you see this character" (in this case the Unix special char EOF)
# $1 and $2 are the username and password args

switch_git_cred () {
if [ "$1" = "lordgrenville" ]; then
  git config --global user.username "lordgrenville" && git config --global user.email "16547083+lordgrenville@users.noreply.github.com" \
      && git config --global core.sshCommand "ssh -i ~/.ssh/id_rsa_pers -F /dev/null"
elif  [ "$1" = "josh-scadafence" ]; then
  git config --global user.username "josh-scadafence" && git config --global user.email "josh.friedlander@scadafence.com" \
      && git config --global core.sshCommand "ssh -i ~/.ssh/id_rsa_work -F /dev/null"
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
grep --color=always -RIi $1 .
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
create_env() {/opt/homebrew/bin/python3 -m venv --upgrade-deps temp_env/; source temp_env/bin/activate}
# create_env() {python3 -m venv temp_env/; source temp_env/bin/activate; echo 'Updating pip...'; $(which python3.9) -m pip install --upgrade pip 1>/dev/null}

destroy_env() {deactivate && rm -rf temp_env/}

# use fzf to switch conda env!!!
co() {
  conda deactivate && conda activate $(ls ~/miniforge3/envs/ | fzf)
}

tm() {
tmux a -t $(tmux list-sessions | sed -E 's/:.*$//' | grep -v \"^$(tmux display-message -p '#S')\$\" | fzf)
}
# Add default node to path
# export PATH=~/.nvm/versions/node/v15.14.0/bin:$PATH
# Load NVM
# export NVM_DIR=~/.nvm

# [[ -s "$NVM_DIR/nvm.sh" ]] && source "$NVM_DIR/nvm.sh" --no-use
# export NVM_DIR="$HOME/.nvm"
# [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
# [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# [[ ! -r /Users/josh/.opam/opam-init/init.zsh ]] || source /Users/josh/.opam/opam-init/init.zsh  > /dev/null 2> /dev/null

eval "$(starship init zsh)"

# plugins
# source /opt/homebrew/share/zsh-abbr/zsh-abbr.zsh
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
fpath=( /Users/josh/misc/ohmyzsh/plugins/gitfast $fpath )
# see top
# zprof
