# cli completion (also see ./completion.zsh)
autoload -U +X compinit && compinit

if [ -f $HOME/.config/zsh/_before.zsh ]; then
  source $HOME/.config/zsh/_before.zsh
fi

eval "$(/opt/homebrew/bin/brew shellenv)"

##################
## oh-my-zsh
##################
ZSH_THEME="robbyrussell"
plugins=(git per-directory-history kubectl fzf asdf yarn)
source $HOME/.oh-my-zsh/oh-my-zsh.sh

source $HOME/.config/zsh/common.zsh

if [ -f $HOME/.config/zsh/_after.zsh ]; then
  source $HOME/.config/zsh/_after.zsh
fi
