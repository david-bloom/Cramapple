# QA Response — TASK-0016 Phase A

**Reviewer note addressed:** `docs/research/CODEX_TASK0016_PHASE_A_QA_FINDINGS_2026_07_08.md`
**Response date:** 2026-07-08
**Status:** Fixes applied; please re-run QA against the updated working tree.

## Summary

Thanks for the careful review. The four requested remediations from the findings
note are now reflected in the working tree and the regression suite:

1. ECF work-support is now tri-state (`unknown | true | false`) instead of
   collapsing missing substitutions into `false`, so correct work without
   itemized substitutions is not false-flagged.
2. Power precedence now matches standard/AP math expectations, so `^` binds
   tighter than unary minus.
3. Multivariable equivalence sampling now draws each variable independently,
   matching the Python reference rather than walking a correlated diagonal.
4. The specificity regression tests were backfilled for all three issues above,
   so the suite now catches the bugs that previously slipped through a green run.

## What changed

- [math-verifier.ts](/Users/davidbloom/Documents/Cramapple/supabase/functions/_shared/math-verifier.ts)
  now:
  - preserves the tri-state ECF work-support path,
  - parses `-2^2` as `-(2^2)`,
  - samples multivariable expressions independently,
  - and keeps the ABSTAIN-on-ambiguity behavior for typed fractions.
- [math-verifier_test.ts](/Users/davidbloom/Documents/Cramapple/supabase/functions/_shared/math-verifier_test.ts)
  now includes regression tests for:
  - no-itemized-substitution ECF correctness,
  - exponent precedence before unary minus,
  - multivariable non-equivalence,
  - and the flat-fraction ABSTAIN guardrail.
- [grading_router_integration_note_2026_07_08.md](/Users/davidbloom/Documents/Cramapple/docs/research/grading_router_integration_note_2026_07_08.md)
  was updated so the documentation matches the in-process TypeScript verifier
  shape that Phase A now uses.

## Verification

I re-ran the targeted suite after the fixes:

- `deno check supabase/functions/_shared/math-verifier.ts supabase/functions/_shared/formula-notation.ts supabase/functions/evaluate-attempt/index.ts`
- `deno test supabase/functions/_shared/math-verifier_test.ts supabase/functions/_shared/grading-router_test.ts supabase/functions/_shared/formula-notation_test.ts supabase/functions/_shared/statistics-verifier_test.ts supabase/functions/evaluate-attempt_test.ts`
- `git diff --check`

All passed in the updated tree.

## Ask for re-review

Please re-run QA on the updated implementation and confirm whether the verdict
can move from `FAIL` to `PASS`.
