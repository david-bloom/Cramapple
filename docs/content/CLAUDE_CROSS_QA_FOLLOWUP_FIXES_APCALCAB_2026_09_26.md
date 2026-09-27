# AP Calculus AB Tier 3 Cross-QA Follow-up Fixes (2026-09-26)

Applies the three fixes flagged in `docs/content/CLAUDE_CROSS_QA_AP_CALCULUS_AB_2026_09_25.md` (PR #199),
Claude's independent cross-QA of Codex's AP Calculus AB Tier 3 work (PR #197). All three were independently
re-verified against Production (`pcntajvbdfqhbeewmdry`) before fixing, via the Supabase MCP tool.

## Fix 1 — `apcalcab-frq-005` label hold resolved

Re-pulled the stored `source_payload` for both models on the held row (`d135bfe3-...`). Confirmed the
cross-QA's read exactly: GPT-5.5 returned `required_units=[2,3]`, `primary_unit=3` with a fully worked
per-criterion evidence table across all three parts (implicit differentiation, product rule, chain rule).
Gemini's *structured* `required_units`/`criterion_units[].units` fields were empty arrays on every single
criterion, but its own *prose* `evidence` text explicitly names units 2.5/2.8/3.1/3.2 for each criterion and
reaches the same conclusion as GPT-5.5 — a model-output-extraction bug, not a genuine disagreement.

Applied `supabase/migrations/20260926130000_apcalcab_frq005_hold_resolution.sql`: inserted a new current
label row (`required_units=[2,3]`, `primary_unit=3`, `label_status='provisional_model'`,
`source='claude_cross_qa_hold_resolution_2026_09_26'`), superseded the held row. Verified post-apply: exactly
one current row for this item, `label_status='provisional_model'`.

Not fixed here (separate content ticket, as the cross-QA noted): the item's `stimulus` field states the
level-curve constant as 14 while `prompt_json`/canonical answers use 16 (the value consistent with the point
(2,2) actually lying on the curve). Both models flagged this independently. Recorded in the migration's
`source_payload` note for traceability; needs a content-team fix to the stimulus text itself.

## Fix 2 — `apcalcab-mcq-030` label hold resolved

Re-verified: both models agree `primary_unit=3` (implicit differentiation of x²+y²=25 at (3,4)); the only
disagreement was `required_units=[3]` (GPT-5.5) vs `[2,3]` (Gemini, citing the power rule as load-bearing
alongside implicit differentiation and the chain rule). Resolved to `[2,3]`, matching the secondary-unit-
tagging convention already used for `apcalcab-mcq-041` in the same run (an implicit-differentiation item
that also tagged its underlying power-rule mechanics unit as a secondary requirement).

Applied `supabase/migrations/20260926130100_apcalcab_mcq030_hold_resolution.sql`. Verified post-apply:
exactly one current row, `label_status='provisional_model'`, `required_units=[2,3]`, `primary_unit=3`.

## Fix 3 — `apcalcab-frq-033` rubric defect and difficulty misclassification

Pulled the item's full stem and all nine `frq_criteria` rows directly from Production before touching
anything. Confirmed the defect: part (a)'s stem said only "State the Mean Value Theorem conclusion for f on
this interval," but `part-a-criterion-3` scores "Cites the given continuity and differentiability
conditions" — an operation the stem text never asks for.

Reading the full rubric (all three parts, nine criteria), "cite the hypotheses" is not a spurious or
misplaced criterion — it's a standard, correctly-scored element of a complete Mean Value Theorem
application (real AP scoring requires verifying continuity/differentiability before concluding existence).
The defect is that the stem is too terse to actually ask for it, not that the criterion belongs somewhere
else or should be removed. Fix: reworded part (a)'s stem to explicitly ask the student to verify the
theorem's hypotheses are satisfied, aligning it with the criterion that was already correctly scoring that
step. Parts (b) and (c) are unchanged.

Applied via `supabase/migrations/20260926130200_apcalcab_frq033_rubric_and_difficulty_fix.sql`, updating
`content_item_versions.stem` for version `b2aa5c0f-685d-4df3-8d4c-da1a46163e2a` in place (no new version
row — matches the existing convention for rubric/stem P0 fixes to published content, e.g.
`supabase/migrations/20260925080000_p0_fixes_calcab_005_and_chem_l002_l006.sql`).

**Difficulty correction:** the item was classified Easy by `assign_difficulty_calcab.py`'s regex classifier
because its cues matched only the rubric's scorer-facing paraphrase verbs ("Identifies," "States," "Cites"),
not the item's actual cognitive demand — a two-part existence-and-uniqueness proof by contradiction (part b
is a contradiction argument, part c is a strict-monotonicity uniqueness argument), which is non-routine by
the documented methodology (`docs/research/apbio_difficulty_calibration_2026_09_22/README.md`). The item's
own authored `prompt_json.difficulty` field (recorded at authoring time, not read by any runtime code) had
already said "Hard" — an independent corroborating signal found while investigating the rubric fix.
Corrected `app.content_item_difficulty` to `difficulty='Hard'`, `basis='calibrated_judgement'` (the closest
fit in the table's check constraint — allowed values are `calibrated_task_verb`, `calibrated_judgement`,
`translated`, `normalised_casing`, `undetermined`; there is no dedicated "manual correction" basis value),
with the correction reason and prior value recorded in `subject_cut_points` and `rationale`.

**Not fixed here, intentionally:** the `apcalcab-frq-033` serving-label row remains `held`
(`rubric_preflight_failure`) — resolving it correctly requires re-running the two-model label pipeline
against the now-corrected stem, not fabricating a new required-units assignment by hand. Flagged as a
follow-up: re-run `extend_serving_labels_mcp.mjs` for this one item once the rubric fix above has landed.

## Verification summary

All three fixes independently confirmed post-apply via fresh `execute_sql` queries against Production
(shown above per fix). No `label_status='validated'` written. No other rows touched — confirmed via
`content_item_id`/`content_item_version_id` scoping in each migration's `where` clause (single-row targets,
not a batch, so no separate contamination-join check was needed beyond confirming the ids belong to the
live AP Calculus AB pack, which the cross-QA report's own investigation already established for all three
items).

## PRs

- PR #197 (Codex's AP Calculus AB Tier 3 implementation) — merged.
- PR #199 (Claude's cross-QA report) — merged.
- This fix (branch `claude/apcalcab-qa-followup-fixes-2026-09-26`) — merged.
