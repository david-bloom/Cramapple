#!/usr/bin/env bash
# QA: /progress display-only contract (Lovable frontend)
# ---------------------------------------------------------------------------
# The Progress Dashboard v1 rule is that Supabase is the sole producer of every
# progress number and the page is display-only. This script enforces the
# frontend half of that contract statically, plus runs the unit tests.
#
# The backend half lives in scripts/qa/progress_dashboard_v1_qa.sql.
#
# Usage:  scripts/qa/progress_display_contract_qa.sh [path-to-frontend-repo]
# Default frontend path: ../exam-buddy-wireframe relative to this repo, or
# $CRAMAPPLE_FRONTEND if set.

set -uo pipefail

FE="${1:-${CRAMAPPLE_FRONTEND:-$HOME/Documents/exam-buddy-wireframe}}"
LIB="$FE/src/lib/progress-dashboard.ts"
ROUTE="$FE/src/routes/_ux.progress.tsx"

pass=0; fail=0
ok()   { echo "  PASS  $1"; pass=$((pass+1)); }
bad()  { echo "  FAIL  $1"; fail=$((fail+1)); }
note() { echo "  NOTE  $1"; }

echo "== /progress display-only contract =="
echo "frontend: $FE"

for f in "$LIB" "$ROUTE"; do
  [ -f "$f" ] || { echo "  FAIL  missing file: $f"; exit 2; }
done

# P1 — exactly one RPC call, and it is the progress dashboard.
rpc_count=$(grep -c "supabase\.rpc(" "$LIB" "$ROUTE" | awk -F: '{s+=$2} END {print s}')
if [ "$rpc_count" = "1" ] && grep -q "get_student_progress_dashboard" "$LIB"; then
  ok "single RPC call, and it is get_student_progress_dashboard"
else
  bad "expected exactly 1 supabase.rpc call (found $rpc_count)"
fi

# P2 — no direct table reads for progress statistics.
if grep -nE '\.from\("(attempts|grading_results|attempt_criterion_results|learning_sessions|sessions|progress_snapshots)"\)' "$LIB" "$ROUTE" >/dev/null; then
  bad "progress files read a raw table directly"
  grep -nE '\.from\("[a-z_]+"\)' "$LIB" "$ROUTE" | sed 's/^/        /'
else
  ok "no raw table reads in the progress files"
fi

# P3 — no client-side derivation of any figure the backend already supplies.
if grep -nE '\* *100|/ *[a-zA-Z_.]*(attempted|possiblePoints|gradedItems|sessions)\b|\.toFixed\(' "$LIB" "$ROUTE" >/dev/null; then
  bad "arithmetic on payload values found — the backend owns every figure"
  grep -nE '\* *100|\.toFixed\(' "$LIB" "$ROUTE" | sed 's/^/        /'
else
  ok "no client-side arithmetic on payload values"
fi

# P4 — the status vocabulary is exactly the five contract tokens.
missing_tok=""
for tok in no_evidence insufficient_evidence developing strong attribution_unavailable; do
  grep -q "\"$tok\"" "$LIB" || missing_tok="$missing_tok $tok"
done
if [ -z "$missing_tok" ]; then
  ok "all five contract status tokens present"
else
  bad "status token(s) missing from the client:$missing_tok"
fi

# P5 — no failure colour. Weak performance and thin evidence are different
# things; UX-007 forbids framing incomplete work as failure.
#
# Scope note: this checks for a failure COLOUR only. The string "error" is
# deliberately excluded — the client uses it as an error-STATE discriminator
# (query.error.kind), which is legitimate and unrelated to status colour.
if grep -nEi '"(red|destructive|danger)"|#(ff0000|f00)\b|\bcolou?r: *red' "$LIB" "$ROUTE" \
     | grep -vE ':[[:space:]]*(//|\*)' >/dev/null; then
  bad "a failure colour appears in the progress UI"
  grep -nEi '"(red|destructive|danger)"|#(ff0000|f00)\b|\bcolou?r: *red' "$LIB" "$ROUTE" | sed 's/^/        /'
else
  ok "no failure colour (no red / destructive / danger)"
fi

# P6 — sections with no data behind them must not be built.
forbidden=0
for pat in "heatmap" "topic mastery" "topicMastery" "scoring move" "scoringMove" "recommended next" "recommendedNext" "most improved" "mostImproved"; do
  if grep -niE "$pat" "$ROUTE" | grep -viE ':\s*(//|\*|/\*)' | grep -viE 'never|not a|no [a-z]* ?heatmap' >/dev/null; then
    bad "forbidden v1 section referenced: $pat"
    forbidden=1
  fi
done
[ "$forbidden" = "0" ] && ok "no heatmap / topic mastery / scoring moves / recommended next / most improved"

# P7 — withheld grades must never render a score.
if grep -q "pointsWithheld" "$ROUTE"; then
  ok "pointsWithheld is handled in the route"
else
  bad "pointsWithheld is not handled — uncertain grades could render a score"
fi

# P8 — null is not zero. percentCorrect and counts must degrade to a dash.
if grep -qE 'value === null \? "—"' "$LIB"; then
  ok "null figures render as an em dash, not 0"
else
  bad "formatters do not render null as an em dash"
fi

# P9 — unit evidence must stay gated while attribution is unavailable.
if grep -q "unitAttributionAvailable" "$ROUTE"; then
  ok "unitsWithEvidence is gated behind unitAttributionAvailable"
else
  bad "unitsWithEvidence is not gated — it may render as a count"
fi

# P10 — the three error codes are mapped to distinct states.
missing_codes=""
for c in 28000 42501 22023; do
  grep -q "$c" "$LIB" || missing_codes="$missing_codes $c"
done
if [ -z "$missing_codes" ]; then
  ok "error codes 28000 / 42501 / 22023 are all handled"
else
  bad "unhandled RPC error code(s):$missing_codes"
fi

# P11 — unit tests.
if [ -f "$FE/package.json" ]; then
  echo "-- vitest (progress-dashboard) --"
  if (cd "$FE" && npx vitest run src/lib/__tests__/progress-dashboard.test.ts --reporter=dot 2>&1 | tail -5); then
    ok "progress-dashboard unit tests pass"
  else
    bad "progress-dashboard unit tests failed"
  fi
else
  note "no package.json at $FE; skipped unit tests"
fi

echo
echo "== $pass passed, $fail failed =="
[ "$fail" -eq 0 ] || exit 1
