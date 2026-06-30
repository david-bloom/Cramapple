# Codex Execution Prompt — TASK-0013 Phase 3 Follow-Up: CI Ambiguity Diagnostic Text

**Cleared to execute.** Non-blocking cleanup item, no gate. Touches only
`scripts/ap_statistics_calculation_check/checker.py` and its test file —
same standalone module as Phase 3, not wired into anything live.

## Context

Phase 3's calculation-check verifier (`scripts/ap_statistics_calculation_check/checker.py`,
merged via PR #24) had a blocking bug fixed during QA remediation: when a
response contains more than one complete confidence-interval pair, the
checker now correctly fails closed to `indeterminate` instead of silently
picking the wrong pair. That fix works — re-QA confirmed it directly against
adversarial inputs, including a 3-pair case.

Re-QA found one remaining, explicitly non-blocking gap: `evaluate()`'s
diagnostic `reason` text and `detected_claims` field can't currently
distinguish "zero confidence-interval claims found" from "more than one
found" — both collapse to the same `indeterminate` reason text ("no
unambiguous confidence-interval claim could be extracted"), because
`extract_confidence_interval_claims` returns an empty list `[]` for both
the `0` and `>1` candidate-count cases. The single-value claim path (e.g.
`t_statistic`, `p_value`) doesn't have this gap — it already distinguishes
0-claims from multiple-claims in its diagnostic text.

## Goal

Make the confidence-interval diagnostic path distinguish "no extractable
pair" from "multiple ambiguous pairs found," matching the single-value
path's existing behavior — without changing the verdict logic itself (the
verdict is already correct; this is a diagnostics-only fix).

## Scope

1. Have `extract_confidence_interval_claims` (or the calling code in
   `evaluate()`) preserve enough information to tell these two cases apart
   — e.g. return the actual list of candidates found (even when count != 1)
   rather than collapsing to `[]`, and let the caller decide the
   `indeterminate` reason text and `detected_claims` payload based on the
   actual count.
2. Update the `reason` string for the `>1` case to say something like
   "Multiple confidence-interval claims were found; cannot determine which
   one answers this criterion" — distinct from the `0` case's "No
   confidence-interval claim could be extracted."
3. `detected_claims` (or whatever field currently goes empty on the `>1`
   path) should list the candidates that were found, for debugging —
   mirroring however the single-value path already surfaces this.
4. Add or update a test confirming the `reason`/`detected_claims` content
   differs between the 0-claim and multi-claim cases for confidence
   intervals (currently nothing asserts on this distinction).
5. Do not change verdict behavior — `indeterminate` is correct for both
   cases and must stay that way. This is diagnostic-text-only.

## Out of Scope

- Any change to the single-value claim path (`t_statistic`, `z_statistic`,
  `p_value`) — it already handles this correctly.
- Wiring this module into `evaluate-attempt`/`grade-frq`.
- Any schema/database work.

## Required Evidence on Completion

- Diff showing the diagnostic-text fix.
- Full test suite passing (currently 9/9 — should grow by at least one
  test for the new distinction).

## Next Expected Output

A PR against `main`, branch-prefixed `codex/...`, referencing `TASK-0013`,
ready for the same independent QA pattern used on prior PRs in this task.
