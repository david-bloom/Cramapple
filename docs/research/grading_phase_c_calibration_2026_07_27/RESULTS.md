# TASK-0016 Phase C — Stage 6 Full Paired Calibration Results

**Run date:** 2026-07-28
**Corpus:** 100 frozen FRQ responses (Stage 1 manifest, Stage 3 corpus), 433–434
adjudicated criterion judgments per arm
**Model:** `google/gemini-2.5-flash`, thinking disabled, temp 0, via Vercel AI Gateway
**Cost:** $0.6216 of the $5.00 cap. Cumulative Phase C spend: **$0.8839**

---

## 1. Headline

**Neither arm meets the TASK-0016 launch bar. Phase C's answer is: repair a
named cross-subject defect before any larger or learner-facing run.**

| Launch bar | Target | Arm A | Arm B | Met? |
|---|---|---:|---:|---|
| Criterion agreement | **≥95%** | 90.6% | 92.4% | ✗ both |
| Experimental aspiration | ≥90% | 90.6% | 92.4% | ✓ both |
| End-to-end p50 | **≤1,000 ms** | 1,943 ms | 3,670 ms | ✗ both |
| Cost / FRQ | ≤$0.01 | $0.0039 | $0.0023 | ✓ both |
| Schema validity | 100% | 99.3% | 99.0% | ~ both |

Cost is a solved problem (4–5× under budget). Quality is close but short.
Speed is the furthest from target and, per §5, is not fixable by arm choice.

## 2. Arm A vs Arm B

| Metric | Arm A (parallel per-criterion) | Arm B (single structured call) |
|---|---:|---:|
| Calls | 437 | 100 |
| Schema-valid | 434/437 (99.3%) | 99/100 (99.0%) |
| Criterion agreement | 393/434 = **90.6%** | 400/433 = **92.4%** |
| — clean held-out (never gate-exposed) | 249/275 = 90.5% | 252/272 = 92.6% |
| — gate-exposed subset | 144/159 = 90.6% | 148/161 = 91.9% |
| Total-score exact agreement (per item) | 48/69 = 69.6% | 54/69 = 78.3% |
| Over-credit / under-credit | 8 / 26 | 4 / 20 |
| **evidence_quote verbatim-grounded** | **369/388 = 95.1%** | **292/359 = 81.3%** |
| p50 / p90 / p95 / p99 / max latency (ms) | 1,943 / 2,866 / 3,315 / 4,233 / **12,024** | 3,670 / 5,700 / 7,191 / 7,758 / 9,182 |
| Cost per FRQ | $0.00389 | $0.00232 |

**Gate-exposure did not contaminate the result** — clean held-out and
gate-exposed subsets agree to within 0.1 pp (Arm A) and 0.7 pp (Arm B), so the
pooled numbers are usable despite 40 of the 100 items having appeared in a
Stage 5 gate.

### The Arm B quality edge is real in direction, but still not significant

Arm B beat Arm A on verdict agreement for the **third consecutive independent
run** (+4.4 pp, +1.1 pp, now +1.8 pp). Paired McNemar on Stage 6:
**B-correct-where-A-wrong = 21, A-correct-where-B-wrong = 13, 34 discordant,
two-sided p ≈ 0.229 — not significant.** Verdict stability between arms was
91.9% (395/430).

**But Arm B pays for it with feedback grounding:** its `evidence_quote` is a
verbatim substring of the student response only **81.3%** of the time versus
Arm A's **95.1%** — a 13.8 pp regression on one of the five required
feedback-quality dimensions. The brevity constraint that was added to fix Arm
B's latency appears to push it to paraphrase quotes rather than lift them.
Under a quality-first ordering, Arm B's verdict edge and grounding deficit
roughly cancel; under any ordering, its latency loses.

**This does not overturn the `ARM_B_ROOT_CAUSE_ANALYSIS.md` verdict.** Latency
by criterion count reconfirms the structural finding at n=100:

| n_criteria | items | Arm A p50 | Arm B p50 |
|---:|---:|---:|---:|
| 1 | 12 | 1,506 ms | 1,407 ms |
| 2 | 12/6 | 2,100 ms | 2,459 ms |
| 3 | 39/13 | 1,627 ms | 2,649 ms |
| 4 | 124/31 | 1,969 ms | 3,604 ms |
| 6 | 192/32 | 1,900 ms | 4,255 ms |
| 8 | 8/1 | 3,305 ms | 7,611 ms |
| 10 | 50/5 | 2,725 ms | 7,687 ms |

Arm A is near-flat in criterion count; Arm B scales linearly and is ~2.8× slower
at n=10. **Retain Arm A.**

### One genuine caveat in Arm A's favour-of-record

Arm A's **max latency was 12,024 ms** — a single criterion call on
`apprecalc-frq-001` that ran ~2.3× longer than any other call in the run
(next slowest: 5,296 ms). This is exactly the max-of-N fan-out tail risk that
originally motivated Arm B: with N parallel calls, one slow draw sets the
item's latency. It occurred **once in 437 calls (0.2%)**, so it does not change
the recommendation — but at 2,500 students it would land on roughly 1 in 500
gradings, and it is the single strongest remaining argument for revisiting a
batched design later.

## 3. The named defect: systematic under-credit on equivalent / boundary-adjacent work

**Under-credit outnumbers over-credit 3.3× (Arm A: 26 vs 8) and 5× (Arm B: 20
vs 4).** The graders are systematically harsh, and the harm direction is
withholding points from work that earned them.

Localised by mechanism (Arm A):

| Mechanism | agreement | over | under |
|---|---:|---:|---:|
| **equivalent_noncanonical_wording** | **75.0%** | 0 | **6** |
| contradiction_or_self_correction | 81.6% | 3 | 3 |
| correct_conclusion_wrong_reasoning | 81.8% | 3 | 1 |
| ecf_downstream_correct_from_wrong_upstream | 84.0% | 1 | 3 |
| negation_hedging_scope_temporal_near_miss | 90.6% | 1 | 2 |
| correct_method_arithmetic_error | 95.8% | 0 | 1 |

And by archetype (Arm A): `boundary_adjacent` is the worst at **80.9%**
(3 over, 10 under); `blank_off_topic` is perfect at 100%.

**This is a direct, cross-subject reconfirmation of two standing lessons**
(`grading_cross_subject_takeaways.md` Lesson 1 "rubric-boundary precision is
the dominant quality lever" and the FRQ-02 rule "equivalent forms must earn").
The grader rejects correct answers phrased differently from the canonical
wording — the single largest recoverable error class, worth ~1.4 pp of Arm A's
agreement on its own, and concentrated in exactly the criteria whose
`accepted_variants` field is empty or generic.

Weakest subjects (both arms): **AP Statistics 82.0% / 82.3%** and **AP Physics 1
85.2% / 88.9%**. AP Chemistry (100% / 93.3%) and AP Biology (96.4% / 98.1%) are
strong. The Statistics weakness is notable because Statistics is the designated
first launch subject.

## 4. Deterministic layer is effectively absent

The deterministic checker **fired on 3 of 437 criterion calls (0.7%)**, across
3 distinct items. Only 5 `content_key`s in the entire 100-item corpus have a
seeded verification profile (the same 5 wired into Production since 2026-07-12),
and the checker correctly abstained on the rest. **99.3% of criteria were graded
by the model with no deterministic support.** Expanding this layer is the most
direct lever on both accuracy and latency (a deterministic verdict costs ~0 ms
and ~$0), and it is currently doing almost nothing.

## 5. The launch bar cannot be met by arm choice (unchanged, reconfirmed)

Measured: provider TTFB alone ≈ 588 ms — **59% of the entire 1,000 ms budget** —
leaving ~110 output tokens against Arm A's 234 per criterion, before network,
auth, DB writes, and render. Arm A's actual p50 is 1,943 ms, ~1.9× the bar.
Closing it requires a faster provider path, streamed partial feedback
(perceived latency becomes TTFB-bound ~600 ms), far wider deterministic
coverage (§4), or an explicit revision of the 1,000 ms figure. **Phase F decision.**

## 6. Known measurement gap — read before citing this as complete

The Stage 6 protocol requires five feedback-quality dimensions per missed
criterion: reason match, minimum-fix sufficiency, grounding, improved-answer
correctness, and error-class accuracy.

**Only grounding was measured** (deterministically, as a verbatim-substring
check: Arm A 95.1%, Arm B 81.3%). The other four require an independent
semantic judging pass over ~200 missed criteria per arm, which **was not run**.

This is a real gap against the protocol, not an oversight to paper over: the
run measures *whether the grader scores correctly*, and only one of five
dimensions of *whether its feedback is any good*. Since feedback quality is the
product thesis (Lesson 6), **no feedback-quality claim should be made from this
run beyond grounding.** Estimated cost to close: one judging workflow over
~400 criterion-feedback records, roughly $0.30–0.60 and ~15 minutes.

## 7. Recommendation (one of the four permitted Stage 6 conclusions)

> **Repair one named cross-subject defect and rerun a fresh held-out slice.**

Specifically: **author explicit `accepted_variants` / equivalent-form boundary
language for the criteria driving the under-credit cluster**, prioritising AP
Statistics and AP Physics 1, then rerun on a held-out slice that excludes all
100 items used here.

Rationale: agreement is 90.6% against a 95% bar; the gap is dominated by one
identified, recoverable, cross-subject error class (equivalent-form
under-credit, 3.3–5× skewed toward withholding earned points); and Lesson 1
says boundary precision — not model or architecture change — is the lever that
has historically moved this number most. Do **not** advance to a learner-facing
or wider run: the launch bar is unmet on both quality and speed.

Architecture decision within this recommendation: **retain Arm A**. Arm B's
verdict edge has now replicated three times but remains statistically
unproven (p ≈ 0.23), comes with a 13.8 pp grounding regression, and loses
decisively on latency.

**This is not a launch decision. Phase F owns that.**
