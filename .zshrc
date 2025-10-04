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

# Prefer Homebrew's bin over system bin
export PATH="/opt/homebrew/bin:$PATH"

# LLVM/clang
export PATH="/opt/homebrew/opt/llvm/bin:$PATH"

# TeX binaries
[ -d "/Library/TeX/texbin" ] && export PATH="/Library/TeX/texbin:$PATH"

# Homebrew GNU make
HOMEBREW_GNU_MAKE="$(brew --prefix)/opt/make/libexec/gnubin"
[ -d "$HOMEBREW_GNU_MAKE" ] && export PATH="$HOMEBREW_GNU_MAKE:$PATH"

# Juliaup binaries
JULIAUP_BIN="$HOME/.juliaup/bin"
[ -d "$JULIAUP_BIN" ] && export PATH="$JULIAUP_BIN:$PATH"

# pipx shims
export PATH="$HOME/.local/bin:$PATH"

# ==============================
# Starship prompt
# ==============================
export STARSHIP_CONFIG=~/dotfiles/starship/starship.toml
eval "$(starship init zsh)"


# ==============================
# Conda
# ==============================
__conda_setup="$('/opt/anaconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    [ -f "/opt/anaconda3/etc/profile.d/conda.sh" ] && \
        . "/opt/anaconda3/etc/profile.d/conda.sh"
fi
unset __conda_setup
conda config --set auto_activate_base false


# ==============================
# LLVM (C/C++ Compiler)
# ==============================
# Ensure LLVM headers/libs available if you need them:
export LDFLAGS="-L/opt/homebrew/opt/llvm/lib"
export CPPFLAGS="-I/opt/homebrew/opt/llvm/include"


# ==============================
# Aliases
# ==============================
[ -f ~/dotfiles/aliases.sh ] && source ~/dotfiles/aliases.sh


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

command -v neofetch >/dev/null && neofetch
