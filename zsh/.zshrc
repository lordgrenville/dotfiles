# uncomment at top and bottom for profiling
# zmodload zsh/zprof
export LANG="en_US.UTF-8"
# export JAVA_HOME="/Users/josh/jdk-17.0.1.jdk/Contents/Home"
export EDITOR="/usr/bin/vi"
export BAT_THEME="Sublime Snazzy"

bindkey '[1;3D' emacs-backward-word
bindkey '[1;3C' emacs-forward-word
bindkey '[1;5D' emacs-backward-word
bindkey '[1;5C' emacs-forward-word

HISTFILE="$HOME/.zsh_history"
HISTSIZE=10000000
SAVEHIST=10000000
# setopt SHARE_HISTORY             # Share history between all sessions.
# removing this one since it adds timestamp to HISTFILE temporarily
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
zstyle ':completion:*:*:-command-:*:*' ignored-patterns 'down-case-word-match'

setopt auto_cd
DIRSTACKSIZE=20
setopt autopushd pushdsilent pushdtohome
# Remove duplicate entries
setopt pushdignoredups
# This reverts the +/- operators.
setopt pushdminus

PYTHONSTARTUP=~/.pythonrc

alias ll="exa --color auto --all --group-directories-first --long --group --header --modified --sort=name --time-style=long-iso --classify"
alias ...="cd ../.."
alias ....="cd ../../.."
alias pbcopy='xclip -selection clipboard'
alias pbpaste='xclip -selection clipboard -o'
alias open="xdg-open"
alias noise="play -q -c 2 -n -t alsa synth brownnoise band -n 1600 1500 tremolo .1 30 &"
# get current branch name
alias branch="git rev-parse --abbrev-ref HEAD | tr -d '\n'"

bindkey "^[f" forward-word
bindkey "^[b" backward-word
bindkey -e
bindkey \^U backward-kill-line

export LC_ALL=en_US.UTF-8
export VIRTUAL_ENV_DISABLE_PROMPT=0

switch_git_cred () {
if [ "$1" = "lordgrenville" ]; then
  git config --global user.username "lordgrenville" && git config --global user.email "16547083+lordgrenville@users.noreply.github.com" \
      && git config --global core.sshCommand "ssh -i ~/.ssh/id_rsa_pers -F /dev/null"
elif  [ "$1" = "josh-scadafence" ]; then
  git config --global user.username "josh-scadafence" && git config --global user.email "josh.friedlander@scadafence.com" \
      && git config --global core.sshCommand "ssh -i ~/.ssh/id_rsa_work -F /dev/null"
fi
} 

# lessons learned from writing this:
# - some fancy jq (read in an array of large objects, find one that matches a condition, get it and extract a few fields
# - string interpolation in zsh - can't use arg ($1) directly, must give it another name
# - have to use double quotes, not single
# - if you want to use quotes inside the quotes, then must escape with backslash
camp () {
    id=$1
    jq ".data | map(select(._id==\""${id}"\"))[0] | .settings.platforms, .settings.cc, .ppu" < all_camps.json
}

# quick search downloaded epub: unzip latest file in Downloads (if not already there)
# unzip quietly, then (recursive, case-insensitive) grep for first argument
book () {
cd ~/Downloads
# if foo/ doesn't exist, then copy the latest epub in Downloads to foo.zip and unzip it to there
# om = order by modified, get the first
if [ ! -d "foo" ]; then
    cp *.epub(.om[1]) foo.zip
    unzip -qq -o foo.zip -d foo/
fi
cd foo/
grep --color=always -RIi $1 .
}

# search a directory with files you don't have permission to, ignore noise
ffind() {
    find . -name $1 2>&1 | grep -v "Permission denied" | grep -v "Operation not permitted"
}

source /usr/share/doc/fzf/examples/key-bindings.zsh

# create venv, silently update pip
create_env() {/usr/bin/python3 -m venv --upgrade-deps temp_env/; source temp_env/bin/activate}
# create_env() {python3 -m venv temp_env/; source temp_env/bin/activate; echo 'Updating pip...'; $(which python3.9) -m pip install --upgrade pip 1>/dev/null}

destroy_env() {deactivate && rm -rf temp_env/}

tm() {
tmux a -t $(tmux list-sessions | sed -E 's/:.*$//' | grep -v \"^$(tmux display-message -p '#S')\$\" | fzf)
}

eval "$(starship init zsh)"

# plugins
source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/share/zsh-abbr/zsh-abbr.zsh

fpath=( /Users/josh/misc/gitfast $fpath )
# zprof

# when opening new shells in tmux sessions, don't switch dirs and obviously don't nest my TMUX session
if !  [ -n "$TMUX" ];  then
  tmux attach -t guest
  cd /mnt/data1/FIEF
fi
