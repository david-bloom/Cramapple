# Short Question Set QS-CHEM-4.7-01 — Stoichiometry and Gas Laws

**Set ID:** QS-CHEM-4.7-01
**Set-Version:** v01
**State:** Drafted
**Subject:** CHEM
**Applies to:** [CHEM]
**Unit / Topic:** Unit 4 (Chemical Reactions) — mole ratios, gas stoichiometry
**Intended use:** diagnostic
**Linked fact pack:** FP-CHEM-4.7-01
**Status note:** Illustrative Draft items demonstrating the short-question-set
format. NOT production content, NOT calibration evidence. Each item would resolve
to a full MCQ/FRQ package (`CONTENT_AUTHORING_AND_PROMPT_ARCHITECTURE.md` §8/§9)
before any production release, authored by a qualified tutor and independently
reviewed.

> Format reference: `docs/product/FACT_PACKS_AND_QUESTION_SETS.md` §5.

## Items

### Item 1 — MCQ (Easy · Calculate)

How many moles of molecules are present in 36.0 g of water (H₂O, molar mass
18.02 g·mol⁻¹)?

- A. 0.500 mol
- B. 1.00 mol
- **C. 2.00 mol** ✔
- D. 36.0 mol

*Key:* C. `n = m / M = 36.0 / 18.02 = 2.00 mol`.
*Distractor logic:* A halves incorrectly; B forgets to divide by molar mass
consistently; D reports grams as moles.

### Item 2 — MCQ (Medium · Calculate)

A rigid 2.00 L vessel contains 0.500 mol of an ideal gas at 300 K. What is the
pressure? (`R = 0.08206 L·atm·mol⁻¹·K⁻¹`)

- A. 1.03 atm
- B. 3.08 atm
- **C. 6.15 atm** ✔
- D. 12.3 atm

*Key:* C. `P = nRT/V = (0.500)(0.08206)(300)/2.00 = 6.15 atm`.
*Distractor logic:* D omits dividing by volume; B mis-halves; A divides by n.

### Item 3 — MCQ (Easy · Calculate)

For `2 H₂ + O₂ → 2 H₂O`, how many moles of water form from 3.0 mol H₂ with excess
O₂?

- A. 1.5 mol
- **B. 3.0 mol** ✔
- C. 6.0 mol
- D. 0.5 mol

*Key:* B. Mole ratio H₂O : H₂ = 2 : 2 = 1, so 3.0 mol H₂ → 3.0 mol H₂O.
*Distractor logic:* A applies an O₂-based ratio; C doubles; D inverts the ratio.

### Item 4 — Short FRQ (Medium · Calculate, Justify)

Ammonia forms by `N₂ + 3 H₂ → 2 NH₃`. A reaction vessel is charged with 1.0 mol
N₂ and 2.0 mol H₂.

(a) Identify the limiting reactant and justify your choice.
(b) Calculate the maximum moles of NH₃ that can form.

*Expected response (development fixture, not a gold label):*
(a) Divide available moles by each coefficient: N₂ → 1.0/1 = 1.0; H₂ → 2.0/3 =
0.67. H₂ gives the smaller value, so **H₂ is limiting**.
(b) `n(NH₃) = 2.0 mol H₂ × (2 NH₃ / 3 H₂) = 1.33 mol NH₃`.

*Criterion sketch:* C1 — correct per-coefficient comparison identifying H₂
(guards the `limiting reactant identified` boundary in FP-CHEM-4.7-01 E6);
C2 — correct mole ratio applied to the limiting reactant to reach ≈1.3 mol NH₃.
