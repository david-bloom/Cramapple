# TASK-0079 — Behaviour-preserving split of `evaluate-attempt`

**Status:** In Progress — S0–S4 on branch `claude/codebase-refactoring-cwj8by` (PR #679); S5 not started; nothing deployed
**Tier:** Standard for source slices. Any deploy of `evaluate-attempt` (Development or Production) is Hard-Gate and needs
its own `APPROVAL`, following the A6 pattern in TASK-0078 (deploy from `main`, bundle diff, boot checks, approval file).
**Owner:** Claude (executing); David Bloom (Product Owner, merges and approves releases)
**Date opened:** 2026-11-26
**Requested by:** David, 2026-11-26 ("start a cramapple session focused on refactoring the code base"; scope chosen:
split `evaluate-attempt`)
**Related:** TASK-0078 (backend stability; A4 grade-store failure semantics, A6 last Production deploy of this function,
A14 shared-module release rule), `docs/qa/SHARED_MODULE_DEPENDENCY_MAP_2026_10_21.md`.

## 1. Why

`supabase/functions/evaluate-attempt/index.ts` was 2,907 lines, and one function, `handleEvaluateAttempt`, ran about 1,700
of them. It is the grading core: every MCQ and FRQ score passes through it. Five grading routes (MCQ rule, LLM text,
symbolic ECF, data-driven, shadow review), the replay and recovery path, the budget reservation and two post-grade
side-effect sequences all live in that one function body. A change to any route means reading all of them.

## 2. Rules for every slice

1. **No behaviour change.** A slice moves or restructures code only. Bugs found along the way are recorded in §5, not
   fixed inside a refactor slice.
2. **Golden traces are the contract.** `golden_test.ts` records, for 19 scenarios, every Supabase call (table or RPC,
   action, filters, modifiers, payload), the hash and size of every OpenAI request, and the response status and body.
   A slice passes only if `golden_fixtures.json` is unchanged. Regenerating the fixtures is a behaviour change and
   needs a reviewed reason in the PR body.
3. **One slice per commit**, tests green at each commit (`index_test.ts` + `golden_test.ts`).
4. **Source only until David approves a release.** Each merged slice makes the deployed bundle differ from `main`
   (see §4).

## 3. Slices

| # | Slice | State | Evidence |
| --- | --- | --- | --- |
| S0 | Golden characterization tests: recording mock + 14 scenarios (MCQ right; MCQ wrong with skill/unit; LLM arm B graded; arm B provider failure; budget capped; Statistics scoped override; Statistics unscoped fallback; symbolic ECF with and without a verifier item; data-driven graded; data-driven abstain; shadow review; replay of a stored grade; QA no-persist). Added to Minimal CI | **done** | 14 pass, stable over repeated runs under CI's `env -i` permission set; fixtures generated from `main` `535df62` |
| S1 | Move leaf code out of `index.ts`: `config.ts` (env, version stamps), `openai-client.ts` (grader client, retry), `mcq-feedback.ts` (`composeMcqFeedback`, choice parsing), `grade-store.ts` (grading_results writes, checkpoint, telemetry, criterion rows) | **done** | `index.ts` 2,907 → 2,181 lines; line-multiset diff shows only imports, header comments and `export` keywords differ; `deno check` and `deno lint` clean; 53/53 tests pass; fixtures unchanged |
| S2 | One `runModelGrading()` (`model-grading.ts`) for the arm A / arm B call, used by both the live path and `qa_no_persist`, which each carried a copy | **done** | S2a: four arm A goldens (graded; one criterion failing; every criterion failing; QA no-persist) recorded on the unchanged code with `GRADING_ARM=a` at process start; `GRADING_ARM` then read once per request (`gradingArm()`), so both arms run in one test process; all traces unchanged. S2b: a golden for a provider reply of JSON `null` (sanitizer throws; arm B still stores the raw response and the estimated token count) recorded before the change; the shared function keeps that through an `onModelReturned` hook, and a mutation that drops it fails the golden. 58/58 tests; `index.ts` 2,181 → 2,109 lines |
| S3 | Route branches become functions: `deterministic-routes.ts` (`gradeSymbolicEcf`, `gradeDataDriven`, `gradeShadowReview`, each returning `{ finalPayload, finalStatus, shadowResult?, deterministicVerifierVersion? }`) and `mcq-context.ts` (`loadMcqFeedbackContext`, the MCQ skill/unit lookup) | **done** | bodies moved verbatim (whitespace-normalised line diff: only signatures, destructuring, returns, assignment→declaration); 19 golden traces unchanged; a mutation flipping the data-driven verdict fails its golden; 58/58 tests; `index.ts` 2,109 → 1,762 lines |
| S4 | Request parsing (`request.ts`: `parseEvaluateRequest`), the two load phases (`load-context.ts`: `loadAttemptContext`, `loadItemContext`) and the replay/recovery responder (`replay.ts`: `createStoredResultResponder`, formerly a closure) | **done** | each loader returns rows or the early-exit `Response`, which the handler returns unchanged, so every early-exit line moved byte-for-byte; query order unchanged (the replay lookup stays between the two phases); whitespace-normalised line diff shows only signatures, parameter types and three `instanceof Response` checks; replay/recovery covered by the 9 existing `index_test.ts` recovery tests, success paths by the goldens; 58/58 tests; `index.ts` 1,762 → 1,362 lines |
| S5 | One post-grade finalize sequence (grade write → checkpoint → telemetry → attempt truth → memory → cell state) shared by the MCQ path and the model path, keeping each path's current differences explicit as parameters | not started | the two copies differ today (§5, items 4 and 5); the shared version must reproduce both exactly |

Target after S5: `index.ts` is the HTTP entry and orchestration (roughly 400–600 lines), each route is readable on its
own, and the route modules can get focused unit tests.

## 4. Release

Production runs `evaluate-attempt` v82 (`a1336c20…`, TASK-0078 A6, 2026-10-21). After any slice merges, `main` and
Production differ in file layout but, per the golden traces, not in behaviour. The function does not need to be
redeployed after each slice; one release after S5 is the plan. That release follows the A6 pattern: Development
deploy, bundle diff against `main`, boot checks, one signed-in grade on Development per route that has live content,
then Production under an `APPROVAL`.

## 5. Pre-existing findings (recorded, not fixed here)

Each needs David's call before a separate fix slice. None is introduced by this task.

1. **Arm A had no test coverage** (closed for tests by S2a: four arm A goldens). Whether Production runs arm A is
   still not verified (secret values are not readable).
2. **Any `reserve_model_usage` failure is shown as the daily budget cap.** The RPC's `error` is never read; a database
   error and a real cap both return `429 budget_capped` with "Cramapple has reached today's research limit." A
   database outage reads to a student as a spending limit.
3. **Unread errors before and after the model call:** the `status: processing` re-stamp of `grading_results`, the
   `model_usage_ledger` `running` update and the `complete_model_usage` RPC all ignore their `error`. A failed
   `complete_model_usage` leaves a ledger row reserved, which counts against the daily cap until it is reconciled.
4. **MCQ grades never fire `first_response_graded`.** Only the model path records it. `attempt-response` also records
   the event on its own path; whether that covers MCQ is **not verified**. If it does not, a student whose first
   graded answer is an MCQ is never counted, because later FRQ grades see a prior graded result.
5. **The attempt-truth update has no status fence on the live paths.** The recovery path updates `app.attempts` only
   where `status = 'submitted'`; the MCQ and model paths update by `id` alone, so a late request can overwrite a
   finalized attempt's score.

6. **A provider reply of JSON `null` is stored with an estimated token count.** On arm B the sanitizer throws on a
   non-object reply after usage is known but before it is read, so `grading_results.input_tokens` holds the
   pre-call estimate and `complete_model_usage` is charged at that estimate with `actual_cost` 0. Rare, and pinned
   by a golden so a later fix is deliberate.

## 6. Local test method

Minimal CI's deterministic step, run locally:

```bash
ENVS=$(sed -n 41p .github/workflows/minimal-ci.yml | sed 's/^ *//')
env -i PATH="$PATH" HOME="$HOME" deno test $ENVS \
  supabase/functions/evaluate-attempt/index_test.ts \
  supabase/functions/evaluate-attempt/golden_test.ts
```

In cloud sessions where `esm.sh` is blocked by the network policy, add `--import-map=<file>` mapping the three
`https://esm.sh/...` imports (`@supabase/supabase-js@2.49.1`, `standardwebhooks@1.0.0`, `stripe@22.0.0`) to the same
versions under `npm:`. The map is a local test aid only; it is not committed and does not change what is deployed.
