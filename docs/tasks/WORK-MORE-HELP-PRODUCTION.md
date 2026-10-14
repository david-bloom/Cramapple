# More help — Calculus and Chemistry production work

**Status:** In Progress — conceptual-subpart/validation fixes deployed to Development v7; bounded live verification pending; release blocked
**Owner:** David Bloom / Codex conductor
**Tier:** Hard-Gate
**Priority:** Owner-requested next production slice
**Created Date:** 2026-10-13 (America/New_York)
**Branch:** `codex/more-help-production`
**PR:** https://github.com/david-bloom/Cramapple/pull/435 (backend), https://github.com/david-bloom/ap-prep-blueprint/pull/21 (App)
**Governing design:** [MORE_HELP_DECISIONS_AND_DESIGN.md](../product/MORE_HELP_DECISIONS_AND_DESIGN.md)
**Starting handoff:** [MORE_HELP_SESSION_HANDOFF_2026_10_13.md](../handoffs/MORE_HELP_SESSION_HANDOFF_2026_10_13.md)

**Latest execution:** [Gateway live QA, October 14](../qa/MORE_HELP_GATEWAY_LIVE_QA_2026_10_14.md). Backend PR #435 is merged; app PR #21 remains draft. Two provider calls attempted; Chemistry stopped before invocation. Three expired QA entitlements temporarily extended then restored. Earlier missing-key/no-success checkpoints below are historical.

## October 14 fixes under live verification

David requested fixing the AB subpart disclosure, BC output validation and missing Chemistry live coverage. Backend `9ac7ee3a` is deployed as JWT-verified Development v7. It filters the observed answer-bearing reference before submission, rejects the observed conceptual conclusion patterns, protects each subpart in the model instructions and preserves graded review. Output limits are now explicit in schema descriptions and system instructions; local validation remains mandatory and reports only fixed diagnostic categories. 22 backend tests/typecheck pass. Offline replay of the exact old AB output is rejected. No app changes, migrations or Production changes.

The original BC response was not retained, so its precise root cause is still unproven. Chemistry success remains unverified. A renewed approval request is pending for up to six bounded empty-work QA requests through the same Gateway; do not treat the older three-call approval as unlimited retries. The approved real-app release scope remains unchanged.

## Owner direction and approval state

David requested: “start a cramapple session focused on handoff” and “Student feedback on the mock design and content is very positive. I want to move calculus and chemistry into production”.

This supersedes the previous wait-for-feedback state for production preparation. The positive feedback is David's report about the mock; no individual student quotes, sample size, live-generation success or performance improvement is inferred.

David subsequently confirmed: “add More help to real Calculus AB/BC and Chemistry questions in app.cramapple.com”. This confirms the real-app target and authorizes implementation and the requested production rollout within this work order, after relevant verification. No additional confirmation is required for the same scope. The separate two-question Sites demo remains untouched.

David selected preparation of the demo's Anthropic Gateway path after Claude QA. More help now targets the saved demo's exact gateway endpoint/model; no OpenAI fallback. Gateway key setup is missing and real generation remains unverified. Existing grading provider/secrets are unchanged. David selected targeted explicit pre-submit disclosure checks plus human red-team QA, and separate delivered-help versus attempted-call limits. No key creation, credit purchase or billable model call occurred. Pre-submission help guides setup; post-grade help uses existing confirmed grading, while uncertain results get an honest pending-review error. A durable delivered receipt precedes disclosure and coaches future attempts without changing old grades. Only request/assistance metadata is newly stored.

## Product goal and proposed app scope

Deliver the accepted two-pane More help experience from the current real question, preserving the student's work and existing grade, and make one next scoring action clear.

- MCQ and FRQ entry after grading, and direct entry when the student cannot answer.
- Current question, choices/stimulus and answer remain visible on the left; focused repair and 1–3 checked facts on the right.
- Explain immediately. No diagnostic microquiz or extra “still struggling” entry gate.
- Offer bounded, question-specific follow-ups. Published relevant hooks include their expansion and caution; omit unsuitable hooks.
- Use real question/version identifiers and available checked content, rather than pinning the app to the two demo questions.
- Keep grading authoritative: read existing criterion feedback and repair information; do not regrade with the help model or change a locked grade.
- Start with current-question information and current grading. A broader persistent student-history selection/retention change remains a separate decision; sparse history does not justify a diagnosis.
- Chemistry reference packs cover Units 1–9. Calculus AB packs cover Units 1–3, with BC inheriting AB; do not advertise unsupported later-unit coverage. Determine availability by relevant vetted sources, not subject name alone.

Out of scope: BYOQ changes, subject-launch/entitlement changes, mastery-rule changes, new content generation, unbounded chat, email invitations, payment changes and provider changes beyond the selected More help Gateway adapter, new Site creation and unrelated figure/prose remediation.

## Verified current sources and access

| Surface | Evidence on October 13 |
| --- | --- |
| Canonical backend/docs | `david-bloom/Cramapple` main `6493417d`; handoff PR #430 has landed, so its former branch URL returns 404 |
| Current app source | `david-bloom/ap-prep-blueprint` main `f0fbcdfff1c43bb7bbf4604efab204ad6b86a215`, matching the live Lovable project's latest source commit |
| App editing/publication | Lovable project `56cae479-f7c9-4988-b536-56538c38ee4e`, “New Cramapple App”; published, agent idle. Latest source is not independently a production publication certificate |
| Production backend | Supabase `pcntajvbdfqhbeewmdry`, ACTIVE_HEALTHY; read-only RPC catalog and reference inventory accessible |
| Development backend | Supabase `wmgjsdkphcyhngaffbqf`, ACTIVE_HEALTHY from project listing; no new Development execution yet |
| Reference content | Production confirms AB U1/U2/U3 = 24/17/10 entries (51 total); Chemistry U1–U9 = 26/21/32/22/29/20/21/32/24 (227 total). Earlier parity audit documents BC alias and hooks; this session did not repeat full hash parity |
| Preserved demo | Existing handoff records scripted publication, unpublished saved version 2 and last HTTP 402. Current credits, successful live generation and current Site audience not rechecked |

GitHub connector reads and isolated Git source fetching succeeded. Supabase read-only access succeeded. Lovable read access succeeded; a guessed `src/pages/Question.tsx` path returned 404, then the real source path was located through the canonical report task. No service credentials were printed or copied.

## Technical integration and findings

The app's route is `/question`, implemented in `src/screens/question-experience/QuestionExperience.jsx`. `TaskPane` owns typed FRQ work and MCQ selection; `QxView` owns the aid list and grade presentation. Keep the answer-owning component mounted when opening/closing help, and prevent in-flight or stale help from moving to a different item.

`public.get_question_experience(p_learning_session_id uuid, p_ordinal integer)` is the existing authoritative read model. Read it server-side with the authenticated caller and verify the requested content-version identity. It owns session access and already separates pre-submission question/choices from post-submission MCQ truth, criteria results, repair hints and comparisons. Do not accept client-supplied correct answers, rubrics, subject, references or grades as trusted grounding.

The app already has authenticated TanStack server functions (`requireSupabaseAuth`) and a server-only Lovable AI Gateway adapter. `src/lib/repair.functions.ts` is an existing generation example, not an approved More help endpoint: its client-supplied rubric and grader-style prompt must not be copied as the trust/grade contract. Validate the installed AI SDK and current available model before choosing a generation path. Do not assume the demo's Vercel Gateway credit error applies to the app's separate gateway.

The existing `evaluate-attempt` already emits criterion feedback and a repair plan via `_shared/grading-repair.ts`. Reuse returned grading/repair data when available. Calling a different grading engine merely to explain an already graded answer is unnecessary. Shadow/abstaining symbolic routes do not become authoritative through this feature.

### Release-critical assistance finding

`QxView` currently keeps aid usage in React state and resets it on item changes. `gradeLiveMcq` and `gradeLiveFrq` send that list at submission; `recordAssistanceEvents` then inserts rows using the existing assistance-event contract. `deriveAssistanceState` derives coached status from the persisted count. Simply adding More help to this in-memory list would lose the receipt on reload, and recording only on model completion could lose help already exposed during a failed request.

Before revealing pre-submission help, persist a server-authoritative receipt for the owning student/current question. Connect it to the actual eventual attempt so submission, refresh, revision, request retries and two tabs cannot falsely claim independence. Reuse current aid/event types where semantically valid; review any needed migration explicitly. A same-question retry must retain assistance; a fresh transfer question must not inherit it automatically. Post-submission help must not rewrite the old attempt's independence.

The unanswered Practice path also needs an explicit answer-disclosure contract: the existing rules withhold answer truth before submission. A system prompt alone cannot guarantee a model will not solve the question. Do not silently turn a scored item into an Open Hand item or use `get_open_hand_item` merely to retrieve a key, since that path writes a permanent scoring exclusion. Define and test the permitted help behavior before rollout.

## Implementation sequence and acceptance criteria

1. Destination resolved by owner: real Calculus AB/BC and Chemistry questions in app.cramapple.com. The existing Sites demo stays separate.
2. For the app, finalize the smallest response/assistance/disclosure contract using current-question context. Implement and test the durable receipt and authenticated context boundary before allowing model calls or UI disclosure.
3. Add bounded structured generation: short explanation, one next step, exact known reference IDs (1–3), and a small focused-follow-up set. Reject unknown IDs, malformed output and oversized inputs; bound latency and duplicate calls. Do not fabricate a diagnosis, score, history or published hook. Handle missing grounding honestly.
4. Implement the accepted two-pane template in the existing app, keeping work/grade mounted and preserving stimulus. Desktop side-by-side, phone stacked. Use current semantic tokens, square corners, zero motion and the shared math renderer. The 16px floor applies to the smallest rendered glyph.
5. Verify Development/Preview end-to-end with controlled authenticated fixtures, then obtain fresh independent QA per the operating model. Cover the matrix below; record proposed QA verdict and conductor disposition. No successful live-generation claim from mocked tests alone.
6. Review the exact backend/app publication delta, roll out only the agreed Calculus/Chemistry slice, then run Production smoke checks. Record migration versions, deployed function/app commits, publication ID, verified behavior and rollback evidence. Claim release completion only after actual production evidence.

Required QA:

- MCQ and FRQ: direct unanswered entry, incorrect answer after grading, correct answer after grading, revision, close/reopen and next item.
- Unsaved answer preserved; existing grade unchanged; no fake grading when the student skips.
- Reload/two-tab/retry assistance accounting; no retroactive coaching of a submitted attempt; fresh question remains independent until help is used there.
- Anonymous/foreign-session/version mismatch, unsupported subject, no relevant references, missing figure/transcript, stale response and attempted client grade/key substitution.
- Prompt-injection attempts in focus/answer; unknown source IDs, generated-hook substitution and answer-disclosure contract checks.
- Successful actual generation, timeout/provider failure/insufficient funds, double click, retry, disabled/loading states and preserved work in errors.
- Desktop/phone reading order, keyboard focus and return, overflow, math/reference legibility and no duplicate navigation.

## QA result, risks and Done decision

**Implementation Summary:** Development v5 is active with Claude QA fixes and the prepared Anthropic Gateway adapter; key setup is missing. App remains an unpublished draft PR.
**Test Results:** App 115 files / 1,102 tests, TypeScript and build pass; backend 18 tests/typecheck pass. Role-correct Development SQL passed and rolled back, including permissions, quotas and stale-worker fencing. No successful actual generation.
**QA Result:** Claude proposed FAIL/BLOCKED, identifying a real service-role grant bug. The [disposition](../qa/MORE_HELP_CLAUDE_QA_DISPOSITION_2026_10_13.md) records fixes, owner decisions and evidence limits. Independent follow-up, private app review and human/live generation QA remain pending.
**Done Decision:** Not made. Production remains unchanged; release is held on real generation and QA.

Open risks: delivery/assistance concurrency and real submission paths; semantic answer leakage beyond targeted checks; missing Gateway setup and existing grading API credits; Calculus later-unit grounding gaps; preservation of unsaved work and existing grades; unrelated changes in any publication delta.

## Handoff packet

**Current source:** This work order, product design, preserved artifact bundle, exact backend/app checkpoints above. Branch/PR belongs to this independently reviewable production-preparation slice.

**Approval state:** Real-app destination and subject scope explicitly confirmed. Controlled Development OpenAI payload explicitly approved after the initial automatic-review rejection. No request to publish a new demo, send invitations, purchase credits or change provider credentials has been inferred.

**Do not touch:** Unrelated dirty files in the primary checkout; prior test-account cleanup; auth/payments/email configuration; Sites audience/credits; other subjects or mastery policy.

**Next owner/action:** Supply private app access/snapshot for Claude to run the [requested adversarial review](../qa/MORE_HELP_CLAUDE_ADVERSARIAL_QA_PROMPT_2026_10_13.md). Resolve its findings and the provider/credit blocker, verify actual generation, then complete the authorized production release checks. Do not reconstruct the prior mock or restart broad repository discovery.

**Recommended continuation:** Start with the Claude prompt and the exact current code SHAs below. Preserve answers/grades, respect pre-submission answer disclosure, use vetted references/hooks, and complete Development/Preview plus independent QA before the exact production rollout. The Sites demo is not this implementation target.

**Documentation synchronization:** PR #435 preserves this In Progress work order and restart records on `codex/more-help-production`. Documentation links and whitespace checks pass. No release completion is implied.

**Confirmed scope:** Real-app Calculus AB/BC and Chemistry. Earlier implementation/version/test counts below are historical checkpoints; the latest review checkpoint supersedes them.

## Implementation checkpoint — confirmed app slice

- Owner confirmed real Calculus AB/BC and Chemistry questions in app.cramapple.com. Existing OpenAI connection is reused; the Sites demo is unchanged.
- Added authenticated `more-help` Edge Function: caller-scoped authoritative question RPC, strict structured output, bounded work/focus/context, verified source IDs, no new student-history retrieval or storage, no grade changes. Before submission it guides the setup using answer-free context; after confirmed grading it uses the recorded feedback.
- Development migration `20261014001227_more_help_receipts` is applied and its exact version is committed. Minimal private metadata is reserved before model calls, quota/idempotency and entitlement gates are atomic, and an attempt trigger carries receipts across reloads/future same-question attempts. Existing submitted attempts are unchanged. Existing `topic_hint` policy is reused, with `more_help` as the source.
- Development `more-help` v1 is active, JWT verification enabled. Security advisors were checked; the service-only table has RLS and no client policies by design. No Production migration/function/App release has occurred at this checkpoint.
- App adds a subject-scoped More help dialog directly to the real TaskPane. It preserves the mounted answer field, shows current work/recorded score, uses two panes on desktop and stacks on phones, renders math with the shared renderer, highlights exact stem phrases and displays checked sources/published hooks.
- Backend tests: 8 pass; Deno typecheck passes. App focused tests: 6 files/38 tests pass; TypeScript and build pass. Native DOM tests caught and fixed duplicate sibling React keys. Development SQL transaction verifies existing-draft coaching, future-attempt coaching, submitted-attempt preservation, duplicate/foreign-session/entitlement denial, fresh-session independence and private grants; transaction rolled back.
- A disposable Development-only QA identity and three subject sessions were created for controlled live QA, with credentials held in a private temporary file. They are task-local QA fixtures and must be revoked/cleaned up after verification; the earlier declined test-account cleanup is a different account and remains untouched. No email sent.
- Automatic approval review initially rejected the real-generation test as insufficient authorization for OpenAI transmission. David then explicitly approved sending selected Cramapple-authored question text/published reference facts with empty work fields, and no real student identity/history/work, to the existing OpenAI backend for Development QA. The authorized test is running; no success claim yet.

Remaining before release: actual-generation outcome, independent QA, desktop/phone visual check, exact publication delta and Production rollout/smoke. No new scope approval is needed for this confirmed slice.

## Live-generation result and release hold

The explicitly approved Development QA authenticated the disposable fixture account and invoked the real More help endpoint for one served question in each of Calculus AB, Calculus BC and Chemistry, with empty work/focus. All three returned HTTP 503 `help_unavailable`. A second run after adding non-sensitive provider-code diagnostics established the upstream error: **HTTP 429 `credit_balance_exhausted`** (Development function logs, 2026-10-14 00:20:12–14 UTC / October 13 8:20 PM New York). No successful generation is verified. Do not keep retrying unchanged credit state, silently substitute a scripted response or automatically pay/top up.

Development function v2 is active with the diagnostic-only addition; logs contain status/error code only, not prompts, student work, credentials or provider bodies. Full App suite now passes: **114 files / 1,092 tests**. App PR #21 CI passes. Backend PR #435's test and Vercel checks pass; Vercel Agent Review is pending. Independent read-only source QA was requested through the existing Lovable project's plan-mode review, with no implementation/publication authorization to that reviewer.

Production remains unchanged. Release requires a functioning authorized model connection, successful real-generation QA and the remaining review/visual/smoke evidence. Existing grading/billing/account secrets were not changed in response to the credit failure.

## Latest review checkpoint — October 13

David requested a Claude adversarial code-review QA prompt and questioned API usage versus his subscription. The [standalone prompt](../qa/MORE_HELP_CLAUDE_ADVERSARIAL_QA_PROMPT_2026_10_13.md) reviews backend code `430fe2bda1d279670ea8518ac86d543a16cf3fc2` (PR #435) and app `30a65daed1ee1dd88e74b8f20f904ffffaab410b` (draft PR #21). It includes privacy/authentication, assistance races, real grading paths, answer leakage, content/maths, accessibility and provider/billing architecture. It requests an independent verdict, reproducible findings and explicit infrastructure limits, without deployment or billing actions.

David supplied the original Lovable QA and requested acting on its findings. The [preserved original](../qa/QA_MORE_HELP_LOVABLE_2026_10_13.md) and [remediation disposition](../qa/MORE_HELP_QA_REMEDIATION_2026_10_13.md) distinguish fixed code, residual limits and blocked generation. Additional fixes cover photo preparation/evaluation/retry assistance, one hook even with reused hook IDs, effect-updated status text and server-reported draft context. New tests exercise QxView with real grading helpers and stubbed network for MCQ/typed FRQ, failed-generation independence, reloaded assistance and photo preparation. These do not certify a full authenticated route or live photo evaluation. The task-local disposable QA fixture account remains pending cleanup after a cancelled transaction; unrelated prior test accounts remain untouched.

The earlier Lovable plan-mode review inspected older backend `ad405dc2` and app `24fd79f0`. It proposed FAIL for client assistance propagation, failed-generation coaching/retries, unsanitized copy/excess hooks, math highlighting and live-generation failure. The current source adds client grading propagation, delivery-only server coaching with bounded stable retries, copy sanitization/one relevant hook, intact math segments, and styling in the existing stylesheet. The accepted new template already has owner authorization. These changes still require fresh review; no earlier reviewer verdict is silently overturned.

Development migration `20261014005146_more_help_delivery_commit` is applied under its exact committed filename. It preserves/revokes the old reservation RPC and adds a lease/state/hash delivery contract. Metadata reservation alone no longer coaches attempts. `commit_question_help` marks existing/future unsubmitted attempts only after valid generation and before disclosure; failures permit bounded retries without assistance. Development function v4 is ACTIVE with JWT verification and uses the new RPCs. This update made no model call and does not resolve exhausted credits.

Final local checks: app **115 files / 1,101 tests**, TypeScript and build pass; backend **9 tests** and typecheck pass. Rolled-back Development SQL assertions pass private grants, entitlement/foreign ownership denial, same-receipt retry, duplicate denial, failed-generation independence, existing/future draft coaching, submitted-attempt preservation and fresh-session independence. Desktop/phone screenshots used a scripted local fixture; they do not establish live explanation quality. No Production changes, merge or app publication have occurred.

## Latest checkpoint — Claude findings acted on

The preceding implementation/version/test counts are historical. Current backend code `d2959e596185522e98227a62b73e9b7255ed22f9` and app `172c540d2c67cef90aba3e341f961377d13854ec` address the [Claude report](../qa/QA_MORE_HELP_CLAUDE_ADVERSARIAL_2026_10_13.md); [full disposition](../qa/MORE_HELP_CLAUDE_QA_DISPOSITION_2026_10_13.md) records each finding and the three owner-selected policies. Four exact Development migration versions are now applied: `20261014001227`, `20261014005146`, `20261014014023`, `20261014015127`. Function v5 is ACTIVE with JWT verification. No Production mutation or app publication.

David explicitly authorized executing the initially declined rollback test using the existing QA account. [Runtime SQL](../../supabase/tests/more_help_runtime.sql) passed under service_role, including grants, delivery/fail/retry, current/future coaching, submitted preservation, foreign/entitlement denial, fresh-session independence, generation fencing, failed-versus-delivered allowance and attempt/burst limits. Transaction rolled back. App 1,102 tests and backend 18 tests/typechecks/build pass. No model call was made. Private app source snapshot and follow-up instructions are available locally; source was not published into this public repo.

Next: install an existing server-owned AI_GATEWAY_API_KEY securely in Development, prepare/verify unchanged approved MCQ fixtures there, obtain controlled real-generation/human red-team QA and independent app review, then complete the already authorized release checks. The previous OpenAI credit problem still affects Development grading; More help's new path needs its own working Gateway connection. Disposable QA-account cleanup remains separate/pending; no deletion is inferred from authorization to run its rolled-back tests.
