# Boundary-Strengthening at Scale + Four-Engine Reliability — Program Design

**Date:** 2026-07-28
**Owner ask:** (1) validate at scale that a body of *grading actions*
strengthens rubric boundaries and thereby avoids time-consuming escalations;
(2) ensure the four grading engines operate reliably, consistently, efficiently.
**Status:** **β1 EXECUTED 2026-07-28 — GATE PASSED.** See
`grading_phase_c_calibration_2026_07_27/B1_BOUNDARY_STRENGTHENING_RESULTS.md`.
Headline: +6.5 pp on fresh held-out answers (paired McNemar p=0.0004), +28.2 pp
on treated criteria vs −0.4 pp on untouched criteria, under-credit down 41% with
over-credit flat, p50 latency unchanged. Cost $0.5965. **Engine 2 confirmed out
of scope** (Product Owner, 2026-07-28 — option (a), three engines: 1, 3, 4).
Two gaps β1 could not close: escalation/abstention reduction is still unmeasured
(fresh gold had zero ambiguous labels), and p90 latency rose +30% from longer
contracts. Original proposed design retained below.

---

## 1. New evidence that sharpens the hypothesis

Two results from the Stage 6 data (2026-07-28, n=434 criterion judgments across
9 subject SKUs) bear directly on the escalation-avoidance claim:

### 1.1 Self-reported confidence is not merely weak — it is entirely flat

**Every one of the 434 judgments came back `confidence: high`.** The model never
once said medium or low. Consequently:

- **100% of the 41 errors were made at high confidence.**
- A "escalate anything not high-confidence" policy would escalate **0%** of
  criteria and catch **0%** of errors.

This is a far more extreme replication of **Lesson 4** than the original FRQ-02
finding (which at least had 0.88–0.95 separation on a float scale). It is
strong direct support for the owner's thesis: **you cannot escalate your way out
of these errors, because the grader has no idea it is wrong.** The only
available lever is the rubric boundary itself.

*Method caveat:* a 3-value enum (`low|medium|high`) invites mode collapse. The
FRQ-02 float version compressed too (0.8–1.0, median 0.95), so this replicates
rather than merely reflecting schema design — but a future run should use a
float and report the distribution before drawing a stronger conclusion.

### 1.2 The grader *under*-abstains — the dangerous direction

| | rate |
|---|---:|
| Model said `unable_to_determine` | 5/434 = **1.2%** |
| Gold said `unable_to_determine` | 14/434 = 3.2% |
| — of which Engine-4 graph artifact | **11** |
| — **genuine Engine 1 ambiguity** | **3/409 = 0.73%** |
| Model abstained where gold was decisive | **0** |

**Corrected 2026-07-28:** the 3.2% figure is inflated by the `HDG-2026-GRAPH`
items (spatial content scored as text). Real ambiguity in Engine 1's own domain
is **~0.7%** — far too rare to measure abstention from observation, which is why
the β2 corpus must deliberately seed it.

The grader never abstains unnecessarily — but it fails to abstain on ~2/3 of the
genuinely ambiguous cases, committing a confident verdict instead. For a
student-facing product this is the worst failure shape: nothing routes it to a
human.

### 1.3 Two distinct "escalation" sources must not be conflated

| Source | Observed rate | Nature | Fix |
|---|---:|---|---|
| **Operational failure** (JSON truncation, timeout) | **33.3%** uncertain in the Production repair pilot (2026-07-27) | engineering defect | output-token handling, timeout policy, retries |
| **Semantic uncertainty** (genuine rubric ambiguity) | **1.2%** measured here, should be ~3.2% | rubric/boundary quality | boundary strengthening — *this program* |

The headline 33.3% figure that has been cited as the escalation load is
**almost entirely operational**, not semantic. Boundary strengthening will not
fix it, and fixing it will not validate this hypothesis. They are separate
workstreams and must be measured separately.

## 2. The hypothesis, stated testably

> Promoting accumulated **grading actions** (verdict + rationale + human
> adjudication of the disagreement) **offline** into an item's criterion
> boundary contract will, on **fresh unseen answers to the same item**:
> (a) raise criterion agreement, (b) raise abstention *calibration* — abstain
> where genuinely ambiguous, commit where not, (c) reduce or hold latency
> (no added runtime lookup, fewer escalation round-trips), and (d) not regress
> the frozen answer set.

Falsifiable predictions, in priority order: **(a) up, (d) flat** is the minimum
for the finding to hold. If (a) rises but (d) regresses, we have overfitted to
known answers — the specific risk a stable item set introduces.

## 3. Proposed design — validate the mechanism before scaling it

### Phase β1 — Mechanism test (small, cheap, decisive)

Do **not** start at scale. Start where the errors already are.

1. **Target set:** the 26 error-carrying items from Stage 6, minus the 5
   `HDG-2026-GRAPH` items (Engine 4 content mis-scored as text — see the
   stable-item-set note) = **21 items, 31 real criterion errors**.
2. **Mine the grading actions** already on hand: for each of the 31 errors we
   have the model's verdict, its `withheld_point_reason` / `minimum_fix` /
   `evidence_quote`, and the independent gold adjudication with rationale. That
   *is* a body of grading actions — no new collection needed for β1.
3. **Author boundary revisions** per criterion: accepted variants, enumerated
   insufficient near-misses, explicit scope / polarity / contradiction / ECF
   policy. Freeze and hash them.
4. **Generate a fresh answer set** for those 21 items — new answers, same
   archetype/mechanism balance, held out at the *answer* level.
5. **Run four cells** (both arms × pre/post contract) on the fresh answers, plus
   a **regression pass** of the revised contracts against the original answers.
6. **Measure:** agreement delta, abstention calibration delta, latency delta,
   regression delta. Estimated cost **~$0.35–0.60**.

Gate to proceed: agreement up ≥3 pp on fresh answers **and** no regression
beyond noise on the frozen set.

### Phase β2 — Scale validation

Only if β1 clears. Extend to the full subject item set (census, not sample),
with the answer-level holdout discipline from the stable-item-set note, and add:

- **Consistency:** repeat runs on identical inputs → verdict-stability rate
  (Stage 6 measured 91.9% *between arms*; we have no *within-arm* repeat
  measurement at all, which is a real gap for a reliability claim).
- **Escalation economics:** abstention rate × adjudication cost, tracked per
  item, as the thing boundary strengthening is supposed to drive down.

### Phase β3 — Durable pipeline

Convert the one-off into standing process: every human adjudication emits a
candidate boundary revision; revisions are reviewed, promoted, hashed, and
regression-tested against that item's frozen answer set. This is the compounding
asset — and it is offline by construction, so it never touches grading latency.

## 4. Four-engine reliability — honest status (scope RESOLVED: engines 1, 3, 4)

"Ensure the four engines operate reliably, consistently, efficiently" **cannot
be executed as one validation today**, because two of the four have essentially
nothing to validate. Current reality:

| Engine | Real status | Can it be validated now? |
|---|---|---|
| **1 — Discrete/Analytical Text** | In production. Validated cross-subject at n=100 this session: 90.6% pooled / ~92.5% excluding Engine-4 artifacts, vs a ≥95% bar. Named defect identified. | **Yes** — and β1/β2 above *is* its reliability program. |
| **2 — Holistic/Evaluative Text** | **Deferred by plan.** The rollout plan puts it explicitly out of scope: it serves AP English/History, which are not in the launch set, and the platform holds an evidence-backed stance *against* holistic scoring (Tate et al. 2024, κ≈.58 vs human-human .79). **No implementation exists.** | **No** — nothing built. Requires a scope decision (§4.1). |
| **3 — Structured Multi-Modal (formula/ECF)** | Typed path built and verified in isolation (formula checker 62/62, ECF engine 6/6, Statistics templates 7/7). **But at graded-traffic scale it is effectively absent: the deterministic layer fired on 3 of 437 criterion calls (0.7%)**, because only 5 `content_key`s carry a verification profile. Hand-drawn path validated only on synthetic renders. | **Partly** — the components are validated; the *integration* is not. Needs profile-coverage expansion first, then it becomes measurable. |
| **4 — Spatial Multi-Modal (graphs)** | Research stage only (TASK-0011, Phase D, "longest pole", owner assigned 2026-07-27). Never validated end-to-end. **And its content is already sitting in the live bank being graded as text** — the 5 `HDG-2026-GRAPH` items found this session, which produced 24% of Stage 6's apparent error mass. | **No** — Phase D has to run first. But the mis-routing is an immediate, separable fix. |

### 4.1 The scope decision — RESOLVED 2026-07-28

**DECIDED: option (a), three engines (1, 3, 4).** Engine 2 remains deferred
until AP English/History enters scope. Options as originally presented:

**Engine 2 is currently out of scope by an explicit, evidence-backed plan
decision.** Validating "all four engines" either re-opens that decision or
means three. I am not going to silently pick one. Options:

- **(a) Three engines (1, 3, 4)** — matches the current plan and the launch set;
  Engine 2 stays deferred until English/History enters scope.
- **(b) Four, including Engine 2** — requires reversing a recorded decision and
  building Engine 2 from nothing, for subjects with no launch commitment.
- **(c) Three now, plus a cheap Engine 2 feasibility probe** — reuse Engine 1's
  criterion decomposition against a couple of multi-row analytic rubrics
  (DBQ/LEQ-style), purely to size the work, no build.

### 4.2 Sequencing that respects the dependencies

The engines are not independently validatable in parallel — Engine 3 and 4 both
gate on content/coverage work that does not exist yet:

1. **Immediate, cheap, unblocked:** route the 5 `HDG-2026-GRAPH` items to
   Engine 4 and out of Engine 1 corpora (recovers ~1.9 pp of apparent Engine 1
   error that is pure artifact).
2. **Engine 1:** run β1 → β2. This is the only engine where a reliability claim
   is available in the near term.
3. **Engine 3:** scope verification-profile authoring as a finite per-subject
   content project (~28% of Statistics FRQs are already triaged numeric/keyed).
   Only after coverage rises above a few percent can "Engine 3 operates
   reliably at scale" be measured at all. This doubles as the strongest
   available lever on the unmet 1,000 ms latency bar, since deterministic
   verdicts cost ~0 ms.
4. **Engine 4:** execute Phase D in its planned order (QR capture → observation
   bake-off → dual-human gold → calibrated abstention → shadow). Do not
   shortcut to a learner-facing score.
5. **Cross-engine consistency harness:** once ≥2 engines are live, add the
   repeat-run stability and per-engine latency/cost segmentation that a
   "reliably, consistently, efficiently" claim actually requires. Note the
   launch bar already mandates latency reported **per engine and input
   modality**, which no run has yet done.

## 5. What I would not claim from this program

- It will not fix the **1,000 ms launch bar** on its own. TTFB alone is 588 ms
  (59% of budget). Boundary strengthening removes escalation round-trips, which
  helps the tail, not the floor.
- It will not produce **dual-human adjudicated gold**. These remain
  `calibration`-tier labels.
- It does not close the **feedback-quality measurement gap** (4 of 5 required
  dimensions still unmeasured).
