# quick_take for Chemistry, Biology and Statistics units 1-5 (2026-11-13)

Authored "In 30 seconds" text (`app.topic_explainers.quick_take`) for 136 published topics: Chemistry 48 (incl. 1.5), Biology 33, Statistics 55. Two lines per topic (answer move, how points are lost); Chemistry 1.5 and Statistics 1.9 add a "Remember it" line from their published hook. Chemistry and Biology topics with only a bare-acronym hook (OIL RIG, SOCS, etc.) carry no hook line. Each sentence at most 25 words, whole field at most 400 characters. Written in session from each topic's own answer_move, common_point_loss and hooks (Production snapshot, `prod_snapshot.json`); no gateway authoring.

Files: `chem.txt` `bio.txt` `stats.txt` (authoring source, `R` rows are hook lines), `qt.py` (build / check / migration), `proposed.json`, `prod_snapshot.json` (read-only Production read, md5 of answer_move|common_point_loss per row), `migration_dev.sql` (schema; also `supabase/migrations/20261113150000_topic_explainers_quick_take.sql`), `prod_apply.sql` (data, md5 guarded, only fills nulls, raises unless exactly 136 rows), `verify_prod.sql`, `check_out/` `recheck_out/` `check_log.txt` (raw checker output).

## Checks
- Checkers: openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, every topic, 12 per batch. Round 1 flagged 23 topics as defects (mostly condensation that dropped a qualifier); the 24 topics below were revised and rechecked: bio 1.5, 1.7; chem 1.4, 1.7, 1.8, 2.2, 2.6, 2.7, 3.2, 3.12, 3.13, 4.7, 5.1; stats 1.1, 1.2, 1.4, 1.6, 1.7, 1.10, 2.9, 4.10, 5.2, 5.5. Recheck (round 1 revisions) left only 'label counts toward 25 words' suggestions (rejected: limit is per sentence), chem 3.2 'drops the name-the-quantity step' (rejected: that clause is generic boilerplate in the 3.x answer moves), stats 5.5 'realism attached to x=0' (rejected: matches the source). Chem 2.6 took three more rounds and is clean from both models.
- Planted-defect control: biology 2.5 (line 2 taken from 2.7) and chemistry 3.4 (Kelvin for Celsius) were both flagged fail by both models. One kimi control batch (statistics 0) returned unparseable output; it held no planted topic.
- Gateway spend about $3.
- Dev rehearsal: schema migration plus prod_apply.sql applied to Dev, 136/136 rows byte-equal to proposed.json. Dev's source fields matched Production's on all 136 rows (md5), and Production's `get_topic_point_guides` and view definition were identical to Development's before the change.

## Known weak spots (not fixed here)
- Chemistry 3.1-3.11 and Statistics 3.1-3.15 `answer_move` fields in Production are one boilerplate sentence ("First name the quantity... then ..."); the quick_take line uses only the specific clause.
- Some Statistics 2.x `common_point_loss` fields look aligned to a different topic than the answer move (2.4, 2.8, 2.9); quick_take follows the source fields and so inherits the mismatch.
- No human review. Checkers treat the source fields as truth.

## Production steps (not run)
1. `supabase db query --linked --workdir /Users/davidbloom -f <repo>/scripts/content-seed/quick-take-2026-11-13/migration_dev.sql` (ref pcntajvbdfqhbeewmdry confirmed with --debug).
2. Same for `prod_apply.sql`, then `verify_prod.sql`; expect 48/33/55 with quick_take, 0 elsewhere, published total unchanged.
3. Rollback: `update app.topic_explainers set quick_take = null where unit_number between 1 and 5 and subject_key in (...)`; the column is additive and the app falls back to the derived block.
Students see the text only after app PR 61 is merged and published to Lovable.
