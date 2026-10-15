# More help — session close and restart

> **Current-state correction, October 15:** start with the [gap catalog](../qa/MORE_HELP_GAP_CATALOG_2026_10_15.md). APPROVAL-0167/0168/0169 record subsequent Production migrations, function deployment and app publication request; APPROVAL-0170 records owner smoke (“More help works”). Fresh checks confirm all four migrations and Production v1/Development v10 with matching nine-file source. This October 14 closeout remains a historical checkpoint; its missing-rollout statements are superseded. Independent/full live QA and the specific fixture/call proposal remain open.

**Date:** 2026-10-14 (America/New_York)
**Session:** Ended at David's request. The production work order remains in progress; no release completion is claimed.
**Task:** [WORK-MORE-HELP-PRODUCTION](../tasks/WORK-MORE-HELP-PRODUCTION.md)
**Next owner:** David Bloom, with the next independent QA session.
**Single best next action:** Run the [updated independent QA prompt](../qa/MORE_HELP_RELEASE_QA_PROMPT_2026_10_14.md) against the merged checkpoints; finish accessible source/local review before the separately authorized live round.

## 1. Current task

Ship the accepted More help experience on real Calculus AB, Calculus BC and Chemistry questions in `app.cramapple.com`, preserving work, recorded grades and assistance rules. The owner reported positive mock feedback and authorized real-app implementation/rollout after verification. The separate Sites demo is outside the current release work.

## 2. Changes and durable checkpoints

| Surface | Checkpoint at close | State verified through GitHub |
| --- | --- | --- |
| Backend code | `8c437bd4d96456e3693fcee067412e532774d1da` | [#442](https://github.com/david-bloom/Cramapple/pull/442) merged at `953640f3aff03eb54c26c766e5c2fdea02c66669` |
| App phase resets and nested-fraction rendering | `e1d49d9ed4ed1be1e14897c6db967f9d49b5042b` | [#25](https://github.com/david-bloom/ap-prep-blueprint/pull/25) merged at `7b81177f1f933ffe16cb4b55ec23fc28b08fcc7f`; CI SUCCESS |
| Browser evidence, remediation and Claude prompt | owner confirmation commit `c6b5d1fabf8f692ae08faf1ad6acd48ed8689a42` | [#448](https://github.com/david-bloom/Cramapple/pull/448) merged at `c06860b3cbe8c862ff1cb382a2699969bb74173a`; checks SUCCESS |

At close, backend/docs `origin/main` was `b82b214c`; app `origin/main` was the #25 merge above. Concurrent unrelated changes are preserved. Merged PRs do not prove app publication or Production runtime deployment.

Confirmed backend findings addressed across the remediation: whole-visible-source screening; targeted explicit choice/key/verdict checks; legitimate-setup false-positive fixes; sibling average-rate wording and supplied rate conclusions; separate delivered-help/attempt accounting and generation fencing. App fixes preserve cached/pending help across scoring and reset answer-control state without remounting help. Original Claude reports are unchanged. Exact N1–N4/F1–F6 dispositions and remaining semantic limitations are in [the remediation](../qa/MORE_HELP_RELEASE_QA_REMEDIATION_2026_10_14.md).

The latest browser pass found innermost nested fraction digits at 11.7px. More help now opts into KaTeX display-sized fractions, measuring 23.4px in the tested expressions; ordinary scripts/default rendering elsewhere retain their behavior. David subsequently confirmed: “Confirmed it renders correctly!” Owner visual acceptance is recorded, without inferring an unspecified environment/version.

## 3. Verified evidence

- Backend: prior checkpoint's 26 tests and Deno typecheck pass. Development more-help v10 was ACTIVE with JWT verification enabled; all nine returned source/dependency files matched the upload byte-for-byte. Bundle SHA-256 `20c84b8c4dd2a2f1c81b1f4473f7d9dedc5b9c50f3a89e30884357b18d3a6aee`. Not redeployed or re-queried during the final UI/documentation pass.
- App at `e1d49d9`: `vitest run` **119 files / 1,144 tests pass**, `tsc --noEmit` passes, `npm run build` passes. Focused formula/More help tests: 40 pass. GitHub #25 CI also passed.
- Actual local browser components at measured 1280/375 CSS px: typed/revised work preservation, pending help surviving scoring, comparison/draft/choice/photo-control resets, recorded score display, focus trap/Escape/return, no horizontal overflow and measured fraction glyph sizes. **Help transport, scoring and photo callbacks were mocked**. See [browser report and screenshots](../qa/MORE_HELP_BROWSER_QA_2026_10_14.md).
- Earlier live producer QA delivered three empty-work, unanswered FRQ explanations, one per subject, through Anthropic via Vercel Gateway. QA entitlements restored. This does not cover MCQs, partial work, graded/revision states or the real grading/photo pipeline.
- Documentation links and `git diff --check` pass. Original Claude follow-up SHA-256 remains `3b54e9519cc9814954f4cc1b0287c9e15cfeb113d4b475717a151d22426e3505`.

## 4. Open work, blockers and risks

1. Fresh independent verdict on merged code, then human reading of real generated outputs. The original FAIL reports concern earlier checkpoints and are not superseded by a new independent PASS. Numeric paraphrases and broader Chemistry/MVT conceptual disclosures remain human-dependent under the settled policy.
2. Development previously had zero published MCQs for these subjects. The pinned unchanged three-MCQ mirror, QA session/entitlement writes/restoration and at-most-12-call Gateway round are prepared in the remediation but **not executed or separately approved**. Recheck inventory, exact authorization and remaining budgets before dependent writes/calls.
3. Authenticated subject × question type × phase coverage, real submission/revision/refresh/two-tab behavior, served-content glyph measurements and actual grading/photo availability. Local simulations and owner visual acceptance do not establish these results.
4. Production rollout after relevant QA: four migrations (`20261014001227`, `20261014005146`, `20261014014023`, `20261014015127`), exact More help bundle/JWT/origin/Gateway configuration, exact app publication and signed-in smoke/rollback verification. Last read-only Production inspection found no More help function or these migrations; this was not rechecked at session close.

Release remains **NOT READY**. No new provider call, database write, secret, purchase, deployment or app publication occurred in the latest browser/remediation/documentation pass.

## 5. Approval state

Owner decisions persist: target explicit disclosure plus human red-team QA; separate delivered-help allowance from attempted-call limits; use the existing Vercel Gateway/Anthropic help path. Do not reopen these decisions or buy credits/create keys by default.

The specific Development fixture-write and 12-call questions remain unanswered. Existing earlier empty-work FRQ approvals do not authorize leading synthetic work/focus, new fixture writes or an unbounded run. Establish authorization for the concrete proposal before executing it. Rollout authorization exists for the real-app scope after relevant verification; remaining QA is an evidence gate, not a request to repeat the same rollout permission.

Separate grading experiment: [PR #445](https://github.com/david-bloom/Cramapple/pull/445) is merged. Its renewed 54-call allowance was fully spent (one direct-API failure plus 53 valid Gateway results); it supplies no More help allowance. TASK-0074's later disposition is in current main and must govern any grading follow-up. No grading-provider deployment was performed by the More help UI pass.

## 6. Files and local state

Canonical restart reads, in order: `docs/INDEX.md`, this closeout, the work order, the remediation, browser evidence and updated independent QA prompt. Preserve both original independent reports. The October 13 handoff remains historical context, not current runtime state.

Local checkouts:

- `/private/tmp/cramapple-more-help-production`: session-close branch `codex/more-help-session-close-2026-10-14`, based on current `origin/main`; documentation only.
- `/private/tmp/cramapple-more-help-app`: clean `codex/more-help-followup-fixes` at `e1d49d9`; merged into `origin/main` at `7b81177`.
- `/Users/davidbloom/Documents/Cramapple.nosync`: unrelated primary working changes preserved; do not overwrite/reset them.
- `/private/tmp/cramapple-more-help-browser`: local synthetic fixture, outside both repositories. Owned Vite session stopped and temporary browser tab closed; viewport override reset. Screenshot evidence is committed under `docs/qa/assets/more-help-browser-2026-10-14/`.

Do not touch the separate Sites demo, unrelated TASK-0073/74/75 work, real student data, Production resources or existing provider configuration merely to resume documentation/independent QA. Never commit private question exports, credentials, raw model logs or private app source into the public docs repo. Do not reuse exhausted grading-call authorization or claim authenticated evidence from mock responses.

## 7. Restart prompt

> Resume More help from `docs/handoffs/MORE_HELP_SESSION_CLOSE_2026_10_14.md` on current GitHub main. Read the index and task/QA links there. App #25, backend #442 and docs #448 merged; David confirmed correct rendering. Verify current heads/deltas, then run the independent QA prompt against the merged code. Preserve original reports and unrelated work. Treat local mocked browser evidence separately from authenticated/live coverage. The concrete Development MCQ-fixture and 12-call plan remains unapproved; complete accessible review and establish its exact authorization before dependent writes/calls. Do not deploy or spend another grading allowance as a substitute. Return the independent verdict and smallest remaining release checklist.
