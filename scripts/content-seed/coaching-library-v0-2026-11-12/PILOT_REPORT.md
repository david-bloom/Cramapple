# Coaching library v0, Layer 3 pilot report (2026-11-12)

Plan: `docs/product/COACHING_LIBRARY_V0_PLAN_2026_11_12.md`. Step 0: `STEP0_REPORT.md`. Spend ledger: `spend_ledger.json` (total $2.62 of the $10 ceiling; no run over the $3 per-run cap). Synthetic inputs only; no student data.

## Labels (199 distractors, one per item family, generator gpt-6-luna, judges Gemini 3.8 Flash + Qwen 3.8 Flash)
- First pass: 144 checked, 55 blocked, 94 regenerated. Cause of most blocks: Qwen `motive_claim` flagged 76 of 78 first drafts where Gemini agreed on 2; none of five labels read contained motive language.
- Judge-calibration fix (David approved 2026-11-12): `motive_claim` is true only when the label states or implies the student's own reasoning; "Choice D says..." is false. Re-judged the 55 blocked: 46 now checked, 9 still blocked (4 verbatim-quote failures, 2 banned-word hits, 1 error-type format, 2 judge flags). Result: **190 checked, 9 blocked, 0 insufficient-source of 199**.
- Controls: 8 of 8 (first run) and 8 of 8 (rejudge: 7 of 8 by both, 8 of 8 by either) then 16 of 16 caught by both judges on the corrected criterion.
- Source audit: 6 authored rationales flagged as suspect by a judge, unread by a human: APSTATS-MCQ-SV-H-2.6-A-v2 (C), apstats-mcq-b6-h-1.12-b (D), APSTATS-MCQ-037 (A), apbio-mcq-b4-sv-h-4.6-a-v3 (C), APBIO-MCQ-055 (D), apbio-mcq-b5-h-2.4-a (C). Needs a qualified subject reviewer.
- Error types: 162 distinct free-text values over 199 labels. No usable taxonomy yet; needs clustering.
- Not done: human read of any label.

## Ablation (held-out families, MCQ, baseline A vs +label B, generators haiku-5.5 and luna)
66 of 70 held-out items had a checked label (4 excluded), 132 item x generator pairs, 264 texts, both judges on each, 8 of 8 planted coaching controls caught per run.

| | A baseline | B +label |
|---|---|---|
| Texts | 132 | 132 |
| Flagged by either judge | 21 | 20 |
| Judge factual-false | 1 | 3 |
| Would help (1-5) | 4.60 | 4.57 |
| Defect and fix named | 4.75 | 4.73 |
| Why required | 4.62 | 4.62 |
| Words (haiku / luna) | 116 / 77 | 118 / 77 |
| Input tokens per call | 883 | 1017 |

Paired: would-help B better in 29 pairs, A better in 34, tie in 69 (mean difference -0.03). Flag in B only: 14; A only: 15; both: 6.
Per generator: haiku B slightly better (would help 4.73 vs 4.63, 8 vs 12 flags); luna B worse (4.41 vs 4.58, 12 vs 9 flags, 2 factual flags).

Adjudicated so far (two of the three first-round factual flags): APSTATS-MCQ-030 C (luna, B) real flaw: says choice C does not pick a value in the observed range though the mean of x lies in it; the stem has no data, so the item itself is a weak source. apbio-mcq-b6-sv-h-1.3-b-v3 A (luna, B): loose restatement of the question, not a biology error. The remaining flags are not adjudicated.

## Reading
- By the plan's decision rule, Layer 3 labels show **no measurable benefit** on this sample beyond the authored rationale alone: ties on judge scores, no change in flags, slightly more factual flags in B, about 15% more input tokens. This is a pilot result, not proof of no effect.
- Limits: judges saturate near 4.6 of 5; 66 items; one pick per item; synthetic first-miss state; judge scores only. **The blinded human read (BLINDED_PAIRS.md, 20 haiku pairs) is the deciding evidence and has not been done.**
- Model pick is not settled by this: haiku exceeds the 100-word cap (116 average) and luna does not.

## Recommendation
Do not run the full 2,360-label pass ($9-18) as grounding for coaching on this evidence. Wait for the human read. Labels may still be worth building for other uses (cross-item patterns, skill linkage, gaps register) that this ablation does not test; that is a separate case.

## Second approach: explainer links (David chose "link to explainer", 2026-11-12)
Rationale for the change: the first labels restated the authored rationale, so they added nothing. A link points each wrong choice at one verbatim passage from the same topic's approved explainer or point brief, and records what the passage adds beyond the rationales. Script `link.mjs`; data `link_items.json` (Production, read-only: all 199 items have a published explainer and brief across 78 topics; none has a skill code, so skill linkage is impossible until TASK-0050 Phase B).

Links (199 items, drafter gpt-6-luna, same two judges, planted controls 8 of 8 caught by both, wrong-topic quote and overclaimed content):
- Checked 75 (38%; Biology 38, Statistics 37). No suitable passage 71. Redundant with the rationale 17. Blocked 36 (24 on a Gemini flag, 4 Qwen, 2 non-verbatim quote, 6 redundant-style).
- 71 links were judged by both judges to add something the rationales do not say.
- Passages used: mostly `explainer.core_idea` (37) and `explainer.understand` (16). Almost none from `common_point_loss`, the field most aimed at errors.

Ablation, arm C (baseline plus the linked passage) vs the existing arm A, 17 held-out items with a link, 34 texts per arm (both generators). A first scoring of arm C was **invalid and discarded**: the C judge schema had lost the "1-5" and "none" descriptions the A judge had (my error), so Gemini scored on a different scale and flagged every C text. C was re-judged with the identical schema (judgement of the existing texts, no regeneration; $0.14).

| | A baseline | C +passage |
|---|---|---|
| Texts | 34 | 34 |
| Flagged by either judge | 5 | 6 |
| Judge factual-false | 0 | 2 |
| Would help (1-5) | 4.59 | 4.71 |
| Defect and fix | 4.78 | 4.87 |
| Why required | 4.60 | 4.63 |

Paired would-help: C better 12, A better 4, tie 18 (mean +0.12). Haiku 4.65 to 4.79; luna 4.53 to 4.62.

Factual flags in C, adjudicated by me (not a subject specialist): APSTATS-MCQ-SV-H-3.8-A-v3 D (luna): the text says the question asks for the chance the test rejects H0 when p = 0.20, but the stem asks which statement is correct; a misstated question, minor, the statistics is right. APBIO-MCQ-SV-008-v1 A (haiku): the text calls R-group interactions noncovalent while the passage lists disulfide bridges, which are covalent; imprecise, plausibly a real minor error. Both need a qualified reviewer.

Reading: a small positive signal for linked passages, unlike the first labels. Caveats: coverage is only 38%; 17 items; judges near ceiling; the passage is also shown to the judge in C but not in A, so C's flags are not strictly comparable; the human read has not been done. Spend: total $3.61 of the $10 ceiling.
