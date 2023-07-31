# only thing to do on bash lol
if [[ -n $SSH_CONNECTION ]] ; then
    # echo "Logged in remotely. Welcome guest! Starting zsh"
    zsh
fi
