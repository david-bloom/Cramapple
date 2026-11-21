# Cheat Sheet guidelines (v3, 2026-11-21)

Status: DRAFT guidelines, derived from the Chemistry 1.5 redraft review (David, 2026-11-21) and checked on `scripts/content-seed/cheat-sheet-redraft-chem-1-5-2026-11-21/`. Not yet ratified as a DECISION. They sit beside the digestibility rollout record (`handoffs/SESSION_CLOSE_2026_11_14_CHEAT_SHEET_DIGESTIBILITY.md`) and replace its "render once" test with a judgment test.

## 1. The test: one job per card, not a repeat count
A concept may appear in more than one card or topic when each appearance does a different job (state it, use it in a table, demonstrate it, apply it in another topic). It is redundant only when two places make the same claim, in the same situation, for the same purpose. Ask of every card: what can a student now do or recognise that the rest of the sheet did not give them? If nothing, merge or cut. Lexical overlap numbers are tripwires for review, never a gate (they miss reworded repeats).

## 2. Two layers, then a link
| Layer | Field (no schema change) | Job |
|---|---|---|
| Know | `core_idea` | What is true: terse bullets, symbols, notation strings; no definitions of basic terms |
| Know | `what_students_need_to_understand` | The mechanism: a small table or at most two bullets of relationship, never a restatement of the rule |
| Score | `how_this_becomes_points` | The procedure: at most three direction-neutral steps |
| Score | `common_point_loss` | Shown as "Weak": the losing answer, and which step it skips |
| Score | `answer_move` | Shown as "Full credit": a concrete model answer whose (1), (2), (3) match the steps |
| Link | `practice_bridge` | One line to where this is used next (another topic), never a restatement |
| Hook | memory hooks | Unchanged, shown as "Remember it" |

The three Score fields render as one card (steps, then Weak, then Full credit). The worked FRQ example is compact, as two short lines, not a side-by-side table.

## 3. No recap
"In 30 seconds" (`quick_take`) is retired for topics redrafted this way: the sheet is short enough to be its own recap. A null `quick_take` must show no recap (no derived fallback).

## 4. Content rules
- Formulas live in Reference (LaTeX) unless the formula is the whole Know content, in which case the Reference duplicate is hidden.
- Mechanics beat prose: a notation string, a table or a numbered step in place of a paragraph.
- Skip definitions of basic terms a student already knows; keep a definition only where the topic's reasoning needs it.
- No new fact that is not in the topic's published fields or the CED fact pack. A needed new fact is flagged NEW, judged as chemistry by the checkers, and decided by David.
- Never state a rule of thumb that contradicts the course (for example fixed electronegativity cutoffs that treat bonds as boxes).
- Weak and Full credit come from the topic's published worked example (already verified), shortened.
- Unicode superscripts and subscripts (², ₗ) for notation; LaTeX stays in Reference until the equation rollout (DECISION-0119/0120) reaches prose.

## 5. Format limits
Field caps (characters): `core_idea` 360, `what_students_need_to_understand` 360, `how_this_becomes_points` 320. Every paragraph is all marker lines (`- `, `1. `, `| a | b |` with the first row as header) or all plain; a plain intro line is its own paragraph.

## 6. Process (unchanged)
Author in session, no hand-patching generated content. Two non-Claude checker families (openai/gpt-6.1-sol, moonshotai/kimi-k3.1-pro) with planted-defect controls; Claude arbitrates; fix real defects and recheck. Production writes only with explicit per-subject approval, an APPROVAL record, a Development rehearsal, per-row guards and an independent read-back. Rollback: save `current.json` first.

## 7. Reference clean-up that goes with this (shared pipeline, separate approval)
Hide Reference entries that repeat a Know bullet (same job); demote basic vocabulary to a glossary; keep entries that carry what Know does not (LaTeX formulas, qualitative definitions the topic needs).
