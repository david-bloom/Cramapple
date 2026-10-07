# AP Statistics: legacy-arm teaching items (TASK-0065 method test, 2026-10-06)

- **Items written:** 6 of 6 assigned topics (1.10, 2.12, 3.1, 3.12, 3.15, 3.6), one MCQ each, in the order given in the inputs file.
- **Topics skipped:** none.
- **Seed use:** 4 of 6 (1.10, 3.1, 3.15, 3.6). 2.12 and 3.12 had no seed, so they were written from the brief and explainer. Each seeded item uses a different scenario, different numbers and a different correct-answer idea from its seed.
- **Key-letter distribution:** A 2 (2.12, 3.6), B 2 (1.10, 3.12), C 1 (3.15), D 1 (3.1).
- **Numeric work:** every numeric key and distractor was computed in python3 before the choice text was written: 18/√50 ≈ 2.55; pooled 91/500 = 0.182 against the unweighted average 0.19; expected counts 6/24/18/72; cell contributions 2.67, 1.6 and 0.67. The computations are recorded in each item's `verification`.

## Self-check (author pass)
- Each item has exactly one `is_correct: true`, and keys A–D each appear once per item (checked by script).
- Each item was re-solved blind from the stem; every answer matched its key.
- No near-copies of seeds: the stems and correct ideas differ.
- Banned phrases ("Credited", "all of the above", "none of the above") and internal terms are absent (checked by script).
- `python3 -c "import json;json.load(open('ap-statistics.json'))"` parses.
- Choice lengths are roughly balanced. In 3.6 the correct choice A is the longest, but D is close to it.

## Self-flags
- **2.12:** the correct choice and distractor D quote σ/√n ≈ 2.5. The brief only says that the spread tightens. The formula is formalized in later sampling-distribution topics, so a checker should confirm it is in scope.
- **3.1:** the key letter (D) is the same as the seed's key letter. The correct idea is the opposite: this item's answer is unbiased, the seed's is biased.
- **3.6:** the correct choice is the longest one.
