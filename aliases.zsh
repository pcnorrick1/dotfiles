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
alias glog="git log --oneline --graph --decorate --all"

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
alias mkvenv="conda create -n"

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

# ==============================
# Academia Workflow Shortcuts
# ==============================
alias tidy="make -f ~/bin/Makefile.tidy tidy"   # daily cleanup
alias snapshot="snapshot-academia"              # snapshot backups
alias links="check-links ~/academia"            # check symlinks
alias normbox="normalize-names ~/inbox"         # force inbox normalization

# Paper handling
alias addpaper="normalize-names ~/inbox && mv ~/inbox/*.pdf ~/academia/library/papers/incoming/"
alias papers="cd ~/academia/library/papers/by-author"

# Quick navigation
alias acad="cd ~/academia"
alias pers="cd ~/personal"
alias notes="cd ~/academia/notes"
alias courses="cd ~/academia/courses"
alias projects="cd ~/academia/projects"
alias cv="cd ~/academia/admin/cv/current"

# LaTeX helpers
alias build="make"
alias makeclean="make clean"
alias cptex='cp ~/academia/templates/latex/notes.tex ~/academia/templates/latex/refs.bib .' #Copy LaTeX and BibTeX templates to current directory

# Removes LaTeX junk but keeps PDFs
alias cleantex="cleanup-tex"

# Scaffolding
alias newcourse="new-course"
alias newproj="new-research"

# Structure overview
alias struct="print-structure"
