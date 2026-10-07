# Insight note: AP Chemistry pooled practice MCQs (2026-10-06)

Source: a Google Doc titled "Chem 1.1 MCQs" that Orly and classmates put together. It has 20 multiple-choice
questions with answer keys. Each question has an "Original idea" line naming a source problem, so these are reworded
versions of released AP exam items, probably written with an AI tool. No question text is stored in the
repo. See the `SOURCE_LOG.md` row for the rights posture and `DECISION-0098` for how it was used.

## What the document tells us (non-content signals, OMP §5)

1. **Class labels do not follow CED numbering.** The class calls this set "1.1". By CED topic it covers Unit 1
   (1.1, 1.3, 1.4: 7 items), Unit 3 (3.4, 3.7: 2 items), Unit 4 stoichiometry (9 items) and Unit 9 (9.8, 9.11:
   2 items). A student who looks for "Unit 1" in Cramapple will not find most of what their class calls Unit 1.
   This repeats the AP Calculus AB numbering mismatch from 2026-09-24.
2. **Students study from unverified AI-reworded keys.** 2 of the 20 keys are wrong: one percent-yield item and
   one electrolysis item. A third item has the right answer but a wrong worked explanation. Two items keep a
   pre-2014 five-choice format, and one item refers to a substance the question never introduces. Orly has been
   told (Product Owner, 2026-10-06). Product signal: verified keys and rationales are something students
   cannot easily get from their own pooled sets.
3. **The real practice is multi-step and lab-framed.** The pooled items take 2-4 steps, include numbers the
   student must ignore, and ask "what should the student do next" or "which error explains the result".
   Our published AP Chemistry Unit 1-3 MCQs are almost all one-step recall or calculation, and the bank has
   **no lab-procedure or error-analysis MCQs** for Units 1-3. That is the gap the 2026-10-06 clean-room batch
   targets (families F7 and F8 in particular).
4. **Coverage depth.** Topics 1.3 and 1.4 have one published MCQ each, and the pooled set leans heavily on
   them (empirical formula, composition of mixtures, constant-mass procedure).
5. **Units 4 and 9 are in active use in class now** (early October), and we have no published Chemistry content
   for them. 11 of the 20 pooled items fall there. They were deliberately left out of this batch (Product
   Owner scope: Units 1-3).

## Excluded from this batch and why

- The hydrate-formula item: "hydrate" and dot notation are not CED vocabulary (`DECISION-0095` rule applied to
  Chemistry). The constant-mass *procedure* idea was kept, reframed as drying a mixture (family F8).
- All Unit 4 and Unit 9 items: out of the requested scope.

## Addendum: AP Calculus AB pooled items (same day)

A second pooled set of 4 AP Calculus AB MCQs, pasted in chat, has the same origin (reworded exam-style items).
- **Topics:** three are 2.1 (average rate of change of a given function) and one is 5.1 (instantaneous velocity
  equal to average velocity, a Mean Value Theorem application).
- **Quality: all 4 keys are wrong, and 3 of the 4 items have no correct choice at all.** The written
  explanations admit the numbers were "tuned" or "adjusted" without being recomputed. This is a stronger form of
  signal 2 above: AI-reworded practice sets that change the numbers without recomputing break completely.
- **Coverage:** the bank already has a family that asks for a single average rate of change of a polynomial or
  radical (`apcalcab-mcq-u2n-001` and variants), so two of the three 2.1 items add nothing. New patterns worth
  writing are trigonometric average rate of change (exact values, including the zero-average case) and
  comparing average rates across intervals: families C1 and C2 in
  `scripts/content-seed/apcalcab-orly-cleanroom-2026-10-06/`. Topic 5.1 has only 2 published items, both on
  `x²`, but it is outside the Units 1-3 scope of this batch.
