#!/usr/bin/env bash
# Axiom audit for Lean DAM.
#
# Runs `#print axioms` on every public theorem/lemma listed in
# scripts/AxiomAudit.lean (after `lake build`), writes the raw output to
# axiom-audit.txt, and fails if
#   - any declaration depends on `sorryAx`,
#   - any declaration depends on an axiom outside Lean's standard three
#     (propext, Classical.choice, Quot.sound), or
#   - the number of reported declarations differs from the audit list.

set -euo pipefail
cd "$(git rev-parse --show-toplevel)"

out="${1:-axiom-audit.txt}"
expected=$(grep -c '^#print axioms' scripts/AxiomAudit.lean)

lake env lean scripts/AxiomAudit.lean | tee "$out"

reported=$(grep -cE "^'LeanDAM\.[^']+' (depends on axioms|does not depend on any axioms)" "$out" || true)
status=0

if [ "$reported" -ne "$expected" ]; then
  echo "FAIL: expected $expected axiom reports, got $reported"; status=1
fi

if grep -q 'sorryAx' "$out"; then
  echo "FAIL: sorryAx present"; status=1
fi

extra=$(grep -oE 'depends on axioms: \[[^]]*\]' "$out" \
  | sed -E 's/.*\[(.*)\]/\1/' | tr ',' '\n' | sed -E 's/^ +| +$//g' \
  | grep -vxE 'propext|Classical\.choice|Quot\.sound' | sort -u || true)
if [ -n "$extra" ]; then
  echo "FAIL: non-standard axioms:"; echo "$extra"; status=1
fi

if [ "$status" -eq 0 ]; then
  echo "OK: $reported declarations audited; axioms within {propext, Classical.choice, Quot.sound}; no sorryAx"
  echo "Footprint summary:"
  grep -oE 'depends on axioms: \[[^]]*\]|does not depend on any axioms' "$out" | sort | uniq -c
fi
exit "$status"
