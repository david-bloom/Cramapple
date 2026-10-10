# AP Chemistry Unit 6 (Thermochemistry): Reference Pack batch, Development only

Batch: `task0067-chem-u5-u9-2026-10-10` · Run date: 2026-10-10 · Target: **Development** (`wmgjsdkphcyhngaffbqf`). Production was not touched.

## Inputs

- CED pages 114–129 (pdftotext dump, `CED_TXT_DIR` scratchpad `ap-chemistry.txt`). These are printed Course Framework pp. 107–121, Topics 6.1–6.9.
- Fact pack: `out/factpack_ap_chemistry_u6.md`
- Scope: Unit 6 rows of `docs/product/AP_CHEMISTRY_CED_SCOPE_INVENTORY_2026_10_09.md`, plus its Reference Pack build protocol. The file is in the main checkout. The `chem-ref-u1` worktree does not have a copy.
- Model slate (smoke-tested earlier today):
  - Extractor: `anthropic/claude-sonnet-5.5`
  - Checkers: `google/gemini-3.5-flash` and `openai/gpt-6-sol`
  - Reject-only veto: `anthropic/claude-haiku-5.5`
- Scripts: `extract.py`, `check.py`, `load.py` in this folder, run unmodified.

## Controls (`controls_ap_chemistry_u6.json`)

Each defect was checked against the CED text before the run.

| id | Defect | CED line used to verify it | Result |
|---|---|---|---|
| ctrl-chem-u6-01-wrong-formula | ΔH° = ΣΔHf°(reactants) − ΣΔHf°(products), reversed | 6.8.A.1 "EQN: ΔH°reaction = ΣΔHf °products − ΣΔHf °reactants" | rejected by both checkers |
| ctrl-chem-u6-02-excluded | ΔH = ΔE + PΔV, enthalpy vs internal energy (6.6) | 6.6 Exclusion Statement: "technical distinctions between enthalpy and internal energy will not be assessed" | rejected by both checkers |
| ctrl-chem-u6-03-wrong-owner | Bond-energy ΔH estimate owned by 6.8 | LO 6.7.A "...based on the average bond energies of bonds broken and formed" | rejected by both checkers (owner should be 6.7) |
| ctrl-chem-u6-04-wrong-member | Hess's law rule ii: "ΔH is divided by c" | 6.9.B.2 ii "the enthalpy change is multiplied by the same factor c" | rejected by both checkers |
| ctrl-chem-u6-05-bad-hook (hook) | Correct q = mcΔT entry. Its hook expands m as "molar mass" | 6.4.A.1 "EQN: q = mcΔT"; LO 6.4.A "amount of the substance" | entry accepted (correct), hook rejected by both checkers |
| ctrl-chem-u6-06-other-unit | ΔG° = ΔH° − TΔS° (Unit 9) | none of "Gibbs", "entropy" or "ΔG" appears on pp. 114–129 | rejected by both checkers |

**Controls: 6/6 caught. The batch is valid.** No controls were replaced, so there are no `*_controls_void.json` files.

## Counts

| Stage | Candidates | Accepted | Rejected | Hooks proposed | Hooks accepted |
|---|---|---|---|---|---|
| Round 1 | 21 (6 vocabulary, 8 convention, 2 list_sequence, 1 diagram, 4 formula) | 20 | 1 (r1-017) | 0 | 0 |
| Round 2 (stateless) | 1 | 0 | 1 (r2-001) | 0 | 0 |
| **Loaded** | — | **20 entries** | **1 escalation** | — | **0 hooks** |

No hooks: the extractor proposed none for Unit 6. This is a "no hook" result, kept on record, not missing work. The only hook in the run was the planted control.

In round 1, all 20 rows that both checkers accepted also passed the Haiku veto. `load.py` schema-rejected no rows.

## Escalation (Product Owner decision needed)

**ap_chemistry-u6-r1-017 / r2-001, "Direction of thermal energy flow in a reaction"** (convention, owner 6.6, CED 6.6.A.2)

- Gemini accepted it in both rounds.
- GPT-6 Sol rejected it in both rounds, on both samples. The facts are correct, but Sol says the owner topic should be **6.1**, because 6.1.A.3 first requires the system-to-surroundings direction.
- The veto did not run, because only one checker accepted.

This is an ownership dispute only. The PO can:
- accept it with owner 6.6 (6.6.A.2 is where the CED states this for reactions);
- re-own it to 6.1; or
- drop it, because accepted rows 001/002 (exothermic and endothermic, owner 6.1, tagged 6.6) already cover the same 6.1.A.3 content. **This is the recommended option.**

Full reasons are in `out/selection_ap_chemistry_u6.json`.

## Completeness disposition (Unit 6 inventory phrases)

Entry numbers below refer to round-1 candidates (`ap_chemistry-u6-r1-NNN`).

| Topic | Phrase | Disposition |
|---|---|---|
| 6.1 | endothermic / exothermic | accepted 002 / 001 |
| 6.1 | system; surroundings; heat; work | consolidated into 001/002, which define them via "heat transfer from/work done by the system… surroundings". No standalone definition: the CED pages give none. |
| 6.1 | q_system = −q_surroundings | consolidated into 001/002 (6.1.A.3: energy lost by the system is gained by the surroundings) and 010 (first law). The CED prints no equation for it, and no separate formula row was extracted. **Open for PO:** whether a standalone formula row is wanted. |
| 6.1 | infer energy flow from temperature or particle interactions | accepted 003 (solution formation), 012, 016 (caution) |
| 6.1 | (6.1.A.4 dissolution) | accepted 003 |
| 6.2 | potential energy; enthalpy change; reactants; products; energy diagrams | accepted 005 (diagram, text-only, no visual asset) |
| 6.2 | ΔH = H_products − H_reactants | consolidated into 005 (compares the starting and ending levels) and 016. 6.2.A.1 prints no EQN. |
| 6.3 | heat transfer; thermal energy; temperature | accepted 006 |
| 6.3 | thermal equilibrium; average kinetic energy; higher-to-lower T flow | accepted 007 (caution covers the warmer body's greater average KE) |
| 6.3 | temperature–time behavior | no entry. 6.3 EK text does not mention it. Covered conceptually by 007. |
| 6.4 | q = mcΔT | accepted 008 |
| 6.4 | specific heat capacity / molar heat capacity / heat capacity | accepted 009 |
| 6.4 | first law | accepted 010 (reused in 6.9) |
| 6.4 | q_lost + q_gained = 0 | consolidated into 010. 6.4 prints no equation for it, and no separate formula row was extracted. **Open for PO**, together with the 6.1 item. |
| 6.4 | calorimeter / calorimetry data analysis | consolidated into 008 (caution: whole-solution mass), 011 and 012. No standalone "calorimeter" vocabulary entry. |
| 6.4 | (6.4.A.6 three ways energy changes) | accepted 004 |
| 6.5 | enthalpy of fusion, vaporization, condensation, freezing; sign reverses | accepted 015 |
| 6.5 | q = nΔH_phase | accepted 013 (shared with 6.6) |
| 6.5 | constant temperature during a phase change; heating-curve plateaus | accepted 014. No separate heating-curve diagram entry: the 6.5 EK text does not name a heating curve. |
| 6.6 | enthalpy of reaction; constant pressure; ΔH = q_p; sign meaning | accepted 016 |
| 6.6 | molar enthalpy of reaction calculation | accepted 013 (tagged 6.6) |
| 6.6 | bond breaking/forming (6.6.A.3) | consolidated into 018 (6.7) |
| 6.6 | energy flow to/from the surroundings (6.6.A.2) | **escalated** (r1-017 / r2-001) |
| 6.6 | Exclusion: enthalpy vs internal energy | respected. No entry; control 02 rejected. |
| 6.7 | bond enthalpy; average bond energy; ΔH ≈ Σbroken − Σformed | accepted 018 |
| 6.8 | ΔH°rxn from ΔHf° | accepted 019. The formula follows the CED's EQN, which has no coefficient n; the inventory shows nΔHf°. The coefficient point is not in 019's caution. **Note for PO.** |
| 6.8 | standard enthalpy of formation; standard state (vocabulary) | no entry. The 6.8 pages do not define either term. |
| 6.9 | Hess's law; reversal; scaling; adding | accepted 020 (list) and 021 (sum of steps) |
| 6.9 | Exclusion: state-function terminology | respected. No entry uses it. |

Duplicates: none among the accepted rows. The escalated row overlaps 001/002 (see above).

## Development load and verification

- **Target check.** I ran `supabase db query --linked --workdir /Users/davidbloom/Documents/Cramapple.nosync --debug "select 1"`. The debug output names `wmgjsdkphcyhngaffbqf` (Dev) and does not name `pcntajvbdfqhbeewmdry` (Prod).
- **Load.** I loaded `out/load_ap_chemistry_u6.sql` (20 inserts, 0 hooks, one transaction) with `-f` and the same flags.
- **Counts in Dev.** For `ap_chemistry` unit 6 after the load: published entries = **20**, all from this batch; hooks = **0**.
- **QA checks.** I ran checks 4–7 of `scripts/qa/unit_reference_and_memory_hooks_qa.sql` in Dev, one section at a time:

| Check | Name | Result |
|---|---|---|
| 4 | zero_orphan_topic_codes | ok = true |
| 5 | owner_unit_matches_taxonomy | ok = true |
| 6 | published_hooks_have_published_entries | ok = true |
| 7 | published_at_present | ok = true |

## Cost

Taken from the `out/logs_*` usage fields. Unit 6 calls were separated by tag and by the `logs_check_ap_chemistry_u6` directory.

| Stage | Model | Calls | Cost (USD) |
|---|---|---|---|
| Extraction (r1 + r2) | claude-sonnet-5.5 | 2 | 0.114 |
| Checking | gemini-3.5-flash | 34 | 0.449 |
| Checking | gpt-6-sol | 37 | 0.604 |
| Veto | claude-haiku-5.5 | 25 | 0.045 |
| **Total** | | | **≈ $1.21** |

## Files (Unit 6 only)

- `controls_ap_chemistry_u6.json`
- `out/candidates_ap_chemistry_u6.json` and `out/candidates_ap_chemistry_u6_r2.json`
- `out/verdicts_ap_chemistry_u6.json` and `out/verdicts_ap_chemistry_u6_r2.json`
- `out/round2_only_ap_chemistry_u6.json`
- `out/check_ap_chemistry_u6.log` and `out/check_ap_chemistry_u6_r2.log`
- `out/load_ap_chemistry_u6.sql`
- `out/selection_ap_chemistry_u6.json`

Raw JSONL logs are not committed. Nothing was committed.
