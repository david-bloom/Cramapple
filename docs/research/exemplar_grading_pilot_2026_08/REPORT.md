# Exemplar-grading pilot — AP Statistics — Results (2026-08-10)

## tl;dr

Injecting a verified gold-set answer as a few-shot exemplar (`exemplar_mode:
"with_exemplar"`) showed a **small positive accuracy shift over the current
production prompt** (`exemplar_mode: "off"`), but the paired-bootstrap 95%
confidence interval's lower bound sits exactly at zero — it does not cleanly
exclude zero. Per this pilot's pre-registered decision gate, that is
**inconclusive, leaning positive** — not a clean "proceed," and not a "stop."
Cost and latency both increased modestly with the exemplar, as expected from
a longer prompt.

## Corpus and confound disclosure

Held-out item pool, as split in Phase 0/2 (`item_pool_split.json`), **with
one correction discovered during this run**: `APSTATS-SFRQ-003` and its
exemplar-source topic-mate `APSTATS-SFRQ-004` turned out to be
`content_item_versions.status = 'retired'` — a version-level status distinct
from the item-level `content_items.status` that Phase 0's audit checked (all
10 items say `'published'` at that level; production's actual
`evaluate-attempt` gate checks the version-level field and returned `409
content_not_published`). That topic pair is excluded from this pilot
entirely, not substituted — see `held_out_items.json`'s `excluded` entry and
`item_pool_split.json`'s corrected `known_limitations`.

| Held-out item | Topic (proxy) | Exemplar source | Responses graded |
|---|---|---|---|
| APSTATS-SFRQ-001 | descriptive stats / outliers, standardized scores (Unit 1) | APSTATS-SFRQ-002 | 8 |
| APSTATS-SFRQ-005 | sampling bias / experimental design (Unit 3) | APSTATS-SFRQ-006 | 6 |
| APSTATS-SFRQ-008 | probability / random variables (Unit 4) | APSTATS-SFRQ-007 | 8 |
| APSTATS-SFRQ-009 | sampling distributions (Unit 5) | APSTATS-SFRQ-010 | 8 |
| ~~APSTATS-SFRQ-003~~ | ~~bivariate data / regression (Unit 2)~~ | ~~APSTATS-SFRQ-004~~ | excluded (retired) |

**Actual pilot size: 4 held-out items, 30 responses, 84 gradable criteria per
arm.** (Not the originally-scoped 5 items / 37 responses.) 5 trials per
`(response, arm)`, sized from a 20-repeat check on one response that showed
100% trial-to-trial agreement on all 4 criteria (`analyze_size_run.mjs`
output, preserved in this session's history) — the noise this pilot's design
exists to average over turned out to be small for the item checked, though
the full run's own variance diagnostic below shows it isn't zero everywhere.

An exemplar item's own retired/published status does not affect grading —
`evaluate-attempt` only enforces `published` on the item **being graded**;
the exemplar's answer text is passed inline in the request body, never
re-fetched from the DB (confirmed by reading `index.ts:844-850`).

## Side-by-side results

| Metric | `with_exemplar` | `off` (baseline) | Δ |
|---|---|---|---|
| Overall accuracy | 0.583 | 0.524 | **+0.059** |
| Selective accuracy (non-abstained only) | 0.961 | 0.936 | +0.025 |
| Coverage (1 − abstention rate) | 0.607 | 0.560 | +0.048 |
| Exact-case accuracy (all criteria right) | 0.433 | 0.400 | +0.033 |
| False positive rate | 0.074 | 0.111 | −0.037 (better) |
| False negative rate | 0.298 | 0.368 | −0.070 (better) |
| Abstentions (of 84 criteria) | 33 | 37 | −4 |
| Latency p50 / p95 (ms) | 6,882 / 14,072 | 6,891 / 12,495 | ~flat p50, +1,577ms p95 |
| Total cost (84 gradable criteria's calls) | $0.119 | $0.107 | +$0.012 (+11%) |

Every point-estimate metric moved in the exemplar's favor in this run.
Latency's p50 is essentially unchanged; p95 is higher with the exemplar, as
expected from a longer prompt (this repo's convention is to treat this as
exploratory, not launch-gating — see the plan's Phase 3 note on prompt
caching). Cost rose ~11%, consistent with the added exemplar text.

## Bootstrap accuracy difference (the load-bearing number)

```json
{
  "estimate": 0.0472,
  "ci95_low": 0,
  "ci95_high": 0.1222,
  "clusters": 30,
  "iterations": 2000
}
```

**`clusters: 30`** matches the 30 gradable held-out responses exactly —
confirms the pseudoreplication fix worked: the bootstrap is resampling over
independent held-out responses, not inflated by the 5 trials each response
was graded on (each response's 5 trials were aggregated to one majority-vote
result **before** this step; see `to_result_cases.mjs`).

The 95% CI is `[0, 0.122]`. Its lower bound lands exactly on zero rather than
above it — a small amount of additional noise (a slightly less lucky trial
run, or one more disagreeing item) could easily have pushed it either side
of that line. Per this pilot's own pre-registered decision gate, a CI that
touches zero rather than excluding it is **not** the "consistently positive"
result required for an unambiguous proceed signal, but it is well short of
the "straddles or centers near zero" stop signal either — this is the middle,
inconclusive case the plan anticipated as plausible at this sample size.

## Raw per-trial variance diagnostic

Across all 188 `(case, arm, criterion)` combinations with recorded trials,
mean modal-status agreement was **97.8%** for `off` and **96.7%** for
`with_exemplar`, both consistent with the 100% agreement seen in the
pre-run sizing check. 8 combinations (4.3%) fell below the 75% agreement
threshold flagged by `to_result_cases.mjs` (full detail in
`raw_trial_variance.json`):

| Case | Arm | Criterion | Agreement | Distribution |
|---|---|---|---|---|
| APSTATS-SFRQ-001#0 | with_exemplar | b1 | 60% | earned=2, unable_to_determine=3 |
| APSTATS-SFRQ-005#1 | off | b1 | 40% | earned=2, not_yet_earned=2, unable_to_determine=1 |
| APSTATS-SFRQ-005#2 | off | b1 | 60% | earned=2, unable_to_determine=3 |
| APSTATS-SFRQ-005#2 | with_exemplar | a1 | 40% | earned=2, not_yet_earned=2, unable_to_determine=1 |
| APSTATS-SFRQ-005#2 | with_exemplar | d1 | 60% | earned=2, not_yet_earned=3 |
| APSTATS-SFRQ-009#6 | with_exemplar | b | 60% | not_yet_earned=3, unable_to_determine=1, not_applicable=1 |
| APSTATS-SFRQ-009#7 | with_exemplar | a | 60% | earned=3, unable_to_determine=2 |
| APSTATS-SFRQ-009#7 | with_exemplar | b | 60% | earned=3, unable_to_determine=2 |

All 8 noisy combinations are concentrated in just 3 responses
(`SFRQ-001#0`, `SFRQ-005#2`, and `SFRQ-009#6`/`#7`) — the grader is
genuinely unstable on specific ambiguous responses, not uniformly noisy
across the corpus. `SFRQ-005#2` and `SFRQ-009#7` are each noisy in **both**
arms, meaning the instability is a property of that response, not something
the exemplar caused or fixed. N=5 was adequate to reach a stable majority
vote everywhere (no criterion ended in an unresolvable tie by count, though
`to_result_cases.mjs` logs 2 near-ties resolved by first-seen order — see its
warnings in the run transcript), but a response this genuinely ambiguous
would benefit from more trials in any follow-up pilot.

## Limitations

- **n=4 held-out items / 30 responses**, smaller than this pilot's original
  5-item/37-response scope due to the mid-run retired-item discovery. The CI
  above already reflects this smaller n — a wider CI than a 37-response run
  would have produced is an expected consequence, not a separate caveat.
- **Single exemplar per held-out item for the whole pilot** (Phase 2's
  policy): this tests whether *these specific 4 exemplars* help, not
  whether exemplars help in general. A different exemplar choice per item
  could move the result either direction.
- **No placebo arm**: a longer prompt could plausibly change grading
  behavior by being longer/different, independent of the exemplar's content
  being informative. This pilot cannot separate "the exemplar's content
  helped" from "a longer/different prompt changed behavior" — flagged in
  the original plan as the first addition for a second, more rigorous pass.
- **Confound**: the excluded topic pair (bivariate data/regression, Unit 2)
  is untested by this pilot in either direction — the result above says
  nothing about that topic.
- **Small-sample convention**: matching this repo's existing convention
  (`CONTENT_AUTHORING_AND_QA_PROTOCOL.md` §9.3/§10), this is a directional
  pilot signal, not a powered study or a publishable effect size.

## Decision gate

Per the plan's pre-registered criteria:

- **Proceed** requires a CI that is "consistently positive and excludes
  zero." This run's CI is `[0, 0.122]` — it does not exclude zero.
- **Stop, don't scale** requires the CI to "straddle or center near zero."
  This run's point estimate (+0.047) and every individual metric moved in
  the exemplar's favor, which is not "near zero" in direction, even though
  the CI's lower edge touches it.
- **Recommendation: inconclusive, lean toward a second, larger/de-confounded
  pilot before a production decision** — specifically: (a) restore
  `APSTATS-SFRQ-003`/`004`'s topic pair once un-retired (or substitute
  another Unit-2 item) to get back to the original 5-item scope, (b) add the
  placebo arm the plan flagged as deferred, and (c) consider a second
  exemplar per item to check the single-exemplar-per-item limitation doesn't
  flip the direction. None of this requires new tooling — Phases 1, 3, 4,
  and 5 here are already reusable as-is; only Phase 0's item selection and
  Phase 2's exemplar vetting would need to be redone for a widened corpus.
- This result is **not** a basis for mass gold-set authoring on its own —
  the directional signal is positive enough to justify a second, cheap pilot
  before that decision, not to greenlight it outright.
