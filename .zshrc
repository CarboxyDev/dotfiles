#############################################################
# ALIASES (Most of these are for personal use and based on my personal taste)

# Some commands are mac only (Especially ones using the open command)

alias ..='cd ..'
alias ...='cd ../../'
alias back='cd -'
alias cp='cp -iv'
alias mv='mv -iv'
alias top='gotop'
alias ping='ping -c 3'
alias g++='g++ -std=c++17'
alias c='clear'
alias python='python3'
alias py='python3'
alias j='java'
alias jc='javac'
alias a='make a && ./a'
alias finder='open .'
alias apps='cd /Applications && open . && cd -'
alias zshrc='vim ~/.zshrc'
alias bashrc='vim ~/.bashrc'
alias vimrc='vim ~/.vimrc'
alias spotify='open -a spotify.app'
alias whatsapp='open -a whatsapp.app'
alias discord='open -a discord.app'
alias obsidian='open -a obsidian.app'
alias college='cd ~/College && open . && cd -'
alias screenshots='cd ~/Desktop/Screenshots && open . && cd -'
alias scripting='cd ~/Dev/Scripting'

alias mygithub='cecho "CYAN" "My github: https://github.com/CarboxyDev/" && open -a safari "https://github.com/CarboxyDev/"'


# Utilitity related aliases

alias sha='shasum -a 256'
alias diff='colordiff' # requires colordiff 
alias myip='curl https://ipinfo.io/ip && echo "" && ipconfig getifaddr en0'
alias gitupload='git add . && git commit -m "Minor changes [automated commit]" && git push'

# I'm currently working on a gitx command which will allow for faster git related operations
# Fun and utterly useless aliases

alias whoami='whoami | cowsay'
alias fortune='fortune | cowsay'
alias train='sl' # Steam locomotive animation just goes through the terminal cause why not


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
export PS1="%F{214}%m%F{015} %F{039}%1~ %F{007}%% %F{015}"

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

# Fuzzy finder
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
# Fuck command for correcting mistakes
eval $(thefuck --alias)

#############################################################
### MISC


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
setopt EXTENDED_HISTORY
setopt HIST_IGNORE_ALL_DUPS


