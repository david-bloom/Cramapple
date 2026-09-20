# Codex Prompt — Course Mode Pilot Content: AP Statistics Units 1–3

STATUS: orchestration prompt (hand to Codex) | DATE: 2026-08-26 | AUDIENCE: David
(orchestrator) → Codex agents (one cell, one agent, one branch, one worktree).

> Paste the block below into Codex. It is self-contained; everything it cites
> lives in `david-bloom/cramapple`.

---

You are authoring Course Mode practice content for the Cramapple AP Statistics
pilot, extending the shipped Unit-1 set to cover **all of Units 1, 2, and 3**
of the repo's taxonomy. The generator, harness, protocol, and release gates all
exist — your job is new cells, not new machinery.

## Read first (in this order)

1. `docs/teaching/COURSE_MODE_CONTENT_CREATION_PROTOCOL_2026_08_24.md` — the
   binding protocol; **read its §11 authoring-quality lessons before writing a
   line of content**.
2. `scripts/course_mode_stats_generator/README.md` — the authoring protocol for
   procedures, and the harness's documented **blind spots** (it checks that a
   distractor is tagged, on-scale, and distinct — it does NOT check that a
   distractor's value equals its named misconception's transform, nor that the
   key is right; that is Gate-2's job, by hand).
3. `docs/teaching/COURSE_MODE_STATS_UNIT1_BATCH3_WORK_ORDERS_2026_08_25.md` —
   the work-order pattern these batches follow.
4. `docs/teaching/COURSE_MODE_PILOT_MERGE_RESOLUTION_2026_08_26.md` — the
   registry-spine merge playbook. The Batch-3 merges scrambled shared
   dispatchers once; do not repeat it.

## The taxonomy (authoritative — repo taxonomy, NOT the CED's 9-unit numbering)

Source version `dae3c72e-82ca-4960-9552-1b034bd347e5`:
- **Unit 1 — Exploring One-Variable Data and Collecting Data** (topics 1.1–1.13).
  Ten cells are DONE (1.2×2.A, 1.5×3.A, 1.6×4.A, 1.7×3.B, 1.8×3.A, 1.9×3.B,
  1.9×4.B, 1.11×2.A, 1.12×2.A, 1.13×2.A).
- **Unit 2 — Probability, Random Variables, and Probability Distributions**
  (2.1 two-cat representations, 2.2 two-cat summary stats, 2.3 simulation,
  2.4 intro probability, 2.5 mutually exclusive, 2.6 conditional, 2.7
  independence/unions, 2.8 random variables, 2.9 RV parameters, 2.10 binomial,
  2.11 normal, 2.12 sampling distributions/CLT).
- **Unit 3 — Inference for Categorical Data: Proportions** (3.1 estimators,
  3.2 sampling dist of p̂, 3.3 one-prop CI, 3.4 justify from CI, 3.5 test
  setup, 3.6 p-values, 3.7 carry out test, 3.8 errors, 3.9 sampling dist of
  difference, 3.10 two-prop CI, 3.11 justify two-prop CI, 3.12 two-prop test
  setup, 3.13 carry out two-prop test, 3.14 chi-square setup, 3.15 carry out
  chi-square).

## Phase 0 — cell slate (STOP for David's sign-off before authoring)

Propose the target cell list (topic × CED skill code) with a one-line value
rationale per cell, then STOP for David's approval. Start from this draft
slate and adjust only with stated reasons:

- **Unit 1 completion (2 cells):** 1.3×2.B (tabular/summary stats, one
  categorical — compute proportions), 1.4×2.A (categorical graph reading).
  Skip 1.1 and 1.10 (framing topics, weak MCQ value) unless David objects.
- **Unit 2 (10 cells):** 2.1×2.A (read two-way representations), 2.2×3.B
  (marginal/conditional proportions — computational), 2.4×3.B (basic
  probability rules), 2.5×2.A (mutually exclusive vs independent — identify),
  2.6×3.B (conditional probability — computational), 2.7×3.B
  (independence/unions — computational), 2.8×2.A (identify RVs/distributions),
  2.9×3.B (mean/SD of an RV — computational), 2.10×3.B (binomial —
  computational), 2.11×3.B (normal areas/z — computational), 2.12×2.A
  (sampling distributions/CLT behavior — conceptual). Trim to 10 by value.
- **Unit 3 (10 cells):** 3.2×2.A (conditions/shape of p̂'s distribution),
  3.3×3.B (one-prop CI — computational), 3.4×4.B (justify a claim from a CI),
  3.5×2.A (hypotheses/conditions setup), 3.6×2.A (p-value meaning), 3.7×3.B
  (carry out one-prop test — computational), 3.8×2.A (Type I/II errors,
  consequences), 3.10×3.B (two-prop CI — computational), 3.13×3.B (two-prop
  test — computational), 3.14×2.A (chi-square setup: expected counts,
  hypotheses).

Verify every proposed skill code against the CED conformance rules the Unit-1
cells used (2.A describe/identify, 3.A represent-as-reading, 3.B calculate,
4.A/4.B interpret/compare). 3.A-style cells are served as **read/choose a
representation**, never open construction.

## Authoring rules (all mandatory, per cell)

- **Track A (computational, 3.B):** a `statlib`-grounded procedure in
  `generator.py` + registration in `COMPUTATIONAL_PREFIXES` in
  `build_load_sql.py`. **Track B (conceptual):** a slot-frame in
  `slot_frames.py` with a `FRAMING` entry in `scenarios.py`. Both: follow the
  existing FRAMES-registry spine — graft, never rewrite shared dispatchers.
- **Misconception-encoded distractors:** new cell-namespaced tags
  (`u2_6__…`, `u3_7__…`) in `misconceptions.py` — append-only, each tag used
  by ≥1 distractor, each citing a source. Every distractor's VALUE must equal
  its named misconception's transform — hand-verify; the harness cannot.
- **4 choices, exactly 1 correct; answer position varies.** Stems embed the
  A–D options (the stem↔choices sync gate enforces this).
- **≥5 realistic contexts per cell with credible value envelopes** (the
  scenario-credibility SME lesson: numbers must be plausible for the context —
  no 40-point IQR on a 10-question quiz).
- **Serving is MCQ choice-match for every new cell** (`rubric_type='mcq'`,
  stamped by the loader — already Fix-1 compliant). Where a computational cell
  is a natural numeric-entry candidate, note it in the work order for David;
  do not build numeric-entry serving.
- **Content keys mirror Unit 1 exactly:** `apstat-u2-<t>-<s><letter>-<proc>-NNNNNN`
  (e.g. `apstat-u2-6-3b-cond_prob-206000`), `apstat-u3-…` likewise. The
  frontend derives the cell from this prefix; do not invent a new shape.
  (Known coordinated follow-up, NOT yours: the client's
  `pilotCellFromContentKey` currently parses only `apstat-u1-…` — the frontend
  team extends it when these units ship.)
- **Confirm-transfer compatibility:** every cell yields ≥2 interchangeable
  same-cell items (trivially true at 20/cell) so the same-cell transfer
  selector always has a parallel item.

## Gates (D8 bars, ratified — every cell)

1. Property harness: **≥100 instances/procedure and ≥120/frame at 0 rejects**,
   full context/tag coverage, meta-tests green.
2. **Gate-2 independent re-derivation:** hand-recompute the key AND every
   distractor for the 20-instance validation sample; commit a re-derivation
   record (`docs/teaching/COURSE_MODE_STATS_<cell>_REDERIVATION_RECORD_<date>.md`
   pattern). 0 defects or fix and re-run.
3. Emit the **deterministic 20-instance sample per template** for David's D8
   SME review (the review pack pattern:
   `COURSE_MODE_STATS_UNIT1_D8_REVIEW_PACK_2026_08_25.md`).
4. `build_load_sql.py --check` green over the new cells; regenerate
   `out/*_DRAFT.sql` (DRAFT only).
5. Gold-regression: existing cells' emitted output byte-stable (0 drift).

## Batching & branches

One cell = one agent = one branch (`content/course-mode-stats-<topic>-<skill>`)
= one worktree. Batch ~4 cells at a time; integrate on an integration branch
keeping the registry spine and keep-both on the append-only catalogs (de-dupe
doubled keys, re-close FRAMING delimiters — see the merge playbook). Unit 1
completion first, then Unit 2, then Unit 3 (Unit 3's test/CI procedures may
author by analogy to the existing one-sample/two-sample t procedures — the
same review caught garbled distractor formulas there; §11 applies doubly).

## Hard boundaries (never)

- **Code-only.** No loader run against ANY database, no publish, no release
  (`cm_d19_release_template` is David-gated on his D8 SME sign-off), no
  serving switch, no edge-function deploy, nothing on Dev or Prod.
- No edits to the engine, grader, router, or frontend.
- No new dependencies; no rewriting shared generator dispatchers.

## Definition of done (per cell)

Own branch; harness report committed and green at the bars above; Gate-2
re-derivation record committed; 20-sample SME emission committed; loader
`--check` green; no DB/release/serving/Prod touches. Final deliverable per
batch: a short work-order-style summary (cells, branches, harness numbers,
open flags) for David's review.
