-- Correct two gold-set answer_text defects that Muhammad Saood's cold
-- verification pass correctly caught (both marked absent, correctly, given
-- the flawed text as written):
--
--   * gold_set_answer_id a38a5a8b-e175-4171-a539-1d7d4d70115a
--     (APSTATS-SFRQ-002, seq 30 in Saood's set): arithmetic error.
--     (62-52)/4 = 10/4 was stated as "2.0" -- it is 2.5. Quiz B's z-score is
--     actually higher than originally written (2.5, not 2.0); the answer's
--     qualitative conclusion ("Quiz B is the better relative performance")
--     still holds, only the numeral was wrong.
--
--   * gold_set_answer_id eb5367b3-507a-48d5-b8ae-bf76ae8d8a5e
--     (APSTATS-SFRQ-003, seq 39 in Saood's set): unevaluated arithmetic.
--     "52 plus 4.1 times 6" was never reduced to a number (76.6) before the
--     residual (-2.6, itself correct: 74 - 76.6 = -2.6) was stated. Added
--     the explicit evaluation so the predicted-value element is actually
--     satisfiable from the answer text.
--
-- Owner instruction, 2026-08-06: "Correct real errors like unevaluated
-- arithmetic and a mislabeled z-score" (from the fresh QA pass on Saood's
-- cold set).
--
-- IMPORTANT: this does NOT touch app.gold_set_element_marks. Saood's marks
-- on both elements were 'absent', which was the correct call against the
-- text as it existed at review time -- marks are immutable by design and
-- stay as an accurate historical record of that pass. Now that the
-- underlying answer text has changed, the elements these two marks cover
-- need a FRESH verification pass against the corrected text before they can
-- be counted as verified; they are not auto-resolved by this script. Flagged
-- as follow-up, not executed here (assigning a new reviewer/pass is a
-- separate decision).

begin;
select pg_advisory_xact_lock(hashtext('cramapple-fix-saood-flagged-answer-errors-20260806'));

update app.gold_set_answers
set answer_text = 'For Quiz A the z-score is (86-74)/8 = 12/8 = 1.5. For Quiz B I got (62-52)/4 = 10/4 = 2.5 so the student did better relative to the class on Quiz B since that z-score is higher. Z-scores are useful because they put different scores on a common scale by measuring how many standard deviations away from the mean each score is, so you can compare across different tests.'
where gold_set_answer_id = 'a38a5a8b-e175-4171-a539-1d7d4d70115a'::uuid
  and answer_text like '%10/4 = 2.0%';

update app.gold_set_answers
set answer_text = 'The association between study hours and test scores is strong and positive. For a student studying 6 hours, the predicted score would be 52 plus 4.1 times 6, which is 76.6. If their actual score was 74, the residual is -2.6, meaning their score was 2.6 points lower than predicted.'
where gold_set_answer_id = 'eb5367b3-507a-48d5-b8ae-bf76ae8d8a5e'::uuid
  and answer_text like '%52 plus 4.1 times 6. If their actual score was 74%';

do $$
declare
  v1 text; v2 text;
begin
  select answer_text into v1 from app.gold_set_answers where gold_set_answer_id='a38a5a8b-e175-4171-a539-1d7d4d70115a'::uuid;
  select answer_text into v2 from app.gold_set_answers where gold_set_answer_id='eb5367b3-507a-48d5-b8ae-bf76ae8d8a5e'::uuid;

  if v1 not like '%10/4 = 2.5%' then
    raise exception 'apstats_sfrq_002_fix_not_applied';
  end if;
  if v2 not like '%is 76.6%' then
    raise exception 'apstats_sfrq_003_fix_not_applied';
  end if;
end $$;

commit;
