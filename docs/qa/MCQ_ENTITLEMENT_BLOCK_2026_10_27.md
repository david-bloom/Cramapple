# Question page: access-denial handling during MCQ submission

**Status:** Investigation complete; remediation open. No QA pass or Production repair claimed.
**Date:** 2026-10-27
**Tier:** Standard non-destructive QA. Production publication remains Hard-Gate.
**Branch:** `codex/qa-mcq-entitlement-block`
**Related:** TASK-0071 (instant MCQ feedback), TASK-0078 (backend stability).

This public report contains software behavior and repair criteria only. Account records, payment
history, user/attempt/response identifiers and raw Production logs are excluded.

## Observed software failure

When an MCQ submission returns `entitlement_required`, the unified question page can display
locally checked answer feedback while showing “We could not score that answer. Please try again.”
Next question remains disabled. A local correctness check is not proof of a submitted or graded attempt.
The server's access check must remain authoritative.

Source inspected: Lovable app `56cae479-f7c9-4988-b536-56538c38ee4e`, source commit
`1d3a7074e73a0e4d3c50f6555bdf67b7684f3c3c`. The exact published frontend commit was not
independently identified. Backend source baseline: `origin/main` `49480bb4`.

## P1 — Access denial becomes a generic scoring error and a blocked review page

`src/lib/live-practice-mcq/grade.ts:79–86` preserves the `entitlement_required` submit failure.
`src/screens/question-experience/QuestionExperience.jsx:1050–1053` passes that code upward,
but TaskPane at lines 350–358 discards it and displays a generic retry message.

QxView at lines 774–795 retains optimistic feedback with status error after a failed save.
Line 808 sets `progressPending = Boolean(activeLocalGrade)` for both saving and failed states;
the fieldset at line 489 therefore keeps Next question and other task actions disabled.
A “Try saving again” control exists above the panes at line 805. It cannot resolve denied access.

Required behavior: retain the typed error, explain that progress was not saved, and offer a working
Account or Home action outside disabled controls. Do not treat a local check as a durable score.

## P1 — Learn treats an access denial as a missing worked example

`src/lib/question-experience/worked-example.ts:110–120` collapses all RPC errors,
explicitly including entitlement_required, to null. QuestionExperience.jsx:921–928
then skips the worked example and continues into question serving.

Required behavior: distinguish unavailable content from denied access. Stop the denied path
with an appropriate recovery action; retain fallback for genuinely missing examples.
Check Home entry, direct question URLs, and access revoked while a question is open.
A client check must not replace server enforcement.

## Repair and acceptance checks

1. Preserve typed failure codes through the Learn loader, grading adapter and question view.
   Show access-specific, truthful unsaved-answer copy and usable Account/Home actions.
2. Keep transient save failures distinct: retain the selected choice and logical submission,
   allow retry, and enable Next only after authoritative persistence succeeds.
3. Cover denied access, authorized access, a genuinely missing worked example, a transient save
   failure followed by successful retry, and access revoked after page load. Include shared FRQ handling.
4. In a signed-in browser, confirm authorized answers produce one submitted/graded attempt and
   enable Next. Confirm denied access offers a working exit without an endless retry or false saved score.
   Check Learn, Practice and direct-URL entry.

## Verification and next action

Read-only service checks and source inspection support these findings. No app code, entitlement,
role, payment, migration, deployment or publication was changed. Repository edits are documentation
only; git diff --check is the applicable local check. Runtime repair tests remain open.

Next: implement the error-state repair, obtain independent QA, then follow the normal publication gate.
Account-specific access decisions are handled separately from this public report.
Keep unrelated payments and frozen review functions outside this slice.
