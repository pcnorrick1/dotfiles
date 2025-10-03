# ==============================
# PATH
# ==============================
export PATH="$HOME/bin:$HOME/.local/bin:$PATH"

# Homebrew GNU make
HOMEBREW_GNU_MAKE="$(brew --prefix)/opt/make/libexec/gnubin"
[[ -d "$HOMEBREW_GNU_MAKE" ]] && export PATH="$HOMEBREW_GNU_MAKE:$PATH"

# TeX
[[ -d "/Library/TeX/texbin" ]] && export PATH="/Library/TeX/texbin:$PATH"

# ==============================
# Juliaup (was auto-inserted by juliaup)
# ==============================
case ":$PATH:" in
    *:"$HOME/.juliaup/bin":*) ;;
    *) export PATH="$HOME/.juliaup/bin${PATH:+:${PATH}}" ;;
esac

# ==============================
# Starship prompt (same look as zsh)
# ==============================
export STARSHIP_CONFIG="$HOME/dotfiles/starship/starship.toml"
eval "$(starship init bash)"


# ==============================
# Conda (migrated from conda init)
# ==============================
if [[ -f "/opt/anaconda3/etc/profile.d/conda.sh" ]]; then
    . "/opt/anaconda3/etc/profile.d/conda.sh"
else
    export PATH="/opt/anaconda3/bin:$PATH"
fi
# To keep base off by default:
conda config --set auto_activate false

# ==============================
# Completions / Tools
# ==============================
# Bash completion
[[ -r /opt/homebrew/etc/profile.d/bash_completion.sh ]] && \
  . /opt/homebrew/etc/profile.d/bash_completion.sh

# fzf keybindings/history search
[[ -f ~/.fzf.bash ]] && . ~/.fzf.bash

# autojump
[[ -r /opt/homebrew/etc/profile.d/autojump.sh ]] && \
  . /opt/homebrew/etc/profile.d/autojump.sh

# ==============================
# Aliases & functions
# ==============================
[[ -f "$HOME/dotfiles/aliases.sh" ]] && . "$HOME/dotfiles/aliases.sh"

# ==============================
# Neofetch banner (interactive shells only)
# ==============================
case $- in
  *i*) command -v neofetch >/dev/null && neofetch ;;
esac
