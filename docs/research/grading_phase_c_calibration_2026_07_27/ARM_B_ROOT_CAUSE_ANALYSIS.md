# Arm B Root-Cause Analysis — Reparable Flaw or Dead End?

**Date:** 2026-07-27
**Question:** Arm B (single structured multi-criterion call) failed the Stage 5
low-number gate twice. Is that a reparable design flaw or should Arm B be
closed as a dead end?
**Verdict:** **Dead end as a latency architecture — but for one reason, not the
two previously reported.** One of the two reported failures was self-inflicted
by the v2 repair and is fully reparable; the other is structural and is not.

This analysis **corrects an error** in `stage5_v2_burned_run_record.md` (see
§4). Diagnostic cost: $0.01281.

---

## 1. Correcting the record: the v2 schema failure was my bug, not Arm B's

`stage5_v2_burned_run_record.md` reported Arm B v2's 85% schema-validity as an
Arm B architectural failure mode, and attributed the 3 failures to "three
long-form AP Physics C items with 10 criteria each." **Both claims are wrong.**

What actually failed:

| item | n_criteria | v2 token cap | latency at failure | implied tokens generated | % of cap |
|---|---:|---:|---:|---:|---:|
| `apchem-frq-l-003` | **4** | 820 | 3,826 ms | ~859 | **105%** |
| `apphycm-frq-037` | 10 | 1,780 | 6,715 ms | ~1,630 | 92% |
| `apphycm-frq-035` | 10 | 1,780 | 6,822 ms | ~1,659 | 93% |

- Only **two** of the three failures were 10-criterion items; the third was a
  **4-criterion** Chemistry item. The third 10-criterion Physics C item
  (`apphycem-frq-035`) **succeeded** (1,667 tokens against a 1,780 cap — 94%).
- All three ran to 92–105% of their token cap before dying. This is
  **truncation at the cap**, not a model or schema-adherence defect.
- The cap that truncated them was introduced by **my own v2 repair**
  (`min(180 + 160·n, 2200)`), replacing v1's flat 3,500. v1 had **100%**
  schema validity. I made this worse.

**Diagnostic probe (`raw/armb_uncapped_diagnostic.jsonl`):** rerunning exactly
those 3 items with a generous 4,000-token cap:

| item | n_criteria | criteria returned | output tokens | latency |
|---|---:|---:|---:|---:|
| `apchem-frq-l-003` | 4 | **4/4** | 856 | 3,808 ms |
| `apphycm-frq-037` | 10 | **10/10** | 1,681 | 6,565 ms |
| `apphycm-frq-035` | 10 | **10/10** | 1,795 | 6,984 ms |

**3/3 recovered, all criteria returned.** The schema failure is 100% reparable
by one line (raise the cap). It was never an Arm B property.

Also note a config-fidelity gap: `frozen_arm_manifest.json` declares
`retries_on_transient_failure: 1`, but the Stage 5 runner implemented no
retry. Since the failures were deterministic truncation rather than transient,
a retry would likely have reproduced them — but the run did not match its own
declared config, and the 85% figure should be read with that caveat.

## 2. The real, structural finding: Arm B's latency is linear in criterion count

From 36 successful Arm B calls across both runs, latency is a clean linear
function of output-token count, and output-tokens is linear in criterion count:

```
Arm B latency_ms ≈ 610 (TTFB) + 3.75 × output_tokens
Arm B output_tokens ≈ 170 × n_criteria      (post-brevity-repair)
⇒  Arm B latency_ms ≈ 610 + 637 × n_criteria
```

Measured generation rate: **267 tok/s**; mean TTFB **610 ms**. Predictions vs.
observations agree closely (n=4 predicted 3,158 ms, observed 3,010–3,971 ms;
n=10 predicted 6,980 ms, observed 6,565–7,028 ms).

**Arm A, by contrast, is flat in criterion count** — it is max-of-N parallel
calls, each ~1,437 ms (p50), so adding criteria widens the max-of-N draw
slightly but does not add serial generation time. Observed Arm A item p50:
1,685 ms (v1) and 1,712 ms (v2), against corpora whose mean criterion count
is 4.4.

| n_criteria | Arm B p50 (modelled) | Arm A p50 (flat) | winner |
|---:|---:|---:|---|
| 1 | ~1,247 ms | ~1,500 ms | Arm B |
| 2 | ~1,884 ms | ~1,500 ms | Arm A |
| 3 | ~2,521 ms | ~1,600 ms | Arm A |
| 4 | ~3,158 ms | ~1,700 ms | Arm A |
| 6 | ~4,432 ms | ~1,700 ms | Arm A |
| 10 | ~6,980 ms | ~1,700 ms | Arm A |

Arm B only wins at **n_criteria = 1**. In the frozen 100-item corpus,
**88 of 100 items have ≥2 criteria** (median 4, mean 4.4, up to 10). Arm B is
therefore dominated on latency for 88% of the corpus, and by ~4× at the tail.

**Why no repair fixes this:** the slope (637 ms per criterion) is the cost of
generating one criterion's feedback serially. The only lever is cutting
per-criterion output. To meet the 3,000 ms gate at the corpus median (n=4),
Arm B needs ≤ ~90 tokens/criterion for all five feedback fields combined
(evidence_quote, withheld_point_reason, minimum_fix, improved_answer, plus
enums) — roughly 15 words each. To meet the real 1,000 ms launch bar at n=4 it
needs ~26 tokens/criterion, i.e. ~20 words *total* per criterion. That does not
leave room for a grounded evidence quote plus a concrete minimum fix plus a
concise improved answer — the exact fields that constitute the product promise.
Cutting them to hit the number would win the benchmark by deleting the feature.

The brevity repair already did work — mean output dropped **239 → 170
tokens/criterion (−29%)**, and it still wasn't close. A further 3–6× cut is not
a tuning exercise; it is a different product.

## 3. Arm B's original motivation is empirically refuted

Arm B was proposed (per `frq02_label_audit_2026_07_27/RESULTS_REPEAT2_FINAL_GOLD_2026_07_27.md`)
to "reduce request fan-out and max-of-four tail latency." That premise assumed
individual criterion calls have a fat tail, making max-of-N much worse than one
call. On this model/corpus that tail does not materialize:

- Arm A per-call: p50 1,437 ms, p90 1,991 ms, max 3,179 ms — max/p50 = 2.2, no
  pathological outliers (unlike the 8–11 s escalation outliers that motivated
  the concern in the FRQ-02 work).
- Arm A item-level (max-of-N): p50 1,712 ms, p90 2,439 ms, max 3,532 ms.

With `gemini-2.5-flash` and thinking disabled, per-criterion calls are
reliably fast, so max-of-N costs little — while Arm B pays the full serial sum.
The fan-out concern was real for a slow, escalating, reasoning-heavy grader; it
does not apply to the fast grader that is actually the default.

## 4. What Arm B is still good at (do not discard the finding)

Two genuine Arm B advantages, both real but both subordinate to speed under
the standing priority order (Speed > Quality > Cost, DECISION per grader-
priority memo; the Stage 6 prompt orders Quality > Speed > Cost — Arm B does
not win either ordering on the binding constraint):

1. **Cost: ~2.4× cheaper.** Arm A re-sends the shared stem/stimulus/instructions
   once per criterion, spending **3.64× the input tokens** of Arm B
   (122,825 vs 33,788 across the same 20 items). Per-FRQ: Arm A **$0.0045**,
   Arm B **$0.0019**. Both are far under the $0.01 target and the $0.03
   ceiling, so this saves ~$0.0026/FRQ ≈ **$39 per 15,000 grades** — immaterial
   at beta scale, and explicitly not worth trading speed for.
2. **Criterion agreement was equal-or-better, twice.** Arm B 95.7% (v1) and
   91.2% (v2) vs Arm A 91.3% and 90.1%; pooled **93.4% (128/137) vs 90.6%
   (145/160)**, a +2.8 pp edge, directionally consistent across two independent
   slices. This is **not statistically significant at these n** and must not be
   reported as a finding — but it is a plausible mechanism worth recording:
   seeing all criteria in one context may reduce criterion-boundary confusion
   and cross-criterion contamination, which is precisely the failure class
   (C2/C4 leakage) that dominated the FRQ-02 errors. If a future run needs a
   quality lever rather than a speed lever, this is the hypothesis to test.

## 5. The larger finding: neither arm meets the actual launch bar

The 3,000 ms Stage 5 threshold is only a stop-loss. The real TASK-0016 launch
bar is **end-to-end p50 ≤ 1,000 ms (submit → feedback rendered)**. Decomposing
the measured budget:

- **Fixed provider TTFB alone: ~588 ms — 59% of the entire 1,000 ms budget**,
  before a single output token is generated.
- Remaining generation budget: ~412 ms ≈ **110 output tokens total** at the
  measured 267 tok/s.
- Current Arm A per-criterion output: **234 tokens — 2.1× over budget**, and
  that is for the *single fastest* criterion, excluding network to the student,
  auth, DB writes, and render.

**Arm A wins the comparison but also misses the launch bar**, and it does so
for a reason that has nothing to do with request architecture: TTFB plus
feedback verbosity already exceed 1,000 ms. This reproduces and sharpens the
prior FRQ-02 conclusion ("quality and cost are confirmed; the 1,000-ms speed
target is not") — and it means **the launch bar cannot be met by choosing
between these two arms.** It requires one or more of: a faster/closer-hosted
model or provider path, streaming partial feedback to the UI so *perceived*
time-to-first-feedback is TTFB-bound (~600 ms) rather than
completion-bound, deterministic-layer coverage far beyond today's 5 seeded
`content_key`s so many criteria return with no model call at all, or an
explicit Product Owner revision of the 1,000 ms figure.

That is a Phase F / launch-gate issue, not an Arm A vs Arm B issue, and it is
the most consequential thing this run measured.

## 6. Verdict

**Close Arm B as a dead end for its stated purpose (latency), with the reason
recorded precisely so it is not re-proposed:** its latency is linear in
criterion count where Arm A's is flat, so it is structurally dominated on 88%
of the corpus; the required verbosity cut to close the gap would delete the
criterion-feedback fields that are the product's core promise; and its
original max-of-N-tail motivation is refuted for the fast default grader.

**Do not record the truncation as Arm B's failure** — that was an artifact of
the v2 repair, is fixed by one line, and was verified fixed.

**Retain Arm B's cost and cross-criterion-quality results as live hypotheses**
for any future run where cost or criterion-boundary quality, not speed, is the
binding constraint.

**Escalate the launch-bar finding (§5) as the real blocker** — it outranks the
architecture question and is not resolved by this run.
