-- AP Statistics servability work (docs/product/SUBJECT_SERVABILITY_CRITERIA.md), criterion 4.
-- Authors canonical_answer_1 + canonical_answer_spans for the 35 published AP Statistics FRQ items
-- that had a blank canonical_answer_1 on the primary/general exam-pack version
-- (548f06be-ccf4-426d-b82b-b424137a4438): APSTAT-MOD3-E002, APSTAT-MOD3-H001-INV, APSTAT-MOD4-H001-INV,
-- APSTAT-MOD4-M001, APSTAT-MOD5-H001-INV, APSTAT-MOD5-M001, APSTAT-MOD6-H001, APSTAT-MOD6-H002-INV,
-- APSTAT-MOD6-M002, APSTAT-MOD7-H002-INV, STATS-MOD1-E002, STATS-MOD1-E003, STATS-MOD1-M001,
-- STATS-MOD3-M007, STATS-MOD4-E005, and apstats-frq-u12-001 through apstats-frq-u12-020, following the
-- same pattern as the AP Physics canonical-answer migrations this week: each answer's text is composed
-- of criterion-exclusive spans (one span per criterion, plus assembly_literal separators), verified to
-- concatenate exactly to canonical_answer_1.
--
-- Content: each item's math/stats was independently re-derived from first principles (confidence
-- intervals, hypothesis tests, chi-square tests, binomial and Normal-approximation calculations,
-- regression, probability trees, simulations, etc.) rather than copied from rubric text, then
-- cross-checked against the rubric's stated correct values.
--
-- Verification before writing this migration:
-- (1) all 35 target rows were confirmed to have canonical_answer_1 IS NULL beforehand -- this is a
--     pure addition, nothing is overwritten;
-- (2) span concatenation per item was verified programmatically to equal canonical_answer_1 byte for
--     byte before generating this SQL, with a live do-block check inside each transaction below that
--     raises an exception (aborting that transaction) if any mismatch is found;
-- (3) a third, independent check ran via a separate execute_sql call after apply (against Production),
--     confirming total_items=35, has_canonical=35, concat_matches=35.
--
-- Applied to Production (pcntajvbdfqhbeewmdry) as ten separate migrations
-- (apstats_canonical_answers_batch_1 through _batch_10) on 2026-09-25; this file concatenates those ten
-- self-contained transactions, in the same order, for the repo's migration ledger record.
--
-- Scope note: AP Statistics has a separate, known P0 issue -- two exam-pack versions are simultaneously
-- published, creating a routing hazard, documented in
-- docs/product/AP_STATISTICS_LAUNCH_READINESS_2026_09_24.md and
-- docs/content/CLAUDE_QA_REPORT_AP_STATISTICS_AND_PHYSICS_1_2026_09_25.md. This migration does NOT
-- touch that issue -- it only adds canonical answers to the 35 items on the correct/primary exam-pack
-- version (548f06be-ccf4-426d-b82b-b424137a4438) and does not retire, modify, or otherwise touch any
-- exam_pack_versions row.
--
-- Rollback: set canonical_answer_1 back to null and delete the inserted canonical_answer_spans rows
-- for the 35 content_item_version_ids referenced in the do-blocks below, if ever needed.

begin;

-- APSTAT-MOD3-E002 (882d7377-1634-46a9-88c8-a46680c837db)
update app.content_item_versions set canonical_answer_1 = 'If a test was very easy, most students would score high, with a smaller tail of lower scores pulling the distribution''s tail to the left. This produces a histogram that is skewed left (negative skew): scores cluster at higher values, with a long tail extending toward lower scores.' where id = '882d7377-1634-46a9-88c8-a46680c837db';
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('882d7377-1634-46a9-88c8-a46680c837db', 'canonical_answer_1', 1, 'If a test was very easy, most students would score high, with a smaller tail of lower scores pulling the distribution''s tail to the left. This produces a histogram that is skewed left (negative skew): scores cluster at higher values, with a long tail extending toward lower scores.', ARRAY['distribution_shape'], 'drafted', 'apstats_canonical_2026_09_25');

-- APSTAT-MOD3-H001-INV (decf1d69-0fb2-4bd6-8d71-a587a46bff57)
update app.content_item_versions set canonical_answer_1 = '(a) This is selection bias (specifically a form of convenience sampling): only collecting data on Friday and Saturday, the highest-traffic days, means the sample overrepresents the busiest days and underrepresents typical weekday sales. This will bias the estimate upward -- the estimated average daily sales will tend to overestimate the true average across all days of the week.

(b) An improved plan should use a random or systematic sample spread across all days of the week (and across enough weeks to capture normal variation), not just the two busiest days. For example, randomly select at least 20-30 days spread across a several-week period, or use a systematic sample (e.g., every day for several weeks). A larger, more representative sample size (around 30 or more) also supports use of t-procedures via the Central Limit Theorem.

(c) With n=30, sample mean=$850, sample SD=$120, using a one-sample t-interval with df=29 (since the population standard deviation is unknown): the critical value t* is approximately 2.045 for 95% confidence. Margin of error = 2.045 x (120/sqrt(30)) = 2.045 x 21.909 ≈ 44.8. The 95% confidence interval is approximately (805.2, 894.8).

(d) We are 95% confident that the true mean daily sales for the coffee shop is between approximately $805.20 and $894.80. In context, this means that if this sampling procedure were repeated many times, about 95% of the resulting intervals would capture the true average daily sales -- the owner can be fairly confident that a typical day brings in sales somewhere in this range, though any individual day''s actual sales will vary around this average.

(e) Testing H0: mu = 800 against Ha: mu > 800 (a one-sided test, since the claim is that sales exceed $800): the test statistic is t = (850-800)/(120/sqrt(30)) = 50/21.909 ≈ 2.28, with df=29. This gives a one-sided p-value of approximately 0.015, which is less than alpha=0.05. Since the p-value is small, we reject H0 and conclude there is significant evidence that true average daily sales exceed $800 -- consistent with the confidence interval from part (c), whose lower bound (805.2) is already above 800.' where id = 'decf1d69-0fb2-4bd6-8d71-a587a46bff57';
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('decf1d69-0fb2-4bd6-8d71-a587a46bff57', 'canonical_answer_1', 1, '(a) This is selection bias (specifically a form of convenience sampling): only collecting data on Friday and Saturday, the highest-traffic days, means the sample overrepresents the busiest days and underrepresents typical weekday sales. This will bias the estimate upward -- the estimated average daily sales will tend to overestimate the true average across all days of the week.', ARRAY['bias_identification'], 'drafted', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('decf1d69-0fb2-4bd6-8d71-a587a46bff57', 'canonical_answer_1', 2, '

', ARRAY[]::text[], 'assembly_literal', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('decf1d69-0fb2-4bd6-8d71-a587a46bff57', 'canonical_answer_1', 3, '(b) An improved plan should use a random or systematic sample spread across all days of the week (and across enough weeks to capture normal variation), not just the two busiest days. For example, randomly select at least 20-30 days spread across a several-week period, or use a systematic sample (e.g., every day for several weeks). A larger, more representative sample size (around 30 or more) also supports use of t-procedures via the Central Limit Theorem.', ARRAY['improved_sampling_design'], 'drafted', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('decf1d69-0fb2-4bd6-8d71-a587a46bff57', 'canonical_answer_1', 4, '

', ARRAY[]::text[], 'assembly_literal', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('decf1d69-0fb2-4bd6-8d71-a587a46bff57', 'canonical_answer_1', 5, '(c) With n=30, sample mean=$850, sample SD=$120, using a one-sample t-interval with df=29 (since the population standard deviation is unknown): the critical value t* is approximately 2.045 for 95% confidence. Margin of error = 2.045 x (120/sqrt(30)) = 2.045 x 21.909 ≈ 44.8. The 95% confidence interval is approximately (805.2, 894.8).', ARRAY['ci_calculation'], 'drafted', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('decf1d69-0fb2-4bd6-8d71-a587a46bff57', 'canonical_answer_1', 6, '

', ARRAY[]::text[], 'assembly_literal', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('decf1d69-0fb2-4bd6-8d71-a587a46bff57', 'canonical_answer_1', 7, '(d) We are 95% confident that the true mean daily sales for the coffee shop is between approximately $805.20 and $894.80. In context, this means that if this sampling procedure were repeated many times, about 95% of the resulting intervals would capture the true average daily sales -- the owner can be fairly confident that a typical day brings in sales somewhere in this range, though any individual day''s actual sales will vary around this average.', ARRAY['ci_interpretation'], 'drafted', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('decf1d69-0fb2-4bd6-8d71-a587a46bff57', 'canonical_answer_1', 8, '

', ARRAY[]::text[], 'assembly_literal', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('decf1d69-0fb2-4bd6-8d71-a587a46bff57', 'canonical_answer_1', 9, '(e) Testing H0: mu = 800 against Ha: mu > 800 (a one-sided test, since the claim is that sales exceed $800): the test statistic is t = (850-800)/(120/sqrt(30)) = 50/21.909 ≈ 2.28, with df=29. This gives a one-sided p-value of approximately 0.015, which is less than alpha=0.05. Since the p-value is small, we reject H0 and conclude there is significant evidence that true average daily sales exceed $800 -- consistent with the confidence interval from part (c), whose lower bound (805.2) is already above 800.', ARRAY['hypothesis_test'], 'drafted', 'apstats_canonical_2026_09_25');

-- APSTAT-MOD4-H001-INV (b045075d-724f-4248-8a3b-e0f0c68e82a0)
update app.content_item_versions set canonical_answer_1 = '(a) Randomly assign the 50 college students to one of two groups: a treatment group that follows the new exercise program, and a control group that does not (or follows a placebo/standard routine). Random assignment (for example, using a random number generator to assign each student) balances both known and unknown confounding variables between the groups on average. Potential confounding variables to consider and control for include: baseline fitness level or resting heart rate before the study, diet and caffeine/nicotine use, sleep habits, and pre-existing health conditions -- these should either be measured and checked for balance between groups, or explicitly controlled through the randomization process.

(b) Yes, measurement time (early morning vs. afternoon) should be a blocking factor, since resting heart rate is known to vary systematically with time of day. By blocking on measurement time -- for example, ensuring both treatment and control groups have similar proportions of morning and afternoon measurements, or analyzing the two time-of-day groups separately -- the researcher removes this source of variability from the comparison between treatment and control, increasing the precision (power) of the test by reducing unexplained variability.

(c) Testing H0: mu_treatment = mu_control against Ha: mu_treatment < mu_control (since the claim is that exercise reduces heart rate), with treatment mean=68 (SD=6, n=25) and control mean=72 (SD=5, n=25): the two-sample t-statistic is t = (68-72)/sqrt(6^2/25 + 5^2/25) = -4/sqrt(36/25+25/25) = -4/sqrt(2.44) = -4/1.562 ≈ -2.56. This is a fairly large test statistic in magnitude; with the given p ≈ 0.014 (less than alpha=0.05), we reject H0 and conclude there is significant evidence that the exercise program reduces resting heart rate.

(d) A statistically significant result (p ≈ 0.014 < 0.05) means the observed difference is unlikely to be due to chance alone -- but this is a separate question from whether the difference is practically/clinically meaningful. A 4 bpm difference in resting heart rate (68 vs 72) is a real but fairly modest physiological change; whether it matters clinically depends on context (e.g., for most healthy young adults, this might be a nice-to-have improvement, but for patients with cardiovascular risk factors, even a small consistent reduction could be clinically relevant). Statistical significance tells us the effect is probably real; practical significance asks whether the size of that real effect is large enough to matter for decisions.' where id = 'b045075d-724f-4248-8a3b-e0f0c68e82a0';
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('b045075d-724f-4248-8a3b-e0f0c68e82a0', 'canonical_answer_1', 1, '(a) Randomly assign the 50 college students to one of two groups: a treatment group that follows the new exercise program, and a control group that does not (or follows a placebo/standard routine). Random assignment (for example, using a random number generator to assign each student) balances both known and unknown confounding variables between the groups on average. Potential confounding variables to consider and control for include: baseline fitness level or resting heart rate before the study, diet and caffeine/nicotine use, sleep habits, and pre-existing health conditions -- these should either be measured and checked for balance between groups, or explicitly controlled through the randomization process.', ARRAY['experimental_design'], 'drafted', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('b045075d-724f-4248-8a3b-e0f0c68e82a0', 'canonical_answer_1', 2, '

', ARRAY[]::text[], 'assembly_literal', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('b045075d-724f-4248-8a3b-e0f0c68e82a0', 'canonical_answer_1', 3, '(b) Yes, measurement time (early morning vs. afternoon) should be a blocking factor, since resting heart rate is known to vary systematically with time of day. By blocking on measurement time -- for example, ensuring both treatment and control groups have similar proportions of morning and afternoon measurements, or analyzing the two time-of-day groups separately -- the researcher removes this source of variability from the comparison between treatment and control, increasing the precision (power) of the test by reducing unexplained variability.', ARRAY['blocking_decision'], 'drafted', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('b045075d-724f-4248-8a3b-e0f0c68e82a0', 'canonical_answer_1', 4, '

', ARRAY[]::text[], 'assembly_literal', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('b045075d-724f-4248-8a3b-e0f0c68e82a0', 'canonical_answer_1', 5, '(c) Testing H0: mu_treatment = mu_control against Ha: mu_treatment < mu_control (since the claim is that exercise reduces heart rate), with treatment mean=68 (SD=6, n=25) and control mean=72 (SD=5, n=25): the two-sample t-statistic is t = (68-72)/sqrt(6^2/25 + 5^2/25) = -4/sqrt(36/25+25/25) = -4/sqrt(2.44) = -4/1.562 ≈ -2.56. This is a fairly large test statistic in magnitude; with the given p ≈ 0.014 (less than alpha=0.05), we reject H0 and conclude there is significant evidence that the exercise program reduces resting heart rate.', ARRAY['hypothesis_test_execution'], 'drafted', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('b045075d-724f-4248-8a3b-e0f0c68e82a0', 'canonical_answer_1', 6, '

', ARRAY[]::text[], 'assembly_literal', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('b045075d-724f-4248-8a3b-e0f0c68e82a0', 'canonical_answer_1', 7, '(d) A statistically significant result (p ≈ 0.014 < 0.05) means the observed difference is unlikely to be due to chance alone -- but this is a separate question from whether the difference is practically/clinically meaningful. A 4 bpm difference in resting heart rate (68 vs 72) is a real but fairly modest physiological change; whether it matters clinically depends on context (e.g., for most healthy young adults, this might be a nice-to-have improvement, but for patients with cardiovascular risk factors, even a small consistent reduction could be clinically relevant). Statistical significance tells us the effect is probably real; practical significance asks whether the size of that real effect is large enough to matter for decisions.', ARRAY['significance_interpretation'], 'drafted', 'apstats_canonical_2026_09_25');

do $$
declare
  v_bad text;
begin
  select string_agg(civ.id::text, ', ') into v_bad
  from (values ('882d7377-1634-46a9-88c8-a46680c837db'::uuid),('decf1d69-0fb2-4bd6-8d71-a587a46bff57'::uuid),('b045075d-724f-4248-8a3b-e0f0c68e82a0'::uuid)) as t(vid)
  join app.content_item_versions civ on civ.id = t.vid
  cross join lateral (
    select string_agg(cas.span_text, '' order by cas.span_ordinal) as concat
    from app.canonical_answer_spans cas
    where cas.content_item_version_id = civ.id and cas.answer_field = 'canonical_answer_1'
  ) agg
  where agg.concat is distinct from civ.canonical_answer_1;

  if v_bad is not null then
    raise exception 'span concatenation mismatch for version ids: %', v_bad;
  end if;
end $$;

commit;

begin;

-- APSTAT-MOD4-M001 (80a0b867-d6e6-4bf6-999c-323c357f10f1)
update app.content_item_versions set canonical_answer_1 = 'Randomly divide students into two groups: a treatment group that receives the new tutoring program and a control group that does not (continuing with standard instruction instead).

Students should be randomly assigned to the treatment or control group (for example, by random number generator or drawing names), so that the two groups are comparable except for the tutoring program itself.

Measure student performance (for example, via a common test or course grade) for both groups after the tutoring period, then compare the average performance between the treatment and control groups to assess whether the tutoring program made a difference.' where id = '80a0b867-d6e6-4bf6-999c-323c357f10f1';
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('80a0b867-d6e6-4bf6-999c-323c357f10f1', 'canonical_answer_1', 1, 'Randomly divide students into two groups: a treatment group that receives the new tutoring program and a control group that does not (continuing with standard instruction instead).', ARRAY['design-groups'], 'drafted', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('80a0b867-d6e6-4bf6-999c-323c357f10f1', 'canonical_answer_1', 2, '

', ARRAY[]::text[], 'assembly_literal', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('80a0b867-d6e6-4bf6-999c-323c357f10f1', 'canonical_answer_1', 3, 'Students should be randomly assigned to the treatment or control group (for example, by random number generator or drawing names), so that the two groups are comparable except for the tutoring program itself.', ARRAY['design-random-assignment'], 'drafted', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('80a0b867-d6e6-4bf6-999c-323c357f10f1', 'canonical_answer_1', 4, '

', ARRAY[]::text[], 'assembly_literal', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('80a0b867-d6e6-4bf6-999c-323c357f10f1', 'canonical_answer_1', 5, 'Measure student performance (for example, via a common test or course grade) for both groups after the tutoring period, then compare the average performance between the treatment and control groups to assess whether the tutoring program made a difference.', ARRAY['design-outcome'], 'drafted', 'apstats_canonical_2026_09_25');

-- APSTAT-MOD5-H001-INV (b0d3059b-0072-44d5-8543-eb16cc79a17b)
update app.content_item_versions set canonical_answer_1 = '(a) No, the data scientist cannot conclude that social media causes anxiety from this correlational data alone. Correlation does not imply causation: a strong association (r=0.65) shows the two variables tend to move together, but this observational data cannot rule out the possibility that anxiety causes more social media use, that some third variable causes both, or that the relationship is more complex than a simple one-directional cause.

(b) Three plausible confounding variables: (1) sleep quality/duration -- students who sleep poorly might both use social media more (e.g., late at night) and have higher anxiety independent of social media itself; (2) underlying personality traits (e.g., a tendency toward worry or social comparison) that could drive both heavier social media use and higher anxiety; (3) academic or social stress -- students already experiencing stress from school or peer relationships might turn to social media more and also report higher anxiety, with the stress driving both.

(c) Random assignment ensures that, on average, the two groups (social media vs. no social media) are balanced on all other factors -- known and unknown confounders like sleep habits, personality, and baseline stress are spread evenly between groups by chance. This means any systematic difference in anxiety between the groups at the end of the study can be attributed to the social media condition itself, rather than to some pre-existing difference between the groups -- which is exactly what allows a causal conclusion that the purely observational correlational study could not support.

(d) With t=2.1, df=48, p=0.04, since p < alpha=0.05, we reject the null hypothesis of no difference and conclude there is significant evidence that social media use affects anxiety scores in this experiment. In context: students assigned to use social media for 1 hour/day showed significantly different anxiety scores than students assigned to no social media, suggesting a causal effect (given the randomized design). This conclusion requires the standard assumptions for a t-test: that the anxiety score differences are approximately normally distributed (or the sample size is large enough for the Central Limit Theorem to apply) and that observations are independent (e.g., no interaction effects between assigned students).' where id = 'b0d3059b-0072-44d5-8543-eb16cc79a17b';
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('b0d3059b-0072-44d5-8543-eb16cc79a17b', 'canonical_answer_1', 1, '(a) No, the data scientist cannot conclude that social media causes anxiety from this correlational data alone. Correlation does not imply causation: a strong association (r=0.65) shows the two variables tend to move together, but this observational data cannot rule out the possibility that anxiety causes more social media use, that some third variable causes both, or that the relationship is more complex than a simple one-directional cause.', ARRAY['causation_vs_correlation'], 'drafted', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('b0d3059b-0072-44d5-8543-eb16cc79a17b', 'canonical_answer_1', 2, '

', ARRAY[]::text[], 'assembly_literal', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('b0d3059b-0072-44d5-8543-eb16cc79a17b', 'canonical_answer_1', 3, '(b) Three plausible confounding variables: (1) sleep quality/duration -- students who sleep poorly might both use social media more (e.g., late at night) and have higher anxiety independent of social media itself; (2) underlying personality traits (e.g., a tendency toward worry or social comparison) that could drive both heavier social media use and higher anxiety; (3) academic or social stress -- students already experiencing stress from school or peer relationships might turn to social media more and also report higher anxiety, with the stress driving both.', ARRAY['confounding_variables'], 'drafted', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('b0d3059b-0072-44d5-8543-eb16cc79a17b', 'canonical_answer_1', 4, '

', ARRAY[]::text[], 'assembly_literal', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('b0d3059b-0072-44d5-8543-eb16cc79a17b', 'canonical_answer_1', 5, '(c) Random assignment ensures that, on average, the two groups (social media vs. no social media) are balanced on all other factors -- known and unknown confounders like sleep habits, personality, and baseline stress are spread evenly between groups by chance. This means any systematic difference in anxiety between the groups at the end of the study can be attributed to the social media condition itself, rather than to some pre-existing difference between the groups -- which is exactly what allows a causal conclusion that the purely observational correlational study could not support.', ARRAY['experimental_advantage'], 'drafted', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('b0d3059b-0072-44d5-8543-eb16cc79a17b', 'canonical_answer_1', 6, '

', ARRAY[]::text[], 'assembly_literal', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('b0d3059b-0072-44d5-8543-eb16cc79a17b', 'canonical_answer_1', 7, '(d) With t=2.1, df=48, p=0.04, since p < alpha=0.05, we reject the null hypothesis of no difference and conclude there is significant evidence that social media use affects anxiety scores in this experiment. In context: students assigned to use social media for 1 hour/day showed significantly different anxiety scores than students assigned to no social media, suggesting a causal effect (given the randomized design). This conclusion requires the standard assumptions for a t-test: that the anxiety score differences are approximately normally distributed (or the sample size is large enough for the Central Limit Theorem to apply) and that observations are independent (e.g., no interaction effects between assigned students).', ARRAY['experimental_conclusion'], 'drafted', 'apstats_canonical_2026_09_25');

-- APSTAT-MOD5-M001 (acf20fc2-bc25-42e9-9068-fea69c26c89c)
update app.content_item_versions set canonical_answer_1 = 'The mean is (10+15+20+25+30)/5 = 100/5 = 20. The deviations from the mean are -10, -5, 0, 5, 10; squaring gives 100, 25, 0, 25, 100, which sum to 250. Dividing by n-1=4 gives a sample variance of 250/4 = 62.5, and taking the square root gives a sample standard deviation of approximately 7.91.' where id = 'acf20fc2-bc25-42e9-9068-fea69c26c89c';
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('acf20fc2-bc25-42e9-9068-fea69c26c89c', 'canonical_answer_1', 1, 'The mean is (10+15+20+25+30)/5 = 100/5 = 20. The deviations from the mean are -10, -5, 0, 5, 10; squaring gives 100, 25, 0, 25, 100, which sum to 250. Dividing by n-1=4 gives a sample variance of 250/4 = 62.5, and taking the square root gives a sample standard deviation of approximately 7.91.', ARRAY['descriptive_statistics'], 'drafted', 'apstats_canonical_2026_09_25');

-- APSTAT-MOD6-H001 (bf471ada-e35b-4d63-b27d-d9aba40722ca)
update app.content_item_versions set canonical_answer_1 = 'The null hypothesis is H0: mu_control = mu_treatment (no difference in mean test scores between the two teaching methods), and the alternative is Ha: mu_control does not equal mu_treatment (a two-sided test, since the question does not specify a direction).

With control (n=30, mean=72, SD=8) and treatment (n=30, mean=76, SD=7): the two-sample t-statistic is t = (76-72)/sqrt(8^2/30 + 7^2/30) = 4/sqrt(64/30+49/30) = 4/sqrt(3.767) = 4/1.941 ≈ 2.06. Using the conservative degrees of freedom (the smaller of n1-1 and n2-1) gives df=29, or a Welch-adjusted df of approximately 57 for a more precise calculation; either way, this places the test statistic in the range associated with a two-sided p-value of roughly 0.04-0.05.

Since the p-value (approximately 0.04-0.05) is at or below alpha=0.05, we (marginally) reject the null hypothesis and conclude there is evidence of a significant difference in mean test scores between the two teaching methods, with the treatment group scoring higher on average. Because this result is close to the significance threshold, a careful reader should note the conclusion is sensitive to the exact degrees-of-freedom method used, and treat this as a borderline-significant result.' where id = 'bf471ada-e35b-4d63-b27d-d9aba40722ca';
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('bf471ada-e35b-4d63-b27d-d9aba40722ca', 'canonical_answer_1', 1, 'The null hypothesis is H0: mu_control = mu_treatment (no difference in mean test scores between the two teaching methods), and the alternative is Ha: mu_control does not equal mu_treatment (a two-sided test, since the question does not specify a direction).', ARRAY['hypotheses_setup'], 'drafted', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('bf471ada-e35b-4d63-b27d-d9aba40722ca', 'canonical_answer_1', 2, '

', ARRAY[]::text[], 'assembly_literal', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('bf471ada-e35b-4d63-b27d-d9aba40722ca', 'canonical_answer_1', 3, 'With control (n=30, mean=72, SD=8) and treatment (n=30, mean=76, SD=7): the two-sample t-statistic is t = (76-72)/sqrt(8^2/30 + 7^2/30) = 4/sqrt(64/30+49/30) = 4/sqrt(3.767) = 4/1.941 ≈ 2.06. Using the conservative degrees of freedom (the smaller of n1-1 and n2-1) gives df=29, or a Welch-adjusted df of approximately 57 for a more precise calculation; either way, this places the test statistic in the range associated with a two-sided p-value of roughly 0.04-0.05.', ARRAY['test_calculation'], 'drafted', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('bf471ada-e35b-4d63-b27d-d9aba40722ca', 'canonical_answer_1', 4, '

', ARRAY[]::text[], 'assembly_literal', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('bf471ada-e35b-4d63-b27d-d9aba40722ca', 'canonical_answer_1', 5, 'Since the p-value (approximately 0.04-0.05) is at or below alpha=0.05, we (marginally) reject the null hypothesis and conclude there is evidence of a significant difference in mean test scores between the two teaching methods, with the treatment group scoring higher on average. Because this result is close to the significance threshold, a careful reader should note the conclusion is sensitive to the exact degrees-of-freedom method used, and treat this as a borderline-significant result.', ARRAY['conclusion'], 'drafted', 'apstats_canonical_2026_09_25');

do $$
declare
  v_bad text;
begin
  select string_agg(civ.id::text, ', ') into v_bad
  from (values ('80a0b867-d6e6-4bf6-999c-323c357f10f1'::uuid),('b0d3059b-0072-44d5-8543-eb16cc79a17b'::uuid),('acf20fc2-bc25-42e9-9068-fea69c26c89c'::uuid),('bf471ada-e35b-4d63-b27d-d9aba40722ca'::uuid)) as t(vid)
  join app.content_item_versions civ on civ.id = t.vid
  cross join lateral (
    select string_agg(cas.span_text, '' order by cas.span_ordinal) as concat
    from app.canonical_answer_spans cas
    where cas.content_item_version_id = civ.id and cas.answer_field = 'canonical_answer_1'
  ) agg
  where agg.concat is distinct from civ.canonical_answer_1;

  if v_bad is not null then
    raise exception 'span concatenation mismatch for version ids: %', v_bad;
  end if;
end $$;

commit;

begin;

-- APSTAT-MOD6-H002-INV (c93a7c33-587b-48dc-9aaf-929e9e3cccc0)
update app.content_item_versions set canonical_answer_1 = '(a) With r=0.75, there is a moderately strong to strong positive linear association between SAT score and GPA: as SAT score increases, GPA tends to increase as well, and the relationship is reasonably tight around a line (r=0.75 indicates a fairly consistent, though not perfect, linear trend).

(b) The slope, 0.0025, means that for each additional point on the SAT, predicted GPA increases by 0.0025 points, on average. The intercept, 0.475, would represent the predicted GPA for an SAT score of 0 -- but since observed SAT scores range from 750 to 1350, an SAT score of 0 is far outside the range of the data, so the intercept has no meaningful real-world interpretation here (extrapolation warning).

(c) The residuals being randomly scattered around 0 with roughly constant spread supports two of the linear-model conditions: linearity (no systematic curve in the residuals) and constant variance/homoscedasticity (spread doesn''t change across the range of SAT scores) . The description does not establish the normality condition (whether the residuals themselves follow a normal distribution) -- that would require additional information such as a normal probability plot or histogram of the residuals, which is not given here.

(d) The model can reasonably be used to predict GPA from SAT scores within the observed range (750 to 1350), but predictions should be treated cautiously given R²=0.5625 -- only about 56.25% of the variability in GPA is explained by SAT score, leaving a substantial 43.75% unexplained by other factors, so individual predictions will carry real uncertainty. The model should NOT be used to predict GPA for SAT scores outside the 750-1350 range (extrapolation), since the linear relationship is not verified to hold outside the observed data, and the intercept''s lack of real-world meaning (part b) is a clear symptom of this same extrapolation danger.' where id = 'c93a7c33-587b-48dc-9aaf-929e9e3cccc0';
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('c93a7c33-587b-48dc-9aaf-929e9e3cccc0', 'canonical_answer_1', 1, '(a) With r=0.75, there is a moderately strong to strong positive linear association between SAT score and GPA: as SAT score increases, GPA tends to increase as well, and the relationship is reasonably tight around a line (r=0.75 indicates a fairly consistent, though not perfect, linear trend).', ARRAY['exploratory_analysis'], 'drafted', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('c93a7c33-587b-48dc-9aaf-929e9e3cccc0', 'canonical_answer_1', 2, '

', ARRAY[]::text[], 'assembly_literal', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('c93a7c33-587b-48dc-9aaf-929e9e3cccc0', 'canonical_answer_1', 3, '(b) The slope, 0.0025, means that for each additional point on the SAT, predicted GPA increases by 0.0025 points, on average. The intercept, 0.475, would represent the predicted GPA for an SAT score of 0 -- but since observed SAT scores range from 750 to 1350, an SAT score of 0 is far outside the range of the data, so the intercept has no meaningful real-world interpretation here (extrapolation warning).', ARRAY['regression_fitting'], 'drafted', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('c93a7c33-587b-48dc-9aaf-929e9e3cccc0', 'canonical_answer_1', 4, '

', ARRAY[]::text[], 'assembly_literal', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('c93a7c33-587b-48dc-9aaf-929e9e3cccc0', 'canonical_answer_1', 5, '(c) The residuals being randomly scattered around 0 with roughly constant spread supports two of the linear-model conditions: linearity (no systematic curve in the residuals) and constant variance/homoscedasticity (spread doesn''t change across the range of SAT scores) . The description does not establish the normality condition (whether the residuals themselves follow a normal distribution) -- that would require additional information such as a normal probability plot or histogram of the residuals, which is not given here.', ARRAY['residual_diagnostics'], 'drafted', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('c93a7c33-587b-48dc-9aaf-929e9e3cccc0', 'canonical_answer_1', 6, '

', ARRAY[]::text[], 'assembly_literal', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('c93a7c33-587b-48dc-9aaf-929e9e3cccc0', 'canonical_answer_1', 7, '(d) The model can reasonably be used to predict GPA from SAT scores within the observed range (750 to 1350), but predictions should be treated cautiously given R²=0.5625 -- only about 56.25% of the variability in GPA is explained by SAT score, leaving a substantial 43.75% unexplained by other factors, so individual predictions will carry real uncertainty. The model should NOT be used to predict GPA for SAT scores outside the 750-1350 range (extrapolation), since the linear relationship is not verified to hold outside the observed data, and the intercept''s lack of real-world meaning (part b) is a clear symptom of this same extrapolation danger.', ARRAY['model_recommendation'], 'drafted', 'apstats_canonical_2026_09_25');

-- APSTAT-MOD6-M002 (0d1808ac-8b62-472d-abcb-1d7edd5184ab)
update app.content_item_versions set canonical_answer_1 = 'A 95% confidence interval of (45, 55) means that we used a procedure that, if repeated many times on many different random samples, would produce intervals containing the true population mean approximately 95% of the time. In this specific case, we are 95% confident that the true population mean lies between 45 and 55 -- this is a statement about our confidence in the procedure, not a probability statement about this one fixed (already-computed) interval containing a fixed population parameter.' where id = '0d1808ac-8b62-472d-abcb-1d7edd5184ab';
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('0d1808ac-8b62-472d-abcb-1d7edd5184ab', 'canonical_answer_1', 1, 'A 95% confidence interval of (45, 55) means that we used a procedure that, if repeated many times on many different random samples, would produce intervals containing the true population mean approximately 95% of the time. In this specific case, we are 95% confident that the true population mean lies between 45 and 55 -- this is a statement about our confidence in the procedure, not a probability statement about this one fixed (already-computed) interval containing a fixed population parameter.', ARRAY['confidence_interval_interpretation'], 'drafted', 'apstats_canonical_2026_09_25');

-- APSTAT-MOD7-H002-INV (9817ead7-52af-493f-b7ef-dc30c3c4d904)
update app.content_item_versions set canonical_answer_1 = '(a) From the given percentages: low anxiety (200 students): 80% STEM = 160 yes, 40 no. Medium anxiety (200 students): 55% STEM = 110 yes, 90 no. High anxiety (100 students): 40% STEM = 40 yes, 60 no. The complete table:

| | Low anxiety | Medium anxiety | High anxiety | Total |
|---|---|---|---|---|
| STEM = yes | 160 | 110 | 40 | 310 |
| STEM = no | 40 | 90 | 60 | 190 |
| Total | 200 | 200 | 100 | 500 |

(b) Expected counts (row total x column total / grand total): low/STEM=124, medium/STEM=124, high/STEM=62, low/no=76, medium/no=76, high/no=38. Chi-square = sum of (O-E)^2/E = (160-124)^2/124 + (110-124)^2/124 + (40-62)^2/62 + (40-76)^2/76 + (90-76)^2/76 + (60-38)^2/38 = 10.45 + 1.58 + 7.81 + 17.05 + 2.58 + 12.74 ≈ 52.2. Degrees of freedom = (3-1)(2-1) = 2. This chi-square value is far larger than the critical value of 5.99 (df=2, alpha=0.05), giving a p-value far smaller than 0.05. We reject the null hypothesis of independence and conclude there is strong evidence of an association between math anxiety level and STEM-major intentions.

(c) The conditional probabilities are given directly: P(STEM | low anxiety) = 0.80, P(STEM | medium anxiety) = 0.55, P(STEM | high anxiety) = 0.40. These probabilities show a clear decreasing trend: as anxiety level increases, the proportion of students planning to pursue STEM decreases substantially (from 80% down to 40%), suggesting a negative relationship between math anxiety and STEM intentions.

(d) In context: there is strong statistical evidence of an association between a student''s math anxiety level and their intention to pursue a STEM major, with higher anxiety associated with lower likelihood of planning to pursue STEM. However, this is observational data, so this association cannot be interpreted as anxiety causing reduced STEM interest (or vice versa) -- other factors could explain the pattern. Limitations include: this may not be a random sample of all high school students (limiting generalizability), self-reported anxiety levels and STEM intentions may be subject to self-report bias, and any observed association could be driven by confounding variables such as prior academic performance or exposure to STEM subjects.' where id = '9817ead7-52af-493f-b7ef-dc30c3c4d904';
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('9817ead7-52af-493f-b7ef-dc30c3c4d904', 'canonical_answer_1', 1, '(a) From the given percentages: low anxiety (200 students): 80% STEM = 160 yes, 40 no. Medium anxiety (200 students): 55% STEM = 110 yes, 90 no. High anxiety (100 students): 40% STEM = 40 yes, 60 no. The complete table:

| | Low anxiety | Medium anxiety | High anxiety | Total |
|---|---|---|---|---|
| STEM = yes | 160 | 110 | 40 | 310 |
| STEM = no | 40 | 90 | 60 | 190 |
| Total | 200 | 200 | 100 | 500 |', ARRAY['contingency_table'], 'drafted', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('9817ead7-52af-493f-b7ef-dc30c3c4d904', 'canonical_answer_1', 2, '

', ARRAY[]::text[], 'assembly_literal', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('9817ead7-52af-493f-b7ef-dc30c3c4d904', 'canonical_answer_1', 3, '(b) Expected counts (row total x column total / grand total): low/STEM=124, medium/STEM=124, high/STEM=62, low/no=76, medium/no=76, high/no=38. Chi-square = sum of (O-E)^2/E = (160-124)^2/124 + (110-124)^2/124 + (40-62)^2/62 + (40-76)^2/76 + (90-76)^2/76 + (60-38)^2/38 = 10.45 + 1.58 + 7.81 + 17.05 + 2.58 + 12.74 ≈ 52.2. Degrees of freedom = (3-1)(2-1) = 2. This chi-square value is far larger than the critical value of 5.99 (df=2, alpha=0.05), giving a p-value far smaller than 0.05. We reject the null hypothesis of independence and conclude there is strong evidence of an association between math anxiety level and STEM-major intentions.', ARRAY['chi_square_test'], 'drafted', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('9817ead7-52af-493f-b7ef-dc30c3c4d904', 'canonical_answer_1', 4, '

', ARRAY[]::text[], 'assembly_literal', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('9817ead7-52af-493f-b7ef-dc30c3c4d904', 'canonical_answer_1', 5, '(c) The conditional probabilities are given directly: P(STEM | low anxiety) = 0.80, P(STEM | medium anxiety) = 0.55, P(STEM | high anxiety) = 0.40. These probabilities show a clear decreasing trend: as anxiety level increases, the proportion of students planning to pursue STEM decreases substantially (from 80% down to 40%), suggesting a negative relationship between math anxiety and STEM intentions.', ARRAY['probability_analysis'], 'drafted', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('9817ead7-52af-493f-b7ef-dc30c3c4d904', 'canonical_answer_1', 6, '

', ARRAY[]::text[], 'assembly_literal', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('9817ead7-52af-493f-b7ef-dc30c3c4d904', 'canonical_answer_1', 7, '(d) In context: there is strong statistical evidence of an association between a student''s math anxiety level and their intention to pursue a STEM major, with higher anxiety associated with lower likelihood of planning to pursue STEM. However, this is observational data, so this association cannot be interpreted as anxiety causing reduced STEM interest (or vice versa) -- other factors could explain the pattern. Limitations include: this may not be a random sample of all high school students (limiting generalizability), self-reported anxiety levels and STEM intentions may be subject to self-report bias, and any observed association could be driven by confounding variables such as prior academic performance or exposure to STEM subjects.', ARRAY['contextual_interpretation'], 'drafted', 'apstats_canonical_2026_09_25');

-- STATS-MOD1-E002 (f99d019c-6b73-4f89-bd9e-9dc731e6b5f3)
update app.content_item_versions set canonical_answer_1 = '(a) Student ID number: categorical -- even though it''s written as a number, it''s a numeric label used for identification, not a measured quantity, and arithmetic on it (like averaging ID numbers) would be meaningless. (b) Gender: categorical -- it places individuals into named categories. (c) Test score: quantitative -- it''s a numeric measurement where arithmetic (like averaging) is meaningful. (d) Favorite color: categorical -- it places individuals into named categories.' where id = 'f99d019c-6b73-4f89-bd9e-9dc731e6b5f3';
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('f99d019c-6b73-4f89-bd9e-9dc731e6b5f3', 'canonical_answer_1', 1, '(a) Student ID number: categorical -- even though it''s written as a number, it''s a numeric label used for identification, not a measured quantity, and arithmetic on it (like averaging ID numbers) would be meaningless. (b) Gender: categorical -- it places individuals into named categories. (c) Test score: quantitative -- it''s a numeric measurement where arithmetic (like averaging) is meaningful. (d) Favorite color: categorical -- it places individuals into named categories.', ARRAY['variable_classification'], 'drafted', 'apstats_canonical_2026_09_25');

-- STATS-MOD1-E003 (76ca33ec-f07a-4bf6-83f6-d45bd2fb4c7b)
update app.content_item_versions set canonical_answer_1 = 'The population is all 40,000 residents of Springfield -- the entire group the researchers want to draw conclusions about. The sample is the 500 residents who were actually surveyed -- the subset of the population from which data was actually collected.' where id = '76ca33ec-f07a-4bf6-83f6-d45bd2fb4c7b';
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('76ca33ec-f07a-4bf6-83f6-d45bd2fb4c7b', 'canonical_answer_1', 1, 'The population is all 40,000 residents of Springfield -- the entire group the researchers want to draw conclusions about. The sample is the 500 residents who were actually surveyed -- the subset of the population from which data was actually collected.', ARRAY['population_sample'], 'drafted', 'apstats_canonical_2026_09_25');

do $$
declare
  v_bad text;
begin
  select string_agg(civ.id::text, ', ') into v_bad
  from (values ('c93a7c33-587b-48dc-9aaf-929e9e3cccc0'::uuid),('0d1808ac-8b62-472d-abcb-1d7edd5184ab'::uuid),('9817ead7-52af-493f-b7ef-dc30c3c4d904'::uuid),('f99d019c-6b73-4f89-bd9e-9dc731e6b5f3'::uuid),('76ca33ec-f07a-4bf6-83f6-d45bd2fb4c7b'::uuid)) as t(vid)
  join app.content_item_versions civ on civ.id = t.vid
  cross join lateral (
    select string_agg(cas.span_text, '' order by cas.span_ordinal) as concat
    from app.canonical_answer_spans cas
    where cas.content_item_version_id = civ.id and cas.answer_field = 'canonical_answer_1'
  ) agg
  where agg.concat is distinct from civ.canonical_answer_1;

  if v_bad is not null then
    raise exception 'span concatenation mismatch for version ids: %', v_bad;
  end if;
end $$;

commit;

begin;

-- STATS-MOD1-M001 (b2f2de47-2c10-4b83-bf97-89cdfd695e18)
update app.content_item_versions set canonical_answer_1 = 'Random sampling gives every member of the population a known, typically equal, chance of being selected, which tends to produce a sample that is representative of the population as a whole and allows for valid statistical inference. Convenience sampling, by contrast, selects individuals simply because they are easy to reach (e.g., people nearby, or willing to respond), which introduces selection bias: the sample may systematically differ from the population in ways related to why those individuals were easy to sample, making conclusions drawn from it unreliable as an estimate of the broader population.' where id = 'b2f2de47-2c10-4b83-bf97-89cdfd695e18';
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('b2f2de47-2c10-4b83-bf97-89cdfd695e18', 'canonical_answer_1', 1, 'Random sampling gives every member of the population a known, typically equal, chance of being selected, which tends to produce a sample that is representative of the population as a whole and allows for valid statistical inference. Convenience sampling, by contrast, selects individuals simply because they are easy to reach (e.g., people nearby, or willing to respond), which introduces selection bias: the sample may systematically differ from the population in ways related to why those individuals were easy to sample, making conclusions drawn from it unreliable as an estimate of the broader population.', ARRAY['sampling_methods'], 'drafted', 'apstats_canonical_2026_09_25');

-- STATS-MOD3-M007 (90fdfeba-dc7f-464c-9420-06a78ddb1830)
update app.content_item_versions set canonical_answer_1 = 'The standard normal distribution remains useful even for non-normal data because of the Central Limit Theorem: for a sufficiently large sample size, the sampling distribution of the sample mean is approximately normal, regardless of the shape of the original population distribution. This means that even when individual data points don''t follow a normal distribution, standard normal (z-based) procedures can still be validly applied to the sample mean once the sample is large enough, which is why the standard normal distribution is so broadly applicable in statistical inference.' where id = '90fdfeba-dc7f-464c-9420-06a78ddb1830';
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('90fdfeba-dc7f-464c-9420-06a78ddb1830', 'canonical_answer_1', 1, 'The standard normal distribution remains useful even for non-normal data because of the Central Limit Theorem: for a sufficiently large sample size, the sampling distribution of the sample mean is approximately normal, regardless of the shape of the original population distribution. This means that even when individual data points don''t follow a normal distribution, standard normal (z-based) procedures can still be validly applied to the sample mean once the sample is large enough, which is why the standard normal distribution is so broadly applicable in statistical inference.', ARRAY['standard_normal_utility'], 'drafted', 'apstats_canonical_2026_09_25');

-- STATS-MOD4-E005 (f112c2b6-7101-4fb9-bee4-94d2c90ef8c4)
update app.content_item_versions set canonical_answer_1 = 'An experiment involves actively manipulating one or more variables (e.g., randomly assigning subjects to different treatments) to observe the effect on an outcome, which allows for causal conclusions. A survey (or observational study) simply observes and records existing characteristics or behaviors of subjects without manipulating anything, which can reveal associations but cannot by itself establish causation.' where id = 'f112c2b6-7101-4fb9-bee4-94d2c90ef8c4';
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('f112c2b6-7101-4fb9-bee4-94d2c90ef8c4', 'canonical_answer_1', 1, 'An experiment involves actively manipulating one or more variables (e.g., randomly assigning subjects to different treatments) to observe the effect on an outcome, which allows for causal conclusions. A survey (or observational study) simply observes and records existing characteristics or behaviors of subjects without manipulating anything, which can reveal associations but cannot by itself establish causation.', ARRAY['experiment_vs_survey'], 'drafted', 'apstats_canonical_2026_09_25');

-- apstats-frq-u12-001 (1300dd2b-de29-4d8b-a990-376c8d3ff876)
update app.content_item_versions set canonical_answer_1 = '(a) Relative frequency = count / 80 for each category. For example, Sports: 32/80 = 0.40.

The relative frequencies are: Sports = 32/80 = 0.40, Music = 12/80 = 0.15, Clubs = 20/80 = 0.25, None = 16/80 = 0.20.

(b) A bar graph has four separate bars, one per category, with heights equal to 0.40 (Sports), 0.15 (Music), 0.25 (Clubs), and 0.20 (None) -- or equivalently the counts 32, 12, 20, 16.

The horizontal axis is labeled "Activity" with the four category names, the vertical axis is labeled "Relative Frequency" (or "Number of Students"), and the graph has a title such as "After-School Activity of Tenth-Grade Students."

The four bars are drawn with equal width and gaps between them (not touching), since activity is a categorical variable.

(c) Sports is the most common activity, and Music is the least common.

Sports (40%, 32 students) is more than twice as common as the next-highest category, Clubs (25%, 20 students), while Music (15%, 12 students) is the least common, notably lower than the other three categories.

(d) Activity is a categorical (qualitative) variable -- it places each student into a named group rather than recording a numeric measurement.

A bar graph is appropriate because the categories (Sports, Music, Clubs, None) have no inherent numerical order or scale between them -- they can be arranged in any order without changing the meaning of the display.

A histogram would be inappropriate here because a histogram is used for quantitative data, where the horizontal axis represents a numerical scale and bar width represents a range of values; since activity categories have no numeric scale, there is no meaningful way to order them along a continuous axis or to have bars touch (as a histogram requires) to represent adjacent numeric intervals.' where id = '1300dd2b-de29-4d8b-a990-376c8d3ff876';
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('1300dd2b-de29-4d8b-a990-376c8d3ff876', 'canonical_answer_1', 1, '(a) Relative frequency = count / 80 for each category. For example, Sports: 32/80 = 0.40.', ARRAY['part-a-criterion-02'], 'drafted', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('1300dd2b-de29-4d8b-a990-376c8d3ff876', 'canonical_answer_1', 2, '

', ARRAY[]::text[], 'assembly_literal', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('1300dd2b-de29-4d8b-a990-376c8d3ff876', 'canonical_answer_1', 3, 'The relative frequencies are: Sports = 32/80 = 0.40, Music = 12/80 = 0.15, Clubs = 20/80 = 0.25, None = 16/80 = 0.20.', ARRAY['part-a-criterion-01'], 'drafted', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('1300dd2b-de29-4d8b-a990-376c8d3ff876', 'canonical_answer_1', 4, '

', ARRAY[]::text[], 'assembly_literal', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('1300dd2b-de29-4d8b-a990-376c8d3ff876', 'canonical_answer_1', 5, '(b) A bar graph has four separate bars, one per category, with heights equal to 0.40 (Sports), 0.15 (Music), 0.25 (Clubs), and 0.20 (None) -- or equivalently the counts 32, 12, 20, 16.', ARRAY['part-b-criterion-01'], 'drafted', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('1300dd2b-de29-4d8b-a990-376c8d3ff876', 'canonical_answer_1', 6, '

', ARRAY[]::text[], 'assembly_literal', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('1300dd2b-de29-4d8b-a990-376c8d3ff876', 'canonical_answer_1', 7, 'The horizontal axis is labeled "Activity" with the four category names, the vertical axis is labeled "Relative Frequency" (or "Number of Students"), and the graph has a title such as "After-School Activity of Tenth-Grade Students."', ARRAY['part-b-criterion-02'], 'drafted', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('1300dd2b-de29-4d8b-a990-376c8d3ff876', 'canonical_answer_1', 8, '

', ARRAY[]::text[], 'assembly_literal', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('1300dd2b-de29-4d8b-a990-376c8d3ff876', 'canonical_answer_1', 9, 'The four bars are drawn with equal width and gaps between them (not touching), since activity is a categorical variable.', ARRAY['part-b-criterion-03'], 'drafted', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('1300dd2b-de29-4d8b-a990-376c8d3ff876', 'canonical_answer_1', 10, '

', ARRAY[]::text[], 'assembly_literal', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('1300dd2b-de29-4d8b-a990-376c8d3ff876', 'canonical_answer_1', 11, '(c) Sports is the most common activity, and Music is the least common.', ARRAY['part-c-criterion-01'], 'drafted', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('1300dd2b-de29-4d8b-a990-376c8d3ff876', 'canonical_answer_1', 12, '

', ARRAY[]::text[], 'assembly_literal', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('1300dd2b-de29-4d8b-a990-376c8d3ff876', 'canonical_answer_1', 13, 'Sports (40%, 32 students) is more than twice as common as the next-highest category, Clubs (25%, 20 students), while Music (15%, 12 students) is the least common, notably lower than the other three categories.', ARRAY['part-c-criterion-02'], 'drafted', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('1300dd2b-de29-4d8b-a990-376c8d3ff876', 'canonical_answer_1', 14, '

', ARRAY[]::text[], 'assembly_literal', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('1300dd2b-de29-4d8b-a990-376c8d3ff876', 'canonical_answer_1', 15, '(d) Activity is a categorical (qualitative) variable -- it places each student into a named group rather than recording a numeric measurement.', ARRAY['part-d-criterion-01'], 'drafted', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('1300dd2b-de29-4d8b-a990-376c8d3ff876', 'canonical_answer_1', 16, '

', ARRAY[]::text[], 'assembly_literal', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('1300dd2b-de29-4d8b-a990-376c8d3ff876', 'canonical_answer_1', 17, 'A bar graph is appropriate because the categories (Sports, Music, Clubs, None) have no inherent numerical order or scale between them -- they can be arranged in any order without changing the meaning of the display.', ARRAY['part-d-criterion-02'], 'drafted', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('1300dd2b-de29-4d8b-a990-376c8d3ff876', 'canonical_answer_1', 18, '

', ARRAY[]::text[], 'assembly_literal', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('1300dd2b-de29-4d8b-a990-376c8d3ff876', 'canonical_answer_1', 19, 'A histogram would be inappropriate here because a histogram is used for quantitative data, where the horizontal axis represents a numerical scale and bar width represents a range of values; since activity categories have no numeric scale, there is no meaningful way to order them along a continuous axis or to have bars touch (as a histogram requires) to represent adjacent numeric intervals.', ARRAY['part-d-criterion-03'], 'drafted', 'apstats_canonical_2026_09_25');

-- apstats-frq-u12-002 (2899b6c0-815c-4b54-a8a3-1f912e11d97d)
update app.content_item_versions set canonical_answer_1 = '(a) Landing on red and landing on blue are mutually exclusive outcomes (a single spin lands on exactly one sector), so P(red or blue) = P(red) + P(blue).

P(red or blue) = 3/8 + 2/8 = 5/8 = 0.625.

(b) Using the complement rule: P(not green) = 1 - P(green).

P(not green) = 1 - 2/8 = 6/8 = 0.75.

(c) The events "lands on red" and "lands on blue" are mutually exclusive.

Each spin results in the spinner landing on exactly one sector, and no sector is colored both red and blue.

By definition, mutually exclusive events cannot occur together: P(red and blue) = 0, since landing on red and landing on blue cannot both happen on the same spin.

(d) Since the two spins are independent, the probability that both land on red is the product of the individual probabilities: P(red) x P(red).

P(both red) = (3/8) x (3/8) = 9/64.

9/64 ≈ 0.1406.' where id = '2899b6c0-815c-4b54-a8a3-1f912e11d97d';
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('2899b6c0-815c-4b54-a8a3-1f912e11d97d', 'canonical_answer_1', 1, '(a) Landing on red and landing on blue are mutually exclusive outcomes (a single spin lands on exactly one sector), so P(red or blue) = P(red) + P(blue).', ARRAY['part-a-criterion-01'], 'drafted', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('2899b6c0-815c-4b54-a8a3-1f912e11d97d', 'canonical_answer_1', 2, '

', ARRAY[]::text[], 'assembly_literal', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('2899b6c0-815c-4b54-a8a3-1f912e11d97d', 'canonical_answer_1', 3, 'P(red or blue) = 3/8 + 2/8 = 5/8 = 0.625.', ARRAY['part-a-criterion-02'], 'drafted', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('2899b6c0-815c-4b54-a8a3-1f912e11d97d', 'canonical_answer_1', 4, '

', ARRAY[]::text[], 'assembly_literal', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('2899b6c0-815c-4b54-a8a3-1f912e11d97d', 'canonical_answer_1', 5, '(b) Using the complement rule: P(not green) = 1 - P(green).', ARRAY['part-b-criterion-01'], 'drafted', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('2899b6c0-815c-4b54-a8a3-1f912e11d97d', 'canonical_answer_1', 6, '

', ARRAY[]::text[], 'assembly_literal', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('2899b6c0-815c-4b54-a8a3-1f912e11d97d', 'canonical_answer_1', 7, 'P(not green) = 1 - 2/8 = 6/8 = 0.75.', ARRAY['part-b-criterion-02'], 'drafted', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('2899b6c0-815c-4b54-a8a3-1f912e11d97d', 'canonical_answer_1', 8, '

', ARRAY[]::text[], 'assembly_literal', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('2899b6c0-815c-4b54-a8a3-1f912e11d97d', 'canonical_answer_1', 9, '(c) The events "lands on red" and "lands on blue" are mutually exclusive.', ARRAY['part-c-criterion-01'], 'drafted', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('2899b6c0-815c-4b54-a8a3-1f912e11d97d', 'canonical_answer_1', 10, '

', ARRAY[]::text[], 'assembly_literal', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('2899b6c0-815c-4b54-a8a3-1f912e11d97d', 'canonical_answer_1', 11, 'Each spin results in the spinner landing on exactly one sector, and no sector is colored both red and blue.', ARRAY['part-c-criterion-02'], 'drafted', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('2899b6c0-815c-4b54-a8a3-1f912e11d97d', 'canonical_answer_1', 12, '

', ARRAY[]::text[], 'assembly_literal', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('2899b6c0-815c-4b54-a8a3-1f912e11d97d', 'canonical_answer_1', 13, 'By definition, mutually exclusive events cannot occur together: P(red and blue) = 0, since landing on red and landing on blue cannot both happen on the same spin.', ARRAY['part-c-criterion-03'], 'drafted', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('2899b6c0-815c-4b54-a8a3-1f912e11d97d', 'canonical_answer_1', 14, '

', ARRAY[]::text[], 'assembly_literal', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('2899b6c0-815c-4b54-a8a3-1f912e11d97d', 'canonical_answer_1', 15, '(d) Since the two spins are independent, the probability that both land on red is the product of the individual probabilities: P(red) x P(red).', ARRAY['part-d-criterion-01'], 'drafted', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('2899b6c0-815c-4b54-a8a3-1f912e11d97d', 'canonical_answer_1', 16, '

', ARRAY[]::text[], 'assembly_literal', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('2899b6c0-815c-4b54-a8a3-1f912e11d97d', 'canonical_answer_1', 17, 'P(both red) = (3/8) x (3/8) = 9/64.', ARRAY['part-d-criterion-02'], 'drafted', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('2899b6c0-815c-4b54-a8a3-1f912e11d97d', 'canonical_answer_1', 18, '

', ARRAY[]::text[], 'assembly_literal', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('2899b6c0-815c-4b54-a8a3-1f912e11d97d', 'canonical_answer_1', 19, '9/64 ≈ 0.1406.', ARRAY['part-d-criterion-03'], 'drafted', 'apstats_canonical_2026_09_25');

do $$
declare
  v_bad text;
begin
  select string_agg(civ.id::text, ', ') into v_bad
  from (values ('b2f2de47-2c10-4b83-bf97-89cdfd695e18'::uuid),('90fdfeba-dc7f-464c-9420-06a78ddb1830'::uuid),('f112c2b6-7101-4fb9-bee4-94d2c90ef8c4'::uuid),('1300dd2b-de29-4d8b-a990-376c8d3ff876'::uuid),('2899b6c0-815c-4b54-a8a3-1f912e11d97d'::uuid)) as t(vid)
  join app.content_item_versions civ on civ.id = t.vid
  cross join lateral (
    select string_agg(cas.span_text, '' order by cas.span_ordinal) as concat
    from app.canonical_answer_spans cas
    where cas.content_item_version_id = civ.id and cas.answer_field = 'canonical_answer_1'
  ) agg
  where agg.concat is distinct from civ.canonical_answer_1;

  if v_bad is not null then
    raise exception 'span concatenation mismatch for version ids: %', v_bad;
  end if;
end $$;

commit;

begin;

-- apstats-frq-u12-003 (f8ebd5b5-6ac8-405f-a564-bb6b0dfb0759)
update app.content_item_versions set canonical_answer_1 = '(a) Since IDs range from 001 to 400, three-digit labels are needed, so read the random digit table in groups of three digits at a time.

As each group of three digits is read, discard any group corresponding to a number outside 001-400 (i.e., 000 or 401-999).

Also skip any group that duplicates a number already selected (since each student can only be chosen once), and continue reading groups of three digits until 15 distinct valid numbers have been obtained.

The 15 students whose ID numbers correspond to the 15 selected valid numbers make up the sample.

(b) Surveying only students who happen to be in the cafeteria line during 5th period is a convenience sample, which systematically excludes any student not in that line during that period (e.g., students with a different lunch period, students who bring lunch from home, students absent that day).

The SRS procedure, by contrast, gives every one of the 400 students an equal chance of being selected, so it does not systematically exclude any group of students the way the cafeteria-line method does.

In context, this matters because opinions about cafeteria satisfaction could plausibly differ by lunch period or eating habits (for example, students who never eat in the cafeteria might have different, perhaps more negative, opinions) -- so the convenience sample could produce a biased estimate of true cafeteria satisfaction across the whole school, while the SRS would not have this systematic exclusion.

(c) The probability a particular student is included in an SRS of size 15 from a population of 400 is sample size divided by population size.

P(Maria is selected) = 15/400.

15/400 = 0.0375, or 3.75%.' where id = 'f8ebd5b5-6ac8-405f-a564-bb6b0dfb0759';
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('f8ebd5b5-6ac8-405f-a564-bb6b0dfb0759', 'canonical_answer_1', 1, '(a) Since IDs range from 001 to 400, three-digit labels are needed, so read the random digit table in groups of three digits at a time.', ARRAY['part-a-criterion-01'], 'drafted', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('f8ebd5b5-6ac8-405f-a564-bb6b0dfb0759', 'canonical_answer_1', 2, '

', ARRAY[]::text[], 'assembly_literal', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('f8ebd5b5-6ac8-405f-a564-bb6b0dfb0759', 'canonical_answer_1', 3, 'As each group of three digits is read, discard any group corresponding to a number outside 001-400 (i.e., 000 or 401-999).', ARRAY['part-a-criterion-02'], 'drafted', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('f8ebd5b5-6ac8-405f-a564-bb6b0dfb0759', 'canonical_answer_1', 4, '

', ARRAY[]::text[], 'assembly_literal', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('f8ebd5b5-6ac8-405f-a564-bb6b0dfb0759', 'canonical_answer_1', 5, 'Also skip any group that duplicates a number already selected (since each student can only be chosen once), and continue reading groups of three digits until 15 distinct valid numbers have been obtained.', ARRAY['part-a-criterion-03'], 'drafted', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('f8ebd5b5-6ac8-405f-a564-bb6b0dfb0759', 'canonical_answer_1', 6, '

', ARRAY[]::text[], 'assembly_literal', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('f8ebd5b5-6ac8-405f-a564-bb6b0dfb0759', 'canonical_answer_1', 7, 'The 15 students whose ID numbers correspond to the 15 selected valid numbers make up the sample.', ARRAY['part-a-criterion-04'], 'drafted', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('f8ebd5b5-6ac8-405f-a564-bb6b0dfb0759', 'canonical_answer_1', 8, '

', ARRAY[]::text[], 'assembly_literal', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('f8ebd5b5-6ac8-405f-a564-bb6b0dfb0759', 'canonical_answer_1', 9, '(b) Surveying only students who happen to be in the cafeteria line during 5th period is a convenience sample, which systematically excludes any student not in that line during that period (e.g., students with a different lunch period, students who bring lunch from home, students absent that day).', ARRAY['part-b-criterion-01'], 'drafted', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('f8ebd5b5-6ac8-405f-a564-bb6b0dfb0759', 'canonical_answer_1', 10, '

', ARRAY[]::text[], 'assembly_literal', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('f8ebd5b5-6ac8-405f-a564-bb6b0dfb0759', 'canonical_answer_1', 11, 'The SRS procedure, by contrast, gives every one of the 400 students an equal chance of being selected, so it does not systematically exclude any group of students the way the cafeteria-line method does.', ARRAY['part-b-criterion-02'], 'drafted', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('f8ebd5b5-6ac8-405f-a564-bb6b0dfb0759', 'canonical_answer_1', 12, '

', ARRAY[]::text[], 'assembly_literal', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('f8ebd5b5-6ac8-405f-a564-bb6b0dfb0759', 'canonical_answer_1', 13, 'In context, this matters because opinions about cafeteria satisfaction could plausibly differ by lunch period or eating habits (for example, students who never eat in the cafeteria might have different, perhaps more negative, opinions) -- so the convenience sample could produce a biased estimate of true cafeteria satisfaction across the whole school, while the SRS would not have this systematic exclusion.', ARRAY['part-b-criterion-03'], 'drafted', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('f8ebd5b5-6ac8-405f-a564-bb6b0dfb0759', 'canonical_answer_1', 14, '

', ARRAY[]::text[], 'assembly_literal', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('f8ebd5b5-6ac8-405f-a564-bb6b0dfb0759', 'canonical_answer_1', 15, '(c) The probability a particular student is included in an SRS of size 15 from a population of 400 is sample size divided by population size.', ARRAY['part-c-criterion-01'], 'drafted', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('f8ebd5b5-6ac8-405f-a564-bb6b0dfb0759', 'canonical_answer_1', 16, '

', ARRAY[]::text[], 'assembly_literal', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('f8ebd5b5-6ac8-405f-a564-bb6b0dfb0759', 'canonical_answer_1', 17, 'P(Maria is selected) = 15/400.', ARRAY['part-c-criterion-02'], 'drafted', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('f8ebd5b5-6ac8-405f-a564-bb6b0dfb0759', 'canonical_answer_1', 18, '

', ARRAY[]::text[], 'assembly_literal', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('f8ebd5b5-6ac8-405f-a564-bb6b0dfb0759', 'canonical_answer_1', 19, '15/400 = 0.0375, or 3.75%.', ARRAY['part-c-criterion-03'], 'drafted', 'apstats_canonical_2026_09_25');

-- apstats-frq-u12-004 (a01f2bff-79df-4a27-a7d8-39a12a4cb5df)
update app.content_item_versions set canonical_answer_1 = '(a) The mean is the sum of all 12 values divided by 12: (18+22+24+25+26+28+28+29+31+33+35+61)/12 = 360/12 = 30.

The data is already in order; with n=12 (even), the median is the average of the 6th and 7th values: (28+28)/2 = 28.

Both calculations require the data to be correctly summed (for the mean) and correctly ordered with the middle two values identified (for the median) -- the data given is already sorted, with the 6th and 7th values both equal to 28.

(b) The distribution is skewed to the right, due to the unusually high value of 61 pulling the upper tail of the distribution out.

This is reflected in the mean (30) being greater than the median (28).

The high value of 61 pulls the mean upward (since the mean uses every value in its calculation), while the median -- which depends only on the middle value(s)'' rank, not their magnitude -- is resistant to this extreme value and stays closer to the bulk of the data.

(c) The median is the more appropriate measure of the "typical" weekly training distance for this group.

This is because the value 61 is a high outlier that inflates the mean, making the mean less representative of what a typical runner in this group actually trains; the median is not affected by this extreme value.

The appropriate accompanying measure of spread is the interquartile range (IQR), which is resistant to outliers the same way the median is. Q1 (median of the lower 6 values 18,22,24,25,26,28) = (24+25)/2 = 24.5, and Q3 (median of the upper 6 values 28,29,31,33,35,61) = (31+33)/2 = 32.

IQR = Q3 - Q1 = 32 - 24.5 = 7.5.' where id = 'a01f2bff-79df-4a27-a7d8-39a12a4cb5df';
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('a01f2bff-79df-4a27-a7d8-39a12a4cb5df', 'canonical_answer_1', 1, '(a) The mean is the sum of all 12 values divided by 12: (18+22+24+25+26+28+28+29+31+33+35+61)/12 = 360/12 = 30.', ARRAY['part-a-criterion-01'], 'drafted', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('a01f2bff-79df-4a27-a7d8-39a12a4cb5df', 'canonical_answer_1', 2, '

', ARRAY[]::text[], 'assembly_literal', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('a01f2bff-79df-4a27-a7d8-39a12a4cb5df', 'canonical_answer_1', 3, 'The data is already in order; with n=12 (even), the median is the average of the 6th and 7th values: (28+28)/2 = 28.', ARRAY['part-a-criterion-02'], 'drafted', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('a01f2bff-79df-4a27-a7d8-39a12a4cb5df', 'canonical_answer_1', 4, '

', ARRAY[]::text[], 'assembly_literal', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('a01f2bff-79df-4a27-a7d8-39a12a4cb5df', 'canonical_answer_1', 5, 'Both calculations require the data to be correctly summed (for the mean) and correctly ordered with the middle two values identified (for the median) -- the data given is already sorted, with the 6th and 7th values both equal to 28.', ARRAY['part-a-criterion-03'], 'drafted', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('a01f2bff-79df-4a27-a7d8-39a12a4cb5df', 'canonical_answer_1', 6, '

', ARRAY[]::text[], 'assembly_literal', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('a01f2bff-79df-4a27-a7d8-39a12a4cb5df', 'canonical_answer_1', 7, '(b) The distribution is skewed to the right, due to the unusually high value of 61 pulling the upper tail of the distribution out.', ARRAY['part-b-criterion-01'], 'drafted', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('a01f2bff-79df-4a27-a7d8-39a12a4cb5df', 'canonical_answer_1', 8, '

', ARRAY[]::text[], 'assembly_literal', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('a01f2bff-79df-4a27-a7d8-39a12a4cb5df', 'canonical_answer_1', 9, 'This is reflected in the mean (30) being greater than the median (28).', ARRAY['part-b-criterion-02'], 'drafted', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('a01f2bff-79df-4a27-a7d8-39a12a4cb5df', 'canonical_answer_1', 10, '

', ARRAY[]::text[], 'assembly_literal', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('a01f2bff-79df-4a27-a7d8-39a12a4cb5df', 'canonical_answer_1', 11, 'The high value of 61 pulls the mean upward (since the mean uses every value in its calculation), while the median -- which depends only on the middle value(s)'' rank, not their magnitude -- is resistant to this extreme value and stays closer to the bulk of the data.', ARRAY['part-b-criterion-03'], 'drafted', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('a01f2bff-79df-4a27-a7d8-39a12a4cb5df', 'canonical_answer_1', 12, '

', ARRAY[]::text[], 'assembly_literal', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('a01f2bff-79df-4a27-a7d8-39a12a4cb5df', 'canonical_answer_1', 13, '(c) The median is the more appropriate measure of the "typical" weekly training distance for this group.', ARRAY['part-c-criterion-01'], 'drafted', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('a01f2bff-79df-4a27-a7d8-39a12a4cb5df', 'canonical_answer_1', 14, '

', ARRAY[]::text[], 'assembly_literal', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('a01f2bff-79df-4a27-a7d8-39a12a4cb5df', 'canonical_answer_1', 15, 'This is because the value 61 is a high outlier that inflates the mean, making the mean less representative of what a typical runner in this group actually trains; the median is not affected by this extreme value.', ARRAY['part-c-criterion-02'], 'drafted', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('a01f2bff-79df-4a27-a7d8-39a12a4cb5df', 'canonical_answer_1', 16, '

', ARRAY[]::text[], 'assembly_literal', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('a01f2bff-79df-4a27-a7d8-39a12a4cb5df', 'canonical_answer_1', 17, 'The appropriate accompanying measure of spread is the interquartile range (IQR), which is resistant to outliers the same way the median is. Q1 (median of the lower 6 values 18,22,24,25,26,28) = (24+25)/2 = 24.5, and Q3 (median of the upper 6 values 28,29,31,33,35,61) = (31+33)/2 = 32.', ARRAY['part-c-criterion-03'], 'drafted', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('a01f2bff-79df-4a27-a7d8-39a12a4cb5df', 'canonical_answer_1', 18, '

', ARRAY[]::text[], 'assembly_literal', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('a01f2bff-79df-4a27-a7d8-39a12a4cb5df', 'canonical_answer_1', 19, 'IQR = Q3 - Q1 = 32 - 24.5 = 7.5.', ARRAY['part-c-criterion-04'], 'drafted', 'apstats_canonical_2026_09_25');

-- apstats-frq-u12-005 (804d26da-67ae-4acf-8ad8-dc33c2459f67)
update app.content_item_versions set canonical_answer_1 = '(a) IQR = Q3 - Q1 = 55 - 42 = 13. The outlier fences are 1.5 x IQR = 1.5 x 13 = 19.5 beyond each quartile: lower fence = 42 - 19.5 = 22.5, upper fence = 55 + 19.5 = 74.5. Since the maximum value, 90, is greater than the upper fence of 74.5, 90 is an outlier by the 1.5xIQR rule. The minimum, 34, is greater than the lower fence of 22.5, so there is no low outlier.

(b) A modified boxplot shows a box from Q1=42 to Q3=55 with a line at the median=48. Since 90 is an outlier, the upper whisker extends only to the largest non-outlier value, 60, and 90 is plotted as a separate point beyond the whisker. The lower whisker extends to the minimum, 34, since there is no low outlier.

(c) The distribution appears skewed to the right: the presence of the high outlier (90), together with the gap between Q3 (55) and the next value (60) versus the larger jump to 90, and the fact that the mean (560/11 ≈ 50.9) is noticeably higher than the median (48), all point to a right-skewed shape with a long upper tail.

Because of the outlier and right skew, the median and IQR are the more appropriate choices for describing center and spread here, rather than the mean and standard deviation -- the mean and SD are both heavily influenced by the extreme value of 90, while the median and IQR are resistant to it and better reflect the typical height and spread of the bulk of the plants.' where id = '804d26da-67ae-4acf-8ad8-dc33c2459f67';
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('804d26da-67ae-4acf-8ad8-dc33c2459f67', 'canonical_answer_1', 1, '(a) IQR = Q3 - Q1 = 55 - 42 = 13. The outlier fences are 1.5 x IQR = 1.5 x 13 = 19.5 beyond each quartile: lower fence = 42 - 19.5 = 22.5, upper fence = 55 + 19.5 = 74.5. Since the maximum value, 90, is greater than the upper fence of 74.5, 90 is an outlier by the 1.5xIQR rule. The minimum, 34, is greater than the lower fence of 22.5, so there is no low outlier.', ARRAY['a'], 'drafted', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('804d26da-67ae-4acf-8ad8-dc33c2459f67', 'canonical_answer_1', 2, '

', ARRAY[]::text[], 'assembly_literal', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('804d26da-67ae-4acf-8ad8-dc33c2459f67', 'canonical_answer_1', 3, '(b) A modified boxplot shows a box from Q1=42 to Q3=55 with a line at the median=48. Since 90 is an outlier, the upper whisker extends only to the largest non-outlier value, 60, and 90 is plotted as a separate point beyond the whisker. The lower whisker extends to the minimum, 34, since there is no low outlier.', ARRAY['b'], 'drafted', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('804d26da-67ae-4acf-8ad8-dc33c2459f67', 'canonical_answer_1', 4, '

', ARRAY[]::text[], 'assembly_literal', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('804d26da-67ae-4acf-8ad8-dc33c2459f67', 'canonical_answer_1', 5, '(c) The distribution appears skewed to the right: the presence of the high outlier (90), together with the gap between Q3 (55) and the next value (60) versus the larger jump to 90, and the fact that the mean (560/11 ≈ 50.9) is noticeably higher than the median (48), all point to a right-skewed shape with a long upper tail.', ARRAY['c1'], 'drafted', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('804d26da-67ae-4acf-8ad8-dc33c2459f67', 'canonical_answer_1', 6, '

', ARRAY[]::text[], 'assembly_literal', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('804d26da-67ae-4acf-8ad8-dc33c2459f67', 'canonical_answer_1', 7, 'Because of the outlier and right skew, the median and IQR are the more appropriate choices for describing center and spread here, rather than the mean and standard deviation -- the mean and SD are both heavily influenced by the extreme value of 90, while the median and IQR are resistant to it and better reflect the typical height and spread of the bulk of the plants.', ARRAY['c2'], 'drafted', 'apstats_canonical_2026_09_25');

do $$
declare
  v_bad text;
begin
  select string_agg(civ.id::text, ', ') into v_bad
  from (values ('f8ebd5b5-6ac8-405f-a564-bb6b0dfb0759'::uuid),('a01f2bff-79df-4a27-a7d8-39a12a4cb5df'::uuid),('804d26da-67ae-4acf-8ad8-dc33c2459f67'::uuid)) as t(vid)
  join app.content_item_versions civ on civ.id = t.vid
  cross join lateral (
    select string_agg(cas.span_text, '' order by cas.span_ordinal) as concat
    from app.canonical_answer_spans cas
    where cas.content_item_version_id = civ.id and cas.answer_field = 'canonical_answer_1'
  ) agg
  where agg.concat is distinct from civ.canonical_answer_1;

  if v_bad is not null then
    raise exception 'span concatenation mismatch for version ids: %', v_bad;
  end if;
end $$;

commit;

begin;

-- apstats-frq-u12-006 (5a68fcbc-4c45-4bdc-ae2a-4acbcfaf79ac)
update app.content_item_versions set canonical_answer_1 = '(a) The marginal distribution is found by dividing each service''s overall total by the grand total of 200.

Service A: 80/200 = 0.40. Service B: 80/200 = 0.40. Service C: 40/200 = 0.20.

(b) The conditional distribution for each age group is found by dividing each cell in that age group''s column by that column''s total.

For adults Under 30 (column total 80): Service A = 48/80 = 0.60, Service B = 24/80 = 0.30, Service C = 8/80 = 0.10.

For adults 30 and Over (column total 120): Service A = 32/120 ≈ 0.267, Service B = 56/120 ≈ 0.467, Service C = 32/120 ≈ 0.267.

(c) Comparing these two conditional distributions (not the raw marginal totals):

Adults Under 30 strongly favor Service A (60%), while adults 30 and Over favor Service B instead (about 46.7%) -- a clearly different preference pattern between the two age groups.

Because the preferred service differs so much between the two conditional distributions, there does appear to be an association between age group and streaming service preference.

(d) The joint probability that a respondent is Under 30 and prefers Service C is the count in that cell divided by the grand total.

P(Under 30 and Service C) = 8/200 = 0.04.' where id = '5a68fcbc-4c45-4bdc-ae2a-4acbcfaf79ac';
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('5a68fcbc-4c45-4bdc-ae2a-4acbcfaf79ac', 'canonical_answer_1', 1, '(a) The marginal distribution is found by dividing each service''s overall total by the grand total of 200.', ARRAY['part-a-criterion-02'], 'drafted', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('5a68fcbc-4c45-4bdc-ae2a-4acbcfaf79ac', 'canonical_answer_1', 2, '

', ARRAY[]::text[], 'assembly_literal', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('5a68fcbc-4c45-4bdc-ae2a-4acbcfaf79ac', 'canonical_answer_1', 3, 'Service A: 80/200 = 0.40. Service B: 80/200 = 0.40. Service C: 40/200 = 0.20.', ARRAY['part-a-criterion-01'], 'drafted', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('5a68fcbc-4c45-4bdc-ae2a-4acbcfaf79ac', 'canonical_answer_1', 4, '

', ARRAY[]::text[], 'assembly_literal', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('5a68fcbc-4c45-4bdc-ae2a-4acbcfaf79ac', 'canonical_answer_1', 5, '(b) The conditional distribution for each age group is found by dividing each cell in that age group''s column by that column''s total.', ARRAY['part-b-criterion-03'], 'drafted', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('5a68fcbc-4c45-4bdc-ae2a-4acbcfaf79ac', 'canonical_answer_1', 6, '

', ARRAY[]::text[], 'assembly_literal', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('5a68fcbc-4c45-4bdc-ae2a-4acbcfaf79ac', 'canonical_answer_1', 7, 'For adults Under 30 (column total 80): Service A = 48/80 = 0.60, Service B = 24/80 = 0.30, Service C = 8/80 = 0.10.', ARRAY['part-b-criterion-01'], 'drafted', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('5a68fcbc-4c45-4bdc-ae2a-4acbcfaf79ac', 'canonical_answer_1', 8, '

', ARRAY[]::text[], 'assembly_literal', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('5a68fcbc-4c45-4bdc-ae2a-4acbcfaf79ac', 'canonical_answer_1', 9, 'For adults 30 and Over (column total 120): Service A = 32/120 ≈ 0.267, Service B = 56/120 ≈ 0.467, Service C = 32/120 ≈ 0.267.', ARRAY['part-b-criterion-02'], 'drafted', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('5a68fcbc-4c45-4bdc-ae2a-4acbcfaf79ac', 'canonical_answer_1', 10, '

', ARRAY[]::text[], 'assembly_literal', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('5a68fcbc-4c45-4bdc-ae2a-4acbcfaf79ac', 'canonical_answer_1', 11, '(c) Comparing these two conditional distributions (not the raw marginal totals):', ARRAY['part-c-criterion-03'], 'drafted', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('5a68fcbc-4c45-4bdc-ae2a-4acbcfaf79ac', 'canonical_answer_1', 12, '

', ARRAY[]::text[], 'assembly_literal', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('5a68fcbc-4c45-4bdc-ae2a-4acbcfaf79ac', 'canonical_answer_1', 13, 'Adults Under 30 strongly favor Service A (60%), while adults 30 and Over favor Service B instead (about 46.7%) -- a clearly different preference pattern between the two age groups.', ARRAY['part-c-criterion-01'], 'drafted', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('5a68fcbc-4c45-4bdc-ae2a-4acbcfaf79ac', 'canonical_answer_1', 14, '

', ARRAY[]::text[], 'assembly_literal', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('5a68fcbc-4c45-4bdc-ae2a-4acbcfaf79ac', 'canonical_answer_1', 15, 'Because the preferred service differs so much between the two conditional distributions, there does appear to be an association between age group and streaming service preference.', ARRAY['part-c-criterion-02'], 'drafted', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('5a68fcbc-4c45-4bdc-ae2a-4acbcfaf79ac', 'canonical_answer_1', 16, '

', ARRAY[]::text[], 'assembly_literal', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('5a68fcbc-4c45-4bdc-ae2a-4acbcfaf79ac', 'canonical_answer_1', 17, '(d) The joint probability that a respondent is Under 30 and prefers Service C is the count in that cell divided by the grand total.', ARRAY['part-d-criterion-01'], 'drafted', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('5a68fcbc-4c45-4bdc-ae2a-4acbcfaf79ac', 'canonical_answer_1', 18, '

', ARRAY[]::text[], 'assembly_literal', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('5a68fcbc-4c45-4bdc-ae2a-4acbcfaf79ac', 'canonical_answer_1', 19, 'P(Under 30 and Service C) = 8/200 = 0.04.', ARRAY['part-d-criterion-02'], 'drafted', 'apstats_canonical_2026_09_25');

-- apstats-frq-u12-007 (09c01266-44ef-4639-af6e-b9f8016b8211)
update app.content_item_versions set canonical_answer_1 = '(a) Out of a hypothetical 1000 people, 15% (150 people) have the allergy. Of these, the test is positive 92% of the time: 150 x 0.92 = 138 true positives, and negative the remaining 150 - 138 = 12 times.

The remaining 85% (850 people) do not have the allergy. Of these, the test is (incorrectly) positive 6% of the time: 850 x 0.06 = 51 false positives, and negative the remaining 850 - 51 = 799 times.

The complete table:

| | Test positive | Test negative | Total |
|---|---|---|---|
| Has allergy | 138 | 12 | 150 |
| No allergy | 51 | 799 | 850 |
| Total | 189 | 811 | 1000 |

(b) This asks for the conditional probability P(has allergy | test positive).

The numerator is the count of people who have the allergy AND tested positive: 138.

The denominator is the total number of people who tested positive: 189.

P(allergy | positive) = 138/189 ≈ 0.730, or about 73.0%.

(c) The 92% figure is P(positive | allergy) -- the probability of testing positive GIVEN that a person has the allergy. This is a different conditional probability than P(allergy | positive) found in part B, since the order of conditioning matters: these are not the same quantity.

Because the allergy is relatively rare in this population (only 15% prevalence) and the false-positive rate (6%) is not zero, a substantial number of positive test results come from the much larger group of people who do NOT have the allergy, even though that group''s individual false-positive rate is low.

Specifically, of the 189 total positive results, 51 are false positives (from the no-allergy group) compared to 138 true positives (from the allergy group) -- so while most positives are still true positives, the sizable false-positive count (driven by the large no-allergy population) pulls P(allergy | positive) down from the 92% figure to about 73%.' where id = '09c01266-44ef-4639-af6e-b9f8016b8211';
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('09c01266-44ef-4639-af6e-b9f8016b8211', 'canonical_answer_1', 1, '(a) Out of a hypothetical 1000 people, 15% (150 people) have the allergy. Of these, the test is positive 92% of the time: 150 x 0.92 = 138 true positives, and negative the remaining 150 - 138 = 12 times.', ARRAY['part-a-criterion-01'], 'drafted', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('09c01266-44ef-4639-af6e-b9f8016b8211', 'canonical_answer_1', 2, '

', ARRAY[]::text[], 'assembly_literal', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('09c01266-44ef-4639-af6e-b9f8016b8211', 'canonical_answer_1', 3, 'The remaining 85% (850 people) do not have the allergy. Of these, the test is (incorrectly) positive 6% of the time: 850 x 0.06 = 51 false positives, and negative the remaining 850 - 51 = 799 times.', ARRAY['part-a-criterion-02'], 'drafted', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('09c01266-44ef-4639-af6e-b9f8016b8211', 'canonical_answer_1', 4, '

', ARRAY[]::text[], 'assembly_literal', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('09c01266-44ef-4639-af6e-b9f8016b8211', 'canonical_answer_1', 5, 'The complete table:

| | Test positive | Test negative | Total |
|---|---|---|---|
| Has allergy | 138 | 12 | 150 |
| No allergy | 51 | 799 | 850 |
| Total | 189 | 811 | 1000 |', ARRAY['part-a-criterion-03'], 'drafted', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('09c01266-44ef-4639-af6e-b9f8016b8211', 'canonical_answer_1', 6, '

', ARRAY[]::text[], 'assembly_literal', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('09c01266-44ef-4639-af6e-b9f8016b8211', 'canonical_answer_1', 7, '(b) This asks for the conditional probability P(has allergy | test positive).', ARRAY['part-b-criterion-01'], 'drafted', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('09c01266-44ef-4639-af6e-b9f8016b8211', 'canonical_answer_1', 8, '

', ARRAY[]::text[], 'assembly_literal', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('09c01266-44ef-4639-af6e-b9f8016b8211', 'canonical_answer_1', 9, 'The numerator is the count of people who have the allergy AND tested positive: 138.', ARRAY['part-b-criterion-02'], 'drafted', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('09c01266-44ef-4639-af6e-b9f8016b8211', 'canonical_answer_1', 10, '

', ARRAY[]::text[], 'assembly_literal', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('09c01266-44ef-4639-af6e-b9f8016b8211', 'canonical_answer_1', 11, 'The denominator is the total number of people who tested positive: 189.', ARRAY['part-b-criterion-03'], 'drafted', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('09c01266-44ef-4639-af6e-b9f8016b8211', 'canonical_answer_1', 12, '

', ARRAY[]::text[], 'assembly_literal', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('09c01266-44ef-4639-af6e-b9f8016b8211', 'canonical_answer_1', 13, 'P(allergy | positive) = 138/189 ≈ 0.730, or about 73.0%.', ARRAY['part-b-criterion-04'], 'drafted', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('09c01266-44ef-4639-af6e-b9f8016b8211', 'canonical_answer_1', 14, '

', ARRAY[]::text[], 'assembly_literal', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('09c01266-44ef-4639-af6e-b9f8016b8211', 'canonical_answer_1', 15, '(c) The 92% figure is P(positive | allergy) -- the probability of testing positive GIVEN that a person has the allergy. This is a different conditional probability than P(allergy | positive) found in part B, since the order of conditioning matters: these are not the same quantity.', ARRAY['part-c-criterion-01'], 'drafted', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('09c01266-44ef-4639-af6e-b9f8016b8211', 'canonical_answer_1', 16, '

', ARRAY[]::text[], 'assembly_literal', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('09c01266-44ef-4639-af6e-b9f8016b8211', 'canonical_answer_1', 17, 'Because the allergy is relatively rare in this population (only 15% prevalence) and the false-positive rate (6%) is not zero, a substantial number of positive test results come from the much larger group of people who do NOT have the allergy, even though that group''s individual false-positive rate is low.', ARRAY['part-c-criterion-02'], 'drafted', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('09c01266-44ef-4639-af6e-b9f8016b8211', 'canonical_answer_1', 18, '

', ARRAY[]::text[], 'assembly_literal', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('09c01266-44ef-4639-af6e-b9f8016b8211', 'canonical_answer_1', 19, 'Specifically, of the 189 total positive results, 51 are false positives (from the no-allergy group) compared to 138 true positives (from the allergy group) -- so while most positives are still true positives, the sizable false-positive count (driven by the large no-allergy population) pulls P(allergy | positive) down from the 92% figure to about 73%.', ARRAY['part-c-criterion-03'], 'drafted', 'apstats_canonical_2026_09_25');

-- apstats-frq-u12-008 (ff256908-1a1d-4138-a396-0f24d1e0a8e4)
update app.content_item_versions set canonical_answer_1 = '(a) The probabilities for each outcome are: P(grand prize, $50) = 1/20 = 0.05, P(medium prize, $10) = 4/20 = 0.20, P(small prize, $2) = 5/20 = 0.25, P(no prize, $0) = 10/20 = 0.50.

E(X) = 50(0.05) + 10(0.20) + 2(0.25) + 0(0.50).

E(X) = 2.5 + 2 + 0.5 + 0 = $5.00.

(b) Since E(X) = $5, exactly equal to the $5 cost to play, the game is fair on average -- in the long run over many plays, a player''s net gain (winnings minus cost) would average out to $0.

This is a statement about the long-run average across many plays, not a guarantee about the outcome of any single play -- an individual player could win more or less than $5 on any given play.

(c) E(X²) = 50²(0.05) + 10²(0.20) + 2²(0.25) + 0²(0.50) = 2500(0.05) + 100(0.20) + 4(0.25) + 0 = 125 + 20 + 1 + 0 = 146.

Variance = E(X²) - [E(X)]² = 146 - 5² = 146 - 25 = 121.

Standard deviation = sqrt(121) = $11.00.

(d) An SD of $11, compared to a mean of $5, indicates substantial variability in the winnings -- consistent with the wide range of possible outcomes, from $0 to $50.

Compared to a hypothetical game with SD = $2, this game''s outcomes are much more spread out around the expected value; a game with SD = $2 would have outcomes clustering much more tightly around its own expected value, making it a less risky, more predictable game than this one.' where id = 'ff256908-1a1d-4138-a396-0f24d1e0a8e4';
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('ff256908-1a1d-4138-a396-0f24d1e0a8e4', 'canonical_answer_1', 1, '(a) The probabilities for each outcome are: P(grand prize, $50) = 1/20 = 0.05, P(medium prize, $10) = 4/20 = 0.20, P(small prize, $2) = 5/20 = 0.25, P(no prize, $0) = 10/20 = 0.50.', ARRAY['part-a-criterion-01'], 'drafted', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('ff256908-1a1d-4138-a396-0f24d1e0a8e4', 'canonical_answer_1', 2, '

', ARRAY[]::text[], 'assembly_literal', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('ff256908-1a1d-4138-a396-0f24d1e0a8e4', 'canonical_answer_1', 3, 'E(X) = 50(0.05) + 10(0.20) + 2(0.25) + 0(0.50).', ARRAY['part-a-criterion-02'], 'drafted', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('ff256908-1a1d-4138-a396-0f24d1e0a8e4', 'canonical_answer_1', 4, '

', ARRAY[]::text[], 'assembly_literal', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('ff256908-1a1d-4138-a396-0f24d1e0a8e4', 'canonical_answer_1', 5, 'E(X) = 2.5 + 2 + 0.5 + 0 = $5.00.', ARRAY['part-a-criterion-03'], 'drafted', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('ff256908-1a1d-4138-a396-0f24d1e0a8e4', 'canonical_answer_1', 6, '

', ARRAY[]::text[], 'assembly_literal', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('ff256908-1a1d-4138-a396-0f24d1e0a8e4', 'canonical_answer_1', 7, '(b) Since E(X) = $5, exactly equal to the $5 cost to play, the game is fair on average -- in the long run over many plays, a player''s net gain (winnings minus cost) would average out to $0.', ARRAY['part-b-criterion-01'], 'drafted', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('ff256908-1a1d-4138-a396-0f24d1e0a8e4', 'canonical_answer_1', 8, '

', ARRAY[]::text[], 'assembly_literal', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('ff256908-1a1d-4138-a396-0f24d1e0a8e4', 'canonical_answer_1', 9, 'This is a statement about the long-run average across many plays, not a guarantee about the outcome of any single play -- an individual player could win more or less than $5 on any given play.', ARRAY['part-b-criterion-02'], 'drafted', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('ff256908-1a1d-4138-a396-0f24d1e0a8e4', 'canonical_answer_1', 10, '

', ARRAY[]::text[], 'assembly_literal', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('ff256908-1a1d-4138-a396-0f24d1e0a8e4', 'canonical_answer_1', 11, '(c) E(X²) = 50²(0.05) + 10²(0.20) + 2²(0.25) + 0²(0.50) = 2500(0.05) + 100(0.20) + 4(0.25) + 0 = 125 + 20 + 1 + 0 = 146.', ARRAY['part-c-criterion-01'], 'drafted', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('ff256908-1a1d-4138-a396-0f24d1e0a8e4', 'canonical_answer_1', 12, '

', ARRAY[]::text[], 'assembly_literal', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('ff256908-1a1d-4138-a396-0f24d1e0a8e4', 'canonical_answer_1', 13, 'Variance = E(X²) - [E(X)]² = 146 - 5² = 146 - 25 = 121.', ARRAY['part-c-criterion-02'], 'drafted', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('ff256908-1a1d-4138-a396-0f24d1e0a8e4', 'canonical_answer_1', 14, '

', ARRAY[]::text[], 'assembly_literal', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('ff256908-1a1d-4138-a396-0f24d1e0a8e4', 'canonical_answer_1', 15, 'Standard deviation = sqrt(121) = $11.00.', ARRAY['part-c-criterion-03'], 'drafted', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('ff256908-1a1d-4138-a396-0f24d1e0a8e4', 'canonical_answer_1', 16, '

', ARRAY[]::text[], 'assembly_literal', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('ff256908-1a1d-4138-a396-0f24d1e0a8e4', 'canonical_answer_1', 17, '(d) An SD of $11, compared to a mean of $5, indicates substantial variability in the winnings -- consistent with the wide range of possible outcomes, from $0 to $50.', ARRAY['part-d-criterion-01'], 'drafted', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('ff256908-1a1d-4138-a396-0f24d1e0a8e4', 'canonical_answer_1', 18, '

', ARRAY[]::text[], 'assembly_literal', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('ff256908-1a1d-4138-a396-0f24d1e0a8e4', 'canonical_answer_1', 19, 'Compared to a hypothetical game with SD = $2, this game''s outcomes are much more spread out around the expected value; a game with SD = $2 would have outcomes clustering much more tightly around its own expected value, making it a less risky, more predictable game than this one.', ARRAY['part-d-criterion-02'], 'drafted', 'apstats_canonical_2026_09_25');

-- apstats-frq-u12-009 (350a6f19-505d-476e-a513-f7cc14473966)
update app.content_item_versions set canonical_answer_1 = '(a) There is a fixed number of trials (n = 6 free-throw attempts), and each trial has exactly two possible outcomes: make or miss.

The trials are independent of each other (the outcome of one free throw does not affect another), and the probability of success is constant at p = 0.75 for every attempt -- satisfying all the conditions for a binomial random variable.

(b) P(X=4) = C(6,4) x (0.75)^4 x (0.25)^2, using the binomial probability formula.

C(6,4) = 15.

(0.75)^4 = 0.31640625, and (0.25)^2 = 0.0625.

P(X=4) = 15 x 0.31640625 x 0.0625 ≈ 0.2966.

(c) The mean of a binomial random variable is mu = np.

mu = 6 x 0.75 = 4.5.

The standard deviation of a binomial random variable is sigma = sqrt(np(1-p)).

sigma = sqrt(6 x 0.75 x 0.25) = sqrt(1.125) ≈ 1.061.' where id = '350a6f19-505d-476e-a513-f7cc14473966';
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('350a6f19-505d-476e-a513-f7cc14473966', 'canonical_answer_1', 1, '(a) There is a fixed number of trials (n = 6 free-throw attempts), and each trial has exactly two possible outcomes: make or miss.', ARRAY['part-a-criterion-01'], 'drafted', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('350a6f19-505d-476e-a513-f7cc14473966', 'canonical_answer_1', 2, '

', ARRAY[]::text[], 'assembly_literal', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('350a6f19-505d-476e-a513-f7cc14473966', 'canonical_answer_1', 3, 'The trials are independent of each other (the outcome of one free throw does not affect another), and the probability of success is constant at p = 0.75 for every attempt -- satisfying all the conditions for a binomial random variable.', ARRAY['part-a-criterion-02'], 'drafted', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('350a6f19-505d-476e-a513-f7cc14473966', 'canonical_answer_1', 4, '

', ARRAY[]::text[], 'assembly_literal', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('350a6f19-505d-476e-a513-f7cc14473966', 'canonical_answer_1', 5, '(b) P(X=4) = C(6,4) x (0.75)^4 x (0.25)^2, using the binomial probability formula.', ARRAY['part-b-criterion-01'], 'drafted', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('350a6f19-505d-476e-a513-f7cc14473966', 'canonical_answer_1', 6, '

', ARRAY[]::text[], 'assembly_literal', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('350a6f19-505d-476e-a513-f7cc14473966', 'canonical_answer_1', 7, 'C(6,4) = 15.', ARRAY['part-b-criterion-02'], 'drafted', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('350a6f19-505d-476e-a513-f7cc14473966', 'canonical_answer_1', 8, '

', ARRAY[]::text[], 'assembly_literal', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('350a6f19-505d-476e-a513-f7cc14473966', 'canonical_answer_1', 9, '(0.75)^4 = 0.31640625, and (0.25)^2 = 0.0625.', ARRAY['part-b-criterion-03'], 'drafted', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('350a6f19-505d-476e-a513-f7cc14473966', 'canonical_answer_1', 10, '

', ARRAY[]::text[], 'assembly_literal', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('350a6f19-505d-476e-a513-f7cc14473966', 'canonical_answer_1', 11, 'P(X=4) = 15 x 0.31640625 x 0.0625 ≈ 0.2966.', ARRAY['part-b-criterion-04'], 'drafted', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('350a6f19-505d-476e-a513-f7cc14473966', 'canonical_answer_1', 12, '

', ARRAY[]::text[], 'assembly_literal', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('350a6f19-505d-476e-a513-f7cc14473966', 'canonical_answer_1', 13, '(c) The mean of a binomial random variable is mu = np.', ARRAY['part-c-criterion-01'], 'drafted', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('350a6f19-505d-476e-a513-f7cc14473966', 'canonical_answer_1', 14, '

', ARRAY[]::text[], 'assembly_literal', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('350a6f19-505d-476e-a513-f7cc14473966', 'canonical_answer_1', 15, 'mu = 6 x 0.75 = 4.5.', ARRAY['part-c-criterion-02'], 'drafted', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('350a6f19-505d-476e-a513-f7cc14473966', 'canonical_answer_1', 16, '

', ARRAY[]::text[], 'assembly_literal', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('350a6f19-505d-476e-a513-f7cc14473966', 'canonical_answer_1', 17, 'The standard deviation of a binomial random variable is sigma = sqrt(np(1-p)).', ARRAY['part-c-criterion-03'], 'drafted', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('350a6f19-505d-476e-a513-f7cc14473966', 'canonical_answer_1', 18, '

', ARRAY[]::text[], 'assembly_literal', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('350a6f19-505d-476e-a513-f7cc14473966', 'canonical_answer_1', 19, 'sigma = sqrt(6 x 0.75 x 0.25) = sqrt(1.125) ≈ 1.061.', ARRAY['part-c-criterion-04'], 'drafted', 'apstats_canonical_2026_09_25');

do $$
declare
  v_bad text;
begin
  select string_agg(civ.id::text, ', ') into v_bad
  from (values ('5a68fcbc-4c45-4bdc-ae2a-4acbcfaf79ac'::uuid),('09c01266-44ef-4639-af6e-b9f8016b8211'::uuid),('ff256908-1a1d-4138-a396-0f24d1e0a8e4'::uuid),('350a6f19-505d-476e-a513-f7cc14473966'::uuid)) as t(vid)
  join app.content_item_versions civ on civ.id = t.vid
  cross join lateral (
    select string_agg(cas.span_text, '' order by cas.span_ordinal) as concat
    from app.canonical_answer_spans cas
    where cas.content_item_version_id = civ.id and cas.answer_field = 'canonical_answer_1'
  ) agg
  where agg.concat is distinct from civ.canonical_answer_1;

  if v_bad is not null then
    raise exception 'span concatenation mismatch for version ids: %', v_bad;
  end if;
end $$;

commit;

begin;

-- apstats-frq-u12-010 (22897ba4-5b51-473d-a7dc-ea9012892f99)
update app.content_item_versions set canonical_answer_1 = '(a) The researcher should randomly assign the 40 plants to the two fertilizer groups (e.g., 20 plants to the new fertilizer, 20 to the standard fertilizer) using a chance mechanism such as a random number generator or drawing labels.

Random assignment is important because it balances out other variables (lurking variables like individual plant vigor or genetic variation) between the two groups on average, so the groups start out similar in every way except the fertilizer they receive.

This allows any observed difference in yield between the two groups to be attributed to the fertilizer itself, rather than to some other systematic difference between the groups that existed before the fertilizer was applied.

(b) Blocking can be incorporated by treating each of the 4 shelves as a block: group the 10 plants on each shelf together, then randomly assign fertilizer (e.g., 5 new, 5 standard) separately within each shelf/block, rather than randomizing across all 40 plants at once.

The benefit is that it removes variability due to the blocking variable (distance from the light source, which differs by shelf) from the comparison between fertilizers -- since each block contains both fertilizer groups, any shelf-to-shelf difference in light exposure affects both groups equally within that block, preventing it from being confused with the fertilizer''s effect.

Random assignment of fertilizer type still happens within each block (each shelf), preserving the benefits of randomization while also controlling for the shelf/light effect.

(c) The explanatory variable is fertilizer type (new vs. standard).

The response variable is plant yield (for example, the amount or weight of beans produced by each plant).

(d) This is an experiment, not an observational study, because the researcher actively assigns/imposes the treatment (which fertilizer each plant receives) rather than simply observing plants that happened to already be using one fertilizer or another.

Because the treatment is actively and randomly imposed rather than observed, this design allows the researcher to draw a cause-and-effect conclusion about fertilizer''s effect on yield -- unlike an observational study, which could only establish an association between fertilizer use and yield, not causation.' where id = '22897ba4-5b51-473d-a7dc-ea9012892f99';
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('22897ba4-5b51-473d-a7dc-ea9012892f99', 'canonical_answer_1', 1, '(a) The researcher should randomly assign the 40 plants to the two fertilizer groups (e.g., 20 plants to the new fertilizer, 20 to the standard fertilizer) using a chance mechanism such as a random number generator or drawing labels.', ARRAY['part-a-criterion-01'], 'drafted', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('22897ba4-5b51-473d-a7dc-ea9012892f99', 'canonical_answer_1', 2, '

', ARRAY[]::text[], 'assembly_literal', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('22897ba4-5b51-473d-a7dc-ea9012892f99', 'canonical_answer_1', 3, 'Random assignment is important because it balances out other variables (lurking variables like individual plant vigor or genetic variation) between the two groups on average, so the groups start out similar in every way except the fertilizer they receive.', ARRAY['part-a-criterion-02'], 'drafted', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('22897ba4-5b51-473d-a7dc-ea9012892f99', 'canonical_answer_1', 4, '

', ARRAY[]::text[], 'assembly_literal', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('22897ba4-5b51-473d-a7dc-ea9012892f99', 'canonical_answer_1', 5, 'This allows any observed difference in yield between the two groups to be attributed to the fertilizer itself, rather than to some other systematic difference between the groups that existed before the fertilizer was applied.', ARRAY['part-a-criterion-03'], 'drafted', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('22897ba4-5b51-473d-a7dc-ea9012892f99', 'canonical_answer_1', 6, '

', ARRAY[]::text[], 'assembly_literal', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('22897ba4-5b51-473d-a7dc-ea9012892f99', 'canonical_answer_1', 7, '(b) Blocking can be incorporated by treating each of the 4 shelves as a block: group the 10 plants on each shelf together, then randomly assign fertilizer (e.g., 5 new, 5 standard) separately within each shelf/block, rather than randomizing across all 40 plants at once.', ARRAY['part-b-criterion-01'], 'drafted', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('22897ba4-5b51-473d-a7dc-ea9012892f99', 'canonical_answer_1', 8, '

', ARRAY[]::text[], 'assembly_literal', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('22897ba4-5b51-473d-a7dc-ea9012892f99', 'canonical_answer_1', 9, 'The benefit is that it removes variability due to the blocking variable (distance from the light source, which differs by shelf) from the comparison between fertilizers -- since each block contains both fertilizer groups, any shelf-to-shelf difference in light exposure affects both groups equally within that block, preventing it from being confused with the fertilizer''s effect.', ARRAY['part-b-criterion-02'], 'drafted', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('22897ba4-5b51-473d-a7dc-ea9012892f99', 'canonical_answer_1', 10, '

', ARRAY[]::text[], 'assembly_literal', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('22897ba4-5b51-473d-a7dc-ea9012892f99', 'canonical_answer_1', 11, 'Random assignment of fertilizer type still happens within each block (each shelf), preserving the benefits of randomization while also controlling for the shelf/light effect.', ARRAY['part-b-criterion-03'], 'drafted', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('22897ba4-5b51-473d-a7dc-ea9012892f99', 'canonical_answer_1', 12, '

', ARRAY[]::text[], 'assembly_literal', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('22897ba4-5b51-473d-a7dc-ea9012892f99', 'canonical_answer_1', 13, '(c) The explanatory variable is fertilizer type (new vs. standard).', ARRAY['part-c-criterion-01'], 'drafted', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('22897ba4-5b51-473d-a7dc-ea9012892f99', 'canonical_answer_1', 14, '

', ARRAY[]::text[], 'assembly_literal', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('22897ba4-5b51-473d-a7dc-ea9012892f99', 'canonical_answer_1', 15, 'The response variable is plant yield (for example, the amount or weight of beans produced by each plant).', ARRAY['part-c-criterion-02'], 'drafted', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('22897ba4-5b51-473d-a7dc-ea9012892f99', 'canonical_answer_1', 16, '

', ARRAY[]::text[], 'assembly_literal', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('22897ba4-5b51-473d-a7dc-ea9012892f99', 'canonical_answer_1', 17, '(d) This is an experiment, not an observational study, because the researcher actively assigns/imposes the treatment (which fertilizer each plant receives) rather than simply observing plants that happened to already be using one fertilizer or another.', ARRAY['part-d-criterion-01'], 'drafted', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('22897ba4-5b51-473d-a7dc-ea9012892f99', 'canonical_answer_1', 18, '

', ARRAY[]::text[], 'assembly_literal', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('22897ba4-5b51-473d-a7dc-ea9012892f99', 'canonical_answer_1', 19, 'Because the treatment is actively and randomly imposed rather than observed, this design allows the researcher to draw a cause-and-effect conclusion about fertilizer''s effect on yield -- unlike an observational study, which could only establish an association between fertilizer use and yield, not causation.', ARRAY['part-d-criterion-02'], 'drafted', 'apstats_canonical_2026_09_25');

-- apstats-frq-u12-011 (9a053602-a9d5-4a4a-a641-afb2d8fc9f11)
update app.content_item_versions set canonical_answer_1 = '(a) z = (650 - 500)/90 = 150/90 ≈ 1.667.

This calls for the upper-tail probability P(Z > 1.667), i.e. the area under the standard normal curve to the right of z=1.667.

P(Z > 1.667) ≈ 1 - 0.9522 = 0.0478, so approximately 4.78% of test-takers score above 650.

(b) The z-score corresponding to the 90th percentile is approximately z = 1.28 (more precisely, 1.2816).

Setting up the inverse-normal equation: score = mean + z x SD = 500 + 1.2816 x 90.

score = 500 + 115.3 ≈ 615.3, so a score of approximately 615 separates the top 10% of test-takers from the rest.

(c) Since the individual scores are approximately normally distributed (and/or n=36 is large enough for the Central Limit Theorem to apply), the sampling distribution of the sample mean is also approximately normal, centered at the population mean 500.

The standard error of the sample mean is SD/sqrt(n) = 90/sqrt(36) = 90/6 = 15.

z = (520 - 500)/15 = 20/15 ≈ 1.333.

P(sample mean > 520) = P(Z > 1.333) ≈ 1 - 0.9088 = 0.0912, so approximately 9.12%.' where id = '9a053602-a9d5-4a4a-a641-afb2d8fc9f11';
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('9a053602-a9d5-4a4a-a641-afb2d8fc9f11', 'canonical_answer_1', 1, '(a) z = (650 - 500)/90 = 150/90 ≈ 1.667.', ARRAY['part-a-criterion-01'], 'drafted', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('9a053602-a9d5-4a4a-a641-afb2d8fc9f11', 'canonical_answer_1', 2, '

', ARRAY[]::text[], 'assembly_literal', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('9a053602-a9d5-4a4a-a641-afb2d8fc9f11', 'canonical_answer_1', 3, 'This calls for the upper-tail probability P(Z > 1.667), i.e. the area under the standard normal curve to the right of z=1.667.', ARRAY['part-a-criterion-02'], 'drafted', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('9a053602-a9d5-4a4a-a641-afb2d8fc9f11', 'canonical_answer_1', 4, '

', ARRAY[]::text[], 'assembly_literal', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('9a053602-a9d5-4a4a-a641-afb2d8fc9f11', 'canonical_answer_1', 5, 'P(Z > 1.667) ≈ 1 - 0.9522 = 0.0478, so approximately 4.78% of test-takers score above 650.', ARRAY['part-a-criterion-03'], 'drafted', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('9a053602-a9d5-4a4a-a641-afb2d8fc9f11', 'canonical_answer_1', 6, '

', ARRAY[]::text[], 'assembly_literal', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('9a053602-a9d5-4a4a-a641-afb2d8fc9f11', 'canonical_answer_1', 7, '(b) The z-score corresponding to the 90th percentile is approximately z = 1.28 (more precisely, 1.2816).', ARRAY['part-b-criterion-01'], 'drafted', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('9a053602-a9d5-4a4a-a641-afb2d8fc9f11', 'canonical_answer_1', 8, '

', ARRAY[]::text[], 'assembly_literal', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('9a053602-a9d5-4a4a-a641-afb2d8fc9f11', 'canonical_answer_1', 9, 'Setting up the inverse-normal equation: score = mean + z x SD = 500 + 1.2816 x 90.', ARRAY['part-b-criterion-02'], 'drafted', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('9a053602-a9d5-4a4a-a641-afb2d8fc9f11', 'canonical_answer_1', 10, '

', ARRAY[]::text[], 'assembly_literal', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('9a053602-a9d5-4a4a-a641-afb2d8fc9f11', 'canonical_answer_1', 11, 'score = 500 + 115.3 ≈ 615.3, so a score of approximately 615 separates the top 10% of test-takers from the rest.', ARRAY['part-b-criterion-03'], 'drafted', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('9a053602-a9d5-4a4a-a641-afb2d8fc9f11', 'canonical_answer_1', 12, '

', ARRAY[]::text[], 'assembly_literal', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('9a053602-a9d5-4a4a-a641-afb2d8fc9f11', 'canonical_answer_1', 13, '(c) Since the individual scores are approximately normally distributed (and/or n=36 is large enough for the Central Limit Theorem to apply), the sampling distribution of the sample mean is also approximately normal, centered at the population mean 500.', ARRAY['part-c-criterion-01'], 'drafted', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('9a053602-a9d5-4a4a-a641-afb2d8fc9f11', 'canonical_answer_1', 14, '

', ARRAY[]::text[], 'assembly_literal', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('9a053602-a9d5-4a4a-a641-afb2d8fc9f11', 'canonical_answer_1', 15, 'The standard error of the sample mean is SD/sqrt(n) = 90/sqrt(36) = 90/6 = 15.', ARRAY['part-c-criterion-02'], 'drafted', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('9a053602-a9d5-4a4a-a641-afb2d8fc9f11', 'canonical_answer_1', 16, '

', ARRAY[]::text[], 'assembly_literal', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('9a053602-a9d5-4a4a-a641-afb2d8fc9f11', 'canonical_answer_1', 17, 'z = (520 - 500)/15 = 20/15 ≈ 1.333.', ARRAY['part-c-criterion-03'], 'drafted', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('9a053602-a9d5-4a4a-a641-afb2d8fc9f11', 'canonical_answer_1', 18, '

', ARRAY[]::text[], 'assembly_literal', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('9a053602-a9d5-4a4a-a641-afb2d8fc9f11', 'canonical_answer_1', 19, 'P(sample mean > 520) = P(Z > 1.333) ≈ 1 - 0.9088 = 0.0912, so approximately 9.12%.', ARRAY['part-c-criterion-04'], 'drafted', 'apstats_canonical_2026_09_25');

-- apstats-frq-u12-012 (3ffe16de-35ff-46ed-ad96-6709fc159cd4)
update app.content_item_versions set canonical_answer_1 = '(a) Downtown (12,15,18,20,22,25,28,30,55): mean = (12+15+18+20+22+25+28+30+55)/9 = 225/9 = 25.0. With n=9, the median is the 5th value in the sorted list: 22.

Suburban (25,27,29,30,31,33,34,36,38): mean = (25+27+29+30+31+33+34+36+38)/9 = 283/9 ≈ 31.44. The median is the 5th value: 31.

(b) Shape: the Downtown distribution is right-skewed (due to the 55-minute value pulling the upper tail out), while the Suburban distribution is fairly symmetric (evenly spread from 25 to 38 with no extreme values).

Center: the Suburban office has a higher typical commute time than Downtown (median 31 minutes vs. 22 minutes; mean 31.44 vs. 25.0).

Spread: the Downtown data has greater spread (range 55-12=43 vs. Suburban''s range 38-25=13), which is largely driven by the 55-minute outlier.

In summary: Suburban commute times are greater in typical value (higher median/mean) than Downtown, while Downtown commute times are more spread out (greater range) than Suburban, mainly due to Downtown''s high outlier; Downtown is right-skewed while Suburban is roughly symmetric.

(c) For the Downtown data, sorted: 12,15,18,20,22,25,28,30,55. Q1 = median of the lower 4 values (12,15,18,20) = (15+18)/2 = 16.5. Q3 = median of the upper 4 values (25,28,30,55) = (28+30)/2 = 29. IQR = 29 - 16.5 = 12.5. Upper fence = Q3 + 1.5 x IQR = 29 + 18.75 = 47.75.

Since 55 > 47.75, the value of 55 minutes IS an outlier by the 1.5xIQR rule.

(d) The median is resistant to outliers and skew (it depends only on the rank of the middle value, not its magnitude), unlike the mean, which is pulled toward extreme values.

In context, Downtown''s outlier (the 55-minute commute) inflates the Downtown mean, making a mean-based comparison of "typical" commute time between the offices misleading -- the median gives a more accurate sense of what a typical commuter at each office actually experiences.' where id = '3ffe16de-35ff-46ed-ad96-6709fc159cd4';
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('3ffe16de-35ff-46ed-ad96-6709fc159cd4', 'canonical_answer_1', 1, '(a) Downtown (12,15,18,20,22,25,28,30,55): mean = (12+15+18+20+22+25+28+30+55)/9 = 225/9 = 25.0. With n=9, the median is the 5th value in the sorted list: 22.', ARRAY['part-a-criterion-01'], 'drafted', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('3ffe16de-35ff-46ed-ad96-6709fc159cd4', 'canonical_answer_1', 2, '

', ARRAY[]::text[], 'assembly_literal', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('3ffe16de-35ff-46ed-ad96-6709fc159cd4', 'canonical_answer_1', 3, 'Suburban (25,27,29,30,31,33,34,36,38): mean = (25+27+29+30+31+33+34+36+38)/9 = 283/9 ≈ 31.44. The median is the 5th value: 31.', ARRAY['part-a-criterion-02'], 'drafted', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('3ffe16de-35ff-46ed-ad96-6709fc159cd4', 'canonical_answer_1', 4, '

', ARRAY[]::text[], 'assembly_literal', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('3ffe16de-35ff-46ed-ad96-6709fc159cd4', 'canonical_answer_1', 5, '(b) Shape: the Downtown distribution is right-skewed (due to the 55-minute value pulling the upper tail out), while the Suburban distribution is fairly symmetric (evenly spread from 25 to 38 with no extreme values).', ARRAY['part-b-criterion-01'], 'drafted', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('3ffe16de-35ff-46ed-ad96-6709fc159cd4', 'canonical_answer_1', 6, '

', ARRAY[]::text[], 'assembly_literal', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('3ffe16de-35ff-46ed-ad96-6709fc159cd4', 'canonical_answer_1', 7, 'Center: the Suburban office has a higher typical commute time than Downtown (median 31 minutes vs. 22 minutes; mean 31.44 vs. 25.0).', ARRAY['part-b-criterion-02'], 'drafted', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('3ffe16de-35ff-46ed-ad96-6709fc159cd4', 'canonical_answer_1', 8, '

', ARRAY[]::text[], 'assembly_literal', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('3ffe16de-35ff-46ed-ad96-6709fc159cd4', 'canonical_answer_1', 9, 'Spread: the Downtown data has greater spread (range 55-12=43 vs. Suburban''s range 38-25=13), which is largely driven by the 55-minute outlier.', ARRAY['part-b-criterion-03'], 'drafted', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('3ffe16de-35ff-46ed-ad96-6709fc159cd4', 'canonical_answer_1', 10, '

', ARRAY[]::text[], 'assembly_literal', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('3ffe16de-35ff-46ed-ad96-6709fc159cd4', 'canonical_answer_1', 11, 'In summary: Suburban commute times are greater in typical value (higher median/mean) than Downtown, while Downtown commute times are more spread out (greater range) than Suburban, mainly due to Downtown''s high outlier; Downtown is right-skewed while Suburban is roughly symmetric.', ARRAY['part-b-criterion-04'], 'drafted', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('3ffe16de-35ff-46ed-ad96-6709fc159cd4', 'canonical_answer_1', 12, '

', ARRAY[]::text[], 'assembly_literal', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('3ffe16de-35ff-46ed-ad96-6709fc159cd4', 'canonical_answer_1', 13, '(c) For the Downtown data, sorted: 12,15,18,20,22,25,28,30,55. Q1 = median of the lower 4 values (12,15,18,20) = (15+18)/2 = 16.5. Q3 = median of the upper 4 values (25,28,30,55) = (28+30)/2 = 29. IQR = 29 - 16.5 = 12.5. Upper fence = Q3 + 1.5 x IQR = 29 + 18.75 = 47.75.', ARRAY['part-c-criterion-01'], 'drafted', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('3ffe16de-35ff-46ed-ad96-6709fc159cd4', 'canonical_answer_1', 14, '

', ARRAY[]::text[], 'assembly_literal', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('3ffe16de-35ff-46ed-ad96-6709fc159cd4', 'canonical_answer_1', 15, 'Since 55 > 47.75, the value of 55 minutes IS an outlier by the 1.5xIQR rule.', ARRAY['part-c-criterion-02'], 'drafted', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('3ffe16de-35ff-46ed-ad96-6709fc159cd4', 'canonical_answer_1', 16, '

', ARRAY[]::text[], 'assembly_literal', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('3ffe16de-35ff-46ed-ad96-6709fc159cd4', 'canonical_answer_1', 17, '(d) The median is resistant to outliers and skew (it depends only on the rank of the middle value, not its magnitude), unlike the mean, which is pulled toward extreme values.', ARRAY['part-d-criterion-01'], 'drafted', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('3ffe16de-35ff-46ed-ad96-6709fc159cd4', 'canonical_answer_1', 18, '

', ARRAY[]::text[], 'assembly_literal', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('3ffe16de-35ff-46ed-ad96-6709fc159cd4', 'canonical_answer_1', 19, 'In context, Downtown''s outlier (the 55-minute commute) inflates the Downtown mean, making a mean-based comparison of "typical" commute time between the offices misleading -- the median gives a more accurate sense of what a typical commuter at each office actually experiences.', ARRAY['part-d-criterion-02'], 'drafted', 'apstats_canonical_2026_09_25');

do $$
declare
  v_bad text;
begin
  select string_agg(civ.id::text, ', ') into v_bad
  from (values ('22897ba4-5b51-473d-a7dc-ea9012892f99'::uuid),('9a053602-a9d5-4a4a-a641-afb2d8fc9f11'::uuid),('3ffe16de-35ff-46ed-ad96-6709fc159cd4'::uuid)) as t(vid)
  join app.content_item_versions civ on civ.id = t.vid
  cross join lateral (
    select string_agg(cas.span_text, '' order by cas.span_ordinal) as concat
    from app.canonical_answer_spans cas
    where cas.content_item_version_id = civ.id and cas.answer_field = 'canonical_answer_1'
  ) agg
  where agg.concat is distinct from civ.canonical_answer_1;

  if v_bad is not null then
    raise exception 'span concatenation mismatch for version ids: %', v_bad;
  end if;
end $$;

commit;

begin;

-- apstats-frq-u12-013 (4b713cd8-0e04-477c-ac93-1cc73faf2315)
update app.content_item_versions set canonical_answer_1 = '(a) This is a convenience sample.

The sample was not randomly selected from the population of all city adults -- it consists only of whichever adults happened to walk by the manager during a specific time and place, distinguishing it from a simple random sample (SRS), where every adult in the city would have a known, equal chance of selection.

(b) One source of bias is tied to location: surveying people specifically outside a department store at a shopping mall oversamples people who are already out shopping in person.

This would likely bias the estimate downward (underestimate the true proportion who shop online weekly), since people who prefer or rely more on online shopping may be less likely to be found shopping in person at a physical mall.

A second, distinct source of bias is tied to timing: surveying only on a Tuesday afternoon excludes people who are working typical daytime jobs during that time.

This would likely also bias the estimate, potentially in either direction depending on the true relationship, but plausibly downward if employed adults (who have less free time for in-person shopping and might rely more on the convenience of online shopping) are systematically underrepresented in a weekday-afternoon sample taken outside a store.

(c) A better method would be to obtain a random sample of all city adults from a comprehensive list (for example, using registered voter rolls, utility records, or random-digit-dialing of phone numbers covering the whole city), or a stratified sample surveying across multiple locations and multiple days/times (not just one mall on one weekday afternoon).

This method includes an explicit random selection mechanism -- for example, randomly selecting names or numbers from the citywide list, rather than surveying whoever happens to be nearby.

This addresses the location bias because it does not depend on people already being present at a particular shopping location -- it reaches people regardless of whether they shop in person or shop online, and regardless of which part of the city they live in.

This addresses the time bias because sampling across multiple times/days (or using a method like phone/mail surveys that doesn''t require in-person presence at a specific hour) would include working adults and others who wouldn''t be captured by a single Tuesday-afternoon in-person survey.' where id = '4b713cd8-0e04-477c-ac93-1cc73faf2315';
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('4b713cd8-0e04-477c-ac93-1cc73faf2315', 'canonical_answer_1', 1, '(a) This is a convenience sample.', ARRAY['part-a-criterion-01'], 'drafted', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('4b713cd8-0e04-477c-ac93-1cc73faf2315', 'canonical_answer_1', 2, '

', ARRAY[]::text[], 'assembly_literal', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('4b713cd8-0e04-477c-ac93-1cc73faf2315', 'canonical_answer_1', 3, 'The sample was not randomly selected from the population of all city adults -- it consists only of whichever adults happened to walk by the manager during a specific time and place, distinguishing it from a simple random sample (SRS), where every adult in the city would have a known, equal chance of selection.', ARRAY['part-a-criterion-02'], 'drafted', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('4b713cd8-0e04-477c-ac93-1cc73faf2315', 'canonical_answer_1', 4, '

', ARRAY[]::text[], 'assembly_literal', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('4b713cd8-0e04-477c-ac93-1cc73faf2315', 'canonical_answer_1', 5, '(b) One source of bias is tied to location: surveying people specifically outside a department store at a shopping mall oversamples people who are already out shopping in person.', ARRAY['part-b-criterion-01'], 'drafted', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('4b713cd8-0e04-477c-ac93-1cc73faf2315', 'canonical_answer_1', 6, '

', ARRAY[]::text[], 'assembly_literal', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('4b713cd8-0e04-477c-ac93-1cc73faf2315', 'canonical_answer_1', 7, 'This would likely bias the estimate downward (underestimate the true proportion who shop online weekly), since people who prefer or rely more on online shopping may be less likely to be found shopping in person at a physical mall.', ARRAY['part-b-criterion-02'], 'drafted', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('4b713cd8-0e04-477c-ac93-1cc73faf2315', 'canonical_answer_1', 8, '

', ARRAY[]::text[], 'assembly_literal', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('4b713cd8-0e04-477c-ac93-1cc73faf2315', 'canonical_answer_1', 9, 'A second, distinct source of bias is tied to timing: surveying only on a Tuesday afternoon excludes people who are working typical daytime jobs during that time.', ARRAY['part-b-criterion-03'], 'drafted', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('4b713cd8-0e04-477c-ac93-1cc73faf2315', 'canonical_answer_1', 10, '

', ARRAY[]::text[], 'assembly_literal', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('4b713cd8-0e04-477c-ac93-1cc73faf2315', 'canonical_answer_1', 11, 'This would likely also bias the estimate, potentially in either direction depending on the true relationship, but plausibly downward if employed adults (who have less free time for in-person shopping and might rely more on the convenience of online shopping) are systematically underrepresented in a weekday-afternoon sample taken outside a store.', ARRAY['part-b-criterion-04'], 'drafted', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('4b713cd8-0e04-477c-ac93-1cc73faf2315', 'canonical_answer_1', 12, '

', ARRAY[]::text[], 'assembly_literal', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('4b713cd8-0e04-477c-ac93-1cc73faf2315', 'canonical_answer_1', 13, '(c) A better method would be to obtain a random sample of all city adults from a comprehensive list (for example, using registered voter rolls, utility records, or random-digit-dialing of phone numbers covering the whole city), or a stratified sample surveying across multiple locations and multiple days/times (not just one mall on one weekday afternoon).', ARRAY['part-c-criterion-01'], 'drafted', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('4b713cd8-0e04-477c-ac93-1cc73faf2315', 'canonical_answer_1', 14, '

', ARRAY[]::text[], 'assembly_literal', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('4b713cd8-0e04-477c-ac93-1cc73faf2315', 'canonical_answer_1', 15, 'This method includes an explicit random selection mechanism -- for example, randomly selecting names or numbers from the citywide list, rather than surveying whoever happens to be nearby.', ARRAY['part-c-criterion-02'], 'drafted', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('4b713cd8-0e04-477c-ac93-1cc73faf2315', 'canonical_answer_1', 16, '

', ARRAY[]::text[], 'assembly_literal', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('4b713cd8-0e04-477c-ac93-1cc73faf2315', 'canonical_answer_1', 17, 'This addresses the location bias because it does not depend on people already being present at a particular shopping location -- it reaches people regardless of whether they shop in person or shop online, and regardless of which part of the city they live in.', ARRAY['part-c-criterion-03'], 'drafted', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('4b713cd8-0e04-477c-ac93-1cc73faf2315', 'canonical_answer_1', 18, '

', ARRAY[]::text[], 'assembly_literal', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('4b713cd8-0e04-477c-ac93-1cc73faf2315', 'canonical_answer_1', 19, 'This addresses the time bias because sampling across multiple times/days (or using a method like phone/mail surveys that doesn''t require in-person presence at a specific hour) would include working adults and others who wouldn''t be captured by a single Tuesday-afternoon in-person survey.', ARRAY['part-c-criterion-04'], 'drafted', 'apstats_canonical_2026_09_25');

-- apstats-frq-u12-014 (f3b2730e-2ea9-4ab9-ad22-01566fa117e3)
update app.content_item_versions set canonical_answer_1 = '(a) Since the player makes 40% of free kicks, assign digits 0, 1, 2, 3 (4 out of the 10 digits, i.e. 40%) to represent a "made" free kick, and digits 4, 5, 6, 7, 8, 9 (the remaining 6 digits, 60%) to represent a "missed" free kick.

Each trial uses 5 random digits, one for each of the 5 simulated free-kick attempts.

For each trial, count how many of the 5 digits fall in the "made" group (0-3), and record whether that count is at least 2 (a "success" for this trial) or not.

Repeat this process for many trials (for example, 50 or more), and estimate the probability of making at least 2 of 5 free kicks as the proportion of trials in which the count of makes was at least 2.

(b) Trial 1 (3 8 1 4 6): digits 3 and 1 are in the "made" range (0-3); digits 8, 4, 6 are "missed." That''s 2 makes out of 5, which counts as a success (at least 2 makes).

Trial 2 (7 2 0 9 5): digits 2 and 0 are "made"; digits 7, 9, 5 are "missed." That''s 2 makes out of 5, a success.

Trial 3 (4 4 2 1 3): digits 2, 1, and 3 are "made"; digits 4 and 4 are "missed." That''s 3 makes out of 5, a success.

(c) The estimated probability is 27/50 = 0.54.

This means the estimated probability that the player makes at least 2 of her next 5 free kicks is about 54%.

This is a simulation-based estimate, not an exact theoretical probability -- it is based on a finite number of simulated trials (50) and would be expected to vary somewhat (though converge closer to the true probability) if a different or larger set of trials were simulated.' where id = 'f3b2730e-2ea9-4ab9-ad22-01566fa117e3';
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('f3b2730e-2ea9-4ab9-ad22-01566fa117e3', 'canonical_answer_1', 1, '(a) Since the player makes 40% of free kicks, assign digits 0, 1, 2, 3 (4 out of the 10 digits, i.e. 40%) to represent a "made" free kick, and digits 4, 5, 6, 7, 8, 9 (the remaining 6 digits, 60%) to represent a "missed" free kick.', ARRAY['part-a-criterion-01'], 'drafted', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('f3b2730e-2ea9-4ab9-ad22-01566fa117e3', 'canonical_answer_1', 2, '

', ARRAY[]::text[], 'assembly_literal', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('f3b2730e-2ea9-4ab9-ad22-01566fa117e3', 'canonical_answer_1', 3, 'Each trial uses 5 random digits, one for each of the 5 simulated free-kick attempts.', ARRAY['part-a-criterion-02'], 'drafted', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('f3b2730e-2ea9-4ab9-ad22-01566fa117e3', 'canonical_answer_1', 4, '

', ARRAY[]::text[], 'assembly_literal', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('f3b2730e-2ea9-4ab9-ad22-01566fa117e3', 'canonical_answer_1', 5, 'For each trial, count how many of the 5 digits fall in the "made" group (0-3), and record whether that count is at least 2 (a "success" for this trial) or not.', ARRAY['part-a-criterion-03'], 'drafted', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('f3b2730e-2ea9-4ab9-ad22-01566fa117e3', 'canonical_answer_1', 6, '

', ARRAY[]::text[], 'assembly_literal', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('f3b2730e-2ea9-4ab9-ad22-01566fa117e3', 'canonical_answer_1', 7, 'Repeat this process for many trials (for example, 50 or more), and estimate the probability of making at least 2 of 5 free kicks as the proportion of trials in which the count of makes was at least 2.', ARRAY['part-a-criterion-04'], 'drafted', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('f3b2730e-2ea9-4ab9-ad22-01566fa117e3', 'canonical_answer_1', 8, '

', ARRAY[]::text[], 'assembly_literal', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('f3b2730e-2ea9-4ab9-ad22-01566fa117e3', 'canonical_answer_1', 9, '(b) Trial 1 (3 8 1 4 6): digits 3 and 1 are in the "made" range (0-3); digits 8, 4, 6 are "missed." That''s 2 makes out of 5, which counts as a success (at least 2 makes).', ARRAY['part-b-criterion-01'], 'drafted', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('f3b2730e-2ea9-4ab9-ad22-01566fa117e3', 'canonical_answer_1', 10, '

', ARRAY[]::text[], 'assembly_literal', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('f3b2730e-2ea9-4ab9-ad22-01566fa117e3', 'canonical_answer_1', 11, 'Trial 2 (7 2 0 9 5): digits 2 and 0 are "made"; digits 7, 9, 5 are "missed." That''s 2 makes out of 5, a success.', ARRAY['part-b-criterion-02'], 'drafted', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('f3b2730e-2ea9-4ab9-ad22-01566fa117e3', 'canonical_answer_1', 12, '

', ARRAY[]::text[], 'assembly_literal', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('f3b2730e-2ea9-4ab9-ad22-01566fa117e3', 'canonical_answer_1', 13, 'Trial 3 (4 4 2 1 3): digits 2, 1, and 3 are "made"; digits 4 and 4 are "missed." That''s 3 makes out of 5, a success.', ARRAY['part-b-criterion-03'], 'drafted', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('f3b2730e-2ea9-4ab9-ad22-01566fa117e3', 'canonical_answer_1', 14, '

', ARRAY[]::text[], 'assembly_literal', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('f3b2730e-2ea9-4ab9-ad22-01566fa117e3', 'canonical_answer_1', 15, '(c) The estimated probability is 27/50 = 0.54.', ARRAY['part-c-criterion-01'], 'drafted', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('f3b2730e-2ea9-4ab9-ad22-01566fa117e3', 'canonical_answer_1', 16, '

', ARRAY[]::text[], 'assembly_literal', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('f3b2730e-2ea9-4ab9-ad22-01566fa117e3', 'canonical_answer_1', 17, 'This means the estimated probability that the player makes at least 2 of her next 5 free kicks is about 54%.', ARRAY['part-c-criterion-02'], 'drafted', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('f3b2730e-2ea9-4ab9-ad22-01566fa117e3', 'canonical_answer_1', 18, '

', ARRAY[]::text[], 'assembly_literal', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('f3b2730e-2ea9-4ab9-ad22-01566fa117e3', 'canonical_answer_1', 19, 'This is a simulation-based estimate, not an exact theoretical probability -- it is based on a finite number of simulated trials (50) and would be expected to vary somewhat (though converge closer to the true probability) if a different or larger set of trials were simulated.', ARRAY['part-c-criterion-03'], 'drafted', 'apstats_canonical_2026_09_25');

-- apstats-frq-u12-015 (0838c759-dc87-4acf-ac86-06057344b531)
update app.content_item_versions set canonical_answer_1 = '(a) Since S and B can occur together (P(S and B) = 0.05, not zero), the general addition rule is needed, which subtracts the overlap to avoid double-counting: P(S or B) = P(S) + P(B) - P(S and B).

P(S or B) = 0.20 + 0.15 - 0.05 = 0.30.

(b) S and B are NOT mutually exclusive.

This is justified because P(S and B) = 0.05, which is not equal to 0 -- if the events were mutually exclusive, they could never occur together, meaning P(S and B) would have to be exactly 0.

In context, this makes sense: some laptops genuinely need both a screen repair and a battery repair, so the two events can and do occur together for the same laptop.

(c) S and B are NOT independent.

If S and B were independent, we would expect P(S and B) = P(S) x P(B) = 0.20 x 0.15 = 0.03. The actual given value is P(S and B) = 0.05.

Since 0.03 does not equal 0.05, the events are not independent -- needing a screen repair is associated with (makes it somewhat more likely to also need) a battery repair, beyond what would be expected if the two needs were unrelated.

(d) This calls for the conditional probability formula: P(B | S) = P(S and B) / P(S).

P(B | S) = 0.05 / 0.20 = 0.25.' where id = '0838c759-dc87-4acf-ac86-06057344b531';
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('0838c759-dc87-4acf-ac86-06057344b531', 'canonical_answer_1', 1, '(a) Since S and B can occur together (P(S and B) = 0.05, not zero), the general addition rule is needed, which subtracts the overlap to avoid double-counting: P(S or B) = P(S) + P(B) - P(S and B).', ARRAY['part-a-criterion-01'], 'drafted', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('0838c759-dc87-4acf-ac86-06057344b531', 'canonical_answer_1', 2, '

', ARRAY[]::text[], 'assembly_literal', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('0838c759-dc87-4acf-ac86-06057344b531', 'canonical_answer_1', 3, 'P(S or B) = 0.20 + 0.15 - 0.05 = 0.30.', ARRAY['part-a-criterion-02'], 'drafted', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('0838c759-dc87-4acf-ac86-06057344b531', 'canonical_answer_1', 4, '

', ARRAY[]::text[], 'assembly_literal', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('0838c759-dc87-4acf-ac86-06057344b531', 'canonical_answer_1', 5, '(b) S and B are NOT mutually exclusive.', ARRAY['part-b-criterion-01'], 'drafted', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('0838c759-dc87-4acf-ac86-06057344b531', 'canonical_answer_1', 6, '

', ARRAY[]::text[], 'assembly_literal', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('0838c759-dc87-4acf-ac86-06057344b531', 'canonical_answer_1', 7, 'This is justified because P(S and B) = 0.05, which is not equal to 0 -- if the events were mutually exclusive, they could never occur together, meaning P(S and B) would have to be exactly 0.', ARRAY['part-b-criterion-02'], 'drafted', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('0838c759-dc87-4acf-ac86-06057344b531', 'canonical_answer_1', 8, '

', ARRAY[]::text[], 'assembly_literal', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('0838c759-dc87-4acf-ac86-06057344b531', 'canonical_answer_1', 9, 'In context, this makes sense: some laptops genuinely need both a screen repair and a battery repair, so the two events can and do occur together for the same laptop.', ARRAY['part-b-criterion-03'], 'drafted', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('0838c759-dc87-4acf-ac86-06057344b531', 'canonical_answer_1', 10, '

', ARRAY[]::text[], 'assembly_literal', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('0838c759-dc87-4acf-ac86-06057344b531', 'canonical_answer_1', 11, '(c) S and B are NOT independent.', ARRAY['part-c-criterion-01'], 'drafted', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('0838c759-dc87-4acf-ac86-06057344b531', 'canonical_answer_1', 12, '

', ARRAY[]::text[], 'assembly_literal', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('0838c759-dc87-4acf-ac86-06057344b531', 'canonical_answer_1', 13, 'If S and B were independent, we would expect P(S and B) = P(S) x P(B) = 0.20 x 0.15 = 0.03. The actual given value is P(S and B) = 0.05.', ARRAY['part-c-criterion-02'], 'drafted', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('0838c759-dc87-4acf-ac86-06057344b531', 'canonical_answer_1', 14, '

', ARRAY[]::text[], 'assembly_literal', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('0838c759-dc87-4acf-ac86-06057344b531', 'canonical_answer_1', 15, 'Since 0.03 does not equal 0.05, the events are not independent -- needing a screen repair is associated with (makes it somewhat more likely to also need) a battery repair, beyond what would be expected if the two needs were unrelated.', ARRAY['part-c-criterion-03'], 'drafted', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('0838c759-dc87-4acf-ac86-06057344b531', 'canonical_answer_1', 16, '

', ARRAY[]::text[], 'assembly_literal', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('0838c759-dc87-4acf-ac86-06057344b531', 'canonical_answer_1', 17, '(d) This calls for the conditional probability formula: P(B | S) = P(S and B) / P(S).', ARRAY['part-d-criterion-01'], 'drafted', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('0838c759-dc87-4acf-ac86-06057344b531', 'canonical_answer_1', 18, '

', ARRAY[]::text[], 'assembly_literal', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('0838c759-dc87-4acf-ac86-06057344b531', 'canonical_answer_1', 19, 'P(B | S) = 0.05 / 0.20 = 0.25.', ARRAY['part-d-criterion-02'], 'drafted', 'apstats_canonical_2026_09_25');

do $$
declare
  v_bad text;
begin
  select string_agg(civ.id::text, ', ') into v_bad
  from (values ('4b713cd8-0e04-477c-ac93-1cc73faf2315'::uuid),('f3b2730e-2ea9-4ab9-ad22-01566fa117e3'::uuid),('0838c759-dc87-4acf-ac86-06057344b531'::uuid)) as t(vid)
  join app.content_item_versions civ on civ.id = t.vid
  cross join lateral (
    select string_agg(cas.span_text, '' order by cas.span_ordinal) as concat
    from app.canonical_answer_spans cas
    where cas.content_item_version_id = civ.id and cas.answer_field = 'canonical_answer_1'
  ) agg
  where agg.concat is distinct from civ.canonical_answer_1;

  if v_bad is not null then
    raise exception 'span concatenation mismatch for version ids: %', v_bad;
  end if;
end $$;

commit;

begin;

-- apstats-frq-u12-016 (c41a14bc-0ecb-42a3-ac92-4837389d9ac5)
update app.content_item_versions set canonical_answer_1 = '(a) The two possible payout values are Y = $20,000 (if a covered claim is filed) and Y = $0 (if not).

The corresponding probabilities are P(Y=20000) = 0.02 and P(Y=0) = 1 - 0.02 = 0.98.

(b) E(Y) = 20000(0.02) + 0(0.98) = 400.

The company''s expected profit per policy is the revenue from the policy minus the expected payout: profit = 500 - E(Y).

Expected profit = 500 - 400 = $100 per policy.

(c) E(Y²) = 20000²(0.02) + 0²(0.98) = 400,000,000 x 0.02 = 8,000,000.

Variance = E(Y²) - [E(Y)]² = 8,000,000 - 400² = 8,000,000 - 160,000 = 7,840,000.

Standard deviation = sqrt(7,840,000) ≈ $2,800.

(d) The insurance company sells many policies to a large number of independent policyholders, so by the law of large numbers, the average payout per policy across all its policyholders will be very close to the expected value E(Y) = $400.

This is in contrast to a single policyholder, whose actual individual outcome (either $0 or $20,000) could differ enormously from the expected value -- the expected value only becomes a reliable predictor when averaged over many independent policies, which is exactly the company''s situation but not an individual customer''s.' where id = 'c41a14bc-0ecb-42a3-ac92-4837389d9ac5';
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('c41a14bc-0ecb-42a3-ac92-4837389d9ac5', 'canonical_answer_1', 1, '(a) The two possible payout values are Y = $20,000 (if a covered claim is filed) and Y = $0 (if not).', ARRAY['part-a-criterion-01'], 'drafted', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('c41a14bc-0ecb-42a3-ac92-4837389d9ac5', 'canonical_answer_1', 2, '

', ARRAY[]::text[], 'assembly_literal', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('c41a14bc-0ecb-42a3-ac92-4837389d9ac5', 'canonical_answer_1', 3, 'The corresponding probabilities are P(Y=20000) = 0.02 and P(Y=0) = 1 - 0.02 = 0.98.', ARRAY['part-a-criterion-02'], 'drafted', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('c41a14bc-0ecb-42a3-ac92-4837389d9ac5', 'canonical_answer_1', 4, '

', ARRAY[]::text[], 'assembly_literal', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('c41a14bc-0ecb-42a3-ac92-4837389d9ac5', 'canonical_answer_1', 5, '(b) E(Y) = 20000(0.02) + 0(0.98) = 400.', ARRAY['part-b-criterion-01'], 'drafted', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('c41a14bc-0ecb-42a3-ac92-4837389d9ac5', 'canonical_answer_1', 6, '

', ARRAY[]::text[], 'assembly_literal', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('c41a14bc-0ecb-42a3-ac92-4837389d9ac5', 'canonical_answer_1', 7, 'The company''s expected profit per policy is the revenue from the policy minus the expected payout: profit = 500 - E(Y).', ARRAY['part-b-criterion-02'], 'drafted', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('c41a14bc-0ecb-42a3-ac92-4837389d9ac5', 'canonical_answer_1', 8, '

', ARRAY[]::text[], 'assembly_literal', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('c41a14bc-0ecb-42a3-ac92-4837389d9ac5', 'canonical_answer_1', 9, 'Expected profit = 500 - 400 = $100 per policy.', ARRAY['part-b-criterion-03'], 'drafted', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('c41a14bc-0ecb-42a3-ac92-4837389d9ac5', 'canonical_answer_1', 10, '

', ARRAY[]::text[], 'assembly_literal', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('c41a14bc-0ecb-42a3-ac92-4837389d9ac5', 'canonical_answer_1', 11, '(c) E(Y²) = 20000²(0.02) + 0²(0.98) = 400,000,000 x 0.02 = 8,000,000.', ARRAY['part-c-criterion-01'], 'drafted', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('c41a14bc-0ecb-42a3-ac92-4837389d9ac5', 'canonical_answer_1', 12, '

', ARRAY[]::text[], 'assembly_literal', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('c41a14bc-0ecb-42a3-ac92-4837389d9ac5', 'canonical_answer_1', 13, 'Variance = E(Y²) - [E(Y)]² = 8,000,000 - 400² = 8,000,000 - 160,000 = 7,840,000.', ARRAY['part-c-criterion-02'], 'drafted', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('c41a14bc-0ecb-42a3-ac92-4837389d9ac5', 'canonical_answer_1', 14, '

', ARRAY[]::text[], 'assembly_literal', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('c41a14bc-0ecb-42a3-ac92-4837389d9ac5', 'canonical_answer_1', 15, 'Standard deviation = sqrt(7,840,000) ≈ $2,800.', ARRAY['part-c-criterion-03'], 'drafted', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('c41a14bc-0ecb-42a3-ac92-4837389d9ac5', 'canonical_answer_1', 16, '

', ARRAY[]::text[], 'assembly_literal', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('c41a14bc-0ecb-42a3-ac92-4837389d9ac5', 'canonical_answer_1', 17, '(d) The insurance company sells many policies to a large number of independent policyholders, so by the law of large numbers, the average payout per policy across all its policyholders will be very close to the expected value E(Y) = $400.', ARRAY['part-d-criterion-01'], 'drafted', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('c41a14bc-0ecb-42a3-ac92-4837389d9ac5', 'canonical_answer_1', 18, '

', ARRAY[]::text[], 'assembly_literal', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('c41a14bc-0ecb-42a3-ac92-4837389d9ac5', 'canonical_answer_1', 19, 'This is in contrast to a single policyholder, whose actual individual outcome (either $0 or $20,000) could differ enormously from the expected value -- the expected value only becomes a reliable predictor when averaged over many independent policies, which is exactly the company''s situation but not an individual customer''s.', ARRAY['part-d-criterion-02'], 'drafted', 'apstats_canonical_2026_09_25');

-- apstats-frq-u12-017 (3de3974f-38ba-408d-abe6-69de5d0eff8c)
update app.content_item_versions set canonical_answer_1 = '(a) Transportation mode (Car, Bus, Bike, Walk) is a categorical variable -- it places commuters into named groups.

The distance-from-downtown grouping is also categorical as it is recorded here -- even though distance is fundamentally a quantitative measurement, in this survey it has been binned into two named categories ("within 3 miles" and "farther than 3 miles"), which is how it is actually recorded and analyzed in this table.

(b) The conditional distribution for commuters within 3 miles is found by dividing each mode''s count by the column total of 100: Car = 40/100 = 0.40, Bus = 20/100 = 0.20, Bike = 25/100 = 0.25, Walk = 15/100 = 0.15.

Each value is computed by dividing the cell count by the column total (100 for the "within 3 miles" group).

These proportions sum to 1.00 (0.40+0.20+0.25+0.15=1.00), confirming internal consistency.

(c) A segmented bar graph shows two bars -- one for "within 3 miles," one for "farther than 3 miles" -- each with a total height of 100% (or 1), divided into four segments representing Car, Bus, Bike, and Walk in their correct relative proportions for that distance group.

The segments within each bar are ordered consistently (e.g., Car, Bus, Bike, Walk from bottom to top in both bars), with a legend identifying which segment corresponds to which transportation mode.

Both axes are labeled (distance group on the horizontal axis, percentage/proportion on the vertical axis), and the graph has a title.

(d) There is a substantial contrast between the two distance groups: car use is much higher for commuters farther than 3 miles from downtown (110/150 ≈ 73.3%) than for those within 3 miles (40/100 = 40%), while bike and walk usage combined is much higher within 3 miles (25+15=40, or 40%) than farther away ((5+5)/150 ≈ 6.7%).

This substantial difference between the conditional distributions indicates there does appear to be an association between distance from downtown and transportation mode -- commuters closer to downtown are far more likely to bike or walk, while those farther away rely much more heavily on cars.' where id = '3de3974f-38ba-408d-abe6-69de5d0eff8c';
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('3de3974f-38ba-408d-abe6-69de5d0eff8c', 'canonical_answer_1', 1, '(a) Transportation mode (Car, Bus, Bike, Walk) is a categorical variable -- it places commuters into named groups.', ARRAY['part-a-criterion-01'], 'drafted', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('3de3974f-38ba-408d-abe6-69de5d0eff8c', 'canonical_answer_1', 2, '

', ARRAY[]::text[], 'assembly_literal', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('3de3974f-38ba-408d-abe6-69de5d0eff8c', 'canonical_answer_1', 3, 'The distance-from-downtown grouping is also categorical as it is recorded here -- even though distance is fundamentally a quantitative measurement, in this survey it has been binned into two named categories ("within 3 miles" and "farther than 3 miles"), which is how it is actually recorded and analyzed in this table.', ARRAY['part-a-criterion-02'], 'drafted', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('3de3974f-38ba-408d-abe6-69de5d0eff8c', 'canonical_answer_1', 4, '

', ARRAY[]::text[], 'assembly_literal', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('3de3974f-38ba-408d-abe6-69de5d0eff8c', 'canonical_answer_1', 5, '(b) The conditional distribution for commuters within 3 miles is found by dividing each mode''s count by the column total of 100: Car = 40/100 = 0.40, Bus = 20/100 = 0.20, Bike = 25/100 = 0.25, Walk = 15/100 = 0.15.', ARRAY['part-b-criterion-01'], 'drafted', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('3de3974f-38ba-408d-abe6-69de5d0eff8c', 'canonical_answer_1', 6, '

', ARRAY[]::text[], 'assembly_literal', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('3de3974f-38ba-408d-abe6-69de5d0eff8c', 'canonical_answer_1', 7, 'Each value is computed by dividing the cell count by the column total (100 for the "within 3 miles" group).', ARRAY['part-b-criterion-02'], 'drafted', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('3de3974f-38ba-408d-abe6-69de5d0eff8c', 'canonical_answer_1', 8, '

', ARRAY[]::text[], 'assembly_literal', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('3de3974f-38ba-408d-abe6-69de5d0eff8c', 'canonical_answer_1', 9, 'These proportions sum to 1.00 (0.40+0.20+0.25+0.15=1.00), confirming internal consistency.', ARRAY['part-b-criterion-03'], 'drafted', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('3de3974f-38ba-408d-abe6-69de5d0eff8c', 'canonical_answer_1', 10, '

', ARRAY[]::text[], 'assembly_literal', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('3de3974f-38ba-408d-abe6-69de5d0eff8c', 'canonical_answer_1', 11, '(c) A segmented bar graph shows two bars -- one for "within 3 miles," one for "farther than 3 miles" -- each with a total height of 100% (or 1), divided into four segments representing Car, Bus, Bike, and Walk in their correct relative proportions for that distance group.', ARRAY['part-c-criterion-01'], 'drafted', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('3de3974f-38ba-408d-abe6-69de5d0eff8c', 'canonical_answer_1', 12, '

', ARRAY[]::text[], 'assembly_literal', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('3de3974f-38ba-408d-abe6-69de5d0eff8c', 'canonical_answer_1', 13, 'The segments within each bar are ordered consistently (e.g., Car, Bus, Bike, Walk from bottom to top in both bars), with a legend identifying which segment corresponds to which transportation mode.', ARRAY['part-c-criterion-02'], 'drafted', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('3de3974f-38ba-408d-abe6-69de5d0eff8c', 'canonical_answer_1', 14, '

', ARRAY[]::text[], 'assembly_literal', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('3de3974f-38ba-408d-abe6-69de5d0eff8c', 'canonical_answer_1', 15, 'Both axes are labeled (distance group on the horizontal axis, percentage/proportion on the vertical axis), and the graph has a title.', ARRAY['part-c-criterion-03'], 'drafted', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('3de3974f-38ba-408d-abe6-69de5d0eff8c', 'canonical_answer_1', 16, '

', ARRAY[]::text[], 'assembly_literal', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('3de3974f-38ba-408d-abe6-69de5d0eff8c', 'canonical_answer_1', 17, '(d) There is a substantial contrast between the two distance groups: car use is much higher for commuters farther than 3 miles from downtown (110/150 ≈ 73.3%) than for those within 3 miles (40/100 = 40%), while bike and walk usage combined is much higher within 3 miles (25+15=40, or 40%) than farther away ((5+5)/150 ≈ 6.7%).', ARRAY['part-d-criterion-01'], 'drafted', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('3de3974f-38ba-408d-abe6-69de5d0eff8c', 'canonical_answer_1', 18, '

', ARRAY[]::text[], 'assembly_literal', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('3de3974f-38ba-408d-abe6-69de5d0eff8c', 'canonical_answer_1', 19, 'This substantial difference between the conditional distributions indicates there does appear to be an association between distance from downtown and transportation mode -- commuters closer to downtown are far more likely to bike or walk, while those farther away rely much more heavily on cars.', ARRAY['part-d-criterion-02'], 'drafted', 'apstats_canonical_2026_09_25');

-- apstats-frq-u12-018 (a115bde8-0657-4607-aa4a-4a46ed141af3)
update app.content_item_versions set canonical_answer_1 = '(a) The first-level branches of the tree diagram show P(Machine A) = 0.50, P(Machine B) = 0.30, P(Machine C) = 0.20.

The second-level branches show the conditional probability of a defect from each machine: P(defective | A) = 0.02, P(defective | B) = 0.05, P(defective | C) = 0.08 (with the complementary "not defective" branches at 0.98, 0.95, and 0.92 respectively).

This gives six joint outcome paths in total: (A, defective), (A, not defective), (B, defective), (B, not defective), (C, defective), (C, not defective).

(b) By the law of total probability, the overall probability of a defective board is the sum of the joint probabilities across all three machines.

The individual joint probabilities are: P(A and defective) = 0.50 x 0.02 = 0.01; P(B and defective) = 0.30 x 0.05 = 0.015; P(C and defective) = 0.20 x 0.08 = 0.016.

P(defective) = 0.01 + 0.015 + 0.016 = 0.041.

(c) This calls for a Bayes''-type ratio: P(C | defective) = P(C and defective) / P(defective).

Using the values from parts (a) and (b): P(C | defective) = 0.016 / 0.041.

P(C | defective) ≈ 0.390, or about 39.0%.

(d) The events "produced by Machine C" and "is defective" are NOT independent, since P(defective | C) = 0.08 is different from the overall (unconditional) probability P(defective) = 0.041 found in part (b) -- if the events were independent, these two values would be equal, but a board from Machine C is nearly twice as likely to be defective as a randomly selected board overall.' where id = 'a115bde8-0657-4607-aa4a-4a46ed141af3';
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('a115bde8-0657-4607-aa4a-4a46ed141af3', 'canonical_answer_1', 1, '(a) The first-level branches of the tree diagram show P(Machine A) = 0.50, P(Machine B) = 0.30, P(Machine C) = 0.20.', ARRAY['part-a-criterion-01'], 'drafted', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('a115bde8-0657-4607-aa4a-4a46ed141af3', 'canonical_answer_1', 2, '

', ARRAY[]::text[], 'assembly_literal', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('a115bde8-0657-4607-aa4a-4a46ed141af3', 'canonical_answer_1', 3, 'The second-level branches show the conditional probability of a defect from each machine: P(defective | A) = 0.02, P(defective | B) = 0.05, P(defective | C) = 0.08 (with the complementary "not defective" branches at 0.98, 0.95, and 0.92 respectively).', ARRAY['part-a-criterion-02'], 'drafted', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('a115bde8-0657-4607-aa4a-4a46ed141af3', 'canonical_answer_1', 4, '

', ARRAY[]::text[], 'assembly_literal', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('a115bde8-0657-4607-aa4a-4a46ed141af3', 'canonical_answer_1', 5, 'This gives six joint outcome paths in total: (A, defective), (A, not defective), (B, defective), (B, not defective), (C, defective), (C, not defective).', ARRAY['part-a-criterion-03'], 'drafted', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('a115bde8-0657-4607-aa4a-4a46ed141af3', 'canonical_answer_1', 6, '

', ARRAY[]::text[], 'assembly_literal', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('a115bde8-0657-4607-aa4a-4a46ed141af3', 'canonical_answer_1', 7, '(b) By the law of total probability, the overall probability of a defective board is the sum of the joint probabilities across all three machines.', ARRAY['part-b-criterion-01'], 'drafted', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('a115bde8-0657-4607-aa4a-4a46ed141af3', 'canonical_answer_1', 8, '

', ARRAY[]::text[], 'assembly_literal', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('a115bde8-0657-4607-aa4a-4a46ed141af3', 'canonical_answer_1', 9, 'The individual joint probabilities are: P(A and defective) = 0.50 x 0.02 = 0.01; P(B and defective) = 0.30 x 0.05 = 0.015; P(C and defective) = 0.20 x 0.08 = 0.016.', ARRAY['part-b-criterion-02'], 'drafted', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('a115bde8-0657-4607-aa4a-4a46ed141af3', 'canonical_answer_1', 10, '

', ARRAY[]::text[], 'assembly_literal', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('a115bde8-0657-4607-aa4a-4a46ed141af3', 'canonical_answer_1', 11, 'P(defective) = 0.01 + 0.015 + 0.016 = 0.041.', ARRAY['part-b-criterion-03'], 'drafted', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('a115bde8-0657-4607-aa4a-4a46ed141af3', 'canonical_answer_1', 12, '

', ARRAY[]::text[], 'assembly_literal', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('a115bde8-0657-4607-aa4a-4a46ed141af3', 'canonical_answer_1', 13, '(c) This calls for a Bayes''-type ratio: P(C | defective) = P(C and defective) / P(defective).', ARRAY['part-c-criterion-01'], 'drafted', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('a115bde8-0657-4607-aa4a-4a46ed141af3', 'canonical_answer_1', 14, '

', ARRAY[]::text[], 'assembly_literal', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('a115bde8-0657-4607-aa4a-4a46ed141af3', 'canonical_answer_1', 15, 'Using the values from parts (a) and (b): P(C | defective) = 0.016 / 0.041.', ARRAY['part-c-criterion-02'], 'drafted', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('a115bde8-0657-4607-aa4a-4a46ed141af3', 'canonical_answer_1', 16, '

', ARRAY[]::text[], 'assembly_literal', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('a115bde8-0657-4607-aa4a-4a46ed141af3', 'canonical_answer_1', 17, 'P(C | defective) ≈ 0.390, or about 39.0%.', ARRAY['part-c-criterion-03'], 'drafted', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('a115bde8-0657-4607-aa4a-4a46ed141af3', 'canonical_answer_1', 18, '

', ARRAY[]::text[], 'assembly_literal', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('a115bde8-0657-4607-aa4a-4a46ed141af3', 'canonical_answer_1', 19, '(d) The events "produced by Machine C" and "is defective" are NOT independent, since P(defective | C) = 0.08 is different from the overall (unconditional) probability P(defective) = 0.041 found in part (b) -- if the events were independent, these two values would be equal, but a board from Machine C is nearly twice as likely to be defective as a randomly selected board overall.', ARRAY['part-d-criterion-01'], 'drafted', 'apstats_canonical_2026_09_25');

do $$
declare
  v_bad text;
begin
  select string_agg(civ.id::text, ', ') into v_bad
  from (values ('c41a14bc-0ecb-42a3-ac92-4837389d9ac5'::uuid),('3de3974f-38ba-408d-abe6-69de5d0eff8c'::uuid),('a115bde8-0657-4607-aa4a-4a46ed141af3'::uuid)) as t(vid)
  join app.content_item_versions civ on civ.id = t.vid
  cross join lateral (
    select string_agg(cas.span_text, '' order by cas.span_ordinal) as concat
    from app.canonical_answer_spans cas
    where cas.content_item_version_id = civ.id and cas.answer_field = 'canonical_answer_1'
  ) agg
  where agg.concat is distinct from civ.canonical_answer_1;

  if v_bad is not null then
    raise exception 'span concatenation mismatch for version ids: %', v_bad;
  end if;
end $$;

commit;

begin;

-- apstats-frq-u12-019 (1147fd77-60f7-4fb4-a485-e0100e05c21f)
update app.content_item_versions set canonical_answer_1 = '(a) Assuming p=0.06 is correct, the mean of X (number of defective bulbs in 200) is mu = np = 200 x 0.06 = 12.

The standard deviation is sigma = sqrt(np(1-p)) = sqrt(200 x 0.06 x 0.94) = sqrt(11.28) ≈ 3.359.

(b) The large counts condition requires both np ≥ 10 and n(1-p) ≥ 10: here np = 12 and n(1-p) = 200 x 0.94 = 188.

Since both 12 and 188 are at least 10, the large counts condition is satisfied, so the distribution of X can be approximated as approximately Normal.

(c) Using the Normal approximation with mean 12 and SD ≈ 3.359 from part (a):

Since X is a discrete count being approximated by a continuous Normal distribution, a continuity correction is applied: "more than 18" is approximated using the boundary 18.5.

z = (18.5 - 12)/3.359 = 6.5/3.359 ≈ 1.935.

P(X > 18) ≈ P(Z > 1.935) ≈ 1 - 0.9735 = 0.0265, or about 2.65%.

(d) 22 defective bulbs is far above the assumed mean of 12 -- roughly (22-12)/3.359 ≈ 2.98, about 3 standard deviations above the mean -- which corresponds to a very small probability of occurring under the claimed 6% defect rate.

Because an outcome this extreme would be quite rare if the true defect rate really were 6%, observing 22 defective bulbs provides evidence (reasoning informally from how unlikely such a result would be under the stated model) that the true defect rate may actually be higher than the manufacturer''s claimed 6%.' where id = '1147fd77-60f7-4fb4-a485-e0100e05c21f';
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('1147fd77-60f7-4fb4-a485-e0100e05c21f', 'canonical_answer_1', 1, '(a) Assuming p=0.06 is correct, the mean of X (number of defective bulbs in 200) is mu = np = 200 x 0.06 = 12.', ARRAY['part-a-criterion-01'], 'drafted', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('1147fd77-60f7-4fb4-a485-e0100e05c21f', 'canonical_answer_1', 2, '

', ARRAY[]::text[], 'assembly_literal', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('1147fd77-60f7-4fb4-a485-e0100e05c21f', 'canonical_answer_1', 3, 'The standard deviation is sigma = sqrt(np(1-p)) = sqrt(200 x 0.06 x 0.94) = sqrt(11.28) ≈ 3.359.', ARRAY['part-a-criterion-02'], 'drafted', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('1147fd77-60f7-4fb4-a485-e0100e05c21f', 'canonical_answer_1', 4, '

', ARRAY[]::text[], 'assembly_literal', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('1147fd77-60f7-4fb4-a485-e0100e05c21f', 'canonical_answer_1', 5, '(b) The large counts condition requires both np ≥ 10 and n(1-p) ≥ 10: here np = 12 and n(1-p) = 200 x 0.94 = 188.', ARRAY['part-b-criterion-01'], 'drafted', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('1147fd77-60f7-4fb4-a485-e0100e05c21f', 'canonical_answer_1', 6, '

', ARRAY[]::text[], 'assembly_literal', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('1147fd77-60f7-4fb4-a485-e0100e05c21f', 'canonical_answer_1', 7, 'Since both 12 and 188 are at least 10, the large counts condition is satisfied, so the distribution of X can be approximated as approximately Normal.', ARRAY['part-b-criterion-02'], 'drafted', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('1147fd77-60f7-4fb4-a485-e0100e05c21f', 'canonical_answer_1', 8, '

', ARRAY[]::text[], 'assembly_literal', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('1147fd77-60f7-4fb4-a485-e0100e05c21f', 'canonical_answer_1', 9, '(c) Using the Normal approximation with mean 12 and SD ≈ 3.359 from part (a):', ARRAY['part-c-criterion-01'], 'drafted', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('1147fd77-60f7-4fb4-a485-e0100e05c21f', 'canonical_answer_1', 10, '

', ARRAY[]::text[], 'assembly_literal', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('1147fd77-60f7-4fb4-a485-e0100e05c21f', 'canonical_answer_1', 11, 'Since X is a discrete count being approximated by a continuous Normal distribution, a continuity correction is applied: "more than 18" is approximated using the boundary 18.5.', ARRAY['part-c-criterion-02'], 'drafted', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('1147fd77-60f7-4fb4-a485-e0100e05c21f', 'canonical_answer_1', 12, '

', ARRAY[]::text[], 'assembly_literal', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('1147fd77-60f7-4fb4-a485-e0100e05c21f', 'canonical_answer_1', 13, 'z = (18.5 - 12)/3.359 = 6.5/3.359 ≈ 1.935.', ARRAY['part-c-criterion-03'], 'drafted', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('1147fd77-60f7-4fb4-a485-e0100e05c21f', 'canonical_answer_1', 14, '

', ARRAY[]::text[], 'assembly_literal', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('1147fd77-60f7-4fb4-a485-e0100e05c21f', 'canonical_answer_1', 15, 'P(X > 18) ≈ P(Z > 1.935) ≈ 1 - 0.9735 = 0.0265, or about 2.65%.', ARRAY['part-c-criterion-04'], 'drafted', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('1147fd77-60f7-4fb4-a485-e0100e05c21f', 'canonical_answer_1', 16, '

', ARRAY[]::text[], 'assembly_literal', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('1147fd77-60f7-4fb4-a485-e0100e05c21f', 'canonical_answer_1', 17, '(d) 22 defective bulbs is far above the assumed mean of 12 -- roughly (22-12)/3.359 ≈ 2.98, about 3 standard deviations above the mean -- which corresponds to a very small probability of occurring under the claimed 6% defect rate.', ARRAY['part-d-criterion-01'], 'drafted', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('1147fd77-60f7-4fb4-a485-e0100e05c21f', 'canonical_answer_1', 18, '

', ARRAY[]::text[], 'assembly_literal', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('1147fd77-60f7-4fb4-a485-e0100e05c21f', 'canonical_answer_1', 19, 'Because an outcome this extreme would be quite rare if the true defect rate really were 6%, observing 22 defective bulbs provides evidence (reasoning informally from how unlikely such a result would be under the stated model) that the true defect rate may actually be higher than the manufacturer''s claimed 6%.', ARRAY['part-d-criterion-02'], 'drafted', 'apstats_canonical_2026_09_25');

-- apstats-frq-u12-020 (3449fff0-009e-4ffc-ac1f-ef1c77c0b670)
update app.content_item_versions set canonical_answer_1 = '(a) Using the South facility''s five-number summary (Q1=10.5, Q3=14.0): IQR = 14.0 - 10.5 = 3.5.

Upper fence = Q3 + 1.5 x IQR = 14.0 + 1.5(3.5) = 14.0 + 5.25 = 19.25.

Since the recorded maximum of 40 pounds is greater than the upper fence of 19.25, it IS an outlier by the 1.5xIQR rule.

(b)(i) The mean would decrease. The mean is affected by every value in the dataset, and replacing a very high value (40) with a much smaller one (8.0) reduces the total sum, and therefore reduces the mean.

(ii) The median could shift, but its exact direction and size cannot be determined from the summary statistics alone. Although the median depends only on the rank of the middle value(s), this specific correction moves the affected data point''s rank dramatically: it goes from being the maximum (well above the median) to being below Q1 (well below the median) -- crossing over the median''s position entirely. Because of this, it is not simply a case of "a large value getting smaller" without consequence; the identities of the values occupying the middle ranks of the dataset can change as a result, so the median''s new value cannot be pinned down without the full raw dataset.

(iii) The standard deviation would decrease. Removing the extreme deviation caused by the incorrect 40-pound value (far from the mean) and replacing it with a value close to the center of the distribution reduces the overall variability of the data around the mean.

(c) After the correction, the value 8.0 is no longer the maximum of the South data -- in fact, since 8.0 is below the South median of 12.5, it is now one of the smaller values in the dataset, not the largest. This means the true corrected maximum of the South data is some other, unknown-from-the-summary value that is no greater than what was previously the second-largest observation.

With the extreme high value removed, the corrected South distribution is likely much more symmetric (no longer having an extreme high outlier pulling its shape), in contrast to -- or rather, now more similar to -- the North distribution''s shape, which was already roughly symmetric (since its mean, 12.4, and median, 12.0, were already close together).

The corrected South standard deviation would be smaller than North''s reported SD of 3.1 (since South''s extreme value has been removed while North''s has not) -- meaning that despite the originally reported SDs being identical (3.1 for both facilities), the two facilities are actually LESS similar in spread than the original, uncorrected statistics suggested.

However, the centers (mean and median) of the North and South distributions remain fairly similar even after the correction (South''s mean shifts down only slightly, and its median may shift somewhat but stays in a comparable range to North''s), so the two facilities remain broadly comparable in terms of typical package weight, even though their spread is now shown to differ more than originally reported.' where id = '3449fff0-009e-4ffc-ac1f-ef1c77c0b670';
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('3449fff0-009e-4ffc-ac1f-ef1c77c0b670', 'canonical_answer_1', 1, '(a) Using the South facility''s five-number summary (Q1=10.5, Q3=14.0): IQR = 14.0 - 10.5 = 3.5.', ARRAY['part-a-criterion-01'], 'drafted', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('3449fff0-009e-4ffc-ac1f-ef1c77c0b670', 'canonical_answer_1', 2, '

', ARRAY[]::text[], 'assembly_literal', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('3449fff0-009e-4ffc-ac1f-ef1c77c0b670', 'canonical_answer_1', 3, 'Upper fence = Q3 + 1.5 x IQR = 14.0 + 1.5(3.5) = 14.0 + 5.25 = 19.25.', ARRAY['part-a-criterion-02'], 'drafted', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('3449fff0-009e-4ffc-ac1f-ef1c77c0b670', 'canonical_answer_1', 4, '

', ARRAY[]::text[], 'assembly_literal', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('3449fff0-009e-4ffc-ac1f-ef1c77c0b670', 'canonical_answer_1', 5, 'Since the recorded maximum of 40 pounds is greater than the upper fence of 19.25, it IS an outlier by the 1.5xIQR rule.', ARRAY['part-a-criterion-03'], 'drafted', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('3449fff0-009e-4ffc-ac1f-ef1c77c0b670', 'canonical_answer_1', 6, '

', ARRAY[]::text[], 'assembly_literal', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('3449fff0-009e-4ffc-ac1f-ef1c77c0b670', 'canonical_answer_1', 7, '(b)(i) The mean would decrease. The mean is affected by every value in the dataset, and replacing a very high value (40) with a much smaller one (8.0) reduces the total sum, and therefore reduces the mean.', ARRAY['part-b-criterion-01'], 'drafted', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('3449fff0-009e-4ffc-ac1f-ef1c77c0b670', 'canonical_answer_1', 8, '

', ARRAY[]::text[], 'assembly_literal', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('3449fff0-009e-4ffc-ac1f-ef1c77c0b670', 'canonical_answer_1', 9, '(ii) The median could shift, but its exact direction and size cannot be determined from the summary statistics alone. Although the median depends only on the rank of the middle value(s), this specific correction moves the affected data point''s rank dramatically: it goes from being the maximum (well above the median) to being below Q1 (well below the median) -- crossing over the median''s position entirely. Because of this, it is not simply a case of "a large value getting smaller" without consequence; the identities of the values occupying the middle ranks of the dataset can change as a result, so the median''s new value cannot be pinned down without the full raw dataset.', ARRAY['part-b-criterion-02'], 'drafted', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('3449fff0-009e-4ffc-ac1f-ef1c77c0b670', 'canonical_answer_1', 10, '

', ARRAY[]::text[], 'assembly_literal', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('3449fff0-009e-4ffc-ac1f-ef1c77c0b670', 'canonical_answer_1', 11, '(iii) The standard deviation would decrease. Removing the extreme deviation caused by the incorrect 40-pound value (far from the mean) and replacing it with a value close to the center of the distribution reduces the overall variability of the data around the mean.', ARRAY['part-b-criterion-03'], 'drafted', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('3449fff0-009e-4ffc-ac1f-ef1c77c0b670', 'canonical_answer_1', 12, '

', ARRAY[]::text[], 'assembly_literal', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('3449fff0-009e-4ffc-ac1f-ef1c77c0b670', 'canonical_answer_1', 13, '(c) After the correction, the value 8.0 is no longer the maximum of the South data -- in fact, since 8.0 is below the South median of 12.5, it is now one of the smaller values in the dataset, not the largest. This means the true corrected maximum of the South data is some other, unknown-from-the-summary value that is no greater than what was previously the second-largest observation.', ARRAY['part-c-criterion-01'], 'drafted', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('3449fff0-009e-4ffc-ac1f-ef1c77c0b670', 'canonical_answer_1', 14, '

', ARRAY[]::text[], 'assembly_literal', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('3449fff0-009e-4ffc-ac1f-ef1c77c0b670', 'canonical_answer_1', 15, 'With the extreme high value removed, the corrected South distribution is likely much more symmetric (no longer having an extreme high outlier pulling its shape), in contrast to -- or rather, now more similar to -- the North distribution''s shape, which was already roughly symmetric (since its mean, 12.4, and median, 12.0, were already close together).', ARRAY['part-c-criterion-02'], 'drafted', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('3449fff0-009e-4ffc-ac1f-ef1c77c0b670', 'canonical_answer_1', 16, '

', ARRAY[]::text[], 'assembly_literal', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('3449fff0-009e-4ffc-ac1f-ef1c77c0b670', 'canonical_answer_1', 17, 'The corrected South standard deviation would be smaller than North''s reported SD of 3.1 (since South''s extreme value has been removed while North''s has not) -- meaning that despite the originally reported SDs being identical (3.1 for both facilities), the two facilities are actually LESS similar in spread than the original, uncorrected statistics suggested.', ARRAY['part-c-criterion-03'], 'drafted', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('3449fff0-009e-4ffc-ac1f-ef1c77c0b670', 'canonical_answer_1', 18, '

', ARRAY[]::text[], 'assembly_literal', 'apstats_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('3449fff0-009e-4ffc-ac1f-ef1c77c0b670', 'canonical_answer_1', 19, 'However, the centers (mean and median) of the North and South distributions remain fairly similar even after the correction (South''s mean shifts down only slightly, and its median may shift somewhat but stays in a comparable range to North''s), so the two facilities remain broadly comparable in terms of typical package weight, even though their spread is now shown to differ more than originally reported.', ARRAY['part-c-criterion-04'], 'drafted', 'apstats_canonical_2026_09_25');

do $$
declare
  v_bad text;
begin
  select string_agg(civ.id::text, ', ') into v_bad
  from (values ('1147fd77-60f7-4fb4-a485-e0100e05c21f'::uuid),('3449fff0-009e-4ffc-ac1f-ef1c77c0b670'::uuid)) as t(vid)
  join app.content_item_versions civ on civ.id = t.vid
  cross join lateral (
    select string_agg(cas.span_text, '' order by cas.span_ordinal) as concat
    from app.canonical_answer_spans cas
    where cas.content_item_version_id = civ.id and cas.answer_field = 'canonical_answer_1'
  ) agg
  where agg.concat is distinct from civ.canonical_answer_1;

  if v_bad is not null then
    raise exception 'span concatenation mismatch for version ids: %', v_bad;
  end if;
end $$;

commit;

