# APPROVAL-0214 — AP Statistics Unit 2 harder seeds and variants: 96 items published, 33 superseded items retired (granted and executed 2026-11-10)

- **Status:** **Granted by David in chat ("blind solve and then push to production", 2026-11-10) and executed.**
- **Tier:** Production content write (student-facing questions).
- **Basis:** David's finding that Statistics Unit 2 questions were too easy (seed-level: 8 of 11 seed families were one-step recall). He rejected the earlier two-checker protocol for these seeds ("the replacement seeds are much better") and asked for variants drafted the same way.

## Scope
Production `pcntajvbdfqhbeewmdry`, AP Statistics pack `548f06be-ccf4-426d-b82b-b424137a4438`.
- **Loaded and published 96 MCQs** (24 seeds + 72 variants, 8 per topic, topics 2.1 to 2.12). Keys `APSTATS-MCQ-H-<topic>-<A|B>` and `APSTATS-MCQ-SV-H-<topic>-<A|B>-v1..3`. Correct-answer position balanced 24 each of A to D.
- **Retired 33 superseded items:** seed families 050, 051, 046, 048, 054, 049, 081, 052 (each seed + 3 variants) and `APSTATS-MCQ-073`. Rows retired, not deleted; student history intact.
- Package and generator: `scripts/content-seed/ap-statistics-unit2-harder-seeds-2026-11-10/` (README, items.json, load chunks, publish and retire SQL, hash manifest, `source_draft.md`).

## Verification before the write
- **Blind solve (2026-11-10):** DeepSeek V4 Pro and Kimi K3.1 Pro each solved all 96 items with keys and rationales hidden; **both agreed with the stored key on 96 of 96.** This checks keys only; per-choice rationales were not model-audited.
- Author's own Python arithmetic check on every number (before the blind solve).
- **Not done, by owner decision:** the two-checker rationale audit, the topic/skill vote and the CED scope check. Topics are the author's design intent; skill_code is null (topic-only tagging).

## Execution record
- 11 load chunks: no errors. `verify_hashes.sql`: 96 of 96 `ok`, all draft.
- `publish_rehearsal.sql`: `REHEARSAL OK (rolled back): published=96, validated_labels=96, topic_cells=96`. `publish.sql`: committed, same counts; `verify_hashes.sql` then showed 96 of 96 `ok`, item and version `published`.
- `retire_old_rehearsal.sql`: `REHEARSAL OK ... retired=33`. `retire_old.sql`: `retired = 33`.
- **After (verified):** published Statistics MCQs 261 → 324 (261 + 96 − 33); published per topic 2.1 to 2.12: 9, 9, 9, 9, 9, 12, 12, 9, 8, 13, 9, 9.
- Labels: serving, `required_units {2}`, `primary_unit 2`, taxonomy source version `dae3c72e-82ca-4960-9552-1b034bd347e5`; validation decision source `chat_review`; hashes validated against `app.taxonomy_relevant_hash`.

## Not verified
- **Student-facing delivery was not exercised** (no live session, no browser check that a student is served the new items and none of the retired ones). The label and cell post-checks passed, which is the proxy the pipeline uses.
- **Table stems** are plain `Row, Column: value` lines with group totals left for the student to compute; no content reviewer read the final student-facing text.
- Student attempt history on the 33 retired items was not inspected.

## Rollback
Retire the 96 new items (pattern in `retire_old.sql`, keyed on `APSTATS-MCQ-H-%` and `APSTATS-MCQ-SV-H-%`) and re-publish the 33 retired versions (rows retained).
