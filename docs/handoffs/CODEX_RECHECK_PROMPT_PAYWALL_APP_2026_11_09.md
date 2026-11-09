# Codex recheck prompt: paywall app fixes after round-1 QA (2026-11-09)

Paste everything below the line into a Codex session. The author does not QA its own work; do not take the author's word for any "fixed" below.

---

You reviewed the Cramapple 72-hour free-sample app side earlier today and returned three blockers, several should-fix items and the verdict "not ready to request activation approval". Those PRs (app #47, docs #593) had already merged at their first commits, so your review covered stale heads. The fixes are in **app PR #48** (`david-bloom/ap-prep-blueprint`, branch `claude/paywall-sample-app-wiring`) and **docs PR #601** (`david-bloom/Cramapple`, branch `claude/paywall-app-docs-cdd3b5`). Review those branch heads, not main. Report only; change nothing, merge nothing, enable no flag outside Development, and make no Production write. Authority is unchanged: `APPROVAL-0206` (Development/draft), `DECISION-0134`, and `APPROVAL-0207` step A only (Production dark apply done; activation NOT approved).

Backend spec §10.1 now documents the deployed `sample-try` shapes (Cramapple PR #600). Compare the app to the deployed function source and to live Development responses, not to the author's fixtures.

## Verify each claimed fix independently (verified / not fixed / new problem)

1. **Blocker 1, response shape.** App reads `result.try.{question,feedback,status,unit_number}`; `start` token only on `created`; `already_answered` and `register_required` bodies carry stored feedback under `try`. Do the tests use shapes copied from the real function, and would they have failed on the old code? Does a real `start` -> `answer` against Development render?
2. **Blocker 3, claim refusals.** `try_not_found`, `try_not_answered`, `try_claim_expired`, `try_claimed_elsewhere` restart with a new question and clear the token; `not_student`, `already_sampled`, `email_already_sampled`, `not_eligible_prior_*` show the new `unavailable` state with the card-trial offer and no claim of saved feedback. Check every §8 `claim_sample_try` code against the code path, including unknown codes.
3. **Should-fix: lost claim response.** On a non-rule claim failure the app asks `get_sample_access_state` before showing `save_failed`; copy no longer says "no time used". Think about the race: claim committed but state call also fails.
4. **Should-fix: resume.** A served, unanswered try reappears after reload.
5. **Should-fix: focus.** Focus moves to the heading on each state change; check in a real browser at 375px and desktop, keyboard only, plus a screen-reader pass if you can.
6. **Docs.** Email draft now states the grace deadline as fixed 72 hours after expiry and no longer promises uploaded FRQ or unconditional photo; no other doc claims a shipped or verified thing that is not. Check `docs/product/PAYWALL_PRODUCT_OWNER_DECISIONS_2026_11_09.md` (N3 unit counts: re-run `app.sample_unit_availability` read-only on Production and compare 31 eligible / 17 ineligible of 48), the release plan against `APPROVAL-0207`, and the smoke record against what you can reproduce.

## Blocker 2 (still open by design): confirm it is honestly disclosed, do not re-report as new

Not built: FRQ attempt flow (must start a new session via `session_start`, `entry_path:'topic'`, `practice_format:'targeted_drill'`; the imported first-MCQ session returns `409 practice_format_mismatch`), questions 2 to 8 through `student-session-items`, photo-answer flow (Production flags off; decision N12), analytics events, attribution forwarding into checkout, marketing link. Verify instead that **no control implies these work**: the FRQ start is disabled "Coming soon"; Upgrade goes to `/checkout/start` and Parent to `/ask-parent` (both redirect to marketing; offer and attribution are not forwarded); saved-feedback and finish-in-grace go to `/question?session=<learning_session_id>&ordinal=1&type=mcq`. Confirm each of those links actually works for a signed-in sample student in Development, and that buttons with no session are hidden.

## Also check

- Anonymous exposure, token handling (localStorage, never in a URL or analytics) and flag-off 404, as in Prompt 1 of `docs/handoffs/CODEX_QA_PROMPT_PAYWALL_APP_2026_11_09.md`.
- `npx tsc --noEmit`, `npx vitest run` (author reports 1303/1303), `npx vite build`. The `npm ci` lockfile mismatch you found: say whether it exists on main independent of these PRs.
- The shared `cm-card` purple top rule (`--cap-work`) is an app-wide token; judge only whether it contradicts the design rules for this surface and say so as a design note, not a defect in these PRs.

## Output

Ranked findings (blocker / should-fix / note), each verified or inferred with reproduction, what you did not check, and one verdict per PR plus one release verdict: ready to request activation approval / not ready (with the shortest list of what remains). If not ready, separate **missing build scope** from **defects in what exists**.


---

# Addendum (2026-11-09, late): new scope since the recheck above was written

Since that prompt the app (PR #48) gained: later MCQs and the FRQ via the normal practice entry (`/question?mode=practice&type=mcq|frq`, each a new session); sample refusals (`sample:*`, `grading_access:sample_*`, empty queue reason `sample_allowance`) redirect from the shared question experience to `/sample`; two claim-outcome fixes (no card-trial offer after a prior trial; honest "couldn't confirm" message when a claim response is lost). The backend gained migration `20261109171915_paywall_sample_serving_alignment` (applied to Development and, under `APPROVAL-0207` step A.1, to Production, still dark): claim sets the course position to the grant unit, the imported first-MCQ session is format-less, `sample_unit_availability` counts serving-deliverable items and adds `basis`. Production now reads 48 units, 30 eligible (Calc AB Unit 1 ineligible).

Additional checks:
1. **Shared-code safety.** Review the three small edits in `src/screens/question-experience/QuestionExperience.jsx` (imports from `src/lib/sample/refusal.ts`, `fail()`, the graded-failure branch, the end-of-queue branch). Prove they cannot trigger for a non-sample student (codes, strings), and that no existing question-experience test or behaviour changed.
2. **Serving through the app path.** Against Production's functions, read-only (switches are off; do not enable them): for a sample grant in each of a few units (Statistics U1, U3; Physics 2 U10; Physics C E&M U9; Biology U2; Calculus BC U3), reason through or simulate in a rollback-only transaction that claim sets `student_course_positions` and that `select_student_practice_items` for the grant unit returns at least 7 further MCQs and at least one FRQ for a format-null MCQ session and a `targeted_drill` FRQ session. Report any unit where it does not.
3. **Development walk (if you can sign in).** The author ran an API-level signed-in walk (password grant on a throwaway user, since deleted); a real browser walk is still missing. Development has no serving labels, so the unit-gated queue is empty there; say so rather than reporting it as a defect, and verify instead that the typed refusals redirect to `/sample` and `/sample` renders the right state for each phase (active, grace, expired, readonly, unavailable).
4. Confirm the FRQ flow is not offered when `frqRemaining` is 0, that Next question is hidden at `mcqRemaining` 0, and that the upgrade and parent exits are the only unwired-attribution gaps.

Output as before; end with one release verdict and the shortest remaining list. Remember Production activation is still unapproved and the owner decisions N4 (minors' data review), N12 (photo flags), and the Step B approval remain open.
