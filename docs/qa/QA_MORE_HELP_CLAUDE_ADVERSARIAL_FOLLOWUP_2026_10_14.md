# Independent adversarial QA — More help follow-up (after producer remediation)

STATUS: CURRENT
DATE: 2026-10-14 (America/New_York)
REVIEWER: Claude (independent, read-only; no implementation, deployment, migration, publication, billing or messaging actions)
FIRST REVIEW: `docs/qa/QA_MORE_HELP_CLAUDE_ADVERSARIAL_2026_10_13.md` (proposed FAIL / BLOCKED)
PRODUCER DISPOSITION CHALLENGED: `docs/qa/MORE_HELP_CLAUDE_QA_DISPOSITION_2026_10_13.md`
UPDATED PROMPT: `docs/qa/MORE_HELP_CLAUDE_ADVERSARIAL_QA_PROMPT_2026_10_13.md` (on `codex/more-help-production`)

## Proposed verdict: backend code PASS with conditions · production release BLOCKED · app NOT REVIEWED

The P0 from the first review is fixed and I verified it independently against Development as the runtime role, not from the producer's report. No remaining backend defect at P0–P2 was found. What remains open is not code: Development has no gateway key, so no real generation has ever succeeded; Development still holds zero published MCQs for these subjects; the app commit is unreachable from this session; the grader's own provider credits are still exhausted, which blocks the after-grade flow end to end. The feature is not Done and not live.

"PASS with conditions" means: the backend at the reviewed SHA has no confirmed defect that would block a controlled live test, and the live test is now the gate. It does not mean the feature works; nothing here has produced a single real explanation.

## Exact scope reviewed

| Item | Reviewed |
| --- | --- |
| Backend PR #435 head | `2fe007df514f4ea0420711244ad447023c12fd91`; code checkpoint `d2959e596185522e98227a62b73e9b7255ed22f9` is an ancestor and the only code-bearing commit since my first review (`62c8a6d`). Delta: `contract.ts`, `handler.ts`, `index.ts`, `model.ts`, new `diagnostics.ts`, `contract_test.ts` (9 → 18 tests), migrations `20261014014023_more_help_runtime_permissions.sql` and `20261014015127_more_help_quota_and_delivery_fencing.sql`, `supabase/tests/more_help_runtime.sql`, docs. |
| Development `wmgjsdkphcyhngaffbqf` | All four task migrations present in `schema_migrations`. Function `more-help` v5 (deployed 2026-10-14 02:12:40 UTC, `verify_jwt=true`); its `index/contract/handler/model/diagnostics` files compared line by line with `d2959e5`: identical. No invocation of the function has been logged since 00:30 UTC, so v5 has never run live. |
| App PR #21 @ `172c540d…` | **Not reviewed.** The repository is private and outside this session's GitHub credential (`add_repo` refused again at review time). The private snapshot named in the disposition lives on the producer's machine and did not reach me. Seams 3 and 5 stay blocked; the 1,102 app tests are producer evidence only. |
| Vercel AI Gateway documentation | **Blocked** (vercel.com unresolvable from the sandbox). Compatibility claims below are unverified by me. |

Local checks: 18/18 backend tests pass and `deno check` passes for handler/contract/model/diagnostics using the offline std-assert shim (`index.ts` typecheck still blocked by esm.sh). Eleven synthetic follow-up tests were run in scratch and not committed; nine fail for the documented reason (section 3).

## 1. Prior findings — independently verified disposition

| Finding | Verified state | How I checked |
| --- | --- | --- |
| P0-1 service_role could not UPDATE receipts or INSERT assistance events | **Fixed.** | `has_table_privilege('service_role', …)`: receipts SELECT/INSERT/UPDATE true, DELETE false; events SELECT/INSERT true, UPDATE/DELETE false; calls SELECT/INSERT true. `begin; set local role service_role;` no-op `update … where false`, `insert … where false` on all three tables and `fail_question_help(random, random, 1)` now succeed, rolled back. Old 2-argument `commit/fail` signatures and `reserve_question_help` have no EXECUTE for service_role, authenticated or anon; new signatures EXECUTE only for service_role. |
| P1-1 prompt-only answer withholding | **Owner decision recorded; tripwire implemented, gap remains.** | The before-phase check rejects "the answer is …", "final value is …", "Answer: …" and "Select/Choose/Pick B". Seven ordinary leak phrasings pass (section 3, R1). Human red-team on live outputs is still the real gate, as the owner chose. |
| P1-2 zero Development MCQs | **Open.** Producer proposes mirroring approved Production MCQs into Development; not done. |
| P1-3 app unreachable | **Open.** See scope table. |
| P1-4 provider/billing | **Owner chose the demo's Anthropic Gateway path; adapter switched, not merely prepared.** `OPENAI_*` is no longer read by More help; `AI_GATEWAY_API_KEY` preflight runs after the question RPC and before any reservation (test present). The grader still depends on OpenAI credits, which remain exhausted; the after-grade flow therefore cannot be exercised end to end in Development today. |
| P2-1 failures burn quota | **Fixed as designed.** Delivered allowance 30/24 h counts delivered receipts plus live leases only; attempted calls are bounded separately at 6/min, 90/user/24 h, 1,000/site/24 h via the new `app.question_help_calls` table (6 pre-existing rows backfilled). The 1,000/site constant remains hard-coded (rollout-protocol item). |
| P2-2 `uncertain` as before-phase | **Fixed for `phase:"after"`** (409 `help_grade_pending`). Not for `phase:"before"` (R2). |
| P2-3 everything 403 | **Fixed.** 400/403/409/429/503 mapping plus `retryAfterSeconds` and `Retry-After` header; tests assert statuses. |
| P2-4 hook `sourceNote` leak | **Fixed.** Hooks, items and choices are allowlisted. I confirmed the Development data shapes match the allowlist: every published entry's `items[]` uses `{label, meaning}` and every published hook's `expandsTo[]` uses `{cue, means}`, so nothing is silently blanked. |
| P2-5 expired worker commits newer lease | **Fixed by generation fencing.** `commit`/`fail` require `delivery_attempts = p_generation`; reserve returns the generation; handler rejects a reservation without one in 1–3. The producer's rolled-back service-role batch covers stale commit/fail and expired-lease recovery; I read the SQL and the assertions are null-safe. |
| P3-6 legacy `working` rows | Preserved, now with call rows; harmless; still Development fixture cleanup. |
| P3-7 no RPC logging | **Fixed** (operation + SQLSTATE only). Narrow regex, see R4. |
| P3-8 highlights across math | **Fixed on the server** (inline, display and `\(…\)`/`\[…\]` spans; cap 4). |
| P3-9 global advisory lock | Retained, as stated. |
| P3-10 rollback | Correctly updated: older function versions fail closed against revoked signatures. |

## 2. New verification I ran

- Role-correct no-op write checks as `service_role` (above).
- RPC definitions in Development match the migration: `reserve_question_help_delivery` references `question_help_calls`; the three-argument `commit`/`fail` reference `p_generation`; all `SECURITY INVOKER`, `search_path=''`.
- Deployed v5 source equals `d2959e5` for every More help file.
- Function logs 00:30 UTC → now: no requests. The v5 commit path, like v4's, has not executed live; the runtime SQL batch is the only role-correct evidence and I accept it as such because its assertions would fail on the grant bug.
- The repository's Minimal CI does not run `supabase/functions/more-help/contract_test.ts` on either branch; the 18 tests are local-only evidence (R5).

## 3. Residual findings (none blocking the controlled live test)

**R1 — P2, owner-accepted policy, worth one cheap extension.** The before-phase tripwire misses the phrasings a model most naturally uses. Synthetic inputs that pass `validateHelp(…, before=true)`: "B is correct.", "The correct one is B.", "Option B matches this.", "So the rate is (45−5)/4 = 10 L/min, which is choice B.", "You get 10 L/min, i.e. 10 litres per minute.", "Answer B.", "Go with B." The owner rejected numeric/choice-text equality for good reasons; a second narrow pattern costs nothing and catches five of these: any bare choice letter adjacent to "option/choice/answer" or followed by "is correct/right" (`\b(?:option|choice|answer)\s+\(?[A-E]\)?\b`, `\b[A-E]\s+is\s+(?:the\s+)?(?:correct|right)\b`). Computed final values stay a human-review item. Regression: add the seven strings to the existing test, six rejected, the "i.e." case documented as allowed.

**R2 — P3.** `help_grade_pending` fires only when the client sends `phase:"after"`. With `phase:"before"` on a submitted `uncertain` item the server returns before-phase setup help (no coaching, so no scoring harm) and `phase:"before"` copy on a graded page. Make the refusal depend on the server state (submitted and uncertain, no draft), not the client's phase.

**R3 — P3.** Refusal is terminal only in the client. Server-side, `help_refused` runs the normal `fail` path, so the same `requestId` can be re-reserved at generations 2 and 3 and billed twice more for an input the model already refused. Record the refusal on the receipt (a `refused` state or reason) and return `retry_exhausted` for that hash. Regression: SQL batch step "refused receipt re-reserve → retry_exhausted".

**R4 — P3.** `rpcFailure` logs only codes matching `^[0-9A-Z]{5}$`; PostgREST errors such as `PGRST202` (function or overload not found, exactly the class of failure the overloaded `commit_question_help` could produce) log as `unknown`. Accept `^PGRST\d{3}$` too.

**R5 — P3, process.** Add the More help test file to `minimal-ci.yml`'s list; today a regression in these 18 tests would not fail CI.

**R6 — P3, UX.** 6 attempts per minute per student is reachable by a legitimate fast student (open help, three follow-ups, one retry). The 429 carries `Retry-After` ≤ 60 s; whether the app shows it is unverified.

Unchanged from the first review and still acceptable for pilot: 50 s lease against a 35 s model timeout; global advisory lock; 1,000/site/day constant.

## 4. Unverified compatibility claims (first live call decides)

The adapter sends to `https://ai-gateway.vercel.sh/v1/chat/completions`: `model: anthropic/claude-haiku-5.5`, `store:false`, `max_tokens: 2500`, `reasoning: {effort: "none"}`, `response_format: {type: "json_schema", json_schema: {strict: true, schema}}` with `enum` on array items and `minItems/maxItems`. The producer cites the gateway's structured-output and reasoning docs and a live catalog check; I could not open those pages. If the gateway or the Anthropic backend rejects any keyword, the function returns `help_unavailable` with only the HTTP status logged, so the first controlled call must capture the gateway status code and, out of band, the response body. The adapter also assumes `message.content` is a string; an array-form content (some gateways) is rejected as `invalid_model_output` (synthetic test).

## 5. Coverage matrix (follow-up)

| Seam | Observed live | Locally tested | Source-only | Blocked |
| --- | --- | --- | --- | --- |
| Grants, revoked signatures, SECURITY INVOKER, RLS | Dev, as service_role | — | migrations | Production |
| reserve → generate → commit/fail with fencing | Dev RPC defs; producer rolled-back batch read | 18 repo tests + 11 synthetic | handler/SQL | live path (no key) |
| Quotas: delivered vs attempted, burst, retry-after | — | repo tests (stubbed) | SQL | live |
| Error status mapping, Retry-After | — | repo tests | handler/index | app handling |
| Pre-submit disclosure tripwire | — | repo tests + 7 synthetic bypasses | contract.ts | human red team on live output |
| Hook/item/choice allowlist | Dev data shapes | repo test | contract.ts | — |
| Math-safe highlights | — | repo test | contract.ts | app rendering |
| Gateway payload/response handling | — | stub tests | model.ts | gateway docs, live call |
| Deployment: v5 = checkpoint, JWT, migrations | Dev | — | — | Production |
| App submission, photo, UI, a11y | — | — | — | PR #21 @ 172c540 |
| MCQ path | — | — | — | no Dev MCQs |

## 6. Minimum remaining conditions for a production release

1. Install the existing server-owned `AI_GATEWAY_API_KEY` in Development; make one controlled authenticated call per subject (FRQ, before phase) and record gateway status, `finish_reason`, token usage, latency and `has_question_help = true` with one `more_help` event per draft.
2. Mirror a small approved MCQ set into Development; repeat the matrix for MCQ before/after.
3. Restore the grader's provider connection or otherwise obtain graded attempts so the after-phase help path runs end to end.
4. Human red-team on the live outputs (section 3, R1 list plus the prompt's injection cases); any disclosure blocks until fixed or accepted in writing.
5. Independent review of app PR #21 with source access (grant the Claude GitHub App on `ap-prep-blueprint`, or supply the snapshot through a channel this session can read).
6. Optional but cheap before Production: R1 pattern, R3 refused state, R4 regex, R5 CI entry.
7. Production: four migrations in order, function deploy, `AI_GATEWAY_API_KEY` secret, signed-in smoke, rollback note (older function versions fail closed).

## Evidence notes

- All Development access was read-only or `begin … rollback` with `where false` and random ids; no student identity, work or history was read. No migration, deploy, secret, Lovable, message or billing action was taken.
- Synthetic follow-up tests live in the review scratch directory only and are labelled synthetic.
- The producer's `supabase/tests/more_help_runtime.sql` was read, not executed by me; its structure (role switch, null-safe assertions, full rollback) is sound, and the owner's instruction to run it against the task QA account is recorded in the disposition.
