# TASK-0050 — Statistics Phase B, 2026-11-11

Scope: the live AP Statistics exam pack `548f06be-ccf4-426d-b82b-b424137a4438` in Production. This directory is the reviewable labeling package and execution evidence. David separately approved the 390-row Production insert under `APPROVAL-0236`; `write_skill_codes.sql` was applied and verified. `deterministic_review_only.sql` was not applied.

## Why the pilot labels did not transfer

The 203 MCQs on retired pilot pack `7c5a2975-8f0e-45b9-8fcc-7ec9b8d81ada` are separate content. Against all 821 current or retired items in the live pack, they have **zero matching `content_key`, title, or exact version stem**. The pilot pack has no FRQs. Its skill cells are tied to the pilot item and version IDs; copying them to the live pack would assign unrelated questions a skill. A separate 181-row Phase B migration was prepared for the live pack on 2026-09-29 (`20260929071941_task0050_apstats_phase_b_skill_codes.sql`). All 181 version IDs still exist: 56 retain its `skill_dimension_phase_b` source, while 125 now carry the October 2 four-voter replacement source. Subsequent content releases expanded and replaced much of the bank.

## Current Production inventory (read 2026-11-11 ET)

| Type | Published item rows | Published versions with skill | Published versions without skill | Published item rows with no published version |
| --- | ---: | ---: | ---: | ---: |
| MCQ | 460 | 88 | 364 | 8 |
| FRQ | 110 | 69 | 26 | 15 |

The reported 372 MCQ and 41 FRQ gaps count all published item rows. Of these, 23 have only retired versions and cannot receive a *published-version* skill label until their lifecycle status is reconciled. The 390 labelable versions all have a primary topic and registered candidate skills. Candidate counts: 99 with one skill, 96 with two, 153 with three, 42 with four. Before this pass, the live pack has 52 labeled topic × skill cells; 19 have at least two MCQs, 41 have at least one FRQ, and 12 meet both inventory thresholds. These are inventory counts, not proof of student mastery.

## Files and status

- `packets_01.json` through `packets_20.json`: 390 Production read-only packets, 20 or fewer per file; unique version IDs. Each contains stem/stimulus, choices or FRQ scoring criteria, current topic, and allowed grid skills. They intentionally omit answer-key flags.
- `no_published_version.csv`: the 23 published item rows whose latest version is retired. These need lifecycle reconciliation before a published-version skill can be assigned.
- `generate_deterministic.py`: produces `deterministic_review_only.sql` for the 99 single-candidate items. The SQL requires the same live pack, published item and version, primary topic, allowed grid cell, and no existing skill. It asserts exactly 99 inserts or rolls back. **Review only; Production write is a Hard Gate.**
- `scripts/taxonomy/label_skill_codes_mcp.mjs`: three-model consensus runner. Failed gateway calls are now retryable errors and cannot be mistaken for no-majority results. Its output SQL guards against changed lifecycle/topic/grid state and asserts the expected insert count.
- `decisions.json`, `results.jsonl`, `run_report.md`, `write_skill_codes.sql`: completed three-model pass and the guarded write that was applied under `APPROVAL-0236`. The vote records include model IDs, each model's skill and reason, and unanimity/majority tier. The SQL asserts exactly 390 inserts or rolls back.
- `baseline_cell_counts.json` and `verify_package.py`: reproducible cross-check of the current cell inventory, packet IDs, vote completeness, allowed skills, SQL guards, and projected inventory threshold.
- `postwrite_verify.sql`: read-only Production verification for `APPROVAL-0236`. It returned 390 inserted rows on 390 versions, 364 MCQ/26 FRQ, zero invalid inserted rows, zero remaining published versions without a skill, the matching label digest, 102 labeled cells, and 49 inventory-threshold cells.

`write_skill_codes.sql` includes the 99 deterministic rows. It and `deterministic_review_only.sql` are alternative application plans; do not apply both.

The first gateway attempt failed all calls because the shell sandbox blocked outbound fetches; its generated `held` result was discarded. A later auto-review rejection was resolved by David's explicit approval of the model calls in this session. The completed run used `openai/gpt-5.5`, `google/gemini-2.5-pro`, and blind `anthropic/claude-opus-5` on each of 291 multi-candidate items: **247 unanimous, 44 majority-earned, 0 held**. The adjudicator broke 28 proposer splits. Together with 99 deterministic rows, this covers all 390 labelable versions. Gateway-reported spend: **$6.0790 for 873 calls**. A post-run read-only Production check returned the same 390 missing version IDs as the packet set (`md5(string_agg(id::text, ',' order by id)) = 306bfc70759360396c912683cbb68f9a`).

Post-write Production readback found exactly 390 new secondary `provisional_model` rows (364 MCQ, 26 FRQ), 390 unique versions, zero invalid grid pairs, and zero published versions left without a skill. The database `version_id|topic_code|skill_code` digest matches `decisions.json`: `7fc5b10f60a5e049409d985017c17e1c`. Labeled topic × skill cells rose from 52 to **102**, and cells with at least two MCQs and one FRQ from **12 to 49**. This is an inventory threshold only; it does not certify actual student mastery or servability.

## Remaining Production boundary

The model calls and 390-row Production insert were separately approved. The old `content_item_cells_validation_check` blocker described in TASK-0050 is stale: today's CHECK permits `validated_by` **or** `model_run_id`, while still requiring `validated_at` and `validation_decision_id`. Promotion of these `provisional_model` rows to `validated` and reconciliation of the 23 items with no published version require separate decisions. Do not reapply either SQL file.
