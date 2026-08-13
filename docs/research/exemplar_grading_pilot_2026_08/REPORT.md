# Exemplar-grading pilot — AP Statistics — Report

**Date:** 2026-08-10
**Status:** COMPLETE — result is **INCONCLUSIVE**, not a negative or positive
finding. Do not ship `exemplar_mode: "with_exemplar"` on this evidence.
Do not treat this as a replication of the Biology reference-layer null
results (`grading_cross_subject_takeaways.md` Lesson 2) — this pilot's
verdict is "the design cannot answer the question," not "exemplars don't
help."

## Headline

| | `off` (baseline) | `with_exemplar` (candidate) |
| --- | --- | --- |
| Overall accuracy | 52.4% | 58.3% |
| Selective accuracy | 93.6% | 96.1% |
| Coverage (non-abstention) | 56.0% | 60.7% |
| Exact-case accuracy | 40.0% | 43.3% |
| False negative rate | 36.8% | 29.8% |
| False positive rate | 11.1% | 7.4% |
| p50 / p95 latency | 6,891 / 12,495 ms | 6,882 / 14,072 ms |
| Cost (30 cases) | $0.1074 | $0.1195 |

Point estimate: **candidate − baseline = +4.7 pp** overall accuracy.
Bootstrap 95% CI: **[0.0 pp, 12.2 pp]** (`report.json`,
`candidate_minus_baseline.overall_accuracy`).

Every metric moves in the candidate's favor. Taken at face value this reads
as a mild, borderline-significant win. It is not trustworthy — see below.

## Why the result is not trustworthy: the bootstrap CI is computed over the
wrong cluster unit

`report.json` reports `"clusters": 30`. The pilot's own execution plan
(this directory's README, and the header comment in `to_result_cases.mjs`)
pre-registered that a valid run must show **cluster count = number of
held-out items (4, after the SFRQ-003 exclusion below), not the number of
responses (30) and not the number of trials (150)**. The reasoning:
responses to the same held-out item share the same rubric, the same
(candidate-arm) exemplar, and the same prompt scaffolding, so they are not
independent draws — treating them as independent (pseudoreplication) makes
the reported confidence interval artificially narrow.

`to_result_cases.mjs` correctly fixes the *trial*-level pseudoreplication
(aggregating each case×arm's 5 trials into one `ResultCase` before scoring).
It does not fix the *response*-level pseudoreplication the plan also called
out, because nothing does: `clusterBootstrapDifference` in `harness.ts`
clusters on whatever granularity `item_correctness`'s keys happen to be
(`content_key#response_index`, i.e. per response), with no held-out-item
grouping layer above that. This is a gap in the harness, not a mistake in
how this pilot invoked it — the harness has never been used for a design
where cluster ≠ scored-case before.

Consequence: the `[0, 12.2]` pp interval above is anti-conservative. The
true sampling unit count for this design is 4 (one per held-out item), and
a bootstrap over n=4 clusters would report substantially wider, likely
uninformative, uncertainty — not enough to distinguish a 4.7pp difference
from noise. **No accuracy claim, positive or negative, can be made from this
run's numbers without a harness change to support item-level clustering.**

## Supporting context (not independently disqualifying)

- **Held-out pool corrected mid-run, 5/37 → 4/30.** Phase 0's item-pool
  audit checked `content_items.status` (item-level) but not
  `content_item_versions.status` (version-level, what `evaluate-attempt`
  actually enforces). `APSTATS-SFRQ-003` — and its exemplar-source
  topic-mate `APSTATS-SFRQ-004` — turned out `retired` at the version level,
  discovered when the first live full-matrix call 409'd
  (`content_not_published`). Fixed in `held_out_items.json` and
  `item_pool_split.json` (commit `cf88a0e`); this report additionally
  regenerates `gold_cases.json`/`gold_cases_internal.json` to drop
  SFRQ-003's 7 responses, which had not been done and blocked `main.ts`
  (`missing result case` errors) until this scoring pass.
- **Data collection itself was reliable after resume.** 29 of 330 raw calls
  (8.8%) hit `401` (mid-run session expiry) and 1 hit `409` (the retired
  item above); `run_pilot.mjs`'s resumability (added in `cf88a0e`) recovered
  all of them on subsequent runs. `raw_trial_variance.json` confirms every
  one of the 188 (case × arm × criterion) cells has the full pre-registered
  `trial_count: 5` — no cell is running on a partial trial count. Mean modal
  agreement across trials is 97.2%; only 8/188 cells (4.3%) fall below the
  75% agreement flag, all pre-existing rubric-boundary ambiguity
  (`APSTATS-SFRQ-005`/`009`), not an exemplar-arm-specific pattern.

## Small-sample caveat

This was always a pilot, not a powered study: 4 held-out items, 30 total
graded responses, 5 trials/cell. Per this repo's small-sample-caveat
convention, even a methodologically sound run at this size would only
produce directional signal. Combined with the invalid clustering above, no
signal survives — directional or otherwise.

## Verdict

**Do not ship `exemplar_mode: "with_exemplar"`.** Not because exemplars
were shown to hurt or fail to help — no valid comparison was completed —
but because this pilot cannot be read as evidence either way, and the
marginal, CI-straddles-zero point estimate does not clear the bar to justify
rebuilding the harness and re-running to get a valid answer, absent a new
reason to believe exemplar injection matters more than the other
open grading-program work (`GRADING_PROGRAM_LEDGER_2026_07_27.md`).

If this question becomes worth re-asking: fix `clusterBootstrapDifference`
(or a caller-side grouping step) to resample whole held-out items rather
than individual response keys, and re-register a trial/item count sized to
produce a usable CI at n=4 (or grow the held-out pool — the 10-item
`item_pool_split.json` audit inventory suggests room, if the version-status
check is applied to every candidate this time).

## Cleanup status

Not yet performed — see README.md §5. Required before this pilot is fully
closed: delete `grading_results`, `response_versions`, `attempts`, and
`student_memory` rows tied to the synthetic pilot student, its
`app.profiles` row, and its Supabase Auth user; confirm via a final query
that no `app.*` rows reference the pilot's user id.

## Correction — 2026-08-11

The headline numbers above are additionally corrupted by a **replay-parsing
defect** found in the 2026-08-10 second-opinion review (see
`prompts/FABLE_EXEMPLAR_PILOT_AND_GOLD_SET_SECOND_OPINION_2026_08_10.md` and
`../GRADING_ENGINE_REPLAN_EXECUTION_PLAN_2026_08_10.md`). The prior text of
this report is retained unchanged above; this section supersedes its
numbers.

**The defect.** 5 of the 300 successful calls in `raw_calls.jsonl`
(`APSTATS-SFRQ-001#0`, arm=off, all 5 trials) are idempotency replays: the
`(case, arm, trial)` idempotency key already had a completed
`grading_results` row, so `evaluate-attempt` returned that row as `result`
— whose column is `criterion_results`, not `criteria`. All five carry
`status: "graded"` with **all four criteria `earned` 4/4**.
`to_result_cases.mjs` read only `result.criteria`, so this fully-correct
baseline case was silently scored as *empty* criteria — zeroing it in the
`off` arm only, which inflated the candidate-minus-baseline difference.

**Corrected numbers** (repaired `to_result_cases.mjs` — now reads
`criterion_results` as the replay fallback and fails loudly on any record
with neither shape — re-run 2026-08-11 into a scratch directory; committed
`results_*.json`/`report.json` left as-is as the historical record):

| | `off` (baseline) | `with_exemplar` (candidate) |
| --- | --- | --- |
| Overall accuracy | **57.1%** (was 52.4%) | 58.3% (unchanged) |
| Selective accuracy | 94.1% | 96.1% |
| Coverage | **60.7%** (now equal) | 60.7% |
| Abstentions | 33 (now equal) | 33 |
| Exact-case accuracy | **43.3%** (now equal) | 43.3% |
| False negative rate | **29.8%** (now equal) | 29.8% |
| False positive rate | 11.1% | 7.4% |

- Point estimate: **+1.39pp** (was +4.7pp). Response-level bootstrap 95% CI
  **[−2.5, +6.7]pp** (was [0.0, +12.2]).
- With the new item-level cluster bootstrap (`harness.ts`
  `collapseToItemClusters`, the fix this report's original verdict asked
  for): estimate +2.0pp, 95% CI **[−2.3, +8.3]pp** over the correct 4
  clusters.
- Per-item differences: SFRQ-001 −0.031, SFRQ-005 +0.111, SFRQ-008 0,
  SFRQ-009 0. The entire remaining point estimate is one item.

**Additional confound found in the same review:** 130 of the 300 calls
(13 of 30 cases, both arms) never reached the model at all — the
deterministic Statistics gate short-circuited them, arm-invariantly, and
for SFRQ-008 (8 of those 13 cases) the gate itself was firing on a
**defective key** ([1.8, 4.9] vs the item's true −1.40/≈4.48 — see
`../DETERMINISTIC_KEY_AUDIT_2026_08_11.md`). The pilot therefore compared
the arms on a corpus where 43% of cases were decided identically by a
non-model code path, further shrinking any measurable exemplar effect.

**Verdict unchanged, grounds strengthened:** do not ship
`exemplar_mode: "with_exemplar"`. The corrected point estimate is +1.4pp
with both CIs straddling zero, secondary metrics equalize, and the original
clustering objection stands. The prompt-content experiment direction is
closed per the replan (1.5).
