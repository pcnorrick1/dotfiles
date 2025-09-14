#!/usr/bin/env bash
# ============================================================
# MacBook Academia/Personal Filesystem Bootstrap
# ============================================================
# Creates clean directory tree, installs bin helpers,
# sets up CV/Resume scaffolding, and drop-in automation.
#
# Run once on a new machine:
#   bash ~/dotfiles/setup_filesystem.sh
# ============================================================

set -euo pipefail
IFS=$'\n\t'

# --------------------------
# Base directories
# --------------------------
ACA="$HOME/academia"
PER="$HOME/personal"
BIN="$HOME/bin"
INBOX="$HOME/inbox"
BACKUPS="$HOME/backups/local"
SCRATCH="$HOME/scratch"
LAUNCHD="$HOME/Library/LaunchAgents"

mkdir -p "$ACA" "$PER" "$BIN" "$INBOX" "$BACKUPS" "$SCRATCH" "$LAUNCHD"

# --------------------------
# Academia structure
# --------------------------
mkdir -p "$ACA"/{courses,projects,notes,templates,admin,applications}
mkdir -p "$ACA"/library/{papers/{incoming,by-author},textbooks,datasets/{raw,processed,external,interim}}

# Personal
mkdir -p "$PER"/{projects,notes,admin,archive}

# --------------------------
# STRUCTURE.md (documentation)
# --------------------------
cat > "$ACA/STRUCTURE.md" <<'EOF'
# Filesystem Structure & Conventions

**Naming**
- all lowercase
- kebab-case (dashes) for multiword names
- ISO dates for time-ordered files: `YYYY-MM-DD-*`
- version suffix like `-v01` before extension

**Top-level**
- ~/academia/ (courses, projects, notes, library, templates, admin, applications)
- ~/personal/ (projects, notes, admin, archive)
- ~/inbox/ (default browser downloads)
- ~/bin/ (scripts)
- ~/backups/local/ (manual snapshots)
- ~/scratch/ (throwaway)

**Library & Symlinks**
- Canonical PDFs live in `academia/library/papers` and `textbooks`.
- Courses/projects should symlink resources into local `references/` folder.
- Use `slink <target>` to create relative symlinks.
- Check integrity with `check-links`.

**Course scaffold**
- `new-course 2026-fall econ-701 macro-i`
- Creates syllabus/, lectures/, assignments/, exams/, code/, tex/, notes/, references/.

**Research scaffold**
- `new-research heterogeneous-agents --lang both --git`
- Creates data/, notebooks/, src/, reports/, references/, results/, figures/, docs/.
- Adds Python `environment.yml` and/or Julia `Project.toml` + package skeleton.

EOF

# --------------------------
# Templates
# --------------------------
mkdir -p "$ACA/templates/latex"
cat > "$ACA/templates/latex/notes.tex" <<'EOF'
\documentclass[11pt]{article}
\usepackage[margin=1in]{geometry}
\usepackage{amsmath,amssymb,mathtools}
\usepackage{hyperref}
\title{Course Notes}
\author{Patrick}
\date{\today}
\begin{document}
\maketitle
\section*{Session Title}
% your notes
\end{document}
EOF

# Generic LaTeX Makefile
cat > "$ACA/templates/latex/Makefile" <<'EOF'
LATEX = latexmk
TEXFLAGS = -pdf -interaction=nonstopmode -file-line-error -synctex=1

all: notes.pdf

notes.pdf: notes.tex
	$(LATEX) $(TEXFLAGS) notes.tex

clean:
	$(LATEX) -C

.PHONY: all clean
EOF

# Generic .gitignore
cat > "$ACA/templates/.gitignore" <<'EOF'
.DS_Store
*.swp
__pycache__/
*.pyc
.venv/
Manifest.toml
*.aux
*.log
*.out
*.toc
*.synctex*
*.fls
*.fdb_latexmk
*.ipynb_checkpoints/
results/
EOF

# --------------------------
# CV scaffolding
# --------------------------
CV="$ACA/admin/cv"
mkdir -p "$CV"/{current,archive,templates}

cat > "$CV/current/cv.tex" <<'EOF'
\documentclass[11pt]{article}
\usepackage[margin=1in]{geometry}
\begin{document}
\section*{Curriculum Vitae}
Patrick
\end{document}
EOF

cat > "$CV/current/Makefile" <<'EOF'
LATEX = latexmk
TEXFLAGS = -pdf -interaction=nonstopmode -file-line-error -synctex=1

all: cv.pdf
cv.pdf: cv.tex
	$(LATEX) $(TEXFLAGS) cv.tex

clean:
	$(LATEX) -C
.PHONY: all clean
EOF

ln -sfn "$CV/current/cv.pdf" "$CV/cv.pdf"

# --------------------------
# BIN HELPERS
# --------------------------
# _helpers.sh: slugify + relpath
cat > "$BIN/_helpers.sh" <<'EOF'
#!/usr/bin/env bash
set -euo pipefail
slugify() {
  local s="${1,,}"
  if command -v iconv >/dev/null 2>&1; then
    s="$(printf '%s' "$s" | iconv -f UTF-8 -t ASCII//TRANSLIT 2>/dev/null || printf '%s' "$s")"
  fi
  s="${s// /-}"
  s="$(printf '%s' "$s" | sed -E 's/[^a-z0-9._-]+/-/g; s/-+/-/g; s/^-|-$//g')"
  printf '%s' "$s"
}
relpath() {
  python3 - "$1" "$2" <<'PY'
import os,sys
target, base = sys.argv[1], sys.argv[2]
print(os.path.relpath(target, start=base))
PY
}
EOF
chmod +x "$BIN/_helpers.sh"

# slink: safe relative symlink
cat > "$BIN/slink" <<'EOF'
#!/usr/bin/env bash
set -euo pipefail
. "$HOME/bin/_helpers.sh"
target="$(cd "$(dirname "$1")" && pwd)/$(basename "$1")"
link="${2:-$(basename "$target")}"
link_dir="$(pwd)"
rel="$(relpath "$target" "$link_dir" 2>/dev/null || true)"
: "${rel:=$target}"
ln -sfn "$rel" "$link"
EOF
chmod +x "$BIN/slink"

# lslinks
cat > "$BIN/lslinks" <<'EOF'
#!/usr/bin/env bash
set -euo pipefail
dir="${1:-.}"
find "$dir" -type l -exec ls -l {} +
EOF
chmod +x "$BIN/lslinks"

# normalize-names
cat > "$BIN/normalize-names" <<'EOF'
#!/usr/bin/env bash
set -euo pipefail
. "$HOME/bin/_helpers.sh"
dir="${1:-$HOME/inbox}"
cd "$dir"
for f in *; do
  [ -f "$f" ] || continue
  base="${f%.*}"; ext="${f##*.}"
  [[ "$f" == "$ext" ]] && ext=""
  newbase="$(slugify "$base")"
  newname="$newbase${ext:+.$ext}"
  if [[ "$newname" != "$f" ]]; then
    mv -n "$f" "$newname"
    echo "$f -> $newname"
  fi
done
EOF
chmod +x "$BIN/normalize-names"

# check-links
cat > "$BIN/check-links" <<'EOF'
#!/usr/bin/env bash
set -euo pipefail
root="${1:-$HOME/academia}"
find "$root" -type l ! -exec test -e {} \; -print
EOF
chmod +x "$BIN/check-links"

# dedup-pdfs
cat > "$BIN/dedup-pdfs" <<'EOF'
#!/usr/bin/env bash
set -euo pipefail
dir="${1:-$HOME/academia/library/papers}"
declare -A seen
while IFS= read -r -d '' f; do
  sum="$(shasum "$f" | awk '{print $1}')"
  if [[ -n "${seen[$sum]:-}" ]]; then
    echo "Duplicate: $f == ${seen[$sum]}"
  else
    seen[$sum]="$f"
  fi
done < <(find "$dir" -type f -iname '*.pdf' -print0)
EOF
chmod +x "$BIN/dedup-pdfs"

# cleanup-tex
cat > "$BIN/cleanup-tex" <<'EOF'
#!/usr/bin/env bash
set -euo pipefail
root="${1:-.}"
find "$root" -type f \( -name "*.aux" -o -name "*.log" -o -name "*.out" -o -name "*.toc" -o -name "*.synctex*" -o -name "*.fls" -o -name "*.fdb_latexmk" \) -delete
EOF
chmod +x "$BIN/cleanup-tex"

# archive-old
cat > "$BIN/archive-old" <<'EOF'
#!/usr/bin/env bash
set -euo pipefail
dir="${1:-$HOME/inbox}"
days="${2:-30}"
dest="$dir/archive"
mkdir -p "$dest"
find "$dir" -maxdepth 1 -type f -mtime +$days -exec mv {} "$dest"/ \;
EOF
chmod +x "$BIN/archive-old"

# snapshot-academia
cat > "$BIN/snapshot-academia" <<'EOF'
#!/usr/bin/env bash
set -euo pipefail
TS="$(date +%Y%m%d-%H%M%S)"
DEST="$HOME/backups/local/$TS"
mkdir -p "$DEST"
rsync -a --delete --exclude '.git' --exclude '.venv' --exclude 'Manifest.toml' "$HOME/academia/" "$DEST/academia/"
rsync -a --delete "$HOME/personal/" "$DEST/personal/"
ln -sfn "$DEST" "$HOME/backups/local/latest"
echo "snapshot -> $DEST"
EOF
chmod +x "$BIN/snapshot-academia"

# new-course
cat > "$BIN/new-course" <<'EOF'
#!/usr/bin/env bash
set -euo pipefail
. "$HOME/bin/_helpers.sh"
term="$(slugify "$1")"; code="$(slugify "$2")"; shift 2
name="$(slugify "$*")"
slug="$term-$code${name:+-$name}"
root="$HOME/academia/courses/$slug"
mkdir -p "$root"/{syllabus,lectures,assignments,exams,code/{python,julia},tex,notes,references}
cp -n "$HOME/academia/templates/latex/notes.tex" "$root/tex/notes.tex"
cp -n "$HOME/academia/templates/latex/Makefile" "$root/tex/Makefile"
cp -n "$HOME/academia/templates/.gitignore" "$root/.gitignore"
EOF
chmod +x "$BIN/new-course"

# new-research
cat > "$BIN/new-research" <<'EOF'
#!/usr/bin/env bash
set -euo pipefail
. "$HOME/bin/_helpers.sh"
lang="both"; gitinit="no"; name=""
while [[ $# -gt 0 ]]; do
  case "$1" in
    --lang) lang="$2"; shift 2;;
    --git) gitinit="yes"; shift;;
    *) name="$name $1"; shift;;
  esac
done
slug="$(slugify "$name")"
root="$HOME/academia/projects/$slug"
mkdir -p "$root"/{data/{raw,processed,external,interim},src,notebooks,reports,figures,results,references,docs}
cp -n "$HOME/academia/templates/.gitignore" "$root/.gitignore"

# Python env
if [[ "$lang" == "python" || "$lang" == "both" ]]; then
cat > "$root/environment.yml" <<PY
name: $slug
channels:
  - conda-forge
dependencies:
  - python>=3.11
  - numpy
  - pandas
  - matplotlib
  - jupyter
PY
fi

# Julia package skeleton
if [[ "$lang" == "julia" || "$lang" == "both" ]]; then
pkgname="$(echo "$slug" | sed -E 's/(^|-)([a-z])/\U\2/g')"
cat > "$root/Project.toml" <<JL
name = "$pkgname"
uuid = "00000000-0000-0000-0000-000000000000"
authors = ["Patrick"]
version = "0.1.0"
JL
mkdir -p "$root/src"
cat > "$root/src/$pkgname.jl" <<JL
module $pkgname

greet() = println("Hello from $pkgname.jl")

end # module
JL
fi

# LaTeX reports scaffold
mkdir -p "$root/reports"
cp -n "$HOME/academia/templates/latex/Makefile" "$root/reports/Makefile"

# git init
if [[ "$gitinit" == "yes" ]]; then
  (cd "$root" && git init -q && git add . && git commit -m "init $slug" >/dev/null)
fi
EOF
chmod +x "$BIN/new-research"

# print-structure
cat > "$BIN/print-structure" <<'EOF'
#!/usr/bin/env bash
if command -v tree >/dev/null; then
  tree -a -L 3 --noreport "$HOME/academia" "$HOME/personal"
else
  find "$HOME/academia" -maxdepth 3 -print
  find "$HOME/personal" -maxdepth 3 -print
fi
EOF
chmod +x "$BIN/print-structure"

# --------------------------
# Launchd job for inbox normalization (WatchPaths)
# --------------------------
PLIST="$LAUNCHD/com.user.inbox-normalize.plist"
cat > "$PLIST" <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN"
 "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>Label</key>
  <string>com.user.inbox-normalize</string>
  <key>ProgramArguments</key>
  <array>
    <string>$HOME/bin/normalize-names</string>
    <string>$HOME/inbox</string>
  </array>
  <key>WatchPaths</key>
  <array>
    <string>$HOME/inbox</string>
  </array>
  <key>StandardOutPath</key>
  <string>$HOME/inbox/.normalize.log</string>
  <key>StandardErrorPath</key>
  <string>$HOME/inbox/.normalize.err</string>
</dict>
</plist>
EOF

echo "✅ Setup complete. Add 'export PATH=\"$HOME/bin:\$PATH\"' to your ~/.zshrc if not already present."
echo "➡ Enable inbox watcher: launchctl load $PLIST"
