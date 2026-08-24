# Course Mode — AP Statistics Unit 1, Batch 2 Work Orders

STATUS: work orders (hand to Codex) | DATE: 2026-08-24 | AUDIENCE: David (orchestrator) + the coding agents assigned each cell.

Second authoring batch for the Course Mode / Stats Unit 1 pilot. Three cells, deliberately mixed in
shape to de-risk the paths the first cell (`1.11×2.A`) did not touch: one **new Track A computational**
procedure, plus two **Track B conceptual** slot-frames. Running three agents concurrently is also the
first real test of the multi-agent catalog-integration step (protocol §6).

**Every agent MUST follow** `docs/teaching/COURSE_MODE_CONTENT_CREATION_PROTOCOL_2026_08_24.md`, and
**MUST read its §11 (authoring quality lessons) before authoring** — those are the concrete rules the
automated harness does not enforce, learned from the `1.11×2.A` review. One cell, one agent, one branch,
one worktree. No loader run, no DB write, no release, no serving switch, Prod untouched.

Cell/difficulty source of truth: `COURSE_MODE_STATS_UNIT1_PILOT_PLAN_2026_08_24.md` §4.

---

## Work order 1 — `1.9×3.B` (Track A, computational)

- **Cell:** 1.9×3.B — "Comparisons of the Distributions for One Quantitative Variable" × skill 3.B (calculate)
- **Track:** A — new computational procedure in `scripts/course_mode_stats_generator/generator.py`
- **Difficulty:** Medium
- **Serving/grading:** numeric-entry (deterministic; single parseable number)
- **Branch:** `content/course-mode-stats-1.9-3b` (from latest `main`, own worktree)

**Task design**
- Present TWO one-variable quantitative data sets (Group A, Group B) in a realistic context.
- Ask for ONE specific comparison statistic, reported as **A − B**, so the answer is a single number:
  randomly pick the asked statistic among {difference in medians, difference in IQRs, difference in
  means}. State it unambiguously in the stem ("Calculate Group A's median minus Group B's median.").
- Compute the key with `statlib` (`five_number_summary` / `iqr` / `sample_mean`). Use `tol` consistent
  with the 2-dp display (see `gen_summary_stats`: `tol=0.01`).

**Distractors** (each a documented, cited misconception; hand-re-derive every value per Gate 2):
- `u1_9__used_mean_not_median` (or the inverse) — computed the wrong center/spread statistic.
- `u1_9__used_range_not_iqr` — range instead of IQR when IQR was asked.
- `u1_9__sign_reversed_difference` — B − A instead of A − B.
- `u1_9__reported_single_group_stat` — computed one group's statistic, forgot to subtract.

**Register in ALL FOUR places (§3):** `gen_` fn + `PROCEDURES` dict; `COMPUTATIONAL_PREFIXES` in
`build_load_sql.py`; a `scenarios.py` framing; new `u1_9__` misconception tags (append-only, namespaced).

**Gates (§5, all mandatory):** property harness ≥100/0 + meta-tests green; Gate 2 independent
re-derivation of the key AND every distractor; CED conformance (fact pack, skill 3.B); realistic
distractors (§11.2 — each tempting for the specific numbers drawn, and clear of the key by >2–3× tol).
**DoD (§7):** own branch; passing property report; committed re-derivation record; no loader/DB/release/serving/Prod.

---

## Work order 2 — `1.2×2.A` (Track B, conceptual)

- **Cell:** 1.2×2.A — "Variables" × skill 2.A (describe/identify)
- **Track:** B — authored slot-frame in `scripts/course_mode_stats_generator/slot_frames.py`
- **Difficulty:** Easy–Medium
- **Serving/grading:** MCQ choice-match
- **Branch:** `content/course-mode-stats-1.2-2a` (from latest `main`, own worktree)

Follow the `1.9×4.B` and `1.11×2.A` frames as patterns. **Read §11 first** — especially §11.1 (write the
variable/measure slots as clean noun phrases, no dangling pronouns; read three rendered instances aloud)
and §11.2 (per-context distractor plausibility).

**Task design**
- Present a variable in a realistic study context and ask the student to classify it: categorical vs
  quantitative (and, where natural, discrete vs continuous quantitative).
- Vary the surface via a scenario pool deep enough for genuinely different instances (aim ≥5 contexts ×
  several variables each — the "changed surface" requirement).

**Distractors** (documented, cited; cell-namespaced `u1_2__` tags, append-only):
- `u1_2__numeric_codes_called_quantitative` — a categorical variable stored as numbers (zip code, jersey
  number, 1=yes/0=no) misread as quantitative.
- `u1_2__counts_or_ordinal_miscategorized` — an ordinal/label treated as the wrong type.
- `u1_2__quantitative_called_categorical` — a genuine measurement misread as categorical because it has
  few distinct values.

Confirm each distractor is a believable error for the SPECIFIC variable shown (§11.2), and tag names
match the misconception's direction (§11.3).

**Gates (§5):** frame harness ≥100/0 + meta-tests; Gate 2 independent re-derivation of key + every
distractor; CED conformance (skill 2.A); realistic distractors. **DoD (§7):** own branch; passing report;
re-derivation record; no loader/DB/release/serving/Prod.

---

## Work order 3 — `1.6×4.A` (Track B, conceptual)

- **Cell:** 1.6×4.A — "Descriptions for One Quantitative Variable Distributions" × skill 4.A (interpret)
- **Track:** B — authored slot-frame in `scripts/course_mode_stats_generator/slot_frames.py`
- **Difficulty:** Medium
- **Serving/grading:** MCQ choice-match (interpret-and-pick; **NOT** open free-response)
- **Branch:** `content/course-mode-stats-1.6-4a` (from latest `main`, own worktree)

**Read §11 first** — especially §11.1 (stem prose), §11.2 (per-context plausibility), and §11.4:
describing shape/center/spread invites near-duplicate option prose; make any such pairing **intentional**
and SME-flag it.

**Task design**
- Describe a one-variable quantitative distribution via a compact textual summary the student can reason
  about **without** rendering a real graph — e.g. give shape + a five-number summary (or the mean-vs-median
  relationship) in words/numbers, and ask which description of shape/center/spread/outliers is correct.
- Keep it MCQ interpret-and-pick; do **not** require an open written interpretation (no LLM grader in the
  pilot).
- Vary surface via ≥5 contexts and varied summary values.

**Distractors** (documented, cited; cell-namespaced `u1_6__` tags, append-only):
- `u1_6__skew_direction_reversed` — reads skew from the wrong tail (mean < median called right-skew, etc.).
- `u1_6__center_spread_confused` — reports a spread measure as center, or vice versa.
- `u1_6__outlier_from_range_not_fences` — calls a value an outlier without the 1.5×IQR rule (or misses one).
- `u1_6__ignores_shape_reports_center_only` — describes center but omits the shape the data clearly shows.

Confirm each is tempting for the specific summary shown; tag direction honest (§11.3).

**Gates (§5):** frame harness ≥100/0 + meta-tests; Gate 2 independent re-derivation of key + every
distractor; CED conformance (skill 4.A, served as MCQ); realistic distractors. **DoD (§7):** own branch;
passing report; re-derivation record; no loader/DB/release/serving/Prod.

---

## Orchestration (David)

- **Catalog-integration test (§6):** all three agents append to `misconceptions.py`/`scenarios.py`
  concurrently. On return, integrate the **catalog additions first** (append-only → trivial), then the
  template files, then run the **full harness once over everything** (`python3 generator.py` + the
  `slot_frames.py` harness). A green full sweep is the integration gate and where any real collision surfaces.
- **Review:** when each branch is pushed, the same independent review used for `1.11×2.A` applies
  (harness re-run + Gate-2 re-derivation + package-shape/regression checks) before D8 SME review.
- **Two side-tasks (not part of the three):**
  - `1.11×2.A` prose fix — hand Codex §11.1; fix on its existing branch `content/course-mode-stats-1.11-2a`.
  - `1.7×3.B` (`gen_summary_stats`) already exists and is fully registered — validate it through the gate
    (no new authoring) so it is release-ready.
- **Release stays gated:** loader → D8 SME review → CM-D19, Dev-first, held for David's go. Not the agents' job.
