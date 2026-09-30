begin;
create temporary table u1n_epv (epv_id uuid) on commit drop;
create temporary table u1v_epv (epv_id uuid) on commit drop;
insert into u1n_epv select epv.id from app.exam_pack_versions epv join app.exam_packs e on e.id = epv.exam_pack_id where e.exam_name = 'AP Calculus AB';
insert into u1v_epv select epv_id from u1n_epv;
do $$ begin
  if (select count(*) from u1n_epv) <> 1 then raise exception 'exam pack version lookup failed'; end if;
  if exists (select 1 from app.content_items ci join u1n_epv on ci.exam_pack_version_id = u1n_epv.epv_id where ci.content_key = any (array['apcalcab-frq-u1v-001-v1','apcalcab-frq-u1v-001-v2','apcalcab-frq-u1v-001-v3','apcalcab-frq-u1v-002-v1','apcalcab-frq-u1v-002-v2','apcalcab-frq-u1v-002-v3'])) then
    raise exception 'chunk already loaded';
  end if;
end $$;
-- FRQ variant 001-v1 of 001 | medium | Gain Ratio of a Circuit With a Hole and a Pole
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status, frq_form, practice_format, frq_archetype)
  select gen_random_uuid(), epv_id, 'apcalcab-frq-u1v-001-v1', 'frq', 'Gain Ratio of a Circuit With a Hole and a Pole', 'draft', 'short', 'targeted_drill', 'mathematical_routines'
  from u1v_epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, rubric_type, evaluator_strategy)
  select gen_random_uuid(), id, 1, 'Answer all parts of the following question.

(a) Find lim(x->-2) g(x). Show the algebra that leads to your answer.

(b) The graph of g has a removable discontinuity at x = -2. Justify this, and state the value that would have to be assigned to g(-2) to make the function continuous at x = -2.

(c) Find lim(x->3-) g(x) and lim(x->3+) g(x). Give a reason for the sign of each.', 'The gain g of an amplifier circuit at input level x is modeled by g(x) = (3x^2 - x - 14)/(x^2 - x - 6) for x != -2 and x != 3.', md5('apcalcab-frq-u1v-001-v1'), 'draft', 'tutor_review_pending', 'discrete_text', 'llm_discrete_text'
  from item_ins returning id
)
insert into app.frq_criteria (id, content_item_version_id, criterion_key, learner_facing_text, points_possible, evidence_requirements, minimum_fix, accepted_variants)
select gen_random_uuid(), id, 'part-a-criterion-01', 'Factors and cancels x + 2 (for x not equal to -2), then evaluates to obtain the limit 13/5.', 1, 'Response factors the numerator as (x + 2)(3x - 7) and the denominator as (x + 2)(x - 3), cancels x + 2 (for x not equal to -2), and evaluates (3x - 7)/(x - 3) at x = -2 to get (-13)/(-5) = 13/5.', 'Show the factoring and cancellation step before evaluating. A correct value with no algebra does not earn the point.', '["13/5","2.6"]'::jsonb from version_ins
union all select gen_random_uuid(), id, 'part-b-criterion-01', 'Justifies a removable discontinuity: the limit at x = -2 exists but g(-2) is not defined.', 1, 'Response states that the limit exists as a finite number while g(-2) is undefined, so the discontinuity is removable.', 'State that the limit exists and that g(-2) is undefined. Saying only ''the factors cancel'' is not sufficient.', '[]'::jsonb from version_ins
union all select gen_random_uuid(), id, 'part-b-criterion-02', 'States that g(-2) would have to equal 13/5 for continuity.', 1, 'Response states that assigning g(-2) = 13/5 (the limit found in part (a)) makes g continuous at x = -2.', 'Give the value 13/5 and connect it to the limit.', '["13/5","2.6"]'::jsonb from version_ins
union all select gen_random_uuid(), id, 'part-c-criterion-01', 'Finds the one-sided limits at x = 3 as -infinity from the left and infinity from the right, with sign reasoning.', 1, 'Response gives lim(x->3-) g(x) = -infinity and lim(x->3+) g(x) = infinity, using the simplified form (3x - 7)/(x - 3): the numerator approaches 2 and is positive near x = 3, and x - 3 is negative on the left and positive on the right.', 'Give both one-sided limits and explain the sign of x - 3 on each side. Both must be correct.', '["+infinity","positive infinity","negative infinity"]'::jsonb from version_ins
;
-- FRQ variant 001-v2 of 001 | medium | Concentration Ratio Along a Tube
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status, frq_form, practice_format, frq_archetype)
  select gen_random_uuid(), epv_id, 'apcalcab-frq-u1v-001-v2', 'frq', 'Concentration Ratio Along a Tube', 'draft', 'short', 'targeted_drill', 'mathematical_routines'
  from u1v_epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, rubric_type, evaluator_strategy)
  select gen_random_uuid(), id, 1, 'Answer all parts of the following question.

(a) Find lim(x->-1) r(x). Show the algebra that leads to your answer.

(b) The graph of r has a removable discontinuity at x = -1. Justify this, and state the value that would have to be assigned to r(-1) to make the function continuous at x = -1.

(c) Find lim(x->4-) r(x) and lim(x->4+) r(x). Give a reason for the sign of each.', 'In a diffusion experiment, the ratio r of two concentrations at position x cm from a marker on a tube is modeled by r(x) = (2 + x - x^2)/(x^2 - 3x - 4) for x != -1 and x != 4.', md5('apcalcab-frq-u1v-001-v2'), 'draft', 'tutor_review_pending', 'discrete_text', 'llm_discrete_text'
  from item_ins returning id
)
insert into app.frq_criteria (id, content_item_version_id, criterion_key, learner_facing_text, points_possible, evidence_requirements, minimum_fix, accepted_variants)
select gen_random_uuid(), id, 'part-a-criterion-01', 'Factors and cancels x + 1 (for x not equal to -1), then evaluates to obtain the limit -3/5.', 1, 'Response factors the numerator as (x + 1)(2 - x) and the denominator as (x + 1)(x - 4), cancels x + 1 (for x not equal to -1), and evaluates (2 - x)/(x - 4) at x = -1 to get 3/(-5) = -3/5.', 'Show the factoring and cancellation step before evaluating. A correct value with no algebra does not earn the point.', '["-3/5","-0.6"]'::jsonb from version_ins
union all select gen_random_uuid(), id, 'part-b-criterion-01', 'Justifies a removable discontinuity: the limit at x = -1 exists but r(-1) is not defined.', 1, 'Response states that the limit exists as a finite number while r(-1) is undefined, so the discontinuity is removable.', 'State that the limit exists and that r(-1) is undefined. Saying only ''the factors cancel'' is not sufficient.', '[]'::jsonb from version_ins
union all select gen_random_uuid(), id, 'part-b-criterion-02', 'States that r(-1) would have to equal -3/5 for continuity.', 1, 'Response states that assigning r(-1) = -3/5 (the limit found in part (a)) makes r continuous at x = -1.', 'Give the value -3/5 and connect it to the limit.', '["-3/5","-0.6"]'::jsonb from version_ins
union all select gen_random_uuid(), id, 'part-c-criterion-01', 'Finds the one-sided limits at x = 4 as infinity from the left and -infinity from the right, with sign reasoning.', 1, 'Response gives lim(x->4-) r(x) = infinity and lim(x->4+) r(x) = -infinity, using the simplified form (2 - x)/(x - 4): the numerator approaches -2 and is negative near x = 4, and x - 4 is negative on the left (so the quotient is positive) and positive on the right (so the quotient is negative).', 'Give both one-sided limits and explain the sign of the numerator and of x - 4 on each side. Both must be correct.', '["+infinity","positive infinity","negative infinity"]'::jsonb from version_ins
;
-- FRQ variant 001-v3 of 001 | medium | Force Ratio on a Track
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status, frq_form, practice_format, frq_archetype)
  select gen_random_uuid(), epv_id, 'apcalcab-frq-u1v-001-v3', 'frq', 'Force Ratio on a Track', 'draft', 'short', 'targeted_drill', 'mathematical_routines'
  from u1v_epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, rubric_type, evaluator_strategy)
  select gen_random_uuid(), id, 1, 'Answer all parts of the following question.

(a) Find lim(x->-3) w(x). Show the algebra that leads to your answer.

(b) The graph of w has a removable discontinuity at x = -3. Justify this, and state the value that would have to be assigned to w(-3) to make the function continuous at x = -3.

(c) Find lim(x->1-) w(x) and lim(x->1+) w(x). Give a reason for the sign of each.', 'A physics lab models the ratio w of two measured forces at position x meters along a track by w(x) = (2x^2 + 9x + 9)/(3 - 2x - x^2) for x != -3 and x != 1.', md5('apcalcab-frq-u1v-001-v3'), 'draft', 'tutor_review_pending', 'discrete_text', 'llm_discrete_text'
  from item_ins returning id
)
insert into app.frq_criteria (id, content_item_version_id, criterion_key, learner_facing_text, points_possible, evidence_requirements, minimum_fix, accepted_variants)
select gen_random_uuid(), id, 'part-a-criterion-01', 'Factors and cancels x + 3 (for x not equal to -3), then evaluates to obtain the limit -3/4.', 1, 'Response factors the numerator as (x + 3)(2x + 3) and the denominator as (x + 3)(1 - x), cancels x + 3 (for x not equal to -3), and evaluates (2x + 3)/(1 - x) at x = -3 to get (-3)/4 = -3/4.', 'Show the factoring and cancellation step before evaluating. A correct value with no algebra does not earn the point.', '["-3/4","-0.75"]'::jsonb from version_ins
union all select gen_random_uuid(), id, 'part-b-criterion-01', 'Justifies a removable discontinuity: the limit at x = -3 exists but w(-3) is not defined.', 1, 'Response states that the limit exists as a finite number while w(-3) is undefined, so the discontinuity is removable.', 'State that the limit exists and that w(-3) is undefined. Saying only ''the factors cancel'' is not sufficient.', '[]'::jsonb from version_ins
union all select gen_random_uuid(), id, 'part-b-criterion-02', 'States that w(-3) would have to equal -3/4 for continuity.', 1, 'Response states that assigning w(-3) = -3/4 (the limit found in part (a)) makes w continuous at x = -3.', 'Give the value -3/4 and connect it to the limit.', '["-3/4","-0.75"]'::jsonb from version_ins
union all select gen_random_uuid(), id, 'part-c-criterion-01', 'Finds the one-sided limits at x = 1 as infinity from the left and -infinity from the right, with sign reasoning.', 1, 'Response gives lim(x->1-) w(x) = infinity and lim(x->1+) w(x) = -infinity, using the simplified form (2x + 3)/(1 - x): the numerator approaches 5 and is positive near x = 1, and 1 - x is small and positive on the left and small and negative on the right.', 'Give both one-sided limits and explain the sign of 1 - x on each side. Both must be correct.', '["+infinity","positive infinity","negative infinity"]'::jsonb from version_ins
;
-- FRQ variant 002-v1 of 002 | medium | Asymptotes of a Reaction Rate Model
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status, frq_form, practice_format, frq_archetype)
  select gen_random_uuid(), epv_id, 'apcalcab-frq-u1v-002-v1', 'frq', 'Asymptotes of a Reaction Rate Model', 'draft', 'short', 'targeted_drill', 'mathematical_routines'
  from u1v_epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, rubric_type, evaluator_strategy)
  select gen_random_uuid(), id, 1, 'Answer all parts of the following question.

(a) Find all vertical asymptotes of the graph of R. Justify your answer.

(b) Find lim(x->3+) R(x). Give a reason for the sign of your answer.

(c) Find lim(x->-4-) R(x). Give a reason for the sign of your answer.

(d) Write an equation for the horizontal asymptote of the graph of R, or explain why there is none.', 'The rate R of a chemical reaction, in moles per second, at temperature setting x is modeled by R(x) = (2x - 1)/(x^2 + x - 12).', md5('apcalcab-frq-u1v-002-v1'), 'draft', 'tutor_review_pending', 'discrete_text', 'llm_discrete_text'
  from item_ins returning id
)
insert into app.frq_criteria (id, content_item_version_id, criterion_key, learner_facing_text, points_possible, evidence_requirements, minimum_fix, accepted_variants)
select gen_random_uuid(), id, 'part-a-criterion-01', 'Identifies x = 3 and x = -4 and justifies each with a zero denominator and a nonzero numerator.', 1, 'Response factors the denominator as (x - 3)(x + 4) and identifies x = 3 and x = -4, noting that the numerator 2x - 1 is nonzero (5 and -9) at each.', 'Name both asymptotes and state that the numerator is nonzero at each. Listing the zeros of the denominator alone is not enough.', '[]'::jsonb from version_ins
union all select gen_random_uuid(), id, 'part-b-criterion-01', 'Finds lim(x->3+) R(x) = infinity, with sign reasoning.', 1, 'Response gives infinity and explains that near 3 from the right the numerator is positive (about 5), x - 3 is small and positive, and x + 4 is positive.', 'Give infinity and justify the sign of each factor.', '["+infinity","positive infinity"]'::jsonb from version_ins
union all select gen_random_uuid(), id, 'part-c-criterion-01', 'Finds lim(x->-4-) R(x) = -infinity, with sign reasoning.', 1, 'Response gives -infinity and explains that near -4 from the left the numerator is negative (about -9), and both x + 4 and x - 3 are negative, so the denominator is small and positive.', 'Give -infinity and justify the sign of the numerator and denominator.', '["negative infinity"]'::jsonb from version_ins
union all select gen_random_uuid(), id, 'part-d-criterion-01', 'States the horizontal asymptote y = 0 with a valid reason based on degrees or a limit at infinity.', 1, 'Response gives y = 0 and justifies it with the degree of the denominator exceeding the degree of the numerator, or by evaluating lim(x->infinity) R(x) = 0.', 'State y = 0 and give a reason based on degrees or the limit at infinity.', '["y = 0"]'::jsonb from version_ins
;
-- FRQ variant 002-v2 of 002 | medium | Asymptotes of a Dosage Ratio With Equal Degrees
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status, frq_form, practice_format, frq_archetype)
  select gen_random_uuid(), epv_id, 'apcalcab-frq-u1v-002-v2', 'frq', 'Asymptotes of a Dosage Ratio With Equal Degrees', 'draft', 'short', 'targeted_drill', 'mathematical_routines'
  from u1v_epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, rubric_type, evaluator_strategy)
  select gen_random_uuid(), id, 1, 'Answer all parts of the following question.

(a) Find all vertical asymptotes of the graph of D. Justify your answer.

(b) Find lim(x->4-) D(x). Give a reason for the sign of your answer.

(c) Find lim(x->0+) D(x). Give a reason for the sign of your answer.

(d) Write an equation for the horizontal asymptote of the graph of D, or explain why there is none.', 'A pharmacology model gives the ratio D of absorbed to administered dose at dose setting x as D(x) = (5x^2 - 3)/(2x^2 - 8x).', md5('apcalcab-frq-u1v-002-v2'), 'draft', 'tutor_review_pending', 'discrete_text', 'llm_discrete_text'
  from item_ins returning id
)
insert into app.frq_criteria (id, content_item_version_id, criterion_key, learner_facing_text, points_possible, evidence_requirements, minimum_fix, accepted_variants)
select gen_random_uuid(), id, 'part-a-criterion-01', 'Identifies x = 0 and x = 4 and justifies each with a zero denominator and a nonzero numerator.', 1, 'Response factors the denominator as 2x(x - 4) and identifies x = 0 and x = 4, noting that the numerator 5x^2 - 3 is nonzero (-3 and 77) at each.', 'Name both asymptotes and state that the numerator is nonzero at each. Listing the zeros of the denominator alone is not enough.', '[]'::jsonb from version_ins
union all select gen_random_uuid(), id, 'part-b-criterion-01', 'Finds lim(x->4-) D(x) = -infinity, with sign reasoning.', 1, 'Response gives -infinity and explains that near 4 from the left the numerator is positive (about 77), 2x is positive (about 8), and x - 4 is small and negative, so the denominator is small and negative.', 'Give -infinity and justify the sign of the numerator and of each denominator factor.', '["negative infinity"]'::jsonb from version_ins
union all select gen_random_uuid(), id, 'part-c-criterion-01', 'Finds lim(x->0+) D(x) = infinity, with sign reasoning.', 1, 'Response gives infinity and explains that near 0 from the right the numerator is negative (about -3), 2x is small and positive, and x - 4 is negative (about -4), so the denominator is small and negative and the quotient is positive.', 'Give infinity and justify the sign of the numerator and denominator.', '["+infinity","positive infinity"]'::jsonb from version_ins
union all select gen_random_uuid(), id, 'part-d-criterion-01', 'States the horizontal asymptote y = 5/2 with a valid reason based on equal degrees or a limit at infinity.', 1, 'Response gives y = 5/2 and justifies it with the numerator and denominator having equal degree (ratio of leading coefficients 5 and 2), or by evaluating lim(x->infinity) D(x) = 5/2, for example by dividing by x^2.', 'State y = 5/2 and give a reason based on the equal degrees or the limit at infinity.', '["y = 5/2","y = 2.5"]'::jsonb from version_ins
;
-- FRQ variant 002-v3 of 002 | hard | Asymptotes of a Signal Model With a Repeated Factor
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status, frq_form, practice_format, frq_archetype)
  select gen_random_uuid(), epv_id, 'apcalcab-frq-u1v-002-v3', 'frq', 'Asymptotes of a Signal Model With a Repeated Factor', 'draft', 'short', 'targeted_drill', 'mathematical_routines'
  from u1v_epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, rubric_type, evaluator_strategy)
  select gen_random_uuid(), id, 1, 'Answer all parts of the following question.

(a) Find all vertical asymptotes of the graph of S. Justify your answer.

(b) Find lim(x->1) S(x). Give a reason for the sign of your answer.

(c) Find lim(x->-2-) S(x). Give a reason for the sign of your answer.

(d) Write an equation for the horizontal asymptote of the graph of S, or explain why there is none.', 'The strength S of a signal at distance x meters from a transmitter mast is modeled by S(x) = (x + 4)/((x - 1)^2 (x + 2)).', md5('apcalcab-frq-u1v-002-v3'), 'draft', 'tutor_review_pending', 'discrete_text', 'llm_discrete_text'
  from item_ins returning id
)
insert into app.frq_criteria (id, content_item_version_id, criterion_key, learner_facing_text, points_possible, evidence_requirements, minimum_fix, accepted_variants)
select gen_random_uuid(), id, 'part-a-criterion-01', 'Identifies x = 1 and x = -2 and justifies each with a zero denominator and a nonzero numerator.', 1, 'Response identifies x = 1 and x = -2 as the zeros of the denominator (x - 1)^2 (x + 2), noting that the numerator x + 4 is nonzero (5 and 2) at each.', 'Name both asymptotes and state that the numerator is nonzero at each. Listing the zeros of the denominator alone is not enough.', '[]'::jsonb from version_ins
union all select gen_random_uuid(), id, 'part-b-criterion-01', 'Finds lim(x->1) S(x) = infinity, with sign reasoning that uses the squared factor.', 1, 'Response gives infinity and explains that near 1 the numerator is positive (about 5), (x - 1)^2 is small and positive on both sides of 1, and x + 2 is positive (about 3), so S is large and positive from both the left and the right.', 'Give infinity and explain why the sign is the same on both sides, using that (x - 1)^2 is positive.', '["+infinity","positive infinity"]'::jsonb from version_ins
union all select gen_random_uuid(), id, 'part-c-criterion-01', 'Finds lim(x->-2-) S(x) = -infinity, with sign reasoning.', 1, 'Response gives -infinity and explains that near -2 from the left the numerator is positive (about 2), (x - 1)^2 is positive (about 9), and x + 2 is small and negative, so the quotient is negative.', 'Give -infinity and justify the sign of each factor.', '["negative infinity"]'::jsonb from version_ins
union all select gen_random_uuid(), id, 'part-d-criterion-01', 'States the horizontal asymptote y = 0 with a valid reason based on degrees or a limit at infinity.', 1, 'Response gives y = 0 and justifies it with the degree of the denominator (3) exceeding the degree of the numerator (1), or by evaluating lim(x->infinity) S(x) = 0.', 'State y = 0 and give a reason based on degrees or the limit at infinity.', '["y = 0"]'::jsonb from version_ins
;

commit;
