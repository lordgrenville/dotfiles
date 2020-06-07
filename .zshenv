# path settings in general should be here
# note lower-case path isn't the same as PATH - it's a zsh convenience, PATH is updated based on it but gives you more convenience (eg can use arrays)
path+=/usr/local/sbin
# the below keeps only unique values in path!
typeset -U path
