# TASK-0074 — Test whether the FRQ grader handles LaTeX in rubric text

**Status:** Open — created 2026-10-14 at the Product Owner's request; nothing run yet.
**Tier:** Standard for the analysis, harness and tests; **Hard-Gate** for any call that spends Production model budget or reads or writes Production grading data.
**Owner:** unassigned. **Product Owner:** David Bloom.
**Branch / PR:** none yet.
**Blocks:** `TASK-0073` Phase 2 (the 10 rubric-line edits). Phase 1 (MCQ rows) does not depend on this.
**Related:** `DECISION-0121`, `DECISION-0119`, `TASK-0073`, the independent QA of 2026-10-14.

## Why this exists

`TASK-0073` drafts prose maths as `\(…\)` (inline) and `\[…\]` (display). Ten of the drafted edits are rubric lines
(`app.frq_criteria.learner_facing_text`). Unlike answer choices, **rubric text is read by the model that grades the
student's answer.** The independent QA found that the Production grader reads this column directly, injects it into
the model rubric prompt, and persists the model's `decision_explanation` without any prose-maths conversion.

So changing the rubric text could change grades, or could make the model quote `\[…\]` into a field that is shown
to a student. Mathematically equivalent text is not the same as grading-invariant text. Nobody has tested it.

## What is known

- The grader is `supabase/functions/evaluate-attempt/index.ts`. It loads criteria with `learner_facing_text` (around
  lines 908 and 1466) and calls the OpenAI Responses API directly (around line 580). Shared contract and feedback
  code is in `supabase/functions/_shared/grading-contract.ts` and `grading-feedback.ts`, with tests alongside.
- `decision_explanation` is persisted (around lines 319 and 1866) and shown in the question page's per-criterion
  `reason` line. As of `ap-prep-blueprint` PR #23 that line is rendered through `ProseMath`, so a quoted `\(…\)` would
  typeset. Other model-written fields (feedback preview, repair hints, minimum-fix text) are not covered and have not
  been checked.
- "More help" (`supabase/functions/more-help`) is a separate feature on the Anthropic Gateway. Its contract tells the
  model to use dollar-delimited maths, which does not match the backslash delimiters. It is limited to Calculus AB/BC
  and Chemistry today, so this pilot does not reach it, but expanding it would.

## Questions to answer

1. Does the grading **decision** (earned, not yet earned, unable to determine) change when a rubric line carries
   `\[…\]` or `\(…\)` instead of plain text, for the same student responses?
2. Does the model's **explanation or evidence quote** copy the delimiters or LaTeX commands into a persisted,
   student-visible field? In which fields?
3. If either answer is yes, what is the smallest safe fix?

## Method

1. Build a small harness in Development, using **synthetic** criteria and responses so no published exam text enters
   this public repository. Mirror the shapes of the ten deferred rubric lines: a single worked equation with stacked
   fractions, units, subscripts, and a nested simple quotient.
2. For each criterion write three responses: correct, wrong in a way the rubric should catch (sign, value, units),
   and vague. Grade each against the plain-text rubric and against the LaTeX rubric, several times each, to separate
   model variance from a real effect.
3. Compare decision agreement between the two rubric forms against the run-to-run agreement of each form alone.
   Search every persisted model-written string for `\(`, `\[`, `\frac`, `\mathrm` and `$`.
4. Real model calls spend the daily budget. They need the Product Owner's explicit approval for a bounded number of
   calls (the More help QA used three of six permitted), recorded before running.

## If the grader does not handle it

In order of preference:

1. **Convert at prompt-build time.** Strip or flatten the delimiters before the rubric reaches the model (a
   server-side counterpart of the app's `stripProseMath`), so students see typeset maths and the grader sees the text
   it graded before. Add tests in `grading-contract_test.ts`.
2. **Instruct the model** not to repeat markup, and escape on the way out. Weaker, because it relies on compliance.
3. **Leave the ten rubric lines unedited** and accept slash notation in rubrics.

Any change to `evaluate-attempt` is a Production deployment with its own approval.

## Out of scope

Editing any rubric row, any Production write, "More help" delimiters, and the reviewer and admin pages (already
handled in `ap-prep-blueprint` PR #23).

## Acceptance

- A written result for each of the three questions, with the counts behind it.
- Either a clear "safe as is" with the run-to-run baseline, or a tested fix and its deployment plan.
- `TASK-0073` Phase 2 updated to proceed, change, or drop, citing this task.
- The bounded model-call approval recorded if any real calls were made.
