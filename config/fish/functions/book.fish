# quick search downloaded epub: unzip latest file in Downloads (if not already there)
# unzip quietly, then (recursive, case-insensitive) grep for first argument
function book
    cd ~/Downloads
    if [ (ls -Art | tail -n 1) != "foo" ]
        cp (ls -Art | tail -n 1) foo.zip
    end
    unzip -qq -o foo.zip -d foo/
    cd foo/
    grep -RIi $argv[1] .
end
