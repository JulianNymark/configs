# zstyle ':completion:*' completer _extensions _complete _approximate
# zstyle ':completion:*' use-cache on
# zstyle ':completion:*' cache-path "~/.config/zsh/.zcompcache"
# zstyle ':completion:*' menu select

fpath=($fpath $HOME/Repos/configs/zsh/completions)

autoload -U compinit
compinit
