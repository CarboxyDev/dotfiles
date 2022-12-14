# Source the alias file for my personal aliases
source ~/Configs/zsh/alias.zsh


#############################################################
### ZSH PROMPT


# For the prompt shit, check out https://zsh.sourceforge.io/Doc/Release/Prompt-Expansion.html
# For the colors, check out https://www.ditig.com/256-colors-cheat-sheet


# 1 line prompt with full path
#export PS1="%F{214}%m%F{015} %F{039}%~ %F{015}%% "

# 1 line prompt with small concise path
#export PS1="%F{214}%m%F{015} %F{039}%1~ %F{015}%% "

# 1 line prompt with small concise path w/ arrow instead of zsh's % (requires font w/ ligatures)
#export PS1="%F{214}%m%F{015} %F{039}%1~ -> %F{015}"

# 1 line prompt with small concise path and colored %/$ sign 
#export PS1="%F{214}%m%F{015} %F{039}%1~ %F{007}%% %F{015}"

# 1 line prompt with just compact path
export PS1="%F{117}%1~ $ %F{015}%b"


# 1 line prompt with custom lambda marking and gold/purple colors
# export PS1="%F{214}λ%F{015} %F{111}%1~ %B$ %F{015}%b"


# 1 line simple and very concise path
#export PS1="%F{214}%F{015}%F{039}%1~ %F{007}%% %F{015}"

# 1 line prompt with semi-small concise path (like 2 folder names at most)
#export PS1="%F{214}%m%F{015} %F{039}%2~ %F{015}%% "

# 2 line prompt
#export PS1="%F{214}%m%F{015} %F{039}%~ %F{015}"$'\n'"%F{214}->%F{015} "



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
# These scripts given below are dependent upon an absolute path on my local machine.
source ~/Configs/zsh/zsh-z.plugin.zsh
source ~/Configs/zsh/script.zsh

source ~/Configs/bash/gitx.sh
source ~/Configs/bash/extra.sh
# Fuzzy finder
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
# Fuck command for correcting mistakes
eval $(thefuck --alias)

#############################################################
### MISC


# JUnit related stuff
export JUNIT_HOME="$HOME/Dev/Java/JUnit"
export PATH="$PATH:$JUNIT_HOME"
export CLASSPATH="$CLASSPATH:$JUNIT_HOME/junit-4.13.2.jar:$JUNIT_HOME/hamcrest-core-1.3.jar"

# Uncomment the line below to enable a greeting in terminal
#cecho "GREEN" "$USER is now active on $HOST\n"

#############################################################
### ZSH HISTORY RELATED (History saved in ~/.zsh_history)
export HISTFILE=~/.zsh_history
export HISTFILESIZE=1000000
export HISTSIZE=1000000
export SAVEHIST=$HISTSIZE


setopt INC_APPEND_HISTORY
#export HISTTIMEFORMAT="[%F %T] "


