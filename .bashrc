# NOTE: Bash is not my main terminal shell. I'm only using it for some bash scripting practice.
# Most of the stuff below has been copied from my ~/.zshrc file
echo "[!] Switched to BASH"
#############################################################
# ALIASES (Most of these are for personal use and based on my personal taste)

alias ..='cd ..'
alias ...='cd ../../'
alias back='cd - >> /dev/null'
alias cp='cp -iv'
alias mv='mv -v'
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
alias college='cd ~/College && open . && cd -'
alias screenshots='cd ~/Desktop/Screenshots && open . && cd -'
alias scripting='cd ~/Dev/Scripting'

alias github='echo "My github: https://github.com/CarboxyDev/" && open -a safari "https://github.com/CarboxyDev/"'


# Utilitity related aliases

alias sha='shasum -a 256'
alias diff='colordiff'
alias myip='curl https://ipinfo.io/ip && echo "" && ipconfig getifaddr en0'
alias gitupload='git add . && git commit -m "Minor changes [automated commit]" && git push'
# I'm currently working on a gitx command which will allow for faster git related operations

# Fun and utterly useless aliases

alias whoami='whoami | cowsay'
alias fortune='fortune | cowsay'
alias train='sl' # Steam locomotive animation just goes through the terminal cause why not


#############################################################
#############################################################

[ -f ~/.fzf.bash ] && source ~/.fzf.bash
eval $(thefuck --alias)
source ~/Configs/bash/gitx.sh

# Bash prompt
export PS1="\[\033[38;5;49m\]bash\[$(tput sgr0)\] \[$(tput sgr0)\]\[\033[38;5;39m\]\W\[$(tput sgr0)\] \\$ \[$(tput sgr0)\]"
