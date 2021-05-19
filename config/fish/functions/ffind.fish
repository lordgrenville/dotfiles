function ffind
    find . -name $argv[1] 2>&1 | grep -v "Permission denied" | grep -v "Operation not permitted"
end
