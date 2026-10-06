# AP Statistics Open Hand teaching batch (rkey ap-statistics)

- Gap topics returned by the fact pack: 41 (29 in units 1-3 numbering block, 12 in units 4-5). Items written: 41. Topics skipped: none.
- Seed present in the fact pack and used as style/difficulty anchor only: 24 items (seed_used = true). 17 topics had no seed. Every item uses a different scenario, numbers and correct idea from its seed.
- Correct-key distribution: A 10, B 11, C 10, D 10.
- Numeric items (1.3, 1.4, 1.8, 1.9, 2.2, 2.4, 2.5, 2.8, 2.11, 2.12, 3.3, 3.7, 3.9, 3.10, 3.12, 3.13, 3.15, 4.5, 4.6, 4.10, 5.2, 5.4): key and every distractor value computed in Python; recorded in `verification`.
- Self-check run: one correct per item, keys A-D once each, no banned phrases, JSON parses, 41 topics match the fact pack.

## Self-flags
- Correct choice is the strictly longest in about 12 of the ~29 prose items (margins mostly small). Checkers may want to rebalance lengths.
- 4.5: p-value 0.015 for t = 2.30, df = 24 (one-sided) was computed by numerical integration of the t density (0.0152), not a table.
- 3.10: interval endpoints rounded to three decimals ((0.174, 0.426) from 0.1745 / 0.4255).
- Several topics (1.1, 3.1, 3.6, 3.11, 4.4, 4.9, 5.1, 5.5) are conceptual; verification cites the brief/explainer fact.
- 1.4 stem assumes the reader accepts a text description of two bar charts rather than a figure.
