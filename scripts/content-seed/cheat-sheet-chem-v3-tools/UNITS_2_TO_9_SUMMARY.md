# AP Chemistry Units 2 to 9, Cheat Sheet v3 drafts: summary and decisions (2026-11-21)

Status: DRAFTS FOR REVIEW. Nothing written to Development or Production, no render, no human read. 83 topics drafted by nine subagents (one per unit; Unit 3 split in two) from `AGENT_BRIEF.md`, each in its own folder `scripts/content-seed/cheat-sheet-chem-u{N}-v3-2026-11-21/` (`proposed.json`, `DRAFTS.md`, `CHECKER_RESULTS.md`, `plants.json`, `check_out/`, `source_snapshot.json`). Unit 1 is in `cheat-sheet-unit1-v3-2026-11-21/` (PR 676). Rules: `docs/product/CHEAT_SHEET_GUIDELINES_2026_11_21.md`.

## What was checked
- **Agents' own runs:** gpt-6.1-sol and kimi-k3.1-pro, clean and planted copies, per unit. Both models caught every planted defect in every unit (re-verified by the parent from the raw output: 0 misses for either model).
- **Parent's independent pass (this summary's author):** validator on all nine folders (0 problems each); a fresh gpt-6.1-sol pass over the final text of all 83 topics; kimi on the topics the agents had left unrechecked (5.3, 5.6, 5.7, 8.3), clean; then fixes and rechecks of everything that pass flagged. Every topic has a clean result from both models on its final text, except where noted under "Left on purpose".
- **Defects the independent pass found that the agents' passes had not** (all fixed and rechecked clean): 2.6 bond lengths not in the sources (115, 124 and 140 pm, one wrong; replaced with a qualitative table); 3.3 water-vapor value not marked hypothetical; 4.5 "do not stop at moles" too absolute; 5.4, 5.7, 5.8 shortcuts stated without their limits; 7.8 K from raw counts; 7.9 "a stress shifts"; 8.2 strong-base and H₂SO₄ scope; 6.4 provenance wording; 9.11 time units; 5.7 Link "proves a catalyst". This shows one gpt pass is not enough on its own: expect further wording-level findings in a human read.
- Cost: about $11.3 (agents, as they reported) plus about $1.5 (parent verification and fixes), about $12.8 for Units 2 to 9. (Unit 8's own results file understates its cost; its report says about $1.15.)

## Length
Words a student sees across the cards (same counting method as Unit 1), current Production fields versus drafts:
| Unit | Topics | Now | Drafted | Change |
|---|---|---|---|---|
| 1 | 8 | 2,045 | 1,588 | -22% |
| 2 | 7 | 1,867 | 1,479 | -21% |
| 3 (3a + 3b) | 13 | 2,921 | 2,678 | -8% |
| 4 | 9 | 1,486 | 1,536 | +3% |
| 5 | 11 | 1,803 | 1,960 | +9% |
| 6 | 9 | 1,393 | 1,802 | +29% |
| 7 | 12 | 1,362 | 1,711 | +26% |
| 8 | 11 | 1,245 | 1,719 | +38% |
| 9 | 11 | 1,214 | 1,847 | +52% |
| All | 91 | 15,336 | 16,320 | +6% |

So the format is shorter only where the current text was long (Units 1 to 3). In Units 4 to 9 the current fields are terse and have no weak or full-credit answer, so the new worked unit adds words. The goal that held everywhere is structure (one job per card, no repeats, a model answer, a mechanism table), not length. (The validator prints "-26% less" for a 26% increase: a sign bug in `validate.py`.)

## Decisions for David
1. **DECIDED 2026-11-22 (David): keep, labelled.** Each affected Full-credit answer now opens with a label: 5.3 "Illustrative numbers", 6.4 "Illustrative inputs", 6.6 "Illustrative amount", 6.7 and 6.9 "Standard data values", 6.8 "Standard data value", 9.11 "F = 96,485 C per mole of electrons, a standard constant". 7.6's K = 4 is already worded "for example". Rechecked clean by both models. Original issue: **Illustrative numbers added to Full-credit answers** (the brief said numbers come from the published example; these units' examples are conceptual, so agents added figures; arithmetic recomputed and checked by both models, but the question the answer responds to is not the published one):
   - 5.3: slope -0.0231 s⁻¹, k = 0.0231 s⁻¹, t½ = 30.0 s (chosen by the agent).
   - 6.4: c = 4.18 J/(g·°C), ΔT = +2.0 °C (now worded "assumed for this example"); 6.6: 0.0100 mol giving -84 kJ/mol.
   - 6.7: bond energies H-H 436, Cl-Cl 243, H-Cl 431 kJ/mol; 6.8: ΔH°f(NH₃) = -45.9 kJ/mol; 6.9: +90.3 and +57.1 kJ steps summing to +66.4 kJ (standard data values, not in our fields).
   - 7.6: K = 4 becomes 0.25. 9.11: F ≈ 96,485 C/mol and about 1.93×10⁵ C (standard constant).
   Options: keep as clearly illustrative; revert those answers to the published conceptual example; or keep only the constants (F) and drop invented scenarios (5.3, 6.4, 6.6).
2. **Hook placement.** Production's hook-to-topic data attaches "OIL RIG" to 4.7 and 4.9 and "An Ox, Red Cat" to 9.8, 9.9 and 9.11; the agents put each hook verbatim on every attached topic. Today's recap showed it only on 4.7 and 9.8. Keep on all, or only the first? (Unit 5's "Plain, ln, reciprocal" hook is on 5.3 only.)
3. **New content not in the sources** (standard chemistry, judged by the checkers as chemistry only): per-unit lists are in each folder's `CHECKER_RESULTS.md` and the agents' reports; highlights are tables that carry facts the published fields only imply (2.3 conduction row; 2.7 geometry/hybridization; 3.1 structure-to-force table and strength order; 4.5 and 4.9 tables; 5.2 order-0 row; 5.9 illustrative mechanism; 7.7, 7.10, 7.11 illustrations; 8.2 Ca(OH)₂ example and 8.3 "x100"; 9.6 sign table; 9.9 E°cell formula; 9.11 q = I x t). Decide per unit whether to keep them or hold to the published fields only.
4. **Whether the format applies as is to conceptual topics.** About half the Units 4 to 9 topics have conceptual published examples (no calculation), so Weak and Full credit are short model answers, not worked calculations. They read well in the drafts but are the weakest fit; a human read should decide.

## Source defects found in Production fields (for a repair pass; none edited)
- Boilerplate `answer_move` ("First name the quantity, structure, condition, or representation...") in Chemistry 3.1 to 3.13 (all drafts take the move from the published worked example instead).
- Wrong or misleading: 7.10 `what_students_need_to_understand` ("adding reactant usually lowers or raises Q depending on placement" is wrong: adding a reactant that is in Q always lowers Q); 2.4 worked example ("both alloys made of two metals": steel is iron plus carbon); 1.2 worked example rounding (18.945 should be 18.946).
- Categorical or simplified: 3.10 worked example ("much stronger" hydrogen bonding vs dispersion); 3.3 worked example (22,400 mL/mol "water vapor at standard conditions" is the ideal-gas value, not an actual vapor); 3.4 worked example (3 significant figures from 2-figure inputs); 3.6 and 3.7 worked examples (stated absolutely); Reference entry 7.11 ("Ksp values greater than 1 correspond to soluble salts").
- Field mismatches: 8.1 and 8.8 `common_point_loss` do not match their worked-example weak answers; 8.4 and 8.11 `how_this_becomes_points` hold no steps; 8.7 step 2 and 7.3 step 3 have no demonstration in the published example.
- Not used on purpose: exam statistics in sources (for example the "2025 FRQ mean 0.56 of 1.0" in 2.7 and "0.11/1.0" in 3.1), because the guidelines avoid scoring claims.

## Plants after the fixes
`plants.json` in every folder was re-verified against the final `proposed.json` (every target text present, every plant changes the text, 2 to 4 per folder). Two were stale after later fixes (Unit 4: 4.2 step; Unit 7: 7.10 table row) and were repointed, so `check_unit.py <folder> run` applies cleanly everywhere (found by a PR review). The controls were caught by both models on the text as it stood in each agent's run; they were not re-run through the gateway after these refreshes.

## Left on purpose (documented disagreements and suggestions)
- 8.2: gpt flagged the H₂SO₄ and Group II points several times; the text now calls [H₃O⁺] = initial concentration "a convention" and ties Group II to "as far as they dissolve". Both models passed the last version.
- Suggestions not applied (all non-defects): 2.6 draw both resonance forms; 6.4 Link "at constant pressure"; 7.3 separate Qc, Qp and Ksp forms; 5.11 weak wording; 8.5 pKa of HB⁺ in Know; assorted "verification only" notes.

## Not done
No render at desktop or 375px (tables, unicode, the merged Score card), no human read of any topic, no write to Development or Production. Needed before any apply: the two app changes (one merged Score card with Weak and Full-credit labels; no recap when `quick_take` is null), the Reference clean-up, per-subject approval records, a Development rehearsal, and `current.json` snapshots for rollback. Physics, Biology, Statistics, Calculus and Precalculus are untouched.
