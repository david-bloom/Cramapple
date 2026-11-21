# Checker results: Chemistry Unit 8 v3 drafts (2026-11-21)

Checkers: openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro. Claude authored and arbitrated; no human review. Gateway spend about $1.00 for the main run plus about $0.23 for the recheck (sum of script lines).

## Controls (4 planted, all caught by both models)
8.2 Full credit pH 12.00 -> 11.00; 8.5 weak acid-strong base "Basic" -> "Acidic"; 8.9 "Raise 10" -> "Raise e"; 8.10 "More HA ... added base" -> "added acid". Both models flagged all four, so both clean passes are trustworthy for these areas.

## Real defects / changes (arbitrated)
| Topic | Finding | By | Action |
|---|---|---|---|
| 8.11 | "Yes" for any weak-acid/base ion under "added acid" over-generalizes (NH4+ is consumed by OH-, not H+) | kimi | Table now "Depends: does H+ or OH- remove that ion?" |
| 8.3 | "much less / most stays un-ionized" stated universally; "well below 0.10 M" not established without Ka | gpt | Added "typically"; "well" dropped |
| 8.4 | Step 1 "react completely" does not apply to weak acid + weak base | gpt | Scoped to "with a strong acid or base present" |
| 8.5 | Half-equivalence notation is weak-acid only | gpt | Added weak-base [B] = [HB+] and pKa of HB+ |
| 8.3 Link | "becomes the ratio" imprecise | gpt (suggestion) | Reworded (applied after recheck; text change only, not rechecked) |

## Left as is (source-faithful, reasoned disagreement)
- 8.2: gpt flags H2SO4 ([H3O+] = initial concentration), Group II hydroxides (Be(OH)2 amphoteric) and very dilute solutions (water autoionization). The CED fact pack states these rules exactly this way; the sheet follows the CED convention. Not changed.

## Final status
Rechecked clean by both models after edits: 8.3 (gpt suggestion only, applied), 8.4, 8.5, 8.11. Clean on first pass by both models: 8.1, 8.6, 8.7, 8.8, 8.9, 8.10. 8.2 has the three documented gpt findings above (kimi clean). The 8.3 Link rewording was never rechecked.

## What checkers cannot show
Sources are treated as truth; derived facts (Ca(OH)2 example, percent ionization formula, 0.010 M log values, 10 to the 1.00) are judged as chemistry only. Arithmetic recomputed by the author: -log(0.010) = 2.00; 14.00 - 2.00 = 12.00; 14.00 - 3.00 = 11.00; 20.0 / 2 = 10.0 mL; 10^1.00 = 10.

Words a student sees: 1245 -> about 1718 (validate.py total, run after final edit).
