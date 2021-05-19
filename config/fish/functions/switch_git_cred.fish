function switch_git_cred

    printf %s\n "host=github.com" "protocol=https" | git credential-osxkeychain erase

    if [ $argv = "lordgrenville" ]
        read password <~/ghpwpers.txt
    else if  [ $argv = "josh-friedlander-kando" ]
        read password <~/ghpw.txt
    end

    printf %s\n "host=github.com" "protocol=https" "username=$argv" "password=$password" | git credential-osxkeychain store

    if [ $argv = "lordgrenville" ]
      git config --global user.username "lordgrenville" && git config --global user.email "16547083+lordgrenville@users.noreply.github.com"
    else if  [ $argv = "josh-friedlander-kando" ]
      git config --global user.username "josh-friedlander-kando" && git config --global user.email "josh@kando.eco"
    end
end

