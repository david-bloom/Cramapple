# Codex QA Prompt — TASK-0016 Phase A (Grading Router + Deterministic/Typed Formula Engines)

Use per `docs/team_charter/AGENT_OPERATING_MODEL.md`'s QA Agent role: an
independent, skeptical review, not a relabeled continuation of the implementer.
Treat yourself as having no prior context on this work; verify claims from
source, not from the implementation summary.

## Task

Review the current TASK-0016 Phase A implementation in the working tree against
`main`. Inspect the actual diff, not just the task description or chat recap.

## Background

Phase A is the grading-router and typed-formula/ECF wiring pass for Cramapple.
The intended shape is:

- rubric-driven routing by `rubric_type` / `evaluator_strategy`
- deterministic checks for MCQ and numeric/Statistics-owned criteria
- typed symbolic formula checking with ABSTAIN-on-ambiguity behavior
- Error-Carried-Forward support for structured formula work
- regression safety for the existing Biology / Statistics text-grading path

## What to verify, not assume

1. **Router behavior**
   - Confirm `supabase/functions/_shared/grading-router.ts` routes
     `mcq`, `discrete_text`, `structured_formula`, `spatial`, and `holistic`
     as intended.
   - Confirm unsupported or missing metadata still falls back to shadow review
     instead of erroring or silently passing.
   - Verify router tests cover explicit rubric routes, legacy item-type routes,
     prompt_json fallbacks, and the shadow-review fallback path.

2. **Typed formula checker**
   - Confirm the shared math verifier implements:
     - expression equivalence
     - antiderivative checking with `+C`
     - numeric checking
     - conceptual ABSTAIN
   - Confirm ambiguous typed notation, especially the flat-fraction hazard
     (`3t^2/2t`-style input), ABSTAINS rather than false-flagging.
   - Confirm the reference battery is represented in tests and that the hazard
     cases do not produce false flags.

3. **ECF behavior**
   - Confirm the ECF path honors the reference verdict set:
     `CORRECT`, `CORRECT_VIA_ECF`, `CONCEPTUAL_COLLAPSE`, `COINCIDENTAL`,
     `NAKED_ANSWER`, `INCORRECT`.
   - Confirm no-work-shown responses trigger the help/scaffold path rather than
     receiving ECF credit.
   - Confirm the AP Statistics keyed items can be coerced from the stored
     response shape used by `evaluate-attempt`.

4. **Production wiring**
   - Confirm `supabase/functions/evaluate-attempt/index.ts` routes structured
     formula attempts through the symbolic/ECF branch and still preserves the
     existing Statistics deterministic fallback and Biology/Statistics text
     grading behavior.
   - Confirm the result payload still records the relevant routing and feedback
     fields, including the new verifier pins.

5. **Schema / migration**
   - Confirm the migration for the verifier pin columns exists and matches the
     fields written by the edge function.
   - If any new column is referenced in code, confirm the migration covers it.

6. **Docs / contract note**
   - Confirm the integration note reflects the actual implementation shape and
     does not claim a different deployment boundary than the code uses.

7. **Validation**
   - Run the targeted Deno checks/tests for the touched files.
   - Confirm `git diff --check` is clean.

## Authority boundaries

You may propose a verdict and findings. You may not approve, merge, mark Done,
or alter live state. David is the final approver.

## Required Output

1. Proposed verdict: Pass / Fail.
2. Blocking findings, with file:line, if any.
3. Non-blocking risks or test gaps.
4. Evidence actually checked (files read, commands run).
5. Required remediation, if any.

Keep the report concise and source-backed.
