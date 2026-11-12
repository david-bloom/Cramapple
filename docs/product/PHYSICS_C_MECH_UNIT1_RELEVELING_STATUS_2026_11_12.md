# AP Physics C: Mechanics Unit 1 re-leveling status (2026-11-12)

**Scope:** Physics 1 Unit 1 was done with the other subjects (APPROVAL-0243 to 0253). Physics 2 starts at Unit 9 and Physics C: E&M at Unit 8, so Physics C: Mechanics Unit 1 is the only Physics Unit 1 left. Plan: `QUESTION_DIFFICULTY_IMPROVEMENT_PLAN_2026_11_11.md`.

## Audit (read-only)
43 published practice MCQs before this batch (1.1: 8, 1.2: 14, 1.3: 5, 1.4: 8, 1.5: 8). 1.1 is 8 of 8 R1; 1.2 is 5 of 14 R1; no topic has more than one R3.

## Executed 2026-11-12 (APPROVAL-0254)
`scripts/content-seed/apphycm-harder-seeds-u1-2026-11-12`: 40 new MCQs (two seeds per topic, three variants each, topics 1.1-1.5), 19 retirements (whole R1 families: 1.1 all 8, 1.2 10, 1.3 1; teaching items excluded). After the batch each topic has 8 new items; the standard minimum is not met by new items alone where the old R1 families are retired (1.1 would have 8 published).

## Checks
- Format validator OK; package built with required_units [1].
- Blind solve (DeepSeek only): 40 of 40 agree with the key. This is one solver short of the two-model check in the difficulty plan; both models were used for tier checks.
- Tier check (both models, lower tier counts): no R1 seeds after the rewrite; one 1.1-B variant rated R1/R2; 1.2-A and 1.5-B base items were flagged `key_disputed` by the tier tool and re-derived by hand (v'(1) = -4 with v = 3 so slowing down; speed at t = 2 is sqrt(8^2 + 3^2) = 8.54 m/s): the keys are correct.

## Caveats
The author rates 1.4-B and 1.5-B as the weakest (R2-ish), 1.1-B and 1.2-B as modest R3. No subject-expert read; rationales not model-audited. Tiers are uncalibrated.
