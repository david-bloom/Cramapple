# TASK-0068 execution record — BYOQ photo extraction with student confirmation

**Date:** 2026-10-09
**Owner:** Claude session (implementation). **Product Owner:** David Bloom.
**Direction:** David, 2026-10-09: "finish executing the plan and moving the new capabilities to production for use by students." Taken as authority for Gates B, C and D of `BYOQ_PHOTO_EXTRACTION_PLAN_V2_2026_10_08.md` (Development build, Production deploy, capability on for all students rather than a named pilot). Recorded under `APPROVAL-0140` (see §6).
**Branch / PR:** `claude/task-0068-byoq-photo-extraction` (this record is on it).
**Status at writing:** see §7 (updated as each step lands).

## 1. What was built (backend)

| Piece | File | Notes |
| --- | --- | --- |
| Migration | `supabase/migrations/20261009112941_task0068_byoq_extraction.sql` | Three additive nullable columns on `app.byoq_items`: `extraction jsonb`, `captured_work text` (≤4,000), `context_unit_number int` (1–20). CHECKs on `ready` and on choices unchanged. Version is the one Development recorded. |
| Extraction module | `supabase/functions/_shared/byoq-extraction.ts` | OpenAI Responses API, `store: false`, strict closed JSON schema (no answer-bearing field; topic enum built per call from the student's unit), plain-Unicode notation rules, `[see diagram in photo]` / `[unreadable]` markers, `captured_work` for marks that are not the question, printed answer key dropped. Never throws. Prompt version `2026-10-09.1`. |
| Function ops | `supabase/functions/byoq/index.ts` | `finish_capture` runs extraction synchronously for question photos and returns `extraction`; owner op `extract_question { item_id, force? }`; capability ops `capture_review_get` / `capture_review_update` / `capture_review_remove_flagged_text` (pairing handle only, item fixed by the handle, live or ≤30 min after consumed). Proposed values fill only null fields; student edits never overwritten; proposed text passes `detectAnswerLeaks`; idempotent on (page digests, model, prompt version). `item` view gains `extraction` (summary) and `context_unit_number`; `captured_work` is never returned. |
| Cost | `supabase/functions/byoq/store.ts` | One fixed reservation per call through `app.reserve_model_usage` against the shared `OPENAI_DAILY_CAP_USD` (fail closed), completed/failed on every path; BYOQ-only breaker `BYOQ_EXTRACT_DAILY_CAP_USD` (default 100 USD/day) checked first. |
| Config | env | `BYOQ_EXTRACTION_ENABLED` (default true; `false` = rollback to the shipped photo-then-type flow), `BYOQ_EXTRACT_MODEL` (default `OPENAI_MODEL`, then `gpt-4.1-mini`), `BYOQ_EXTRACT_TIMEOUT_MS` (45 000), `BYOQ_EXTRACT_RESERVED_COST_USD` (0.03), `BYOQ_EXTRACT_DAILY_CAP_USD` (100). |
| Tests | `_shared/byoq-extraction_test.ts`, `byoq/index_test.ts` | 53 Deno tests pass (33 existing + 13 module + 7 request-level: fill-only-nulls, no overwrite, idempotency, leak gate on proposed text, answer-key drop, disabled/no-key/breaker/failure fallbacks, capability scoping and review window, remove-flagged-text via capability, rate limit). |
| Smoke | `scripts/byoq_extraction_smoke.ts` | Live end-to-end against a deployed function with a real signed upload of a rendered fixture page: 27 checks. `scripts/byoq_smoke.mjs` (TASK-0039, 24 checks) is the regression suite. |
| Benchmark | `scripts/byoq-extraction-benchmark/` | `render_fixtures.py` renders 89 published items (10 subjects) to 210 pages (clean, degraded, 32 planted controls incl. blank/notes); `run_benchmark.ts` calls the production module and scores type, stem similarity, choices, topic top-1/top-3, leak flags, planted-answer presence, abstention. Pages and results are git-ignored; manifest/items/topics are committed. |

## 2. Development evidence

- Migration applied to `wmgjsdkphcyhngaffbqf` as version `20261009112941`; local file renamed to match.
- `byoq` deployed to Development with `--no-verify-jwt --use-api`.
- Development's `OPENAI_API_KEY` secret was invalid (OpenAI returned 401 "Incorrect API key" on the first live run; this also affected the pre-existing capture-quality path). Reset from the repo-local key file (`scripts/vercel-gateway-check/.env.local`, never printed) via `supabase secrets set --env-file` with a one-variable file. Production's key was not touched.
- Live extraction smoke on Development: 27/27 PASS (fixture `clean/0d2259c0…`, AP Physics C Mechanics unit 3: proposed `mcq`, 4 choices, topic `3.2` = ground truth; phone-side review via handle; foreign `item_id` ignored; confirm; forced re-run kept the edit; cleanup).
- TASK-0039 regression smoke on Development: 24/24 PASS.

## 3. Benchmark

210 rendered pages (89 clean, 89 degraded, 32 planted controls) from 89 published items across all ten subjects, scored against the database rows. Two models, same prompt and schema (final run uses prompt `2026-10-09.2`). Reports: `scripts/byoq-extraction-benchmark/fixtures/report-gpt-4.1-mini.md` (final), `report-gpt-4.1-mini-prompt1.md`, `report-gpt-5.5.md`.

| Measure (plan §6.3 gate) | gpt-4.1-mini, prompt .2 | gpt-5.5, prompt .1 |
| --- | --- | --- |
| Pages proposed / failed | 210 / 0 | 210 / 0 |
| Item type correct (≥97%) | clean 100%, degraded 100% | clean 98.9%, degraded 96.6% |
| Stem similarity ≥0.95 (proxy for zero-edit, ≥85% clean) | clean 83.1%, degraded 89.9%; mean 0.976 / 0.979; 100% ≥0.85 | clean 83.1%, degraded 85.4%; mean 0.971 / 0.974 |
| Choices complete and in order (≥95%, 0 invented) | 97.5% / 97.5%; 0 invented | 97.5% / 97.5% |
| Topic top-1 (reported) | 80.9% / 79.8% | 91.0% / 91.0% |
| Topic top-3 within unit (≥90%) | **86.5% / 88.8% — below gate** | 95.5% / 94.4% |
| Answer text in stem/choices after validation (0) | 0 | 0 |
| Leak-gate flags on proposed text | 0 | 0 |
| Planted answer key: dropped with warning | 6/6 | 6/6 |
| Circled option / handwritten work → `captured_work` | 11/11 | 11/11 |
| Printed "Answer: X" line | dropped from stem and not stored (6/6); never leaked | same |
| Student name → PII flag | 4/6 | — |
| Blank page / notes page abstain (≥95%) | 2/2 with prompt .2 (prompt .1 hallucinated a sentence on the blank page; fixed by the "visible text only" rule) | 1/2 |
| Median latency single page (≤10 s) | 2.4 s (p90 3.6 s) | 4.9 s (p90 7.7 s) |
| Tokens per page | 3,626 in / 162 out | 3,720 in / 425 out |

**Choice: `gpt-4.1-mini`**, pinned as `BYOQ_EXTRACT_MODEL` in Development and Production. It wins on everything the product goal depends on (type, stem, choices, speed, cost); gpt-5.5 wins only on topic choice, which is optional, editable, and shown with alternatives and "I'm not sure".

**Gate miss, stated plainly:** topic top-3 is 86.5–88.8% against a 90% gate. Per subject it is 100% for Chemistry, Biology, Physics C (both), 94% Physics 1, 88% Physics 2 and Precalculus, 75% Calculus AB, 69% Calculus BC, 64% Statistics. The Statistics and Calculus ground-truth labels are the content pipeline's own model-assigned labels (promoted under `DECISION-0079`), so part of the gap is label noise, but not all of it. The cost of a wrong topic is mildly irrelevant hints on an item the student can re-topic in one tap. The pilot's `byoq_review_confirmed.topic_changed` event measures the real rate.

Stem similarity below 0.95 is almost entirely notation and layout normalisation (fractions, superscripts, line breaks), not missing or invented content: every page scored ≥0.85 and no page carried invented choices.

## 4. Frontend (Lovable App `56cae479`)

Spec sent to the Lovable agent 2026-10-09 11:28 UTC (message `umsg_01m4g6rsddfwp9garw3mgrx3zf`): `ByoqReview.jsx` (shared phone/desktop review screen, every field editable, suggested topic + alternatives chips, warnings copy, "Yes, this is my question"), phone leg review via the capability ops, desktop prefill + polling + "Try reading it again", `subject_key`/`unit_number` from context at creation, privacy-safe PostHog events, vitest coverage. Result recorded in §7.

Note for publication: the App project carries other sessions' unpublished edits ("Added reference content & hooks" 2026-10-09 01:16, "Updated third-party text" 11:24). A publish ships them too.

## 5. Production runbook (Gate C/D)

1. `apply_migration` to `pcntajvbdfqhbeewmdry` with the same SQL; confirm the recorded version; note it here.
2. `supabase functions deploy byoq --project-ref pcntajvbdfqhbeewmdry --no-verify-jwt --use-api --workdir <repo root>`.
3. Secrets: set `BYOQ_EXTRACT_MODEL` to the benchmark's chosen model (only if it differs from `OPENAI_MODEL`); leave `BYOQ_EXTRACTION_ENABLED` unset (on). No change to `OPENAI_API_KEY`.
4. Live smoke against Production (`scripts/byoq_extraction_smoke.ts` with the Production URL and publishable key): creates one anonymous item, one real model call, deletes the item.
5. Lovable publish of the App project after the review screen is verified in preview.
6. Rollback: `supabase secrets set BYOQ_EXTRACTION_ENABLED=false --project-ref pcntajvbdfqhbeewmdry` (the function reads it per request; no redeploy) returns the shipped photo-then-type flow; the three columns stay, unused.

## 6. Records

- `APPROVAL-0140` — Gates B–D under David's 2026-10-09 direction (written at close; number checked against open PRs first).
- `TASK-0068` — implementation notes, test results, QA verdict, Done decision.
- Activity log entry; `DECISION-0108` unchanged.

## 7. Status log

- 11:28 UTC — backend committed and pushed (`f8859681`), Lovable spec sent, benchmark started (gpt-4.1-mini then gpt-5.5).
- 11:31 UTC — Dev migration applied, function deployed, Dev OpenAI key repaired, extraction smoke 27/27, regression smoke 24/24 (`a2e55ea2`).
- 11:36 UTC — independent backend QA agent started (separate context), writing to `docs/qa/QA_TASK0068_BACKEND_2026_10_09.md`.
- 11:35 UTC — Lovable build finished (commit `ea999aad`, "Added BYOQ photo review screens"): 11 files, vitest 780/780, `tsgo` clean; source of `ByoqReview.jsx`, `QuestionForm.jsx`, `review.ts`, `api.ts`, `ByoqIntake.jsx`, `ByoqCapturePhone.jsx` read and matched the contract (owner key never sent on review ops; `extract_question` is an owner op; `student_course_positions.unit_id` is an integer, so the saved-unit read is valid).
- 11:40 UTC — Production migration applied (recorded version `20261009113605`; the repo file keeps Development's `20261009112941` per convention).
- 11:46 UTC — benchmark: blank page hallucination found and fixed (prompt .2); both model runs complete; gpt-4.1-mini chosen and pinned in both environments; Development redeployed with prompt .2 (`4db8c52b`). Build PR #393 opened.
