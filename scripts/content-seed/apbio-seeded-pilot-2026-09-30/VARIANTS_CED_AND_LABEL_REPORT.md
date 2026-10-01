# AP Biology Units 1-2: variants, CED conformance and label inheritance (round 1, 2026-10-01)

16 class-A variants (14 + 2 from the repaired seed `APBIO-MCQ-023`), checked by `google/gemini-3.5-flash` and `deepseek/deepseek-v4-pro` (CED) and `google/gemini-3.5-flash` (labels, 2 samples), run by the Product Owner.
Raw: `out_math_023/`, `out_ced/results.jsonl` (32 calls), `out_labels/labels.jsonl` (48 calls). All calls succeeded with structured output.
The two `023` variants passed the content check: 8 of 8 calls, both models solved to the key, 0 flags.

## CED conformance (fact pack: `docs/product/AP_BIOLOGY_CED_FACT_PACK.md`)
| | fully in scope | out-of-scope flag |
|---|---|---|
| Gemini 3.5 Flash | 15 | 1 (`sv-014-v1`) |
| DeepSeek V4 Pro | 5 | 11 |
DeepSeek flags far more, as in the Calc pilot. Each flag was adjudicated by hand against the pack, not by vote. **The pack is a topic-level map, not a vocabulary list:** it has 0 mentions of 70S/80S, integral/peripheral, signal peptide/SRP, clathrin, endosome, proteasome or NLS,
and the *published seeds already use* several of them (014: 70S/80S; 021: SRP; 023: integral/peripheral and detergent; 018: clathrin; 022: 70S, binary fission). A term being absent from the pack therefore cannot by itself fail a variant. Two cases were different and were real:

1. **`sv-005-v2` (leucine vs isoleucine): REAL.** Pack line 380: "Exclusion: specific amino acid molecular structure beyond scope." The item turned on exactly that. Only DeepSeek caught it. Rewritten (below).
2. **`sv-021-v2` (nuclear localization signal): REAL, scope departure.** Nuclear import (NLS, importins, pore size cutoff, plus proteasome and default-ER-entry in the distractors) is a different mechanism from the seed's ER targeting and is not in the pack. Replaced by the converse of the seed (adding a signal peptide to a cytoplasmic enzyme), which stays inside the seed's concept.
3. **`sv-014-v1` (the only item both models flagged): 70S/80S.** Gemini itself noted the answer does not depend on it. Not required, not in the pack, so removed from `sv-014-v1` and, for consistency, `sv-014-v2` (which both models had passed despite the same wording, a sign of noise).

Flags I judged **acceptable** (concept inherited from the published seed, or fully supplied by the stimulus): `005-v1` ("stereoisomer"; reworded to "isomer", which the pack uses), `008-v1` (disulfide bonds; the pack mentions them), `018-v1`/`018-v2` (receptor-mediated endocytosis, clathrin, endosome, LDL, transferrin; the seed carries the first four, the stimulus supplies the rest), `021-v1` (SRP, from the seed), `022-v1` (70S/80S, antibiotic sensitivity, binary fission; from the seed), `023-v1`/`023-v2` (integral vs peripheral, detergent, protease assay; from the seed, techniques defined in the stimulus).
**Open for the Learning Quality Owner (Orly), not settleable by search:** whether the terms the seeds already use (SRP, 70S/80S, integral/peripheral, clathrin) are within the AP Biology CED as the exam treats it. That question is about the existing library, not these variants.

## Label inheritance
Gemini 3.5 Flash, blind, 2 samples per item. Seeds were probed too.
| Variant vs its seed's probe label | match |
|---|---|
| Required units | **28 of 32** |
| Primary topic | 27 of 32 |
| Difficulty | 24 of 32 (every variant said Medium; seeds spanned Easy to Hard) |
Every unit and topic miss was a design flaw of mine: `sv-005-v1`/`v2` moved from Unit 1 to Unit 3 (topic 3.1 Enzymes) because I turned the seed's transport protein into an enzyme (galactokinase, aminoacyl-tRNA synthetase). That would have changed *when the item is served*. The other 12 variants kept the seed's unit. Rewritten with a transport/binding protein (below). Difficulty remains coarse, as in Calc.

**The seeds' own stored topic tags look wrong.** Production's provisional topic tag differs from the blind probe on 5 of 8 seeds:
| Seed | Production (provisional) | Probe (2/2 samples) |
|---|---|---|
| `APBIO-MCQ-005` | 1.3 | 1.4 Carbohydrates |
| `APBIO-MCQ-008` | 1.1 Structure of Water | 1.7 Proteins |
| `APBIO-MCQ-014` | 2.1 | 2.9 Cell Compartmentalization |
| `APBIO-MCQ-018` | 2.5 | 2.8 Mechanisms of Transport |
| `APBIO-MCQ-022` | 2.1 | 2.10 Origins of Cell Compartmentalization |
`016`, `021`, `023` agree. All eight seeds sit in the right unit, so unit gating is unaffected. This is Finding 4 of the protocol (a mislabelled seed multiplies its error). One model, two samples: **do not change Production from this**; label the seeds with three-model consensus first, then let variants inherit.

## Patches made (round 2 to re-check in full, per the protocol)
| Variant | Change | Reason |
|---|---|---|
| `sv-005-v1` | enzyme framing -> bacterial transport protein; "isomers" | Unit drift; term |
| `sv-005-v2` | amino acids -> mannose/glucose and a bacterial surface protein | explicit CED exclusion; Unit drift |
| `sv-014-v1`, `sv-014-v2` | removed 70S/80S details | not needed, not in pack |
| `sv-021-v2` | nuclear import -> signal peptide added to a cytoplasmic enzyme | scope departure |
Letters, the other 11 variants and the three label-agnostic checks are unchanged. `variants_recheck2_items.json` holds the five; `recheck2_keys.txt` their keys.
