# TASK-0016 Phase D — Stage D4: Observation Bake-off Results

**Written:** 2026-08-20. **Status:** Repackaging of existing measured evidence into the Stage D4
artifact, **not** a fresh run of D4's exact 4-arm gated protocol. Per `D3_D4_D5_STATUS.md`, the
core question D4 exists to answer (does representation/architecture choice matter, and which
wins?) already has a real, evidence-backed answer from the 2026-08-18/19 investigation; this
document consolidates that answer under D4's structure and **honestly marks what D4's letter still
requires and this evidence does not supply** (a pre-registered locked holdout, dual-human /
reader-certified gold). It also adds one new zero-spend re-analysis: **arm 4** in the owner-selected
reading (design-doc option (d), gate-on-escalation), which had never been computed before.

**Evidence tier (read this first).** Every number below is measured against
`real_photo_gold_labels_2026_08_18.json` — **`ai_provisional` gold**: single-pass AI labels, not
reader-certified, and the same corpus was iterated on (EST tolerance fixes, PLOT_VALUES prompt
attempts). By this repo's own rule (`GRADING_RESEARCH_CANONICAL_PROCESS`: only
`adjudicated_gold`/`held_out` support release/quality claims), **nothing here is release-grade.**
These are strong R&D signals for architecture selection, not launch-qualifying numbers.

Evidence-class labels follow repo convention (Live verified / Deployed verified / Repository only /
Prototype-research only / Proposed / Not verified).

---

## 1. Frozen inputs and provenance (Prototype-research only)

| Element | Value |
|---|---|
| Corpus | 200 real Biology hand-drawn-graph photos, 3 archetypes (CAT 64 / SER 69 / EST 67) |
| Gold | `gold/real_photo_gold_labels_2026_08_18.json` (`ai_provisional`, single-pass AI) |
| Primary model | `openai/gpt-5.2`, joint perception+judgment, single call, full image + full rubric |
| Escalation model | `openai/gpt-5.2-pro`, `maxOutputTokens: 1200` |
| Primary run | `runs/real_photo_benchmark_gpt52_results.jsonl` (200 rows; `prompt_hash`, `sha256`, `model_id` per row) |
| Escalation run | `runs/escalation_full_results.jsonl` (105 medium-confidence rows) |
| Re-analysis (this doc) | `analysis/d4_d5_evidence_repackage.py`, `analysis/arm4_gate_on_escalation.py` (deterministic, no model calls) |

The primary run's aggregate was **independently recomputed from raw rows** for this document and
reproduces the source doc exactly: exact-match 38.5%, F1 93.3%, FAR 19.0%, FRR 8.0% (1501 scored
criterion judgments). This confirms the harness before any derived claim is made on it.

---

## 2. The four arms

D4's spec compares the same frozen inputs across four arms. Here is what each arm actually has behind
it today:

| Arm | Definition | Status | Result (point-match / criterion accuracy) |
|---|---|---|---|
| **1. Direct multimodal criterion grading** (control) | `gpt-5.2`, joint perception+judgment, one call | **Run (full 200)** | **Winner.** 73.8% point-match on the driving criterion; 38.5% response exact-match, F1 93.3% |
| **2. Multimodal observation → separate criterion grading** | Explicit extraction-only perception, then judgment as a separate stage | **Run (probe)** | **Strictly worse — 20.2% point-match.** Perception errors compound rather than isolate when split. `runs/extraction_probe_*` |
| **3. Deterministic geometry/OCR → separate criterion grading** | OCR as a perception source feeding judgment | **Explored, 3 configurations** | **Speed-only, not a decider** (300ms, free, local) — negative alone, as a publish-early gate, and as primary-with-escalation. `runs/ocr_*`. Full design: `OCR_VALUE_ASSESSMENT_EXPERIMENT_DESIGN_2026_08_18.md` |
| **4. Hybrid observation reconciliation → separate criterion grading** | Owner-selected reading (2026-08-20): **design-doc option (d)** — EST-gated escalation, then confidence-gate the result before treating it as authoritative | **Run (this doc, zero new spend)** | **Marginal, near-neutral vs. gating alone — see §4.** Does not clear FAR |

**Note on arm 4's reading.** Two different things are called "hybrid" in the prior docs: (i) the
Phase D prompt's literal arm 4 (a *perception*-reconciliation stage before judgment), and (ii) the
production design doc's option (d) (escalate, then confidence-gate the *result*). The owner selected
(ii) for this pass (2026-08-20) — the cheaper reading that extends confirmed work; arm 2's result
(decomposed perception is strictly worse) already makes reading (i) the likely loser and it remains
untested. This is recorded so a later session doesn't mistake "arm 4 done" for "perception
reconciliation tested."

---

## 3. Model-backbone ablation (beyond D4's literal scope, same underlying question)

| Model | Verdict |
|---|---|
| `gpt-5.2` | **Selected** — clears F1, 100% structured-output reliability on the joint schema |
| `gpt-4o-mini` (`VISION_FAST_ESC`, prior candidate) | **Rejected** — fails all four DR-1 thresholds wide (23.0% exact / 84.5% F1 / 30.6% FAR / 20.5% FRR) |
| `gemini-3.1-pro-preview` | **Rejected on reliability, not quality** — highest raw perceptual quality (59.9% point-match) but 52% structured-output reliability on the simpler schema, 0/3 on the joint schema |

Standing constraint (`DRAWN_RESPONSE_ARCHITECTURE_REVIEW.md`): **no vendor lock before a held-out
bake-off.** `gpt-5.2`/`gpt-5.2-pro` is the current best-measured pairing, not a commitment.

---

## 4. Escalation-policy study, and arm 4 (option d) — the new result

Escalation was studied at three settings; the first two are already in the record, the third is
this document's contribution.

**(a) Blanket escalation (all medium-confidence → `gpt-5.2-pro`): tested at full scale, REJECTED.**
Whole-corpus F1 93.3%→91.0% (worse), FRR 8.0%→13.3% (worse); only FAR improves (19.0%→13.6%). The
21-photo pilot's clean win did **not** generalize — the effect is archetype-dependent (a real win on
EST, a large net loss on SER). This is the program's canonical small-sample-reversal case.

**(b) Archetype-gated escalation (EST only → `gpt-5.2-pro`): tested, CONFIRMED, recommended policy.**
Full 200-corpus: exact-match 38.5%→**41.5%**, F1 93.3%→**93.4%** (flat), FAR 19.0%→**13.6%** (real
win), FRR 8.0%→**9.0%** (near-flat). Reproduced from raw rows for this doc — matches the source doc.

**(c) Arm 4 = option (d): EST-gated escalation, THEN confidence-gate the result.** New re-analysis,
zero new spend (`analysis/arm4_gate_on_escalation.py`). Question: does gating on top of (b)'s output
give a better *authoritative slice* than gating the raw primary output (design-doc option (b))?

| Slice | Coverage | Exact | F1 | FAR | FRR |
|---|---:|---:|---:|---:|---:|
| Option (b) reference — gate **raw primary** at high-confidence | 47.5% (95/200) | 60.0% | 96.2% | **12.2%** | 4.1% |
| **Arm 4 / option (d)** — gate **post-escalation** at high-confidence | 49.5% (99/200) | 59.6% | 96.2% | **12.05%** | 4.1% |
| Arm 4 routed-to-human remainder | 50.5% (101/200) | 23.8% | 90.5% | 15.1% | 13.9% |

**Finding:** gating on top of escalation is **near-neutral versus gating alone** — identical F1 and
FRR, FAR essentially unchanged (12.05% vs 12.2%), at +2pp coverage (escalation promoted 4 more EST
responses to high-confidence, and they arrive at comparable quality). **Escalation and
confidence-gating are largely redundant levers on the auto slice, not complementary.** Neither the
hybrid nor the gate-alone auto slice clears the DR-1 FAR ceiling (≤2%) — both sit ~6× over it.
So even the best hybrid tested does **not** yield a launch-ready authoritative slice on this gold.

---

## 5. What D4's letter still requires and this evidence does NOT supply

This is a real gap, not a paperwork one:

1. **No pre-registered locked holdout (D4d).** Every number above was measured on a corpus that was
   also used for iteration. D4d requires opening a frozen 120-response holdout **once**, after
   methods/prompts/thresholds are frozen. That partition does not exist yet — it is blocked on D3's
   volume and reader-certification gaps (`D3_D4_D5_STATUS.md`).
2. **Gold tier.** `ai_provisional`, not dual-human/reader-certified. Same blocker.
3. **Arms 3 and 4(i) incomplete.** OCR was explored but never run as a full clean pipeline arm with
   the orientation-invariant axis-role fix in place; the prompt's literal arm-4 perception
   reconciliation was never run at all.
4. **Capture-defect discrimination not measured here.** D4b requires each arm to distinguish capture
   failure from graph failure on defect cases; the accuracy corpus is static offline photos and does
   not exercise that path.

---

## 6. Recommendation

- **Do not re-run arms 1–3 from scratch.** The joint-beats-decomposed conclusion is settled with a
  wide margin; reproducing it would spend money to re-derive a known answer.
- **Adopt EST-gated escalation (option b/§4b) as the working escalation policy** for any interim
  design, with the explicit caveat that it still fails FAR.
- **Treat arm 4 (option d) as answered and near-neutral** — do not build the added escalation+gate
  complexity expecting a FAR win it does not deliver; the FAR lever lives in gold/criterion
  adjudication (the `PLOT_VALUES`/`UNCERTAINTY_MARKS`/scale disagreements, most of which sit at the
  gold layer per blocker 7), not in more model routing.
- **The one genuine remaining D4 experiment is a real D4d locked-holdout pass** once D3 closes — and,
  optionally, the prompt's literal arm-4 perception reconciliation at that time (the only arm with
  zero evidence either way), though arm 2 predicts it loses.

**See also:** `ENGINE4_PRODUCTION_DESIGN_2026_08_18.md` (design synthesis, §1/§2),
`HAND_DRAWN_REAL_PHOTO_GRADING_ACCURACY_2026_08_18.md` (source evidence),
`ABSTENTION_CALIBRATION.md` (D5, the abstention/coverage companion to this bake-off),
`D3_D4_D5_STATUS.md` (the honest stage-by-stage reconciliation this doc implements for D4).
