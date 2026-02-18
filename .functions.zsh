ports() {
  echo "Active Listening Ports:"
  echo "PORT\tPID\tPROCESS\tSTATE" | column -t -s $'\t'
  lsof -iTCP -sTCP:LISTEN -n -P | awk 'NR>1 {split($9,a,":"); printf "%s\t%s\t%s\tLISTEN\n", a[2], $2, $1}' | sort -n | column -t -s $'\t'
}

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

rgg() {
  local pattern="$1"
  local extensions="${2:-ts,tsx,js,jsx,json}"

  if [ -z "$pattern" ]; then
    echo "Usage: rgg <pattern> [extensions]"
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

extract() {
  if [ -z "$1" ] || [ ! -f "$1" ]; then
    echo "Usage: extract <file>"
    return 1
  fi
  case "$1" in
    *.tar.bz2) tar xjf "$1" ;;
    *.tar.gz)  tar xzf "$1" ;;
    *.tar.xz)  tar xJf "$1" ;;
    *.bz2)     bunzip2 "$1" ;;
    *.gz)      gunzip "$1" ;;
    *.tar)     tar xf "$1" ;;
    *.tbz2)    tar xjf "$1" ;;
    *.tgz)     tar xzf "$1" ;;
    *.zip)     unzip "$1" ;;
    *.7z)      7z x "$1" ;;
    *.rar)     unrar x "$1" ;;
    *.zst)     unzstd "$1" ;;
    *)         echo "'$1' cannot be extracted" ;;
  esac
}

run() {
  emulate -L zsh
  setopt NO_NOMATCH

  local all=0
  if [[ "$1" == "--all" || "$1" == "-a" ]]; then
    all=1
    shift
  fi

  local -a all_cpp
  all_cpp=("${(@f)$(command find . -type f \( -name '*.cpp' -o -name '*.cc' -o -name '*.cxx' \) \
            -not -path '*/build/*' -not -path '*/.git/*' -not -path '*/cmake-*/*' 2>/dev/null)}")

  local src="$1"
  if [[ -z "$src" ]]; then
    if command -v fzf >/dev/null 2>&1 && (( ${#all_cpp[@]} > 0 )); then
      src=$(printf '%s\n' "${all_cpp[@]}" | \
            fzf --prompt='Select C++ file ▶ ' \
                --height=80% --reverse \
                --preview 'bat --style=numbers --color=always --line-range=:200 {} 2>/dev/null || sed -n "1,200p" {}')
      [[ -z "$src" ]] && { echo "No file selected."; return 1; }
    else
      if (( ${#all_cpp[@]} == 0 )); then
        echo "No .cpp files found."; return 1
      fi
      src=$(ls -t -- "${all_cpp[@]}" | head -n1)
      echo "No file given; using most recent: $src"
    fi
  fi

  if [[ "$src" != *.* ]]; then
    src="$src.cpp"
  fi
  if [[ ! -f "$src" ]]; then
    echo "File not found: $src"; return 1
  fi

  local -a files
  if (( all )); then
    files=("${all_cpp[@]}")
    echo "Compiling ALL sources (${#files[@]} files)…"
  else
    files=("$src")
    echo "Compiling: $src"
  fi

  local base="${${src:t}%.*}"
  local out="/tmp/${base}.out"

  clang++ -std=c++23 -Wall -Wextra -O2 "${files[@]}" -o "$out" \
    && "$out" "${@:2}"
}

runall() { run --all "$@"; }

function accept-line-or-clear() {
  if [[ -z $BUFFER ]]; then
    clear
    zle reset-prompt
  else
    zle .accept-line
  fi
}

zle -N accept-line-or-clear
bindkey '^M' accept-line-or-clear
