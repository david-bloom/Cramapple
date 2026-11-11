# AP Chemistry topics 3.1 to 3.3: harder seeds and variants (2026-11-11)

**Status: PREPARED, NOT EXECUTED.** Nothing here has been loaded into Dev or Production. Execution needs the Product Owner's go-ahead.
Part of the question difficulty improvement plan (`docs/product/QUESTION_DIFFICULTY_IMPROVEMENT_PLAN_2026_11_11.md`). Same pipeline as the Statistics packages (APPROVAL-0214, 0215, 0217).

## Contents
- 24 new MCQs: 6 seeds and 18 variants, topics 3.1 to 3.3 (8 each).
- Retires 12 published items (`superseded_keys.json`): apchem-mcq-029, -030, -031 and their variants v1..v3 (12 items; 030 has an ambiguous key). Replaces 3 families (029, 030, 031) of one-fact items: 8 of 14 topic 3.1 to 3.3 items were 'hydrogen bonding raises boiling point', 3.3 had no practice MCQs (the two OHT items are teaching items and stay).
- Pack `c9ca46b2-b529-4ed3-9741-dddea455ab9b`.

## Verification done
- Blind solve by `deepseek/deepseek-v4-pro` and `moonshotai/kimi-k3.1-pro`: all 24 agree with the key, after the final revision of the draft.
- Difficulty tool (`scripts/difficulty-audit/audit.py --items-file items.json`) run on the draft; results and the items it rated R1 are in the session notes. The tool takes the lower of two model tiers, so it is strict.
- Not done: no checker pass on rationales, no subject-expert read, no Production load or rehearsal.

## Execution order (Production, from `~/supabase`)
1. `load/chunk_*.sql` 2. `verify_hashes.sql` (24 rows ok) 3. `publish_rehearsal.sql` then `publish.sql` 4. `retire_old_rehearsal.sql` then `retire_old.sql` 5. `verify_hashes.sql` again, record an approval (check the next free APPROVAL number first).
Regenerate: `python3 build_items.py && python3 gen_package.py`.
