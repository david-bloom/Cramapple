# TASK-0016 Phase D — Stage D5: Abstention Calibration

**Written:** 2026-08-20. **Status:** Repackaging of existing measured evidence into the Stage D5
artifact, built from **observed calibration errors** (per the D5 spec: "build thresholds from
observed calibration errors, not model confidence"). Companion to `BAKEOFF_RESULTS.md` (D4). The
concrete threshold table this document derives is `abstention_thresholds.json`, generated
deterministically by `analysis/gen_abstention_thresholds.py` from `analysis/d4_d5_summary.json`.

**Evidence tier (read this first).** All numbers are measured against
`real_photo_gold_labels_2026_08_18.json` — **`ai_provisional` gold** (single-pass AI, not
reader-certified, iterated corpus). Per `GRADING_RESEARCH_CANONICAL_PROCESS`, **nothing here is
release-grade.** This calibration defines what an Engine-4 shadow run (Stage D6) would route to
human review and where automated output is least untrustworthy — **not** a launch-authoritative
automation policy. **Honest ceiling, stated up front: no configuration tested clears the DR-1 FAR
gate (≤2%).** Even the best response-level auto slice sits at ~12% FAR.

---

## 1. Coverage-versus-error curve (overall)

Response-level selective automation: auto-grade only responses at/above a confidence level, route
the rest to human review. Recomputed from raw rows (`analysis/d4_d5_evidence_repackage.py`); the
full-coverage row reproduces the documented aggregate exactly.

| Auto-grade gate | Response coverage | Auto-slice FAR | Auto-slice FRR | Auto-slice F1 | Auto-slice exact-match |
|---|---:|---:|---:|---:|---:|
| high-confidence only | **47.5%** (95/200) | **12.2%** | 4.1% | 96.2% | 60.0% |
| high + medium (= full coverage) | 100% | 19.0% | 8.0% | 93.3% | 38.5% |

(No responses carried `low` confidence, so the curve has two operating points.) The high-confidence
gate buys a real quality lift on the automated slice (FAR 19.0%→12.2%, FRR 8.0%→4.1%, F1 93.3%→96.2%)
at the cost of routing 52.5% of responses to human review — but **the automated slice still fails
DR-1 FAR by ~6×.** Confidence, on its own, is a coverage lever, not a FAR fix.

---

## 2. Observed per-criterion and per-(archetype, criterion) error — the real threshold basis

Thresholds are built from where the grader actually makes false-accept errors, not from its
self-reported confidence. Per-criterion false-accept rate (pooled across archetypes, full 200):

| Criterion | Observed FAR | Neg. support (fp+tn) | Read |
|---|---:|---:|---|
| `POINT_CONNECTION` | 66.7% | 3 | High FAR but tiny support — untrustworthy either way |
| `UNCERTAINTY_MARKS` | 39.1% | 23 | Genuinely weak (matches the DECISION-0045 weakest-agreement finding) |
| `Y_SCALE` | 37.1% | 35 | Weak |
| `PLOT_VALUES` | 23.6% | 55 | Weak in both directions (FRR 24.1%); largest error source |
| `X_SCALE` | 23.4% | 47 | Weak |
| `REPRESENTATION_TYPE` | 22.2% | 9 | High FAR on small negative support |
| `Y_UNIT` | 12.5% | 24 | Borderline |
| `ESTIMATE_VALUE` | 11.9% | 67 | Borderline |

Made archetype-specific, the unsafe cells sharpen considerably (these drive the routing policy):

| Cell | Observed FAR | Neg. support | Disposition |
|---|---:|---:|---|
| `CAT:PLOT_VALUES` | 71.4% | 7 | human_review_required |
| `CAT:UNCERTAINTY_MARKS` | 66.7% | 12 | human_review_required |
| `SER:X_SCALE` | 63.6% | 11 | human_review_required |
| `EST:Y_SCALE` | 34.4% | 32 | human_review_required |
| `SER:PLOT_VALUES` | 27.3% | 11 | human_review_required |
| `SER:Y_UNIT` | 25.0% | 8 | human_review_required |
| `EST:PLATEAU_ANNOTATION` | 0.0% | 27 | **auto_eligible (provisional)** |
| `EST:X_UNIT` | 0.0% | 9 | **auto_eligible (provisional)** |
| `EST:Y_UNIT` | 0.0% | 8 | **auto_eligible (provisional)** |

**Only 3 of 24 (archetype, criterion) cells are even provisionally auto-eligible** at a generous R&D
bar (observed FAR ≤ 5% with ≥8 negative-support observations). 11 cells fail on high FAR, 10 have
too little negative support to certify at all. Full table: `abstention_thresholds.json`.

---

## 3. Candidate abstention signals, mapped to what this corpus supports

The D5 spec lists candidate signals; here is which have real evidence today:

| Signal | Status on this corpus |
|---|---|
| Criterion-/archetype-specific historical error | **Primary basis** — §2, the disposition table |
| Model confidence (response-level) | Coverage lever only (§1); not a FAR fix |
| Self-consistency disagreement (3× `gpt-5.2`, asymmetric majority-earned) | **Confirmed at full corpus (n=200):** FAR 19.0%→14.7% (majority), a real lever at ~3× cost; still fails ≤2% (see §4) |
| OCR/geometry/multimodal disagreement | Explored (D4 arm 3); speed-only, not a reliable abstention decider |
| Escalation (EST-gated → `gpt-5.2-pro`) | Confirmed FAR lever on EST only (19.0%→13.6% corpus-wide); hybrid gate-on-escalation near-neutral (BAKEOFF §4) |
| Capture-quality measures | **Not measured on this corpus** — static offline photos; belongs to the live capture path (Stage D2) |
| Unsupported-representation / OOD detection | Not measured here |

---

## 4. Self-consistency ensemble — full-corpus confirmation

The pilot (n=39, `far_experiment_subsample`) showed asymmetric majority-earned consensus (2 of 3
`gpt-5.2` runs must agree on `earned`; a lone `earned` is downgraded, a `not_earned` is never
overridden) cutting FAR 33.3%→21.4%. Per this program's standing discipline (small-sample
directional reads reverse at scale — the escalation reversal is the canonical case), that number
must not be cited past pilot tier without a full-corpus run.

**Full-corpus run executed 2026-08-20** (all 200 photos, 2 extra `gpt-5.2` passes each, 322 new
calls, $6.64, 0 errors). Report: `analysis/self_consistency_fullcorpus_report.json`; data:
`runs/self_consistency_fullcorpus_extra_runs_2026_08_20.jsonl`.

| Policy | FAR | FRR | F1 | exact-match |
|---|---:|---:|---:|---:|
| Baseline (run #1 alone) | 19.0% | 8.0% | 93.3% | 38.5% |
| **Majority-earned (2 of 3)** | **14.7%** | 9.4% | 93.0% | 38.0% |
| Unanimous-earned (3 of 3) | 9.5% | 11.7% | 92.5% | 36.0% |

**The pilot's directional read holds at scale but attenuates — critically, it did NOT reverse**
(unlike the escalation case). Majority-earned is a real corpus-wide FAR lever (19.0→14.7) at a small
FRR cost (8.0→9.4) and near-flat F1; unanimous pushes FAR to 9.5% but costs more FRR/F1/exact. The
pilot's larger 33.3→21.4 was measured on a hand-picked medium-confidence subsample (a harder
population), which is why the full-corpus magnitude is smaller — not a contradiction. Per-archetype,
majority-earned helps **CAT** (FAR 46.9→37.5) and **EST** (12.3→7.8) but does **nothing for SER**
(33.3→33.3) — SER's false-accepts are not the "lone spurious `earned` vote" shape this policy
corrects.

**Cost/verdict:** a genuine FAR lever, but it triples per-response model cost (2 extra calls) and
still fails the ≤2% DR-1 gate by a wide margin. Recorded as a **candidate shadow-mode lever, not
adopted as the default** — it does not change the shadow-only conclusion.

---

## 5. Adversarial re-check — tested and rejected (do not revisit)

An adversarial re-verification pass as an abstention/re-scoring mechanism was tested and
**decisively rejected**: it solves FAR but destroys F1/exact-match (~5:1 collateral damage). The
failure looks mechanistic, not tunable. Recorded so a future session does not re-propose it as a
calibration lever without new evidence. (`runs/adversarial_recheck_results.jsonl`.)

---

## 6. Required abstention behaviors (encoded in the thresholds file)

Per the D5 spec, non-negotiable:

1. **Withhold the total whenever any point-bearing criterion abstains.** All rubric criteria in this
   graph family are treated as point-bearing, so any human-review-required or model-abstained
   criterion in a response withholds that response's total and routes it to human review. Given §2,
   most archetypes contain at least one unsafe criterion — consistent with the ~50% human-routing
   rate the confidence curve independently shows.
2. **Request a new photo only for fixable capture defects** (blur/glare/cutoff/framing). Any
   non-fixable or ambiguous defect routes to human review, not a retake loop. (This is the
   DECISION-0051 capture-failure split already implemented on the Stage D2 capture path; the
   accuracy corpus here does not exercise it.)

---

## 7. Coverage/error summary and the honest ceiling

- **Best automated slice found:** high-confidence gate — 47.5% coverage, 12.2% FAR, 4.1% FRR, 96.2%
  F1. Escalation and self-consistency shift FAR further but none reaches the ≤2% DR-1 gate.
- **Auto-eligible criterion cells:** 3 of 24, provisional, on `ai_provisional` gold.
- **Conclusion:** Engine 4 today is a **shadow-only / human-in-the-loop** system. The calibrated
  policy protects quality by routing the majority of work (and specifically the FAR-prone
  criteria) to human review; it does not yet support authoritative automation on any slice.

**What's genuinely missing:** (a) reader-certified gold (D3) — until then every FAR figure here is
R&D-tier and the thresholds are provisional; (b) capture-quality and OOD signals measured on the
live capture path, not the offline corpus. (The full-corpus self-consistency confirmation — the one
outstanding paid run this stage required — was executed this session, §4.) **Recommendation:** ship this as the shadow-mode routing policy for Stage D6,
re-derive the thresholds against reader-certified gold once D3 closes, and do not treat any cell as
authoritative-automation-eligible before that.

**See also:** `BAKEOFF_RESULTS.md` (D4), `abstention_thresholds.json` (the machine-readable policy),
`ENGINE4_PRODUCTION_DESIGN_2026_08_18.md` §2 (deployment-model options), `D3_D4_D5_STATUS.md`.
