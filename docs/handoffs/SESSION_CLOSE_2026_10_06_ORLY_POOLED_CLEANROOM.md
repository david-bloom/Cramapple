# Session close: Orly pooled practice sets → clean-room MCQs (2026-10-06)

## What happened

1. **Assessment.** Orly and classmates pooled practice MCQs:
   - **AP Chemistry:** 20 questions in a Google Doc titled "Chem 1.1 MCQs". By CED topic they cover Unit 1 (7), Unit 3 (2), Unit 4 (9) and Unit 9 (2). 2 keys are wrong.
   - **AP Calculus AB:** 4 questions pasted in chat, covering topics 2.1 (3) and 5.1 (1). All 4 keys are wrong, and 3 have no correct choice.

   All of them are reworded released-exam items. David told Orly about the errors.
2. **Decision `DECISION-0098`.** Sets like these (seed class D) may seed new items only through the clean-room path:
   - one context writes scrubbed pattern specs;
   - fresh agents author from those specs;
   - a divergence check runs outside the repo.

   The source text is never stored.
3. **Run.**
   - **Scope:** Units 1-3 only. 10 families: Chemistry F1-F8 and Calculus C1-C2.
   - **Drafts:** 3 per family, 30 in total.
   - **Checkers:** gpt-5.6-sol and deepseek-v4-pro-0813.
   - **Quality steps:** 4 divergence rewrites, independent re-derivation of every key, patches re-checked in full.
4. **Publish `APPROVAL-0126`.** 27 items are live in Production:
   - **Chemistry (21):** `apchem-mcq-orly-*`
   - **Calc AB (6):** `apcalcab-mcq-orly-*`

   Each has a validated label, a topic cell, a skill cell and a difficulty band, and all 27 were hash-verified. F4 (3 density items) is **held, not in any database** (density is not in the AP Chemistry CED). f6-v2 was set to topic 3.7 by David.

## Where things are

| What | Where |
|---|---|
| Batch README (procedure, who saw what, adjudications) | `scripts/content-seed/apchem-orly-cleanroom-2026-10-06/README.md` |
| Pattern specs (scrubbed, signed off) | `family_specs.json` in each batch folder |
| Final item text | `items_assembled.json` (pre-patch: `items_assembled_prepatch.json`) in each batch folder |
| Per-item status | `status_manifest.json` in each batch folder |
| Patch record (3 rounds) | `apchem-orly-cleanroom-2026-10-06/patch_round1.py` |
| Key re-derivation | `rederive_independent.py` in each batch folder |
| Checker outputs | `out_audit*`, `out_ced*`, `out_probe_*`, `out_skill_*` in each batch folder |
| Production load (template for new, non-variant items) | `apchem-orly-cleanroom-2026-10-06/gen_publish.py`, `*_rehearsal.sql`, `*_commit.sql`, `hash_check_*.sql` |
| Source log + insight note | `docs/research/orly_source_log/SOURCE_LOG.md`, `docs/research/orly_source_log/2026-10-06_ap_chemistry_pooled_practice_mcqs.md` |
| Decision / approval / activity | `DECISION-0098`, `APPROVAL-0126`, activity log 2026-10-06 |
| PR | [david-bloom/Cramapple#352](https://github.com/david-bloom/Cramapple/pull/352) (records only; Production already written) |
| Source text | **Not in the repo.** It is in the Google Doc and the chat only. |

## Open

- **Merge PR #352.** It is David's to merge; CI was pending at close.
- **F4 (density):** held as readiness content. It returns only if a prerequisite layer exists (OMP §4).
- **`apchem-mcq-orly-f2-v3`:** its skill cell is `provisional_model` (2 of 4 votes).
- **Not used yet:** the pooled sets' Unit 4 and Unit 9 Chemistry items and the Calc AB 5.1 item. They were outside this run's scope, and they are the clearest gaps: we have no Chemistry content for Units 4 or 9, and 5.1 has only 2 trivial items.
- **Family membership** exists only in the batch files (seeded protocol §7).

## Traps hit (reuse the fixes)

- **Divergence:** clean-room authors still converge on the classic source instance (SO₃, MgCl₂/KCl, gas collected over water). The divergence check caught all of them.
- **Audit artifact:** `subject_audit_check.mjs` says "treat numbers as exact", so GPT flags 4-sig-fig empirical formulas as having a "key wrong". This is an artifact; adjudicate it by hand.
- **CED check input:** `subject_ced_check.mjs` needs `content_key` and `criteria` fields; `key` and `choices` are not enough.
- **Skill grid:** `skills-u13-2026-10-03/cells_chem.json` covers only part of the grid. Read `app.taxonomy_cells` instead.
- **Letter draw:** use a balanced random draw. A plain random draw gave 11 of 24 answers on D.
