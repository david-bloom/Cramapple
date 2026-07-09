# Phase A Handoff — TASK-0016

**Date:** 2026-07-08
**From:** Codex Phase A implementation
**To:** Claude Phase B / follow-on QA

## What Phase A now guarantees

- `rubric_type` / `evaluator_strategy` routing exists and routes `structured_formula`
  and legacy `quantitative` content to the symbolic/ECF boundary.
- The shared TypeScript verifier now covers:
  - typed formula equivalence,
  - antiderivatives with `+C`,
  - numeric answers,
  - ECF / consistency-point grading,
  - ABSTAIN-on-ambiguity for risky typed notation.
- AP Statistics keyed items can be coerced from the stored response shape used
  by `evaluate-attempt`.
- The evaluate-attempt path records verifier pins and keeps the existing
  discrete-text / Statistics fallback behavior intact.

## Regression coverage now in place

- ECF no longer false-flags correct work when itemized substitutions are absent.
- Exponentiation precedence now matches standard/AP math expectations.
- Multivariable equivalence sampling now draws each variable independently.
- Tests exist for the above three specificity regressions, plus the flat-fraction
  ABSTAIN hazard.

## What Phase A intentionally does not claim

- No learner-facing authoritative score for the symbolic boundary yet.
- No hand-drawn / OCR / transcription path.
- No spatial engine.
- No launch-gate calibration on the adjudicated gold set.

## Source files to trust

- [grading-router.ts](/Users/davidbloom/Documents/Cramapple/supabase/functions/_shared/grading-router.ts)
- [math-verifier.ts](/Users/davidbloom/Documents/Cramapple/supabase/functions/_shared/math-verifier.ts)
- [math-verifier_test.ts](/Users/davidbloom/Documents/Cramapple/supabase/functions/_shared/math-verifier_test.ts)
- [evaluate-attempt/index.ts](/Users/davidbloom/Documents/Cramapple/supabase/functions/evaluate-attempt/index.ts)
- [grading_router_integration_note_2026_07_08.md](/Users/davidbloom/Documents/Cramapple/docs/research/grading_router_integration_note_2026_07_08.md)

## Next action for Phase B

- Keep the typed symbolic/ECF contract stable.
- Work on the next boundary contract or follow-on calibration tasks without
  widening the Phase A scope.

