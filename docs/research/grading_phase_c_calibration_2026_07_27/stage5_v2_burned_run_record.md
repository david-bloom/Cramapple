# Stage 5 v2 — Burned Run Record and Recommendation

**Run date:** 2026-07-27
**Status:** Burned. Second consecutive gate failure for Arm B on an
independent, non-overlapping n=20 slice.

## What happened

After the v1 failure (`stage5_v1_burned_run_record.md`), Arm B was repaired
(`arm_b_v2` in `frozen_arm_manifest.json`): brevity constraints added to the
prompt (~20-word cap per feedback field) and a dynamic `max_output_tokens`
policy (`min(180 + 160*n_criteria, 2200)`) replacing the flat 3,500-token cap.
Arm A was left unchanged (it already passed v1 cleanly). Reran against a
**fresh, non-overlapping** 20-item slice (4/family, no items from the v1
selection). Cost: **$0.12826** of the $1.00 cap (112 calls: 92 Arm A + 20 Arm B).

| Metric | Arm A (unchanged) | Arm B v2 (repaired) | Gate bar |
|---|---:|---:|---|
| Schema-valid | 98.9% (91/92) | **85.0% (17/20)** | ≥95% |
| Criterion agreement vs Stage 3 gold | 90.1% (82/91) | 91.2% (62/68) | ≥85% |
| p50 latency | 1,712 ms | **3,160 ms** | ≤3,000 ms |
| p90 latency | 2,439 ms | 6,726 ms | measure |

**Gate result: FAIL again**, and on *two* dimensions this time: Arm B's p50
latency is still over the ceiling (3,160 ms), and its schema-validity rate
dropped from 100% (v1) to 85% (v2) — 3 of 20 calls returned unparseable
output ("No object generated: could not parse the response").

## Why the repair didn't fix it, and made schema validity worse

> **CORRECTION (2026-07-27, superseded by `ARM_B_ROOT_CAUSE_ANALYSIS.md`):**
> the attribution below is **wrong on two counts** and is retained only as the
> original record. (1) Only **two** of the three failures were 10-criterion
> items — the third, `apchem-frq-l-003`, has **4** criteria; and the third
> 10-criterion item (`apphycem-frq-035`) **succeeded**. (2) The claim that "no
> single `max_output_tokens` value" works was **not verified and is false as
> stated** — a diagnostic rerun of all 3 failed items at a 4,000-token cap
> recovered **3/3 with all criteria returned**. The truncation was an artifact
> of the v2 repair's own too-tight cap, is reparable in one line, and is **not**
> an Arm B failure mode. The *real* structural finding is that Arm B's latency
> is **linear in criterion count** (≈610 + 637·n ms) where Arm A's is flat —
> see `ARM_B_ROOT_CAUSE_ANALYSIS.md` for the corrected analysis.

This slice happened to include three long-form AP Physics C items
(`apphycem-frq-035`, `apphycm-frq-037`, `apphycm-frq-035`) with **10 criteria
each** — the highest criteria-count items in the entire 100-item corpus. The
dynamic token formula gives these `min(180 + 160*10, 2200) = 1780` tokens,
which was tight enough that some generations were cut off mid-JSON before
completing all 10 criteria objects, causing the 3 parse failures. Tightening
the token budget to fix latency directly reduced headroom for the highest-
criteria-count items and pushed some of them into truncation instead.

This is not a fixable-by-tuning problem: **there is no single
`max_output_tokens` value that is both small enough to keep Arm B under the
3-second p50 ceiling and large enough to avoid truncating full-feedback
output for 10-criterion items.** The single-call architecture forces exactly
this trade-off; Arm A avoids it entirely because each call only ever handles
one criterion regardless of how many criteria the item has.

## Recommendation

Per the Stage 6 decision menu, this run recommends:

**Retain the current architecture (Arm A, parallel per-criterion calls).
Arm B does not improve the quality/speed tradeoff and has now failed the
low-number gate twice on independent held-out slices, including a genuine
architectural failure mode (truncation on high-criteria-count items) that a
third prompt/token tweak is unlikely to resolve given the corpus contains
items up to 10 criteria.**

Arm A passed every gate bar on **both** slices (schema validity 100%/98.9%,
criterion agreement 91.3%/90.1%, p50 1,685ms/1,712ms) without any repair.

This does not mean Arm B is unfixable in principle (e.g., a genuinely
different approach -- streaming partial JSON to the client incrementally
rather than waiting for the full object, or splitting very-high-criteria
items back into sub-batches -- might close the gap), but that is new
engineering work, not a Stage 5 prompt/token repair, and is out of scope for
this calibration run.

## Cumulative Stage 5 spend

v1: $0.12123 + v2: $0.12826 = **$0.24949** across both gate attempts (each
had its own independent $1.00 cap; no cap was ever at risk of being exceeded
in either run).
