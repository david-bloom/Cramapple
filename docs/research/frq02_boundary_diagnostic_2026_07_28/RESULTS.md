# FRQ02 Boundary Diagnostic — Compact Boundary Memory vs No Memory, All Four Criteria

**Date:** 2026-07-28
**Answers memo items #1 and #5** from `bio_reference_layer_next_planning_memo.md` (2026-06-18),
whose item #5 makes the C1/C3/C4 diagnostic a **precondition for any promotion decision**.
**Cost:** $0.2910 (800 calls). Corpus: 100 `use_as_ground_truth` answers × 4 criteria × 2 arms.

> **CORRECTED 2026-07-28.** The first version of this report concluded "compact boundary memory
> did not help on any criterion." **That was wrong on C2, and wrong because it scored against
> labels that `grader_speed_sp1_report.md` had already identified as defective.** The corrected
> analysis is below. The error is instructive and is retained rather than quietly replaced.

---

## 1. The correction, first

On C2 the raw result was 3 fixed / 3 broken, p = 1.00 — an apparent perfect null. Checking which
responses moved against the prior SP-1 investigation:

| | responses |
|---|---|
| **Fixed** by the boundary table | `S020`, `S021`, `S028` |
| **"Broken"** by it | `S054`, `S062`, `S070` |

Those are not two arbitrary sets of three.

- `S020`, `S021`, `S028` are **exactly SP-1's confirmed hard cases** — the ones the v2 boundary
  table was written to fix (`S021` "randomly destroyed", `S020`/`S028` the misattachment shape).
- `S054`, `S062`, `S070` are **all three in SP-1's documented label-noise cluster**: responses
  labelled `earned` in the provisional corpus while using phrasing "nearly identical to the
  confirmed-`not_earned` `S068`". SP-1 stated plainly that crediting them "would reopen the
  original over-credit hole."

**The boundary table did not break those three. It graded them correctly and the gold is wrong.**

| FRQ02-C2 | n | no_memory | boundary_memory | delta | fixed / broken |
|---|---:|---:|---:|---:|---:|
| as-labelled | 99 | 80.8% | 80.8% | +0.0 pp | 3 / 3 |
| **excluding the 5 known label defects** | 94 | 81.9% | **85.1%** | **+3.2 pp** | **3 / 0** |

p = 0.25 on 3 discordant pairs — not significant, but **zero regressions** and every fix landing
on a pre-identified target. That is a coherent mechanism, not noise.

**Compact boundary memory works on C2.** My first reading inverted this by treating a known-bad
corpus as ground truth.

## 2. Headroom check (run first, per Lesson 22)

| | |
|---|---:|
| `no_memory` baseline agreement | 93.5% (26 errors / 400) |
| Gate set before the run | >92% ⇒ underpowered |

The gate tripped for the whole-rubric delta, which remains inconclusive (3 fixed / 7 broken,
p = 0.34). The C2 result above survives because it is mechanistically explained, not because it
is statistically powerful.

## 3. Per-criterion — what memo item #5 asked for

| criterion | boundary size | baseline errors | fixed | broken | reading |
|---|---:|---:|---:|---:|---|
| C1 | 303 ch | **1 / 99** | 0 | 0 | at ceiling; nothing to gain |
| **C2** | 2,067 ch | **19 / 99** | **3** | 3 (all label defects) | **boundary memory works** |
| C3 | 435 ch | 5 / 100 | 0 | 2 | near ceiling; boundary only hurt |
| C4 | 546 ch | 1 / 100 | 0 | 2 | at ceiling; boundary only hurt |

**C2 carries 19 of the 26 errors in the whole rubric — 73% of all error mass on one criterion.**
The memo's focus on C2 was correct, and the full-rubric context now confirms it was not an
artefact of only having looked there.

**On C1/C3/C4 the finding stands: boundary text produced 0 fixed and 4 broken.** These sit at
99%/95%/99% unaided. Authoring boundary tables for criteria already near ceiling is measurable
risk for no measurable return.

## 4. The corpus defect is now independently confirmed twice

SP-1 identified `S054`, `S058`, `S062`, `S070`, `S014` by reading answer text against reviewer
notes. Today a boundary table, applied blind, rejected three of them — and rejected *only* them.
Two independent methods, same five responses.

**Recommendation: fix the labels.** They are actively corrupting measurement — they made a real
+3.2 pp effect read as exactly zero, and any future C2 experiment will be distorted the same way
until they are corrected. This is Lesson 5 in its purest observed form.

## 5. Model dependence — the interaction the memo's suite treats as separable

FRQ02-C2 strict agreement across every arm now measured:

| model | boundary | agreement | source |
|---|---|---:|---|
| `gpt-5.5` medium | **none** | 67.5% | SP-1 `BM-Control` |
| `gpt-4o-mini` | v1 | 60.0% | SP-1 |
| `gpt-4o-mini` | **v2** | 77.5% | SP-1 |
| `gemini-2.5-flash` | **none** | **80.8%** | today |
| `gemini-2.5-flash` | v2 | 80.8% (85.1% on clean labels) | today |

**Caveat, and it is not small:** SP-1 used a deliberately enriched n=40 stratified sample
including all 5 named ambiguity-cluster responses; today used the full n=100. SP-1's sample is
harder, so these numbers are not directly comparable and the table should be read as suggestive.

Read with that caveat, the pattern is still striking: **`gemini-2.5-flash` with no boundary
memory at all is at or above `gpt-4o-mini` with the boundary table, and well above `gpt-5.5`
without it.** Boundary tables encode calibration that a stronger model may already carry.

**This makes memo items #1 and #2/#4 non-separable.** "Does boundary memory help?" has no
model-independent answer; the right experiment is the 2×2 of {model} × {boundary on/off} on one
fixed sample. Neither run so far is that.

## 6. Speed — a real lever, unchanged by the correction

| | p50 | p90 | input tok | output tok |
|---|---:|---:|---:|---:|
| this run (4-field schema) | **1,073 ms** | 1,442 ms | 286 | **100** |
| Phase C Arm A (9-field schema) | 1,428 ms | 2,188 ms | — | — |

Same model, provider, and architecture. The differences are a leaner output schema (4 fields vs
9 — this run drops `improved_answer`, `minimum_fix`, `error_classification`,
`gate_schema_status`) and a shorter prompt. **p50 ≈ 1,073 ms, essentially at the 1,000 ms
aspiration**, with no architectural change. `improved_answer` in particular asks the model to
compose prose no grading decision depends on.

Boundary memory cost +64% prompt (1,309 → 2,149 ch) for +4.5% p90 — a real but modest price,
now known to buy a real gain on the one criterion that needs it.

## 7. Revised recommendations

1. **Fix the five C2 labels** (`S054`, `S058`, `S062`, `S070`, `S014`) before any further C2
   experiment. Two independent methods now agree they are wrong, and they invert results.
2. **Run the {model} × {boundary} 2×2 on one fixed sample.** Memo items #1, #2 and #4 are one
   experiment, not three. Include `gpt-4o-mini` (SP-1's fast primary), `gemini-2.5-flash`, and
   Production's `gpt-4.1-mini` — which has never been evaluated on any corpus.
3. **Strip decision-irrelevant output fields** from the grading schema — ~355 ms of p50, the
   cheapest speed win identified.
4. **Do the Arm A conversion** in Production (one call per item → parallel per criterion),
   ≈0.58 s + 3.89 s × n_criteria today; ~16 s → ~4 s on a 4-criterion FRQ.
5. **Author boundary tables only for criteria below ~95%.** C1/C3/C4 show 0 fixed / 4 broken.
   Boundary effort should be targeted by measured error mass, not applied uniformly.

## 8. Process note

The first version of this report reached the opposite conclusion because it scored a new run
against a corpus whose defects were already documented in `grader_speed_sp1_report.md`. Reading
the prior investigation before interpreting the result would have caught it immediately. The
standing rule this implies: **before interpreting a disagreement between grader and gold on a
corpus with prior investigation, check whether that disagreement is already a known label
defect.**
