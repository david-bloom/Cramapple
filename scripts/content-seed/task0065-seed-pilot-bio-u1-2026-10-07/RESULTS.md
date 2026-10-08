# TASK-0065 seed pilot: Biology Unit 1 (2026-10-07)

**Question.** Can the generate-and-select pipeline (protocol v0.6 §0) produce exam-quality *seeds*, with no hand edits?
And can those seeds then yield 3 variants each through the same checks?

**Answer: yes for quality, no for difficulty targeting.**
- 21/21 seeds and 61/63 variants were accepted.
- 0 defects in the blind held-out judging (§4): 21 seeds plus 21 sampled variants, with 4/4 planted defects caught. 15 single-judge disputes were adjudicated as non-defects; those adjudications are provisional.
- Skill targeting mostly works.
- Difficulty targeting does not: the panel never rated a seed Hard.

Nothing was written to any database.

## 1. Design

**Plan** (`plan.json`): Biology Unit 1, topics 1.1–1.7. Each topic gets 3 seed slots with different skills and difficulty bands:

| Slot | Skill | Target band |
|---|---|---|
| A | 1.C, explain in applied context | Easy |
| B | 4.B, describe data from a table (odd topics); 3.C on even topics | Medium |
| C | 6.E, predict effects of a disruption | Hard |

**Seeds.**
- Each seed is one generate-and-select run with the standard author prefix (cached), plus the target skill and band.
- It goes through the full checks: 4 non-author families blind-solve and rubric-audit it, then the own-family veto and lint.
- Up to 2 rounds × 2 authors (GPT-6.1, then Claude Opus 5.5).

**Variants.**
- Each accepted seed gets 3 variants through the same checks.
- Each variant must keep the seed's topic, skill, band and named student errors, and must change the scenario, organism or numbers, and wording.
- A deterministic similarity gate rejects any variant with 3-gram Jaccard above 0.35 against the seed or an earlier sibling.

**Labels.** Every accepted item gets a skill and difficulty vote from the 4 non-author families. A skill is *validated* at 3 or more matching votes, and *provisional* at a unique 2.

**Runner.** `scripts/vercel-gateway-check/teaching_pipeline/seed_pipeline.mjs` (`run.sh`).

**Controls.**
- The 6 planted-defect controls ran under the current rubric (`batch_controls/`), and all 6 were caught.
- The pilot itself ran on the **pre-lever config** (full fact pack, Kimi K3 as the fourth checker). It was launched before those defaults changed in commit 54fdb009.

## 2. Throughput

| | Slots | Accepted | Candidates written |
|---|---|---|---|
| Seeds | 21 | **21** | 30 |
| Variants | 63 | **61** | 89 |

The two empty variant slots both escalated cleanly, as the protocol intends. Neither was hand-patched.
- **1.1 C v2:** both GPT candidates were vetoed and both Claude candidates failed the blind solve.
- **1.2 B v1:** all 4 candidates failed the audit.

**Rejections by stage** (119 candidates in total):

| Stage | Seed | Variant |
|---|---|---|
| Blind solve | 3 | 13 |
| Rubric audit | 6 | 8 |
| Own-family veto | 0 | 4 |
| Lint | 0 | 3 |
| Similarity gate | 0 | 0 |

**Variant novelty.** Similarity to the seed was at most 0.153 and averaged 0.047, so no variant came near the 0.35 gate. Variants rewrite the scenario; they do not paraphrase the seed.

**Wall time.** 62 minutes for 82 accepted items, at 4 topics in parallel.

## 3. Cost

| | USD |
|---|---|
| Whole pilot (82 items, 119 candidates, label votes) | **$25.73** |
| Per accepted item | **$0.314** |

**By stage:** author $5.58, solve $1.74, audit $12.28, veto $3.55, label votes $2.58.

**By model:**

| Model | USD | Cache hit |
|---|---|---|
| GPT-6.1 | $8.39 | 9% |
| Kimi K3 | $7.48 | 66% |
| Claude Opus 5.5 | $5.70 | 82% |
| Gemini 3.8 Flash | $2.29 | 4% |
| DeepSeek V4 Pro | $1.86 | 91% |

These are pre-lever costs. On the current defaults (Muse Spark replacing Kimi, unit-scoped fact pack), the lever test measured a 29% drop ($0.28 → $0.20 per item). Applied here, that is **about $0.22 per item, or about $18 for this pilot. That figure is an estimate, not a measurement.**

Per item, seeds plus variants cost more than single teaching items. Variants fail the blind solve more often (13 of 89), and each accepted item also pays for a 4-model label vote.

## 4. Quality: blind held-out judging

**Setup.**
- The blind set holds all 21 seeds, 1 randomly chosen variant per seed (21), and 4 planted-defect items. They were shuffled under random IDs (`judging/review_set.json`).
- Three held-out judges, used by neither author nor checker, each judged every item twice against Biology CED excerpts for 1.1–1.7: Mistral Large 4, GLM-5.3 and MiniMax M3.
- That is 552 calls in total; 551 succeeded.
- Scoring follows `score.py`, the same rules as the method test and the lever test.
- Numeric keys (S1800, S5752, S7587, S9020) were recomputed deterministically (`judging/recompute.py`), and all 4 are correct.

**Panel result before adjudication.**
- Seeds: 0 defects.
- Variants: 0 defects.
- Planted: 4 of 4 caught, each on at least one Q1–Q3 measure.

| Arm | n | Q1 key | Q2 false statement | Q3a off-topic | Q3b beyond CED | Not publishable |
|---|---|---|---|---|---|---|
| Seed | 21 | 0 | 0 | 0 | 0 | 0 |
| Variant | 21 | 0 | 0 | 0 | 0 | 0 |
| Planted | 4 | 1 (+1 disputed) | 3 (+1) | 1 | 1 (+1) | 1 (+3) |

**Disputes.**
- 15 of 42 real items had a single-judge or undecided flag: 10 seeds and 5 variants. The lever test had 0 of 24.
- 9 were Q3b, beyond CED. The judges' `beyond_ced` lists contained commentary ("Nothing substantive", "acceptable extension"), and the scorer counts any non-empty list as a flag. The content they named is the standard bridge between CED statements: kinks → packing → melting temperature; cellulose as a linear glucose polymer, which EK 1.4.A.1 itself describes; and fragment counting in 1.3.
- 6 were Q2, false statement. The flagged text was the distractors' own deliberately false claims, or a self-contradicting note.
- 1 was Q1, key: MiniMax picked C twice on S8645. The key, B, re-derives correctly, and the other two judges agreed with it.
- These items lean on data tables and applied scenarios, which draws more "is this an extension?" commentary than the plain items in the lever test.

**Adjudication.** I adjudicated all 15 as not defects (`judging/adjudication.json`, reasons in `adjudication_reasons.json`). **These are provisional and need human confirmation.**

**One real weakness the pipeline passed.** In S3113 (a 1.7 variant), GLM noted in both samples that "the first amino acid" is an ambiguous referent: it reads as the N-terminal residue. The key holds under either reading, so this is a clarity flaw, not an error.

**Final:** 0/21 seeds and 0/21 variants defective; 4/4 planted caught.

## 5. Skill and difficulty labels

**Seed skill.**

| Measure | Result |
|---|---|
| Voted skill = target skill | 14/21 |
| Voted practice = target practice (e.g. 1.x vs 4.x) | 17/21 |
| Skill status | validated 17, provisional 2, none 2 |

Misses fall mostly between adjacent skills in the same practice: 1.C↔1.B, and 4.B→6.D/6.B on the data slots.

**Seed difficulty.**

| Target | Voted Easy | Voted Medium | Voted Hard |
|---|---|---|---|
| Easy (7) | 3 | 4 | 0 |
| Medium (7) | 0 | 7 | 0 |
| Hard (7) | 0 | 7 | 0 |

Target band matched 10/21 times. **The panel never voted any item Hard**, including the 7 written to the Hard brief.

**Variants versus their seed.**

| Measure | Result |
|---|---|
| Same voted skill | 39/61 |
| Same practice | 47/61 |
| Same voted band | 53/61 |
| Skill status | validated 41, provisional 12, none 8 |

## 6. Findings and recommendations

1. **Seeds are publishable without editing.** Every seed slot filled, and the blind held-out panel found 0 defects in 21 seeds and a 21-variant sample, while catching 4/4 planted defects. The pipeline works as a seed generator.
2. **Variants work and are genuinely new.**
   - 97% of variant slots filled, with low wording overlap.
   - The blind solve is the main filter: a rewritten scenario sometimes turns a different choice into a defensible answer, and the solve catches it.
3. **Difficulty targeting does not work as specified.**
   - Writing to a "Hard" brief produces Medium items, as the panel rates them.
   - Unit 1 is foundational content, so some ceiling effect is expected.
   - Model-voted difficulty is also unvalidated against real student data.
   - **Recommendation:**
     - Stop treating the band as an author target.
     - Keep the panel's vote as a provisional label (DECISION-0096 already has variants inherit the seed's difficulty).
     - Recalibrate from real attempt data later.
   - If Hard items are needed, define Hard structurally (for example, two linked concepts, or a multi-step mechanism with a data table) and test that against the panel separately.
4. **Skill targeting works at the practice level, not reliably at the sub-skill level.**
   - Target practice matched 17/21; the exact sub-skill matched 14/21.
   - **Recommendation:**
     - Target and report at the practice level.
     - Store the panel's voted sub-skill only when validated (3 or more matching votes).
     - Let variants inherit the seed's validated skill instead of re-voting. Re-voting each variant adds cost ($2.58 across the pilot) and noise: 22/61 variants landed on a different sub-skill even though the reasoning was the same.
5. **Cost.** About $0.22 per item on current defaults (estimate). The next lever is the label vote: if variants inherit, only seeds are voted, which saves about 70% of that stage.

## 7. Files

- `plan.json`, `bio_skills.json`, `run.sh`, `run.log`, `timing.log`: run inputs and logs
- `batch/topics/*.json`: every candidate with its checker verdicts; `batch/calls.jsonl` holds per-call usage
- `batch_controls/`: 6/6 planted-defect controls caught
- `analyze.py` → `analysis.json`: acceptance, rejection stages, similarity, label agreement, and accepted items
- `pilot_cost.json`: cost by model and stage
- `judging/`: blind set (`review_set.json`), the arm key (`review_key.json`), CED excerpts, raw judgements, `recompute.py`/`recompute.json`, and scores
- `score.py`: same rules as the method test and the lever test

## 8. Published to Production (APPROVAL-0131, 2026-10-07)

All 82 items are live as AP Biology practice MCQs.
- **Keys:** seeds `APBIO-MCQ-101`–`121`; variants `APBIO-MCQ-SV-<seed>-v<k>`.
- **Labels (DECISION-0101):** 74 skill cells (66 validated, 8 provisional); difficulty Medium 70, Easy 12, all provisional.
- **Review:** no human review (DECISION-0102).

**How it was loaded and checked:**
- Every computable key among the 82 was recomputed first: 14/14 correct (`judging/recompute.py` → `recompute_all.json`).
- Items went in as drafts and hash-matched the local manifest 82/82.
- The publish was rehearsed and rolled back, then committed.
- Each step was re-verified independently afterwards.
- The real selector `app.select_biology_practice_items` serves all 82.

**Effect:** Biology's published MCQ bank went from 79 to 161.

Scripts: `load/build_load.py`, `chunk_NN.sql`, `hash_check.sql`, `publish_rehearsal.sql`, `publish.sql`.
