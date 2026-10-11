# UX Challenge QA — Session Close

DATE: 2026-10-11
AUTHOR: Codex
SCOPE: Closeout of the October 8 Open Hand/Practice and Student Hub independent QA session. This is a handoff record, not new QA acceptance.

## 1. Current work

Independent UX challenge QA of Open Hand/Practice (PR #380) and Student Hub (separate PR #381 requested by David). Session ends here; no new implementation or live-system work was performed during closeout.

## 2. What changed in this session

- Added `docs/qa/QA_OPEN_HAND_PRACTICE_CHALLENGE_2026_10_08.md` and its index entry to PR #380.
- Created PR #381 with `docs/qa/QA_STUDENT_HUB_CHALLENGE_2026_10_08.md`, 15 findings, comparison with Fable, proposed student-facing guidance, priorities and an acceptance matrix; indexed it.
- Closeout re-read current GitHub records rather than treating the earlier draft PR states as current.

## 3. Verified at closeout

GitHub metadata confirms both PRs are merged:
- [#380](https://github.com/david-bloom/Cramapple/pull/380): merge commit `2bf8557f01e3afaa27d7b2e6ccef53db693293fe`.
- [#381](https://github.com/david-bloom/Cramapple/pull/381): merge commit `efcb9044331e4fea4ab1d312118af0ddc6a47efc`.

PR #381 now contains the consolidated Sol/Fable plan. The original challenge report is an evidence record, not the current implementation plan.

Current governing handoff:
- [Consolidated plan](../qa/QA_STUDENT_HUB_CONSOLIDATED_PLAN_2026_10_08.md): proposal with owner decisions in §5, DECISION-0103.
- [Slice 1 execution](STUDENT_HUB_SLICE1_EXECUTION_2026_10_08.md): records Lovable `a509b7d7e722cdb871a85b614bd6c19b50ecde9c`, frontend fixes and owner-confirmed live “Studying” heading on October 8. It reports 755 tests, typecheck and build passing; these were agent-reported results, not rerun here. Signed-in behavior remains unverified in that record.

This closeout did not independently confirm the current deployed SHA or re-test production.

## 4. What remains open

- Independent re-QA of slice 1, especially subject-scoped evidence, save-on-change race/failure behavior, stale-topic clearing, topic-level availability and consistent unit-wide scope.
- Signed-in desktop/mobile screenshots and behavior, long lesson names, 200% zoom, notes keyboard/focus/stacking behavior, console and necessary network requests.
- First-use student comprehension and route differentiation.
- Later slices: first-use copy/layout; shelves, accessibility and recovery.
- Open Hand/Practice on-screen validation and assistance attribution per its execution record. Do not assume every October 8 finding remains unchanged after subsequent fixes.

## 5. Blockers and risks

The original assessment could not access an authenticated student session. No signed-in visual Pass was issued. A merged QA document or passing reported unit tests is not production experience certification. Newer source must be checked before reproducing or reopening old defects.

Slice 1 record calls out: failed saves leave a visible draft while doors use the saved lesson; “Saved” may remain visible after subject switching; unknown unit-level teaching availability can route to Practice. Include these in re-QA.

## 6. Files and systems checked

During assessment: mounted hub components, HomeStudyActions, HomeV2, home.functions, home-snapshot, entry/session/content adapters, overlay and responsive CSS at Lovable `d5adcbc6`; relevant read-only deployed delivery/content contracts documented in the challenge report.

During closeout: session-start protocol, close-session prompt, collaboration rules, current PR metadata for #380/#381, docs index, consolidated hub plan and slice 1 execution record.

No application, schema, secrets, payment, deployment or Production data writes in this Codex QA session.

## 7. Commands / tests and results

- Actual home-snapshot helpers executed with Node TypeScript stripping: other-subject attempts yield personalized if passed unscoped; active-pack filtering correctly yields new; guided-only work yields zero qualifying evidence; three attempts on one item do not qualify for recommendations. These tested the older inspected source, not the newer implemented slice.
- Report and index remote reads verified their committed contents when created.
- Closeout `git status --short`: not a Git repository in the scratch workspace. No local checkout to commit or synchronize; retained inspection files are temporary evidence, not unique project edits.
- Current GitHub PR reads confirm both deliverables merged.

## 8. Approval state

QA/documentation only from this agent. No final Pass, Done decision, launch approval or risk acceptance. DECISION-0103 governs the consolidated plan's five owner choices; do not reopen them based on the original report. Slice 1 execution/publication was separately owner-authorized as recorded by Fable. Broader implementation and release retain their normal approval boundaries.

## 9. Exact next owner and action

**Next owner:** David for an authenticated student walkthrough or accessible test session; Codex/Sol for independent re-QA.

**Single best next action:** complete slice 2 against a freshly identified current frontend checkpoint, then independently check slice 1's behavior. Use desktop, 390px and 320px, Stage A with/without a saved lesson, Stage B, notes open, long names and 200% zoom. Record source SHA and distinguish observed behavior from source inference.

Restart prompt:

> Resume Student Hub QA from the consolidated plan and slice 1 execution record. Re-read current GitHub approvals/decisions and identify the current Lovable/deployed checkpoint. Independently verify slice 1 and perform signed-in slice 2. Credit landed fixes; report new/residual defects with evidence. Do not implement or publish without the applicable authorization.

## 10. Do not touch

Do not revive the merged task branches, delete user data, change schema/grading/content, alter secrets/payments, publish, or issue final QA acceptance as part of this handoff. Do not treat the original dismissible-panel proposal as decided: DECISION-0103 chose non-dismissible Stage A guidance, absent on Stage B.

This closeout is durable on its PR branch once the remote verification succeeds; promotion to main is separate.
