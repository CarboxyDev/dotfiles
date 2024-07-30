#alias .='ls'
alias ..='cd ..'
alias ...='cd ../../'
alias cp='cp -iv'
alias mv='mv -iv'
alias c='clear'
alias clear='echo -e "\033c"'
alias b='cd -'
alias f='open .'
alias l='ls'
alias ls='exa --icons'
alias lsa='ls -a'
alias t='tree -L 2'
alias tf='tree -L 2 -d'
alias n='npm run dev' # Run a nextjs dev server
alias python='python3.9'
alias py='python3.9'
alias j='javac Main.java && java Main'
alias jc='javac'
alias a='make a && ./a'
alias zshrc='nvim ~/.zshrc'
alias aliases='nvim ~/.alias.zsh'
alias tmuxconf='nvim ~/.tmux.conf'
alias g='gitc'
alias github='cd ~/Github'
alias gitd='git diff'
alias gitb='git branch'
alias gitc='git diff --stat'
alias gitl='git log --pretty=format:"%h - %an, %ar : %s"'
alias gita='git add --all'
alias gits='git status --renames'
alias size='du -ah'
alias dsa='z dsa && code .'
alias nnpm='npm'
alias p='ps -o pid,comm | column -t'
alias pall='ps -u $USER'
alias top='vtop'
alias vim='nvim'
alias diff='colordiff' # requires colordiff 
alias ip='curl https://ipinfo.io/ip && echo "" && ipconfig getifaddr en0'
alias ss='freeze' # requires freeze
