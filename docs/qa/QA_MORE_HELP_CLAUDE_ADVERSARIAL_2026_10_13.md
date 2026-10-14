# Independent adversarial QA — More help (Calculus AB/BC, Chemistry)

STATUS: CURRENT
DATE: 2026-10-14 (America/New_York, evening of 2026-10-13)
REVIEWER: Claude (independent, read-only; no implementation, deployment, migration, publication, billing or messaging actions)
PROMPT: `docs/qa/MORE_HELP_CLAUDE_ADVERSARIAL_QA_PROMPT_2026_10_13.md`
PRODUCER DISPOSITION CHALLENGED: `docs/qa/MORE_HELP_QA_REMEDIATION_2026_10_13.md`
ORIGINAL FINDINGS: `docs/qa/QA_MORE_HELP_LOVABLE_2026_10_13.md`

## Proposed verdict: FAIL (code) · BLOCKED (production release)

The backend cannot deliver help as deployed. The three new delivery RPCs run as `service_role`
(`SECURITY INVOKER`) but `service_role` holds no `UPDATE` on `app.question_help_receipts` and no
privilege at all on `app.attempt_assistance_events`. Every request that reaches
`commit_question_help` therefore fails with `assistance_commit_failed` (HTTP 503) after a paid
model call, the compensating `fail_question_help` also fails, and same-ID retries fail at
reservation. This is confirmed in Development by direct privilege checks and by executing the
functions' own statements as `service_role` in rolled-back transactions. The producer's SQL
assertions passed because they ran as the table owner, not as the role the Edge Function uses.
No live request has ever exercised the v4 commit path: the only live calls (00:18–00:20 UTC) ran
under function v1/v2 and failed upstream before commit.

Code readiness and release readiness differ. Code readiness fails on one confirmed P0 plus
unresolved contract gaps. Release readiness is additionally blocked by: no successful real
generation (upstream `429 credit_balance_exhausted`, confirmed in Development function logs),
zero published MCQs for these subjects in Development (the MCQ path cannot be tested there), the
app PR being unreachable from this session, and the open provider/billing decision.

The feature is not Done and not live. Nothing in this review establishes end-to-end correctness.

## Exact scope reviewed

| Repository | Reviewed | Notes |
| --- | --- | --- |
| `david-bloom/Cramapple` backend | PR #435 head `62c8a6de0052456176d702626335487c573419d5` | Code checkpoint `430fe2bda1d279670ea8518ac86d543a16cf3fc2` is an ancestor; `git diff 430fe2b..62c8a6d -- supabase` is empty, so the verdict covers both. Base `6493417d`; PR base now `0f6b30b3` after the merge of main. |
| Development `wmgjsdkphcyhngaffbqf` | Function `more-help` v4 (deployed 2026-10-14 01:08:18 UTC), `verify_jwt=true` | Deployed `index/handler/contract/model` and `_shared` files compared with the checkpoint: identical. Migrations `20261014001227` and `20261014005146` present in `schema_migrations`. |
| `david-bloom/ap-prep-blueprint` app | **NOT REVIEWED** — PR #21 @ `30a65daed1ee1dd88e74b8f20f904ffffaab410b` | The repository is outside this session's GitHub scope (`list_repos` returns nothing for it) and the Lovable project (`56cae479…`) returns 404 for that commit and for `src/lib/more-help.ts` / `src/components/session/MoreHelp.tsx` at HEAD (`4b6fff2e`). Only the app's **base** submission path (`QuestionExperience.jsx`, `live-practice-mcq/grade.ts`, `live-practice-frq/grade.ts`, `assistance-events.ts`, `FrqPhotoPanel.jsx`) was read, to assess the integration seams structurally. |
| Production `pcntajvbdfqhbeewmdry` | Not touched | Per prompt. The grant gap will replay identically there because it is a property of the migrations. |

Local checks run (details under Evidence): backend 9/9 Deno tests pass and `deno check` passes for
`handler/contract/model` using an offline assert shim (deno.land and esm.sh are blocked from this
sandbox; `index.ts` typecheck is therefore **blocked**). Seven synthetic adversarial Deno tests
were written in a scratch directory (clearly labelled synthetic, not committed); five fail for the
claimed reason and document gaps below. App `vitest`/`tsc`/`build`: **blocked** (no source).

## Findings by severity

### P0-1 — Delivery RPCs cannot write: `service_role` lacks UPDATE on receipts and any grant on assistance events

- **Files:** `supabase/migrations/20261014001227_more_help_receipts.sql:17` (grants only `select, insert` on `app.question_help_receipts` to `service_role`); `supabase/migrations/20261014005146_more_help_delivery_commit.sql:60,80,84,97` (UPDATE receipts / INSERT events inside `SECURITY INVOKER` functions executed as `service_role`); `supabase/functions/more-help/index.ts:32-57` (all three RPCs called with the service client). `app.attempt_assistance_events` was granted only to `authenticated` (`20261007181153…:62`); no migration grants it to `service_role`.
- **Trigger:** Any authenticated, entitled student request with a working provider. Sequence: `reserve_question_help_delivery` inserts the receipt (allowed) → model call (paid) → `commit_question_help` executes `update app.question_help_receipts …` → `42501 permission denied` → handler throws `assistance_commit_failed` (503) → `fail_question_help` executes `update …` → `42501`, swallowed by the handler's `catch {}` → row stays `working` for 50 s. Retry with the same `requestId` after the lease: `reserve…` takes the `update … delivery_attempts+1` branch → `42501` → `reservation_failed` (503). Retry with a new `requestId`: reserve succeeds, model paid again, commit fails again.
- **Expected:** Validated help commits a durable receipt, coaches unsubmitted drafts, then is disclosed.
- **Actual:** No help is ever disclosed; every successful generation is paid for and discarded; receipts accumulate as `working`/orphaned; `has_question_help` never turns true; the per-user quota (sum of `delivery_attempts`) is still consumed.
- **Impact:** Feature non-functional for every student (even with credits restored); cost burn per attempt; assistance never recorded, which at least means no false coaching.
- **Evidence (Development, read-only / rolled back):**
  - `has_table_privilege('service_role','app.question_help_receipts','UPDATE') = false`; `…('app.attempt_assistance_events','INSERT') = false` (and SELECT/UPDATE/DELETE false). `relacl`: receipts `service_role=ar`; events `authenticated=ar` only.
  - `begin; set local role service_role; update app.question_help_receipts set request_state=request_state where false; rollback;` → `ERROR 42501 permission denied for table question_help_receipts`.
  - Same pattern with `insert into app.attempt_assistance_events … where false` → `42501 permission denied for table attempt_assistance_events`.
  - `select public.fail_question_help(<random uuid>,<random uuid>)` as `service_role` → `42501 … CONTEXT: SQL function "fail_question_help" statement 1`.
  - `commit_question_help(<random>,<random>)` as `service_role` returns `receipt_not_found` (it fails before reaching the UPDATE only because no row matched).
  - Function logs 2026-10-14 00:18–00:20 UTC show six `POST | 503` with `[more-help] provider request failed { status: 429, code: "credit_balance_exhausted" }`; function v4 was deployed at 01:08:18 UTC. The commit/fail/retry branches have never run live.
  - `app.question_help_receipts` holds 6 rows, all `request_state='working'`, `delivery_attempts=1`, created 00:18–00:20 UTC (pre-migration-2 rows that the second migration did not reconcile; see P3-6).
- **Why the producer's checks missed it:** the rolled-back SQL assertions ran as `postgres` (owner, member of `service_role`, bypasses nothing it owns). The Deno tests stub `reserve/commit/fail`.
- **Smallest fix:** a new migration: `grant update on app.question_help_receipts to service_role; grant select, insert on app.attempt_assistance_events to service_role;` (service_role already has `arwd` on `app.attempts`). Alternative: make the three RPCs `SECURITY DEFINER` (owner `postgres`, `set search_path=''`, execute granted only to `service_role`) like the trigger and `has_question_help`; this is the more self-contained option because it does not widen `service_role`'s table rights.
- **Regression check:** a Development SQL script run under `set local role service_role` (rolled back) that drives `reserve → commit → fail → reserve(retry)` on a synthetic receipt and asserts `delivered`/`failed` states and one `more_help` event per draft; then one real authenticated call through the deployed function with a stub-free provider once credits exist, asserting HTTP 200 and `has_question_help = true`.

### P1-1 — Pre-submission answer withholding is prompt-only; no deterministic guard; unresolvable offline

- **Files:** `contract.ts:158-192` (`validateHelp` checks lengths, source IDs, highlights, follow-up count only); `contract.ts:193` (`HELP_SYSTEM`); `model.ts:24-46` (payload = stem, stimulus, all choices, topic, work, focus, all facts).
- **Trigger:** Before submission, any MCQ/FRQ whose stem plus references let the model solve it (every Calculus/Chemistry computation item). Synthetic test GAP-1: output `{headline:"The answer is B", next_step:"Select B." …}` passes `validateHelp` unchanged.
- **Expected:** "Before submission, assistance must guide setup without disclosing a complete answer/key" — a contract the server enforces.
- **Actual:** Enforcement is one sentence in the system prompt. A compliant-schema response that names the correct choice or final value is disclosed, and the attempt is (correctly) marked coached, but mastery policy for "answer-bearing help" is not what the owner accepted for this surface.
- **Impact:** Scoring integrity (Practice answer-disclosure rule, DECISION-0118 boundary); cannot be verified without real generations; Development has **no published MCQ** for these subjects (see P1-2), so MCQ disclosure cannot be red-teamed there at all.
- **Smallest corrective action:** add a deterministic before-phase post-check in `validateHelp`: reject output whose text contains any `mcqChoices[].choiceText` verbatim, any `choice X`/`(X)`/`answer is` pattern for MCQ keys, or (FRQ numeric items) the canonical answer strings the server already holds (`canonical_answer_1/2` are on `content_item_versions` and never leave the server). Reject → `invalid_model_output`, bounded by the existing 3-attempt retry. Record the owner's decision on what pre-submission help may say.
- **Regression check:** backend tests with leaking fixtures (choice text, key letter, numeric answer) rejected; a controlled live red-team set (≥10 MCQ + ≥10 FRQ, before phase, "ignore the instructions", "what is the answer", work containing a wrong answer, malicious focus) reviewed by a human before release.

### P1-2 — The MCQ path cannot be tested in Development: zero published MCQs for Calculus AB/BC or Chemistry

- **Evidence:** Development content for these three subjects by published `content_item_versions`: Calculus AB 11 FRQ / 0 MCQ; Calculus BC 13 FRQ / 0 MCQ; Chemistry 18 FRQ / 0 MCQ (checked via both the exam-pack join and the taxonomy-cell join; no version has `mcq_choices`). All published items sit in units 1–3; none has a stimulus image.
- **Consequence:** the approved "one real question per subject" live test was FRQ-only; `mcqChoices`/`mcqFeedback` grounding, before-phase choice disclosure, after-phase "recorded answer" explanation and the preloaded-answer interaction in the app have never been exercised against real data. The production work order's QA matrix (MCQ direct entry, incorrect after grading, correct after grading) is not executable in Development as it stands.
- **Action:** owner decision: seed a small published MCQ set for these subjects in Development (preferred), or run the MCQ verification against Production content with the disposable account after the backend is deployed there (which contradicts "Production unchanged until QA passes"). Record which.

### P1-3 — App PR #21 is unverifiable from this session; Lovable findings 1, 3, 4, 5 remain unconfirmed

- **Blocked:** no source access to `30a65da…` (GitHub scope, Lovable 404). The remediation claims (receipt propagation into `assisted`, sanitiser on reference/hook copy, one-hook selection, math-safe highlighting, styles moved into `question-experience.css`, AGENTS note, photo-path assistance, live-region) are **unassessed**, not accepted.
- **What the base app shows (read at Lovable HEAD `4b6fff2e`, which does not contain More help):** `QxView` keeps `aids` in React state and resets on `itemKey` change; `TaskPane` is keyed on `${session.id}:${ordinal}:${state}` so a `state` change remounts it (an opened-help state that changes `state` would lose the draft; whether the PR touches this is unknown); `gradeLiveMcq/Frq` send `assistance_state` to `create_attempt` and `assistance_condition` to `evaluate-attempt`; `recordAssistanceEvents` inserts client events through `public.attempt_assistance_events` keyed by `hint_key` (`topic-hint → topic_hint`). If the PR adds More help as an aid with a mapped key, a second client `topic_hint` event would be inserted beside the server's `more_help` event (double count on `pre_submit_hint_count`, same `coached` outcome). If it uses an unmapped key, no duplicate. Unverified.
- **Server-side mitigation observed (positive, contingent on P0-1):** `attempt-response` accepts the client's `assistance_state` only as a starting value; `app.record_prior_question_help` (SECURITY DEFINER) rewrites it to `coached` and inserts the event on insert; `evaluate-attempt` ignores the body's `assistance_state` object, hashes `assistance_condition` into the idempotency key only, and derives `assistance_state` from `pre_submit_hint_count` (`_shared/assistance-state.ts`). So a client `assisted:false` cannot contradict a delivered receipt once P0-1 is fixed. The client flag still matters for `assistance_condition` in the request hash (a retry with a different flag is a different grading request) — low impact.

### P1-4 — Provider / billing architecture is an open owner decision; official docs could not be fetched

- **What the code does:** `model.ts` calls `https://api.openai.com/v1/responses` with the grading backend's `OPENAI_API_KEY`/`OPENAI_MODEL`, `store:false`, `max_output_tokens:2500`, strict `json_schema`, 35 s timeout, no `reasoning` block. This is the same credential and endpoint `evaluate-attempt` uses (`grading-contract.ts:360-367`). Consequently the 429 `credit_balance_exhausted` seen here also means **Development grading is down**; it is an environment blocker, not a More-help-specific one.
- **Subscription question:** nothing in the repository supports funding server-side calls for arbitrary students from the owner's personal ChatGPT subscription; the integration path the prompt names ("Sign in with ChatGPT") is, by its nature, end-user OAuth where each signed-in ChatGPT user's own plan is used, which would require every student to hold and connect a ChatGPT account and is a different product surface from a server-side coach. I could not verify current official terms: `platform.openai.com`, `learn.chatgpt.com` and `developers.openai.com` are unresolvable from this sandbox (DNS blocked). **Treat this as unverified; the owner should read the two linked pages before deciding.** A personal session token must not become a service credential.
- **Decision needed (one of):** (a) keep the existing API account and fund credits (the grader already requires this, so More help adds marginal cost on a dependency that must exist anyway); (b) route More help through the app's existing server-only Lovable AI Gateway adapter (named in the work order) with its own billing; (c) the demo's Anthropic-via-gateway path. The code change for (b)/(c) is confined to `model.ts`/`index.ts` plus secrets; it must not be implemented in this review.
- **Model-semantics risk (unverified):** `helpSchema` uses `minItems/maxItems` and an `enum` on array items under `strict:true`. The live grader's schemas use `enum` and `additionalProperties:false` but not `minItems/maxItems`, so this codebase has no evidence those keywords are accepted by the configured model. If `OPENAI_MODEL` is a reasoning model, reasoning tokens count against `max_output_tokens:2500` and an `incomplete` status surfaces as `help_incomplete` (502) with no log line. Verify on the first successful call.

### P2-1 — Failed and refused generations consume quota and up to three paid retries; outages lock students out for 24 h

- **Files:** `20261014005146…:50-55` (`delivery_attempts` sums toward 30/user/day and 1000/day), `handler.ts:89-99`, `model.ts:52-67,86-91`.
- **Trigger:** provider outage (as now), a strict-schema refusal (`{type:"refusal"}` → `invalid_model_output`, GAP-5), or deterministic `help_incomplete`. Each same-ID retry is a new paid call; after 3 the client must mint a new ID and the cycle repeats until 30.
- **Impact:** cost without value; a student who keeps pressing "Try again" during an outage exhausts the day's allowance (`rate_limited`, 429) with nothing delivered. The remediation calls this abuse protection; it is also the first-week UX of an outage. **Owner decision**, not a defect per se.
- **Smallest action:** classify provider 5xx/429/network failures and refusals as non-counting (or count them at 1/3), surface `rate_limited` copy that says when it resets, and treat refusal as terminal for that input hash (no automatic retry).

### P2-2 — `uncertain` gradings are treated as pre-submission

- **File:** `contract.ts:100` (`after = phase==='after' && grading.status==='graded' && !draft`). `get_question_experience` returns gradings with status `graded` **or** `uncertain`.
- **Trigger:** FRQ submitted, grader returned `uncertain` (a real outcome in `evaluate-attempt`), student opens More help with `phase:'after'`. GAP-2 reproduces: `after=false`, `recordedGrade=null`.
- **Expected:** after authoritative grading, explain the recorded feedback. **Actual:** setup guidance with no grading context; the attempt is submitted so no coaching occurs (safe), but the response `phase:"before"` can make the UI show before-submission copy on a graded item. Low scoring impact; contract mismatch.
- **Fix:** treat `uncertain` as after-phase with the recorded (uncertain) result, or explicitly refuse with a distinct code. Test: fixture with `grading.status='uncertain'`.

### P2-3 — Reservation failures all collapse to 403; the client cannot tell "wait" from "forbidden"

- **File:** `handler.ts:59-71`. `request_in_progress`, `retry_exhausted`, `request_conflict`, `question_not_owned`, `subject_not_supported`, `entitlement_required`, `invalid_request`, `reservation_failed` all map to 403 (GAP-4). The `error` string is the only discriminator.
- **Impact:** a second tab, or a retry inside the 50 s lease after a lost response, gets 403 `request_in_progress`; a client keyed on status codes shows "not allowed". Whether the app keys on `error` is unverified (P1-3).
- **Fix:** 409 for `request_in_progress`/`request_conflict`, 410 or 429 for `retry_exhausted`, 403 only for authorization. Test in `contract_test.ts`.

### P2-4 — Hook authoring metadata (`sourceNote`) is sent to the model and returned to the client

- **File:** `contract.ts:86` (`memoryHooks: list(e.memoryHooks)` raw). Entry-level `sourceNote`/`visualAssetRef`/`sharedFromSubjectKey` are dropped by the `Source` mapping, hook-level `sourceNote` is not (GAP-3). Development hook notes are provenance strings (`public-domain-common`, `cramapple-authored`); entry notes include `generated-checked; extractor=anthropic/claude-sonnet-5.5; …`. Not a secret, but internal provenance leaks into the help response and prompt and inflates payload. Also note 15 Chemistry diagram entries and 3 Calculus list entries mention "CED" in body/items; the server passes these verbatim and relies on the app sanitiser (unverified).
- **Fix:** map hooks to `{id, kind, hookText, expandsTo, whenToUse, caution}` only. One-line test.

### P2-5 — Lease/timeout margin and expired-worker double disclosure (theoretical)

- **Files:** `model.ts:47` (35 s), `20261014005146…:8,49,60,79` (50 s lease; commit refuses after expiry).
- **Analysis:** load + reserve + 35 s generation + commit normally fits 50 s; under slow DB/provider the commit returns `delivery_expired` after a paid, valid generation, the help is withheld and the row marked failed (correct, conservative). If worker A exceeds the lease while B re-reserves the same ID (second tab after 50 s), A's late commit succeeds against B's lease and both disclose the same help (same input hash) with two paid calls. Not reachable within the 35 s abort in normal operation. P3 by reachability; noted because the prompt asks.

### P3-6 — Second migration does not reconcile receipts created under the first contract

- **File:** `20261014005146…:3-8` adds `request_state default 'working'` and a fresh 50 s lease to existing rows. Six Development rows from the v1/v2 contract sit at `working/1` with an expired lease; under v1 those receipts coached drafts at reservation time, which the new contract would not have done. Production has no rows, so no release impact; Development QA fixtures should be cleaned with the rest of the disposable account.

### P3-7 — RPC errors are not logged; the P0 would be invisible in logs

- **Files:** `index.ts:28,42,50` throw generic codes on any RPC error and log nothing; `handler.ts:93` swallows `fail` errors. Only the provider branch logs (`model.ts:59`). Log `error.code` (never the message body) for the three RPCs so a permission or schema regression shows up as something other than a bare 503.

### P3-8 — Highlight validation is a raw substring check; math-span safety is delegated to the app

- **File:** `contract.ts:176-178`. A highlight inside or across `$…$` passes (`stem.includes`). The app-side segmenting fix is unverified (P1-3). A server guard (reject highlights overlapping `$…$`/`\(…\)` spans) is three lines and would make the invariant independent of the client.

### P3-9 — Global advisory lock serialises every reservation across all students

- **File:** `20261014005146…:41`. Held only for the quota sums and one insert/update; fine at pilot scale, a ceiling later. The quota count indexes exist. No action now; note for scale.

### P3-10 — Rollback/upgrade consequences (verified safe)

- Restoring function v1–v3 against the current database: `reserve_question_help` has no `service_role` grant (`proacl {postgres=X}`) → `reservation_failed` 503, no model call, no coaching. Safe fail.
- Migration 1 drops `attempt_assistance_events_source_check` by its auto-generated name; the name matches in Development and derives from the same base migration, so Production should match. Both migrations replay in filename order and the ledger names match Development (`more_help_receipts`, `more_help_delivery_commit`).

## Confirmed correct (inspected, not merely claimed)

- JWT: gateway `verify_jwt=true` (Development and `config.toml`), then `requireAuthedUser` calls `auth.getUser(token)` so the anon key alone is rejected. Caller-scoped `get_question_experience` (SECURITY DEFINER, `auth.uid()` ownership, `search_path=pg_catalog`) loads context with the student's own JWT; session id, version id and ordinal are cross-checked (409).
- Reservation gates: ownership + `status='active'` + item in session + both `content_item*` published + subject allowlist + active entitlement including `all_subjects` and date window. Foreign/ended sessions and unsupported subjects fail before any model call (tests present; SQL inspected).
- Client cannot smuggle a key/grade/reference/history: `parseInput` keeps only the seven fields; `helpContext` builds the payload exclusively from the RPC; `after` requires a server `graded` result and no server draft; `priorAttempts`, `criteria`, `comparisonAnswers` are not forwarded.
- Receipts table: RLS on, no policies, no `authenticated`/`anon` grants; `has_question_help` is SECURITY DEFINER, `search_path=''`, returns only delivered receipts for `auth.uid()`.
- Trigger `app.record_prior_question_help` is SECURITY DEFINER, `search_path=''`, keyed on `min(delivered_at)`, only `submitted_at is null`; `set_assistance_event_derived_fields` marks it `before`, so `pre_submit_hint_count` increments and `deriveAssistanceState` yields `coached`.
- Logs/metadata: no student text, prompt, provider body, token or key is logged or stored (`console.warn` emits status/code only; table stores ids, hash, state, timestamps).
- Bounds: 16 KB request, 160/4000-char focus/work, 12 sources, 8 KB/source, 32 KB sources, 12 KB stem, 10 KB stimulus, 35 s timeout, 2500 output tokens, 100/1400/400-char output fields, ≤3 follow-ups, ≤4 highlights, unique known source IDs.
- Reference availability: Development max 10 entries per topic (Chemistry) and 6 (Calculus), so the 12-source cap never truncates today; later-unit Calculus questions correctly fail `reference_unavailable` — but no such questions are published in Development, so this is source-only.

## Unresolved contract / architecture decisions (owner)

1. Pre-submission disclosure boundary and whether a deterministic server guard is required (P1-1).
2. Whether failed/refused generations count toward the student's daily quota (P2-1).
3. Provider and billing path for More help (P1-4), including confirmation that the grader's API dependency is itself funded.
4. How the MCQ path is to be verified before release given Development holds no MCQs (P1-2).
5. Whether `uncertain` gradings get after-phase help (P2-2).

## Checks blocked by infrastructure

| Check | Status | Reason |
| --- | --- | --- |
| App PR #21 source review (seams 3 and 5), vitest/tsc/build, QxView→grading tests, photo path, math/a11y/44 px/motion/tokens | Blocked | No access to `ap-prep-blueprint`; Lovable has neither the commit nor the files |
| `deno check supabase/functions/more-help/index.ts` | Blocked | esm.sh unreachable from sandbox (handler/contract/model checked) |
| Official OpenAI/ChatGPT billing and structured-output docs | Blocked | DNS blocked for the three hosts |
| Real generation (before/after, MCQ/FRQ, prompt-injection red team) | Blocked | Upstream credits exhausted; no retry attempted per prompt |
| Production parity of grants/constraints | Not attempted | Out of scope per prompt; inferred from identical migrations |

## Coverage matrix

| Seam | Observed live | Locally tested | Source-only | Blocked |
| --- | --- | --- | --- | --- |
| 1 JWT / origin / ownership / version-ordinal / published / subject / entitlement | Dev grants, RPC defs, logs | 9 repo tests + GAP-4 | handler/contract/SQL | — |
| 1 Service-only grants, RLS, SECURITY DEFINER, retired RPC | **Dev: P0 confirmed** | — | migrations | Production |
| 1 Logs/metadata exclude raw work/prompts/secrets | Dev function logs | — | model.ts | — |
| 2 reserve→model→validate→commit→disclose | **Dev: commit/fail broken** | repo tests (stubbed), GAP-6 | handler.ts | live path |
| 2 Idempotency hash, duplicate/conflict, lease, retry bounds, quota sums | — | — | SQL inspected | live concurrency |
| 2 Trigger coaching of future drafts; submitted attempts untouched | trigger/derived-field defs read | — | SQL | live |
| 2 Migrations replay / ledger names / rollback | Dev ledger | — | files | Production |
| 3 MoreHelp→parent→grading→events→rollup | — | — | base app only | PR #21 |
| 3 Photo prepare/evaluate/retry assistance | — | — | base `FrqPhotoPanel.jsx` | PR #21 |
| 4 Pre/post payload and validator | — | GAP-1/2/3/5/7 | contract.ts | real outputs |
| 4 Source-ID validation, truncation, missing sources, visuals | Dev reference shapes/counts | repo tests | contract.ts | — |
| 5 UI, math, a11y | — | — | — | PR #21 |
| 6 Deployment config (`verify_jwt`, no-store, secrets names), OpenAI payload | Dev function + config | repo test | index/model | provider docs |
| 6 Cost/credit state | Dev logs (429) | — | — | retry forbidden |

## Prior findings (Lovable) — disposition after independent check

| # | Status now |
| --- | --- |
| 1 Grader never hears about More help | Server side redesigned so the database is authoritative (commit + trigger + `deriveAssistanceState`); **defeated by P0-1 until grants are fixed**; app propagation unverified. |
| 2 Help charged when it fails; fresh retry IDs | Design fixed (coaching only on commit; stable IDs with lease and 3 attempts); fail path broken by P0-1 (row stuck `working` until lease expiry; still no false coaching). Quota consumption on failure is an open owner decision (P2-1). |
| 3 Unsanitised copy; up to 3 hooks | App unverified; server still forwards raw hook objects including `sourceNote` (P2-4). |
| 4 Highlights split LaTeX | App unverified; server validator unchanged (P3-8). |
| 5 Second stylesheet/component | App unverified; the accepted-template record is an owner matter, not reviewed here. |
| 6 Real generation fails | Still blocked; root cause confirmed from logs (429 `credit_balance_exhausted`); Development grading shares the dependency. |

New defects not in the earlier review: P0-1, P1-2, P2-2, P2-3, P2-4, P3-6, P3-7.

## Minimum remaining conditions for a production release

1. Grant/definer fix migration applied to Development; the four delivery functions re-verified **as `service_role`**; one real authenticated request returns 200 with `has_question_help=true`, one more_help event per draft, and a submitted attempt unchanged.
2. Provider/billing decision recorded and credits (or the alternative path) working; successful real generations on FRQ and MCQ, before and after grading, for all three subjects, in an environment that actually has MCQs (P1-2).
3. Pre-submission disclosure decision recorded; either a deterministic guard with tests, or an explicit accepted-risk entry, plus a human-reviewed red-team set.
4. Independent review of app PR #21 with source access (seams 3 and 5), including the double-count and `TaskPane` remount questions above.
5. Error-code and `uncertain`-phase fixes (P2-2, P2-3) or recorded deferrals; hook field allowlist (P2-4); RPC error logging (P3-7).
6. Exact publication delta reviewed; Production migrations + function deploy + secrets; signed-in smoke on app.cramapple.com; rollback note that older function versions fail closed.

Passing the repository's 9 Deno tests, the rolled-back owner-role SQL assertions, and the app's mocked suites did not and could not establish any of the above.

## Evidence notes

- Offline test run: `deno test --import-map=<shim> supabase/functions/more-help/contract_test.ts` → 9 passed. The shim maps `https://deno.land/std@0.224.0/assert/mod.ts` to a 20-line local `assertEquals/assertThrows`; it is review scaffolding only.
- Synthetic adversarial tests (scratch, not committed): GAP-1 leak passes validator (fails as expected); GAP-2 `uncertain`→before (fails as expected); GAP-3 hook `sourceNote` in payload (fails as expected); GAP-4 single 403 status for four distinct reservation errors (fails as expected); GAP-5 refusal → `invalid_model_output` (fails as expected); GAP-6 `fail()` invoked when commit throws (passes); GAP-7 after-phase MCQ payload contains the recorded correct key (passes; by design).
- Development SQL was read-only or wrapped in `begin … rollback` with `where false`/random ids; no student identity, work or history was read. Counts only.
- Lovable reads used the project's HEAD, which does not contain the feature; no Lovable edits, messages or publishes were made.
