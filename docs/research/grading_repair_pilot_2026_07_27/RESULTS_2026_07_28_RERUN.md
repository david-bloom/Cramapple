# Production Engine 1 Narrow Pilot — Re-run After the Transport and Grounding Fixes

**Date:** 2026-07-28
**Baseline:** the 2026-07-27 run of the identical 30 calls / 6 items / 5 quality tiers.
**Deployed:** `evaluate-attempt` v26 (`gpt-4.1-mini`, `math-verifier-ts-2026-07-28`).
**Verdict:** **FRQ grading works end-to-end for the first time.** Quality discrimination is
excellent. Latency is the remaining problem, and the pilot identified its cause.
**Cost:** $0.2503 across 30 calls ($0.00894/call).

---

## 1. Headline

| | 2026-07-17 | 2026-07-27 | **2026-07-28** |
|---|---:|---:|---:|
| FRQ gradings that completed | **0 of 5** | 30 of 30 | **28 of 28** |
| `graded` | 0 | 20 (67%) | **24 (86%)** |
| `uncertain` | 5 (100%) | 10 (33%) | **4 (14%)** |
| Wall p50 | — | 17.48 s | **12.17 s** |
| Wall p90 | — | 91.10 s | **20.29 s** |
| Cost / call | — | $0.00997 | $0.00894 |

Two of the 30 calls are excluded: one `403` (the entitlement regression, §5) and one Cloudflare
`520` on the transport edge. Both were retried; neither is a grading failure.

**p90 fell 91.1 s → 20.3 s — a 4.5x improvement in the tail** — and the uncertain rate more than
halved.

## 2. Quality discrimination is strong, and this is the best news in the run

The corpus has five deliberately-authored quality tiers per item (5 = model answer,
1 = near-empty). Scores across them:

| tier | points earned / available | |
|---|---:|---:|
| 5 (best) | 18/21 | **85.7%** |
| 4 | 11/29 | 37.9% |
| 3 | 4/30 | 13.3% |
| 2 | 1/30 | 3.3% |
| 1 (worst) | 0/30 | **0.0%** |

**Perfectly monotonic, with no tier inversion and clean separation at both ends.** The grader is
not merely producing output — it is ranking answer quality correctly. This is the strongest
evidence to date that Engine 1's judgement is sound on real Production content.

## 3. Latency — the cause is architectural, and Phase C already named it

Latency splits cleanly by criterion count, because **Production issues ONE model call that
grades every criterion of an item in a single structured output**:

| criteria per item | n | mean | p50 | max |
|---|---:|---:|---:|---:|
| 1 (AP Statistics) | 14 | **4.46 s** | 4.38 s | 7.10 s |
| 4 (AP Biology) | 14 | **16.13 s** | 16.20 s | 21.69 s |

Fit: **latency ≈ 0.58 s + 3.89 s × n_criteria.**

That is the **Arm B signature**. Phase C measured Arm B at ≈0.61 s + 0.64 s × n_criteria and
**closed it as a latency dead end**, recommending Arm A — parallel per-criterion calls, which
were **flat in criterion count** at ~1.9 s p50 (`ARM_B_ROOT_CAUSE_ANALYSIS.md`).

**Production is running the architecture Phase C rejected.** The per-criterion coefficient is
6x worse here than in Phase C, which is a different model on a different transport, but the
*shape* is identical and it is the shape that matters: every criterion added to a rubric costs
another ~3.9 s. A 4-criterion Biology FRQ takes 16 s; an 8-criterion one would take ~31 s.

**This is the single highest-value latency fix available, it is already designed, and it was
already validated at n=100.** Converting Production to Arm A should collapse 4-criterion items
from ~16 s toward the cost of their slowest single criterion.

## 4. Integrity issues — down sharply, and one confirmed reporting bug

3 of 70 graded criteria (**4.3%**) triggered an integrity issue, against the **2.66%** the β2
corpus predicted for the fixed evidence matcher. At n=70 those are not distinguishable, and both
are far below the 10.19% the old exact-substring rule produced on the same corpus. The
grounding fix behaves in Production as measured offline.

**Confirmed in Production — the misleading `uncertainty_reason` I flagged before deploying:**

```
APBIO-FRQ-L-021 tier=2 -> status=uncertain
  uncertainty_reason: "Grading output failed 0 integrity check(s)."
  actual cause: one criterion returned unable_to_determine
```

`sanitizeModelResult` sets `uncertain` when `issues.length > 0` **OR** any criterion is
`unable_to_determine`, but always words the reason as an integrity-check failure. When the cause
is abstention, it reports **"failed 0 integrity check(s)"** — literally false, and it would send
anyone debugging this in the wrong direction. Not fixed in this run; it is a message bug, not a
scoring bug. **Recommend fixing before the reason string is ever shown to a tutor.**

## 5. A regression this run caused, and its remediation

The first call returned **`403 entitlement_required`**. Cause: the deploy shipped repo HEAD,
which contains an entitlement gate calling `authorize_grading_access` — an RPC defined in
migration `20260720122542_free_score_check_growth_funnel.sql` that is **not applied to
Production** (verified). The deployed function therefore rejected every non-admin caller.

- **Impact: none.** Production has 0 real students, 0 attempts, 0 responses. Live ~25 minutes.
- **Remediation:** the check is now behind `GRADING_ENTITLEMENTS_ENABLED`, defaulting to
  **off**, which reproduces v23's behaviour exactly (v23 had no gate). Not a silent bypass —
  it is skipped only when explicitly disabled.
- **Root cause:** deploying repo HEAD without diffing it against the deployed version. The
  `math-verifier` blast radius was checked; the function as a whole was not.
- **Owner decision outstanding:** whether to apply the growth-funnel migration. It changes
  monetization behaviour (free users get one initial grade plus one repair), so it is a product
  call. Apply it and flip the flag in the same change — code and schema must ship together.

## 6. What this run did NOT answer

**The partial-credit question is unresolved.** All 6 pilot items use **single-point criteria
only** (0 multi-point criteria appeared in 70 results), so `earned_points_mismatch` never fired.
The concern stands unmeasured: 598 of 2,472 Production criteria (24%) are worth more than 1
point, and the current code converts any `earned` criterion whose award ≠ `points_possible` into
`unable_to_determine` with **0 points**, making partial credit impossible.

Settling it needs a pilot corpus that includes multi-point criteria. The existing corpus cannot.

Also unmeasured here: 4 of the 5 feedback-quality dimensions, and any comparison against gold
labels — the tier ordering is evidence of discrimination, not of per-criterion correctness.

## 7. Recommendations

1. **Convert Production to Arm A (parallel per-criterion).** Already designed, already validated
   at n=100, and it is the only fix that addresses the 3.89 s/criterion scaling. Biggest single
   speed win available.
2. **Fix the "failed 0 integrity check(s)" message** — separate abstention from integrity failure
   in `sanitizeModelResult`.
3. **Decide the entitlement migration**, and ship it with the flag flip.
4. **Re-run this pilot with multi-point criteria** to settle partial credit.
5. **Diff deployed vs HEAD before every deploy.** This run's regression is entirely attributable
   to skipping that step.
