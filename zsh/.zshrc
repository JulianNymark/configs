###########
## STUFF
###########

setopt extended_glob
setopt hist_ignore_all_dups

autoload -U select-word-style
select-word-style bash

###########
## exports
###########

export PATH="$PATH:$HOME/bin"
export PATH="$PATH:$HOME/go/bin"
export PATH="$PATH:$HOME/Repos/synq/SYNQ-bash/"
export PATH="$PATH:$HOME/Repos/scripts"

export EMACS_RUN='emacs 2>/dev/null'
export EDITOR=$EMACS_RUN
export VISUAL=$EMACS_RUN
export GIT_EDITOR=$EMACS_RUN
export TIMEFMT=$'\nreal\t%E\nuser\t%U\nsys\t%S'
export PYTHONSTARTUP="$HOME/.pythonrc"
export HISTTIMEFORMAT='%F %T '
export HISTFILE="$HOME/.zsh_history"
export HISTSIZE=10000
export SAVEHIST=$HISTSIZE
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export GOPATH="$HOME/go"

#############
## SYNQ
#############

source .zshrc_synq

###########
## aliases
###########

alias la='ls -la --color'
alias _='sudo'

alias tree='tree -a -C -I "node_modules" -I ".git"'
alias s='sleep'
alias more='less'
alias beep='bell'
alias ..='cd ..'

############
## GIT
############

git_current_branch(){
    git branch | grep \* | cut -d ' ' -f2
}

alias ga='git add'
alias gc='git commit -v'
alias gcb='git checkout -b'
alias gcm='git checkout master'
alias gco='git checkout'
alias gst='git status'
alias gd='git diff --word-diff=color'
alias gl='git pull'
alias gp='git push'
alias gpsup='git push --set-upstream origin $(git_current_branch)'

# git logging
alias glg='git log --stat'
alias glgp='git log --stat -p'
alias glgg='git log --graph'
alias glgga='git log --graph --decorate --all'
alias glgm='git log --graph --max-count=10'
alias glo='git log --oneline --decorate'
alias glol="git log --graph --pretty='%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
alias glola="git log --graph --pretty='%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --all"
alias glog='git log --oneline --decorate --graph'
alias gloga='git log --oneline --decorate --graph --all'
# Pretty log messages
function _git_log_prettily(){
  if ! [ -z $1 ]; then
    git log --pretty=$1
  fi
}
alias glp="_git_log_prettily"

#############
## functions
#############

dcleanup(){
    docker rm -v $(docker ps --filter status=exited -q 2>/dev/null) 2>/dev/null
    docker rmi $(docker images --filter dangling=true -q 2>/dev/null) 2>/dev/null
}

dcleanup_all(){
  docker rm -f $(docker ps -a -q)
  docker rmi -f $(docker images -q)
  docker volume ls -qf dangling=true | xargs -r docker volume rm
}

dbash(){
  docker exec -it $1 /bin/bash
}

#############
## prompt
#############

autoload -U promptinit && promptinit
prompt j blue

TMOUT=1

TRAPALRM() {
    zle reset-prompt
}

############
## evals
############

eval $(keychain --eval --quiet id_rsa)
