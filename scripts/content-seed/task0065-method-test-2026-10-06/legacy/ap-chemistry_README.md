# AP Chemistry — Open Hand teaching items (legacy arm, method test 2026-10-06)

- **Items written:** 6 of 6 input topics (1.2, 1.3, 1.5, 2.1, 3.8, 3.9), course order.
- **Topics skipped:** none.
- **Seed use:** 4 of 6 (1.3, 1.5, 2.1, 3.9); 1.2 and 3.8 had no seed and were written from the brief and explainer. Each seeded item uses a different scenario, numbers and correct-answer idea from its seed.
- **Key-letter distribution:** A 1 · B 2 · C 2 · D 1.
- **Numeric items (1.2, 1.3, 3.8):** key and every distractor value computed in python3 before choice text was written; computations recorded in each item's `verification`.

## Self-check
- Exactly one `is_correct: true` per item; keys A–D present once each: pass.
- Blind re-solve from stem alone matched the key on all 6: pass.
- No near-copy of seeds (stems and correct choices compared): pass.
- Banned words ("Credited", "all of the above", "none of the above") and internal terms absent from student-facing text: pass.
- `python3 -c "import json;json.load(open('ap-chemistry.json'))"`: pass.

## Self-flags
- 1.3 distractor B (C₉H) is not a chemically sensible formula; kept as the direct result of the mass-ratio-as-mole-ratio slip.
- 1.5 choice C is a true statement that fails as reasoning; the stem asks for the explanation "that would earn the reasoning point" to keep it single-key. Correct choice A is marginally the longest (167 vs 165 chars).
- 3.9 distractor D touches the seed's concept (direction of travel in chromatography) in a different scenario.
- 1.2 uses real Ga-69/Ga-71 masses and abundances.
