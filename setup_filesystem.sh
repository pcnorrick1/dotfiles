#!/usr/bin/env bash
# ============================================================
# MacBook Academia/Personal Filesystem Bootstrap
# ============================================================
# Creates clean directory tree, installs bin helpers
#
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
mkdir -p "$ACA"/library/{papers/{incoming,by-author},textbooks}

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
- ~/academia/ (courses, projects, notes, library, templates, admin)
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
- Creates syllabus/, lectures/, assignments/, exams/, tex/, notes/, references/.

**Research scaffold**
- `new-research heterogeneous-agents`
- Creates data/, src/, reports/, references/, results/, figures/.

EOF

# --------------------------
# Templates
# --------------------------
mkdir -p "$ACA/templates/latex"
cat > "$ACA/templates/latex/article.tex" <<'EOF'
\documentclass[11pt]{article}
\usepackage[margin=1in]{geometry}
\usepackage{amsmath,amssymb,mathtools}
\usepackage{hyperref}
\title{Article Title}
\author{Patrick Norrick}
\date{\today}

\begin{document}
\maketitle

\section{Introduction}
Text.
Example citation \cite{example}.

\bibliographystyle{plain}
\bibliography{refs}
\end{document}
EOF

# Generic ref.bib template
cat > "$ACA/templates/latex/refs.bib" <<'EOF'
@article{example,
  author  = {Doe, John and Smith, Jane},
  title   = {An Example Paper},
  journal = {Journal of Examples},
  year    = {2024},
  volume  = {1},
  number  = {1},
  pages   = {1--10}
}
EOF

# Beamer template
cat > "$ACA/templates/latex/beamer.tex" <<'EOF'
\documentclass{beamer}
\usetheme{default}
\title{Talk Title}
\author{Patrick Norrick}
\date{\today}
\begin{document}
\frame{\titlepage}
\begin{frame}{Slide}
Content.
\end{frame}
\end{document}
EOF


# Generic .gitignore
cat > "$ACA/templates/.gitignore" <<'EOF'
# OS/editor
.DS_Store
*.swp
*.swo
# Python
__pycache__/
*.pyc
.venv/
# Julia
Manifest.toml
# LaTeX
*.pdf
*.aux
*.log
*.out
*.toc
*.synctex*
*.fls
*.fdb_latexmk
# Notebooks
*.ipynb_checkpoints/
# Misc
results/
EOF

# --------------------------
# BIN HELPERS
# --------------------------
# _helpers.sh: slugify + relpath
#Slugify: turns a string into a filesystem-safe consistent format
#Relpath: computes relative path from one folder to another so symlinks don't break
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
#Finds relative path and creates a symlink, replacing existing if needed
cat > "$BIN/slink" <<'EOF'
#!/usr/bin/env bash
set -euo pipefail
. "$HOME/bin/_helpers.sh"
if [[ $# -lt 1 || $# -gt 2 ]]; then
  echo "usage: slink <target> [linkname]" >&2; exit 2
fi
target="$(cd "$(dirname "$1")" && pwd)/$(basename "$1")"
if [[ ! -e "$target" ]]; then echo "target does not exist: $target" >&2; exit 1; fi
link="${2:-$(basename "$target")}"
link_dir="$(pwd)"
rel="$(relpath "$target" "$link_dir" 2>/dev/null || true)"
: "${rel:=$target}"  # fallback absolute if python missing
ln -sfn "$rel" "$link"
echo "linked -> $link -> $rel"
EOF
chmod +x "$BIN/slink"

# lslinks
#List all symlinks in a directory
cat > "$BIN/lslinks" <<'EOF'
#!/usr/bin/env bash
set -euo pipefail
dir="${1:-.}"
find "$dir" -type l -exec ls -l {} +
EOF
chmod +x "$BIN/lslinks"

# normalize-names
#Cleans up filenames in a directory (primarily for ~/inbox/)
cat > "$BIN/normalize-names" <<'EOF'
#!/usr/bin/env bash
set -euo pipefail
. "$HOME/bin/_helpers.sh"

dir="${1:-$HOME/inbox}"

for f in "$dir"/*; do
  # skip if not a regular file
  [ -f "$f" ] || continue

  base="$(basename "$f")"
  ext="${base##*.}"
  name="${base%.*}"

  # normalize only if not already clean
  slug="$(slugify "$name").$ext"
  if [[ "$base" != "$slug" ]]; then
    newpath="$dir/$slug"
    if [ -e "$newpath" ]; then
      echo "Skipping $base → $slug (target exists)" >&2
    else
      mv "$f" "$newpath"
      echo "Renamed $base → $slug"
    fi
  fi
done
EOF
chmod +x "$BIN/normalize-names"

# check-links
# Check for broken symlinks
cat > "$BIN/check-links" <<'EOF'
#!/usr/bin/env bash
set -euo pipefail

root="${1:-$HOME/academia}"

echo "Scanning for broken symlinks under $root ..."
echo

broken=0
while IFS= read -r -d '' link; do
  target="$(readlink "$link")"
  echo "❌ $link -> $target"
  broken=$((broken+1))
done < <(find "$root" -type l ! -exec test -e {} \; -print0)

if [[ $broken -eq 0 ]]; then
  echo "✅ No broken links found."
else
  echo
  echo "Found $broken broken links."
  echo "Tip: recreate them with 'slink <target> [linkname]'"
fi
EOF
chmod +x "$BIN/check-links"

# dedup-pdfs
# Finds duplicate PDFs
cat > "$BIN/dedup-pdfs" <<'EOF'
#!/usr/bin/env bash
set -euo pipefail
dir="${1:-$HOME/academia/library/papers}"

echo "Scanning for duplicate PDFs in $dir ..."
echo

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
# Remove auxiliary LaTeX files
cat > "$BIN/cleanup-tex" <<'EOF'
#!/usr/bin/env bash
set -euo pipefail
root="${1:-.}"

echo "Cleaning LaTeX build artifacts under $root ..."

# Walk subdirectories
find "$root" -type d | while read -r dir; do
  # Only clean if the directory has at least one .tex file
  if compgen -G "$dir"/*.tex > /dev/null 2>&1; then
    find "$dir" -maxdepth 1 -type f \( \
      -name "*.aux" -o -name "*.log" -o -name "*.out" -o -name "*.toc" \
      -o -name "*.synctex*" -o -name "*.fls" -o -name "*.fdb_latexmk" \
    \) -delete
  fi
done

echo "✅ Done."
EOF
chmod +x "$BIN/cleanup-tex"

# archive-old
# Move files older than N days to archive subfolder
cat > "$BIN/archive-old" <<'EOF'
#!/usr/bin/env bash
set -euo pipefail
dir="${1:-$HOME/inbox}"
days="${2:-30}"
dest="$dir/archive"
mkdir -p "$dest"

echo "Archiving files older than $days days in $dir ..."
find "$dir" -maxdepth 1 -type f -mtime +$days -exec mv {} "$dest"/ \;
echo "✅ Archived into $dest"
EOF
chmod +x "$BIN/archive-old"

# snapshot-academia
# Create a timestamped snapshot of academia and personal
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
# Scaffold for a new course with consistent structure
cat > "$BIN/new-course" <<'EOF'
#!/usr/bin/env bash
set -euo pipefail
. "$HOME/bin/_helpers.sh"

if [[ $# -lt 2 ]]; then
  echo "Usage: new-course <term> <code> [name...]"
  exit 1
fi

term="$(slugify "$1")"; code="$(slugify "$2")"; shift 2
name="$(slugify "$*")"
slug="$term-$code${name:+-$name}"
root="$HOME/academia/courses/$slug"

if [[ -d "$root" ]]; then
  echo "Error: course $slug already exists at $root"
  exit 1
fi

mkdir -p "$root"/{syllabus,lectures,assignments,exams,tex,notes,references}

#LaTeX scaffolding
cp -n "$HOME/academia/templates/latex/article.tex" "$root/tex/notes.tex"
cp -n "$HOME/academia/templates/latex/refs.bib" "$root/tex/refs.bib"
cp -n "$HOME/academia/templates/.gitignore" "$root/.gitignore"

#README
cat > "$root/README.md" <<EOF2
# $slug

## shape
- \`syllabus/\`: syllabus and policies
- \`lectures/\`: dated lecture notes (\`YYYY-MM-DD-lecture-##.tex\`)
- \`assignments/\`, \`exams/\`
- \`tex/\`: main LaTeX notes (\`notes.tex\`)
- \`notes/\`: quick markdown notes (Obsidian-friendly)
- \`references/\`: **symlinks** to papers/textbooks

## common commands
- add a paper: \`(cd references && slink ~/academia/library/papers/by-author/romer-1990-endogenous-growth.pdf)\`
- list symlinks: \`lslinks .\`
EOF2

echo "✓ Created new course at $root"
echo "  - LaTeX notes scaffolded at $root/tex/notes.tex"

EOF
chmod +x "$BIN/new-course"

# new-research
# Scaffold for a new research project with optional Python/Julia/LaTeX/git
cat > "$BIN/new-research" <<'EOF'
#!/usr/bin/env bash
set -euo pipefail
. "$HOME/bin/_helpers.sh"


if [[ -z "$name" ]]; then
  echo "Usage: new-research [--lang python|julia|both] [--git] <project name>"
  exit 1
fi

slug="$(slugify "$name")"
root="$HOME/academia/projects/$slug"

if [[ -d "$root" ]]; then
  echo "Error: project $slug already exists at $root"
  exit 1
fi

# --------------------------
# Core project structure
# --------------------------
mkdir -p "$root"/{data/{raw,processed,external,interim},src,reports,figures,results,references}
cp -n "$HOME/academia/templates/.gitignore" "$root/.gitignore"


# --------------------------
# README
# --------------------------
cat > "$root/README.md" <<EOF2
# $slug

## layout
- \`data/\`: raw (RO), processed, external, interim
- \`src/\`: code
- \`reports/\`: LaTeX/markdown writeups
- \`references/\`: **symlinks** to PDFs in \`academia/library\`
- \`results/\`, \`figures/\`

EOF2

# --------------------------
# Reports scaffold
# --------------------------
mkdir -p "$root/reports"
cp -n "$HOME/academia/templates/latex/article.tex" "$root/reports/writeup.tex"
cp -n "$HOME/academia/templates/latex/refs.bib" "$root/reports/refs.bib"


echo "✓ Created research project at $root"
EOF
chmod +x "$BIN/new-research"

# add-paper
# Add a downloaded paper to the library classified by author last name
#!/usr/bin/env bash
set -euo pipefail
. "$HOME/bin/_helpers.sh"

usage() {
  cat <<USAGE
Usage:
  add-paper [--author "Kydland, Finn; Prescott, Edward"] [--year 1982] [--title "Time to Build and Aggregate Fluctuations"] [--link <dir>] <pdf...>

Notes:
  - If flags are omitted, you'll be prompted.
  - Files are normalized, renamed to lastname[-etal]-year-short-title.pdf,
    moved to ~/academia/library/papers/by-author/<lastname>/,
    and optionally symlinked into --link (defaults to cwd if it's a .../references dir).
USAGE
}

authors="" year="" title="" link=""
args=()
while [[ $# -gt 0 ]]; do
  case "$1" in
    --author) authors="$2"; shift 2;;
    --year)   year="$2";    shift 2;;
    --title)  title="$2";   shift 2;;
    --link)   link="$2";    shift 2;;
    -h|--help) usage; exit 0;;
    *) args+=("$1"); shift;;
  esac
done

if [[ ${#args[@]} -eq 0 ]]; then usage; exit 1; fi

# Derive default link target if CWD looks like a references dir
if [[ -z "$link" && "$PWD" =~ /academia/(courses|projects)/.*/references$ ]]; then
  link="$PWD"
fi

# Prompt if missing metadata
if [[ -z "$authors" ]]; then read -r -p "Authors (e.g., 'Kydland, Finn; Prescott, Edward'): " authors; fi
if [[ -z "$year" ]];    then read -r -p "Year (e.g., 1982): " year; fi
if [[ -z "$title" ]];   then read -r -p "Title: " title; fi

# Split authors by semicolon
author_list=($(echo "$authors" | tr ';' '\n'))

# Clean and slugify first author last name
first_last="$(echo "${author_list[0]}" | awk -F',' '{gsub(/^[[:space:]]+|[[:space:]]+$/,"",$1); print $1}')"
first_last="$(slugify "$first_last")"

# Handle naming based on number of authors
if [[ ${#author_list[@]} -eq 1 ]]; then
  fname="${first_last}-${year}-$(slugify "$title").pdf"
elif [[ ${#author_list[@]} -eq 2 ]]; then
  second_last="$(echo "${author_list[1]}" | awk -F',' '{gsub(/^[[:space:]]+|[[:space:]]+$/,"",$1); print $1}')"
  second_last="$(slugify "$second_last")"
  fname="${first_last}-${second_last}-${year}-$(slugify "$title").pdf"
else
  fname="${first_last}-etal-${year}-$(slugify "$title").pdf"
fi

dest_dir="$HOME/academia/library/papers/by-author/$lastname"
mkdir -p "$dest_dir"

for f in "${args[@]}"; do
  [[ -f "$f" ]] || { echo "Missing file: $f" >&2; exit 1; }
  # normalize source name (spaces etc.) then rename into dest
  base="$(basename "$f")"
  norm="$(slugify "${base%.*}").${base##*.}"
  tmp="$HOME/academia/library/papers/incoming/$norm"
  mkdir -p "$HOME/academia/library/papers/incoming"
  cp "$f" "$tmp"

  final="$dest_dir/$fname"
  mv -f "$tmp" "$final"
  echo "Filed: $final"

  if [[ -n "$link" ]]; then
    mkdir -p "$link"
    # relative symlink
    rel="$(python3 - <<PY
import os,sys
print(os.path.relpath("$final","$link"))
PY
)"
    ln -sfn "$rel" "$link/$fname"
    echo "Linked into: $link/$fname"
  fi
done

# print-structure
# Print directory tree of academia and personal
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
# Automatically cleans up filenames in ~/inbox when new files arrive
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
