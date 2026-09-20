# Course Mode — AP Statistics Unit 1 Integration + Gate-2 Re-derivation Record

STATUS: verification record | DATE: 2026-08-25 | AUTHOR: integration session (LLM) |
AUDIENCE: David (pre-D8 SME review).

This records the **integration** of all seven Codex-authored Unit-1 content branches onto
the integration branch, and the **Gate-2 independent re-derivation** — the one check the
automated harness structurally cannot perform.

---

## 0. Why Gate-2 exists (the harness blind spot)

The property harness (`slot_frames.py` / `generator.py`) verifies, per instance:
exactly one correct option, four options, unique option **texts**, every distractor **tagged**
with a canonical misconception, every distractor cites a source, scenario framing present,
answer-position varies. What it **cannot** verify: that a distractor's *value* is actually the
number/description the transform named by its misconception tag would produce, and that the
*key* is correct. A distractor could be tagged `used_range_not_iqr` yet carry a value that is
neither the IQR answer nor the range answer — the harness would still pass it. Gate-2 closes
that gap by independent hand-recomputation of the key **and every distractor**.

---

## 1. Integration result

Four Batch-3 branches merged onto the Batch-2 integration tip (`e03c836`):
`content/course-mode-stats-{1.5-3a, 1.8-3a, 1.12-2a, 1.13-2a}`.

**Conflict nature.** All conflicts were (a) append-only catalog additions
(`misconceptions.py` CATALOG, `scenarios.py` FRAMING/context-banks) and (b) the Batch-3
branches' harness rewrites. The Batch-3 branches were authored **before** the Batch-2
FRAMES-registry refactor, so each re-wrote `property_report()` / `emit_samples()` / `generate()`
in the old per-frame style. Resolution: keep the **registry** spine (HEAD) and graft each
branch's builder functions + one `FRAMES` entry — the intended "append one entry, no harness
rewrite" contract. Catalog conflicts resolved by keeping both sides.

**Full harness sweep — GREEN:**

| Harness | Result |
|---|---|
| `generator.py` | PASS — 11 procedures, 880 instances, **0 rejects**, 0 meta-failures |
| `slot_frames.py` | ok:true — 8 frames, 960 instances, 9600 checks; answer position varies (0–3) on all |
| `scenarios.py` self-check | `self_check_problems: []`; 14 context banks present |
| `misconceptions.py` self-check | `validate_catalog: []` |
| `build_load_sql.py --check` | 34 packages, 0 problems |

---

## 2. Gate-2 re-derivation — per cell

Legend: key re-derived by hand; each distractor checked that its value/description equals the
transform its misconception tag names.

### Computational (numeric-entry, deterministic checks)

- **1.7×3.B `summary_stats`** — mean. seed 50001: Σ=412, n=9 → 45.7778 ✓. seed 50002: Σ=451,
  n=7 → 64.4286 ✓. Key = deterministic numeric check; re-derived correct.
- **1.9×3.B `compare_stats`** — median/mean/IQR difference, A−B. seed 90001: med(A)=58,
  med(B)=61 → −3 ✓. seed 90002: 51−39 → 12 ✓. seed 90003: 55−61 → −6 ✓. Group order and
  sign correct in all.

### MCQ slot-frames

- **1.5×3.A `graphs`** (FB-U1-5-3A-GRAPH-01). seed 15000: data {8,9,10,10,10,11,12,12,14,14,16,17}
  → bins 5–9:2, 10–14:8, 15–19:2 = correct histogram ✓. Distractors: `miscounted_bin_frequency`
  shifts one boundary count (1/9 vs 2/8) ✓; `wrong_plot_type_for_data` = bar chart of numeric
  data ✓; `stem_leaf_place_value_error` = whole value as stem, "0" leaf ✓. seed 15001 same
  pattern ✓.
- **1.8×3.A `boxplots`** (FB-U1-8-3A-BOXPLOT-01). seed 18000: min7 Q1 12 med15 Q3 19 max31,
  IQR=7, upper fence 29.5, max 31 → outlier; box 12–19, whiskers 7&25, outlier 31 = correct ✓.
  Distractors: `whisker_to_extreme_ignores_outlier` (whisker to 31, no outlier) ✓;
  `quartile_median_positions_swapped` (box 15–19, median at 12) ✓; `box_spans_range_not_iqr`
  (box 7–31) ✓. seed 18001 (IQR 10, fence 49, max 54 outlier) all match ✓.
- **1.12×2.A `bias`** (FB-U1-12-2A-BIAS-01). Open web poll → key `Voluntary-response bias` ✓;
  mailed-survey 94/600 → key `Nonresponse bias` ✓. Distractors embody `bias_type_confused`
  (nonresponse/undercoverage/SRS/voluntary mislabels) and `sampling_vs_nonsampling_error`
  (response-bias mislabel) ✓.
- **1.13×2.A `design`** (FB-U1-13-2A-DESIGN-01). Records existing habits → key `observational
  study` ✓; random assignment + inactive pill → key `placebo control` ✓. Distractors embody
  `observational_treated_as_experiment`, `control_blinding_randomization_confused`,
  `confounding_vs_lurking_confused` ✓.
- **1.2×2.A `variables`** (FB-U1-2-2A-VARIABLES-01). Jersey number → key `categorical /
  identifier` ✓. Distractors: `numeric_codes_called_quantitative` (×2 surfaces: continuous /
  discrete), `counts_or_ordinal_miscategorized` (ordinal) ✓.
- **1.6×4.A `distribution`** (FB-U1-6-4A-DISTRIBUTION-01). min10 Q1 20 med24 Q3 34 max52
  mean~29: IQR=14 ✓, mean>median → right-skew ✓, upper fence 55>max 52 → no outlier ✓.
  Distractors: `skew_direction_reversed` (left-skew), `ignores_shape_reports_center_only`
  (center/spread only), `outlier_from_range_not_fences` (max "far from min") ✓.
- **1.11×2.A `sampling`** (FB-U1-11-2A-SAMPLING-01). Cafeteria at lunch → key `convenience,
  not random` ✓. Distractors: `stratified_cluster_confusion`,
  `convenience_or_voluntary_called_random`, `stratified_samples_whole_groups` ✓.
- **1.9×4.B `compare/justify`** (FB-4B-COMPARE-01). Observational 48(SD14) vs 45(SD14),
  "always" claim → key affirms average diff, refuses "always" on overlap ✓. Distractors:
  `ignores_variability_claims_every_value`, `over_generalizes_beyond_data`,
  `association_implies_causation` ✓.

**Verdict: all keys correct; every distractor embodies its named misconception. No Gate-2
defects found.**

---

## 3. Notes for the SME (D8) review

- **Tag-namespace inconsistency (pre-existing, cosmetic).** The original 4.B frame (1.9×4.B)
  uses non-namespaced misconception tags (`ignores_variability_claims_every_value`, etc.); all
  Batch-2/3 cells use the `u1_X__` namespace convention. Both register cleanly (self-check
  passes); worth normalizing later, not a correctness issue.
- **1.2×2.A** intentionally reuses one misconception tag across two distractor surfaces
  (continuous vs discrete). This is allowed (uniqueness is enforced on option **text**, not
  tag) and both surfaces genuinely embody the same error.
- **Serving form (Decision C).** The computational cells carry BOTH mcq choices and numeric
  deterministic checks. Pilot serving form is numeric-entry (C1) per the release-path brief;
  the MCQ payload must not be served for these without the option→value mapping, or grading
  abstains.
- Nothing here is released. All instances remain `unreleased_generated_pending_review`;
  release is gated on **D8** (release bars — still ON HOLD) + **CM-D19** template release.
