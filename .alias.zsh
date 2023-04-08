###########################################################
###################### A L I A S E S ######################
###########################################################

alias ..='cd ..'
alias ...='cd ../../'
alias cp='cp -iv'
alias mv='mv -iv'
alias c='clear'
alias f='open .'
alias ls='exa'
alias top='btop'
alias ping='ping -c 3'
alias g++='g++ -std=c++17'
alias python='python3.9'
alias py='python3.9'
alias j='javac Main.java && java Main'
alias jc='javac'
alias a='make a && ./a'
alias finder='open .'
alias apps='cd /Applications && open . && cd -'
alias zshrc='vim ~/.zshrc'
alias aliases='vim ~/.alias.zsh'
alias g='cd ~/Github'
alias github='cd ~/Github'
alias gitd='git diff'
alias gitc='git diff --stat'
alias gitl='git log --oneline'

# Utilitity related aliases

alias diff='colordiff' # requires colordiff 
alias ip='curl https://ipinfo.io/ip && echo "" && ipconfig getifaddr en0'

# Useless and fun aliases
alias whoami='whoami | cowsay'
