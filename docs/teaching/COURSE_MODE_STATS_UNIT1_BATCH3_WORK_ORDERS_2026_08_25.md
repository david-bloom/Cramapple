# Course Mode — AP Statistics Unit 1, Batch 3 Work Orders

STATUS: work orders (hand to Codex) | DATE: 2026-08-25 | AUDIENCE: David (orchestrator) + the coding agents assigned each cell.

Third authoring batch for the Course Mode / Stats Unit 1 pilot. **Four MCQ-conceptual slot-frames** — the
remaining pilot cells not covered by Batch 2. With these done, all 10 pilot cells
(`COURSE_MODE_STATS_UNIT1_PILOT_PLAN_2026_08_24.md` §4) are scoped:

- **Done, merged:** `1.7×3.B` (`gen_summary_stats`), `1.9×4.B` (`FB-4B-COMPARE-01`).
- **On a branch (needs merge + §11.1 prose fix):** `1.11×2.A`.
- **Batch 2 (in flight):** `1.9×3.B` (computational), `1.2×2.A`, `1.6×4.A`.
- **Batch 3 (this doc):** `1.5×3.A`, `1.8×3.A`, `1.12×2.A`, `1.13×2.A`.

**Every agent MUST follow** `docs/teaching/COURSE_MODE_CONTENT_CREATION_PROTOCOL_2026_08_24.md`, and **MUST
read its §11 (authoring quality lessons) before authoring**. One cell, one agent, one branch, one worktree.
**No loader run, no DB write, no release, no serving switch, Prod untouched** — release stays David's, gated
on D8 SME review → CM-D19.

All four are **skill 2.A / 3.A served as MCQ choice-match** (`rubric_type='mcq'`); 3.A "represent" is served
as **read/choose a representation**, never open construction (no drawing grader in the pilot). Follow the
`1.9×4.B` and `1.2×2.A` frames as the pattern. Register in **all four places** (protocol §3): frame in
`slot_frames.py`; `COMPUTATIONAL_PREFIXES` is N/A for Track B, but the frame's `package_id` prefix and
`FRAMING` entry in `scenarios.py` are required; new cell-namespaced `u1_*__` tags in `misconceptions.py`
(append-only, each USED by ≥1 distractor, each citing a source). **Gates (§5, all mandatory):** frame
harness ≥100 instances / 0 rejects + meta-tests green; **Gate-2 independent re-derivation of the key AND
every distractor**; CED conformance (correct skill); realistic per-context distractors (§11.2). **DoD (§7):**
own branch; passing property report; committed re-derivation record; no loader/DB/release/serving/Prod.

---

## Work order 1 — `1.5×3.A` (Track B, conceptual)

- **Cell:** 1.5×3.A — "Graphical Representations of One Quantitative Variable" × skill 3.A (represent)
- **Difficulty:** Easy–Medium · **Serving:** MCQ choice-match · **Branch:** `content/course-mode-stats-1.5-3a`

**Task design**
- Give a small quantitative data set (or a compact textual description of one) and ask which
  dotplot / stemplot / histogram **correctly represents** it, or ask the student to **read a value**
  (frequency in a bin, a count above/below a cutoff) from a described plot.
- Keep the "graph" describable in words/numbers (bin counts, stems) so no rendered image is needed.
- Vary surface via ≥5 contexts and varied data sets ("changed surface").

**Distractors** (`u1_5__` tags, append-only, cited):
- `u1_5__miscounted_bin_frequency` — off-by-one / wrong bin when reading a frequency.
- `u1_5__stem_leaf_place_value_error` — misreads stem-and-leaf place value (e.g. 3|2 read as 32 vs 3.2).
- `u1_5__wrong_plot_type_for_data` — picks a representation invalid for the data type (e.g. bar chart for
  quantitative, or a plot that loses the individual values when the item requires them).

---

## Work order 2 — `1.8×3.A` (Track B, conceptual)

- **Cell:** 1.8×3.A — "Graphical Representations of Summary Statistics" × skill 3.A (represent)
- **Difficulty:** Medium · **Serving:** MCQ choice-match · **Branch:** `content/course-mode-stats-1.8-3a`

**Task design**
- Give a **five-number summary** (min, Q1, median, Q3, max) and ask which **boxplot** matches, or the
  inverse: given a described boxplot, ask which five-number summary it encodes. Where natural, include a
  1.5×IQR outlier so the whisker-vs-fence distinction is tested.
- Describe boxplots in words/numbers (positions of the five marks) — no rendered image needed.
- Vary surface via ≥5 contexts and varied summaries.

**Distractors** (`u1_8__` tags):
- `u1_8__quartile_median_positions_swapped` — box edges / median placed at the wrong summary values.
- `u1_8__whisker_to_extreme_ignores_outlier` — extends a whisker to min/max when an outlier should sit
  beyond the fence (or vice versa).
- `u1_8__box_spans_range_not_iqr` — draws the box across the full range instead of Q1–Q3.

---

## Work order 3 — `1.12×2.A` (Track B, conceptual)

- **Cell:** 1.12×2.A — "Potential Problems with Sampling" × skill 2.A (describe/identify)
- **Difficulty:** Medium · **Serving:** MCQ choice-match · **Branch:** `content/course-mode-stats-1.12-2a`

**Task design**
- Present a realistic sampling scenario and ask the student to **identify the type of bias** (undercoverage,
  nonresponse, voluntary-response, response/wording bias), or to identify what would reduce it.
- Vary surface via ≥5 distinct scenarios spanning the bias types.

**Distractors** (`u1_12__` tags):
- `u1_12__bias_type_confused` — names a different, plausible-but-wrong bias type for the scenario.
- `u1_12__sampling_vs_nonsampling_error` — attributes a bias to random sampling variability (larger n
  "fixes" it) rather than to the design flaw.
- `u1_12__no_bias_called_biased` — flags a sound design as biased (or the inverse: misses a real bias).

Note (§11.2): each bias-type distractor must be a believable misread of the SPECIFIC scenario — do not reuse
one generic distractor set across contexts.

---

## Work order 4 — `1.13×2.A` (Track B, conceptual)

- **Cell:** 1.13×2.A — "Introduction to Experimental Design" × skill 2.A (describe/identify)
- **Difficulty:** Medium · **Serving:** MCQ choice-match · **Branch:** `content/course-mode-stats-1.13-2a`

**Task design**
- Present an experiment (or observational study) and ask the student to **identify a design element or
  flaw**: confounding, the role of a control/placebo, randomization, or observational-vs-experimental.
- Vary surface via ≥5 scenarios covering the key ideas.

**Distractors** (`u1_13__` tags):
- `u1_13__confounding_vs_lurking_confused` — mislabels a confounding variable / cause-effect claim.
- `u1_13__control_blinding_randomization_confused` — swaps the purpose of control, blinding, or
  randomization.
- `u1_13__observational_treated_as_experiment` — claims causation from an observational design (or calls a
  true experiment observational).

---

## Orchestration (David)

- **Catalog integration (protocol §6):** these four agents append to `misconceptions.py` / `scenarios.py`
  concurrently (with Batch 2's three, if run together). On return, integrate the **catalog additions first**
  (append-only → trivial), then the frame files, then run the **full harness once over everything**
  (`python3 generator.py` + `python3 slot_frames.py`) — a green full sweep is the integration gate.
- **QA / review per branch** (same as Batch 2): harness re-run + **Gate-2 re-derivation** of key + every
  distractor + package-shape/regression checks, before D8 SME review.
- **Release stays gated:** loader → D8 SME review (David) → CM-D19, Dev-first, held for David's go.
