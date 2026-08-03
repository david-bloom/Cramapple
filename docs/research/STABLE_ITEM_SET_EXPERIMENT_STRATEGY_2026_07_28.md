# Stable Question Set — What It Changes About Grading Experimentation

**Date:** 2026-07-28
**Trigger:** Product Owner clarification — Cramapple serves a *defined, stable
set of questions per subject*; questions are fixed, student answers vary.
**Status:** Strategy note. Revises the framing (not the substance) of the
Phase C Stage 6 recommendation.

---

## Short answer

**Yes — substantially.** A closed item set changes grading from an *open-domain
ML problem* ("will this generalize to questions we haven't seen?") into a
*bounded content-engineering problem* ("which of our ~N known items are not yet
graded well, and what does each one need?").

The Phase C Stage 6 data already supports this reading, and it makes the result
look considerably better than the pooled headline suggested.

## 1. The errors are concentrated, not diffuse — this is the whole argument

Re-cutting the Stage 6 Arm A result per item rather than pooled:

| | |
|---|---:|
| Items at **100%** criterion agreement | **73 / 99 (74%)** |
| Items with ≥1 error | 26 |
| Total criterion errors | 41 |
| Distinct (item, criterion) pairs with any error | **41 / 434 = 9.4%** |

Repairing the worst items individually:

| Items repaired | Pooled agreement |
|---:|---:|
| 0 | 90.6% |
| 3 | 92.9% |
| 5 | 94.2% |
| **8** | **95.6% — clears the ≥95% launch bar** |
| 15 | 97.5% |

**Under an open item set, 90.6% is a model-quality ceiling.** Under a stable
item set, it is a **backlog of roughly 8–26 known items**, each with a named,
inspectable defect. That is a fundamentally different — and far more
tractable — problem.

## 2. A quarter of the "errors" are a measurement artifact, not grader failure

Five of the worst-performing items are `APSTATS-HDG-2026-GRAPH-*`, carrying
**10 of 41 errors (24%)**. These items instruct the student to *"Submit one
photograph showing your constructed graph"*, and their criteria grade drawn
artifacts — `SEGMENTED_BARS` ("draws two complete segmented bars with total
length 1"), `POINTS_PLOTTED` ("plots all nine ordered pairs at recoverable
locations"), `AXIS_SCALE`.

Stage 3 generated **text-only** synthetic responses. So these are **Engine 4
(Spatial Multi-Modal) items scored by Engine 1 (text)** — a routing mismatch in
the corpus, not a grader defect. Both the model and the gold labels were
operating in a degraded mode (note the gold labels themselves are largely
`unable_to_determine` on these).

Excluding them, Arm A's Engine-1-appropriate agreement is approximately
**383/414 = 92.5%**, not 90.6% — and the remaining repair backlog drops to
~21 items.

**Action:** these items should carry `rubric_type` / `evaluator_strategy`
routing to Engine 4 and be excluded from Engine 1 calibration corpora. This is
the router field from TASK-0016 Technical Scope §1 doing exactly the job it was
specified for; the corpus was built without consulting it.

## 3. What changes in experimental design

### 3.1 The held-out dimension moves from *items* to *answers*

This is the most important methodological consequence, and it inverts a
discipline I applied throughout Stage 5/6.

I spent real effort keeping *items* held out — burning the v1 gate slice,
selecting a disjoint v2 slice, tracking gate-exposed vs clean subsets. **Under
a stable question set that discipline is largely pointless**: every item is
"exposed" permanently by design. You will tune against these exact questions
forever; that is the product.

What must stay held out is **answers**. The corpus discipline becomes, per item:

- a **frozen regression set** of adjudicated answers (never used for tuning) —
  guards against regressions when prompts/models/contracts change;
- a **rotating validation set** of fresh answers (real student answers once
  live) — the only honest accuracy measurement;
- a **tuning set** — answers you are allowed to look at while authoring
  boundary contracts.

Contamination now means *"we tuned on this answer"*, not *"we tuned on this
question."*

### 3.2 Sampling → census, plus a per-item scoreboard

There is no population to generalize to. Eventually **every item gets measured**.
Pooled cross-subject accuracy stops being the headline metric and becomes a
roll-up; the operational artifact is a **per-item accuracy scoreboard** with a
triage queue ordered by (error rate × expected student volume).

Statistical power arguments about unseen items become irrelevant. Power now
matters *within* an item — how many answers per item do you need to trust its
score? That is a much smaller, per-item question.

### 3.3 `accepted_variants` becomes a monotone accumulating asset

The Stage 6 named defect — equivalent-form under-credit (75.0% agreement on
`equivalent_noncanonical_wording`, 26 under-credits vs 8 over-credits) — is a
**cold-start problem**, not a model limitation. With stable items, every
adjudicated "this phrasing is also correct" is permanently attached to that
item's criterion and never has to be re-learned. Per-item accuracy should
improve monotonically with usage.

> ### ⚠ Do not re-run the already-refuted experiment
>
> `grading_cross_subject_takeaways.md` **Lesson 2** records that exemplar
> retrieval, oracle-precedent injection, gated prompting, and a **100-answer
> online flywheel all failed to beat the no-card baseline** — some made quality
> or latency worse.
>
> The distinction that matters — **corrected 2026-07-28 per Product Owner**, who
> has the more precise account of what those experiments actually showed:
>
> - **Refuted:** building a *reference body of answers* and consulting it at
>   **runtime**. The failure mode was **latency** — the retrieval/injection step
>   costs time on every grading call, for no accuracy gain.
> - **Supported:** accumulating a body of **grading actions** (the verdicts,
>   their rationales, and the human adjudications that settled them) and using
>   them **offline** to *strengthen the rubric boundary* — sharper accepted
>   variants, enumerated near-misses, explicit scope/polarity/contradiction
>   policy. This handles edge cases inside the single fast call and therefore
>   **avoids time-consuming escalations**, so it is a latency *win*, not just an
>   accuracy win.
>
> The raw material differs (grading *actions*, not answer text), the timing
> differs (offline, not runtime), and the payoff differs (escalation avoidance,
> not reference lookup). A stable item set makes the supported path cheap and
> compounding. It does not resurrect the refuted one.

### 3.4 Deterministic coverage becomes a finite, one-time project

Stage 6 measured the deterministic layer firing on **3 of 437 criterion calls
(0.7%)** — Lesson 12. In an open-item world, authoring per-item verification
profiles is unbounded work. With a closed set of ~150–250 items per subject it
is a **finite content project**, and the AP Statistics triage already found
**28 of 100 FRQs are numeric/keyed**.

This is the highest-value lever available, because it is the only one that
improves accuracy, latency, and cost simultaneously: a deterministic verdict is
~0 ms, ~$0, and ~100% accurate. Fully-keyed items could bypass the model
entirely.

### 3.5 Prompt caching becomes available — and it targets the binding latency constraint

Stable questions mean the stem, stimulus, and criterion contract are **byte-identical
across every student answering that item**. That makes the prompt prefix
cacheable, which was not meaningfully true in an open-item framing.

Why this matters more than it sounds: the launch bar's binding constraint is
**TTFB ≈ 588 ms, 59% of the entire 1,000 ms budget** — before a single output
token. Prompt caching is the most plausible lever on TTFB, and the gateway
pricing table already carries a cached-input rate of **$0.03/1M vs $0.30/1M
(10× cheaper)**. Stage 6 logged zero cached tokens because every call was
effectively unique.

**This should be the next speed experiment**, ahead of any further architecture
comparison. It is cheap to test and directly attacks the metric that is
furthest from target.

## 4. What does *not* change

- **The 1,000 ms bar is still unmet** (Arm A p50 1,943 ms). Caching and
  deterministic coverage are the levers; item stability does not by itself fix it.
- **Arm A vs Arm B is still settled** (Lesson 9). Request-shape economics are a
  property of criterion count and serial generation, independent of whether the
  item set is closed.
- **Feedback quality is still unmeasured** on 4 of 5 required dimensions.
- **Labels are still `calibration` tier**, not dual-human adjudicated gold.
  Stable items make real student answers the eventual replacement for the
  synthetic corpus — but that is post-launch.
- **Per-item overfitting is a genuine new risk.** Tuning contracts against known
  items can produce a grader that scores the frozen answer set well and real
  student answers worse. The frozen-regression / rotating-validation split in
  §3.1 exists specifically to detect this, and it should be treated as a
  standing guardrail, not a nicety.

## 5. Revised next steps

Superseding the framing (not the substance) of `RESULTS.md` §7:

1. **Route the 5 `HDG-2026-GRAPH` items to Engine 4** and rebuild the Engine 1
   calibration corpus without them. Recovers ~1.9 pp of apparent error that is
   pure artifact.
2. **Work the per-item backlog, not the aggregate.** Repairing ~8 named items
   clears the 95% bar. Prioritise by error rate × expected student volume.
3. **Test prompt caching for TTFB reduction** — the only cheap lever on the
   metric furthest from target, newly available because questions are stable.
4. **Scope verification-profile authoring as a finite per-subject content
   project**, starting with the ~28% of Statistics FRQs already triaged as
   numeric/keyed.
5. **Restructure corpora around answer-level holdout** (frozen regression +
   rotating validation + tuning), replacing the item-level holdout discipline
   used in Stage 5/6.
6. Close the feedback-quality measurement gap (4 of 5 dimensions, ~$0.30–0.60).
