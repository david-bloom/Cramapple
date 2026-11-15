# APPROVAL-0236 — TASK-0050 AP Statistics Phase B provisional skills in Production

- **Status:** Granted by David in this Codex session on 2026-11-11 ET ("Approve the 390-row Production insert") and executed.
- **Tier:** Hard Gate, Production content-label write.
- **Scope:** Production `pcntajvbdfqhbeewmdry`, AP Statistics pack `548f06be-ccf4-426d-b82b-b424137a4438`.
- **Branch / PR:** `codex/task-0050-statistics-phase-b`, draft [#631](https://github.com/david-bloom/Cramapple/pull/631).
- **Prepared package:** `scripts/content-seed/task0050-stats-phase-b-2026-11-11/`.

## Exact approval

David separately approved the model calls, then approved applying the guarded TASK-0050 SQL to add **390 provisional skill cells (364 MCQ, 26 FRQ)** to live pack `548f06be`. The request and approval explicitly excluded the 23 published item rows with no published version and excluded promotion to `validated`. The original `APPROVAL-0060` covered Development and model spend but not this Production write; this is its subject-specific gate.

## Execution and verification

The retired pilot pack's 203 MCQs had zero matching content keys, titles or exact stems in the live pack, so no pilot skill cell was copied. The 390 published-version packets had 99 single-skill deterministic decisions and 291 model decisions (`openai/gpt-5.5`, `google/gemini-2.5-pro`, blind `anthropic/claude-opus-5`; 247 unanimous, 44 majority-earned, 0 held). Gateway-reported spend was $6.0790 for 873 calls.

Immediately before the write, Production still had 390 missing published versions (364 MCQ, 26 FRQ) with the same sorted version-ID digest as the packet set: `306bfc70759360396c912683cbb68f9a`. The guarded `write_skill_codes.sql` required the exact pack, published item and version, matching primary topic, registered topic × skill cell, and no existing skill row. It asserted **390 inserted** or rolled back. Executed through the Production Supabase SQL tool; no schema migration or app deployment.

Post-write readback:

- Exactly **390 new rows**, 390 distinct versions: 364 MCQ and 26 FRQ; all `provisional_model`, `is_primary=false`, and on registered grid cells. `model_run_id` prefix: `skill-codes-ap_statistics-20261112032357:`.
- **Zero** published versions on the live pack remain without a skill cell.
- The sorted `version_id|topic_code|skill_code` digest from the database equals the local decision file: `7fc5b10f60a5e049409d985017c17e1c`.
- Labeled topic × skill cells rose from 52 to **102**. Cells with at least two published MCQs and one published FRQ rose from 12 to **49**. Example `1.1 × 2.A` has four MCQs and one FRQ; two MCQ cell IDs `46f5f55a-0e7a-4918-8679-02879695a2ab`, `80f4383a-769e-44cc-9368-97b644600d4b`, FRQ cell ID `94e4069e-4ff3-4c93-a006-0f7cf5f998d2`.

This is a content inventory threshold, not student mastery or a serving-flow certification. The 23 published item rows whose latest versions are retired (8 MCQ, 15 FRQ) remain separate lifecycle defects in `no_published_version.csv`. Promotion to `validated` requires a further approval and a validation decision record; this approval did not grant it.

## Rollback

If the approved insertion must be reversed, delete only `app.content_item_cells` rows with `model_run_id like 'skill-codes-ap_statistics-20261112032357:%'`, after first checking that the count remains 390 and no later work depends on them. This rollback was not executed.
