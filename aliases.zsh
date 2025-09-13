# ==============================
# General Aliases
# ==============================
alias ll="ls -lah"
alias la="ls -A"
alias l="ls -CF"

alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."

alias zshconfig="code ~/.zshrc"
alias ohmyzsh="code ~/.oh-my-zsh"

# ==============================
# Git Shortcuts
# ==============================
alias gst="git status"
alias gco="git checkout"
alias gcb="git checkout -b"
alias gcm="git commit -m"
alias gp="git push"
alias gl="git pull"
alias gd="git diff"
alias gpo="git push origin"
alias gbr="git branch"
alias gmt="git mergetool"

# ==============================
# Conda / Python Shortcuts
# ==============================
alias cenv="conda env list"
alias act="conda activate"
alias deact="conda deactivate"
alias py="python3"
alias ipy="ipython"
alias jn="jupyter notebook"
alias jl="jupyter lab"

# ==============================
# Julia Shortcuts
# ==============================
alias ju="julia"
alias jup="juliaup update"
alias jpkg="julia -e 'using Pkg; Pkg.status()'"

# ==============================
# LaTeX / TeX Shortcuts
# ==============================
alias latexmk="latexmk -pdf -interaction=nonstopmode -file-line-error"
alias pdflatex="pdflatex -synctex=1"

# ==============================
# Homebrew Shortcuts
# ==============================
alias brewu="brew update && brew upgrade && brew cleanup"
alias brewi="brew install"
alias brewup="brew upgrade"

# ==============================
# Misc Productivity
# ==============================
alias edit="code ."
alias h="history"
alias reload="source ~/.zshrc"
alias mkdircd='foo(){ mkdir -p "$1"; cd "$1"; }; foo'
