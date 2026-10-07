# AP Calculus AB — legacy-arm teaching items (TASK-0065 method test, 2026-10-06)

- **Items written:** 6 of 6 input topics (1.3, 1.9, 1.12, 1.14, 1.15, 2.3), in course order.
- **Topics skipped:** none.
- **Seed use:** 5 of 6 (1.9 had no seed). Each seeded item uses a different scenario, function/numbers and correct-answer idea from its seed.
- **Key-letter distribution:** A 1, B 2, C 2, D 1.
- **Numeric verification:** every key and numeric distractor computed in python3 (sympy limits / continuous_domain / factor; Fraction for the 2.3 table) before choice text was written; computations recorded in each item's `verification`.

## Self-check
- Exactly one `is_correct: true` per item; keys A–D once each: pass.
- Blind re-solve of each stem matches the key: pass.
- No near-copy of seeds (stems and correct choices compared): pass.
- Banned words ("Credited", "all of the above", "none of the above") and internal terms: none found.
- JSON parses with `python3 -c "import json;json.load(open('ap-calculus-ab.json'))"`: pass.
- Correct choice is the longest in 3 items (1.3, 1.9, 1.14) but by small margins (1–9 characters).

## Self-flags
- 1.3: graph is described in words (no figure needed).
- 2.3: choice B (inverted quotient) is labeled "°C per minute" for parallel form; its true units would be minutes per °C, which the rationale states. Checker may prefer a different label.
- 2.3: stem fixes the method (nearest times on each side) so one-sided estimates are not competing answers; neither one-sided value (−7/3, −2) appears as a choice.
