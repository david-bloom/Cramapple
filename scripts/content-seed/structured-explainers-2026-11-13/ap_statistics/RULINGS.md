# Rulings: AP Statistics structured explainers, units 1-5 (2026-11-13)

Checkers: openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, all 55 topics, 5 topics per call. Arbitrated by Claude in session by reading CURRENT vs PROPOSED text.

## First full run (check_out/)
gpt-6.1-sol: 9 findings (1.3, 1.9, 2.1, 3.2, 3.8, 3.9, 3.13, 4.6, 5.1). moonshotai/kimi-k3.1-pro: 0 findings.

| Topic | Field | Claim | Verdict | Reason |
|---|---|---|---|---|
| 1.3, 1.9, 2.1, 3.2, 3.8, 3.9, 3.13, 4.6, 5.1 (9 findings, same issue) | point_attaining_answer | Table has no Markdown separator row (`\| --- \|`) after the header, so it will not render as a table in standard Markdown | Not a defect (rejected) | The renderer convention for this batch is "first row is the header, same column count every row", with no separator row, and tools.py validate enforces exactly that. Adding a separator would create a data row that the renderer would show. This is a markup-convention disagreement, not a factual, meaning, arithmetic or lost-content defect. Whether the live renderer needs a separator is NOT verified here; it should be confirmed in the preview. |

Real defects from the full run: 0.

## Control
`--plant 2.9` (a number changed in 2.9's answer): both models flagged 2.9 (check_out_ctl/). Control passes.

## Pre-existing issue found by the validator (units 1-2, authored earlier)
| Topic | Field | Claim | Verdict | Reason |
|---|---|---|---|---|
| 2.12 | how_this_becomes_points | 333 characters, over the 320 cap | Real (cap) | Shortened. |
| 2.12 | how_this_becomes_points | (kimi, on the re-check after the shortening) Step 1 says only "a graph", dropping "or description": CURRENT says "a given graph or description" | Real defect (lost content) | Confirmed in CURRENT. Rewrote step 1 as "Identify which a graph or description shows: ..." and made steps 2-3 declarative to stay under the cap (311 chars). Re-checked 2.12 alone: both models clean (check_out_recheck2/). The same omission was in the original proposed_u2.json; fixed in proposed_u2.json and proposed_all.json. |
| 2.1 | core_idea | validator: "2.1" only in CURRENT | Not a defect | CURRENT text says "2.1 asks you to read a table's structure": a self-reference to the topic number, dropped in the reshape; no fact lost. |

Notes on validator output: every "numbers only in PROPOSED: 1" is an artifact (the first step number "1." of how_this_becomes_points is not stripped because it follows other fields in the joined text); 4.6 "15" is n1 = 15 taken from the mini example question, as allowed.
