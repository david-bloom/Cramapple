# β3 — Second-Generation Boundary Contracts: Inconclusive, and Why

**Date:** 2026-07-28
**Goal:** apply the β2 learnings (negative-side pass on over-corrected criteria, balanced
first-generation contracts, compound-criterion language, charitable notation) and re-measure
accuracy and speed.
**Verdict:** **NO demonstrated accuracy gain, and slightly slower.** +0.8 pp on fresh answers,
McNemar **p = 0.69**. The run was **underpowered by construction** and cannot settle the
question either way.
**Cost:** $1.1763 (1,104 calls). Cumulative Phase C spend: **$5.28**

---

## 1. Headline — the honest cell

| | fresh_pre (contracts today) | fresh_post (β3 v2) |
|---|---:|---:|
| Agreement | 95.2% (257/270) | **96.0%** (262/273) |
| Over-credit | 12 (4.4%) | 9 (3.3%) |
| Under-credit | 1 (0.4%) | 2 (0.7%) |
| p50 / p90 latency | 1,852 / 3,787 ms | 1,950 / 4,034 ms |

**Paired McNEMAR: 4 fixed, 2 broken, p = 0.69. Not significant.**

## 2. Why this could not have worked — the design flaw is mine

| | β1 | **β3** |
|---|---:|---:|
| Baseline accuracy | 81.5% | **95.2%** |
| Errors available to fix | 46 / 249 | **13 / 269** |
| Headroom | 18.5 pp | **4.8 pp** |
| Discordant pairs | 20 | **6** |
| Result | +6.5 pp, p = 0.0004 | +0.8 pp, p = 0.69 |

All statistical power in a paired test lives in the **discordant pairs**. With 6 of them, even a
perfect 6–0 split only reaches p = 0.031; the observed 4–2 cannot reach significance **at any
effect size**. The experiment was incapable of producing a clear answer before it ran.

The cause is the fresh corpus. I asked for "strong / mixed / near-boundary" answers, which
produced a corpus the current contracts already grade at 95.2%. β1's fresh answers were
generated to mirror the *specific mechanisms* of observed errors and so landed at 81.5%,
leaving real room to measure. **A held-out set must be hard enough to expose the failure being
fixed.** Mine was not, and I should have checked the baseline error count before spending.

## 3. The same-corpus cell shows textbook overfitting — do not read it as success

| | same_pre (v1 contracts) | same_post (β3 v2) |
|---|---:|---:|
| Agreement | 95.7% (485/507) | **99.0%** (506/511) |
| Over-credit | 14 | **2** |
| Under-credit | 8 | 3 |

99.0% looks excellent and means almost nothing. These contracts were authored **from these exact
errors**, so scoring them well is memorisation. The gap is the tell:

- same corpus (derivation set): **+3.3 pp**
- fresh answers: **+0.8 pp, n.s.**

β1 showed the same asymmetry (+17.3 pp derivation vs +6.5 pp fresh) but its fresh number was
real. Here the fresh number is indistinguishable from noise, so the only defensible statement is
that β3 demonstrably fits its own training errors and has **not** been shown to generalise.

## 4. The negative-side hypothesis: not supported, not refuted

My β2 diagnosis was that β1 over-corrected by enumerating `accepted_variants` without matching
`insufficient_near_misses`, so β3 did a negative-side pass on the 12 already-revised criteria.

| pass type | n | net labels moved |
|---|---:|---:|
| `negative_side` | 34 | **−1** (0 fixed, 1 broken) |
| `first_generation` | 37 | **+2** (2 fixed, 0 broken) |

**These are movements of one and two labels. Neither supports a conclusion**, and I will not
build a narrative on them. What can be said: the negative-side pass produced **no** reduction in
over-credit on fresh answers (4 → 4) despite adding a mean of 9 near-misses per criterion. That
is weak evidence against "more negative boundary text fixes an over-permissive contract", and it
is worth testing properly rather than assuming.

## 5. Speed — slightly worse, as expected

| | fresh_pre | fresh_post |
|---|---:|---:|
| Prompt size | 7,162 chars | 8,281 chars (**+15.6%**) |
| p50 | 1,852 ms | 1,950 ms (+5.3%) |
| p90 | 3,787 ms | 4,034 ms (**+6.5%**) |

Boundary authoring is an accuracy lever and a **speed cost**. β1 measured the same direction
(+30% p90). Contracts now average 8.3 KB of prompt per criterion and keep growing.

**Rubric work will not make grading faster.** The available speed win is the production
architecture: Production issues one call per item for all criteria (≈0.58 s + 3.89 s ×
n_criteria), which Phase C closed as Arm B. Converting to Arm A — parallel per-criterion, flat
in criterion count — is worth roughly **16 s → 4 s** on a 4-criterion Biology FRQ. That is two
orders of magnitude more speed than any prompt-length tuning.

## 6. What to do next

1. **Rebuild the held-out corpus around observed failure mechanisms**, and **check the baseline
   error count before spending**. Target ≥15% baseline error, i.e. ≥40 errors per ~270 labels.
   Without that, no boundary experiment can resolve anything.
2. **Test negative-side vs first-generation authoring properly**, on a corpus with real headroom.
   The n=34/37 split here is a hypothesis, not a result.
3. **Stop adding boundary text to criteria that already have contracts** until (1) and (2) say it
   helps. Contract length is now a measurable latency cost with no measured accuracy return.
4. **Do the Arm A conversion** for speed. It is designed, validated at n=100, and independent of
   all rubric work.
5. Keep the β3 contracts **unshipped** pending a powered test. They are not known to be worse —
   the same-corpus cell is at least consistent with them being better — but "not known to be
   worse" is not a deployment criterion.

## 7. Honest summary

The owner asked for *more accurate and faster*. This run delivered **neither**, and the accuracy
question remains open rather than answered negatively. The most valuable output is the
methodological constraint: **a boundary experiment is only as good as the difficulty of its
held-out set**, and β3's was too easy to measure anything. That is a cheap lesson at $1.18, but
it was avoidable — a five-second check of the baseline error count would have caught it before
the run.
