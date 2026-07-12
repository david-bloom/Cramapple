# QA Note — TASK-0016 Phase A

**Date:** 2026-07-08
**Context:** Follow-up note after the Claude QA findings were addressed in the
Phase A grading-router / typed-formula verifier work.

## Current Status

The three verifier bugs flagged in QA have been fixed in the working tree, and
the regression suite now includes coverage for the cases that previously slipped
through:

- ECF work support is tri-state instead of collapsing unknown substitutions into
  `false`.
- Exponentiation now binds tighter than unary minus.
- Multivariable equivalence sampling now draws each variable independently.
- Specificity regressions for all three cases are now covered in tests.

## Re-verified

The following checks passed after the fixes:

- `deno check supabase/functions/_shared/math-verifier.ts supabase/functions/_shared/formula-notation.ts supabase/functions/evaluate-attempt/index.ts`
- `deno test supabase/functions/_shared/math-verifier_test.ts supabase/functions/_shared/grading-router_test.ts supabase/functions/_shared/formula-notation_test.ts supabase/functions/_shared/statistics-verifier_test.ts supabase/functions/evaluate-attempt_test.ts`
- `git diff --check`

## Reviewer Follow-Up

Please re-run QA against the updated working tree and confirm whether the Phase
A verdict can be upgraded from `FAIL` to `PASS`.

