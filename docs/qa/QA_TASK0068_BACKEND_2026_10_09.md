# QA — TASK-0068 BYOQ photo extraction (backend) — 2026-10-09

**Reviewer:** independent QA context (separate from the implementer).
**Scope:** backend only — migration, `_shared/byoq-extraction.ts`, `byoq/index.ts`, `byoq/store.ts`, tests, live Development function. Frontend (Lovable review screen), UX/accessibility (§7.3 item 7) and PostHog events were not in scope.
**Code reviewed:** branch `claude/task-0068-byoq-photo-extraction` at `c9b2344d` (started at `a2e55ea2`; the implementer committed prompt `2026-10-09.2` as `4db8c52b` mid-review — the Development function runs `.2`, which matches HEAD; worktree clean at close).
**Governing docs:** `docs/product/BYOQ_PHOTO_EXTRACTION_PLAN_V2_2026_10_08.md` §4, §5, §6.3, §7.3; `docs/tasks/TASK-0068-BYOQ-PHOTO-EXTRACTION.md`; DECISION-0057.
**Environment:** Development `wmgjsdkphcyhngaffbqf` only. Nothing deployed, no secrets changed, nothing committed. Production untouched.

## Recommendation: **FAIL for Gate C (Production) in the current state. PASS is reachable with three targeted fixes (findings 1–3) and a short re-QA.**

What holds: the DECISION-0057 contract (no answer-bearing field in the schema or stored record, `captured_work` absent from every function response, the choices CHECK and `validateItemFields` unchanged and still rejecting extra keys), the typed fallback (extraction disabled / unconfigured / failed / breaker never breaks `finish_capture` and never writes partial fields), the capability scoping of the three review ops, the 24-check TASK-0039 regression on Development, and all 53 Deno tests.

What fails an acceptance criterion: (1) a student edit **is** overwritten when it lands while the model call is in flight, and the same race clears a live answer-leak flag so a stem containing `Answer: 4` can be confirmed `ready` (demonstrated with a temporary test, not committed); (2) `captured_work` and the full `extraction` record are readable by a signed-in student over PostgREST, outside the BYOQ function; (3) spend accounting has two gaps — non-forced re-runs after a failure call the model with no reservation, and `extract_question` has no effective per-owner rate limit despite the plan and the test name saying it has one.

## Evidence summary (commands run)

| Check | Command / method | Result |
| --- | --- | --- |
| Unit tests | `cd supabase/functions && deno test --allow-env --allow-net --allow-read byoq/ _shared/byoq_test.ts _shared/byoq-extraction_test.ts` | 53 passed, 0 failed (run at `a2e55ea2` and again at `c9b2344d`) |
| TASK-0039 regression | `node scripts/byoq_smoke.mjs` against Development | 24/24 PASS |
| Live extraction smoke | `scripts/byoq_extraction_smoke.ts` (clean page `0d2259c0…`, AP Physics C Mech U3) | 27/27 PASS; `prompt_version 2026-10-09.2`, latency 2.4 s, topic 3.2 = truth |
| Planted `Answer: B` line (`control/730c7ce7…`, Calc AB U1) | scratchpad probe, 1 model call | stem/choices clean; model reported it as an answer key (`answer_key_present` warning); `answer_text_detected=false`; confirm allowed |
| Printed answer key (`control/51f7683e…`, Calc AB U3) | scratchpad probe | `answer_key_present` warning; stem/choices clean; no `captured_work` in any response |
| Circled option (`control/27198229…`) | scratchpad probe | stem/choices clean, no marker text; topic 3.3 with 3.4 (truth) in alternatives |
| Blank page | scratchpad probe | `not_a_question`, `unreadable`, `no_topic`, `type_unsure`; `filled: []`; nothing written to item |
| Capability refusals (live) | scratchpad probe | malformed handle 400; cancelled handle 409 `pairing_cancelled`; foreign `item_id` in body ignored; response-role handle 409 `pairing_not_reviewable` (unit test); no `owner_key` in any phone-leg response |
| Schema exposure | `GET /rest/v1/byoq_items?select=id` with `Accept-Profile: app`, anon key | `42501 permission denied for schema app` — i.e. `app` **is** in PostgREST's exposed schemas (a non-exposed schema returns PGRST106) |
| Race / ledger / rate-limit | temporary `byoq/_qa_tmp_test.ts` (copy of `index_test.ts` + 4 tests), run then deleted | see findings 1, 3, 4 |

Live model calls made: 6 (clean smoke 2, four probes 1 each). Every probe deleted its item.

## Findings

### 1. Major — concurrent student edit is overwritten by the proposal, and the stale leak-flag recompute lets an answer-bearing stem be confirmed

`supabase/functions/byoq/index.ts:1061-1165` (`extractForItem`). The function reads `item` once, awaits the model (2–4 s live, up to 45 s), then computes `proposalPatch(item, …)` at :1143 and `detectAnswerLeaks(stem, choices, …)` at :1163 **against the pre-call snapshot**, and writes with an unconditional `store.updateItem(item.id, patch)`.

Reproduction (temporary test, injected `extract` that performs `update_item` mid-flight):

- QA-A: item created, photo finished; during the model call the student saves `item_type: "frq", stem: "My own typed question"`. After extraction: `item_type=mcq`, stem = the proposal, 4 proposed choices. The student's edit is gone.
- QA-B: item has stem `What is 2 + 2?`; during the model call the student saves stem `What is 2 + 2?\nAnswer: 4` (flagged, `answer_text_detected=true`). After extraction `patch.stem` is undefined (snapshot stem was non-null) but `leak_flags` is recomputed from the **snapshot** stem → `[]`. Result: `answer_text_detected=false` with `Answer: 4` still in the live stem; `confirm_item` → 200, status `ready`, stem `"What is 2 + 2?\nAnswer: 4"`. The DB CHECK passes because `leak_flags` was overwritten to `[]`.

Why it is reachable in the designed flow: §4.1 has the desktop form open while the phone captures; `finish_capture` marks the token consumed *before* extraction, so desktop polling sees the capture end while the model is still running, and §5.4 only switches the desktop to prefilled once `extraction.status = 'proposed'` — the typed form is live for exactly the race window. Same race with `extract_question` (desktop) vs `capture_review_update` (phone).

Severity reasoning: violates plan §4.3 ("Student edits are never overwritten") and the task acceptance criterion; the leak-gate consequence defeats the §4.5 backstop. Not classed Blocking because the overwritten/leaked text is the student's own, no cross-owner exposure exists, and the window is one model call. Fix: after the model returns, re-read the row and compute `proposalPatch` + `leak_flags` against the fresh row (or make the fill conditional in SQL: `set stem = coalesce(stem, $1)` etc., and recompute `leak_flags` from the row's final values).

### 2. Major — `captured_work` and the full `extraction` record are readable outside the BYOQ function by a signed-in student

Migration `supabase/migrations/20261009112941_task0068_byoq_extraction.sql` adds the columns; `20260928150000_task0039_byoq_core.sql:525` grants `select on table app.byoq_items … to authenticated` (table-level, so new columns are included), `:527` policy `user_id = auth.uid()`; `20260731160000_schema_baseline.sql:7426` grants `usage on schema app to authenticated`; and the live probe shows `app` is an exposed PostgREST schema. A signed-in student can therefore `GET /rest/v1/byoq_items?select=captured_work,extraction` with `Accept-Profile: app` and read their own `captured_work` (the marks the plan says are "never read by any path outside BYOQ", §4.5) and `extraction.proposed.stem/choices` — the raw proposal, which is not masked and persists even after `remove_flagged_text` cleans the item (`buildExtractionRecord`, `byoq-extraction.ts`). QA plan §7.3 item 5 requires `captured_work` never be returned by any non-BYOQ path.

Not executed live (no signed-in test account on Development; creating one is outside my remit); verified from the grants plus the schema probe. Own-rows only, so not cross-owner. Fix: `revoke select (captured_work, extraction) on app.byoq_items from authenticated` in the same migration (the column-grant pattern already used for `mcq_choices`), and add a grep/test as §7.3 asks.

### 3. Major — spend accounting: non-forced re-runs after a failure are unmetered, and `extract_question` has no effective per-owner rate limit

(a) `index.ts:1106` builds `requestId = byoq_extract:<item>:<key16>:1` for every non-forced run of the same photos. `app.reserve_model_usage` (baseline `:767-813`) returns the **existing** row on a replayed `request_id` regardless of its status, and `store.ts:545` turns any returned row into `true`. So after a `failed` outcome (timeout, HTTP error, malformed output — `status !== "proposed"` passes the idempotency check at :1078) every later non-forced `extract_question` calls the model again with no new reservation, and `complete_model_usage` is a no-op on the old row. Temporary test QA-C: first run fails → second non-forced run → 2 model calls, 1 ledger row. The BYOQ breaker (`byoqExtractionSpendToday`, `store.ts:558`) only sums ledger rows, so these calls are invisible to both caps.

(b) `index.ts:610`: `extract_question` is gated on `countMintsSince` (pairing-token mints), which `extract_question` never increments. Plan §8.3 and the test name at `index_test.ts` ("extract_question is rate-limited with the pairing-mint window") claim a 12-per-10-minute bound; the test only asserts the archived refusal. Temporary test QA-D: 25 consecutive `force: true` calls → 25 HTTP 200, 25 model calls. The only ceilings are the daily USD caps (~3,300 calls/day at $0.03 under the default `BYOQ_EXTRACT_DAILY_CAP_USD=100`), per anonymous owner, no sign-in required.

Fix: count extraction runs per owner per window (a small table or reuse the ledger `request_id` prefix with the owner id in it), and give retries-after-failure a fresh `request_id` (e.g. include the attempt number or `at`) so every model call is reserved.

### 4. Minor — `BYOQ_EXTRACT_DAILY_CAP_USD` is a no-op unless `OPENAI_DAILY_CAP_USD` is set

`index.ts:1108-1119`: `reserveModelUsage` (and therefore the ledger rows the BYOQ breaker counts) runs only when `sharedCapUsd > 0`. With `OPENAI_DAILY_CAP_USD` unset the comment says "run unmetered" and the BYOQ cap can never trip. Development has the secret name set (`supabase secrets list`); its value, and Production's, were not verifiable here. Document the coupling in the runbook or make the BYOQ breaker count independently.

### 5. Minor — review window mechanism differs from the approved design

Plan §5.3: extend `expires_at` once by 15 minutes at `finish_capture`; "a consumed or cancelled pairing refuses all three ops"; §7.3 item 2 tests "the extension happens once". Implemented (`index.ts:1187-1206`): consumed tokens are accepted for 30 minutes after `consumed_at ?? closed_at`. Consequences: the owner cannot revoke the phone's window (`cancel_pairing` only transitions live states — live probe: `cancel_pairing` on the consumed token returned 200 with `state=consumed` and the phone could still `capture_review_update` afterwards); a re-mint for the slot cancels live tokens only; a token that lapses in `uploaded` state is converted to `consumed` with `closed_at = now` on first touch (`expireIfLapsed`), so its window runs from that touch, i.e. up to 20 + 30 min after upload. Bounded and single-owner, so Minor — but it is an undocumented deviation; record it in the task file or amend §5.3.

### 6. Minor — proposal bypasses `validateItemFields`; over-long text is truncated instead of rejected

Plan §5.2: proposal output "goes through the existing `validateItemFields` … anything that fails validation yields `extraction.status = 'failed'`, not a partial write". Implemented: `normalizeProposal` (`byoq-extraction.ts`) slices stem to 6,000 and choices to 1,000 chars and drops empty choices; `proposalPatch` slices to 6 choices (with a `too_many_choices` warning). Shape is identical to the typed path so the DB CHECK is satisfied, but a 7-choice page silently loses choice G. Acceptable for v1; note the deviation.

### 7. Minor — vendor error text is surfaced to the client

`byoq-extraction.ts:413` puts up to 200 chars of the OpenAI error body into `failure`, which `extractionView` returns to the browser (`extraction.failure`). OpenAI masks keys in its messages, but raw vendor error bodies should not reach students. Keep the status code, log the body server-side.

### 8. Minor — "Answer: X" lines are treated as answer keys, not `captured_work`

Plan §4.5 routes a printed "Answer: B" to `captured_work`; the model (prompt `.2`) sets `answer_key_present` instead (live probe and benchmark: 6/6 `answer_line` controls → `captured_work=NO`, warning raised). Safe (nothing leaks; stem is clean) but the review screen will show the answer-key copy for a student's own answer line. Note for the frontend copy; no backend change required.

### 9. Minor — forced-run `request_id` uses millisecond `at`

`index.ts:1106`: two forced runs in the same millisecond share a `request_id` and the second is unmetered (the fake clock in QA-D produced 8 ledger rows for 25 calls). Unlikely with a real clock; folds into finding 3.

### 10. Observation — benchmark does not meet §6.3 for the chosen model

`report-gpt-4.1-mini.md` (prompt `.2`): topic top-3 within unit 86.5% clean / 88.8% degraded (gate ≥ 90%); stem ≥0.95 similarity 83.1% clean (the proxy for the ≥ 85% zero-edit gate). The execution record states this. Item type, choices, 0 answer text, 0 leak flags, latency (median 2.4 s) and abstention pass. §7.3 says a gate change is a documented amendment, not a QA call; recorded here for the Gate C decision.

## Verified and passing (with evidence)

- **Contract.** `buildExtractionSchema` is closed (`additionalProperties: false`, all 12 properties required, topic enum per call); no property can carry a key, rationale or score. `ExtractionRecord` stores `proposed.{item_type, stem, choices[], topic_code, alternatives, is_question}` only; `extractionView` returns a summary with no `proposed.stem/choices` and no `captured_work` (grep of every live response: `captured_work` never present). `validateItemFields` (`_shared/byoq.ts:339-423`) and `app.byoq_choices_are_answer_free` (core migration `:82-101`) are unchanged; a choice with any key other than `choice_key`/`choice_text` is rejected at both layers. Proposed text goes through `detectAnswerLeaks` at `index.ts:1163`; unit test "proposed text passes the same leak gate" shows a proposed `Answer: 4` stem is masked and blocks confirm until `remove_flagged_text`. A printed key sets `captured_work = null` (`normalizeProposal`) with the `answer_key_present` warning (unit test + live probe).
- **Capability scoping.** `captureReviewOperation` (`index.ts:1209-1216`) takes the item from the token and checks `owner_id`; the body `item_id` is never read (live: foreign id ignored). Refusals verified: malformed (400), cancelled (409), response-role (409 `pairing_not_reviewable`), consumed > 30 min (409 `review_window_closed`, unit test), expired/rejected mapped (code). Phone-leg responses carry no `owner_key` (`owner_key` is only attached in the owner-op branch of `handleByoq`) and no `captured_work`. `reveal: true` is honoured for the capability holder (same person; consistent with `get_item`).
- **Edit safety (sequential).** `proposalPatch` fills only null fields (unit tests; live: forced re-run kept "(edited on phone)"). Idempotency: same digests + model + prompt version → `return item` with no model call (live: `extraction.created_at` unchanged after non-forced `extract_question`). The race in finding 1 is the exception.
- **Fallback.** `enabled=false`, no key, breaker refusal, timeout → `extraction.status` `unavailable`/`failed`, no `item_type/stem/choices/topic` written, `finish_capture` 200, typed `update_item … confirm: true` reaches `ready` (unit tests). `finish_capture` wraps `extractForItem` in `.catch` so a store/storage exception cannot fail the capture.
- **Cost (happy path).** BYOQ breaker checked before `reserve_model_usage`; reservation completed (`completed`/`failed`) immediately after the model returns on both outcomes; no reservation when the model is unconfigured or there are no pages (`runByoqExtraction` ordering). Ledger columns used (`request_id`, `usage_date_utc`, `reserved_cost_usd`, `actual_cost_usd`) exist in the baseline schema `:156-170`; the live `proposed` outcomes show the RPC path did not error (or `sharedCapUsd` is 0 — see finding 4).
- **Migration.** `add column if not exists` ×3 with CHECKs, `comment on column` ×3: re-runnable; filename matches the version Development recorded per the execution record.
- **Regression / parity.** 24/24 TASK-0039 checks; `extract_question` sits in `OWNER_OPERATIONS` and resolves through the same `resolveCaller`/`ownedItem` path for JWT and owner-key callers; the phone leg is identity-agnostic. No divergence found.
- **Error mapping.** New codes: `pairing_not_reviewable`, `review_window_closed`, `rate_limited` (extract), all 4xx through `HttpError`; unknown store errors still map to 500 `byoq_failed`.

## Not verified

- An authenticated PostgREST read of `captured_work` (finding 2) — established from grants + schema probe, not executed.
- The values of `OPENAI_DAILY_CAP_USD` / `BYOQ_EXTRACT_DAILY_CAP_USD` on Development or Production (names only via `supabase secrets list`).
- The `model_usage_ledger` rows written by the live runs (no read access to `app` from here); correctness of the RPC path inferred from the `proposed` outcomes.
- Multi-page and retake re-runs live (code path identical to single page; `extractionKey` is digest-set based; not exercised against Development to stay inside the model-call budget).
- Expired-handle refusal live (needs 20 minutes); covered by `expireIfLapsed` + unit tests.
- Frontend review screen, PostHog events, UX/accessibility (§7.3 items 7–8) — out of scope for this backend pass.
- Production: nothing was run against `pcntajvbdfqhbeewmdry`.
