# AP Calculus AB, units 5-8: Open Hand teaching items (TASK-0065 authoring stage)

- Slice: `unit_number between 5 and 8`, Production fact pack (read-only SELECT). Author family: Anthropic (Claude); no Anthropic checker stage.
- Gap topics returned: 42 (the spec's 69 is the whole-course figure). Items written: 42. Topics skipped: none.
- Output: `ap-calculus-ab_u5-8.json`, course order (5.1-5.12, 6.1-6.10, 6.14, 7.1-7.4, 7.6-7.8, 8.1-8.12). Topics 6.11-6.13 and 7.5 were not in the gap list.
- Seed use: 16 items had a seed in the fact pack (5.1, 5.2, 5.4, 5.5, 5.6, 5.11, 6.2, 6.4, 6.5, 6.6, 6.9, 7.7, 8.1, 8.4, 8.9, 8.11); each uses a different scenario, numbers, stem and correct value. `seed_used` is true for those 16.
- Correct-key distribution: A 11, B 10, C 10, D 11. Correct choice is the longest in 7 of 42 items.
- Every numeric key and distractor was computed with sympy/python before the choice text was written; scripts assert each value, and `verification` records the check. Non-calculator only; no figures.
- Self-check (exactly one correct, keys A-D, no banned phrases, JSON parses, stem order matches the fact pack) passes.

## Self-flags
- 5.9 is a reasoning item from a four-value table and relies on the stem's assumption that f'' keeps one sign; the local-maximum claim uses the Intermediate Value Theorem on f'.
- 5.2 uses x^(2/3) (cube-root domain is all reals); 6.10 and the logs assume x > -1 where stated.
- 6.14 and 7.1 are classification/modeling items with no numeric computation; 7.1's stem says k is "a constant", so a checker should confirm k(20 - T) is not offered as a distractor (it is not).
- 7.8 distractor "70 grams" is a weak named slip (subtracting 10 from 80); a checker may prefer a replacement.
- 8.8 covers semicircles only (not triangles), and 8.7 squares only; one item per topic per the spec.
