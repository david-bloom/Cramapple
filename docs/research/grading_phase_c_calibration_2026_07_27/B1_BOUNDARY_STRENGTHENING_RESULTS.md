# β1 — Boundary Strengthening from Grading Actions: Mechanism Test Results

**Date:** 2026-07-28
**Question:** Does promoting a body of *grading actions* offline into rubric
boundary contracts make the grader measurably more correct on **fresh, unseen
answers** — without overfitting to the answers the revisions were derived from?
**Verdict:** **GATE PASS, decisively.** +6.5 pp on fresh held-out answers,
paired McNemar **p = 0.0004**, with **no collateral damage** to untouched criteria.
**Cost:** $0.5965. Cumulative Phase C spend: **$1.4804**

---

## 1. Design

| | |
|---|---|
| Target | The 21 error-carrying items from Stage 6, excluding the 5 `HDG-2026-GRAPH` items (Engine 4 content mis-scored as text) — **31 real criterion errors** |
| Treatment | 30 of 31 criteria received a revised boundary contract authored **offline** from the existing grading actions (grader verdict + stated reason + independent adjudication). One criterion (`apphy2-frq-019/a-cycle`) was not authored and kept its original boundary — a conservative bias against the treatment. |
| Fresh corpus | **42 new answers** (2 per item), generated blind to the rubric, same archetype/mechanism as the originals, genuinely distinct from each other and from the originals |
| Fresh gold | **252 criterion labels**, adjudicated independently against the **ORIGINAL** rubric and **blind to the revisions** — so the measurement asks "is the grader more *correct*", not "does the grader obey the revision" |
| Cells | `fresh_pre` (original contracts × fresh answers), `fresh_post` (revised × fresh), `original_post` (revised × original answers, regression check) |
| Held constant | Model (`gemini-2.5-flash`), temperature 0, thinking disabled, token cap, output schema, concurrency. **Boundary text is the only variable.** Arm A only (Arm B closed). |
| Calls | 630 |

## 2. Headline result

| Cell | Agreement | Over-credit | Under-credit |
|---|---:|---:|---:|
| `fresh_pre` — original contracts, fresh answers | 203/249 = **81.5%** | 7 | **39** |
| `fresh_post` — revised contracts, fresh answers | 220/250 = **88.0%** | 7 | **23** |
| `original_post` — revised contracts, original answers | 115/124 = **92.7%** | 4 | 5 |

**Paired McNemar on the fresh answers** (identical answers, identical criteria,
boundary text the only difference):

- **18 criteria FIXED** by the revision
- **2 criteria BROKEN**
- discordant n = 20, **two-sided p = 0.0004 — significant**
- **delta = +6.5 pp (81.5% → 88.0%)**

## 3. The three checks that make this credible

### 3.1 The effect is concentrated where the treatment was applied

| Criterion set | pre | post | delta |
|---|---:|---:|---:|
| **WITH a revision** (30 keys, n=60) | 63.3% | **91.5%** | **+28.2 pp** |
| **WITHOUT a revision** (n=189) | 87.3% | 86.9% | **−0.4 pp** |

A **+28.2 pp** gain exactly where boundaries were sharpened, and **−0.4 pp
(noise)** everywhere else. The revisions did what they were aimed at and left
the rest of the rubric alone. This is the negative control the design needed:
a diffuse "the model just got luckier" effect would have moved both lines.

### 3.2 It is not memorisation

The overfitting worry with a stable question set is that revisions authored from
known answers will score those answers well and fresh answers poorly. Observed:

- original answers (the derivation set): 75.4% → **92.7%** (+17.3 pp)
- fresh unseen answers: 81.5% → **88.0%** (+6.5 pp, p = 0.0004)

The gain is **larger on the derivation set than on fresh answers**, so part of it
*is* item-specific — as expected, and why the fresh number is the honest one.
But a genuinely memorising revision would show ≈0 on fresh; +6.5 pp at
p = 0.0004 is real generalisation to unseen answers of the same questions.

### 3.3 It corrects the harsh direction specifically

Under-credit on fresh answers fell **39 → 23 (−41%)** while over-credit stayed
**flat at 7**. Under-credits classified `missing_evidence`/`conceptual_error`
fell 30 → 19. The revisions made the grader stop withholding earned points
**without** making it lenient — the asymmetry we wanted, given that under-credit
was outrunning over-credit 3.3× before.

### 3.4 The two regressions, honestly

- `apprecalc-frq-005/part-a-criterion-2` — **was not revised.** A flip on an
  untouched criterion is run-to-run variance, not revision damage.
- `apphycm-frq-018/b-solution` — **was revised**, and got worse. One genuine
  revision-induced regression out of 30 authored (3.3%). Worth inspecting
  before this becomes standing process, but it does not threaten the result.

## 4. Latency — the escalation-avoidance claim, partially supported

| Cell | p50 | p90 |
|---|---:|---:|
| `fresh_pre` | 2,088 ms | 3,055 ms |
| `fresh_post` | **2,006 ms** | **3,974 ms** |

**p50 is flat-to-slightly-better (−82 ms)** — confirming the central mechanical
claim: because the boundary is *static rubric text inside the existing single
call*, strengthening it costs no extra round-trip. This is the structural
difference from the refuted flywheel, which paid a retrieval cost on every call.

**But p90 rose 3,055 → 3,974 ms (+30%)**, and that should not be waved away: the
revised prompts are materially longer, and longer inputs appear to widen the
tail. Boundary strengthening is **not free** at the tail even though it is free
at the median. If contracts keep accreting variants indefinitely, this cost
grows — an argument for periodically *consolidating* boundary text rather than
only appending to it.

**The escalation-avoidance claim itself was not directly testable here.** The
fresh gold contained **zero** `unable_to_determine` labels, and naturally
occurring ambiguity in Engine 1's domain is only ~0.7% (3 of 409 non-graph
criteria in Stage 3) — too rare to measure from observation at any realistic
sample size, so there were no
genuinely-ambiguous cases for the revised `abstention_policy` fields to act on.
Abstention calibration remains unmeasured; that needs a corpus deliberately
seeded with ambiguous responses.

## 5. What this validates, and what it does not

**Validated:**
- The mechanism is real, significant, and generalises to unseen answers of known
  questions.
- It is targeted, not diffuse (+28.2 pp on treated criteria, −0.4 pp elsewhere).
- It corrects under-credit without introducing over-credit.
- It is latency-neutral at the median — structurally unlike the refuted
  runtime-retrieval flywheel.

**Not validated:**
- **Escalation/abstention reduction** — untestable on this corpus (no ambiguous
  gold). This is the part of the owner's thesis still owed a measurement.
- **Durability at scale** — 21 items, one subject-family spread, one authoring
  pass. β2 is required.
- **Tail-latency cost of accreting contracts** — flagged (+30% p90), not
  characterised.
- Nothing here addresses the **1,000 ms launch bar** (p50 still ~2,000 ms) or the
  **4 unmeasured feedback-quality dimensions**.

## 6. Projected effect on the launch bar (bounded, not a claim)

Stage 6 pooled Arm A was 393/434 = 90.6%. The 21 β1 items carry 126 of those
criteria and 31 of the 41 errors. The measured fresh-answer improvement on
treated criteria was +28.2 pp. Applying that only to the treated criteria and
holding everything else fixed projects roughly **94–96% pooled** — i.e. the
≥95% bar becomes plausibly reachable through boundary authoring alone, which is
consistent with the independent per-item estimate in the stable-item-set note
("repairing ~8 items clears the bar").

This is a projection from n=60 treated criteria, not a measurement. It should be
confirmed by β2 on a census basis before any launch-readiness claim.

## 7. Recommendation

**Proceed to β2.** The mechanism is validated; scale it, and close the two gaps
this run could not:

1. **Seed an ambiguity corpus** so `abstention_policy` and the escalation-
   avoidance claim can actually be measured. This is the owner's core thesis and
   it is currently unproven, not disproven.
2. **Census, not sample** — author boundaries for every error-carrying criterion
   per subject, prioritising AP Statistics (82.0%) and AP Physics 1 (85.2%).
3. **Track contract length against p90** — consolidate rather than only append.
4. **Inspect `apphycm-frq-018/b-solution`** — the one true revision-induced
   regression, before this becomes standing process.
5. Add **within-arm repeat runs**; verdict stability under identical inputs is
   still unmeasured and a reliability claim needs it.
