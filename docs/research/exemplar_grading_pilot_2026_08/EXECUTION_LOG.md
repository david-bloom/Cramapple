# Execution log — exemplar-grading pilot — 2026-08-10

## Synthetic pilot identity

- `user_id`: `60646a2f-9ec3-4ed3-9f33-2b7c9b9eb069`
- `email`: `exemplar-pilot-20260810-3c8f61b5+test@cramapple-internal.test`
- Created via `create_pilot_session.mjs` by the repo owner; email-confirmed
  and given an `active` `app.subject_entitlements` row (`ap-statistics`,
  `beta` tier, `source: 'exemplar_grading_pilot_2026_08'`) directly in the DB
  to satisfy `attempts_entitled_owner_insert`'s RLS policy, which the
  original plan didn't anticipate needing.

## Runs

- Sizing run (`PILOT_MODE=size`): 20/20 calls succeeded, 100% trial
  agreement on all 4 criteria of `APSTATS-SFRQ-001#0` (`arm=off`).
- Full run (`PILOT_MODE=full PILOT_TRIALS=5`): 300 calls attempted.
  - First attempt: 1 call failed with `409 content_not_published`
    (`APSTATS-SFRQ-003`, later confirmed `content_item_versions.status =
    'retired'`) before the item-exclusion fix; corpus corrected to 30
    gradable responses (300 → 300 calls after exclusion, since the corpus
    filter runs before the call list is built).
  - Second attempt (post-fix): 271/300 succeeded, then 29 failed with `401
    UNAUTHORIZED_ASYMMETRIC_JWT` — the pilot session's 1-hour access token
    expired mid-run.
  - Third attempt (after `--signin` refresh): all 29 remaining calls
    succeeded. Final: 300/300 real grading calls completed across both runs
    combined (300 unique calls once size-run overlap and failed retries are
    accounted for).

## Cleanup (completed 2026-08-10, same session as the run)

Deleted, scoped strictly to `user_id = 60646a2f-9ec3-4ed3-9f33-2b7c9b9eb069`:
- `app.grading_results` (315 rows, via `attempt_id` join)
- `app.response_versions` (31 rows, via `attempt_id` join)
- `app.attempts` (31 rows)
- `app.subject_entitlements` (1 row)
- `app.profiles` (1 row)
- `auth.users` (1 row)

No `app.student_memory_events` or `app.student_memory_snapshots` rows
existed for this user (checked before cleanup — 0 in both).

Verified post-cleanup: a query across `auth.users`, `app.profiles`,
`app.attempts`, `app.subject_entitlements`, and `app.grading_results` (via
join) for this `user_id` returns 0 rows in every table.

## Data kept (intentionally, per the plan's Files list)

`raw_calls.jsonl`, `results_with_exemplar.json`,
`results_without_exemplar.json`, `raw_trial_variance.json`, `report.json`,
`REPORT.md`, `gold_cases_gradable.json` — all in this directory, all derived
from a synthetic account's grading calls against real published content, no
real student data involved.

---

# Execution log — grading-engine replan Step 3, Run A — 2026-08-13

Separate identity from the 2026-08-10 pilot above (that one was fully
cleaned up per O3, confirmed zero rows). New synthetic identity created for
this run, per the same create→run→cleanup protocol
(`GRADING_ENGINE_REPLAN_EXECUTION_PLAN_2026_08_10.md` §3.0/§3.1).

## Synthetic pilot identity

- `user_id`: `e5b041cb-9d4f-497c-b6c8-f66af4cf8152`
- `email`: `exemplar-pilot-20260813-f46df3c7+test@cramapple-internal.test`
- Created via `create_pilot_session.mjs` by the repo owner; assistant
  confirmed the email directly in the DB (Production requires email
  confirmation for sign-in), ran `--signin`, and granted the same
  `app.subject_entitlements` row shape as the 2026-08-10 precedent
  (`ap-statistics`, `beta` tier, `source:
  'grading_engine_replan_2026_08_13_o2_smoketest'`) — needed for the same
  `attempts_entitled_owner_insert` RLS reason.
- Also used for the O2 authenticated smoke test earlier the same session
  (see `ACTIVITY_LOG.md`, "O2 Authenticated Smoke Test Passed") — one
  identity, two runs, cleaned up independently after each.

## Run A

**Purpose:** measure recovered accuracy on the exact 13 responses the
deterministic gate short-circuited in the original pilot's `arm=off`
capture (verified by scanning `raw_calls.jsonl` for
`model_id="deterministic-statistics-prefilter"`, not assumed from the
writeup's "~14" estimate): `APSTATS-SFRQ-001#6/#7`, `APSTATS-SFRQ-008#0..#7`
(all 8), `APSTATS-SFRQ-009#0/#1/#4`. 13 cases × 5 trials × 1 arm (`off`,
production prompt) = 65 calls, against the corrected O1 keys + O2 scoping
(both already deployed, `evaluate-attempt` v39).

**Script:** a filtered, scratch copy of `run_pilot.mjs`'s FULL-mode logic
(same `deterministicUuid`/`shuffle`/`buildCall` shape, same
idempotency-key resume behavior) scoped to the 13-case set instead of the
full 30-case corpus — `run_pilot.mjs`'s `gold_cases.json` path isn't
parametrized, so reusing it directly would have run the whole corpus.

**Execution:**
- First attempt: all 65 calls failed immediately with `401 JWT expired`
  (the smoke-test session had aged out) — zero cost, zero rows created,
  since the failure was in the `attempts`/`response_versions` REST
  prerequisite calls, before `evaluate-attempt` was ever reached.
- Re-signed in (`--signin`), restarted: 65/65 calls succeeded (1 resumed
  from a stray partial write during a manual restart, 64 fresh). Zero
  failures.

**Result:** all 13 cases now reach real model grading — **zero** hit the
deterministic gate (matches the plan's pre-registered expectation, "SFRQ-008
moves off 0%"). Scored with the actual harness
(`scripts/grading-model-assessment/main.ts --policy partial-v2`) against a
gold subset filtered to these 13 cases:

| metric | value |
|---|---|
| overall accuracy | 61.3% (19/31 criteria) |
| selective accuracy | **100%** — zero wrong grades among committed criteria |
| coverage | 61.3% (= overall accuracy; all inaccuracy is abstention, not wrong answers) |
| exact-case accuracy | 30.8% (4/13 cases fully correct) |
| false positive / false negative rate | 0% / 12.5% |

Full report: `report_runA.json`. Per-case: `results_runA.json` (harness
`ResultCase[]`), `raw_trial_variance.json` → `raw_trial_variance_runA.json`
(3 of 39 case×criterion combinations had <75% trial agreement — see that
file). Gold subset used: `gold_cases_runA.json`. Raw capture:
`raw_calls_runA.jsonl` (65 records).

**Reading the numbers:** selective accuracy at 100% is the headline finding
— every criterion the grader was willing to commit a verdict on was
correct; 100% of the measured error is abstention (`unable_to_determine`),
not a wrong grade. This lines up exactly with the smoke test's own finding
earlier the same session: the ceiling on recovered credit is currently the
evidence-grounding false-alarm rate (`grading-feedback_test.ts`'s
documented ~10% class), not grading correctness. `total_cost_usd` in
`report_runA.json` ($0.081) is the harness's own per-case aggregate;
$0.4041 is the real total spend across all 65 individual API calls
(`app.model_usage_ledger`, verified by direct query on the 65 idempotency
keys) — within the plan's $0.50–1 estimate.

## Cleanup (completed 2026-08-13, same session as the run)

Deleted, scoped strictly to the 13 `attempt_id`/`response_version_id`
pairs and their `grading_results` rows this run created:
- `app.grading_results`: 0 remaining (deleted by `attempt_id`)
- `app.response_versions`: 0 remaining (13 deleted)
- `app.attempts`: 0 remaining (13 deleted)

Verified post-cleanup via count query against all three tables scoped to
the 13 IDs — confirmed 0/0/0.

**Not cleaned up:** the pilot identity itself (`app.profiles`, `auth.users`,
`app.subject_entitlements`) — left intact in case Run B/C reuse it. Clean
up when Step 3 concludes or is abandoned. `app.model_usage_ledger` rows for
the 65 calls kept, per the 2026-08-10 precedent (billing/audit ledger, no
user linkage after `attempts`/`response_versions` cleanup).

## Data kept (this run)

`raw_calls_runA.jsonl`, `results_runA.json`, `raw_trial_variance_runA.json`,
`report_runA.json`, `gold_cases_runA.json` — all in this directory, all
derived from a synthetic account's grading calls against real published
content, no real student data involved.

---

# Execution log — grading-engine replan Step 3, Run B/C — 2026-08-13

Same session, same pilot identity as Run A above
(`e5b041cb-9d4f-497c-b6c8-f66af4cf8152`).

## Run B — closed without spending, per owner decision

**Purpose (plan §3.2):** measure prompt-caching hit rate and TTFB/cost
deltas from a byte-stable ≥1024-token prompt prefix.

**Finding, structural, zero cost:** checked `buildGradingPrompt` +
`buildSystemPrompt` (`grading-contract.ts`) directly against a real
item's actual stem/stimulus/rubric (`APSTATS-SFRQ-008`). The prefix (system
prompt + everything before the student's response text) **is** byte-stable
across different responses to the same item — confirmed by direct
comparison, not assumed. But it is only **~540 tokens** (char-count
estimate), well under OpenAI's **1024-token minimum** for automatic prompt
caching to activate at all. The plan's own Run B design already
anticipated needing "a byte-stable ≥1024-token prefix," i.e. assumed a
prompt-restructuring change would land before this measurement — that
change was never made.

**Decision (owner, informed by this finding):** skip the paid ~$1 batch.
Running it as originally scoped would, with high confidence, just
reconfirm the zero-cached-tokens baseline already on record from the
2026-08-10/11 capture — not a new data point. Direction closed per the
plan's own decision rule ("otherwise close the direction with the
measurement recorded") until/unless the prompt is deliberately consolidated
to cross the 1024-token floor, at which point this measurement should be
redone for real.

**No Production writes, no cost, nothing to clean up.**

## Run C — Arm A (per-criterion fan-out) latency + quality on gpt-4.1-mini

**Purpose (plan §3.3):** Phase C (2026-07-27) validated Arm A on
`gemini-2.5-flash` (handoff trap 1 — wrong model). Re-measure on the actual
production model, `gpt-4.1-mini`: confirm/refute the "~16s → ~4s" latency
expectation and check quality parity (2026-07-29 found Arm A 0/6 correct
in an earlier narrow test).

**Mechanism:** `GRADING_ARM` is a module-level env var read once at
function cold-start (`evaluate-attempt/index.ts`) — no per-request
override exists. Set as a live Production secret for the test window,
confirmed by owner before doing it:
```
supabase secrets set GRADING_ARM=a --project-ref pcntajvbdfqhbeewmdry
```
Confirmed live by inspecting the first call's `grading_result.raw_model_response.arm`
(`"a"`) before running the full batch. Unset immediately after the run:
```
supabase secrets unset GRADING_ARM --project-ref pcntajvbdfqhbeewmdry
```
confirmed absent via `supabase secrets list` afterward. Zero live student
traffic existed during the ~5-minute window this was set (app has no
launched users yet, per the O2-deploy-bug entry's verification).

**What ran:** 4 held-out items spanning the full available criterion-count
range (`APSTATS-SFRQ-009`: 2 criteria, `APSTATS-SFRQ-008`: 3,
`APSTATS-SFRQ-001`/`APSTATS-SFRQ-005`: 4), 2 responses each, 3 trials =
24 calls, arm=off (exemplar_mode; unrelated to `GRADING_ARM`).

**Result — contradicts the plan's pre-registered latency expectation:**

| criteria | n | mean latency | median | min | max |
|---|---|---|---|---|---|
| 2 | 6 | 30.8s | 31.7s | 19.6s | 44.6s |
| 3 | 6 | 29.9s | 31.3s | 15.5s | 42.8s |
| 4 | 12 | 22.0s | 23.7s | 5.8s | 34.0s |

Not flat, not ~4s on 4-criterion items — the opposite of the pre-registered
"~16s → ~4s" expectation. The fan-out **is** genuinely parallel (confirmed
in code: `Promise.all` over per-criterion calls, wall time taken as
`max(elapsedMs)` across them — not summed), so this isn't a serialization
bug; individual OpenAI call latency itself is high and highly variable
(5.8s–44.6s) at this sample size, and that variance dominates any
criterion-count signal. The n=6/6/12 split is too small to call the
2-vs-4-criterion direction (4-criterion items measuring faster than
2-criterion here) anything other than noise — the one non-noisy
conclusion is: **none of the three buckets are close to the ~4s target,
and most individual calls are slower than Arm B's typical single-call
latency** (~8–12s, per the same-session Run A/O2-smoke-test calls).

**Quality (the other half of the gate):** scored with the actual harness
(`main.ts --policy partial-v2`) against an 8-case gold subset — overall
accuracy 82.6%, selective accuracy 95%, exact-case accuracy 50% (4/8).
Not the 0/6 catastrophic failure the 2026-07-29 note recorded (different
item/response sample, not a like-for-like comparison — but nothing here
suggests a quality collapse this time). Full report: `report_runC.json`;
per-case: `results_runC.json`; variance: `raw_trial_variance_runC.json`;
gold subset: `gold_cases_runC.json`; raw capture: `raw_calls_runC.jsonl`
(24 records).

**Reading it together:** Arm A's core promise — faster grading via
parallel per-criterion calls — does not hold up empirically on the
production model. Quality wasn't clearly bad this round, but the latency
result alone is a real strike against shipping it as currently built; the
speed case would need to be remade with a much larger sample (n=6/bucket
is too small to rule out "still genuinely faster, just noisy here") before
it's worth revisiting.

**Real spend:** $0.2062 across 24 calls (`app.model_usage_ledger`, verified
by direct query on the 24 idempotency keys) — under the plan's $1–2
estimate.

## Cleanup (completed 2026-08-13, same session as the run)

Deleted, scoped strictly to the 8 `attempt_id`/`response_version_id` pairs
and their `grading_results` rows Run C created:
- `app.grading_results`: 0 remaining
- `app.response_versions`: 0 remaining
- `app.attempts`: 0 remaining

Verified via count query scoped to the 8 IDs — confirmed 0/0/0.

**Not cleaned up:** the pilot identity itself, same as after Run A — left
intact. `app.model_usage_ledger` rows for the 24 calls kept, same
precedent as Run A.

## Data kept (Run B/C)

Run B: nothing (no calls made). Run C: `raw_calls_runC.jsonl`,
`results_runC.json`, `raw_trial_variance_runC.json`, `report_runC.json`,
`gold_cases_runC.json`.
