# APPROVAL-0265 — Label gap fill, Units 1-5: validated topic cells and serving labels published to Production (2026-11-13)

- **Date:** 2026-11-13.
- **Authorization:** David Bloom (Product Owner), in the task brief ("David has directed publication of labels"), then in chat: scope "Serving and topic only" (difficulty and skills excluded), "Approve defaults" (Calc AB / Statistics non-validated cells promoted in place only on agreement; held items released only under the stated rules), "raise the cap to $11 so we can finish the task", and "Start Stage 4".
- **What is written (Production `pcntajvbdfqhbeewmdry`), labels only, one rehearsed transaction per subject with an advisory lock (`scripts/content-seed/label-gap-audit-2026-11-13/publish_labels.py`):** for 513 published items in registry Units 1-5 (Physics 2 = 9-13, Physics C: E&M = 8-12, Precalculus 1-4):
  - 298 new validated serving labels (`label_scope='serving'`, hash-fresh against `taxonomy_relevant_hash` of the latest version); the prior non-validated serving rows of those items (provisional_model, held, legacy_unvalidated, stale) get `superseded_by`; one validation decision each.
  - 117 new validated primary topic cells (inserted), 157 existing provisional_model primary cells promoted to validated in place (only where the six-vote topic equals the cell's topic).
  - 173 AP Statistics legacy items keep their existing `authored` topic x skill primary cell unchanged (promoting it would validate a skill, which is out of scope); they only receive the serving label.
- **Counts by subject:**

| Subject | Items | Cells inserted | Cells promoted | Authored cell kept | Serving labels |
|---|---|---|---|---|---|
| ap_biology | 2 | 0 | 0 | 0 | 2 |
| ap_calculus_ab | 157 | 0 | 157 | 0 | 28 |
| ap_calculus_bc | 20 | 7 | 0 | 0 | 20 |
| ap_chemistry | 8 | 7 | 0 | 0 | 7 |
| ap_physics_1 | 22 | 14 | 0 | 0 | 9 |
| ap_physics_2 | 20 | 15 | 0 | 0 | 5 |
| ap_physics_c_em | 30 | 26 | 0 | 0 | 8 |
| ap_physics_c_mechanics | 25 | 18 | 0 | 0 | 10 |
| ap_precalculus | 24 | 0 | 0 | 0 | 24 |
| ap_statistics | 205 | 30 | 0 | 173 | 185 |

- **Basis for each label:** six-vote blind topic probe (gemini-3.8-flash, deepseek-v4-pro, gpt-6.1-sol; sequential early stop: second gpt vote only where the outcome was open), topic accepted at >= 5 of 6, required units named by >= 4 of 6; 10 Statistics unit 4/5 FRQ seeds from their stored six-vote probe (topic 5.5 recorded CED-text tiebreak), their 20 variants inherit. Votes and tallies are stored in each label's `source_payload`. Measured gateway cost $10.31 (`stage3/cost_summary.json`).
- **Held items released (36):** newly served after this change; keys and hold reasons are in `stage3/resolved_final.json` (`hold_reason`): model_unit_disagreement now at >= 5 of 6, empty_required_units, model_call_failure.
- **Residue, NOT written (106):** no majority 50; held items kept held (rubric_preflight_failure 17, other 10); vote disagrees with an existing cell 25 (two of them validated, never changed); vote moves the unit away from the unit on record 4. Listed with tallies in `stage3/residue_final.json`.
- **What is NOT changed:** no item text, version, status, difficulty row or skill cell; no validated cell or label was modified or superseded; no schema, function, migration, edge function or Lovable frontend.
- **Effect on students:** 298 items newly servable (183 had no serving label at all). Items whose topic cell was promoted from provisional_model now count as topic matches in the selector.
- **Rollback (per subject, from the pre-state snapshots `stage4/pre_state_<subject>.json`):** (1) for each inserted label id: `delete` its validation decision then the label row (rows tagged `source = 'label_gap_fill_u1_5_2026_11_13'`); (2) `update app.content_taxonomy_labels set superseded_by = null` for the ids in the snapshot; (3) delete inserted cells with `source like 'label_gap_fill_u1_5_2026_11_13:%'` that are not promotions; (4) restore the promoted cells' `assignment_status`, `source`, `model_run_id`, `validated_at`, `validation_decision_id` from the snapshot.
- **Rehearsal:** all ten subjects `REHEARSAL OK` and rolled back before commit (counts and plan hash per subject printed by the script).
- **Numbering check:** highest APPROVAL on origin/main, every open PR and all remote branches at 2026-11-13 was 0264; this record takes 0265.
- **Result:** see the execution record appended below.

## Execution record (2026-11-13)
- Each of the ten subject transactions passed its own rehearsal again immediately before commit, then committed; in-transaction post-checks (topic cells, fresh validated labels, no duplicate primary, plan hash) passed for all ten.
- Independent read after commit (`publish_labels.py verify`): 513 of 513 items have a validated (or retained authored) topic cell with the planned topic and a fresh validated serving label; for the 298 items that received a new label the stored max required unit equals the plan. 0 mismatches.
- Correction to the counts above: 36 held items were released (not 38; two moved to residue when the unit-away-from-record rule was applied).
- Observation: `apphycm-frq-012` already had a validated serving label with max required unit 6; the vote said 5. Only its topic cell (5.6) was added; the existing label was not touched (rule: never change a validated label). Owner may want to review it.
- Not yet verified: live selector spot check and before/after served-set comparison (Stage 5).
