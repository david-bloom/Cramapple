# AP Calculus AB topics 3.1 to 3.3: harder seeds and variants (2026-11-11)

**Status: PREPARED, NOT EXECUTED.** Nothing here has been loaded into Dev or Production. Execution needs the Product Owner's go-ahead.
Part of the question difficulty improvement plan (`docs/product/QUESTION_DIFFICULTY_IMPROVEMENT_PLAN_2026_11_11.md`). Same pipeline as the Statistics packages (APPROVAL-0214, 0215, 0217).

## Contents
- 24 new MCQs: 6 seeds and 18 variants, topics 3.1 to 3.3 (8 each).
- Retires 18 published items (`superseded_keys.json`): apcalcab-mcq-007, -029, -030 and their variants v1..v5 (18 items). Replaces families 007, 029 and 030 (R1 chain-rule and circle-slope items; 029 repeats two functions).
- Pack `826c8cf1-bc1b-4f2a-bd33-61a758e1487d`.

## Verification done
- Blind solve by `deepseek/deepseek-v4-pro` and `moonshotai/kimi-k3.1-pro`: all 24 agree with the key, after the final revision of the draft.
- Difficulty tool (`scripts/difficulty-audit/audit.py --items-file items.json`) run on the draft; results and the items it rated R1 are in the session notes. The tool takes the lower of two model tiers, so it is strict.
- Not done: no checker pass on rationales, no subject-expert read, no Production load or rehearsal.

## Execution order (Production, from `~/supabase`)
1. `load/chunk_*.sql` 2. `verify_hashes.sql` (24 rows ok) 3. `publish_rehearsal.sql` then `publish.sql` 4. `retire_old_rehearsal.sql` then `retire_old.sql` 5. `verify_hashes.sql` again, record an approval (check the next free APPROVAL number first).
Regenerate: `python3 build_items.py && python3 gen_package.py`.
