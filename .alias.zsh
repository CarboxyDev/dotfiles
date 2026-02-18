alias ..='cd ..'
alias ...='cd ../../'
alias cp='cp -iv'
alias mv='mv -iv'
alias c='clear'
alias clear='echo -e "\033c"'
alias f='open .'
alias ls='eza --icons'
alias t='tree -L 2 -I "node_modules|.git|dist|build|.next"'
alias tf='tree -L 2 -d -I "node_modules|.git|dist|build|.next"'
alias ta='tree -a -L 2 -I "node_modules|.git|dist|build|.next"'
alias u='uvicorn main:backend_app --reload'
alias py='python3'
alias j='javac Main.java && java Main'
alias jc='javac'
alias zshrc='nvim ~/.zshrc'
alias aliases='nvim ~/.alias.zsh'
alias tmuxconf='nvim ~/.tmux.conf'
alias gitd='git diff'
alias gitdd='git diff --word-diff'
alias gitc='git diff --stat'
alias gitl='git log --pretty=format:"%h - %an, %ar : %s"'
alias gits='git status --renames'
ports() {
  echo "Active Listening Ports:"
  echo "PORT\tPID\tPROCESS\tSTATE" | column -t -s $'\t'
  lsof -iTCP -sTCP:LISTEN -n -P | awk 'NR>1 {split($9,a,":"); printf "%s\t%s\t%s\tLISTEN\n", a[2], $2, $1}' | sort -n | column -t -s $'\t'
}
alias p='ports'
alias pall='ps -u $USER'
alias vim='nvim'
alias diff='colordiff' 
alias ip='curl https://ipinfo.io/ip && echo "" && ipconfig getifaddr en0'

size() {
  local target="${1:-.}"
  local max_depth="${2:-1}"
  du -h -d "$max_depth" "$target" | /usr/bin/sort -rh | awk '{print $2 "\t" $1}' | column -t
}


dev() {
  if [ -f package.json ]; then
    if command -v pnpm >/dev/null && jq -e '.scripts.dev' package.json >/dev/null 2>&1; then pnpm dev
    elif command -v bun >/dev/null && jq -e '.scripts.dev' package.json >/dev/null 2>&1; then bun run dev
    else npm run dev
    fi
  else
    echo "No package.json"
  fi
}
alias n='dev'

rgg() {
  local pattern="$1"
  local extensions="${2:-ts,tsx,js,jsx,json}"

  if [ -z "$pattern" ]; then
    echo "Usage: rgc <pattern> [extensions]"
    echo "Default extensions: ts,tsx,js,jsx,json"
    return 1
  fi

  echo "Searching for '$pattern' in: $extensions"
  echo ""
  rg -n --type-add "code:*.{$extensions}" -t code "$pattern"
}

killport() {
  if [ -z "$1" ]; then
    echo "Usage: killport <port>"
    return 1
  fi
  lsof -ti:$1 | xargs kill -9
}
