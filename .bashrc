# ==============================
# PATH order
# ==============================
export PATH="$HOME/bin:$HOME/.local/bin:$PATH"
export PATH="/opt/homebrew/bin:$PATH" #Prefer homebrew to system path
export PATH="/opt/homebrew/opt/llvm/bin:$PATH"
export PATH="/opt/homebrew/opt/llvm/bin:$PATH" #MacTeX binaries

# GNU make (from Homebrew)
HOMEBREW_GNU_MAKE="$(brew --prefix)/opt/make/libexec/gnubin"
[[ -d "$HOMEBREW_GNU_MAKE" ]] && export PATH="$HOMEBREW_GNU_MAKE:$PATH"

# Juliaup (auto-added)
case ":$PATH:" in
    *:"$HOME/.juliaup/bin":*) ;;
    *) export PATH="$HOME/.juliaup/bin${PATH:+:${PATH}}" ;;
esac

# pipx shims (global dev tools)
export PATH="$HOME/.local/bin:$PATH"


# ==============================
# Starship prompt
# ==============================
export STARSHIP_CONFIG="$HOME/dotfiles/starship/starship.toml"
eval "$(starship init bash)"


# ==============================
# Conda
# ==============================
if [[ -f "/opt/anaconda3/etc/profile.d/conda.sh" ]]; then
    . "/opt/anaconda3/etc/profile.d/conda.sh"
fi
# Keep base off by default
conda config --set auto_activate_base false


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
# LLVM (C/C++ Compiler)
# ==============================
# Ensure LLVM headers/libs available if you need them:

export LDFLAGS="-L/opt/homebrew/opt/llvm/lib"
export CPPFLAGS="-I/opt/homebrew/opt/llvm/include"


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


# Color files/dirs when listing
alias ls="gls --color=auto"
export LS_COLORS="\
di=36;1:\
ln=35;1:\
so=32;1:\
pi=33;1:\
ex=32;1:\
bd=34;46:\
cd=34;43:\
su=37;41:\
sg=30;43:\
tw=30;42:\
ow=34;42:\
*.tar=31:*.tgz=31:*.arj=31:*.taz=31:*.lzh=31:*.zip=31:*.z=31:*.Z=31:*.gz=31:*.bz2=31:*.xz=31:*.rar=31:*.7z=31:\
*.jpg=35:*.jpeg=35:*.gif=35:*.bmp=35:*.png=35:*.svg=35:*.pdf=35"



