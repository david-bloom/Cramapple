# AP Biology units 5-8: Open Hand teaching items (author stage)

- Date: 2026-10-06. Author: Claude (Anthropic family). Not yet checked by outside-family checkers.
- Output: `biology_u5-8.json` (32 items, course order).
- Topics in slice (published briefs with no active teaching item, units 5-8): 32. Items written: 32. Skipped: none.
  - Unit 5: 5 (5.1-5.5). Unit 6: 8 (6.1-6.8). Unit 7: 12 (7.1-7.12). Unit 8: 7 (8.1-8.7).
- Seed present for 14 topics (5.1, 5.4, 6.3, 6.5, 6.8, 7.1, 7.2, 7.9, 7.10, 7.12, 8.2, 8.3, 8.5, 8.6); `seed_used: true` on those. Each uses a different scenario, stem, and correct-answer idea from its seed.
- Correct-key distribution: A 8, B 8, C 8, D 8.
- Choice length: correct choice is the longest in 4 of 32 items and the shortest in 9.
- Self-check run: one correct per item, keys A-D once each, no banned phrases, JSON parses.

## Self-flags
- 7.5 (Hardy-Weinberg) and 8.2 (energy) and 7.4 (allele frequency) are numeric; values computed by hand and recorded in `verification` (7.5: q^2=0.16, q=0.4, p=0.6, 2pq=0.48; 8.2: 40000 x 0.1 x 0.1 = 400; 7.4: 80/200 = 0.4).
- 7.9 gives the tree as nested text notation instead of a figure; checker should confirm it is unambiguous.
- 7.7 uses illustrative percent-identity numbers, not tied to a real protein.
- 8.3 gives a population count list in the stem instead of a graph.
- 6.5 tests only the repressor/operator logic, not the glucose/CAP effect.
- 5.4 seed was incomplete dominance; the item uses codominance (different correct idea).
