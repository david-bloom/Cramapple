# Grading Notes From the Seeded-Question Session (2026-09-30 to 2026-10-02)

Kept separate from `SEEDED_QUESTIONS_SESSION_RECORD_2026_10_01.md` on purpose. That file is about generating and checking questions. This one lists only what the session learned or changed that bears on **how answers are keyed, scored, explained and served**.

## 0. What was and was not touched
- **Touched:** the stored answer keys and wrong-answer explanations of **16 published MCQs** (11 Calc AB, 5 AP Biology; `023` was changed twice), and the label records that decide whether an item is served.
- **Not touched:** any grading engine (Engines 1-4), rubric, hand-drawn or free-response grading, `evaluate-attempt`, entitlements, FRQ items, or any scoring code. No grading logic was read or changed this session beyond the data it consumes.
- All statements below about how grading reads the data come from what the session observed in the database and the repair scripts, not from a fresh audit of the grading code. Treat them as pointers to verify.

## 1. Where the answer key lives (observed)
- MCQ scoring reads **`mcq_choices.is_correct`**. The stem's letter text and `canonical_answer_1` are not what marks an answer right.
- **`canonical_answer_1` is only copied into reviewer snapshots** (the review-decision record). For AP Biology MCQs `canonical_answer_1` is **null**, so a Biology reviewer snapshot carries no canonical answer.
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
- **Not re-queried after `APPROVAL-0068`:** the unit-gated servable count (it was 43 for Biology before). Only label freshness for the five items and the overall counts (118 / 160 / 69 / 6) were checked.

## 5. Risks to verify, not yet checked
1. **Difficulty and attainment data copied onto replaced items.** The repair copies `content_item_difficulty` (including any attainment ratio) from the old version to the new one. For `APBIO-MCQ-021` and `023`, the new version is a **different question** on the same topic, and for `005`, `018`, `022` the wording changed a lot. Any difficulty or attainment figure that came from real student attempts on the old wording may no longer describe the new item. Check whether those rows are model-proposed or attempt-derived, and reset them if attempt-derived.
2. **Prior attempts on the replaced seeds.** Not checked: how stored attempts and responses reference the item (by item, by version, or by letter), and whether per-item analytics will mix attempts on the old and new text.
3. **Answer-length guessability.** The product has a parity detector (`supabase/functions/_shared/mcq-quality.ts`, ratio threshold 1.4). The session held every draft to a longest-over-shortest ratio under 1.4 and the correct answer near the distractor mean, but **did not run the real detector**. Run it on the 16 variants before any are loaded; a visibly longer correct answer is a scoring-fairness issue, not only a style issue.
4. **Letter balance.** Keyed letters on the replaced seeds are fixed by their history (005 C, 018 B, 021 C, 022 A, 023 D). New variants were drawn with a per-key seeded shuffle and spread across letters. No batch-level balance check was run.

## 6. Reuse for grading work
- Standing pre-load checklist for any MCQ batch: two-family blind solve against the stored key; two-family rationale audit; the real parity detector; `mcq_stem_choice_desync` clean; labels fresh (hash equal) after any text change; approval recorded for any validation carried forward.
- Keep Production writes as a single transaction with the assertions above inside it. A rolled-back rehearsal is optional (waived for `APPROVAL-0068`) but caught a real constraint failure on the Calc repair.

## 7. Open items specific to grading
| # | Item | Next step |
|---|---|---|
| G1 | Difficulty / attainment rows copied to replaced items | Query `content_item_difficulty` for the five seeds; reset any attempt-derived values |
| G2 | Attempt history on replaced seeds | Read how attempts reference items and versions; decide whether old attempts should be excluded from item statistics |
| G3 | Real parity detector on the 16 variants | Run `mcq-quality.ts` before loading any variant |
| G4 | Unit-gated servable count for Biology | Re-query after `APPROVAL-0068` and compare with the earlier 43 |
