<!-- Preserved verbatim from the Product Owner-supplied Lovable QA report, October 13, 2026. It reviews older SHAs; see MORE_HELP_QA_REMEDIATION_2026_10_13.md for disposition. -->

# Independent QA: More help (App PR #21 @ 24fd79f, backend PR #435 @ ad405dc2)

Read-only review. No code, deploy, secrets, model calls, access or publishing changes. This is a findings report, not an implementation plan for this project.

## Proposed verdict: FAIL

The design (two panes, question/answer/grade kept, no microquiz) holds up, and the trust boundary is mostly sound. Release is still blocked by the findings below and by the known generation failure.

## Blocking findings

1. **The grader never hears about More help.** `QuestionExperience.jsx:1012-1013` sends `assisted: aids.length > 0`, and that only counts Hint-gate aids. After More help, the trigger marks the attempt row `coached`, but `gradeLiveMcq`/`gradeLiveFrq` still send evaluate-attempt `assistance_condition: "independent"` and `independent_diagnostic_evidence: true`. Mastery evidence ends up contradicting the attempt row. Fix: put the server receipt (`has_question_help`, or a local `recorded` flag) into `assisted` before submitting, and add a test.
2. **Help is charged even when it fails.** `handler.ts` reserves first: it records the receipt, adds the `more_help` event and sets `coached` before `generate`, then keeps all of that when generation fails. Every request currently returns `help_unavailable`, so each student who tries is marked Assisted, uses quota and gets nothing. Each retry also mints a new `requestId` (`more-help.ts`), so `request_already_used` idempotency never applies. Fix: reuse one requestId per open/focus for retries, and either release or flag the receipt on provider failure, or make "assisted without help delivered" an explicit, approved rule.
3. **Unsanitized, ungated reference copy.** Sources come straight from the raw RPC `reference` (`contract.ts helpContext`), and `CheckedFact` renders them without `sanitizeStudentCopy`. That brings back the student-facing "CED" text the copy-boundary fix removed (39 unit-reference entries in Production contain it). It also renders `memoryHooks[0]` for each cited source, so up to 3 hooks show, with no topic-owner/reuse check. That breaks the at-most-one-current-topic hook rule.
4. **Highlights break math.** Highlights are validated only as raw substrings of the stem (`validateHelp`). `HighlightedQuestion` splits the stem before `MathText`, so a phrase inside or across `$...$` splits the math and KaTeX renders broken or literal text. That matters for Calculus/Chemistry stems. Fix: reject highlights that overlap math spans, or highlight after `splitMath`. Add a LaTeX-stem test.
5. **Governance: new /question stylesheet and component.** The standing rules allow only `QuestionExperience.jsx` + `question-experience.css` for /question, with no second stylesheet or pane component. The PR adds `src/styles/more-help.css` and `MoreHelp.tsx`. This needs an explicit Product Owner exception recorded in AGENTS.md, or the styles moved into `question-experience.css`. `question-design-rules.test.ts` may not catch this.
6. **Real generation fails (known).** Possible causes to check, from the source alone: `help_unavailable` comes from a non-OK provider response or a non-HelpError throw, and nothing is logged. Log only the provider status and error type. Also check strict json_schema support for `minItems`/`maxItems`/item `enum`, and whether reasoning tokens use up `max_output_tokens: 2500`. That last case would show as `help_incomplete`.

## Nonblocking limits

- Answer disclosure before submission relies only on the prompt. The model gets stem/choices, so for Calculus it can still work out the answer. Nothing in `validateHelp` checks before-phase output for "answer is X"-style text.
- A client can send `phase:"after"` while revising a graded FRQ/MCQ. The server then includes `mcqFeedback` and criteria. Today that is limited to what the student has already seen, and the receipt marks the draft coached. Consider getting phase from the server (draft vs graded) instead.
- Only `item.hasStimulusImage` gets the visual refusal. Diagram-kind reference entries and stem-embedded figures are passed through as text only.
- `source.kind === "formula"` renders `body` as TeX. Real formula bodies may be prose with symbol `items`. Not checked against Production data.
- The "More help used · Assisted" notice shows only before submission (`recorded && before`). After grading, the left pane gives no sign the score was assisted.
- The loading `role="status"` node mounts together with its text, so some screen readers may miss it (same pattern fixed earlier on /question). Touch-target size (≥44px) for `qx-link` buttons in the dialog was not checked.
- `pg_advisory_xact_lock('more-help-quota')` serializes every reservation globally. Fine at pilot volume, but a throughput ceiling.
- `has_question_help` errors are swallowed, so a failed receipt read silently hides the Assisted notice.

## Confirmed correct (inspected)

- JWT required (`config.toml`). Context is loaded with the caller's own client through `get_question_experience`. Session, version and ordinal are cross-checked (409 on mismatch). Client grade/key fields are ignored (test present).
- `reserve_question_help`: service-role only, checks ownership + active session + published item + subject + active entitlement. Its per-question lock pairs with the attempt-insert trigger, and `FOR UPDATE` on unsubmitted drafts means no retroactive event on a submitted attempt.
- Subject scope matches on both sides (server uses hyphen keys, which match `topic.subjectKey` in fixtures; client uses canonicalized keys).
- Source IDs are checked against the supplied sources. Model output is length-bounded, rendered as text/KaTeX, not HTML (test covers `<script>`).
- Radix Dialog gives focus trap, Esc and a title. TaskPane stays mounted, so the textarea and draft are kept (test). Single-flight request, and close/reopen keeps the pending result (test).

## Evidence inspected

- Backend PR #435 full diff: `contract.ts`, `handler.ts`, `index.ts`, `model.ts`, `contract_test.ts` (partly), migration `20261014001227_more_help_receipts.sql`, `config.toml`, PR description.
- App PR #21 file patches at 24fd79f: `MoreHelp.tsx`, `more-help.ts`, `more-help.css`, the `QuestionExperience.jsx` hunk, `more-help.test.tsx`, `more-help-interaction.test.tsx`.
- Local main: `QuestionExperience.jsx:1012-1013`, `live-practice-mcq/grade.ts`, `Formula.tsx` `MathText/splitMath`, `question-experience/__fixtures__`.
- Not inspected: docs files in #435, the full `contract_test.ts`, generated types, live Development data.

## Missing tests

- Submit after More help sends `assisted: true` / coached to create_attempt and evaluate-attempt.
- A failed generation leaves the correct receipt/quota state, and a retry reuses the requestId.
- Sanitizer applied to sources, and at most one current-topic hook.
- Highlight inside a LaTeX stem.
- Server ignores `phase:"after"` while a draft exists.
- Reserve vs submit race (SQL-level).
- MCQ path in the interaction test (only FRQ is covered).

## Remaining release gates

1. Real generation succeeds in Development on Calculus AB, Calculus BC and Chemistry items (MCQ + FRQ, before + after).
2. Blocking findings 1-5 fixed, with tests.
3. Owner sign-off on charging assistance when no help is delivered, and on the stylesheet/component exception.
4. Production migration + function deploy, `ALLOWED_ORIGINS`/`OPENAI_*` secrets set, a signed-in end-to-end run on app.cramapple.com, then publish only on explicit owner instruction.
