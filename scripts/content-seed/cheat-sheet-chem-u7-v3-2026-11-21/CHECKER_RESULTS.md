# Checker results: Unit 7 v3 drafts (2026-11-21)

Checkers: openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro. Claude authored and arbitrated. Spend about $1.5 (gpt about $0.26, kimi about $1.26). Raw output in `check_out/`.

## Controls (plants.json)
Four planted: 7.3 (Q < K row inverted), 7.6 (K = 4 reverses to 0.5), 7.10 (add reactant: Q rises, Q > K, forward), 7.11 (CaF2 exponents "1 and 1"). Both models flagged all four.

## Real defects found and fixed
| Topic | Finding | Found by | Fix |
|---|---|---|---|
| 7.2 | Weak said "both directions always occur" (a reactant-only start has no reverse rate) | both | "having both directions does not make their rates equal" |
| 7.3 | "AgCl dissolves until Q = K" needs enough solid present | gpt | qualified |
| 7.4 | Step 2 (write expression) not shown in Full credit; core and step 1 repeated the labelling instruction | both | steps cut to two, core reworded (initial, change, equilibrium rows) |
| 7.6 | "cancels shared species" too broad; Full credit (1) did not write the changed equation | gpt | "appear on opposite sides"; (1) writes the reversed equation |
| 7.8 | Raw particle counts into K and "more products means K > 1" too general | gpt (3 rounds) | table restricted to a one-to-one equation; raw-count shortcut removed |
| 7.9 | Rules unconditional (species not in Q, inert gas); step 3 not general to every stress | gpt | "species in Q", gas-phase qualifier, step 3 reworded |
| 7.10 | Added-reactant rules assume the species appears in Q (solids excluded) | gpt (3 rounds) | "a reactant in Q" in table and Full credit |
| 7.11 | A saturated solution need not contain solid | gpt | "in contact with undissolved solid" |
| 7.12 | Added/removed rows assume a saturated start; OH- is the salt's ion, not a shared one | gpt | "Starting from a saturated solution", "affected salt ion" |
Applied suggestions: 7.1 "partial pressure" in the graph label; 7.9 gas-phase qualifier.
Left: 7.3 (gpt suggestions: separate Qc/Qp wording; label step 3 as an extension), 7.11 (verification note only).

## Final status
Clean on both models on the final text: 7.1, 7.2, 7.3 (gpt two suggestions only), 7.4, 7.5, 7.6, 7.7, 7.8, 7.9, 7.10, 7.11 (gpt note only), 7.12. 7.5 and 7.7 were clean in the first run and never changed. 7.9 was cleared by a separate rerun after Kimi returned no JSON in the batch. 7.10 and 7.8 were last rechecked singly (both clean on the final text of 7.10; 7.8 clean on both in recheck2).

## What the checkers cannot show
Sources are treated as truth; derived facts (Q direction on adding a reactant, the A ⇌ 2B change row, K = 4 to 0.25) were judged as chemistry only. No render, no human read, no write to Development or Production.
Words a student sees (validate.py): 1362 now -> 1711 drafted. This is an INCREASE of about 26% (validate.py labels it "-26% less"): the published Unit 7 fields are already terse, and the new format adds tables, a Weak line and a Full-credit line.
