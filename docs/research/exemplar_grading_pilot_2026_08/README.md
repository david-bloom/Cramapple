# Exemplar-grading pilot — AP Statistics — 2026-08

**Status (2026-08-10): COMPLETE — result INCONCLUSIVE, do not ship.** See
`REPORT.md` for the full writeup. Headline: the bootstrap CI in
`report.json` is computed over 30 response-level clusters, not the 4
held-out-item clusters this design requires — `harness.ts`'s
`clusterBootstrapDifference` has no item-level grouping, so no accuracy
claim can be made from this run regardless of the (marginal, CI-straddling-
zero) point estimate. **Production cleanup (§5 below) has not been
performed yet** — do that before considering this pilot closed.

## Purpose

Tests whether injecting a verified gold-set answer into the grading prompt as
a few-shot exemplar (`exemplar_mode: "with_exemplar"`) improves grading
accuracy over the current prompt (`exemplar_mode: "off"`, byte-for-byte
today's production behavior). See the approved plan for full context and
non-goals; this file only covers execution of Phases 4–5.

This is a **pilot**: 5 held-out items (37 total gold-set responses) × 2 arms
× N trials. Not a statistically powered study — treat results as directional
signal, matching this repo's small-sample-caveat convention.

## Files

- `held_out_items.json` — Phase 0 output: the 5 held-out item versions' DB
  ids, from a read-only Production audit (2026-08-10).
- `gold_cases.json` / `gold_cases_internal.json` — Phase 1 output: the 37
  held-out responses with human-verified per-criterion ground truth.
- `exemplars.json` — Phase 2 output: one independently re-vetted, clean
  exemplar answer per held-out item.
- `create_pilot_session.mjs` — creates the isolated synthetic pilot student.
  **The owner runs this, not the assistant** (it handles a password).
- `run_pilot.mjs` — the capture script (Phase 4). Two modes:
  - `PILOT_MODE=size`: N repeats on one case/arm, to size the trial count.
  - `PILOT_MODE=full` (default): the full case × arm × trial matrix.
- `analyze_size_run.mjs` — reads a size run's output and recommends a trial
  count N based on how often trials agreed with each other.
- `to_result_cases.mjs` — aggregates `raw_calls.jsonl`'s trials into one
  `ResultCase` per `(content_key, response_index)` per arm — this is the
  pseudoreplication fix; see the script's header comment for why aggregating
  before scoring, not after, is required for `clusterBootstrapDifference`'s
  cluster count to stay correct.

## Execution plan

### 1. Create the isolated pilot identity (owner-run)

```
node docs/research/exemplar_grading_pilot_2026_08/create_pilot_session.mjs
```

Tell the assistant once this is done — it will confirm the address, then
(after Production's email-confirmation step) re-run with `--signin` to
capture the session to `/tmp/cramapple_exemplar_pilot_session.json`.

### 2. Size the trial count

```
SUPABASE_PUBLISHABLE_KEY=... PILOT_MODE=size \
  node docs/research/exemplar_grading_pilot_2026_08/run_pilot.mjs
node docs/research/exemplar_grading_pilot_2026_08/analyze_size_run.mjs
```

Read the recommendation. Set `PILOT_TRIALS` for step 3 accordingly (the
script defaults to 5, matching the plan's expectation that a near-unanimous
grader needs only 3–5 repeats).

### 3. Run the full matrix

```
SUPABASE_PUBLISHABLE_KEY=... PILOT_MODE=full PILOT_TRIALS=<N> \
  node docs/research/exemplar_grading_pilot_2026_08/run_pilot.mjs
```

Writes `raw_calls.jsonl` in this directory. Interruptible and resumable —
re-running with the same `PILOT_RUN_LABEL` (default `20260810`) skips
already-completed `(case, arm, trial)` calls.

Before trusting the results, spot-check that the two arms' prompts differ
only in the exemplar section (dry-run verification step 3(b) in the plan) —
e.g. grep a couple of `raw_calls.jsonl` records' `api_response` for the
`"Worked exemplars"` marker text and diff against a same-case `arm=off` call.

### 4. Map to `ResultCase[]` and score

```
node docs/research/exemplar_grading_pilot_2026_08/to_result_cases.mjs
deno run --allow-read --allow-write scripts/grading-model-assessment/main.ts \
  --gold docs/research/exemplar_grading_pilot_2026_08/gold_cases.json \
  --candidate docs/research/exemplar_grading_pilot_2026_08/results_with_exemplar.json \
  --baseline docs/research/exemplar_grading_pilot_2026_08/results_without_exemplar.json \
  --out docs/research/exemplar_grading_pilot_2026_08/report.json
```

Confirm `report.json`'s bootstrap `clusters` count is 5 (one per held-out
item), not 37 or higher — if it's inflated, the aggregation step didn't
collapse trials correctly (see Phase 5 sanity check in the plan).

Then write `REPORT.md` per the plan's Phase 5 spec: side-by-side `scoreRun`
output, the bootstrap accuracy difference + CI, the raw per-trial variance
diagnostic from `raw_trial_variance.json`, and the small-sample limitation
paragraph.

### 5. Cleanup (required — do not skip)

Same as the 2026-07-27 grading-repair pilot's cleanup step: delete all
`grading_results` rows, `response_versions`, and `attempts` rows tied to the
synthetic pilot student, any `student_memory` rows it wrote, its
`app.profiles` row, and the Supabase Auth user itself. Record what was
deleted here or in a new `EXECUTION_LOG.md`, and confirm via a final query
that no rows referencing the pilot's user id remain in `app.*`.

## Guardrails

- This touches Production. The only identity used must be the isolated pilot
  student created in step 1 — never a real student, tutor, or admin identity.
- `exemplar_mode` defaults to `"off"` and is not read by any caller besides
  this pilot's own capture script — existing production traffic is
  unaffected regardless of what this pilot does.
- Real OpenAI API cost is incurred per call (both arms, every trial) — get
  explicit go-ahead on the trial count before running the full matrix; a
  larger N found necessary in step 2 multiplies cost across all 5 items × 2
  arms.
