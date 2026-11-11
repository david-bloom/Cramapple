# Question difficulty improvement plan (2026-11-11)

**Status:** Draft for Product Owner review. Owner direction 2026-11-11: audits found difficulty is an endemic problem across subjects; correct it at scale; some duplicates are fine for practice but must be exceptions.
**Not the same as the `difficulty_label` metadata.** `difficulty_label` (Easy/Medium/Hard, see `TIER3_LABELS_DIFFICULTY_PAIRED_PLAN_2026_09_25.md`) orders items for serving. This plan is about the **cognitive demand actually in the question**. The two disagree today: AP Statistics seeds whose metadata said Hard (for example 061, 066, 063) were one-step recall.

## 1. What we found
- **AP Statistics Units 2 to 4** (APPROVAL-0214, 0215, 0217): 9 of 26 Unit 3 seed families and 13 of 23 Unit 4 MCQs were one-step recall (R1); exact duplicate seeds; a proportion item filed under a means topic; a mean-CI key built with z*; topics with no MCQs at all. Variants inherit their seed's difficulty, so one weak seed produced a whole weak family.
- **Other subjects, topics 3.1 to 3.3 only** (`output/other_subjects_3_1_to_3_3_audit.xlsx`, 234 MCQs, AI-judged, not yet calibrated): R1 share Precalculus 79%, Chemistry 50%, Physics C 39%, Calculus BC 37%, Physics 1 31%, Calculus AB 29%, Biology 19%. R3 is 0 to 2% in Calculus, Chemistry and Precalculus. Duplicates are common (Physics 1 14 flagged items; the same cos(3x^2) and e^(sin x) pairs in both Calculus AB and BC). Physics C 3.1 is Physics 1 level.
- **Root cause:** the pipeline checks that an item is correct and well formed, never how demanding it is. Nothing at authoring or publish time says "this seed is R1".

## 2. The standard
- **R1** one-step recall or substitution. **R2** apply a method in a short context. **R3** interpretation, multi-step reasoning, or misconception-driven reasoning where each wrong choice is a real student error.
- **Seed rule:** no new seed is R1. Each seed has a stated skill, and each distractor has a named misconception and a rationale (the pattern that worked in the Statistics rewrites).
- **Topic mix target (to be confirmed by the Product Owner):** at least one third of seed families R3, the rest R2; R1 only as a deliberate warm-up, at most one seed per topic.
- **Subject expectation:** Physics C and Calculus BC are judged against their harder level, not against Physics 1 and Calculus AB.
- **Duplicates:** semantic duplicates (same function or numbers and the same answer set, regardless of wording) are allowed only as marked practice repeats, at most one per seed family, never both a seed and its variant at the same numbers.

## 3. The tool (read-only, built first)
`scripts/difficulty-audit/` pulls the published MCQs for a subject, unit or topic range; asks two different-family models to tier each item and to name the misconception behind each distractor; detects semantic duplicates; and writes a workbook plus a per-topic summary (R1/R2/R3 share, seed-family count, duplicate count). Run across everything it produces a ranked rewrite queue. It never writes to the database.
- **Calibration before trust:** a subject-matter reader (Orly or a teacher; the Product Owner is not a maths specialist) labels about 30 items per subject; we measure model-versus-human agreement and adjust the rubric prompt until agreement is acceptable. Until then tiers are triage, not verdicts.
- **Second signal:** items a small non-reasoning model answers correctly every time are likely R1. Real student correct-rates replace this once students exist (production has none today).

## 4. The rewrite loop (proven on Statistics Units 2 to 4)
Audit, then rewrite **seeds only** (variants inherit), then blind-solve every new item with two non-Claude models, then rehearse and publish, then retire the superseded items. Author in session; the gateway only checks. One session per unit.
Order: highest R1 share and highest student exposure first. Agreed start: **Chemistry, then Calculus AB** (Chemistry 3.1 to 3.3 first, then the rest of the subject by queue).

## 5. Gate (so it does not come back)
Add to `CONTENT_AUTHORING_AND_QA_PROTOCOL.md` and `SEEDED_ITEM_GENERATION_PROTOCOL_2026_09_30.md`: the seed tier requirement, the duplicate rule, and a run of the audit tool as a pre-publish check. Publishing a new seed tiered R1 requires an explicit marked exception.

## 6. Risks and open questions
- Tiers are model judgements until calibrated. Calibration owner and the R3 target need Product Owner decisions.
- Retiring items changes what students see; attempt history on retired items is not inspected in the current loop.
- `difficulty_label` should be reconciled with measured tier after the rewrite, or it will keep contradicting the content.
