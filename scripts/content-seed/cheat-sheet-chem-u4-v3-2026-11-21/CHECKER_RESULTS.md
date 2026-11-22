# Checker results: Unit 4 v3 drafts (2026-11-21)

Checkers: openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro. Raw output in `check_out/`. Gateway spend about $0.92 (gpt about $0.14, kimi about $0.78). Claude authored and arbitrated.

## Controls
Four planted: 4.5 (mass conversion arrows swapped), 4.7 (combustion gives CO), 4.9 (oxidation number "Decreases"), 4.2 (cancel any species even if charge or phase differs). Both models caught all four.

## Real defects found and fixed
| Topic | Finding | Found by | Fix |
|---|---|---|---|
| 4.2 | Full credit did not demonstrate steps 1 and 3 (steps promised splitting into ions and a balance check) | gpt | Steps folded to two (cancel in the complete ionic equation; check atoms and charge); Full credit and Weak relabelled |
| 4.8 | "One proton moves" reads as a limit; the source says "one or more protons" | gpt | "Track the transferred proton(s)" |
| 4.1 | "composition changes" is universal; source says "typically with different compositions" | kimi (one of two runs) | Hedged as the source does |

Suggestion left: 4.5 gpt noted the limiting-reactant instruction is more explicit than the source, but correct chemistry (no change).

## Final status
All nine topics were clean on both models. 4.2 and 4.8 were rechecked after their fixes (both models, two runs, clean); 4.1 was rechecked after its fix (both clean). 4.3 was clean on gpt and on kimi (second rerun; kimi returned no JSON on the first three-topic batch). 4.4 to 4.7 and 4.9 passed both models in the first run (4.7 and 4.9 were not edited afterwards).

## What this does not show
Checkers treat the sources as truth. The 4.5 conversion table (n = PV/RT, V = nRT/P, n = M × V) and the 4.9 "oxidation number increases/decreases" column are standard chemistry, judged as such. Not done: render, human read, any database write.
Words a student sees: 1486 now to 1536 drafted (about +3%): the published Unit 4 fields were already short, so the gain is structure (tables, correspondence of steps and Full credit), not length.
