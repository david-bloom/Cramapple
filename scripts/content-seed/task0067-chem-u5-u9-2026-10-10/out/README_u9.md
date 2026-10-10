# AP Chemistry Unit 9 Reference Pack batch (Development only)

Batch: `task0067-chem-u5-u9-2026-10-10` · Unit 9 Thermodynamics and Electrochemistry · run 2026-10-10.
Production was not touched.

## Inputs

- CED text: `$CED_TXT_DIR/ap-chemistry.txt` (pdftotext -layout), PDF pages **168-185** (printed Course Framework pp. 161-178).
  Page 185 ends with 9.11 (`EQN: I = q/t`). The lab section is not on these pages. Topics 9.1-9.11 are all present.
- Fact pack: `out/factpack_ap_chemistry_u9.md`.
- Scope reference: Unit 9 rows and the Reference Pack build protocol in
  `docs/product/AP_CHEMISTRY_CED_SCOPE_INVENTORY_2026_10_09.md` (main repo copy. The `chem-ref-u1` worktree has no copy).
- Models (unchanged; smoke-tested 2026-10-10): extractor `anthropic/claude-sonnet-5.5`; checkers
  `google/gemini-3.5-flash` and `openai/gpt-6-sol`; reject-only veto `anthropic/claude-haiku-5.5`.

## Controls (`controls_ap_chemistry_u9.json`), each checked against the CED text first

| id | defect | CED line it contradicts | result |
|---|---|---|---|
| ctrl-chem-u9-01-wrong-formula | ΔG° = +nFE° | 9.9.A.3 "EQN: ΔGo = −nFEo" | rejected (both N) |
| ctrl-chem-u9-02-excluded | positive/negative electrode signs (the content is correct but excluded) | 9.8 "Exclusion Statement: Labeling an electrode as positive or negative will not be assessed on the AP Exam." | rejected (both N) |
| ctrl-chem-u9-03-wrong-owner | ΔS°rxn from absolute entropies, owned by 9.3 | 9.2.A.1 "EQN: ΔSoreaction = ΣSoproducts − ΣSoreactants" | rejected (both N) |
| ctrl-chem-u9-04-wrong-list | ΔH/ΔS sign table with high T and low T swapped | 9.3.A.6 table: ">0 >0 … high T", "<0 <0 … low T" | rejected (both N) |
| ctrl-chem-u9-05-bad-hook | correct anode/cathode entry, hook "AN OX / RED CAT" expanded with the roles inverted | 9.8.A.3 "oxidation occurs at the anode and reduction occurs at the cathode" | hook rejected (0/1). The entry was accepted, which is expected for a correct entry |
| ctrl-chem-u9-06-other-unit | Henderson-Hasselbalch owned by 9.5 | Unit 9 pages contain no pKa/buffer text (grep 0 hits). 9.5.A.2 relates only K and ΔG° ("EQN: ΔG° = −RT ln K") | rejected (both N) |

**Result: 6/6 controls caught on the first run.** No control leaked, so no `*_controls_void.json` was needed.

## Counts

| round | candidates | accepted | rejected | hooks proposed | hooks accepted |
|---|---|---|---|---|---|
| 1 | 24 | 23 | 1 (r1-001) | 1 | 1 |
| 2 (stateless) | 1 | 0 | 1 (r2-001) | 0 | 0 |
| **loaded** | — | **23 entries** | 1 escalation | — | **1 hook** |

Entries by kind: convention 8, formula 8, list_sequence 3, vocabulary 3, diagram 1 (text-only, no asset).
Entries by owner topic: 9.1:1, 9.2:1, 9.3:5, 9.4:1, 9.5:3, 9.6:1, 9.7:2, 9.8:3, 9.9:2, 9.10:2, 9.11:2.
Hook: "An Ox, Red Cat" on r1-016 (oxidation at the anode, reduction at the cathode; public-domain-common, with a caution).
The other 22 entries have no hook, which is the normal outcome.
Schema-rejected rows: none.

## Escalations (to the Product Owner)

- **ap_chemistry-u9-r1-001 / r2-001: "Entropy increases with dispersal of matter" (9.1, 9.1.A.1).** Gemini accepted
  both rounds and GPT-6 Sol rejected both rounds (re-sampled each time). Sol's reasons, the same in both rounds:
  1. The gas-moles case is stated without the CED's qualifier "generally increases".
  2. The caution says a bare "disorder" statement "does not earn credit", which the CED does not state.
  3. In round 2 only: the reuse codes 9.2 and 9.3 are not supported.

  This is a real gap: 9.1.A.1 matter dispersal is the core of Topic 9.1. The rejection reasons are specific and backed by the CED text. Options: the Product Owner accepts the row, rejects it, or asks for a fresh batch-level re-extraction. Under the protocol there is no round 3. The row has not been hand-patched.

## Completeness: every Unit 9 inventory phrase has a disposition

| topic | phrase | disposition |
|---|---|---|
| 9.1 | entropy; dispersal of energy; entropy rises with temperature | accepted: r1-002 |
| 9.1 | dispersal of matter; phase, gas volume and gas-mole rules; particle-level justification; "avoid disorder" boundary | **escalated** (r1-001/r2-001). Uncovered until the Product Owner decides |
| 9.1 | microstate | excluded: the term never appears on CED pp. 168-185 (it occurs only in the fact pack) |
| 9.2 | standard molar entropy; standard entropy change; ΔS°rxn formula; tabulated data | accepted: r1-003 (matches the CED form, which has no explicit n coefficients) |
| 9.3 | thermodynamically favored/unfavored; "spontaneous" boundary | accepted: r1-004 |
| 9.3 | standard state | accepted: r1-005 |
| 9.3 | ΔG° from ΔGf° | accepted: r1-006 |
| 9.3 | Gibbs free energy; ΔG° = ΔH° − TΔS° | accepted: r1-007 |
| 9.3 | ΔH/ΔS sign cases and temperature dependence | accepted: r1-008 |
| 9.4 | kinetic control; activation barrier; favorability ≠ rate; "not at equilibrium" | accepted: r1-009 (body and caution) |
| 9.4 | thermodynamic control | consolidated into r1-009. The CED defines only "kinetic control" (9.4.A.2) |
| 9.5 | K = e^(−ΔG°/RT) | accepted: r1-010 |
| 9.5 | ΔG° = −RT ln K | accepted: r1-011 |
| 9.5 | sign and magnitude of ΔG° mapped to K vs. 1; equilibrium favorability | accepted: r1-012 |
| 9.6 | lattice disruption; solvent reorganization; solvation; enthalpy-entropy cancellation | accepted: r1-013 (3 items) |
| 9.6 | ΔG° = ΔH° − TΔS° applied to dissolution | consolidated: r1-007 carries topic code 9.6 |
| 9.7 | external energy source (electrical, light) | accepted: r1-014 |
| 9.7 | coupled reaction; shared intermediate; ATP/ADP; net ΔG° < 0 from the summed reactions | accepted: r1-015 (the CED gives no separate EQN for ΣΔG°) |
| 9.8 | anode; cathode; oxidation; reduction | accepted: r1-016, plus the hook |
| 9.8 | galvanic/voltaic vs. electrolytic | accepted: r1-017 |
| 9.8 | half-cell; salt bridge; external circuit/measuring device; electron/ion flow; cell diagrams | accepted: r1-018 (diagram, text-only) |
| 9.8 | positive/negative electrode labels | excluded: 9.8 Exclusion Statement (control 02 confirmed) |
| 9.9 | standard reduction potential; standard cell potential; E°cell from half-reactions; voltage sign ↔ favorability | accepted: r1-019 (prose. The CED gives no EQN for E°cathode − E°anode) |
| 9.9 | ΔG° = −nFE°; Faraday constant | accepted: r1-020. Note: the body is the bare formula, and F, n and E° are not defined in the row |
| 9.10 | Nernst equation (qualitative); "bare algorithmic Nernst is insufficient" boundary | accepted: r1-021 (with a caution) |
| 9.10 | nonstandard potential; reaction quotient; E = 0 at Q = K; Le Châtelier boundary | accepted: r1-022 (with a caution) |
| 9.11 | current; charge; I = q/t | accepted: r1-023 |
| 9.11 | electrolysis; electroplating; Faraday's law; charge ↔ mol e⁻ ↔ mass | accepted: r1-024 (5 items, from 9.11.A.1) |

**Quality note (not a defect the checkers flagged):** the formula rows r1-003, 006, 010, 011, 020, 021 and 023 contain
only the LaTeX expression. Symbol meanings and units, which protocol §4 asks for, are not in the row. This
needs a Product Owner or protocol decision before Production. It is not something to patch by hand.

## Cost (Unit 9 only; summed from the gateway `usage.cost` fields)

| stage | calls | USD |
|---|---|---|
| extract, rounds 1 and 2 (Sonnet 5.5) | 2 | 0.137 |
| Gemini 3.5 Flash | 37 | 0.587 |
| GPT-6 Sol | 40 | 0.767 |
| Haiku 5.5 veto | 29 | 0.058 |
| **total** | 108 | **≈ $1.55** |

## Dev load and verification

- Target check: `supabase db query --linked --workdir /Users/davidbloom/Documents/Cramapple.nosync --debug "select 1"`
  showed only `wmgjsdkphcyhngaffbqf` (Dev) and never `pcntajvbdfqhbeewmdry`. Unit 9 had 0 rows before the load.
- Loaded `out/load_ap_chemistry_u9.sql` (generated by load.py, not edited).
- Dev counts for ap_chemistry unit 9: **23 published entries** (convention 8, formula 8, list_sequence 3, vocabulary 3,
  diagram 1) and **1 published hook**.
- `scripts/qa/unit_reference_and_memory_hooks_qa.sql`, run one section at a time:
  - check 4 `zero_orphan_topic_codes`: ok=true
  - check 5 `owner_unit_matches_taxonomy`: ok=true
  - check 6 `published_hooks_have_published_entries`: ok=true
  - check 7 `published_at_present`: ok=true

## Files (all `_u9`)

`../controls_ap_chemistry_u9.json`, `candidates_ap_chemistry_u9{,_r2}.json`, `verdicts_ap_chemistry_u9{,_r2}.json`,
`round2_only_ap_chemistry_u9.json`, `selection_ap_chemistry_u9.json`, `load_ap_chemistry_u9.sql`,
`check_ap_chemistry_u9{,_r2}.log`. The raw JSONL logs are in `logs_check_ap_chemistry_u9/`, plus shared `logs_extract/` lines tagged `ap_chemistry_u9`. Do not commit them.
No git commit was made.
