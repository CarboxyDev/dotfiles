# ===============================
# Environment Variables
# ===============================
export HOMEBREW_NO_AUTO_UPDATE=1
export BAT_THEME='zenburn'
export EDITOR="cursor -w"
export JAVA_HOME=$(/usr/libexec/java_home 2>/dev/null)
export GEM_HOME="$HOME/.gem"
export BUN_INSTALL="$HOME/.bun"
export ZSH="$HOME/.oh-my-zsh"

# ===============================
# PATH Management
# ===============================
typeset -U path
path=(
  ~/.npm-global/bin
  /opt/homebrew/opt/make/libexec/gnubin
  /opt/homebrew/opt/openjdk/bin
  /opt/homebrew/opt/llvm/bin
  ~/.cargo/bin
  ~/.codeium/windsurf/bin
  ~/.console-ninja/.bin
  "$BUN_INSTALL/bin"
  ~/go/bin
  $path
)

# ===============================
# History Configuration
# ===============================
HISTFILE=~/.zsh_history
HISTSIZE=50000
SAVEHIST=50000
setopt EXTENDED_HISTORY          # Write timestamp
setopt SHARE_HISTORY             # Share between sessions (implies immediate write)
setopt HIST_IGNORE_ALL_DUPS      # Remove older duplicate entries
setopt HIST_IGNORE_SPACE         # Ignore commands starting with space
setopt HIST_REDUCE_BLANKS        # Remove superfluous blanks

# ===============================
# Oh-My-Zsh Configuration
# ===============================
plugins=(git zsh-autosuggestions zsh-syntax-highlighting)
source $ZSH/oh-my-zsh.sh

# ===============================
# Tool Initialization
# ===============================

# Enable corepack for pnpm/yarn (fast, no nvm needed)
export NVM_DIR="$HOME/.nvm"
if [ -d "$NVM_DIR/versions/node" ]; then
  # Resolve nvm default alias dynamically
  _nvm_version=$(cat "$NVM_DIR/alias/default" 2>/dev/null || echo "")
  while [[ "$_nvm_version" == lts/* ]] || [[ "$_nvm_version" =~ ^[a-z]+$ ]]; do
    _nvm_version=$(cat "$NVM_DIR/alias/$_nvm_version" 2>/dev/null || echo "")
  done

  # Fallback to most recent node version if alias resolution fails
  if [ -z "$_nvm_version" ] || [ ! -d "$NVM_DIR/versions/node/$_nvm_version" ]; then
    _nvm_version=$(command ls -t "$NVM_DIR/versions/node" 2>/dev/null | head -n1)
  fi

  if [ -n "$_nvm_version" ] && [ -d "$NVM_DIR/versions/node/$_nvm_version/bin" ]; then
    path=("$NVM_DIR/versions/node/$_nvm_version/bin" $path)
  fi
  unset _nvm_version
fi

nvm() {
  unset -f nvm node npm npx
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
  nvm "$@"
}
node() { nvm >/dev/null 2>&1; command node "$@"; }
npm() { nvm >/dev/null 2>&1; command npm "$@"; }
npx() { nvm >/dev/null 2>&1; command npx "$@"; }

if command -v rbenv >/dev/null 2>&1; then
  rbenv() {
    unset -f rbenv ruby gem bundle
    eval "$(command rbenv init - zsh)"
    rbenv "$@"
  }
  ruby() { rbenv >/dev/null 2>&1; command ruby "$@"; }
  gem() { rbenv >/dev/null 2>&1; command gem "$@"; }
  bundle() { rbenv >/dev/null 2>&1; command bundle "$@"; }
fi

conda() {
  unset -f conda python python3 pip pip3
  __conda_setup="$('/opt/homebrew/Caskroom/miniconda/base/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
  if [ $? -eq 0 ]; then
      eval "$__conda_setup"
  else
      if [ -f "/opt/homebrew/Caskroom/miniconda/base/etc/profile.d/conda.sh" ]; then
          . "/opt/homebrew/Caskroom/miniconda/base/etc/profile.d/conda.sh"
      else
          export PATH="/opt/homebrew/Caskroom/miniconda/base/bin:$PATH"
      fi
  fi
  unset __conda_setup
  conda "$@"
}
unalias python python3 pip pip3 2>/dev/null
python() { conda >/dev/null 2>&1; command python "$@"; }
python3() { conda >/dev/null 2>&1; command python3 "$@"; }
pip() { conda >/dev/null 2>&1; command pip "$@"; }
pip3() { conda >/dev/null 2>&1; command pip3 "$@"; }

if command -v starship >/dev/null 2>&1; then
  eval "$(starship init zsh)"
fi

# ===============================
# External Sources
# ===============================
[[ -f "$HOME/.ghcup/env" ]] && source "$HOME/.ghcup/env"
[[ -f ~/dotfiles/zsh-z.plugin.zsh ]] && source ~/dotfiles/zsh-z.plugin.zsh
[[ -f ~/dotfiles/gitx.sh ]] && source ~/dotfiles/gitx.sh
[[ -f ~/.fzf.zsh ]] && source ~/.fzf.zsh
[[ -f ~/.alias.zsh ]] && source ~/.alias.zsh
[[ -f ~/.functions.zsh ]] && source ~/.functions.zsh
[[ -s "$HOME/.bun/_bun" ]] && source "$HOME/.bun/_bun"

# Colorls tab completion (glob avoids triggering gem/rbenv lazy-load)
for _colorls_tab in ~/.gem/ruby/*/gems/colorls-*/lib/tab_complete.sh(N); do
  source "$_colorls_tab" && break
done
unset _colorls_tab

# ===============================
# Custom Functions
# ===============================

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
bindkey '^M' accept-line-or-clear   # Enter key
