# Unit 5 v3 checker results (2026-11-21)

Checkers: openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro. Words a student sees: 1803 (old) -> 1942 (new) across 11 topics (validate.py; the new format adds Weak/Full credit text and a Link).

## Controls (plants.json, run on the first-draft text)
- 5.3 table "1/[A] vs t | second" changed to "first": caught by both.
- 5.1 Full credit "÷ 2" changed to "× 2": caught by both.
- 5.6 "Products below reactants: ΔE negative, exothermic" inverted: caught by both.
- 5.2 units "M⁻¹ s⁻¹ (2)" changed to "M⁻² s⁻¹": caught by both.
Both models caught all four, so both clean passes are trustworthy for these areas. One kimi call (run_clean_2: 5.7, 5.8, 5.9) returned NO JSON; those topics were covered by per-topic rechecks.

## Real defects / fixes
- 5.2, 5.4, 5.8 (both models): "not from coefficients" / "Not the coefficients" / slow-step rule too absolute. Fixed to "overall-equation coefficients do not generally give them", "cannot be read from the overall coefficients (use data, or the slow step with 5.8)", and the slow-step rule now carries the CED condition (every step irreversible or first step slow).
- 5.1 (sol): sign convention. Core now uses a positive rate of disappearance/appearance; table says disappears/appears.
- 5.5 (sol): concentration/surface area made universal; now "can increase", "more exposed surface area". Weak now says "applies step 2 incompletely".
- 5.8 Full credit (sol): asserted A and B are overall reactants from a one-step example; now conditional (if either were an intermediate, 5.9 applies). Weak now breaks step 2 only (kimi suggestion).
- 5.9 (sol): table ran slow before fast; now mechanism order (1 fast, 2 slow). Full credit now actually writes each step's equation, using the table's illustrative mechanism.
- 5.11 (sol): "unlike an intermediate" implied intermediates are consumed overall; reworded to produced-first/consumed-later.
- 5.10 (sol): steps and Link overstated the slow-step shortcut; now "usually slowest", each barrier from its own starting level, and the Link points to 5.9 for an intermediate.
- 5.8 / 5.1 Link overlaps (both models): 5.8 Link changed to point forward to 5.10; 5.1 Link no longer claims coefficient division must precede rate laws.

## Suggestions
- 5.6 (sol): reverse Eₐ formula correct (standard chemistry, see NEW); left.
- 5.8 Link (sol, suggestion at recheck3): left.

## Final status
Rechecked clean (no defect) by both models on final text: 5.1, 5.2, 5.4, 5.5, 5.8, 5.9, 5.10, 5.11 (5.8: sol pass with one LINK suggestion left; 5.10 changed twice and was clean on the last recheck).
Never rechecked after drafting because unchanged: 5.3, 5.6, 5.7 (clean in the first run for both models, apart from the 5.6 suggestion above; kimi run_clean_2 NO JSON covered 5.7 for sol only, and 5.7 was clean in sol's run, so 5.7 has one clean model only).

## What the checkers cannot show
Sources are treated as truth; derived facts (reverse Eₐ, zero-order row, the illustrative 5.9 mechanism, the 5.3 slope/half-life numbers) are judged as chemistry only.
