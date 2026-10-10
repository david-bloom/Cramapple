# AP Chemistry Unit 8 (Acids and Bases): Reference Pack batch, Development only

Batch: `task0067-chem-u5-u9-2026-10-10`. Date: 2026-10-10. Production was **not** touched.

## Inputs

- CED: `ap-chemistry.txt` (CED_TXT_DIR scratchpad), PDF pages 148-167 (printed Course Framework pp.146-159, topics 8.1-8.11).
- Fact pack: `out/factpack_ap_chemistry_u8.md`.
- Scope/completeness checklist: Unit 8 rows of `docs/product/AP_CHEMISTRY_CED_SCOPE_INVENTORY_2026_10_09.md` and its Reference Pack build protocol. This file is in the main checkout; it is not in the `chem-ref-u1` worktree.
- Roster (unchanged, smoke-tested today): extractor `anthropic/claude-sonnet-5.5`; checkers `google/gemini-3.5-flash` and `openai/gpt-6-sol`; reject-only veto `anthropic/claude-haiku-5.5`.
- Files: `controls_ap_chemistry_u8.json`, `out/candidates_ap_chemistry_u8.json` (r1, 34), `out/candidates_ap_chemistry_u8_r2.json` (r2, 13), `out/verdicts_ap_chemistry_u8{,_r2}.json`, `out/round2_only_ap_chemistry_u8.json`, `out/selection_ap_chemistry_u8.json`, `out/load_ap_chemistry_u8.sql`, `out/check_ap_chemistry_u8{,_r2}.log`.

## Controls (planted, verified against the CED text before the run)

| id | defect | CED line that the defect contradicts | caught |
|---|---|---|---|
| ctrl-chem-u8-01-wrong-formula | Henderson-Hasselbalch with the ratio inverted, [HA]/[A−] | 8.9.A.1 (p.157): "EQN: pH = pKa + log [A−]/[HA]" | yes: both checkers N |
| ctrl-chem-u8-02-excluded | a formula for the new buffer pH after adding strong acid | 8.9 Exclusion: "Computation of the change in pH resulting from the addition of an acid or a base to a buffer will not be assessed on the AP Exam." | yes: both N |
| ctrl-chem-u8-03-wrong-owner | "Acid-base indicator" owned by 8.2 | 8.7.A.2 (p.155): "Acid-base indicators are substances that exhibit different properties (such as color) in their protonated versus deprotonated state" | yes: both N |
| ctrl-chem-u8-04-bad-hook | correct pH/pKa entry; the hook expands "below pKa" to mean the deprotonated form dominates | 8.7.A.1: "When solution pH < acid pKa, the acid form has a higher concentration than the base form." | yes: entry accepted, hook rejected (0/1) |
| ctrl-chem-u8-05-wrong-member | HF substituted for HI in the strong-acid list | 8.2.A.1 (p.147): "(e.g., HCl, HBr, HI, HClO4, H2SO4, and HNO3) will completely ionize" | yes: both N |
| ctrl-chem-u8-06-other-unit | ΔG° = −nFE° (Unit 9.9) placed in 8.4 | pp.148-167 contain no Faraday constant, cell potential or nFE (verified by text search) | yes: both N |

**Controls: 6/6 rejected.** No control leaked, so no void file was needed. Controls were run in round 1 only.

## Counts

| Round | Extracted | Accepted | Rejected | Hooks proposed | Hooks accepted |
|---|---|---|---|---|---|
| R1 | 34 | 21 | 13 (10 veto-only, 3 by GPT-6 Sol) | 0 | 0 |
| R2 (stateless) | 13 | 8 | 5 → escalated | 0 | 0 |
| **Loaded to Dev** | — | **29** (12 convention, 8 formula, 5 list_sequence, 4 vocabulary) | 5 escalations | — | **0** |

Every Unit 8 entry has a "no hook" outcome: the extractor proposed none in either round. This is a recorded outcome, not missing work. No rows were schema-rejected by load.py.

## Escalations (still rejected after round 2; Product Owner decision needed)

| candidate | title | rejected by | reason (short) |
|---|---|---|---|
| ap_chemistry-u8-r2-004 | Base ionization constant, Kb | Haiku veto (both checkers accepted) | topic_codes: the veto says 8.4 does not use Kb. GPT-6 Sol cites 8.4.A.2's A−/OH− hydrolysis equilibrium as a use. This is a reuse-tag dispute. |
| ap_chemistry-u8-r2-008 | Weak base + strong acid: three cases | GPT-6 Sol (twice) | It writes → where the 8.4.A.3 text shows ⇌, and says "excess" for the equimolar case. Note: in the PDF text extraction, the 8.4.A.2 arrow glyph is missing, so the arrow claim needs a check against the PDF. |
| ap_chemistry-u8-r2-009 | Titration curve (pH vs. volume of titrant), diagram | GPT-6 Sol (twice) | It drops the "monoprotic" limit on the equal-moles rule (8.5.A.2), and gives [HA]=[A−] without the "for a weak acid" scoping (8.5.A.3). |
| ap_chemistry-u8-r2-011 | Buffer solution | Haiku veto (both checkers accepted) | Owner: the veto says buffers are first required in 8.4 (8.4.A.2 "a buffer solution is formed"), not 8.8. |
| ap_chemistry-u8-r2-012 | Henderson-Hasselbalch equation | Haiku veto (both checkers accepted) | Owner: the veto says 8.9 (where the EQN is stated); the extractor chose 8.4 (first use, "see 8.9.A.1"). |

PO ownership calls are needed for r2-011 and r2-012: whether the owner is the first-use topic or the defining topic. The R1 rejections of the same entries hit the same dispute, in the other direction for H-H. The build protocol says "assign the entry to the first topic that requires it", which supports the extractor's 8.4. Until these are decided, **Unit 8 has no H-H equation, no Kb formula, no buffer definition, and no titration-curve entry in Dev.** An accepted PO decision would go through `load.py --po-accept`.

## Completeness disposition (Unit 8 inventory phrases)

| Topic | Phrase | Disposition |
|---|---|---|
| 8.1 | acid; base | Excluded as standalone vocabulary: 8.1 has no CED definition of them (no EK defines acid/base); they are used within other entries |
| 8.1 | hydronium; hydroxide | Consolidated into "H+(aq) and H3O+(aq) are interchangeable" and the pH/pOH definitions |
| 8.1 | autoionization; Kw | Accepted: "Water autoionization constant, Kw" (r2-002) |
| 8.1 | neutral solution; neutrality ≠ pH 7 off 25°C; Kw temperature-dependent | Accepted: "Neutral water and temperature" (r2-001) |
| 8.1 | pH = −log[H3O+]; pOH = −log[OH−] | Accepted: "pH definition", "pOH definition" |
| 8.1 | pH + pOH = 14 at 25°C | Accepted: "pKw, pH and pOH at 25°C" (r1-004). **Duplicate**: r2-002 also contains pKw = 14 = pH + pOH. Needs dedup |
| 8.1 | H3O+ preferred, H+ accepted | Accepted: r1-006 |
| 8.2 | strong acid; complete ionization; [H3O+] stoichiometry | Accepted: "Strong acids named in the CED" |
| 8.2 | strong base; Group II gives 2 OH− | Accepted: "Strong base: [OH−] from group I vs group II hydroxides" (r2-003) |
| 8.3 | weak acid/base | Accepted: "Weak acid/base: only a small fraction ionizes" |
| 8.3 | Ka; pK = −log K | Accepted: "Acid ionization constant, Ka" (r2-006, includes pKa). **Duplicate**: r1-010 "pKa". Needs dedup |
| 8.3 | Kb | **Escalated** (r2-004). pKb was accepted separately (r2-005) |
| 8.3 | KaKb = Kw; pKa + pKb = pKw; conjugate pair | Accepted: "Conjugate pair: Ka, Kb and Kw" (r2-007) |
| 8.3 | percent ionization | Accepted: r1-015 |
| 8.3 | ICE tables | Excluded: a representation/method, not a reference entry |
| 8.4 | neutralization; strong/strong stoichiometry; excess reagent | Accepted: "Strong acid + strong base mixing" |
| 8.4 | weak/strong case split; hydrolysis at equivalence | Accepted: "Weak acid + strong base: three cases". The weak base + strong acid version is **escalated** (r2-008) |
| 8.4 | (weak + weak) | Accepted: "Weak acid + weak base mixing" |
| 8.4 | buffer | **Escalated** (r2-011) |
| 8.5 | titration curve | **Escalated** (r2-009, diagram) |
| 8.5 | equivalence point; moles titrant = moles analyte | Accepted: "Equivalence point" |
| 8.5 | half-equivalence; pH = pKa | Accepted: "Half-equivalence point and pKa" |
| 8.5 | major species at equivalence | Accepted: "pH at the equivalence point by titration type" |
| 8.5 | monoprotic/polyprotic; polyprotic boundary | Accepted: "Polyprotic acid titration curves" (r2-010). No concentration calculation is included, per the exclusion |
| 8.6 | conjugate-base stability; inductive effect; resonance; stronger acid ↔ stabilized base | Accepted: "Structure and acid/base strength" |
| 8.6 | carboxylic acid; nitrogenous base | Accepted: "Common weak acid and weak base classes" |
| 8.7 | protonated/deprotonated form; pH vs pKa dominance | Accepted: "Predominant form: compare pH to pKa" |
| 8.7 | acid-base indicator | Accepted: r1-028 |
| 8.7 | transition range; indicator choice | Accepted: "Choosing an indicator for a titration" (the CED states pKa ≈ equivalence pH; no "transition range" EK) |
| 8.8 | buffer; conjugate acid/base consume added base/acid; pH resistance | **Escalated** with "Buffer solution" (r2-011) |
| 8.9 | Henderson-Hasselbalch; buffer ratio | **Escalated** (r2-012) |
| 8.9 | small additions barely change ratio/pH | Accepted: r2-013 |
| 8.9 | derivation; pH-change-on-addition calculation | Excluded by the CED Exclusion Statements (control 02 confirmed checkers enforce it) |
| 8.10 | buffer capacity; fixed ratio sets pH; larger concentrations ↑ capacity; asymmetric capacity | Accepted: "Buffer capacity and component concentrations" |
| 8.10 | optimal buffer range | Excluded: not stated in the 8.10 EKs |
| 8.11 | acid-dependent solubility; basic anion; hydroxide salt; Le Châtelier qualitative | Accepted: "pH-sensitive solubility of salts" |
| 8.11 | solubility-vs-pH calculations | Excluded by the CED Exclusion Statement |

Open completeness items:

1. Five escalations, listed above.
2. Two cross-round duplicates are loaded: pKa appears in r1-010 and inside r2-006, and pKw = pH + pOH appears in r1-004 and inside r2-002. Each pair has different titles, so both rows of each pair were inserted. Retiring one row of each pair is a PO/protocol decision. No hand-edit was made.

## Cost (Unit 8 only; it is separable through the per-unit log directory and the extract tag)

| Model | Calls | Prompt tok | Completion tok | Cost (USD) |
|---|---|---|---|---|
| claude-sonnet-5.5 (extract, 2 rounds) | 2 | 36,280 | 13,827 | 0.21 |
| gemini-3.5-flash | 60 | 578,711 | 47,465 | 0.99 |
| gpt-6-sol | 65 | 587,721 | 23,253 | 1.45 |
| claude-haiku-5.5 (veto) | 68 | 950,166 | 96,049 | 0.14 |
| **Total** | 195 | | | **≈ $2.79** |

## Development load and verification

- Before loading, `supabase db query --linked --workdir /Users/davidbloom/Documents/Cramapple.nosync --debug` showed `wmgjsdkphcyhngaffbqf` (Dev) 10 times and `pcntajvbdfqhbeewmdry` (Prod) 0 times.
- Dev had 0 Unit 8 rows before the load. `out/load_ap_chemistry_u8.sql` was loaded with `-f` from the main checkout's workdir.
- Dev now has ap_chemistry unit 8 = **29 published** (convention 12, formula 8, list_sequence 5, vocabulary 4). All 29 have `published_at`. Unit 8 hooks = 0.
- QA (`scripts/qa/unit_reference_and_memory_hooks_qa.sql`, each section run on its own): 4 zero_orphan_topic_codes **ok=true**; 5 owner_unit_matches_taxonomy **ok=true**; 6 published_hooks_have_published_entries **ok=true**; 7 published_at_present **ok=true**.
- No git commit was made. Raw logs (`logs_check_ap_chemistry_u8/`, `logs_extract/`) must not be committed.
