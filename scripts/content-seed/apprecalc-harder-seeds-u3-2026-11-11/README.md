# AP Precalculus topics 3.1 to 3.3: harder seeds and variants (2026-11-11)

**Status: PREPARED, NOT EXECUTED.** Nothing here has been loaded into Dev or Production. Execution needs the Product Owner's go-ahead.
Part of the question difficulty improvement plan (`docs/product/QUESTION_DIFFICULTY_IMPROVEMENT_PLAN_2026_11_11.md`). Same pipeline as the Chemistry and Calculus AB packages (APPROVAL-0218, 0219).

## Contents
- 24 new MCQs: 6 seeds and 18 variants, topics 3.1 to 3.3 (8 each): shifts a period guarantees, average rates of a periodic function, signs and quadrants, ratios from a point off the unit circle, solving for angles, symmetry and shift identities.
- Retires 11 published practice MCQs (`superseded_keys.json`): families 015 (radian conversion, partly filed under 3.1), 041 and np2-007 (single exact values; 041 and np2-007 repeat cos(5π/6)). Kept: `apprecalc-mcq-sv-np2-007-v3` (a teaching item) and the three OHT teaching items.
- Pack `5522b532-5e50-41f2-99a2-10144bd4e8db`, taxonomy source `16383753-6775-430d-960a-544cd6ee0972`, serving label `required_units [3]`.

## Verification done
- Blind solve by `deepseek/deepseek-v4-pro` and `moonshotai/kimi-k3.1-pro`: 24 of 24 agree with the key each, on the final draft.
- Difficulty tool (`scripts/difficulty-audit/audit.py --items-file items.json`) run on the draft; it takes the lower of two model tiers.
- Not done: no checker pass on rationales, no subject-expert read, no Production load or rehearsal.

## Execution order (Production, from `~/supabase`)
1. `load/chunk_*.sql` 2. `verify_hashes.sql` (24 rows ok) 3. `publish_rehearsal.sql` then `publish.sql` 4. `retire_old_rehearsal.sql` then `retire_old.sql` 5. `verify_hashes.sql` again, record an approval (check the next free APPROVAL number first).
Regenerate: `python3 build_items.py && python3 gen_package.py`.
