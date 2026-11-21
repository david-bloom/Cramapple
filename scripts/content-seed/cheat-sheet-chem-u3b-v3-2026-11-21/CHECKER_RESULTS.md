# Checker results: AP Chemistry topics 3.8 to 3.13, Cheat Sheet v3 (2026-11-21)

Models: openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro. Raw output in check_out/.

## Controls (plants.json)
| Topic | Planted defect | Sol | Kimi |
|---|---|---|---|
| 3.9 | Mobile/stationary phase travel cells swapped | caught | caught |
| 3.11 | Infrared transition changed to Electronic | caught | caught |
| 3.12 | E = hν "greater" changed to "smaller" | caught | caught |
| 3.13 | 0.80 / 0.40 = 4, "quadrupled" | caught | caught |
Both models caught all four plants, so their clean passes are trustworthy for these areas.

## Real findings on the clean text, and arbitration
- 3.10 Know mechanism, "Mismatch: solvent prefers its own, stronger forces" (both models): REAL overgeneralisation (a mismatch does not always mean stronger solvent forces). Fixed: "Solvent-solute attractions replace the disrupted interactions poorly".
- 3.10 Full credit, "water: hydrogen bonding, much stronger" (Sol only): fair. The published example states it, but it is a simplification. Fixed: dropped "much stronger"; the mismatch is now argued as I2-water attractions replacing water's hydrogen bonds poorly.
- 3.12 Full credit did not show step 3 (energy change of the species) (Sol only): REAL step/answer mismatch. Fixed: added part (3) ("if absorbed it raises the species' energy by more").
- All other topics (3.8, 3.9, 3.11, 3.13) clean on both models in the first pass. Suggestions: none outstanding.

## Final status
3.10 and 3.12 were changed and rechecked (recheck1): both models clean on both repeats. 3.8, 3.9, 3.11, 3.13 were not changed after the clean run and were clean on both models. No topic remains unclean.

## What the checkers cannot show
Sources (published fields, worked examples, reference entries) are treated as truth; derived facts are judged only as chemistry. The checkers do not see how cards render or whether a student finds them clear.

## Words a student sees
Old 1308 words -> new 1092 (about 17% less), PROBLEMS: 0 (validate.py).
