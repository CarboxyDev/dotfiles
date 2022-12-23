# Source the alias file for my personal aliases
source ~/.alias.zsh
source ~/.prompt.zsh

#############################################################
### AUTO COMPLETE


autoload -Uz compinit
compinit
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' menu select



#############################################################
### EXPORTS


export PATH=~/.npm-global/bin:$PATH
export PATH="/opt/homebrew/opt/make/libexec/gnubin:$PATH"
export PATH="/opt/homebrew/opt/openjdk/bin:$PATH"
export JAVA_HOME=`/usr/libexec/java_home`

# These scripts given below are dependent on absolute paths on my local machine.
source ~/Configs/zsh/zsh-z.plugin.zsh
source ~/Configs/zsh/script.zsh

source ~/Configs/bash/gitx.sh
source ~/Configs/bash/extra.sh
# Fuzzy finder
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
# Command for correcting mistakes
eval $(thefuck --alias)

#############################################################
### MISC



#############################################################
### ZSH HISTORY RELATED (History saved in ~/.zsh_history)
export HISTFILE=~/.zsh_history
export HISTFILESIZE=1000000
export HISTSIZE=1000000
export SAVEHIST=$HISTSIZE


setopt INC_APPEND_HISTORY
#export HISTTIMEFORMAT="[%F %T] "


