#!/usr/bin/env bash
# Source-integrity guard for Lean DAM.
#
# Fails when a tracked .lean file
#   1. is empty,
#   2. contains markup that marks non-Lean content (HTML/XML documents),
#   3. contains `sorry` or `admit` as a tactic/term token, or
#   4. declares a new `axiom`.
# It also checks that every module imported by the library roots exists.
#
# Comment and string contents are stripped before the token checks, so
# docstrings that mention these words are allowed.

set -euo pipefail
cd "$(git rev-parse --show-toplevel)"

status=0
fail() { echo "::error file=$1::$2"; echo "FAIL $1: $2"; status=1; }

files=()
while IFS= read -r line; do files+=("$line"); done < <(git ls-files '*.lean')
if [ "${#files[@]}" -eq 0 ]; then
  echo "FAIL: no tracked .lean files"; exit 1
fi

strip_comments() {
  # Remove block comments (including docstrings), line comments and strings.
  python3 - "$1" <<'PY'
import re, sys
src = open(sys.argv[1], encoding="utf-8").read()
out, i, depth = [], 0, 0
while i < len(src):
    if src.startswith("/-", i):
        depth += 1; i += 2; continue
    if depth and src.startswith("-/", i):
        depth -= 1; i += 2; continue
    if depth:
        out.append("\n" if src[i] == "\n" else " "); i += 1; continue
    if src.startswith("--", i):
        j = src.find("\n", i); i = len(src) if j < 0 else j; continue
    if src[i] == '"':
        j = i + 1
        while j < len(src) and src[j] != '"':
            j += 2 if src[j] == "\\" else 1
        i = j + 1; continue
    out.append(src[i]); i += 1
sys.stdout.write("".join(out))
PY
}

for f in "${files[@]}"; do
  if [ ! -s "$f" ]; then fail "$f" "empty Lean file"; continue; fi
  if grep -qiE '<!doctype|<html|<head>|<body|<\?xml|</(div|p|span|style|script)>' "$f"; then
    fail "$f" "contains HTML/XML markup; Lean sources must hold Lean code"
  fi
  first=$(grep -m1 -vE '^\s*$' "$f" || true)
  case "$first" in
    "<"*) fail "$f" "first non-blank line starts with '<': $first" ;;
  esac
  code=$(strip_comments "$f")
  if grep -nE '(^|[^A-Za-z0-9_.'"'"'])(sorry|admit)([^A-Za-z0-9_'"'"']|$)' <<<"$code" >/dev/null; then
    fail "$f" "contains sorry/admit"
  fi
  if grep -nE '^\s*((private|protected|noncomputable|unsafe)\s+)*axiom\s' <<<"$code" >/dev/null; then
    fail "$f" "declares an axiom"
  fi
done

# Every `import LeanDAM.X` / `import DenseAssociativeMemory` must resolve to a tracked file.
for f in "${files[@]}"; do
  while read -r mod; do
    case "$mod" in
      LeanDAM*|DenseAssociativeMemory*)
        path="${mod//.//}.lean"
        git ls-files --error-unmatch "$path" >/dev/null 2>&1 \
          || fail "$f" "imports $mod but $path is not tracked"
        ;;
    esac
  done < <(sed -nE 's/^import[[:space:]]+([A-Za-z0-9_.]+).*/\1/p' "$f")
done

if [ "$status" -eq 0 ]; then
  echo "OK: ${#files[@]} Lean files pass the source-integrity guard"
fi
exit "$status"
