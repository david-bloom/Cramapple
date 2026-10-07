# AP Biology — legacy-arm teaching items (TASK-0065 method test, 2026-10-06)

- **Items written:** 6 of 6 assigned topics (1.3, 1.7, 2.10, 2.3, 3.1, 3.3). One MCQ per topic.
- **Topics skipped:** none.
- **Seed use:** 4 of 6 items used the seed as a style/difficulty anchor (1.3, 1.7, 2.10, 2.3). 3.1 had no seed. 3.3's seed (apoptosis vs necrosis) is off-topic for Cellular Energy and was not used. No item reuses its seed's scenario or correct-answer idea.
- **Key-letter distribution:** A 2 (1.7, 3.3), B 1 (2.3), C 1 (1.3), D 2 (2.10, 3.1).

## Self-check

- Exactly one `is_correct: true` per item; keys A-D present once each (scripted check).
- Each item re-solved blind from the stem; answers match keys.
- Seed comparison: 1.3 (seed: sugar isomers) vs hydrolysis water count; 1.7 (seed: surface hydrophobic aggregation) vs H-bond disruption across structure levels; 2.10 (seed: double membrane as engulfment evidence) vs prokaryote/eukaryote compartmentalization contrast; 2.3 (seed: multipass protein orientation) vs phospholipid bilayer orientation.
- Banned words ("Credited", "all of the above", "none of the above"): none found.
- Choice lengths checked; correct choice is not reliably the longest (ties within a few characters in 3.1 and 3.3).
- JSON parses with `python3 -c "import json;json.load(open('biology.json'))"`.
- 1.3 count verified: unbranched chain of 10 monomers has 9 bonds, so 9 water molecules consumed.

## Self-flags

- 2.10: correct choice cites the DNA region (nucleoid) as a specialized internal region; the explainer does not name a specific region. Checker should confirm CED-scope acceptability.
- 1.7: light overlap with 3.2 denaturation language; answer rests on 1.7 structure levels.
- 3.3: seed off-topic, flagged and not used.
