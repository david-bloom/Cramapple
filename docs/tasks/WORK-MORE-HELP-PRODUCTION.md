# More help — Calculus and Chemistry production work

**Status:** In Progress — confirmed real-app implementation and production release
**Owner:** David Bloom / Codex conductor
**Tier:** Hard-Gate
**Priority:** Owner-requested next production slice
**Created Date:** 2026-10-13 (America/New_York)
**Branch:** `codex/more-help-production`
**PR:** https://github.com/david-bloom/Cramapple/pull/435 (backend), https://github.com/david-bloom/ap-prep-blueprint/pull/21 (App)
**Governing design:** [MORE_HELP_DECISIONS_AND_DESIGN.md](../product/MORE_HELP_DECISIONS_AND_DESIGN.md)
**Starting handoff:** [MORE_HELP_SESSION_HANDOFF_2026_10_13.md](../handoffs/MORE_HELP_SESSION_HANDOFF_2026_10_13.md)

## Owner direction and approval state

David requested: “start a cramapple session focused on handoff” and “Student feedback on the mock design and content is very positive. I want to move calculus and chemistry into production”.

This supersedes the previous wait-for-feedback state for production preparation. The positive feedback is David's report about the mock; no individual student quotes, sample size, live-generation success or performance improvement is inferred.

David subsequently confirmed: “add More help to real Calculus AB/BC and Chemistry questions in app.cramapple.com”. This confirms the real-app target and authorizes implementation and the requested production rollout within this work order, after relevant verification. No additional confirmation is required for the same scope. The separate two-question Sites demo remains untouched.

Implementation uses the existing grading backend and OpenAI connection. No new provider, billing change or credential is needed. Pre-submission help uses answer-free context and guides the setup; post-grade help uses the existing recorded grade. A durable receipt precedes disclosure and coaches future attempts on the same served question without changing old grades. Help text and unsaved work are not newly retained in the database; only request/assistance metadata is stored with the owning session/account.

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

Out of scope: BYOQ changes, subject-launch/entitlement changes, mastery-rule changes, new content generation, unbounded chat, email invitations, payment/provider changes, new Site creation and unrelated figure/prose remediation.

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

1. Resolve the destination. If the answer is the live demo, follow the existing Sites handoff and current Sites skill; this app integration proposal does not apply. Preserve project identity and audience, and verify one successful real generation before publication.
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

**Implementation Summary:** None yet; source/live-state audit and production work order prepared.
**Test Results:** Read-only checks above; no application tests or successful generation run in this session.
**QA Result:** Not assessed; no independent implementation QA yet.
**Done Decision:** Not requested or made. The production feature is unbuilt.

Open risks: destination ambiguity; durable pre-submission assistance; answer-disclosure boundary; unverified current model/gateway connection; Calculus later-unit grounding gaps; preservation of unsaved work and existing grades; unrelated changes in any publication delta.

## Handoff packet

**Current source:** This work order, product design, preserved artifact bundle, exact backend/app checkpoints above. Branch/PR belongs to this independently reviewable production-preparation slice.

**Approval state:** Positive mock feedback and production direction recorded. Exact destination unanswered; no live mutation authorized on an inferred target. No request to publish a new demo or send invitations has been inferred.

**Do not touch:** Unrelated dirty files in the primary checkout; prior test-account cleanup; auth/payments/email configuration; Sites audience/credits; other subjects or mastery policy.

**Next owner/action:** David answers the already-presented app-versus-demo scope question; Codex continues the appropriate implementation path using these verified seams and completes the release checks. Do not reconstruct the prior mock or restart broad repository discovery.

**Recommended implementation prompt:** Continue WORK-MORE-HELP-PRODUCTION using David's confirmed destination. For the app, implement the durable assistance and authoritative context contract first, then the accepted two-pane template and bounded generation. Preserve answers/grades, respect pre-submission answer disclosure, use vetted references/hooks, and complete Development/Preview plus independent QA before the exact production rollout. For the demo, use the saved existing Sites project/version and verify current access/real generation without changing audience or paying automatically.

**Documentation synchronization:** PR #435 preserves this In Progress work order and restart records on `codex/more-help-production`. Documentation links and whitespace checks pass. No release completion is implied.

**Confirmed next action:** Codex implements and verifies the real-app path for Calculus AB/BC and Chemistry; the destination question is resolved. Prior references below to an unanswered destination describe the orientation checkpoint.

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
