# cli completion (also see ./completion.zsh)
autoload -U +X compinit && compinit

if [ -f $HOME/.config/zsh/_before.zsh ]; then
  source $HOME/.config/zsh/_before.zsh
fi
source $HOME/.config/zsh/common.zsh

eval "$(/opt/homebrew/bin/brew shellenv)"

##################
## oh-my-zsh
##################
ZSH_THEME="robbyrussell"
plugins=(git per-directory-history kubectl fzf asdf)
source $HOME/.oh-my-zsh/oh-my-zsh.sh

if [ -f $HOME/.config/zsh/_after.zsh ]; then
  source $HOME/.config/zsh/_after.zsh
fi
