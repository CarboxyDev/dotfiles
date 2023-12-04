# Source the other zsh files for the aliases and prompt

source ~/.alias.zsh
source ~/.prompt.zsh


# Add Auto complete functionality

autoload -Uz compinit
compinit
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' menu select

# Export global OS environment variables

export PATH=~/.npm-global/bin:$PATH
export PATH="/opt/homebrew/opt/make/libexec/gnubin:$PATH"
export PATH="/opt/homebrew/opt/openjdk/bin:$PATH"
export JAVA_HOME=`/usr/libexec/java_home`
export HOMEBREW_NO_AUTO_UPDATE=1
# Source the miscellanous zsh files

source ~/Configs/zsh/zsh-z.plugin.zsh
source ~/Configs/zsh/script.zsh

source ~/Configs/bash/gitx.sh
source ~/Configs/bash/extra.sh
source ~/Configs/zsh/time-tracker.sh

# Add fuzzy finder
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh


# Miscellanous stuff

iterm_tab_title() {
  echo -ne "\e]0;${PWD##*/}\a"
}
add-zsh-hook precmd iterm_tab_title


# Maintains zsh history

export HISTFILE=~/.zsh_history
export HISTFILESIZE=1000000
export HISTSIZE=1000000
export SAVEHIST=$HISTSIZE

setopt INC_APPEND_HISTORY

# For Github Copilot CLI
eval "$(github-copilot-cli alias -- "$0")"

# bun completions
[ -s "/Users/arman/.bun/_bun" ] && source "/Users/arman/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# pnpm
export PNPM_HOME="/Users/arman/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end
#
#export ZSH_AUTOSUGGEST_COMPLETION_IGNORE="*"
bindkey '\t\t' autosuggest-accept
source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
