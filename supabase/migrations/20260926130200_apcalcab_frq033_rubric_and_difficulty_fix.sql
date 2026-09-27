-- Fixes the apcalcab-frq-033 rubric defect and difficulty misclassification flagged in Claude's cross-QA
-- of Codex's AP Calculus AB Tier 3 run (docs/content/CLAUDE_CROSS_QA_AP_CALCULUS_AB_2026_09_25.md, PR #199).
--
-- 1. Rubric defect: part-a-criterion-3 ("Cites the given continuity and differentiability conditions")
--    scored an operation part (a)'s stem never asked for ("State the Mean Value Theorem conclusion for f
--    on this interval."). Reading the full nine-criterion rubric, "cite the hypotheses" is a standard,
--    correctly-scored element of a complete MVT application (the real AP scoring convention requires
--    verifying continuity/differentiability before concluding existence) -- the criterion itself is not
--    spurious, the stem is simply too terse to ask for it. Fix: reword part (a)'s stem to explicitly ask
--    the student to verify the theorem's hypotheses are satisfied, aligning it with the criterion that was
--    already (correctly) scoring that step. Parts (b) and (c) are unchanged.
--
-- 2. Difficulty: this item was classified Easy by the calculus-specific regex classifier
--    (docs/research/apbio_difficulty_calibration_2026_09_22/assign_difficulty_calcab.py) because the
--    rubric's scorer-facing paraphrase verbs ("Identifies," "States," "Cites") don't match the classifier's
--    student-facing task-verb cues, even though the item itself is a two-part existence-and-uniqueness
--    proof by contradiction (part b: contradiction argument; part c: strict-monotonicity uniqueness
--    argument) -- genuinely non-routine by the documented methodology
--    (docs/research/apbio_difficulty_calibration_2026_09_22/README.md). The item's own authored
--    prompt_json.difficulty field (not read by any runtime code, but recorded at authoring time) already
--    says "Hard", an independent corroborating signal. Corrected to Hard.

begin;

update app.content_item_versions
set stem = 'Answer all parts of the following question.

(a) Verify that the hypotheses of the Mean Value Theorem are satisfied for f on [0,4], and state the theorem''s conclusion.

(b) Explain why it is impossible for f′(x)≤1 for every x in (0,4).

(c) If f″(x)>0 throughout (0,4), show that exactly one c satisfies f′(c)=2.'
where id = 'b2aa5c0f-685d-4df3-8d4c-da1a46163e2a';

update app.content_item_difficulty
set difficulty = 'Hard',
    basis = 'calibrated_judgement',
    confidence = 'medium',
    subject_cut_points = subject_cut_points || jsonb_build_object(
      'manual_correction_reason',
      'Rubric-fixed two-part existence-and-uniqueness proof by contradiction; classifier''s regex cues matched only the rubric''s scorer-facing paraphrase verbs (Identifies/States/Cites), missing the item''s actual cognitive demand. Corroborated by the item''s own authored prompt_json.difficulty=Hard.',
      'cross_qa_report', 'docs/content/CLAUDE_CROSS_QA_AP_CALCULUS_AB_2026_09_25.md',
      'corrected_from_difficulty', 'Easy'
    ),
    rationale = 'Manual correction following cross-QA: two-part MVT existence-and-uniqueness proof by contradiction is non-routine; original Easy classification was an artifact of the rubric''s scorer-facing paraphrase verbs not matching student-facing task-verb cues. Item''s own authored prompt_json.difficulty field independently says Hard.'
where content_item_version_id = 'b2aa5c0f-685d-4df3-8d4c-da1a46163e2a';

commit;
