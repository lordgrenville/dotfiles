# search joplin DB with rga
# rg is fast grep, rga expands it to sqlite files
# case insensitive, include 3 lines after
function notes
    echo $argv[1]
    rga -iA 3 $argv[1] ~/.config/joplin/database.sqlite
end
