# More help — independent release QA prompt

**Follow-up checkpoint:** The [first release report](QA_MORE_HELP_RELEASE_2026_10_14.md) is preserved. Review [the current remediation](MORE_HELP_RELEASE_QA_REMEDIATION_2026_10_14.md) and exact new backend/app code there. Challenge F1 whole-source scanning, F2 wider tripwires, F3 sibling phrasings, F4 explicit fresh-request/cached-response behavior and F5 grading-transition lifetime. Development is now v10; 26 backend / 1,142 app tests pass. Review the preserved Claude follow-up report and N1–N4 remediation, especially setup false positives and answer-control resets alongside pending help. The pinned MCQ mirror and 12-call round are proposals, not authorizations or executed evidence. Write a new follow-up report rather than overwrite the first.

**Date:** 2026-10-14 (America/New_York)
**Purpose:** Independent follow-up review of the draft remediation and remaining release gates. Paste the prompt below into Claude Code, or into Lovable plan mode with access to both repositories. This document does not dispatch a reviewer or authorize deployment.

---

Run an independent, adversarial follow-up release QA pass for **More help on real Calculus AB, Calculus BC and Chemistry questions in app.cramapple.com**. Determine whether the draft remediation fixes Claude's confirmed defects and whether it is ready to merge and release. Challenge producer evidence; do not repeat the author's verdict or treat passing unit tests as an end-to-end certificate.

## 1. Review the exact current code

| Surface | Remediation checkpoint | Relevant PRs |
| --- | --- | --- |
| Public backend/docs, `david-bloom/Cramapple` | branch `codex/more-help-release-remediation`; backend code `8c437bd4d96456e3693fcee067412e532774d1da`; reviewed base `70f4a3485916f7ca65e4a6f60c29fed92d92c370` | [#442](https://github.com/david-bloom/Cramapple/pull/442), open; #435/#439 merged |
| Private app, `david-bloom/ap-prep-blueprint` | branch `codex/more-help-followup-fixes`; integrated app code `c5c26997ea1f378cb4aba8b1741165f21d8703a6`; current main base `2563209751c618e52aa69ccc392ea1d9ecf780e2`; phase-reset change `d5ba602e` | [#25](https://github.com/david-bloom/ap-prep-blueprint/pull/25), draft; #21/#23/#24 merged |

Verify current PR and main heads. If they advanced, review the relevant delta and state exactly which commits your verdict covers. Start with each remediation diff against the reviewed base, then trace its interaction with the merged feature. Documentation-only commits can follow the pinned code checkpoint. Do not review only main or an old Lovable base.

Local checkouts: `/private/tmp/cramapple-more-help-production` and `/private/tmp/cramapple-more-help-app`. Preserve unrelated dirty work in `/Users/davidbloom/Documents/Cramapple.nosync`. The public docs repo must not receive private app source, credentials or full authored/generated question artifacts. If private GitHub access is unavailable, use the separately supplied local app snapshot described in the disposition, verify its manifest/hash and review the subsequent merge delta. If source remains inaccessible, mark app review BLOCKED and continue accessible work.

Follow session-start and AGENTS instructions. Route through `docs/INDEX.md`; read only relevant sections of:

- `docs/tasks/WORK-MORE-HELP-PRODUCTION.md`
- `docs/product/MORE_HELP_DECISIONS_AND_DESIGN.md` and current architecture/design rules
- `docs/qa/QA_MORE_HELP_LOVABLE_2026_10_13.md` and `QA_MORE_HELP_CLAUDE_ADVERSARIAL_2026_10_13.md` — preserved original failures
- `docs/qa/MORE_HELP_CLAUDE_QA_DISPOSITION_2026_10_13.md`
- `docs/qa/QA_MORE_HELP_RELEASE_2026_10_14.md` — original Claude FAIL report, preserved unchanged
- `docs/qa/QA_MORE_HELP_RELEASE_FOLLOWUP_2026_10_14.md` — Claude follow-up FAIL/N1 report, preserved unchanged
- `docs/qa/MORE_HELP_RELEASE_QA_REMEDIATION_2026_10_14.md` — F1–F6 disposition and exact proposed fixtures/calls
- `docs/qa/MORE_HELP_GATEWAY_LIVE_QA_2026_10_14.md` and `MORE_HELP_GATEWAY_FIX_QA_2026_10_14.md` — failed first run and subsequent producer verification

Older draft/missing-key/no-generation statements are historical. Verify live state instead of treating them as current. Avoid broad scans of research, teaching, prompts, worktrees, dependencies, logs or generated data.

## 2. Establish environment and evidence limits first

Last verified October 14:

- Development Supabase: `wmgjsdkphcyhngaffbqf`, more-help v10 ACTIVE, JWT verification enabled, bundle SHA-256 `20c84b8c4dd2a2f1c81b1f4473f7d9dedc5b9c50f3a89e30884357b18d3a6aee`, deployed from backend code `8c437bd4…`. Independently verify bundle/source correspondence where tooling permits; metadata alone is not that proof. The producer subsequently compared all nine returned deployed source files byte-for-byte with the v10 upload graph; independently repeat this comparison.
- Four Development migrations: `20261014001227`, `20261014005146`, `20261014014023`, `20261014015127`. Their committed filenames must match the ledger.
- Production Supabase: `pcntajvbdfqhbeewmdry`. Read-only checks found **no More help function and none of these four migrations**. Secret names `AI_GATEWAY_API_KEY` and `ALLOWED_ORIGINS` are present; presence does not prove valid values or working access. Never print values.
- Lovable app project: `56cae479-f7c9-4988-b536-56538c38ee4e` was last observed published/ready with source `75c0b18…`. The app remediation is a draft PR and has not been published. Determine the actual source/environment of any browser page tested.
- Current producer regressions: 26 backend tests/typecheck and 119 app test files / 1,142 tests, typecheck and build passed. Original role-correct rolled-back SQL verified permissions, delivery/failure/retry, stale-worker fencing, current/future draft coaching, submitted preservation, foreign/entitlement denial and exact delivery/attempt quota boundaries; it was not rerun against a database during this remediation.
- Three real **unanswered FRQ** Gateway calls returned 200 for AB, BC and Chemistry; each has one delivered receipt and one attempted call. The observed AB conceptual answer was absent after the fix. All three had **empty work/focus and no existing draft**. They do not prove MCQ, after-grade, revision, real submission/photo or browser behavior.
- Development's last inventory had no published MCQs for these subjects. Confirm current inventory. If absent, identify a minimal unchanged mirror of approved Production MCQs and its serving/label prerequisites; prepare the fixture plan without publishing or changing bank content.
- Existing grading still uses its separate OpenAI connection. Its earlier credit failure was not retested by the successful Gateway help calls. Verify grading availability separately; do not assume the Gateway key fixes it.

Keep source inspection, mocks, authenticated browser observations, actual model outputs and Production evidence distinct. Missing deployment is a release gate, not automatically a code defect.

## 3. Respect the settled contract

The accepted help template keeps the question, stimulus, work and existing grade visible. Desktop uses two panes; phones stack them. Explain immediately, then one manageable next action, 1–3 relevant published facts, at most one relevant published hook, and bounded follow-ups. Preserve work during open/close/loading/error/next-item transitions. Do not reopen the accepted template/component decision as a new approval gate.

Before submission, guide setup without supplying an answer/key or complete rubric-earning response to **any individual subpart**, including conceptual explain/justify parts. After authoritative grading, explain the recorded feedback without regrading or changing a locked result. Server-reported drafts force before-phase context; uncertain results fail honestly.

David chose **targeted explicit disclosure checks plus human red-team QA**, not blanket equality against every choice text/numeric answer. The remediation scans every visible source field for the broadened average-rate rule and rejects the five plain verdict/elimination/numeric-conclusion examples. Challenge sibling phrases, follow-ups, given-value false positives and MVT/Chemistry conceptual subparts. Broader semantic protection remains human-dependent; do not infer a universal classifier.

Delivered help coaches current/future unsubmitted attempts on the same served question, including refresh/two tabs. Failed/refused help does not coach and releases delivered-help allowance; attempted calls remain limited. Submitted attempts and fresh questions retain their previous independence.

Runtime: Vercel Gateway Chat Completions, `anthropic/claude-haiku-5.5`, strict schema/local validation, 2,500 output tokens, reasoning effort none, 35-second timeout, no OpenAI fallback. Quotas: 30 delivered/user/rolling 24h; attempted calls 6/minute, 90/user/24h and 1,000/site/24h. Keep grading configuration separate.

## 4. Test the release-critical matrix

For **each subject**, cover both **MCQ and typed FRQ** in unanswered, wrong/partial graded, correct graded and revision states. Mark unavailable cells BLOCKED with the exact prerequisite; do not replace them with an unrelated subject or fabricated successful output.

| Test area | Required evidence and expected behavior |
| --- | --- |
| Real help flow | Authenticated question → More help → grounding → actual validated response → durable receipt → rendered explanation. Check facts/math against the question and sources, not just HTTP/schema validity. |
| Pre-answer red team | Conceptual subparts beyond the narrow rate pattern; numeric/choice questions; requests for the answer/rubric; malicious focus/work; answer-bearing source titles/bodies/hooks/cautions. Given values and legitimate setup remain usable. Check the entire rendered help/reference list. |
| Grade/assistance integration | Submit after help through actual MCQ, typed FRQ and photo/hand-drawn preparation/evaluation/retry paths. Verify attempt state, assistance events, evaluate-attempt context and independent-evidence flags agree. No duplicate ordinary hint and no changed locked grade. |
| Persistence/races | Close/reopen, edited work, refresh, two tabs, late receipt reads, item changes, reserve-versus-submit race, expired lease, stale worker, duplicate/request-conflict, lost response and retry exhaustion. No stale help on another question or premature assistance on failure. |
| Errors and authority | Anonymous/foreign/ended sessions, version/ordinal mismatch, missing entitlement, unsupported subject, absent grounding/visual context, uncertain grade, malformed/overlength output, refusal, timeout, provider/budget failure and commit failure. No helpful content before authorized durable commit; honest recovery and preserved work. |
| Desktop/phone/accessibility | Test actual mounted TaskPane; question/stimulus/work/grade preservation, reading order, keyboard focus/Escape/return, live announcements, ≥44px targets, overflow, square corners, no motion, safe copy and intact math. Measure the smallest readable glyph against the governing 16px rule. |

Use synthetic QA work and the task QA account via its secure mechanism. Confirm the app under test uses Development before creating records or invoking generation. If a preview points at Production, do not use it to bypass Development gaps. Local reversible fixtures may probe failures/races, but label their evidence as simulated. Never alter real students' records or call Open Hand merely to retrieve hidden answers, since that can permanently affect scoring eligibility.

## 5. Inspect implementation and reproduce defects

Backend: `supabase/functions/more-help/{index,handler,contract,model,diagnostics,contract_test}.ts`, four More help migrations, `supabase/tests/more_help_runtime.sql`, config and the authoritative question/grading/assistance dependencies.

App: `src/components/session/MoreHelp.tsx`, `src/lib/more-help.ts`, `src/screens/question-experience/QuestionExperience.jsx`, `src/screens/parts/FrqPhotoPanel.jsx`, `src/styles/question-experience.css`, More help tests and real grading helpers.

Reproduce all six N1 legitimate setup strings from the preserved follow-up report; they must pass while the original five disclosures fail. Check case, word boundaries, labelled/parenthesized choices and generated follow-ups. Mount same-question practice → review → practice transitions: comparison answers default closed after scoring, draft/choice controls reset, photo availability resets and pending More help remains accessible. Keep local simulated checks distinct from signed-in browser observations.

Specifically challenge invoker runtime privileges under service_role, client/RPC grants, generation fencing, allowance-versus-attempt accounting, sanitized copy/allowlisted metadata, one-hook selection, math spans and content-free diagnostics. Owner-role SQL is insufficient for runtime permissions. Do not add SECURITY DEFINER merely to bypass a missing grant.

Run existing checks if dependencies are available: backend `deno test supabase/functions/more-help/contract_test.ts` and `deno check supabase/functions/more-help/index.ts`; app `node_modules/.bin/vitest run`, `node_modules/.bin/tsc --noEmit`, `npm run build`. Prefer a small reproducer that fails for the alleged defect over tests mirroring implementation. Do not install new infrastructure, weaken security or make a load-testing project to obtain a green result.

## 6. Bound the review; produce a concrete release decision

This is **QA, not implementation or deployment**. Do not edit implementation, merge, apply migrations, publish, change secrets/providers/billing, send messages or clean up accounts. Local temporary fixtures and documentation/report writing on an isolated review branch are allowed. Read-only Production checks may verify deployment metadata, not student records.

This prompt supplies no new paid-call or database-write authorization. Earlier live approvals covered specific bounded empty-work FRQ requests. Before additional model/graded/photo calls or fixture writes, establish the exact existing authorization and remaining call budget. If unavailable, prepare a minimal concrete plan specifying fixtures, provider/payload, call ceiling and restoration, then mark dependent tests BLOCKED. Continue all accessible source/local/output review. Do not launch an unrelated paid evaluation pipeline or ask for credentials in chat.

Return:

1. **Code readiness:** proposed PASS / FAIL / BLOCKED, exact backend/app SHAs and environments tested. **Release readiness:** READY / NOT READY, separately justified.
2. Findings P0–P3 with verified file/line, reachable trigger, expected/actual behavior, impact, reproducible evidence, smallest fix and meaningful regression. Separate confirmed defects from hypotheses and access gaps.
3. A compact subject × type × phase coverage matrix, with observed-live / local-simulated / source-only / blocked labels. Identify which earlier findings are fixed, partially covered or still open. List which outputs require human judgment and whether that judgment actually occurred.
4. The **minimum ordered release checklist**: remaining QA, verified MCQ/grading prerequisites, four Production migrations, exact Edge bundle/JWT/origin/Gateway setup verification, exact app publication version and delta, signed-in Production smoke and a workable rollback plan. Do not call an old unfenced function-only redeploy a working rollback.
5. Separate mandatory release gates from later work such as pilot lock scaling, broad load certification or test-account cleanup. Do not make recovery of the lost original BC response a blocker when current behavior has been verified.

Save the new report as `docs/qa/QA_MORE_HELP_RELEASE_FOLLOWUP_2_2026_10_14.md` on an isolated review branch (use a later date or suffix if that file already exists), or return the complete report if repository writing is unavailable. Preserve both `QA_MORE_HELP_RELEASE_2026_10_14.md` and `QA_MORE_HELP_RELEASE_FOLLOWUP_2026_10_14.md` byte-for-byte. Do not publish private app source/full authored outputs. Do not claim a release occurred because PRs merged, CI passed or a project reports published.
