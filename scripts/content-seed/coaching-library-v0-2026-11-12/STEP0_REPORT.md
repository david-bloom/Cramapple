# Coaching library v0: Step 0 report (read-only)

Date: 2026-11-12. Plan: `docs/product/COACHING_LIBRARY_V0_PLAN_2026_11_12.md` (section 10, Step 0). Source: Production, read-only SQL; CED PDFs in `docs/teaching/`. Nothing written anywhere except this directory. No model spend in Step 0.

Eligible population: published, non-retired-pack MCQ items for subjects `biology` and `ap-statistics`; distractor = `mcq_choices` row with `is_correct = false`.

## 1. Denominators

| | Biology | Statistics | Total |
|---|---|---|---|
| Items | 401 | 452 | 853 |
| Item families (key minus trailing `-vN`) | 232 | 254 | 486 |
| Distractors | 1,203 | 1,356 | **2,559** |
| Correct choices | 401 | 452 | 853 |
| Items with stimulus/image | 96 distractors on such items | 135 | 231 |

The earlier "2,583" was an estimate; use 2,559. 55% of items sit in variant families (Biology 262 of 401, Statistics 297 of 452), so one family can have up to three near-identical items. Split and sampling must work by family (done below).

## 2. Rationale quality (the only source for Layer 3)

Rationale length of distractors, characters:

| Bucket | Biology | Statistics |
|---|---|---|
| none | 0 | 0 |
| under 60 | 5 | **157 (11.6%)** |
| 60 to 119 | 496 | 860 |
| 120 to 239 | 299 | 319 |
| 240 and over | **403 (33.5%)** | 20 |
| Starts "Incorrect/This is wrong..." | 25 | 0 |
| Distinct rationale text | 1,203 of 1,203 | 1,295 of 1,356 |

Findings:
- Every distractor has a rationale and every correct choice does too, so nothing is "missing" outright. Length is a poor proxy for usefulness; this table is a screen, not a quality verdict. Real quality (does the rationale name the error, is it supported by the stem) is what the pilot measures.
- Statistics rationales are short. 157 are under 60 characters, and most of the rest are one sentence. A label drawn from these may be thin; expected outcome is that many Statistics "why required" and "requirement lost" fields cannot be supported and go to the gaps register rather than being filled.
- Biology rationales are long (a third over 240 characters), so they hold more, but label drafts must compress without adding claims.
- 61 Statistics distractors share a rationale with another distractor (1,356 minus 1,295). These are exact source-equivalent candidates for dedupe; they were not merged.
- The audit did not test whether the authored rationale is correct. An approved label could repeat a wrong rationale (assessor's point); the pilot samples for this and escalates answer-key disputes.

## 3. Explainer citability (Layer 6 gate)

Published explainers: Biology 60, Statistics 55; all have `how_this_becomes_points`, `common_point_loss`, `answer_move` and a `source_note`. Average sizes: `how_this_becomes_points` 188 characters (Biology) and 273 (Statistics); `common_point_loss` 82 and 127 (minimum 40 and 62); the five prose fields together about 810 and 1,280.

Reading: structurally citable by field, and short enough to cite whole. `common_point_loss` is very short in places (a Biology one is 40 characters), which limits how much it can support. **Not done:** a factual-support audit of explainer content against the CED, so "citable" here means present and field-addressable, not verified. Recommendation: no layer 6 in v0; revisit only if the pilot shows claims being rejected for lack of a concept source. This is a recommendation, not a scope change; layer 6 stays unapproved.

## 4. Layer 1: command verbs and CED definitions

Both CEDs define task verbs: AP Biology (2025 edition) lists about 14 entries (Calculate, Construct/Draw, Describe, Determine, Evaluate, Explain with how/why, Identify, Justify, Make a claim, Predict, Represent, State (the null hypothesis), Support a claim; count from a text extraction, confirm before authoring); AP Statistics (2026 edition) lists at least 11 (Calculate, Compare, Complete, Construct, Describe, Determine, Estimate, Explain, Identify/Classify, Interpret, Justify; the extraction was cut at a page break, so confirm the full list before authoring).

Use in published FRQs, items whose prompt contains the word (counts words anywhere in the prompt, so they include non-command uses; treat as indicative):

| Word | Items | Bio | Stats |
|---|---|---|---|
| explain | 53 | 33 | 20 |
| describe | 30 | 23 | 7 |
| show | 30 | 5 | 25 |
| identify | 21 | 13 | 8 |
| test | 21 | 2 | 19 |
| predict | 21 | 21 | 0 |
| justify | 19 | 11 | 8 |
| calculate | 18 | 9 | 9 |
| support | 14 | 9 | 5 |
| state | 13 | 2 | 11 |
| interpret | 11 | 0 | 11 |
| verify | 9 | 0 | 9 |

Gap: Statistics FRQs lean on **show, test, verify, check, state** (used 25, 19, 9, 3, 11 times), none defined as a task verb in the Statistics CED text found. Those entries would be `claude_authored` from the rubric criteria, flagged in the gaps register. Published FRQ counts were not re-run in this step (Statistics 110, Biology 89 from earlier). Estimated Layer 1 size: about 12 to 15 verbs per subject, fully readable by a human.

## 5. FRQ rubric source (Layer 1 and FRQ coaching)

`frq_criteria` carries `learner_facing_text`, `points_possible`, `evidence_requirements`, `minimum_fix`, `accepted_variants`, `judgement_kind` for 6,735 rows (all subjects); none lacks evidence requirements or a minimum fix. Rubric content for FRQ coaching exists and needs no authoring.

## 6. Mapping and fingerprints

Natural key = `content_key` plus `content_item_versions.version_num` (the column is `version_num`); the Production UUID is carried alongside. Source fingerprint plan: sha256 of the canonical JSON of the distractor's `choice_text`, its `rationale`, the correct choice's `rationale`, and the stem, recorded on each label so a changed source invalidates it. Dev/Prod UUID differences were not checked in this step (Production only).

## 7. Pilot sample (Layer 3)

Method: `pilot_selection.sql` (deterministic, md5 seed `pilot1`). One distractor per item family (not per item), stratified by rationale bucket and subject, split held-out by family hash.

| Subject | Bucket | n | Held-out |
|---|---|---|---|
| Statistics | thin | 25 | 10 |
| | short | 40 | 13 |
| | mid | 28 | 9 |
| | long | 7 | 3 |
| Biology | short | 49 | 18 |
| | mid | 30 | 10 |
| | long | 20 | 7 |

199 labels in total (Statistics 100, Biology 99), 70 held-out (35%) and 129 development. The pilot's Biology "thin" bucket is empty because only 5 Biology distractors are under 60 characters and the family rule excluded them. Raise the Statistics oversampling of thin rationales deliberately: it is where the risk lives.

An earlier exploratory selection split by item and put variant items on both sides of the split; this version supersedes it.

## 8. Review design

- **Pilot (199).** David reads a stratified 40 for voice and usefulness (all 25 Statistics-thin plus 15 across other strata). A qualified subject reviewer, identity still open, reads at least 40 chosen as: every label where the two checkers disagree or flag, every label drafted from a rationale under 60 characters, and a random 15. This sample gives no defect-rate guarantee: 0 defects in 40 reads leaves a 95% upper bound of about 7%, so report individual adjudicated failures, not a rate claim.
- **Each later batch (about 400 labels).** At least 60 reads per batch gives a 95% upper bound near 5% if zero defects are found; one material defect triggers a wider read and batch repair before approval. `approval_basis: batch` on unread entries.
- Subject-correctness disputes go to the qualified reviewer; the source fields and the model checkers cannot settle them.

## 9. Cost (estimates; none spent)

Unit costs are the measured values from earlier passes: coaching text $0.0002 to $0.0005; judge call $0.0015 (Qwen) to $0.003 (Gemini), mean $0.00164 measured in pass 2.

| Step | Calls | Estimate |
|---|---|---|
| Pilot: 199 label drafts, two checkers, one regeneration for about 10% | about 1,000 | $0.9 to $1.5 |
| Pilot: planted label controls (about 8 per run) | small | under $0.05 |
| Pilot ablation on 70 held-out MCQs: 2 generators x 2 arms = 280 coaching texts, each judged twice | about 840 | $1.6 to $2.6 |
| Pilot retries and reruns allowance (50%) | | about $1.3 to $2.1 |
| **Pilot total** | | **about $4 to $6** |
| Full labelling of the remaining 2,360 distractors (drafts under $1, two judges $7.6 to $14, retries 20%) | | $9 to $18 |
| Layers 1 and 5 (small, judged, human-bound) plus FRQ ablation | | $2 to $4 |
| **Whole v0, if the pilot passes** | | **about $15 to $28** |

The earlier $15 to $25 sat in the same range; the previous $6 to $10 for labels alone was too low. A per-run cap of $3 holds for every pilot run above. Ask for a recorded ceiling before any paid run (open question 5).

## 10. Held-out ablation test set

The pilot's 70 held-out MCQ families are frozen by the SQL method above. The FRQ test set, the synthetic student responses, and the Layer 5 exemplar/held-out split are **not yet frozen** and must be before any generation. The pass-2 and pass-3 items stay development-only.

## 11. What Step 0 does not settle

- Whether authored rationales are correct (pilot sample).
- A factual audit of explainers.
- Dev/Prod mapping and fingerprint implementation.
- Who the qualified subject reviewer is.
- Which of the 22 packet texts are approved exemplars.
- Gateway key rotation status.

## 12. Recommended next actions, subject to David's approval

1. Record a spend ceiling and name the qualified subject reviewer (or accept the pilot with model checks plus David's read only, labelled as such).
2. Scaffold `docs/coaching_library/v0/` and the validator (no spend).
3. Layer 5 approval pass on the packet texts (needs David).
4. Run the 199-label pilot and MCQ ablation (about $4 to $6).
5. Review, then decide on full labelling.
