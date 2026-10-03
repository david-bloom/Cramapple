# Grading Notes From the Seeded-Question Session (2026-09-30 to 2026-10-02)

Kept separate from `SEEDED_QUESTIONS_SESSION_RECORD_2026_10_01.md` on purpose. That file is about generating and checking questions. This one lists only what the session learned or changed that bears on **how answers are keyed, scored, explained and served**.

> **Update 2026-10-03.** Other sessions changed several things this file describes (all on `main`): MCQ scoring was confirmed to read `is_correct` and not `canonical_answer_1` (`APPROVAL-0075`); the validation constraint on cells was relaxed for model-consensus labels (`APPROVAL-0072`); Biology serving counts moved (`APPROVAL-0073`); Biology topics were corrected, including `APBIO-MCQ-005` to Unit 2 (`APPROVAL-0079`); and 24 different Biology variants were published (`APPROVAL-0080`). Corrections are marked "2026-10-03" below.

## 0. What was and was not touched
- **Touched:** the stored answer keys and wrong-answer explanations of **16 published MCQs** (11 Calc AB, 5 AP Biology; `023` was changed twice), and the label records that decide whether an item is served.
- **Not touched:** any grading engine (Engines 1-4), rubric, hand-drawn or free-response grading, `evaluate-attempt`, entitlements, FRQ items, or any scoring code. No grading logic was read or changed this session beyond the data it consumes.
- All statements below about how grading reads the data come from what the session observed in the database and the repair scripts, not from a fresh audit of the grading code. Treat them as pointers to verify.

## 1. Where the answer key lives (observed)
- MCQ scoring reads **`mcq_choices.is_correct`**. The stem's letter text and `canonical_answer_1` are not what marks an answer right.
- **`canonical_answer_1` is only copied into reviewer snapshots** (the review-decision record). For AP Biology MCQs `canonical_answer_1` is **null**, so a Biology reviewer snapshot carries no canonical answer.
- **Confirmed 2026-10-03 (`APPROVAL-0075`):** the MCQ scorer, `evaluate-attempt`, reads `is_correct` on the choices; `canonical_answer_1` is not used to score an MCQ. A sample on 2026-10-02 found 7 of 10 subjects already carry a letter on every or nearly every MCQ with 0 disagreeing with `is_correct`; Biology 3 of 43, Statistics 0 of 304. Chemistry's `canonical_answer_1` was filled on 49 MCQs under that approval.
- **`apcalcab-mcq-037` was a records fix, not a scoring bug:** the stored key letter disagreed with the flagged choice. The repair made the letter and the `is_correct` flag agree, and a `mcq_stem_choice_desync` check now runs inside the repair scripts.
- **Key integrity checks now built into the Production scripts** (all asserted inside the single transaction, which aborts on failure): exactly 4 choices, exactly one correct, the keyed letter identical to the old version's letter, no stem/choice desync, no duplicate published version.

## 2. Key correctness: result
- **0 wrong keys** in the Biology pilot: 0 of 16 seed solves and 0 of 28 variant solves by the two checkers disagreed with the stored key; round 4 and round 5 solves also matched on every item. Calc earlier: 0 of 136 keys wrong (one stored-letter desync, `037`).
- Independent blind solves by two models from different families are an inexpensive key check and are worth keeping as a standing step before any item is loaded.

## 3. Explanations shown after answering (feedback quality)
- The defects found were almost all in the **explanatory text on wrong answers and on the correct answer**, not in the key: 10 Calc rationales, 1 Biology rationale (`023` choice A, which stated a false fact), and in Biology the first-draft variants.
- A wrong rationale is student-facing feedback: it can teach a false rule even when the item scores correctly. This is the most direct grading-side impact of the session. Rationale audit by two models stays as a required step.

## 4. Serving depends on label freshness (observed)
- Changing any text that feeds `taxonomy_relevant_hash` (stem, stimulus, prompt, every choice and rationale) marks the item's labels **stale** and nulls the validation fields. The unit-gated selector serves an item only if the serving label's hash equals the current version's hash, so an unrepaired label means the item **silently stops being served**.
- The carry-forward in each repair restores the prior status and original validation record and re-points the label. Verified for the 5 Biology seeds: serving `validated`, coverage `provisional_model`, hash-fresh, approval id in the payload.
- A validated label carried across a content change is a human validation act, so it needs a recorded approval (done: `APPROVAL-0066`, `0067`, `0068`).
- **2026-10-03:** `APPROVAL-0072` relaxed the cells validation constraint so a `validated` cell needs a human validator **or** a model run plus a decision id and timestamp. The labels carried forward by this session's repairs kept their original human validation records; nothing here relied on the relaxed rule.
- **Not re-queried after `APPROVAL-0068`:** the unit-gated servable count (it was 43 for Biology before). Only label freshness for the five items and the overall counts (118 / 160 / 69 / 6) were checked. **2026-10-03:** the count then moved for other reasons to 110 of 118 (`APPROVAL-0073`), so it can no longer isolate the effect of `APPROVAL-0068`; the five items' hash-fresh labels were the right check. `APPROVAL-0079` later gave `APBIO-MCQ-005` a new validated serving label (Unit 2), which replaces the one this session carried forward.

## 5. Risks: two checked at close, two still open
1. **Difficulty rows copied onto replaced items: checked, not attempt-derived, but may be stale as judgements.** Read-only query on Production after `APPROVAL-0068`: `005` v3 Medium (`calibrated_task_verb`, ratio source `all_exact`, attainment 0.559, confidence high); `022` v2 Hard (`calibrated_task_verb`, `all_tier_fallback`, 0.633, medium); `018` v3 Hard, `021` v2 Medium, `023` v3 Hard (all `calibrated_judgement`, no ratio). The ratios come from a task-verb calibration, not from student attempts on these items (see item 2), so they are not corrupted. The **labels were judged for the old wording**: `021` and `023` are replacement items, and `023`'s new question (which R groups sit where) is plausibly easier than "Hard". A reviewer should re-rate the five.
2. **Prior attempts on the replaced seeds: checked, none exist.** `attempts` records reference `content_item_version_id` (version-specific, so old and new text would not mix). Counts on every version of the five items, in both `public.attempts` and `app.attempts`: **0**. No historical statistics are affected. When attempts begin, per-version references keep old and new text apart.
3. **Answer-length guessability (open).** The product has a parity detector (`supabase/functions/_shared/mcq-quality.ts`, ratio threshold 1.4). The session held every draft to a longest-over-shortest ratio under 1.4 and the correct answer near the distractor mean, but **did not run the real detector**. Run it on the 16 variants before any are loaded; a visibly longer correct answer is a scoring-fairness issue, not only a style issue.
4. **Letter balance (open).** Keyed letters on the replaced seeds are fixed by their history (005 C, 018 B, 021 C, 022 A, 023 D). New variants were drawn with a per-key seeded shuffle and spread across letters. No batch-level balance check was run.

## 6. Reuse for grading work
- Standing pre-load checklist for any MCQ batch: two-family blind solve against the stored key; two-family rationale audit; the real parity detector; `mcq_stem_choice_desync` clean; labels fresh (hash equal) after any text change; approval recorded for any validation carried forward.
- Keep Production writes as a single transaction with the assertions above inside it. A rolled-back rehearsal is optional (waived for `APPROVAL-0068`) but caught a real constraint failure on the Calc repair.

## 7. Open items specific to grading
| # | Item | Status |
|---|---|---|
| G1 | Re-rate difficulty on the five replaced seeds (labels judged for the old wording) | Open: reviewer |
| G2 | Attempt history on the replaced seeds | **Closed 2026-10-02:** zero attempts on every version |
| G3 | Run the real parity detector on the 16 variants | Open: before any variant is loaded |
| G4 | Unit-gated servable count for Biology after `APPROVAL-0068` | **Superseded 2026-10-03:** the count is now 110 of 118 after `APPROVAL-0073`; re-verify only that the five seeds' serving labels are still validated and hash-fresh after `APPROVAL-0079` |
| G5 | Batch-level keyed-letter balance for the 16 variants | Open: before any variant is loaded |
| G6 | The 24 Biology variants published under `APPROVAL-0080` (new 2026-10-03) | Open: that approval wrote **no skill or difficulty rows** for them; check whether serving or the mastery model needs those rows. Also run the real parity detector (G3) on them: they were not part of this session's checks. |
| G7 | Published variants that may break the CED-vocabulary ruling | **Closed 2026-10-03:** 7 retired under `APPROVAL-0091` (zero attempts on all seven); 17 remain. Retirement left their labels as they were, so the validated serving-label count is unchanged (163). Not re-queried: the unit-gated servable count. |
| G8 | 42 Biology items marked `published` at item level with every version `retired` (20 FRQ, 22 MCQ; found 2026-10-03 by a safety check, not caused by this session's changes) | Open: check whether the selector serves on item status or version status, and whether any of the 42 can reach a student; clean up if needed |
