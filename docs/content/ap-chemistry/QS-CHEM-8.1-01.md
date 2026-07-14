# Short Question Set QS-CHEM-8.1-01 — Acids, Bases, and pH

**Set ID:** QS-CHEM-8.1-01
**Set-Version:** v01
**State:** Drafted
**Subject:** CHEM
**Applies to:** [CHEM]
**Unit / Topic:** Unit 8 (Acids and Bases) — pH, strong vs. weak acids, buffers
**Intended use:** diagnostic
**Linked fact pack:** FP-CHEM-8.1-01
**Status note:** Illustrative Draft items. NOT production content, NOT calibration
evidence. Each item would resolve to a full package before production release,
authored by a qualified tutor and independently reviewed.

> Format reference: `docs/product/FACT_PACKS_AND_QUESTION_SETS.md` §5.

## Items

### Item 1 — MCQ (Easy · Calculate)

What is the pH of a 0.010 M solution of HCl (a strong acid)?

- A. 1.00
- **B. 2.00** ✔
- C. 0.010
- D. 12.00

*Key:* B. HCl fully dissociates, so `[H⁺] = 0.010 M` and
`pH = −log(0.010) = 2.00`.

### Item 2 — MCQ (Medium · Calculate)

Acetic acid has `Kₐ = 1.8 × 10⁻⁵`. What is its `pKₐ`?

- A. 5.00
- **B. 4.74** ✔
- C. 1.80
- D. 9.26

*Key:* B. `pKₐ = −log(1.8 × 10⁻⁵) = 4.74`.
*Distractor logic:* D reports `14 − pKₐ`; A rounds the exponent only; C reports
the mantissa.

### Item 3 — MCQ (Medium · Justify)

Two solutions are both 0.10 M: one HCl, one acetic acid. Which has the **higher**
pH, and why?

- **A. Acetic acid — it is a weak acid, so it only partially dissociates and
  produces less H⁺.** ✔
- B. HCl — strong acids produce more OH⁻.
- C. They are equal because the concentrations are equal.
- D. Acetic acid — weak acids do not produce any H⁺.

*Key:* A. Weak acids partially dissociate → lower `[H⁺]` → higher pH (guards
FP-CHEM-8.1-01 E4). D is wrong because weak acids still produce some H⁺.

### Item 4 — Short FRQ (Hard · Calculate, Justify)

Acetic acid has `Kₐ = 1.8 × 10⁻⁵`.

(a) Estimate the pH of a 0.10 M acetic acid solution, justifying the method.
(b) A buffer is made with equal concentrations of acetic acid and sodium acetate.
State its pH and the relationship you used.

*Expected response (development fixture, not a gold label):*
(a) Acetic acid is weak, so use `[H⁺] ≈ √(Kₐ·C) = √(1.8×10⁻⁵ × 0.10) =
√(1.8×10⁻⁶) = 1.3×10⁻³ M`; `pH = −log(1.3×10⁻³) ≈ 2.87`. (Justification: partial
dissociation, so the `Kₐ` approximation applies, not complete dissociation.)
(b) With `[A⁻] = [HA]`, Henderson–Hasselbalch gives `pH = pKₐ + log(1) = pKₐ =
4.74`.

*Criterion sketch:* C1 — weak-acid treatment justified and `[H⁺] ≈ √(Kₐ·C)`
applied (guards FP E6); C2 — correct pH ≈ 2.9; C3 — buffer recognized and
`pH = pKₐ = 4.74` via Henderson–Hasselbalch.
