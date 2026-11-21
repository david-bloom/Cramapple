# Checker results: Unit 3 (3.1 to 3.7) v3 drafts (2026-11-21)

Checkers: openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro. Claude authored and arbitrated. Gateway cost about $2.0 in total (about $0.4 of it gpt, the rest kimi; one recheck round of about $0.7 was spent on unedited text because my first edit script failed, so its findings were still real but it did not test fixes).

## Controls
Four planted: 3.4 answer_move (0.714 to 0.814), 3.5 table (lighter gas speed "Greater" to "Smaller"), 3.7 core (liters of solution to solvent), 3.2 table (ionic conducts only if ions move to "conducts as a solid"). Both models flagged every plant (gpt: 3.2, 3.4, 3.5, 3.7; kimi: 3.2, 3.4, 3.5, 3.7). The plant run's kimi clean batch for 3.1 to 3.3 returned NO JSON, so kimi's first pass on those came from the per-topic rechecks.

## Real defects found and fixed
| Topic | Finding | Found by | Fix |
|---|---|---|---|
| 3.1 | Source core lists ion-dipole before hydrogen bonding in a strength order; ion-dipole is typically stronger than dipole-dipole and often stronger than H bonds | gpt | order given for comparable size without ion-dipole in the sequence; ion-dipole stated as typically stronger than dipole-dipole |
| 3.1 | Table and step 3 ignored size (London can dominate for large molecules); table said "strongest" absolutely | gpt, kimi | "comparable size" qualifier, "Typically the strongest force", step 3 "allowing for size" |
| 3.1 | Link "decides solid type... which substances mix" overstated | gpt, kimi | "helps explain" |
| 3.3 | Full credit step 2 omitted motion for ice and liquid, order for vapor | gpt, kimi | added |
| 3.3 | Liquid molar volume "similar to solid" lost the source's "typically" | kimi | restored |
| 3.4 | Total pressure and N2 partial carried 3 significant figures from 2-sf moles | gpt | 1.7 atm, 1.2 atm (unrounded shown) |
| 3.4 | Full credit (1) did not perform step 1 (choose equation) | gpt, kimi | (1) now names PV = nRT then mole fractions |
| 3.4 | Mixture row of table: moles alone do not give total P | kimi | "plus V and T" |
| 3.6 | "Largest deviation" stated categorically | gpt | "generally largest" (core, step 3, Full credit) |
| 3.7 | Solvent-volume row generalized the NaCl example ("generally slightly larger") | gpt | "they can differ"; Weak and Full credit hedged to match |

Suggestions applied: 3.2 direction of vapor pressure and boiling point trends (kimi); 3.3 "about" on molar volumes and STP label for 22,400 (both). Not applied: none left open.

## Final status
Final-text rechecks (both models clean): 3.2, 3.3, 3.4, 3.6, 3.7 (recheck2) and 3.1 (recheck3 after one more table header edit). 3.5 was clean on both models in the first run (kimi clean_1, gpt clean_1 had no 3.5 finding) and was never edited, so its final text is the checked text. All seven topics are clean on both models on their final text.

## What this does not show
- Sources are treated as truth; the 3.1 table rows and the 3.2 trend phrase (stronger IMFs generally mean lower vapor pressure, higher boiling point) are standard chemistry judged as such.
- No render, human read, or write to Development or Production.
- Words a student sees across the seven topics (validate.py): 1613 now, 1586 drafted (2% less). The saving is small because Full credit answers were written to demonstrate every step, and those are the longest fields.
