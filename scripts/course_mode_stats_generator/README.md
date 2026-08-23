# Course-Mode AP Statistics Generator (pilot, drift-safe subset)

Built 2026-08-23 on branch `course-mode/stats-generator-pilot`. Implements the
**drift-safe** portion of `docs/teaching/COURSE_MODE_PILOT_BUILD_PLAN.md`:
F1 (registry) + the computational generator (Track A) + one Practice-4 slot-frame
(Track B). The DB integration (F2/F4/A6/A7 serving) is intentionally NOT built —
it sits on tables that are out of sync Dev↔Prod (`content_item_versions`,
`grading_results`, `exam_pack_versions` differ; `content_taxonomy_labels` missing
in Dev). See `project_task0027_schema_convergence_status`.

Synthetic tooling. Generated items are NOT official College Board content and are
emitted `release_status: unreleased_generated_pending_review` — they require the
CM-D19 template-release + review gate (David reviewer of record) before any serving.

## Files
- `statlib.py` — stdlib-exact stats primitives (normal via erf; Acklam inverse; regression; proportion inference). Verified against known values.
- `cells.py` — F1 skill taxonomy + 131-cell registry (topic × skill) from fact pack §3. `python3 cells.py` prints invariants.
- `misconceptions.py` — **canonical misconception catalog** (A5). Single source of truth for every distractor tag, each with a cited source (fact-pack §10 / CED / trusted study guides) and an evidence tier. Generators fail if a distractor references a non-catalog tag. `python3 misconceptions.py` prints a summary + self-check.
- `scenarios.py` — **canonical scenario/framing catalog**. Per-procedure framing (FRQ archetype §5, task verb §6, digital modality §7, practice, validity rules) with citations, plus the context banks (proportion / two-group / regression / normal), each tagged with domain + per-context guardrails. Contexts are original synthetic settings (rights: no CB content). Generators fail if a procedure lacks canonical framing. `python3 scenarios.py` prints a summary + self-check.
- `generator.py` — Track A: 7 computational procedures × scenario × form, catalog-cited misconception distractors, item-package emission, property harness. `python3 generator.py` runs checks; `emit` writes samples.
- `slot_frames.py` — Track B: authored 4.B slot-frame (cell 1.9 × 4.B), observational-only scenarios, catalog-cited justification distractors. `python3 slot_frames.py` runs checks; `emit` writes samples.
- `f1_build.py` — emits `out/f1_cell_registry_seed.json` + `f1_migration_DRAFT.sql` (DRAFT, not applied).
- `build_load_sql.py` — **F4 intake/loader**. Reads the emitted packages and writes `out/f4_load_DRAFT.sql`: a fail-closed, transactional load that lands each item as an UNRELEASED draft plus its `content_item_checks` (persisted deterministic checks) and `content_item_cells` (item→cell tags). `python3 build_load_sql.py --check` validates packages without writing. Does not apply anything — the SQL is for review + later Dev application.
- `out/` — sample emitted item-packages + F1 seed + the F4 load SQL.

## What is validated
- Registry: 55 topics, 131 cells (U1:28 U2:21 U3:42 U4:30 U5:10); skills/practice P1:1 P2:5 P3:5 P4:7.
- Track A: 7 procedures — one-proportion z-interval (3.3×3.E), two-proportion z-test (3.13×3.E), LSRL predict (5.3×3.B), normal probability (2.11×3.C), summary statistics (1.7×3.B), one-sample t-test statistic (4.5×3.E), one-sample t confidence interval (4.2×3.E). The two t procedures use a standard tabulated t* (stdlib-only, no scipy); a chi-square procedure (3.15×3.E) is scaffolded and next. `lsrl_predict` distractors were made realistic per the content-authoring protocol (2026-08-23; off-scale `swapped_slope_intercept` removed, plausibility guardrail + key-realism floor added). Default `python3 generator.py` = 400 instances / 5,040 per-instance invariant checks + 8 meta-property tests (incl. the misconception- and scenario-catalog self-checks, and correct-answer-position variation), all pass; every MCQ has 1 key + 3 distinct misconception distractors, each carrying a canonical `misconception_source` (catalog tag + citation); every item carries `scenario_provenance` (FRQ archetype + task verb + modality + citations); the correct option is shuffled (not always first) and is asserted to pass the item's own deterministic checks; numeric-valued distractors are held clear of the key (>2× grading tolerance; interval distractors are separated by construction); emission is gated (resample until valid); deterministic_checks populated. Hardened 2026-08-23 per Fable QA (impossible predictions, throwaway/degenerate distractors, cell over-tagging, ungated emission all fixed; a real LSRL predict argument-order bug was caught by the property harness).
- Track B: 1 frame, 60 instances / 600 checks pass; scenarios observational; each distractor a catalog-cited misconception; each item scenario-framed (Q2 / Justify, observational-only).

## Scenario grounding (§5/§6/§7)
Scenarios are no longer bare tuples in code. `scenarios.py` gives each procedure a canonical **framing** and each item emits `scenario_provenance`:
- **FRQ archetype** (§5) — which Section II question type the item mirrors (Q1–Q4).
- **task verb** (§6) — Calculate / Construct / Justify, matching the item's scored demand.
- **modality** (§7) — all pilot items are text/numeric → `exam_aligned_digital` (no Desmos/hand-drawn dependency).
- **validity rules** — the constraints an instance must satisfy (e.g. two distinct groups; plausible slope sign; observational-only for 4.B; per-context μ/σ so Normal numbers stay realistic).
Rights: contexts are original synthetic settings — no official College Board questions or structures as source/exemplar (Phase-4 authoring brief rule 2, DECISION-0031/0033).

## Canonical grounding (A5)
Distractors are no longer invented in code. Every MCQ distractor references a tag in `misconceptions.py`, whose entry cites its source and evidence tier:
- `documented_cr` — documented in the 2025 Chief Reader Report via fact-pack §10 (in-repo, primary).
- `ced_structural` — follows directly from a CED formula / EK / exam-wide convention (fact-pack §10).
- `external_corroborated` — documented as a common error in trusted study guides (Albert.io, Fiveable, Khan Academy), used only for the topics §10 flags as thin (2.11 normal tails; Unit-5 regression prediction); each still carries an in-repo (§10/CED) anchor.
Rights: sources record *documented error patterns* and CED *structure* only — never verbatim College Board questions, keys, or scoring guidelines (DECISION-0031/0033). Adding a catalog entry releases nothing; items stay `unreleased_generated_pending_review` under CM-D19, and §3/§10 remain under the D2 SME gate.

## Scope / deferred (for morning review)
- t- and χ²-based procedures need special functions → a **scipy dependency decision** (env is stdlib-only). Procedures currently cover the normal/proportion/regression/descriptive computational cells.
- The generator emits its own draft package schema (`schema_version: course-mode-generated-0.1`). F4 core (the `content_item_checks` / `content_item_cells` tables + the `data_driven_deterministic` verifier) is now merged, and `build_load_sql.py` produces the load SQL; the DB ingestion still needs to be APPLIED to Dev, and the live `evaluate-attempt` wiring is the remaining F4 step.
- F1 migration is DRAFT and NOT applied to Dev. taxonomy_* are in sync, so it is safe to apply after review.
- Track B is n=1 frame family; it confirms the mechanism and gives an authoring-cost estimate (≈1 frame family per P4 skill), not full P4 coverage.

## Run everything
```
python3 cells.py && python3 generator.py && python3 slot_frames.py && \
python3 generator.py emit && python3 slot_frames.py emit && python3 f1_build.py
```
