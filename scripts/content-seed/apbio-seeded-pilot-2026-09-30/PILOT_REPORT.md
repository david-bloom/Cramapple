# AP Biology Units 1-2 seeded-variant pilot: final report (2026-10-01)

Protocol under test: `docs/research/SEEDED_ITEM_GENERATION_PROTOCOL_2026_09_30.md` (draft v0.1), second subject after AP Calculus AB. Class A seeds only (existing Cramapple items). 8 published MCQ seeds, 2 variants each = **16 variants**.
Author: Claude Sonnet 5.5. Checkers (Product Owner's pick): `google/gemini-3.5-flash` + `deepseek/deepseek-v4-pro`. Nothing was loaded to any database for the variants.
One Production change was made: the repair of seed `APBIO-MCQ-023` (`APPROVAL-0067`). Detail: `S0A_AUDIT_REPORT.md`, `VARIANTS_MATH_CHECK_REPORT.md`, `VARIANTS_CED_AND_LABEL_REPORT.md`.

## Headline
| | Biology (this pilot) | Calc AB pilot |
|---|---|---|
| Wrong keys | **0** (0 of 16 seed solves, 0 of 46 variant solves disagreed) | 0 |
| Seeds with a defective rationale | **1 of 8** | 5 of 8 |
| Variants needing a rewrite or edit after checks | **6 of 16** (38%): 3 wording defects, 1 explicit CED exclusion, 1 scope departure, 2 unit drift (some overlap) | 1 of 16 |
| Defects caught by only one model | all 3 wording defects and the exclusion hit: **DeepSeek only** | the one variant defect: DeepSeek only |
| Cost (checkers, whole pilot) | **$2.45**, about $0.15 per variant | about $0.064 per variant |
**The pattern flipped.** In Calc the *seeds* were the weak point and the variants were clean. In Biology the seeds were nearly clean and the *variants* were the weak point. Keys were never the problem in either subject; the defects live in wording, scope and labels.

## What the three stages caught, and who caught it
1. **Content (blind solve + rationale audit):** 3 wording defects in 2 variants (an absolute "never internalized", an imprecise "iron released into the cytoplasm", an over-strict "only misfolded proteins are degraded"). All hand-verified; all raised only by DeepSeek; Gemini flagged nothing. Patched; re-check clean (no patch regressions this time, unlike Calc Unit 1).
2. **CED scope:** DeepSeek flagged 11 of 16, Gemini 1 of 16. Two flags were genuine: `sv-005-v2` breached an explicit pack exclusion (specific amino acid structure), and `sv-021-v2` left the seed's concept for nuclear import. Only DeepSeek found the first. The rest named terms absent from a *topic-level* fact pack that the published seeds already use.
3. **Labels:** units inherited on 30 of 32 samples (94%), topic 91%, difficulty 75% (variants collapse to Medium; seeds span Easy to Hard). The only large miss was mine: two variants changed the seed's task type (transport protein to enzyme) and the probe moved them from Unit 1 to Unit 3.

## What I did wrong, plainly
- **I did not read the Biology fact pack before authoring**, although the protocol says to author against it. The amino-acid exclusion is on line 380 of that file. The CED stage caught it, but it should never have reached the stage.
- **I changed the task type in two variants**, which changed the unit. A variant must keep the seed's mechanism and topic anchor; only the context and values change.

## Rounds
Round 1 checks on all 16, then round 2 (full content + CED + label re-check) on the 5 rewritten items.
Round 2: content 10/10 solves match and 10/10 audits flag-free; CED: 4 of the 5 now pass both models; `sv-021-v2` is still flagged by both, see below.

## Round 3 (2026-10-01): CED V.1 checked, fact pack annotated, 021-v2 rewritten

Re-run on all 16 variants with the annotated pack. Results: 9 of 16 pass both models; 021-v2 (new) passes both; 021-v1 fails both; DeepSeek alone flags 005-v1, 008-v1, 018-v1, 018-v2, 022-v1, 023-v1, 023-v2. I read each reason against the CED text (searched for every term; printed page numbers):
- **Genuinely absent from the CED, inherited from the published seed, with the mechanism supplied in the stem:** isomers / hydroxyl orientation (005; CED has only "topoisomerase"), receptor-mediated endocytosis, clathrin, endosomes (018; CED 2.5.B.1 covers endocytosis generically), 70S/80S ribosomes and binary fission (022), peripheral vs integral membrane proteins, detergent and protease-topology assays (023; "integral" appears in the CED only as "integral part of lab safety"), signal peptide/SRP (021).
- **Not a CED problem:** disulfide bridges ARE in the CED (1.7.A.5). 008-v1's flag is only borderline, because choice B's rationale relies on "cysteine, not isoleucine, has sulfur".
- **My earlier expectation was wrong.** I said a refreshed pack should make most DeepSeek-only flags disappear. The pack already matched the CED (V.1, the latest edition), so they did not. The flags are accurate about vocabulary; the open question is policy, not a stale pack.

**Policy decision for the Product Owner (new):** the published seeds 005, 018, 021, 022 and 023 themselves rely on terms the CED does not name, and their variants inherit that. Either (a) accept items that supply a beyond-CED mechanism in the stem and test only CED-level reasoning on it (how AP stimulus-based questions work, but the protocol then needs a rule), or (b) keep items to CED vocabulary and rewrite or remediate them as was done for 021-v2. 021-v1 and the seed 021 depend on the mechanism itself rather than only supplying it, so they are the weakest cases.

## Round 4 (2026-10-01): Product Owner policy "stay within CED vocabulary"

Decision: items must not rely on terms the CED does not name, even when the stem supplies them. Consequences:
- **Rewritten to CED vocabulary (6 items + 1 edit), not yet checked by the models:** `018-v1` (transferrin receptor, generic endocytosis), `018-v2` (receptor binds but cannot start endocytosis), `021-v1` (ribosomes cannot attach to the rough ER), `022-v1` (double membrane, circular DNA, ribosomes, independent reproduction), `023-v1` (hydrophobic and hydrophilic regions of an embedded protein, CED 2.3.A.2), `023-v2` (R-group pattern of a channel protein). `008-v1` choice B changed from disulfide to ionic bonding (letters unchanged). Patch: `patch_ced_vocab_round4.py`; items to check: `variants_round4_items.json`. All pass similarity (max 0.39 vs seed, 0.38 vs other variants) and length parity (ratio <= 1.37).
- **What the rewrites give up:** `018` and `023` lose the clathrin / endosome / fractionation-assay reasoning, so they test a simpler idea than the seed (receptor needed for uptake; hydrophobic and hydrophilic regions of embedded proteins). `021-v1` and `021-v2` now both test the rough ER route, from different angles. They are variants of the seed's topic, not of its mechanism.
- **Held, no CED-level version exists:** `005-v1` and `005-v2`. The seed's idea (same formula, different shape, so a protein distinguishes the sugars) is isomerism, which the CED does not name (it has only "topoisomerase"). Any variant keeps that idea.
- **Seeds:** `APBIO-MCQ-005`, `018`, `021`, `022`, `023` themselves use beyond-CED terms. Under this policy they need owner-remediation (new version, never in place) before further variants are built from them. Not touched; each Production change needs its own approval.
- **Next:** run the content check and CED check on `variants_round4_items.json` (7 items), then the label probe.

## Where each variant stands
| Variant | Content | Scope | Labels (vs seed's probe label) | Status |
|---|---|---|---|---|
| 005-v1, 005-v2 | clean | v1 DeepSeek only, v2 clean (round 3) but both rest on isomers, which the CED does not name | units ok / 005-v2 units (1) vs seed (1,2); topic 1.4 | **hold** pending seed 005 (policy: CED vocabulary) |
| 008-v1, 008-v2 | clean | v1 choice B rewritten in round 4 (disulfide -> ionic; unchecked); v2 clean (round 3) | 1.7, unit 1 | ready |
| 014-v1, 014-v2 | clean | clean (round 2) | unit 2; topic 2.9/2.10 split | ready |
| 016-v1, 016-v2 | clean | clean | 2.7, unit 2 | ready |
| 018-v1, 018-v2 | rewritten in round 4 (CED vocabulary; unchecked) | rewritten, unchecked | 2.8, unit 2 | ready |
| 022-v1, 022-v2 | v1 rewritten in round 4 (unchecked); v2 clean | v1 rewritten, unchecked; v2 clean | 2.10, unit 2 | ready |
| 023-v1, 023-v2 | rewritten in round 4 (CED vocabulary; unchecked) | rewritten, unchecked | 2.3, unit 2 | ready |
| 021-v1 | rewritten in round 4 (ribosomes detached from the rough ER; unchecked) | rewritten, unchecked | 2.1, unit 2 | needs round-4 checks |
| 021-v2 (rewritten 2026-10-01) | clean | **clean, both models** (round 3) | 2.1, unit 2 | ready for review |
**16 of 16 ready for review preparation; 2 of them (`021-v1`, `021-v2`) conditional on decision 1.** (Originally 14 ready and 2 held; the hold was released on 2026-10-01 after the Product Owner's direction below.)

## Decisions and follow-ups for the Product Owner
1. **Signal sequence / SRP (seed 021, `021-v1`, `021-v2`): RESOLVED in principle, 2026-10-01.** The Product Owner directed that, in the 2026-2027 AP Biology curriculum, a signal sequence is a short stretch of amino acids, usually at a protein's N-terminus, that acts like a shipping label directing the protein to the endoplasmic reticulum so it can be sorted to the right organelle or secreted. On that basis the concept is in scope and the hold on the `021` family is released.
   **Not verified from the source:** I could not open the College Board CED (the site is blocked from this environment), and the fact pack in the repo has no mention of signal sequences, which is why the scope check flagged them. The direction covers "signal sequence directs a protein to the ER". It does not by itself cover the SRP and co-translational mechanics named in these items; the stimuli define those, so the questions are answerable from the text, but a reviewer should confirm that level of detail is acceptable.
   **Follow-up that matters more than the 021 items:** the fact pack appears to predate the 2026-2027 curriculum. Other terms the scope check flagged on published seeds and variants (70S/80S ribosomes, integral/peripheral proteins, clathrin-mediated endocytosis) may also be in the current CED. Refresh the pack from the actual 2026-27 CED (with the source text cited), then re-run the scope check on the 16 variants and the 8 seeds; expect most DeepSeek-only flags to disappear.
   **Update, 2026-10-01 (CED V.1 checked, printed pp. 49-51; Product Owner confirmed it is the latest edition):** the CED never names signal sequence, signal peptide, SRP or co-translational targeting, and its Golgi exclusion puts packaging of specific enzymes for lysosomes and secretory vesicles out of scope. The Product Owner chose to rewrite `021-v2` to the CED level. It is now a pulse-chase of a secreted enzyme (rough ER, then Golgi, then vesicles; EK 2.1.A.1-A.4, A.6 only), Jaccard 0.18 against the seed, answer-length ratio 1.16. It has not been checked by the models yet (`variants_021v2_ced_items.json`). **Still open:** the published seed `APBIO-MCQ-021` and `021-v1` still rest on SRP and signal peptide, so they remain outside the CED text. Seed 021 is a Product Owner decision (leave, or owner-remediate).
2. **Seed topic tags.** Production's provisional topic differs from the blind probe on 5 of 8 seeds (`008`: 1.1 vs 1.7 Proteins; `022`: 2.1 vs 2.10; `005`, `014`, `018` too). Units are right on all eight. One model, two samples: do not change Production from this. Re-label the seeds by three-model consensus (protocol section 6), then let variants inherit.
3. **`APBIO-MCQ-018` (published seed)** has the same "never enters the cell" overstatement and the same iron/cholesterol "released into the cytoplasm" imprecision that I fixed in the variant. Candidate for the same owner-remediation path. Not changed.
4. **Loading any variant to Production** needs its own approval and the usual review gates; none was requested.

## Recommendations for the protocols
- **Add a "stay on the seed's topic code" rule for variants** and run the label probe on drafts before the full checks (about $0.007 per item). It would have caught both unit-drift items for pennies.
- **Require the author to read the subject's fact pack and its exclusions first** and to list them in the batch README. Make the CED stage a backstop, not the first reader.
- **Keep two checkers from different families.** All 4 real catches beyond keys came from DeepSeek alone; Gemini 3.5 Flash flagged almost nothing in CED. That is the same asymmetry as Calc.
- **Treat fact-pack absence as a prompt for judgement, not a verdict**, when the pack is topic-level. Add the vocabulary question to the Learning Quality Owner's queue.
- **Cost:** CED was 46% of spend because every call carries the whole pack (about 25k tokens). Trimming or caching it is still the obvious saving.

## Caveats
16 variants, MCQ only, one author session, one subject, two checkers, single-model labeling, class A seeds. The Biology and Calc defect rates are not comparable as rates; the lesson is where the defects sit. Gemini was 3.5 Flash here and 3.8 Flash in the Calc pilot.
