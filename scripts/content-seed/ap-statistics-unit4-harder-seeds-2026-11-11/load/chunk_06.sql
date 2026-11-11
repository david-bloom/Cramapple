begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='548f06be-ccf4-426d-b82b-b424137a4438' and content_key = any (array['APSTATS-MCQ-SV-H-4.10-A-v1','APSTATS-MCQ-SV-H-4.10-A-v2','APSTATS-MCQ-SV-H-4.10-A-v3'])) then raise exception 'chunk 6 already loaded'; end if;
end $$;
-- APSTATS-MCQ-SV-H-4.10-A-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-H-4.10-A-v1', 'mcq', 'Two-sample t test: statistic, p-value, conclusion (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Independent random samples give these results: sample 1 has n = 25, mean 14.1, standard deviation 3.2; sample 2 has n = 30, mean 12.9, standard deviation 2.8. Both are roughly symmetric. To test H0: μ1 - μ2 = 0 versus Ha: μ1 - μ2 ≠ 0, which is correct at the 5% level?', null, md5('APSTATS-MCQ-SV-H-4.10-A-v1'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 't = 1.47 and p ≈ 0.07, so there is convincing evidence of a difference in means.', false, 'Used one tail for a two-sided alternative, and even a p of 0.07 would not be below 0.05.' from version_ins
union all select gen_random_uuid(), id, 'B', 't = 0.28 and p ≈ 0.78, so there is not convincing evidence of a difference in means.', false, 'Divided by the square root of the sum of the variances without dividing by the sample sizes.' from version_ins
union all select gen_random_uuid(), id, 'C', 't = 1.47 and p ≈ 0.15, so the two means are equal.', false, 'Failing to reject does not show the means are equal; it means the data do not rule that out.' from version_ins
union all select gen_random_uuid(), id, 'D', 't = 1.47 and p ≈ 0.15, so there is not convincing evidence of a difference in means.', true, 'Correct: SE = sqrt(3.2²/25 + 2.8²/30) = 0.819; t = 1.2/0.819 = 1.47; df ≈ 48; two-sided p = 0.149.' from version_ins;
-- APSTATS-MCQ-SV-H-4.10-A-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-H-4.10-A-v2', 'mcq', 'Two-sample t test: statistic, p-value, conclusion (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'In a test of H0: μ1 - μ2 = 0 versus Ha: μ1 - μ2 < 0, a two-sample t procedure gives t = -2.31 with about 21 degrees of freedom. Which p-value is correct?', null, md5('APSTATS-MCQ-SV-H-4.10-A-v2'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'About 0.016', true, 'Correct: the alternative is lower-tailed, so p = P(T < -2.31) = 0.016 with df = 21.' from version_ins
union all select gen_random_uuid(), id, 'B', 'About 0.03', false, 'This doubles the tail area, which is correct only for a two-sided alternative.' from version_ins
union all select gen_random_uuid(), id, 'C', 'About 0.98', false, 'This is the upper tail, the wrong direction for a less-than alternative.' from version_ins
union all select gen_random_uuid(), id, 'D', 'About 0.0016', false, 'This is ten times too small and does not match the t value.' from version_ins;
-- APSTATS-MCQ-SV-H-4.10-A-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-H-4.10-A-v3', 'mcq', 'Two-sample t test: statistic, p-value, conclusion (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A study of 5,000 students at each of two schools finds mean scores of 74.0 and 73.0 on a 100-point test with standard deviations near 15. A two-sample t test of H0: μ1 = μ2 versus Ha: μ1 ≠ μ2 gives t = 3.33 and p ≈ 0.001. Which conclusion is best?', null, md5('APSTATS-MCQ-SV-H-4.10-A-v3'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The 1-point difference must be large, because the p-value is so small.', false, 'A small p-value reflects the large sample size, not necessarily a large difference.' from version_ins
union all select gen_random_uuid(), id, 'B', 'There is convincing evidence of a difference in population means, but a difference of about 1 point may be too small to matter in practice.', true, 'Correct: with very large samples, even a 1-point difference gives a small p-value; statistical significance does not mean practical importance.' from version_ins
union all select gen_random_uuid(), id, 'C', 'There is a 0.1% chance that the two population means are equal.', false, 'The p-value is a probability computed assuming the null hypothesis is true; it is not the probability that the null is true.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The small p-value proves that school 1 causes higher scores.', false, 'Schools were not randomly assigned to students, so an association does not prove cause.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='548f06be-ccf4-426d-b82b-b424137a4438' and content_key = any (array['APSTATS-MCQ-SV-H-4.10-A-v1','APSTATS-MCQ-SV-H-4.10-A-v2','APSTATS-MCQ-SV-H-4.10-A-v3']) and status='draft')<>3 then raise exception 'chunk 6: expected 3 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='548f06be-ccf4-426d-b82b-b424137a4438' and ci.content_key = any (array['APSTATS-MCQ-SV-H-4.10-A-v1','APSTATS-MCQ-SV-H-4.10-A-v2','APSTATS-MCQ-SV-H-4.10-A-v3']))<>12 then raise exception 'chunk 6: expected 12 choices'; end if;
end $$;
commit;
