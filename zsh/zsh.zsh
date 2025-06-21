# cli completion (also see ./completion.zsh)
autoload -U +X compinit && compinit

source $HOME/.config/zsh/_before.zsh
source $HOME/.config/zsh/common.zsh

eval "$(/opt/homebrew/bin/brew shellenv)"

##################
## oh-my-zsh
##################
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"
plugins=(git per-directory-history kubectl fzf)
source $ZSH/oh-my-zsh.sh

source $HOME/.config/zsh/_after.zsh
