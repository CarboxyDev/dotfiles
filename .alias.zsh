#############################################################
# ALIASES (Most of these are for personal use and based on my personal taste)

# Some commands are mac only (Especially ones using the open command)

alias ..='cd ..'
alias ...='cd ../../'
alias back='cd - >> /dev/null'
alias cp='cp -iv'
alias mv='mv -iv'
alias c='clear'
alias b='bat'
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
alias vim='nvim'
# Utilitity related aliases

alias diff='colordiff' # requires colordiff 
alias ip='curl https://ipinfo.io/ip && echo "" && ipconfig getifaddr en0'

# Fun and utterly useless aliases

alias whoami='whoami | cowsay'

# Temporary aliases go here
alias upload='curl bashupload.com -T'
