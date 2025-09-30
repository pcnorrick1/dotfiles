# ==============================
# Oh My Zsh
# ==============================
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"

# Custom directory for plugins, themes, and aliases
export ZSH_CUSTOM="$ZSH/custom"

# Plugins
plugins=(
  git
)

# Load Oh My Zsh
source $ZSH/oh-my-zsh.sh

# ==============================
# PATH Modifications
# ==============================
export PATH="$HOME/bin:$HOME/.local/bin:$PATH"

# Homebrew GNU make
HOMEBREW_GNU_MAKE="$(brew --prefix)/opt/make/libexec/gnubin"
[ -d "$HOMEBREW_GNU_MAKE" ] && export PATH="$HOMEBREW_GNU_MAKE:$PATH"

# Juliaup binaries
JULIAUP_BIN="$HOME/.juliaup/bin"
[ -d "$JULIAUP_BIN" ] && export PATH="$JULIAUP_BIN:$PATH"

# TeX binaries
[ -d "/Library/TeX/texbin" ] && export PATH="/Library/TeX/texbin:$PATH"

# Conda will append itself below

# ==============================
# Starship prompt
# ==============================
eval "$(starship init zsh)"
export STARSHIP_CONFIG=~/dotfiles/starship/starship.toml

# ==============================
# Conda
# ==============================
# Managed by 'conda init'
__conda_setup="$('/opt/anaconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/opt/anaconda3/etc/profile.d/conda.sh" ]; then
        . "/opt/anaconda3/etc/profile.d/conda.sh"
    else
        export PATH="/opt/anaconda3/bin:$PATH"
    fi
fi
unset __conda_setup

# ==============================
# Aliases
# ==============================
# Load custom aliases from $ZSH_CUSTOM
[ -f "$ZSH_CUSTOM/aliases.zsh" ] && source "$ZSH_CUSTOM/aliases.zsh"


# ==============================
# Oh My Zsh Homebrew Plugins
# ==============================
# zsh-syntax-highlighting
[ -f /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ] && \
    source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# zsh-autosuggestions
[ -f /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh ] && \
    source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# autojump
[ -f /opt/homebrew/etc/profile.d/autojump.sh ] && \
    source /opt/homebrew/etc/profile.d/autojump.sh

neofetch
# ==============================
# Optional Settings
# ==============================
# Uncomment to enable command correction
# ENABLE_CORRECTION="true"

# Uncomment to disable untracked files dirty check (speed up git prompts)
# DISABLE_UNTRACKED_FILES_DIRTY="true"
