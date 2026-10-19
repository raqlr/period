#!/usr/bin/env bash
# Refuses to commit personal cycle data. Run by the pre-commit hook, or by hand:
#   scripts/check-no-data.sh
# Checks every file that is staged (or, outside a commit, every tracked file).
set -u
cd "$(git rev-parse --show-toplevel)" || exit 1
files=$(git diff --cached --name-only --diff-filter=ACM 2>/dev/null)
[ -z "$files" ] && files=$(git ls-files)
bad=0
for f in $files; do
  [ -f "$f" ] || continue
  case "$f" in
    scripts/check-no-data.sh|index.html|README.md) skip_content=1 ;;
    *) skip_content=0 ;;
  esac
  case "$f" in
    *.db|*.sqlite|*.sqlite3|*backup*.json|*export*.json|data/*|private/*)
      echo "BLOCKED: $f looks like a data file."; bad=1; continue ;;
  esac
  [ "$skip_content" = 1 ] && continue
  case "$f" in *.png|*.jpg|*.jpeg|*.gif|*.ico|*.webp) continue ;; esac
  # A Period backup looks like: {"periods":[{"id":"..","start":"2026-01-01", ...
  if grep -Eq '"periods"[[:space:]]*:[[:space:]]*\[[[:space:]]*\{[^}]*"start"[[:space:]]*:[[:space:]]*"[0-9]{4}-[0-9]{2}-[0-9]{2}"' "$f" 2>/dev/null; then
    echo "BLOCKED: $f contains what looks like a Period backup (real or sample)."; bad=1
  fi
done
if [ "$bad" = 1 ]; then
  echo
  echo "Commit stopped. Remove the file or add it to .gitignore."
  echo "Screenshots must use the built-in sample data (Home > Try with sample data)."
  exit 1
fi
exit 0
