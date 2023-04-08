###########################################################
######################## Z S H R C ########################
###########################################################

# Source the other zsh files for the aliases and prompt

source ~/.alias.zsh
source ~/.prompt.zsh


# Add Auto complete functionality

autoload -Uz compinit
compinit
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' menu select


# Export global OS environment variables

export PATH=~/.npm-global/bin:$PATH
export PATH="/opt/homebrew/opt/make/libexec/gnubin:$PATH"
export PATH="/opt/homebrew/opt/openjdk/bin:$PATH"
export JAVA_HOME=`/usr/libexec/java_home`


# Source the miscellanous zsh files

source ~/Configs/zsh/zsh-z.plugin.zsh
source ~/Configs/zsh/script.zsh

source ~/Configs/bash/gitx.sh
source ~/Configs/bash/extra.sh


# Add fuzzy finder
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh


# Miscellanous stuff

DISABLE_AUTO_TITLE="true"
precmd() {
  # sets the tab title to current dir
  echo -ne "\e]1;${PWD##*/}\a"
}


# Maintains zsh history

export HISTFILE=~/.zsh_history
export HISTFILESIZE=1000000
export HISTSIZE=1000000
export SAVEHIST=$HISTSIZE

setopt INC_APPEND_HISTORY


