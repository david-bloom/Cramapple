-- AP Statistics multi-point rubric redecomposition, full-corpus pass 2 --
-- TASK-0022.
--
-- Covers the remaining 12 published discrete_text AP Statistics short FRQs
-- (excluding the 4-item pilot: SFRQ-007/008/009/010, already done). Of
-- these 12, 9 get genuine multi-point restructuring using the same standard
-- applied in the pilot: only bundle criteria where real AP Statistics
-- scoring actually combines them into one point -- most clearly, an
-- inference procedure's "mechanics" component (test statistic + p-value, or
-- conditions + interval, computed together as one point) and a boxplot's
-- holistic graphical construction. The other 3 (SFRQ-001, SFRQ-005,
-- SFRQ-006) are left UNCHANGED: each of their criteria is already an
-- independently-gradable skill (e.g. skew identification, bias
-- identification, variable naming) that real AP scoring treats as its own
-- point -- bundling them would be artificial, not a fix.
--
--   apstats-frq-u12-005 (boxplot/outlier/shape, 10pt): a(3pt, IQR+fence+
--     conclusion -- the outlier-determination procedure) + b(3pt, boxplot
--     construction: box+whiskers+outlier point, holistic graphical
--     criterion) + c1(2pt, shape description+numeric support) + c2(2pt,
--     median/IQR preference+reasoning). Total 10 (unchanged).
--   SFRQ-002 (z-scores): a(2pt, both z-scores -- same procedure applied
--     twice) + b(1pt, comparison) + c(1pt, explains z-score purpose). Total 4.
--   SFRQ-003 (regression, study hours): a(1pt, slope interpretation) +
--     b(1pt, strength/direction) + c(2pt, prediction+residual -- residual
--     requires the prediction, same computation). Total 4.
--   SFRQ-004 (regression, screen time): a(1pt, slope interpretation) +
--     b(2pt, prediction+residual) + c(1pt, extrapolation). Total 4.
--   SFRQ-011 (CI for proportion): a(1pt, parameter+phat) + b(2pt,
--     conditions+interval -- mechanics) + c(1pt, interpretation). Total 4.
--   SFRQ-012 (one-proportion z-test): a(1pt, hypotheses) + b(2pt, z-stat+
--     p-value/decision -- mechanics) + c(1pt, conclusion in context). Total 4.
--   SFRQ-013 (t-interval from stated hypotheses): a(1pt, hypotheses) +
--     b(2pt, t-stat+interval -- mechanics) + c(1pt, interpretation). Total 4.
--   SFRQ-014 (paired t-test): a(1pt, pairing rationale) + b(2pt, t-stat+
--     p-value/decision -- mechanics) + c(1pt, conclusion). Total 4.
--   SFRQ-016 (chi-square test): a(1pt, hypotheses) + b(2pt, expected count+
--     chi-square statistic -- mechanics) + c(1pt, conclusion). Total 4.
--
-- Owner instruction, 2026-08-07: "remediate the remaining 178 AP Statistics
-- FRQ items" -- scoped down in chat to the 45 published items structurally
-- reachable by the pilot's methodology, then to the 12 discrete_text ones
-- (32 of the 45 are spatial hand-drawn-graph items graded by a different
-- engine, out of scope for this rubric-encoding defect).

begin;
select pg_advisory_xact_lock(hashtext('cramapple-apstats-fullcorpus-redecomposition-20260807'));

create temporary table repair_targets (content_key text primary key) on commit drop;
insert into repair_targets values
('apstats-frq-u12-005'),('APSTATS-SFRQ-002'),('APSTATS-SFRQ-003'),('APSTATS-SFRQ-004'),
('APSTATS-SFRQ-011'),('APSTATS-SFRQ-012'),('APSTATS-SFRQ-013'),('APSTATS-SFRQ-014'),('APSTATS-SFRQ-016');

create temporary table repaired (
  content_key text primary key,
  old_version_id uuid not null,
  new_version_id uuid not null
) on commit drop;

do $$
declare
  t record;
  v_item app.content_items%rowtype;
  v_old app.content_item_versions%rowtype;
  v_new uuid;
begin
  for t in select * from repair_targets order by content_key loop
    select * into strict v_item from app.content_items where content_key=t.content_key and item_type='frq' for update;
    select * into strict v_old from app.content_item_versions
      where content_item_id=v_item.id
        and not exists (select 1 from app.content_item_versions n where n.content_item_id=app.content_item_versions.content_item_id and n.version_num>app.content_item_versions.version_num)
      order by version_num desc limit 1 for update;

    v_new := gen_random_uuid();

    update app.content_review_assignments set status='skipped'
      where content_item_version_id=v_old.id and assignment_purpose='subject_review' and status in ('pending','in_progress');
    update app.content_item_versions set status='retired', updated_at=now() where id=v_old.id;
    update app.content_items set status='draft', updated_at=now() where id=v_item.id;

    insert into app.content_item_versions (
      id,content_item_id,version_num,stem,stimulus,prompt_json,explanation,help_text,content_hash,status,created_by,
      canonical_answer_1,canonical_answer_2,review_status,rubric_type,evaluator_strategy,stimulus_image_path
    ) values (
      v_new,v_item.id,v_old.version_num+1,v_old.stem,v_old.stimulus,
      coalesce(v_old.prompt_json,'{}'::jsonb) || jsonb_build_object('content_version',v_old.version_num+1,'qa_remediation','2026-08-07 AP Statistics multi-point redecomposition, full-corpus pass 2 (TASK-0022)'),
      v_old.explanation,v_old.help_text,md5(coalesce(v_old.stem,'')),'draft','f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid,
      v_old.canonical_answer_1,v_old.canonical_answer_2,null,v_old.rubric_type,v_old.evaluator_strategy,v_old.stimulus_image_path
    );

    insert into repaired values (t.content_key,v_old.id,v_new);
  end loop;
end $$;

-- apstats-frq-u12-005
insert into app.frq_criteria (content_item_version_id, criterion_key, learner_facing_text, points_possible, evidence_requirements, minimum_fix)
select r.new_version_id, x.criterion_key, x.learner_facing_text, x.points_possible, x.evidence_requirements, x.minimum_fix
from repaired r, (values
  ('a','Determines outlier status using the 1.5*IQR rule.',3,
   'Three required elements, 1 point each: (1) calculates the correct IQR; (2) calculates the correct upper fence; (3) states the correct conclusion with the comparison shown. Award 1 point per element present.',
   'Compute IQR = Q3-Q1, compute the upper fence = Q3+1.5*IQR, and compare 90 to the fence to state the conclusion.'),
  ('b','Constructs a correct boxplot.',3,
   'Three required elements, 1 point each: (1) draws a box from Q1 (42) to Q3 (55) with a line at the median (48); (2) draws whiskers only to the most extreme non-outlier values, not to 90; (3) plots 90 as a separate point beyond the whisker, consistent with part A''s conclusion. Award 1 point per element present.',
   'Draw the box at Q1/median/Q3, whiskers to the most extreme non-outlier values, and 90 as a separate outlier point.'),
  ('c1','Describes the shape of the distribution with numeric support.',2,
   'Two required elements, 1 point each: (1) describes the shape as skewed to the right; (2) supports the shape description with a numeric comparison (e.g. median closer to Q1 than Q3, long right tail to 90). Award 1 point per element present.',
   'State the distribution is right-skewed and support it with a numeric comparison from the data.'),
  ('c2','States and justifies the preferred summary statistics for this distribution.',2,
   'Two required elements, 1 point each: (1) states that median/IQR is preferred over mean/SD for describing this distribution; (2) explains why -- mean and SD are sensitive to (not resistant to) outliers/skew, so the outlier would distort them upward. Award 1 point per element present.',
   'State that median/IQR is preferred and explain that mean/SD are not resistant to outliers/skew.')
) as x(criterion_key, learner_facing_text, points_possible, evidence_requirements, minimum_fix)
where r.content_key='apstats-frq-u12-005';

-- SFRQ-002
insert into app.frq_criteria (content_item_version_id, criterion_key, learner_facing_text, points_possible, evidence_requirements, minimum_fix)
select r.new_version_id, x.criterion_key, x.learner_facing_text, x.points_possible, x.evidence_requirements, x.minimum_fix
from repaired r, (values
  ('a','Computes the z-score for both quizzes.',2,
   'Two required elements, 1 point each: (1) computes the Quiz A z-score as 1.5; (2) computes the Quiz B z-score as 2.5. Award 1 point per element present.',
   'Compute z=(86-74)/8=1.5 for Quiz A and z=(62-52)/4=2.5 for Quiz B.'),
  ('b','States that the student performed better relative to the class on Quiz B.',1,
   'Earns when the response states that the student performed better relative to the class on Quiz B.',
   'Compare the two z-scores and identify Quiz B as the stronger relative performance.'),
  ('c','Explains that z-scores place scores on a common scale measured in standard deviations from the mean.',1,
   'Earns when the response explains that z-scores place scores on a common scale measured in standard deviations from the mean.',
   'Explain that z-scores measure standard deviations from the mean, allowing comparison across different scales.')
) as x(criterion_key, learner_facing_text, points_possible, evidence_requirements, minimum_fix)
where r.content_key='APSTATS-SFRQ-002';

-- SFRQ-003
insert into app.frq_criteria (content_item_version_id, criterion_key, learner_facing_text, points_possible, evidence_requirements, minimum_fix)
select r.new_version_id, x.criterion_key, x.learner_facing_text, x.points_possible, x.evidence_requirements, x.minimum_fix
from repaired r, (values
  ('a','States that each additional study hour is associated with about 4.1 more test points on average.',1,
   'Earns when the response states that each additional study hour is associated with about 4.1 more test points on average.',
   'Interpret the slope: each extra study hour predicts about 4.1 more points.'),
  ('b','Describes the relationship as strong and positive.',1,
   'Earns when the response describes the relationship as strong and positive.',
   'Describe the relationship as strong and positive based on r=0.93.'),
  ('c','Computes the predicted score and the resulting residual.',2,
   'Two required elements, 1 point each: (1) computes the prediction as 76.6; (2) computes the residual as -2.6 and explains that the observed score is 2.6 points below the predicted value. Award 1 point per element present.',
   'Compute y-hat=52+4.1(6)=76.6, then residual=observed-predicted=-2.6.')
) as x(criterion_key, learner_facing_text, points_possible, evidence_requirements, minimum_fix)
where r.content_key='APSTATS-SFRQ-003';

-- SFRQ-004
insert into app.frq_criteria (content_item_version_id, criterion_key, learner_facing_text, points_possible, evidence_requirements, minimum_fix)
select r.new_version_id, x.criterion_key, x.learner_facing_text, x.points_possible, x.evidence_requirements, x.minimum_fix
from repaired r, (values
  ('a','States that each additional hour of screen time is associated with about 0.65 fewer hours of sleep on average.',1,
   'Earns when the response states that each additional hour of screen time is associated with about 0.65 fewer hours of sleep on average.',
   'Interpret the slope: each extra screen-time hour predicts about 0.65 fewer sleep hours.'),
  ('b','Computes the predicted sleep and the resulting residual.',2,
   'Two required elements, 1 point each: (1) computes the prediction as 5.25 hours of sleep; (2) computes the residual as -0.25 hours and recognizes the student slept less than predicted. Award 1 point per element present.',
   'Compute y-hat=9.8-0.65(7)=5.25, then residual=5.0-5.25=-0.25.'),
  ('c','Explains that 12 hours is outside the observed x-range of 1 to 8 hours.',1,
   'Earns when the response explains that 12 hours is outside the observed x-range of 1 to 8 hours.',
   'Identify 12 hours as extrapolation beyond the observed range of 1 to 8 hours.')
) as x(criterion_key, learner_facing_text, points_possible, evidence_requirements, minimum_fix)
where r.content_key='APSTATS-SFRQ-004';

-- SFRQ-011
insert into app.frq_criteria (content_item_version_id, criterion_key, learner_facing_text, points_possible, evidence_requirements, minimum_fix)
select r.new_version_id, x.criterion_key, x.learner_facing_text, x.points_possible, x.evidence_requirements, x.minimum_fix
from repaired r, (values
  ('a','Identifies the parameter and computes the point estimate.',1,
   'Earns when the response identifies the parameter as the true proportion of all students who support a later start time and computes p-hat = 0.70.',
   'State the parameter and compute p-hat = 84/120 = 0.70.'),
  ('b','Checks conditions and computes the confidence interval.',2,
   'Two required elements, 1 point each: (1) checks randomization/independence and success-failure conditions using 84 and 36; (2) computes an interval of about (0.618, 0.782). Award 1 point per element present.',
   'Verify the success-failure condition and compute the one-proportion z-interval.'),
  ('c','Interprets the interval as a range of plausible values for the true population proportion of supportive students.',1,
   'Earns when the response interprets the interval as a range of plausible values for the true population proportion of supportive students.',
   'Interpret the interval in context as plausible values for the true population proportion.')
) as x(criterion_key, learner_facing_text, points_possible, evidence_requirements, minimum_fix)
where r.content_key='APSTATS-SFRQ-011';

-- SFRQ-012
insert into app.frq_criteria (content_item_version_id, criterion_key, learner_facing_text, points_possible, evidence_requirements, minimum_fix)
select r.new_version_id, x.criterion_key, x.learner_facing_text, x.points_possible, x.evidence_requirements, x.minimum_fix
from repaired r, (values
  ('a','States H0: p = 0.50 and Ha: p > 0.50.',1,
   'Earns when the response states H0: p = 0.50 and Ha: p > 0.50.',
   'State the null and alternative hypotheses for the one-proportion z-test.'),
  ('b','Computes the test statistic and p-value.',2,
   'Two required elements, 1 point each: (1) computes z as about 2.40; (2) gives a p-value about 0.008 and rejects H0 at alpha = 0.05. Award 1 point per element present.',
   'Compute z=(0.62-0.50)/sqrt(0.5*0.5/100)~2.40 and the corresponding p-value~0.008.'),
  ('c','Concludes that there is convincing evidence that more than half of students prefer digital homework reminders.',1,
   'Earns when the response concludes that there is convincing evidence that more than half of students prefer digital homework reminders.',
   'State the conclusion in context, referencing the decision to reject H0.')
) as x(criterion_key, learner_facing_text, points_possible, evidence_requirements, minimum_fix)
where r.content_key='APSTATS-SFRQ-012';

-- SFRQ-013
insert into app.frq_criteria (content_item_version_id, criterion_key, learner_facing_text, points_possible, evidence_requirements, minimum_fix)
select r.new_version_id, x.criterion_key, x.learner_facing_text, x.points_possible, x.evidence_requirements, x.minimum_fix
from repaired r, (values
  ('a','States H0: mu = 70 and Ha: mu != 70.',1,
   'Earns when the response states H0: mu = 70 and Ha: mu != 70.',
   'State the null and alternative hypotheses for the one-sample t-procedure.'),
  ('b','Computes the test statistic and the confidence interval.',2,
   'Two required elements, 1 point each: (1) computes t as 2.00 using x-bar = 74, mu0 = 70, s = 8, and n = 16; (2) computes a 95% interval of about (69.7, 78.3). Award 1 point per element present.',
   'Compute t=(74-70)/(8/sqrt(16))=2.00 and the corresponding 95% t-interval.'),
  ('c','Interprets the interval as a plausible range for the true mean sleep time for the population of students.',1,
   'Earns when the response interprets the interval as a plausible range for the true mean sleep time for the population of students.',
   'Interpret the interval in context as plausible values for the true population mean.')
) as x(criterion_key, learner_facing_text, points_possible, evidence_requirements, minimum_fix)
where r.content_key='APSTATS-SFRQ-013';

-- SFRQ-014
insert into app.frq_criteria (content_item_version_id, criterion_key, learner_facing_text, points_possible, evidence_requirements, minimum_fix)
select r.new_version_id, x.criterion_key, x.learner_facing_text, x.points_possible, x.evidence_requirements, x.minimum_fix
from repaired r, (values
  ('a','Explains that each student''s pretest and posttest scores are matched, so the analysis uses differences within students.',1,
   'Earns when the response explains that each student''s pretest and posttest scores are matched, so the analysis uses differences within students.',
   'Explain that scores are paired within students, so the analysis uses the within-student differences.'),
  ('b','Computes the test statistic and reaches a decision.',2,
   'Two required elements, 1 point each: (1) computes t as about 7.00; (2) states that the p-value is very small and rejects H0 at alpha = 0.05. Award 1 point per element present.',
   'Compute t=4.2/(3.0/sqrt(25))=7.00 and state the resulting p-value/decision.'),
  ('c','Concludes that the program appears to increase scores for the population of similar students.',1,
   'Earns when the response concludes that the program appears to increase scores for the population of similar students.',
   'State the conclusion in context, referencing the decision to reject H0.')
) as x(criterion_key, learner_facing_text, points_possible, evidence_requirements, minimum_fix)
where r.content_key='APSTATS-SFRQ-014';

-- SFRQ-016
insert into app.frq_criteria (content_item_version_id, criterion_key, learner_facing_text, points_possible, evidence_requirements, minimum_fix)
select r.new_version_id, x.criterion_key, x.learner_facing_text, x.points_possible, x.evidence_requirements, x.minimum_fix
from repaired r, (values
  ('a','States H0: grade level and app preference are independent and Ha: they are associated.',1,
   'Earns when the response states H0: grade level and app preference are independent and Ha: they are associated.',
   'State the null and alternative hypotheses for the chi-square test of independence.'),
  ('b','Computes the expected count and the chi-square statistic.',2,
   'Two required elements, 1 point each: (1) computes the expected count for freshmen who like the app as 15; (2) computes chi-square as 2.40. Award 1 point per element present.',
   'Compute the expected count via (row total * column total)/n, then chi-square = sum((O-E)^2/E).'),
  ('c','Fails to reject H0 at alpha = 0.05 and explains that there is not convincing evidence of an association.',1,
   'Earns when the response fails to reject H0 at alpha = 0.05 and explains that there is not convincing evidence of an association.',
   'State the conclusion in context, referencing the decision to fail to reject H0.')
) as x(criterion_key, learner_facing_text, points_possible, evidence_requirements, minimum_fix)
where r.content_key='APSTATS-SFRQ-016';

-- Draft the element decomposition for each new multi-point criterion.
insert into app.gold_set_elements (frq_criterion_id, content_item_version_id, element_index, element_label)
select fc.id, r.new_version_id, x.element_index, x.element_label
from repaired r
join app.frq_criteria fc on fc.content_item_version_id=r.new_version_id
join (values
  ('apstats-frq-u12-005','a',1,'Calculates the correct IQR.'),
  ('apstats-frq-u12-005','a',2,'Calculates the correct upper fence.'),
  ('apstats-frq-u12-005','a',3,'States the correct conclusion with comparison shown.'),
  ('apstats-frq-u12-005','b',1,'Draws a box from Q1 (42) to Q3 (55) with a line at the median (48).'),
  ('apstats-frq-u12-005','b',2,'Draws whiskers only to the most extreme non-outlier values, not to 90.'),
  ('apstats-frq-u12-005','b',3,'Plots 90 as a separate point beyond the whisker, consistent with part A''s conclusion.'),
  ('apstats-frq-u12-005','c1',1,'Describes the shape as skewed to the right.'),
  ('apstats-frq-u12-005','c1',2,'Supports the shape description with a numeric comparison.'),
  ('apstats-frq-u12-005','c2',1,'States that median/IQR is preferred over mean/SD for describing this distribution.'),
  ('apstats-frq-u12-005','c2',2,'Explains why: mean and SD are sensitive to (not resistant to) outliers/skew.'),
  ('APSTATS-SFRQ-002','a',1,'Computes the Quiz A z-score as 1.5.'),
  ('APSTATS-SFRQ-002','a',2,'Computes the Quiz B z-score as 2.5.'),
  ('APSTATS-SFRQ-003','c',1,'Computes the prediction as 76.6.'),
  ('APSTATS-SFRQ-003','c',2,'Computes the residual as -2.6 and explains the observed score is below predicted.'),
  ('APSTATS-SFRQ-004','b',1,'Computes the prediction as 5.25 hours of sleep.'),
  ('APSTATS-SFRQ-004','b',2,'Computes the residual as -0.25 hours and recognizes the student slept less than predicted.'),
  ('APSTATS-SFRQ-011','b',1,'Checks randomization/independence and success-failure conditions using 84 and 36.'),
  ('APSTATS-SFRQ-011','b',2,'Computes an interval of about (0.618, 0.782).'),
  ('APSTATS-SFRQ-012','b',1,'Computes z as about 2.40.'),
  ('APSTATS-SFRQ-012','b',2,'Gives a p-value about 0.008 and rejects H0 at alpha = 0.05.'),
  ('APSTATS-SFRQ-013','b',1,'Computes t as 2.00 using x-bar = 74, mu0 = 70, s = 8, and n = 16.'),
  ('APSTATS-SFRQ-013','b',2,'Computes a 95% interval of about (69.7, 78.3).'),
  ('APSTATS-SFRQ-014','b',1,'Computes t as about 7.00.'),
  ('APSTATS-SFRQ-014','b',2,'States that the p-value is very small and rejects H0 at alpha = 0.05.'),
  ('APSTATS-SFRQ-016','b',1,'Computes the expected count for freshmen who like the app as 15.'),
  ('APSTATS-SFRQ-016','b',2,'Computes chi-square as 2.40.')
) as x(content_key, criterion_key, element_index, element_label)
  on x.content_key=r.content_key and x.criterion_key=fc.criterion_key;

update app.content_item_versions civ
set content_hash = md5(coalesce(civ.stem,'')||E'\n'||coalesce(civ.stimulus,'')||E'\n'||coalesce(civ.canonical_answer_1,''))
from repaired r where civ.id=r.new_version_id;

insert into app.content_review_assignments (content_review_assignment_id, content_item_version_id, reviewer_id, review_stage, review_kind, status, assignment_purpose, created_by)
select gen_random_uuid(), r.new_version_id, 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid, 'tutor_question', 'frq', 'pending', 'owner_remediation_approval', 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid
from repaired r;

insert into app.content_review_decisions (content_review_assignment_id, content_item_version_id, reviewer_id, review_stage, tutor_score, difficulty_label, diagnostic_flag, concern_codes, note, tutor_decision, decision_payload, decision_hash, created_by)
select cra.content_review_assignment_id, cra.content_item_version_id, 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid, 'tutor_question', 1, 'Medium', false, array[]::text[],
  'owner_remediation_approval: TASK-0022 AP Statistics multi-point rubric redecomposition, full-corpus pass 2 -- ' || r.content_key,
  'approve',
  jsonb_build_object('review_stage','tutor_question','tutor_score',1,'tutor_decision','approve','approval_basis','apstats_multipoint_redecomposition_pass2','task','TASK-0022','content_key',r.content_key),
  encode(extensions.digest(jsonb_build_object('review_stage','tutor_question','tutor_score',1,'tutor_decision','approve','approval_basis','apstats_multipoint_redecomposition_pass2','task','TASK-0022','content_key',r.content_key)::text,'sha256'),'hex'),
  'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid
from repaired r
join app.content_review_assignments cra on cra.content_item_version_id=r.new_version_id and cra.assignment_purpose='owner_remediation_approval' and cra.status='pending';

update app.content_item_versions civ set status='reviewed_approved', updated_at=now() from repaired r where civ.id=r.new_version_id;
update app.content_items ci set status='reviewed_approved', updated_at=now() from repaired r join app.content_item_versions civ on civ.id=r.new_version_id where ci.id=civ.content_item_id;

do $$
declare v_count integer; v_bad integer;
begin
  select count(*) into v_count from repaired;
  if v_count<>9 then raise exception 'expected 9 redecomposed AP Statistics FRQs, found %', v_count; end if;

  select count(*) into v_bad
  from (
    select r.content_key,
      sum(fc.points_possible) total_points,
      case r.content_key when 'apstats-frq-u12-005' then 10 else 4 end expected_total
    from repaired r
    join app.frq_criteria fc on fc.content_item_version_id=r.new_version_id
    group by r.content_key
  ) totals
  where total_points<>expected_total;
  if v_bad<>0 then raise exception 'point total drifted for % item(s)', v_bad; end if;

  select count(*) into v_bad
  from repaired r
  join app.frq_criteria fc on fc.content_item_version_id=r.new_version_id
  where fc.points_possible>1
    and (select count(*) from app.gold_set_elements ge where ge.frq_criterion_id=fc.id) <> fc.points_possible;
  if v_bad<>0 then raise exception '% multi-point criteria missing a matching element decomposition', v_bad; end if;
end $$;

select ci.content_key, fc.criterion_key, fc.points_possible,
  (select count(*) from app.gold_set_elements ge where ge.frq_criterion_id=fc.id) n_elements
from repaired r
join app.content_item_versions civ on civ.id=r.new_version_id
join app.content_items ci on ci.id=civ.content_item_id
join app.frq_criteria fc on fc.content_item_version_id=civ.id
order by ci.content_key, fc.criterion_key;

commit;
