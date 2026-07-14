# Fact Pack FP-CHEM-8.1-01 — Acids, Bases, and pH

**Pack ID:** FP-CHEM-8.1-01
**Pack-Version:** v01
**State:** Drafted
**Subject:** CHEM
**Applies to:** [CHEM]
**Unit / Topic:** Unit 8 (Acids and Bases) — pH, strong vs. weak acids, and
buffers *(confirm exact official topic id against the current AP Chemistry CED
before Approved)*
**Author class:** ai_draft_human_reviewed (illustrative format example)
**Source status:** cramapple_authored
**Official-material boundary checked:** yes — established public-domain chemistry
in original wording
**Status note:** Illustrative Draft. NOT production content, NOT calibration
evidence.

> Format reference: `docs/product/FACT_PACKS_AND_QUESTION_SETS.md` §4.

## Entries

### E1 — concept `teaching_safe` (learner_visible_summary, authoring_brief)

pH measures the acidity of a solution from its hydrogen-ion concentration. Strong
acids dissociate completely, so `[H⁺]` equals the acid concentration. Weak acids
only partially dissociate, governed by their acid-dissociation constant `Kₐ`, so
`[H⁺]` is much smaller than the nominal concentration.

### E2 — formula_rule `teaching_safe` (grading_only, learner_visible_summary, authoring_brief)

- `pH = −log[H⁺]`; `pOH = −log[OH⁻]`; `pH + pOH = 14` at 25 °C.
- Strong acid: `[H⁺] = C_acid` (complete dissociation).
- Weak acid (approximation for small dissociation):
  `[H⁺] ≈ √(Kₐ · C_acid)`, so `pH ≈ ½(pKₐ − log C_acid)`.
- `pKₐ = −log Kₐ`.
- Henderson–Hasselbalch (buffer): `pH = pKₐ + log([A⁻] / [HA])`.

### E3 — method `teaching_after_attempt` (grading_only, authoring_brief)

Deciding which relationship to use:

```text
1. Is the acid strong or weak? (strong → [H⁺] = C; weak → use Kₐ)
2. Is it a buffer (weak acid + its conjugate base both present)?
   → use Henderson–Hasselbalch, not the √(Kₐ·C) approximation.
3. Compute [H⁺] (or [OH⁻] for a base), then apply pH = −log[H⁺].
4. Check: strong acids give lower pH than an equal concentration of weak acid.
```

### E4 — misconception `grading_sensitive` (grading_only, repair_after_grade)

- **Misconception hypothesis:** the student treats a weak acid like a strong acid
  and sets `[H⁺] = C_acid`.
- **Response signal:** reports `pH = −log(0.10) = 1.0` for 0.10 M acetic acid.
- **Discriminating probe:** ask whether the acid fully dissociates.
- **Repair move:** "A weak acid only partially dissociates — use `Kₐ`, so
  `[H⁺] ≈ √(Kₐ·C)`, giving a higher pH than a strong acid at the same
  concentration."
- **Minimum fix:** apply the `Kₐ` relationship instead of complete dissociation.

### E5 — misconception `grading_sensitive` (grading_only, repair_after_grade)

- **Misconception hypothesis:** a buffer is treated with the plain weak-acid
  approximation, ignoring the conjugate base already present.
- **Repair move:** "When both the weak acid and its conjugate base are present,
  use Henderson–Hasselbalch."

### E6 — boundary `grading_sensitive` (grading_only) — criterion "weak-acid treatment justified"

- **Required evidence:** the response states or uses that the acid is weak
  (partial dissociation) and applies `Kₐ` (or Henderson–Hasselbalch for a buffer)
  rather than complete dissociation.
- **Accepted:** any correct use of `Kₐ`/`pKₐ`/`√(Kₐ·C)` or Henderson–Hasselbalch
  with a stated reason.
- **Insufficient:** correct arithmetic but on the wrong model (strong-acid
  assumption for a weak acid); a numeric pH with no acid-strength reasoning shown.

## Views

- **authoring_view:** E1–E6, full fields.
- **learner_view:** E1, E2, E3 (post-attempt); excludes E4–E6 pre-attempt.
- **grading_view:** E2, E4, E5, E6.
