# Checker results: Unit 2 v3 drafts (2026-11-21)

Checkers: openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro. Script: `scripts/content-seed/cheat-sheet-chem-v3-tools/check_unit.py`. Raw output: `check_out/`. Gateway spend about $1.09 (gpt about $0.16, kimi about $0.93). Claude authored and arbitrated; no human review.

## Controls
Four planted (`plants.json`): 2.1 (Na-Cl difference 1.23 instead of 2.23), 2.4 (table Radii cells swapped), 2.5 (14 lone-pair electrons instead of 16), 2.7 (3 regions at 109.5°). Kimi flagged all four; gpt flagged all four. Both clean passes are therefore trustworthy for arithmetic and table cells.

## Real defects found and fixed
| Topic | Finding | Found by | Fix |
|---|---|---|---|
| 2.4 | Link "which is all this call needs" implied knowing the larger atom is enough; the call needs whether radii are comparable or significantly different | both | Link now says radius trends help judge whether radii are comparable or very different |
| 2.6 | Step "pick the lowest" formal charge is ambiguous (most negative vs closest to zero) | kimi | "prefer formal charges nearest zero, with negative on the more electronegative atom" |
| 2.2 | Bond-order rule needs a scope (H-H vs N≡N shows it is not universal across element pairs) | gpt | core_idea now "For the same pair of elements, higher bond order generally gives..." |
| 2.5 | "short central atom turns a lone pair into an extra bond" read as universal (BF₃, SF₆) | gpt | "a central atom still short of an octet may take a lone pair as an extra bond" |
| 2.2 | Step 1 said "read from the curve" but the worked example gives data, not a graph, so Weak/Full credit did not demonstrate it | gpt (recheck) | Step 1 now "from given data or from a curve"; Weak and Full credit adjusted |

Left as is: 2.6 gpt suggestion to draw both resonance forms in Full credit (text answer identifies both forms verbally; drawing is not possible in plain text and the point is conceptual).

## Final status
Clean on both models on the final text: 2.1, 2.3, 2.7 (first run, unchanged since), 2.2 (recheck2), 2.4, 2.5, 2.6 (recheck1 clean on both; no later edits). No topic is unchecked after its last edit.

## What the checkers cannot show
- Sources are treated as truth. NEW-ish items judged as chemistry only: 2.3 row "Conducts only when molten or dissolved | Ions are locked in place in the solid" (the source says conduction traces to the array; the mechanism wording is standard chemistry); 2.1 table hedged ("generally", "a shortcut only") with no cutoffs.
- Not done: render, human read, any write to Development or Production, Reference clean-up.
- Words a student sees across seven topics (validate.py): 1867 now to 1479 drafted (21% less). Per topic final: see validate output (2.1 255→200, 2.2 280→~220, 2.3 252→214, 2.4 239→199, 2.5 265→248, 2.6 253→199, 2.7 323→195).
