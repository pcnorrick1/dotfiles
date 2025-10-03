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
alias bashconfig="code ~/.bashrc"

# Reload whichever shell you are using
reload () {
  if [ -n "$ZSH_VERSION" ]; then source ~/.zshrc
  elif [ -n "$BASH_VERSION" ]; then source ~/.bashrc
  else exec "$SHELL"
  fi
}

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

# mkdir + cd as a function (portable)
mkdircd () { mkdir -p "$1" && cd "$1"; }

# ==============================
# Academia Workflow Shortcuts
# ==============================
alias tidy="make -f ~/bin/Makefile.tidy tidy"
alias snapshot="snapshot-academia"
alias links="check-links ~/academia"
alias normbox="normalize-names ~/inbox"
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
alias cptex='cp ~/academia/templates/latex/article.tex article.tex && slink ~/academia/library/master.bib refs.bib'
alias cleantex="cleanup-tex"

# Scaffolding
alias newcourse="new-course"
alias newproj="new-research"

# Structure overview
alias struct="print-structure"

# ==============================
# Obsidian
# ==============================
alias oo="cd ~/academia/notes"
