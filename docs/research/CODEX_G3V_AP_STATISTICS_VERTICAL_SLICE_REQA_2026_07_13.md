# Codex G3V Re-QA — AP Statistics 2026-27 Vertical Slice

**Status:** Proposed QA finding — one rubric remediation remains
**Date:** 2026-07-13
**Commit reviewed:** `31e1967` (slice remediation introduced at `a478f7e`)
**Source:** `docs/research/ap_statistics_2027_vertical_slice_2026_07_13.md`
**Environment impact:** None; committed-document review only

## Proposed verdict

**FAIL — 9 PASS / 1 FAIL across 10 logical review units.** Q1 and Q3 now clear their prior blocking findings. Q4's statistical work is correct, but its revised prompt introduces a p-value computation that no criterion actually requires, leaving a task-verb↔criterion mismatch. Bulk generation remains gated pending that narrow repair and confirmation.

## Remediated-item review

### Q1 — PASS

- Branch P's target population is now explicitly all registered members.
- Every member on the list is reached and every member responds, so “census” is unambiguous.
- Point 1, its non-earning boundary, and minimum-fix text match the revised stimulus.
- The shape language remains appropriately hedged as “likely.”
- The original numeric checks remain correct: Zone 1 outer spreads are 22 vs 6; Zone 2 outer spreads are 14 vs 5.

### Q3 — PASS

- The sample is explicitly independently random from a run of more than 10,000 bottles.
- `36 ≤ 0.10(10,000)=1,000`, so the 10% condition can now be verified rather than presumed.
- Independent recomputation: `SE=9/√36=1.5`; `t=(496.5−500)/1.5=−2.333333`; `df=35`; two-sided `p=0.0255024`; reject at `α=.05`.
- Point 8 now applies ECF to the learner's own computed test statistic/p-value, resolving the calculation→decision dependency.
- Non-blocking cleanup: extend the same explicit ECF wording to Point 9 so the contextual conclusion is judged consistently with the learner's earned decision.

### Q4 — FAIL (rubric validity only)

The revised inference is correct:

- population exceeds 5,000 monthly orders and the sample is independently random;
- `250 ≤ 0.10(5,000)=500`, so the 10% condition is verified;
- distribution sum = 1; `P(X≥3)=.50`; `E(X)=2.60`;
- `p0=P(X≥4)=.25`; `p̂=68/250=.272`;
- `SE=√(.25·.75/250)=.0273861`;
- `z=(.272−.25)/.0273861=.803326`;
- two-sided `p=.421786`; `.421786>.05`, so fail to reject; and
- large counts are 62.5 and 187.5.

However, Part C(iii) now asks students to “compute the standardized statistic **and its two-sided p-value**.” Point 6 awards only `z≈.80`. Point 7 awards an ECF-consistent decision, and Point 8 awards a general justification referencing z/probability. A learner can therefore omit or incorrectly compute the p-value without losing the point assigned to C(iii). The newly added task verb is not represented by an earning boundary.

Required fix:

1. Revise Point 6 to require both `z≈.80` and the two-sided `p≈.42`, with explicit partial/ECF treatment if desired; and
2. revise Point 8's earning and minimum-fix language to require the comparison `p≈.42 > α=.05` while keeping Point 7's decision ECF based on the learner's own p-value.

## Other checks

- Inventory is correctly stated as 10 review units / 12 atomic questions.
- No removed topic is tested.
- All original MCQs and Q2 remain passing; no remediation changed their numeric content.
- Q2's ECF wording should eventually refer to the learner's own center/spread work for both brands, not only “Point 1/4 values,” but this is non-blocking.

## Gate disposition

G3V remains uncleared solely for the Q4 p-value rubric boundary. After the two-line criterion repair, a focused confirmation of Q4 is sufficient; Q1 and Q3 do not require another content rewrite.
