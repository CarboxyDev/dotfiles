export PATH=~/.npm-global/bin:$PATH
export PATH="/opt/homebrew/opt/make/libexec/gnubin:$PATH"
export PATH="/opt/homebrew/opt/openjdk/bin:$PATH"
export JAVA_HOME=`/usr/libexec/java_home`
export HOMEBREW_NO_AUTO_UPDATE=1
export BAT_THEME='zenburn'
PATH=~/.console-ninja/.bin:$PATH
export PNPM_HOME="/Users/arman/.npm-global"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
[ -f "/Users/arman/.ghcup/env" ] && . "/Users/arman/.ghcup/env" # ghcup-env
export PATH="/Users/arman/.cargo/bin:$PATH"


source ~/Configs/zsh/todo.zsh
source ~/Configs/zsh/zsh-z.plugin.zsh
source ~/Configs/zsh/script.zsh
source ~/Configs/bash/gitx.sh
source ~/Configs/bash/extra.sh
source ~/Configs/zsh/time-tracker.sh
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh






# -----------------------------------------------------------------
# -----------------------------------------------------------------
# -----------------------------------------------------------------
# -----------------------------------------------------------------
# --------------------------- OH MY ZSH ---------------------------
# -----------------------------------------------------------------
# -----------------------------------------------------------------
# -----------------------------------------------------------------
# -----------------------------------------------------------------
# -----------------------------------------------------------------


# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"


# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"


# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git zsh-autosuggestions)

source $ZSH/oh-my-zsh.sh


# Source the other zsh files for the aliases and prompt
source ~/.alias.zsh
#source ~/.prompt.zsh

source $(dirname $(gem which colorls))/tab_complete.sh
eval "$(starship init zsh)"
