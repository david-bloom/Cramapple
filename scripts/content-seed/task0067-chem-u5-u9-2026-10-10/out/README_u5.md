# AP Chemistry Unit 5 (Kinetics) Reference Pack batch — Development only

Batch: `task0067-chem-u5-u9-2026-10-10` · Date: 2026-10-10 · Target: Development (`wmgjsdkphcyhngaffbqf`). Production not touched.

## Inputs
- CED: `ap-chemistry.txt` (pdftotext -layout of the current AP Chemistry CED, © 2024 College Board), PDF pages **96-113** (printed Course Framework pp. 89-106; the last page is blank).
- Fact pack: `out/factpack_ap_chemistry_u5.md`.
- Scope checklist: `docs/product/AP_CHEMISTRY_CED_SCOPE_INVENTORY_2026_10_09.md` (Unit 5 table + Reference Pack build protocol). This file is on main (`/Users/davidbloom/Documents/Cramapple.nosync/docs/product/`), not in this worktree.
- Model slate (unchanged, smoke-tested today): extractor `anthropic/claude-sonnet-5.5`; checkers `google/gemini-3.5-flash`, `openai/gpt-6-sol`; reject-only veto `anthropic/claude-haiku-5.5`.
- Files: `controls_ap_chemistry_u5.json`, `out/candidates_ap_chemistry_u5.json`, `out/candidates_ap_chemistry_u5_r2.json`, `out/round2_only_ap_chemistry_u5.json`, `out/verdicts_ap_chemistry_u5.json`, `out/verdicts_ap_chemistry_u5_r2.json`, `out/selection_ap_chemistry_u5.json`, `out/load_ap_chemistry_u5.sql`, `out/check_ap_chemistry_u5.log`, `out/check_ap_chemistry_u5_r2.log`.

## Controls (each defect checked against the CED text before the run)
| id | defect | CED line checked | result |
|---|---|---|---|
| ctrl-chem-u5-01-wrong-formula | first-order half-life written as k/0.693 | 5.3.A.5 (p.97): "EQN: t1/2 = 0.693/k." | rejected (both checkers) |
| ctrl-chem-u5-02-excluded | two-point Arrhenius equation for calculating Ea | 5.6 Exclusion Statement (p.100): "Calculations involving the Arrhenius equation will not be assessed on the AP Exam." | rejected (both) |
| ctrl-chem-u5-03-wrong-owner | Maxwell-Boltzmann distribution owned by 5.9 | 5.5.A.3 (p.99) names the curve; 5.9 (p.103) contains only 5.9.A.1 on pre-equilibrium | rejected (both) |
| ctrl-chem-u5-04-wrong-order | energy profile order reactants → products → transition state | 5.6.A.3 (p.100): "proceeds from reactants, through a transition state, to products" | rejected (both) |
| ctrl-chem-u5-05-bad-hook (hook target) | correct linear-plot entry; hook "Plain, flip, log" maps first order to 1/[A] and second to ln[A] | 5.3.A.2 / 5.3.A.3 (p.96): ln[A] linear for first order, 1/[A] linear for second | hook rejected (0/1 accepted); entry accepted as designed |
| ctrl-chem-u5-06-other-unit | ΔG° = ΔH° − TΔS° (Unit 9) | Grep of pp.96-113: zero hits for "Gibbs", "free energy", "entropy", "ΔG", "ΔH" | rejected (both) |

**Controls caught: 6/6.** No control was replaced; no void verdicts file.

## Counts
| Unit | Extracted R1 | R1 accepted | R2 re-extracted | R2 accepted | Loaded entries | Hooks loaded | Escalated | Controls caught |
|---|---|---|---|---|---|---|---|---|
| 5 | 30 | 25 | 5 | 2 | 27 | 1 | 3 | 6/6 |

R1 rejects: r1-007 (both checkers: "is *the* method" vs CED "a method"), r1-016 and r1-017 (veto), r1-024 (GPT-6 Sol: catalyst caution overstated), r1-030 (GPT-6 Sol: "often" overstated as always). No schema rejects. The only hook proposed (r1-011 "Plain, ln, reciprocal") passed all checkers and was loaded.

## Escalations (still rejected after round 2; Product Owner decision needed; no round 3)
1. **ap_chemistry-u5-r2-002 "Requirements for a successful collision"** (5.5, topic_codes 5.5, 5.11; list_sequence: sufficient energy, proper orientation). CED 5.5.A.2. Gemini and GPT-6 Sol accepted. Haiku veto (twice): the body says "Only a small fraction of collisions lead to reaction" without the CED qualifier "In most reactions"; one sample also rejected the 5.11 tag. In R1 (r1-016) the veto gave the same qualifier reason.
2. **ap_chemistry-u5-r2-003 "Maxwell-Boltzmann energy distribution"** (5.5, topic_codes 5.5, 5.6; diagram). CED 5.5.A.3. Gemini and GPT-6 Sol accepted. Haiku veto (twice): b_topic_codes fails because 5.6.A.4 talks about temperature dependence but does not name the distribution. Items are factually fine. In R1 (r1-017) the veto gave the same 5.6 reason, and one sample also wanted a caution.
3. **ap_chemistry-u5-r2-005 "Types of catalysis named in the CED"** (5.11; list_sequence: binding to reactants/enzymes, acid-base, surface). CED 5.11.A.3-5. Gemini accepted. GPT-6 Sol rejected twice: the body says *each* pathway introduces new intermediates and elementary reactions, but 5.11.A.3 says only "often a new reaction intermediate". This is the same reason as R1 (r1-030). Not reached by the veto.

All three are owner/qualifier issues on CED-required content. None is a factual error in the core claim.

## Completeness disposition (Unit 5 inventory phrases)
| Topic | Phrase(s) | Disposition |
|---|---|---|
| 5.1 | reaction rate; concentration change; time interval | accepted: r1-001 "Kinetics (reaction rate)" |
| 5.1 | surface area; catalyst (as rate factors) | accepted: r1-003 "Factors that influence reaction rate" |
| 5.1 | stoichiometric coefficients fix relative rates | accepted: r1-002 "Stoichiometry sets relative rates of change" |
| 5.1 | average/instantaneous rate from tables/graphs | representation/work; the CED does not name average or instantaneous rate (5.1.A.1-3). Consolidated into r1-001/r1-002; no separate entry |
| 5.2 | rate law; rate = k[A]^m[B]^n | accepted: r1-004 "General rate law expression" |
| 5.2 | reaction order; overall order | accepted: r1-005 |
| 5.2 | rate constant; units depend on overall order; temperature dependence | accepted: r1-006 "Rate constant (k)" |
| 5.2 | method of initial rates; orders from initial-rate ratios | accepted (R2): r2-001 "Find orders by comparing initial rates" |
| 5.2 | infer rate law from tables; predict concentration/temperature effects | representation/work; covered by r1-004/r1-006/r2-001 |
| 5.3 | integrated rate laws (zero/first/second) | accepted: r1-008, r1-009, r1-010 |
| 5.3 | first-order half-life t1/2 = 0.693/k | accepted: r1-012 |
| 5.3 | radioactive decay | accepted: r1-013 |
| 5.3 | which plot is linear; slope/intercept | accepted: r1-011 "Linear plot that identifies reaction order" (+ hook "Plain, ln, reciprocal") |
| 5.4 | elementary reaction; exponents follow stoichiometry | accepted: r1-014 |
| 5.4 | three-body collisions rare | accepted: r1-015 |
| 5.4 | molecularity; unimolecular; bimolecular | consolidated: molecularity in r1-025 and the collision stoichiometry in r1-014. The CED does not use "unimolecular" or "bimolecular" (5.4.A.1-2), so neither gets its own entry |
| 5.5 | collision model; effective collision; orientation; sufficient energy | **escalated**: r2-002. "Effective collisions" also appears in accepted r1-028 (5.11) |
| 5.5 | Maxwell-Boltzmann distribution; shaded fraction above Ea | **escalated**: r2-003 |
| 5.5 | activation energy | accepted: r1-018 (owned by 5.6, where the CED defines it in 5.6.A.3) |
| 5.6 | reaction coordinate | accepted: r1-019 |
| 5.6 | transition state; Ea = transition state − reactants; profile labels | accepted: r1-018 "Activation energy (forward)", r1-020 "Single-step reaction energy profile" |
| 5.6 | exothermic/endothermic; ΔH | consolidated into r1-020 as "Overall energy change". The CED says "overall energy change" (5.6.A) and never "ΔH" or "exo/endothermic" in Unit 5 (both belong to Unit 6) |
| 5.6 | Arrhenius relation (qualitative) | accepted: r1-021 "Why elementary rate depends on temperature", whose caution states the calculation exclusion |
| 5.6 | Arrhenius calculations | excluded: 5.6 Exclusion Statement (used as control 02) |
| 5.7 | mechanism; elementary step; components | accepted: r1-022 "Reaction mechanism" |
| 5.7 | steps sum to the overall equation | accepted: r1-023 |
| 5.7 | intermediate | accepted (R2): r2-004 "Reaction intermediate" |
| 5.7 | catalyst (identified from steps) | accepted: r1-029 "Catalyst in a mechanism" (owned by 5.11) |
| 5.7/5.8 | collecting data to detect an intermediate | excluded: 5.7/5.8 Exclusion Statement |
| 5.8 | rate-determining step; slow step; mechanism consistency | accepted: r1-025 "Rate law from a mechanism with rate-limiting first step" |
| 5.9 | pre-equilibrium; slow step | accepted: r1-026 "First step not rate limiting requires an approximation" |
| 5.9 | fast equilibrium; intermediate substitution derivation | consolidated into r1-026. 5.9.A.1 only says approximations "such as pre-equilibrium" must be made; it gives no derivation, so there is no separate entry |
| 5.10 | multistep profile; peaks = steps; valleys = intermediates; slow-step barrier | accepted: r1-027 "Multistep reaction energy profile" (transition state and Ea per step, intermediates between) |
| 5.11 | catalyst; alternate pathway / lower Ea; net amount regenerated | accepted: r1-028 "How a catalyst increases rate", r1-029 "Catalyst in a mechanism" |
| 5.11 | enzyme catalysis; acid-base catalysis; surface catalysis | **escalated**: r2-005 |
| 5.11 | homogeneous/heterogeneous catalysis | the CED does not use these terms (5.11.A.1-5 name binding/enzyme, acid-base and surface catalysis). Would fold into r2-005 if accepted; no entry |
| 5.11 | catalyst changes pathway, not net thermodynamics | consolidated into r1-028/r1-029. The thermodynamics wording is not in the 5.11 text, so no separate entry |

**Gap:** topic 5.5 currently has **no accepted entry** of its own. Both of its entries (r2-002, r2-003) are escalated, so the unit pack is not complete until the Product Owner decides on them.

No-hook outcomes: 26 of the 27 loaded entries have no hook. This is the normal outcome and was kept as-is.

## Cost (Vercel AI Gateway `usage.cost`, Unit 5 calls only)
Extraction calls are separated by tag `ap_chemistry_u5` in the shared `out/logs_extract/`. Checker calls are in the unit-specific `out/logs_check_ap_chemistry_u5/`.
| stage / model | calls | USD |
|---|---|---|
| extract claude-sonnet-5.5 (R1 + R2) | 2 | 0.1639 |
| check gemini-3.5-flash | 48 | 0.6641 |
| check gpt-6-sol | 51 | 0.8767 |
| veto claude-haiku-5.5 | 39 | 0.0710 |
| **total** | 140 | **1.7758** |

## Development verification
- Target check before the load: `supabase db query --linked --workdir /Users/davidbloom/Documents/Cramapple.nosync --debug` output contained `wmgjsdkphcyhngaffbqf` and did not contain `pcntajvbdfqhbeewmdry`. Re-checked immediately before loading.
- Baseline before the load: 0 ap_chemistry unit 5 entries.
- Loaded `out/load_ap_chemistry_u5.sql` (one transaction). After the load: **27 published entries, 1 published hook**. All 27 carry `batch=task0067-chem-u5-u9-2026-10-10` in `source_note`.
- QA (`scripts/qa/unit_reference_and_memory_hooks_qa.sql`, each section run separately): 4 zero_orphan_topic_codes ok=true; 5 owner_unit_matches_taxonomy ok=true; 6 published_hooks_have_published_entries ok=true; 7 published_at_present ok=true.
