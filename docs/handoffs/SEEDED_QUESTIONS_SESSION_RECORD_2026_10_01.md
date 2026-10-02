# Seeded Question Generation: Session Record (2026-09-30 to 2026-10-02)

Scope of this file: **seeded question generation only** (the protocol, the AP Biology pilot, the CED-scope work, the Production repairs that came out of the audits). Notes that bear on **grading** are kept apart in `GRADING_NOTES_FROM_SEEDED_QUESTION_SESSION_2026_10_01.md`.

Governing records: `DECISION-0093` (seeded-item protocol), `docs/research/SEEDED_ITEM_GENERATION_PROTOCOL_2026_09_30.md` (now with section 10, status by subject). Approvals used: `APPROVAL-0066`, `APPROVAL-0067`, `APPROVAL-0068`. Merged PRs from this session: #303, #305 (earlier in the work: #302; the Product Owner also pushed #297 during the Calc repair work). Author: Claude Sonnet 5.5. Checkers: `google/gemini-3.5-flash` and `deepseek/deepseek-v4-pro`.

## 1. What was asked, in order
1. Test the seeded-item protocol on a new subject: AP Biology Units 1-2, class A seeds only, 2 variants per seed, the same two checkers as the Calc pilot (for direct comparison).
2. Repair `apcalcab-mcq-037` and the distractor-rationale defects (TASK-0053-related) on 10 published Calc AB MCQs.
3. Repair `APBIO-MCQ-023` choice A, then write its 2 variants.
4. Check the AP Biology CED; the Product Owner asserted that signal sequences are in the 2026-27 curriculum.
5. Stay within CED vocabulary (Product Owner ruling), replace the published seeds that broke it, and re-derive the affected variants.
6. Document which subjects have had variant runs and which need one.

## 2. Outcome in one table

| Stream | Result |
|---|---|
| AP Biology pilot (Units 1-2) | 8 seeds audited, 16 variants written and checked, no variant in any database. Closed. |
| Calc AB repair | 11 published items repaired and labels carried forward (`APPROVAL-0066`), verified. |
| Biology `023` repair | Choice A rationale corrected, new version published (`APPROVAL-0067`), verified. |
| Biology seeds replaced | `APBIO-MCQ-005`, `018`, `021`, `022`, `023` replaced with CED-vocabulary text (`APPROVAL-0068`), keyed letters unchanged, labels carried forward, verified. |
| CED fact pack | Cites CED V.1 pp. 49-51, records that signal sequence / SRP are not in the CED. |
| Protocol | Section 10 added: variant-run status by subject and a pre-run checklist. |
| Open | Label probe on the final text; Calc variant re-check; seed topic relabelling; DECISION record for the CED-vocabulary ruling; whether any variant goes to review. |

## 3. Pilot method and what it found

**Steps used:** S0a seed audit first; variants written; sympy-style recompute was not applicable to Biology (judged by derivation); blind solve and rationale audit by both checkers; CED scope check by both; blind label probe (Gemini 3.5 Flash, 2 samples); similarity to the seed under 0.7; answer-length parity; adjudication of every flag by hand against the CED text, never by vote.

**Findings (Biology):**
- Key errors: 0 anywhere (0 of 16 seed solves and 0 of 28 variant solves disagreed with the key).
- Seeds: 1 of 8 had a defective rationale (`023` choice A, flagged by both models, verified by hand: the old text said not being labeled by impermeant biotin does not tell extracellular from cytoplasmic facing, which is false because the reagent labels extracellular-facing domains). Later, 5 of 8 seeds were found to depend on terms the CED does not name.
- Variants: the first draft had real defects the seeds did not (the pattern flipped relative to Calc, where seeds had the rationale defects). Round 1 patched 2 items (3 DeepSeek-only defects verified); several first drafts failed answer-length parity and were fixed by trimming the correct answer and lengthening distractors.
- Checker behavior: DeepSeek V4 Pro over-flags scope but caught every real content and scope defect; Gemini 3.5 Flash was lenient and found almost nothing in the CED check. Same asymmetry as Calc. Keep two families.
- Cost: about $2.45 of checker spend through pilot close; rounds 3-5 added smaller runs (not totalled).
- Label probe (early, one model, 2 samples): Production's provisional topic tags differed from the blind probe on 5 of 8 seeds (units right on all 8). Not acted on; needs three-model consensus.

## 4. The CED work (the longest thread)

1. The Product Owner stated that a signal sequence is a short N-terminal stretch that directs a protein to the ER. The College Board site was unreachable from the cloud session (egress block, not circumvented).
2. "Pages 88-95" turned out to be Unit 4 (printed pp. 81-88) and the start of Unit 5; irrelevant to Units 1-2. The relevant text is Topic 2.1 on printed pp. 49-51.
3. The Product Owner supplied screenshots; the edition is **Course Framework V.1, © 2025, confirmed latest**. The pack already matched the CED on Topic 2.1 (including the smooth-ER and Golgi exclusions); my earlier assumption that it was stale was wrong.
4. The CED never names signal sequence, signal peptide, SRP, co-translational targeting, or sorting to specific organelles, and its Golgi exclusion puts packaging of specific enzymes for lysosomes and secretory vesicles out of scope.
5. Pack edited (`f761aa1`): CED page citations and a note listing the absent terms.
6. `021-v2` rewritten at CED level (a pulse-chase through rough ER, Golgi, vesicles; passes both models).
7. After round 3, DeepSeek alone still flagged 7 variants. Each flag was read against the CED text: the terms really are absent (isomers, receptor-mediated endocytosis, clathrin, 70S/80S ribosomes, binary fission, integral/peripheral proteins), they are inherited from the published seeds, and the stems supply the mechanism. Disulfide bridges are in the CED (1.7.A.5), so that flag on `008-v1` was borderline only.
8. **Product Owner ruling: "stay within the CED vocab."** Items may not rely on terms the CED does not name, even if the stem supplies them.
9. Round 4: six variants rewritten (`018-v1`, `018-v2`, `021-v1`, `022-v1`, `023-v1`, `023-v2`) and `008-v1` choice B changed (disulfide to ionic). All passed the content check; scope passed except two DeepSeek-only flags, both adjudicated: `021-v1` (0.90) read as an over-read prompted by the pack note that names the out-of-scope terms; `022-v1` (0.70, low confidence) uses only CED words, the only gap being which membrane layer came from the host, which the stem supplies. Both kept; the reviewer should judge `022-v1` (`022-v2` is the cleaner CED-level test).
10. Seed remediation (`APPROVAL-0068`): `005`, `018`, `022` keep their idea in plain language (for example `005` lost the word "isomer" but kept same atoms, different arrangement, different shape); `021` and `023` are replacement items on the same topic because the original mechanism cannot be stated in CED vocabulary. The Product Owner approved the old-versus-new preview (`scripts/content-seed/apbio-seeded-pilot-2026-09-30/SEED_REMEDIATION_PREVIEW.md`) and waived the rolled-back rehearsal.
11. Round 5: the `005` pair, held until the seed existed in plain language, was re-derived and passed both models on content and scope.

## 5. Production changes made (all verified afterwards)

| Approval | Change | Verification highlights |
|---|---|---|
| `APPROVAL-0066` | 11 Calc AB MCQs (`apcalcab-mcq-037` key letter; 10 distractor-rationale repairs; `031` had two unexplained wrong-answer numbers replaced), serving labels carried forward (5 validated items restored with their original validation records) | Rolled-back rehearsal first. Records fix; labels fresh. |
| `APPROVAL-0067` | `APBIO-MCQ-023` choice A rationale (new version v2) | Rolled-back rehearsal first, then real run; key D unchanged; labels restored. |
| `APPROVAL-0068` | `APBIO-MCQ-005` v3, `018` v3, `021` v2, `022` v2, `023` v3 | **No rehearsal (waived).** 5 repaired, 10 labels restored; each the only published version; 4 choices, one correct, letters unchanged (005 C, 018 B, 021 C, 022 A, 023 D); no desync; labels `validated` / `provisional_model`, hash-fresh, carrying the approval id. Counts before and after identical: 118 published versions, 160 published items, 69 validated serving labels, 6 stale labels (older, unrelated). No `anon`/`authenticated` grant on `is_correct`/`rationale`. |

Dev (`wmgjsdkphcyhngaffbqf`) has none of these items; nothing was applied there.

## 6. Mistakes and corrections (candid)
- I did not read the Biology fact pack before writing variants; `005-v2` broke an explicit exclusion (specific amino acid structure). Rule now in the protocol checklist: read the pack first.
- I changed the task type in a rewrite (transport to enzyme), which drifted into Unit 3. The label probe now runs on drafts.
- I expected a pack refresh to clear DeepSeek's scope flags. It did not: the pack already matched the CED. The flags were accurate about vocabulary; the issue was policy.
- First-draft answer-length parity failures (6, then 2 rewrites).
- Calc pilot files' letters differ from the database; the database was treated as authority.
- I called one variant's similarity to its seed acceptable at 0.58 (`005-v1`); it is the closest of any variant. Reviewer can ask for more separation.
- PR #303's title and body went stale; corrected before merge.
- The activity log index and entries were prepended to by two PRs at once and conflicted twice; both resolved by keeping both entries.

## 7. Process and tooling notes for next time
- The cloud container has no gateway key; every model check ran on the Product Owner's Mac. Produce the exact paste-ready block, one branch, absolute paths. Stray habits that cost time: running a pasted block on the wrong branch; `git checkout main` fails on that Mac because `main` is checked out in another worktree (`.codex/worktrees/1a38`), so use `git checkout -B <branch> origin/main`; vim opens for merge messages (`Esc`, `:wq`).
- Once a PR merges, new results need a new branch off main. Do not keep pushing to the merged branch.
- Keep the generator scripts idempotent and never re-run `build_variants*.py`: it redraws the letters. Patch scripts (`patch_*.py`) replace named items only.
- Do not name the out-of-scope terms in prompts to the scope checker without thinking: it nudged DeepSeek to over-read `021-v1`.

## 8. Open items (owners)
| # | Item | Owner | Note |
|---|---|---|---|
| 1 | Label probe on the final text (24 items) | Product Owner (laptop) | Command below. Watch `023-v1`, `023-v2`, `005-v1`, `005-v2` for Unit 1 drift. |
| 2 | Record the "stay within CED vocabulary" ruling as a DECISION | Product Owner / next session | Currently recorded only in `APPROVAL-0068` and the protocol checklist. I did not create a decision number. |
| 3 | Re-check the 24 seeded Calc variants against the repaired Calc seeds | next session | Noted since the Calc repair. |
| 4 | Seed topic relabelling by three-model consensus | next session | One model, 2 samples only so far. Re-run after the seed changes. |
| 5 | Whether any variant goes to review or Production | Product Owner | Needs its own approval. Two DeepSeek-only scope flags (`021-v1`, `022-v1`) need reviewer judgement. |
| 6 | Subjects with no variant run (Calc BC, Chem, Phys 1/2/C E&M/C Mech, Precalc, Stats) and Biology Units 3-8 | Product Owner to prioritize | See protocol section 10. |
| 7 | Promote the CED-vocabulary rule from the section-10 checklist into the protocol body (sections 3-4) | next session | |

Probe command (new branch off main; replaces nothing):
```
cd /Users/davidbloom/Documents/Cramapple.nosync
git fetch origin main
git checkout -B claude/apbio-label-probe origin/main
cd scripts/vercel-gateway-check
B=../content-seed/apbio-seeded-pilot-2026-09-30
node apbio_seeded_label_probe.mjs $B/probe_items_final.json $B/out_labels_final --model=google/gemini-3.5-flash --taxonomy=$B/taxonomy_bio.json --samples=2 --keys=$(cat $B/probe_keys_final.txt)
cd ../.. && git add scripts/content-seed/apbio-seeded-pilot-2026-09-30/out_labels_final && git commit -m "AP Bio pilot: label probe on the final text" && git push -u origin claude/apbio-label-probe
```

## 9. Handoff packet

```text
Task:
- No TASK id. Seeded-item generation (DECISION-0093), AP Biology pilot follow-through.

Current Source:
- Task doc: none. Governing: docs/research/SEEDED_ITEM_GENERATION_PROTOCOL_2026_09_30.md (section 10)
- Related docs: scripts/content-seed/apbio-seeded-pilot-2026-09-30/PILOT_REPORT.md, SEED_REMEDIATION_PREVIEW.md; docs/product/AP_BIOLOGY_CED_FACT_PACK.md
- Latest commits reviewed: main after #305 merged; #303 merged earlier
- Branch / PR: all pilot PRs merged. This record is on claude/seeded-question-generation-9rxlqc.
- Uncommitted / unpushed state (R4): none.

Approval State:
- Approved and used: APPROVAL-0066, 0067, 0068
- Not approved: loading any variant into any database; any further Production content change
- Required before execution: new approval for any Production write

Live / Tool State:
- Environments checked: Production (pcntajvbdfqhbeewmdry), read and the three approved writes only. Dev: not touched.
- Not checked: unit-gated servable count after APPROVAL-0068 (labels verified hash-fresh instead); the real answer-length detector in supabase/functions/_shared/mcq-quality.ts. Checked at close: no attempts exist on any version of the five replaced seeds (see the grading notes).

Files / Systems Affected:
- Docs: protocol section 10, fact pack, PILOT_REPORT, activity and approvals logs
- Data/schema: Production content tables for 16 items across the Calc and Biology repairs
- Code: only check scripts under scripts/vercel-gateway-check/ (apbio_seeded_*)

Open Risks / Blockers:
- P2: label probe not run; variants unreviewed; DECISION for the CED-vocabulary ruling missing
- Pending owner decisions: items 2, 5, 6 in section 8

Do Not Touch:
- Do not re-run build_variants.py or build_variants_023.py (letters would be redrawn)
- Do not load variants anywhere without an approval
- Do not change Production topic or unit labels from the one-model probe

Next Expected Output:
- Label probe results (out_labels_final) read and adjudicated; then the owner's call on review.
```
