#!/usr/bin/env bash
# Gate R0 local verification: integrity guard, pinned build, axiom audit.
# Writes all evidence to verification/ for transcription into REPORT.md.
#
# Usage (from the repository root, with elan installed):
#   bash scripts/r0-verify.sh

set -uo pipefail
cd "$(git rev-parse --show-toplevel)"
mkdir -p verification
ev=verification

{
  echo "date_utc: $(date -u +%Y-%m-%dT%H:%M:%SZ)"
  echo "commit: $(git rev-parse HEAD)"
  echo "branch: $(git rev-parse --abbrev-ref HEAD)"
  echo "worktree_clean: $([ -z "$(git status --porcelain --untracked-files=no)" ] && echo yes || echo no)"
  echo "lean-toolchain: $(cat lean-toolchain)"
  echo "mathlib_rev_pinned: $(sed -nE 's/^rev = "([0-9a-f]+)"/\1/p' lakefile.toml)"
  echo "uname: $(uname -sm)"
} > "$ev/env.txt"

echo "== 1/4 integrity guard"
bash scripts/check-lean-sources.sh 2>&1 | tee "$ev/guard.log"
guard=${PIPESTATUS[0]}

echo "== 2/4 toolchain"
{ lean --version; lake --version; } 2>&1 | tee -a "$ev/env.txt"

echo "== 3/4 build (Mathlib cache, then lake build)"
lake exe cache get 2>&1 | tail -5 | tee "$ev/cache.log"
start=$(date +%s)
lake build DenseAssociativeMemory 2>&1 | tee "$ev/build.log"
build=${PIPESTATUS[0]}
echo "build_seconds: $(( $(date +%s) - start ))" >> "$ev/env.txt"
grep -A40 '"name": "mathlib"' lake-manifest.json 2>/dev/null | grep -m1 '"rev"' \
  | sed 's/^ */mathlib_rev_resolved: /' >> "$ev/env.txt"
warnings=$(grep -c 'warning:' "$ev/build.log" || true)

echo "== 4/4 axiom audit"
audit=1
if [ "$build" -eq 0 ]; then
  bash scripts/axiom-audit.sh "$ev/axiom-audit.txt" 2>&1 | tee "$ev/axiom-audit.log"
  audit=${PIPESTATUS[0]}
fi

{
  echo "guard_exit: $guard"
  echo "build_exit: $build"
  echo "build_warnings: $warnings"
  echo "axiom_audit_exit: $audit"
} | tee -a "$ev/env.txt"

echo
echo "Evidence written to $ev/: env.txt guard.log cache.log build.log axiom-audit.txt axiom-audit.log"
[ "$guard" -eq 0 ] && [ "$build" -eq 0 ] && [ "$audit" -eq 0 ]
