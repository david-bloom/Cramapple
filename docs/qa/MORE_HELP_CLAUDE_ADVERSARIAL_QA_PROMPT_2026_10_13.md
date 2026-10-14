# Claude prompt — adversarial More help QA

Paste the prompt below into a fresh Claude Code session. It is a review request, not an implementation or deployment request.

---

Run an independent adversarial code-review-style QA pass on Cramapple's proposed **More help** feature for real Calculus AB, Calculus BC and Chemistry questions in **app.cramapple.com**. Find concrete ways this implementation can violate its contract. Do not assume the author's tests, summaries or claimed fixes establish correctness.

## Exact review targets

Review both repositories together; the feature depends on their combined behavior.

| Repository | PR | Code checkpoint | Comparison base |
| --- | --- | --- | --- |
| `david-bloom/Cramapple` (backend/docs) | https://github.com/david-bloom/Cramapple/pull/435 | `430fe2bda1d279670ea8518ac86d543a16cf3fc2` | `6493417dd5b676827d78d80109763d60dbfb7d53` |
| `david-bloom/ap-prep-blueprint` (app) | https://github.com/david-bloom/ap-prep-blueprint/pull/21 | `30a65daed1ee1dd88e74b8f20f904ffffaab410b` | `f0fbcdfff1c43bb7bbf4604efab204ad6b86a215` |

Local checkouts, if available: backend `/private/tmp/cramapple-more-help-production`; app `/private/tmp/cramapple-more-help-app`. The primary `/Users/davidbloom/Documents/Cramapple.nosync` checkout contains unrelated dirty work; preserve it. Verify each checkout/remote head before reviewing. If a PR has advanced, identify the new SHA and review its delta as well. State precisely which SHAs your verdict covers.

Follow the applicable session-start and AGENTS instructions. Route documentation searches through `docs/INDEX.md`, then read the task-relevant sections of:

- `docs/tasks/WORK-MORE-HELP-PRODUCTION.md`
- `docs/qa/QA_MORE_HELP_LOVABLE_2026_10_13.md` (preserved original findings) and `docs/qa/MORE_HELP_QA_REMEDIATION_2026_10_13.md` (producer disposition; independently challenge it)
- `docs/product/MORE_HELP_DECISIONS_AND_DESIGN.md`
- `docs/handoffs/MORE_HELP_SESSION_HANDOFF_2026_10_13.md` (historical demo, plus later app direction)
- The app's AGENTS instructions and existing question-page QA rules.

Do not broadly scan research, teaching, prompts, temporary/generated directories, worktrees, model-call logs or corpora. Inspect changed files first, then follow only relevant dependencies.

Backend focus: `supabase/functions/more-help/{index,handler,contract,model,contract_test}.ts`, `supabase/config.toml`, `supabase/migrations/20261014001227_more_help_receipts.sql`, and `supabase/migrations/20261014005146_more_help_delivery_commit.sql`. Follow the existing authenticated question RPC, assistance rollup, grading and repair contracts as needed.

App focus: `src/components/session/MoreHelp.tsx`, `src/lib/more-help.ts`, `src/screens/question-experience/QuestionExperience.jsx`, `src/styles/question-experience.css`, `src/screens/parts/FrqPhotoPanel.jsx`, and the three `src/lib/__tests__/more-help*.test.tsx` files. Trace through the actual typed, MCQ, photo/hand-drawn and revision submission paths; a pure helper test is insufficient evidence that the real request is correct.

## Contract and known state

The owner explicitly requested: **“add More help to real Calculus AB/BC and Chemistry questions in app.cramapple.com.”** Positive student feedback concerns the mock. It does not prove production generation quality or better scores.

This is an accepted new help template launched from the ordinary question page. It keeps the question, stimulus, answer and existing grade visible; desktop has two panes and phones stack them. Help begins immediately, with a short explanation, one next scoring action, 1–3 checked references and bounded follow-ups. Published memory hooks must be relevant to the current topic, at most one displayed, with their expansion/caution. Do not invent a new approval requirement by treating the accepted help template as a replacement of the ordinary question-page template.

Before submission, assistance must guide setup without disclosing a complete answer/key. After authoritative grading, it may explain the recorded feedback, without regrading or changing the locked grade. Work must survive opening/closing, loading and failures. Successfully delivered help must coach current/future unsubmitted attempts on the same served question across refresh and tabs; failed generation must not coach an attempt. Submitted attempts and independent fresh questions must retain their prior status.

Grounding is limited to available published references. Calculus currently has AB Units 1–3, shared with BC; Chemistry has Units 1–9. This is not proof that every question has usable grounding. Image-dependent questions without readable context must fail honestly. Broader student history and newly retained raw work/help transcripts are outside this slice.

**Environment:** Development is Supabase `wmgjsdkphcyhngaffbqf`. Both migrations above are applied there, and `more-help` v4 is active with JWT verification, from the backend code checkpoint above. Production `pcntajvbdfqhbeewmdry` has received no migration/function deployment from this work. The app PR is draft and has not been published as this feature.

**Generation blocker:** Approved Development tests used one real authored question per subject, published reference facts, empty work/focus and a disposable QA account. All returned `503 help_unavailable`; safe diagnostics confirmed upstream `429 credit_balance_exhausted` on October 13 at about 8:20 PM New York. There is no verified successful real generation. Do not retry unchanged credit state, top up, change credentials/providers or replace this failure with a mock success.

**Provider choice must be challenged:** Implementation reuses the existing grading backend's `OPENAI_API_KEY` / `OPENAI_MODEL` through the Responses API. The historical saved Sites demo used a different Anthropic model through an AI Gateway. The owner has now asked why an API was used instead of their subscription. Separate review/authoring in an authenticated subscription session from the app's runtime model calls. Ordinary API-key calls have separate billing; subscription-backed app access requires an explicit supported integration. Do not treat a personal subscription/session token as a service credential. Assess whether the selected provider/model/cost contract matches the agreed behavior and what owner decision, if any, remains. Verify any current product capability you rely on with official docs rather than memory. Useful starting sources: https://learn.chatgpt.com/docs/pricing and https://developers.openai.com/siwc/ui-ux-guidelines .

## Review boundaries

Use your authenticated Claude session for this review. Do not create a separate paid model-evaluation pipeline. Local tests, temporary adversarial fixtures and read-only inspection are allowed. Do not modify implementation files, merge, deploy, apply migrations, publish in Lovable, send messages, change billing or inspect real students' identities/work/history. Do not expose tokens, environment values or private QA credential files. If live access is unavailable, continue source/local QA and explicitly mark live checks blocked.

Write the report to `docs/qa/QA_MORE_HELP_CLAUDE_ADVERSARIAL_2026_10_13.md` on an isolated review branch if repository writing is available; otherwise return the complete report. Do not commit on the implementation branch or overwrite existing reports. Any local fixtures must be clearly labeled synthetic. No scripted browser/model fixture establishes a successful live response.

## Attack the following seams

1. **Authority and privacy.** Trace JWT authentication, origin handling, ownership, active sessions, version/ordinal correspondence, published status, subject allowlist and entitlement checks, including `all_subjects`. Try anonymous/foreign sessions, mismatched UUIDs, unsupported subjects, stale items and ended sessions. Can client fields smuggle a grade/key/reference/history or select post-grade disclosure without a current authoritative grade? Does revision use stale grading or future answer truth? Check what the caller-scoped RPC actually exposes. Check service-only grants, RLS, SECURITY DEFINER/search_path and every callable RPC, including the retired reservation function. Verify logs and stored metadata exclude raw work, prompts, provider bodies and secrets.

2. **Delivery, idempotency and assistance.** Review reserve → model → validate → commit → disclose as one state machine. Probe provider/validation/commit failures, lost responses, aborts, retries, identical IDs with different payloads, duplicate IDs, two tabs, concurrent grades and the 50-second lease versus generation timeout. A delivered duplicate can be marked coached even if the response was lost; does recovery remain usable and conservative without duplicate disclosure/calls? Can an expired worker commit a newer reservation, or overwrite failed/delivered state? Check SHA-256 input signatures, retry bounds and quota accounting of actual attempts. Does the global advisory lock serialize too much? Prove failures do not mark assistance; delivered help marks existing and subsequently inserted drafts exactly once; an already submitted attempt stays unchanged; a fresh question/session stays independent. Verify both migrations replay in order and ledger filenames match Development. Identify upgrade/rollback consequences, including restoring an older function against revoked RPC grants.

3. **Actual submission integration.** Trace `MoreHelp` → parent state → real grading request → database assistance event/rollup → displayed outcome. Exercise MCQ, typed FRQ, photo/hand-drawn FRQ and revision. Verify reload, close/reopen, item changes, late receipt reads and stale responses. Can client `assisted:false` contradict a delivered server receipt? Does More help accidentally become a second ordinary hint event and double-count? Independently verify the new QxView-to-real-grading-helper tests, and distinguish their stubbed submit callback/network from the actual route and deployed grading flow. Check photo preparation, normal evaluation and retry evaluation, not only the preparation assertion. Do request IDs stay stable on failures but recover after exhausted/already-delivered requests? Does assistance survive an edited answer whose outdated help response is discarded?

4. **Answer leakage and content truth.** Inspect the exact pre/post model payload and output validator, not just the system prompt. Attempt “ignore the instructions,” requests for the answer/key/rubric, plausible work that contains an answer, and malicious focus text. Determine whether withholding a key is enough when the model can solve the question from its stem/references. Distinguish a deterministic protection from a prompt-only promise. Check source-ID validation, reference relevance, context truncation, missing sources, unsupported diagrams, malformed/oversized/incomplete responses and unsafe output. A valid schema/citation does not establish a correct explanation. Check misconception claims against actual evidence and prohibit invented hooks or new grades. Report answer-disclosure uncertainty as a release gap when it cannot be resolved offline.

5. **UI, math and accessibility.** Verify work preservation with the actual mounted TaskPane, not a mock field. Exercise before-answer, wrong/right graded answers, revision, first load, focused follow-up, error, retry, next question and close/reopen. Check duplicate sibling keys, React effects, race/stale-response handling and hidden state. Test desktop/phone reading order, focus trapping/Escape/return, keyboard access, 44px touch targets, overflow, square corners, no motion and semantic tokens. Measure the smallest readable math glyph against the 16px rule, including fractions/superscripts. Can highlights break LaTeX? Is all generated/reference/hook copy sanitized while source IDs remain stable? Are hooks both published and owned/tagged to this topic, and limited to one across all sources? Check source types and null/optional fields, not only the happy formula fixture.

6. **Deployment and cost.** Establish which source is local, PR, Development, Preview or actually published. Review the combined publication delta for unrelated app changes. Verify JWT configuration, existing origin/model settings, timeouts, no-store behavior, quotas and failure copy without printing secrets. Review the OpenAI payload (`store:false`, output cap, schema, supported model semantics) and the separate subscription question. Identify any architecture mismatch and minimal alternatives; do not implement a provider switch or assume a billing purchase is required. Treat credit exhaustion as an external blocker and potential UX failure, separately from confirmed code defects.

## Evidence and tests

Reproduce likely defects with small temporary tests that can fail for the claimed reason. Prefer integration/state-transition checks to tests mirroring a helper. Never report a hypothetical exploit as confirmed without a reachable path or clearly state the missing precondition.

Author-reported evidence, to independently assess: app full suite 115 files / 1,101 tests, TypeScript and build pass; backend 9 Deno tests and typecheck pass; rolled-back Development SQL assertions passed private grants, entitlement/foreign ownership denial, same-receipt retries, duplicate request denial, failed-generation independence, existing/future draft coaching, submitted-attempt preservation and fresh-session independence. Desktop/phone screenshots were from a scripted local fixture, not live generation.

An earlier Lovable plan-mode review of older SHAs reported assistance propagation, premature coaching/retry, sanitization/hook and math-highlight defects. The current SHAs claim to remediate them, plus photo-path assistance, duplicate reused-hook display, live-region updates and server-reported drafts. A scoped AGENTS note records the accepted new help template; styles are in the existing stylesheet. Failed calls still consume bounded request quota to prevent abuse, but do not coach attempts. Assess this explicitly rather than infer a paid student charge. Independently verify each fix and look for new defects. An earlier pass/fail is not your verdict, and live generation remains unverified.

Suggested existing checks, if tools/dependencies are available: app `node_modules/.bin/vitest run`, `node_modules/.bin/tsc --noEmit`, `npm run build`; backend `deno test supabase/functions/more-help/contract_test.ts` and `deno check supabase/functions/more-help/index.ts`. Check the test file's actual permissions/imports before adjusting commands. Do not silently install new tools/dependencies or weaken security to obtain a green result. Record blocked checks rather than stop the source review.

## Required report

Lead with a proposed **PASS, FAIL or BLOCKED** verdict, exact reviewed SHAs and environment. State whether code readiness and production release readiness differ. Do not call the feature Done or live.

List findings by severity (P0–P3), each with: concise title; repository/file and verified line; concrete trigger/reproduction; expected versus actual behavior; student/security/scoring/cost impact; evidence; and the smallest corrective action plus a meaningful regression check. Separate confirmed defects, unresolved contract/architecture decisions, and checks blocked by infrastructure. Include a compact coverage matrix with observed/locally tested/source-only/blocked status. Identify prior findings fixed versus still open and any new regressions.

Finish with the minimum remaining conditions for a production release. If you find no further code defect, say so and explain the limits of that conclusion. Do not equate passing mocks or exhausted-provider errors with end-to-end correctness. Return a skeptical, evidence-backed review, not encouragement or a restatement of the implementation summary.
