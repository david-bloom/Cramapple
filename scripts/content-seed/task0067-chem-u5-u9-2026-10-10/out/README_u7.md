# AP Chemistry Unit 7 (Equilibrium): Reference Pack batch, Development only

Batch: `task0067-chem-u5-u9-2026-10-10`. Run date: 2026-10-10. **Production was not touched.**

## Inputs

- CED text: `ap-chemistry.txt` (pdftotext -layout) in `$CED_TXT_DIR`, PDF pages 130-147. These are printed pages 123-140: the Unit 7 overview plus Topics 7.1-7.12.
- Fact pack: `out/factpack_ap_chemistry_u7.md`.
- Scope checklist: the Unit 7 rows of `docs/product/AP_CHEMISTRY_CED_SCOPE_INVENTORY_2026_10_09.md` and its Reference Pack build protocol. The file was read from the main checkout because it is missing from this worktree.
- Model slate (unchanged from the protocol, smoke-tested 2026-10-10):
  - extractor: `anthropic/claude-sonnet-5.5`
  - checkers: `google/gemini-3.5-flash` and `openai/gpt-6-sol`
  - reject-only veto: `anthropic/claude-haiku-5.5`
- Files:
  - controls: `controls_ap_chemistry_u7.json`
  - candidates: `out/candidates_ap_chemistry_u7.json` and `out/candidates_ap_chemistry_u7_r2.json`
  - verdicts: `out/verdicts_ap_chemistry_u7.json` and `out/verdicts_ap_chemistry_u7_r2.json`
  - load SQL: `out/load_ap_chemistry_u7.sql`
  - selection: `out/selection_ap_chemistry_u7.json`
  - round-2 list: `out/round2_only_ap_chemistry_u7.json`

## Controls (verified against the CED text before the run). Result: 6/6 rejected

| id | defect | CED line checked | caught by |
|---|---|---|---|
| ctrl-chem-u7-01-wrong-formula | Kc inverted (reactants over products) | 7.3.A.1 "EQN: Kc = [C]^c[D]^d / [A]^a[B]^b" | both checkers N |
| ctrl-chem-u7-02-excluded | Kp = Kc(RT)^Δn | 7.3 Exclusion: "Conversion between Kc and Kp will not be assessed on the AP Exam." | both N |
| ctrl-chem-u7-03-wrong-owner | K_reverse = 1/K owned by 7.9 | 7.6.A.1 "When a reaction is reversed, K is inverted." | both N |
| ctrl-chem-u7-04-wrong-order | Q<K and Q>K outcomes swapped | 7.7.A.2 "When Q < K ... net consumption of reactants and generation of products. When Q > K ... net consumption of products ..." | both N |
| ctrl-chem-u7-05-bad-hook | correct 7.6 K-manipulation entry; hook "Flip, Power, Product" with Flip and Power expansions swapped | 7.6.A.1-3 | entry accepted, hook rejected (0/1) as designed |
| ctrl-chem-u7-06-other-unit | Henderson-Hasselbalch (Unit 8, 8.9) | grep of pp.130-147 for "Henderson", "pKa", "buffer": 0 matches | both N |

No control leaked, so no controls were replaced and there is no void file.

## Counts

| stage | candidates | accepted | rejected | hooks proposed | hooks accepted |
|---|---|---|---|---|---|
| Round 1 | 21 | 16 | 5 | 0 | 0 |
| Round 2 (stateless re-extract of the 5) | 5 | 4 | 1 | 0 | 0 |
| **Loaded (Dev)** | — | **20 entries** | **1 escalation** | — | **0 hooks** |

Round 1 had one transient error: the veto returned non-JSON on r1-003. The checker was resumed for that one row, and the row was accepted (both checkers Y, veto Y).

Kinds loaded: 4 vocabulary, 7 convention, 5 formula, 2 list_sequence, 2 diagram (20 in total). The extractor proposed no hooks for any row. Per protocol, "no hook" is the recorded outcome for all 20 entries.

Round-1 rejection reasons:

- r1-010, r1-011 and r1-012 (the three K-manipulation formulas): GPT-6 Sol twice flagged the reuse tag 7.7 as unsupported.
- r1-014 (particulate-model diagram): GPT-6 Sol twice flagged the item "particle ratio raised to coefficients gives K" as not generally correct.
- r1-006 (Kp): the veto flagged its topic tags twice.

In round 2, the K-manipulation rows came back tagged 7.6 only and were accepted. The diagram was rewritten and accepted.

## Escalations (to the Product Owner)

**ap_chemistry-u7-r2-001: Kp (and Qp) expression, owner 7.3.**

- Both independent checkers accepted it in both rounds.
- The veto rejected it in both rounds on `b_topic_codes` only:
  - Round 1: the tags 7.5/7.6/7.10 were judged unsupported.
  - Round 2: the tag 7.8 was judged unsupported ("7.8.A.1 refers to 'the value of the equilibrium constant' ... with no Kp expression").
- Every check found the formula correct: veto `a_factual`, `c_ced_required` and `d_caution` were all true.
- CED evidence: 7.3.A.1 "for (Kp, Qp) is EQN: Kp = (PC)^c(PD)^d/(PA)^a(PB)^b".
- PO decision needed: accept with owner 7.3 and approved reuse tags (7.3, 7.4, 7.7 are supported in every veto reason). This is the only gap against a core CED equation in the unit.

## Completeness disposition (Unit 7 inventory phrases)

| Topic | Phrase(s) | Disposition |
|---|---|---|
| 7.1 | reversible process; forward/reverse reaction | Accepted: "Examples of reversible processes" (r1-002); consolidated into "Dynamic equilibrium" (r1-001) |
| 7.1 | dynamic equilibrium; forward rate = reverse rate; constant, not necessarily equal | Accepted: r1-001 |
| 7.1 | concentration/rate-time graphs | Accepted: diagram r1-003 |
| 7.1 | particulate models at equilibrium | Consolidated into the 7.8 diagram (r2-005) |
| 7.2 | net forward / net reverse; direction from rates | Accepted: r1-004 |
| 7.3 | equilibrium constant; Kc; Q same form | Accepted: Kc formula r1-005; "Reaction quotient (Q)" r1-007 |
| 7.3 | Kp | **Escalated** (r2-001) |
| 7.3 | omit pure solids/liquids | Accepted: r1-008 |
| 7.3 | homogeneous/heterogeneous equilibrium | Consolidated into r1-008. The CED pages never use these terms (0 matches), so they get no separate vocabulary entry |
| 7.3 | Kc-to-Kp conversion; dissolved/gas-phase equilibrium calculations | Excluded: 7.3 Exclusion Statements (now the 02 control) |
| 7.4 | equilibrium concentration/partial pressure; substitute data into K | Consolidated into Kc (r1-005, tagged 7.4) and Kp (pending). The CED gives no separate rule (7.4.A.1) |
| 7.5 | product-favored / reactant-favored / essentially complete; K magnitude → composition | Accepted: r1-009. The CED wording is "very large K ... essentially to completion"; "favored" does not appear in the CED |
| 7.6 | reverse → 1/K; scale by c → K^c; add → multiply K | Accepted: r2-002, r2-003, r2-004. The r1-012 caution covered "same manipulations apply to Q" (7.6.A.4); the r2 rows are formula-only |
| 7.7 | Q<K / Q>K / Q=K direction | Accepted: r1-013 |
| 7.7 | ICE tables; solving mass-action relations; physically meaningful roots | Excluded as method-level work. "ICE" and "roots" are not in the CED pages; 7.7.A.1 only requires predicting equilibrium concentrations "given the balanced reaction, initial concentrations, and the appropriate K", which the Kc/Kp entries support |
| 7.8 | equilibrium composition; particle counts ↔ K; before/at-equilibrium diagrams | Accepted: diagram r2-005 |
| 7.9 | stress; concentration/pressure/volume/temperature/dilution | Accepted: r1-015 (CED's four stresses in CED order) |
| 7.9 | observable pH/color/temperature changes | Accepted: r1-016 |
| 7.9 | only temperature changes K | Consolidated into r1-017 |
| 7.10 | disturbed equilibrium; Q vs K; temperature alters K; re-equilibration | Accepted: r1-017; r1-013 tagged 7.10 |
| 7.11 | Ksp; write Ksp | Accepted: vocabulary r1-019; formula r1-018 |
| 7.11 | saturated solution; molar solubility ↔ ion concentrations | Consolidated into r1-019 and r1-018 (7.11.A.2/A.4); no separate vocabulary entry |
| 7.11 | Ksp > 1 ↔ soluble; relative solubility | Accepted: r1-020 |
| 7.12 | common ion; reduced solubility | Accepted: r1-021; Ksp rows are tagged 7.12 |
| 7.12 | selective precipitation; Qsp vs Ksp | Excluded. Neither phrase appears in the 7.12 CED text (0 matches); 7.12.A.1 covers only reduced solubility, qualitative or by Ksp |

Every Unit 7 inventory phrase now has a disposition. The only open item is Kp, pending the PO decision.

## Cost (separable, from gateway usage `cost`)

| model | calls | prompt tok | completion tok | USD |
|---|---|---|---|---|
| claude-sonnet-5.5 (extract, r1+r2) | 2 | 28,858 | 7,528 | 0.133 |
| gemini-3.5-flash | 39 | 287,894 | 28,589 | 0.520 |
| gpt-6-sol | 43 | 292,830 | 13,088 | 0.691 |
| claude-haiku-5.5 (veto) | 32 | 368,046 | 42,137 | 0.058 |
| **total** | 116 | | | **$1.40** |

## Development verification

- Target check: `supabase db query --linked --workdir /Users/davidbloom/Documents/Cramapple.nosync --debug` showed `wmgjsdkphcyhngaffbqf` and no `pcntajvbdfqhbeewmdry`. `supabase/.temp/project-ref` is also `wmgjsdkphcyhngaffbqf`.
- Load: `out/load_ap_chemistry_u7.sql` was applied with `-f`. The first connection attempts hit a transient pooler circuit breaker, which is likely concurrent workers. The CLI retried and succeeded; the SQL is idempotent (`on conflict do nothing`).
- Counts: Unit 7 in Development has **20 published entries**, all 20 carrying `batch=task0067-chem-u5-u9-2026-10-10` in `source_note`, and **0 published hooks**.
- QA from `scripts/qa/unit_reference_and_memory_hooks_qa.sql`, run one section at a time:
  - Check 4, `zero_orphan_topic_codes`: ok=true
  - Check 5, `owner_unit_matches_taxonomy`: ok=true
  - Check 6, `published_hooks_have_published_entries`: ok=true
  - Check 7, `published_at_present`: ok=true
- No git commit was made. Raw JSONL logs stay in `out/logs_*` and are not to be committed.
