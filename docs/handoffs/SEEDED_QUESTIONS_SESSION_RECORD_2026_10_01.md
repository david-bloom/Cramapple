# Seeded Question Generation: Session Record (2026-09-30 to 2026-10-02)

Scope of this file: **seeded question generation only** (the protocol, the AP Biology pilot, the CED-scope work, the Production repairs that came out of the audits). Notes that bear on **grading** are kept apart in `GRADING_NOTES_FROM_SEEDED_QUESTION_SESSION_2026_10_01.md`.

Governing records: `DECISION-0093` (seeded-item protocol), `docs/research/SEEDED_ITEM_GENERATION_PROTOCOL_2026_09_30.md` (now with section 10, status by subject). Approvals used: `APPROVAL-0066`, `APPROVAL-0067`, `APPROVAL-0068`. Merged PRs from this session: #303, #305 (earlier in the work: #302; the Product Owner also pushed #297 during the Calc repair work). Author: Claude Sonnet 5.5. Checkers: `google/gemini-3.5-flash` and `deepseek/deepseek-v4-pro`.

## Addendum, 2026-10-03: what changed on `main` after this record was drafted (read this first)

This record was written on 2026-10-02. Other sessions then landed substantial work on `main` on 2026-10-02, and several statements below were true when written and are no longer. The corrections are made in place where short; the important ones are here.

1. **Another AP Biology variant set is published in Production.** `APPROVAL-0080` loaded and published **24 Biology Units 1-2 variants** (keys `APBIO-MCQ-SV-<seed>-v1..v3`, 9 seeds, checked by `gemini-3.8-flash` and `deepseek-v4-pro`; 6 of 30 drafts dropped). That is a **different set from this session's 16 drafts** (`apbio-mcq-sv-...`), which remain in **no database**. Statements below that "no variant is in any database" describe this session's 16 only.
2. **The two sets overlap.** From the first 150 characters of each published item (a read-only Production query; no full comparison was made): `SV-005-v1` is the same galactose/glucose pair as this session's `005-v1`; `SV-018-v1` and `SV-018-v3` are the same transferrin and LDL receptor cases as `018-v1` and `018-v2`; `SV-022-v1` is the same chloroplast evidence list as `022-v1`; `SV-023-v1` is the same channel-protein R-group question as `023-v2`. Loading this session's drafts as well would put near-duplicates in the bank.
3. **Some published variants use terms the 2026-10-01 CED-vocabulary ruling excludes.** Seen in the first 150 characters only: "70S ribosomes" (`SV-014-v1`, `SV-014-v2`, `SV-022-v3`, also "80S"), "receptor-mediated endocytosis" (`SV-018-v1`, `SV-018-v3`), "high-salt" membrane-protein release (`SV-023-v2`), "one hydroxyl group is oriented differently" (`SV-005-v1`). The rest were not read. `APPROVAL-0080` records that the seed-level CED scope check on the 10 Biology seeds was **not** approved or done, and its checkers did not have this session's CED-vocabulary ruling. **Resolved 2026-10-03:** the Product Owner decided to retire them ("We have enough questions"). A full-text scan of all 24 found 7 with terms confirmed absent from the CED; `APPROVAL-0091` retired exactly those 7 (`SV-014-v1`, `014-v2`, `018-v1`, `018-v3`, `022-v1`, `022-v3`, `023-v2`). 17 published variants remain. `SV-005-v3` ("tripeptides") was deliberately kept as a generic label, not a separate concept. No replacements were written and this session's 16 drafts stay unloaded.
4. **Biology topics were corrected by three-family consensus** (`APPROVAL-0079`): 73 primary topic cells replaced, 42 across units, and **`APBIO-MCQ-005` is now Unit 2** (it was Unit 1). This closes the "seed topic relabelling by three-model consensus" open item below. It also means this session's `005-v1` and `005-v2` drafts, written as Unit 1, topic 1.3, are mislabelled against their seed.
5. **Biology serving and skills moved on:** the 22-skill by 60-topic grid was created and 70 live items relabelled (`APPROVAL-0073`: unit-gated servable 43 to 110 of 118); skill cells were re-voted (`APPROVAL-0081`). The validation constraint on cells was relaxed so model-consensus labels can be `validated` (`APPROVAL-0072`).
6. **Chemistry and Statistics now have variant runs** (`APPROVAL-0074` to `0078`); Calc AB Units 2-3 pilot started (`APPROVAL-0082`, `0083`). Protocol section 10 has the current table.
7. **Approval numbering:** an earlier-numbered Calc AB approval was renumbered 0082/0083 because 0069/0071 were taken by the Stripe cutover. This record's `APPROVAL-0066`, `0067`, `0068` are unaffected.

### Further update, 2026-10-03 (later the same day)
- **Three more items retired (`APPROVAL-0092`):** `APBIO-MCQ-014` (70S/80S), `APBIO-MCQ-063` (signal sequence), `APBIO-MCQ-025` (kidney ADH outside the pack). A scan of the published seed-style MCQs found `014` and `063`. **Correction to this record:** `014` also used out-of-CED terms, so six of the eight pilot seeds (not five) were affected; I missed `014` when the five seeds were replaced.
- **`DECISION-0095` records the CED-vocabulary rule** (and the "retire, don't repair" preference). Biology now has 174 published items, 62 seed-style MCQs and 17 published variants.
- **Not caused by this work but found by it:** 42 Biology items (20 FRQ, 22 MCQ) were marked `published` with all versions retired. **Resolved the same day (`APPROVAL-0095`):** none was being served (the selector needs a published version); 38 were set to `retired` at item level. Four were held, then retired the same day under `APPROVAL-0096` after the Product Owner confirmed the attempts were tests and the latest versions were retired. Biology now has 132 published items, each with a published version. The Product Owner asked for no rescan of other subjects' banks under `DECISION-0095`.

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
| AP Biology pilot (Units 1-2) | 8 seeds audited, 16 variants written and checked; **these 16 are in no database** (a different 24-variant set was published on 2026-10-02, see the addendum). Closed. |
| Calc AB repair | 11 published items repaired and labels carried forward (`APPROVAL-0066`), verified. |
| Biology `023` repair | Choice A rationale corrected, new version published (`APPROVAL-0067`), verified. |
| Biology seeds replaced | `APBIO-MCQ-005`, `018`, `021`, `022`, `023` replaced with CED-vocabulary text (`APPROVAL-0068`), keyed letters unchanged, labels carried forward, verified. |
| CED fact pack | Cites CED V.1 pp. 49-51, records that signal sequence / SRP are not in the CED. |
| Protocol | Section 10 added: variant-run status by subject and a pre-run checklist. |
| Open | **Overlap and CED-vocabulary conflict with the published 24-variant set (addendum items 2 and 3)**; label probe on the final text; Calc variant re-check; DECISION record for the CED-vocabulary ruling. (Seed topic relabelling was done by `APPROVAL-0079`.) |

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
| 2 | ~~Record the "stay within CED vocabulary" ruling as a DECISION~~ | **Done 2026-10-03: `DECISION-0095`** | Applied so far to AP Biology only; other subjects' published banks were not scanned (open). |
| 3 | Re-check the 24 seeded Calc variants against the repaired Calc seeds | next session | Noted since the Calc repair. |
| 4 | ~~Seed topic relabelling by three-model consensus~~ | **Done 2026-10-02, `APPROVAL-0079`** | `APBIO-MCQ-005` is now Unit 2; this session's `005` variants still say Unit 1 / topic 1.3. |
| 5 | ~~**Reconcile the two Biology variant sets.**~~ **Done 2026-10-03, `APPROVAL-0091`:** the 7 published variants with out-of-CED terms were retired; this session's 16 drafts stay unloaded (the bank is large enough). Original item: **Reconcile the two Biology variant sets.** Decide whether the 24 published variants that use terms outside the CED stay, are retired, or are replaced by this session's 16 drafts, and whether any of the 16 are loaded at all | Product Owner | Needs its own approval. Two DeepSeek-only scope flags (`021-v1`, `022-v1`) also need reviewer judgement if the drafts are used. |
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

## 9. Handoff packet (refreshed at session close, 2026-10-03)

```text
Task:
- No TASK id. Seeded-item generation (DECISION-0093) and the CED-vocabulary rule (DECISION-0095), AP Biology.

Current Source:
- Task doc: none. Governing: docs/research/SEEDED_ITEM_GENERATION_PROTOCOL_2026_09_30.md (section 10), DECISION-0095
- Related docs: scripts/content-seed/apbio-seeded-pilot-2026-09-30/PILOT_REPORT.md, SEED_REMEDIATION_PREVIEW.md; docs/product/AP_BIOLOGY_CED_FACT_PACK.md; docs/handoffs/GRADING_NOTES_FROM_SEEDED_QUESTION_SESSION_2026_10_01.md
- Branch / PR: #303, #305, #311, #319 merged. #320 (DECISION-0095, APPROVAL-0092/0095/0096 records) is open on claude/seeded-question-generation-9rxlqc, merged with main at close.
- Uncommitted / unpushed state (R4): none.
- A new task, TASK-0059 (apply DECISION-0095 to all subjects, parked), was opened by another session. The Product Owner said on 2026-10-03 not to rescan other subjects under DECISION-0095 for now.

Approval State:
- Approved and used: APPROVAL-0066, 0067, 0068, 0091, 0092, 0095, 0096 (0095 and 0096 were recorded as 0093 and 0094 while in progress and renumbered at merge; the AP Precalculus session holds 0093 and 0094)
- Not approved: loading this session's 16 unloaded variant drafts; any other Production content change; any rescan of other subjects
- Required before execution: a new approval for any Production write

Live / Tool State:
- Environments checked: Production (pcntajvbdfqhbeewmdry), reads and the approved writes only. Dev: not touched.
- Production now: Biology 132 published items, each with a published version; 62 seed-style MCQs and 17 variants published; 163 validated serving labels. Verified after each approval.
- Not checked: the unit-gated servable count after the retirements (it cannot rise); the real answer-length detector in supabase/functions/_shared/mcq-quality.ts; Biology Units 3-8.

Files / Systems Affected:
- Docs: protocol section 10, fact pack, PILOT_REPORT, SEEDED_QUESTIONS record, GRADING_NOTES, approvals/decisions/activity logs, docs/INDEX.md
- Data/schema: Production content tables only (item and version status, new versions for 5 seeds, label carry-forward)
- Code: check scripts under scripts/vercel-gateway-check/ (apbio_seeded_*) only

Open Risks / Blockers:
- None blocking. P3: the 17 published variants still overlap some of this session's drafts in idea; the drafts stay unloaded.
- Pending owner decisions: whether to ever use the 16 drafts (then run the label probe first); Biology Units 3-8; how and when TASK-0059 is run.

Do Not Touch:
- Do not re-run build_variants.py or build_variants_023.py (letters would be redrawn)
- Do not load variants anywhere without an approval
- Do not rescan other subjects under DECISION-0095 until the Product Owner says so

Next Expected Output:
- None required. If the drafts are ever wanted: run the label probe (command in section 8), then ask for an approval.
```
