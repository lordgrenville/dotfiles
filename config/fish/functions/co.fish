# use fzf to switch conda env!!!
function co
    conda deactivate && conda activate (ls ~/anaconda3/envs/ | fzf)
end
