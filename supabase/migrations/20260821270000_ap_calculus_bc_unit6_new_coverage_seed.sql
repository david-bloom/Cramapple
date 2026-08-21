begin;

-- New Coverage: AP Calculus BC Unit 6 topics 6.12 (Integrating Using
-- Linear Partial Fractions) and 6.13 (Evaluating Improper Integrals) --
-- both BC-only, both previously zero coverage (no brief, no explainer)
-- as identified during this session's BC-wide audit.
--
-- Grounded in docs/product/AP_CALCULUS_AB_BC_CED_FACT_PACK.md Unit 6
-- detail: 6.12 is scoped by the CED to linear, nonrepeating denominator
-- factors only (repeated linear factors and irreducible quadratics are
-- out of scope even for BC); 6.13 uses the standard limit-based
-- definition of an improper integral (infinite bound or discontinuous
-- integrand).
--
-- This is a pure insert -- no existing rows are touched. Rollback is
-- deleting these 2 rows (subject_key='ap_calculus_bc', unit_number=6,
-- topic_code in ('6.12','6.13')) from both tables, or setting status
-- back to 'draft'.
--
-- Every explainer is genuinely topic-specific: core_idea differs from
-- the paired brief's what_it_is, and no mini_example_question /
-- weak_answer / point_attaining_answer / practice_bridge value repeats
-- within this batch or elsewhere in the corpus (checked programmatically
-- before and after).

with brief_seed (
  topic_code, title, class_importance, exam_importance, what_it_is,
  why_it_matters, how_points_are_earned, answer_move, common_point_loss,
  learn_more_path
) as (
  values
  ('6.12','Integrating Using Linear Partial Fractions','somewhat-important','somewhat-important',
   'Linear partial fraction decomposition rewrites a rational function with distinct linear denominator factors as a sum of simpler fractions, each with one linear factor, before integrating.',
   'This technique unlocks antiderivatives for rational functions that don''t match a basic reverse-derivative rule, but the CED restricts it to nonrepeating linear factors only.',
   'You earn points by factoring the denominator into distinct linear factors, setting up the decomposition explicitly, solving for each constant, and integrating each resulting term to a logarithm.',
   'Factor the denominator into distinct linear factors, write A/(x-a) + B/(x-b), solve for A and B, then integrate each simpler fraction separately.',
   'Attempting the technique on a repeated linear factor or an irreducible quadratic factor, both of which are out of scope for this exam.',
   '/learn/ap-calculus-bc/unit-6/linear-partial-fractions'),
  ('6.13','Evaluating Improper Integrals','somewhat-important','somewhat-important',
   'An improper integral has an infinite bound or a discontinuous integrand, and is evaluated as the limit of a proper definite integral as the problematic bound is approached.',
   'Many accumulation and probability contexts extend over an infinite interval or approach a singular point, so this limit-based evaluation is the only way to assign them a value.',
   'You earn points by rewriting the improper integral explicitly as a limit, evaluating that limit, and stating convergence to a finite value or divergence based on the actual result.',
   'Rewrite the improper integral as a limit of a proper integral, evaluate the limit, then state convergence or divergence based on whether the limit is a finite number.',
   'Substituting infinity directly into an antiderivative instead of taking an explicit limit, or not splitting an interior discontinuity into two separate improper integrals.',
   '/learn/ap-calculus-bc/unit-6/improper-integrals')
)
insert into app.topic_point_briefs (
  subject_key, unit_number, topic_code, title, class_importance, exam_importance,
  what_it_is, why_it_matters, how_points_are_earned, answer_move,
  common_point_loss, learn_more_path, practice_subject_key, practice_unit_number,
  practice_topic_code, source_note, status, published_at
)
select
  'ap_calculus_bc', 6, topic_code, title, class_importance, exam_importance,
  what_it_is, why_it_matters, how_points_are_earned, answer_move,
  common_point_loss, learn_more_path, 'ap_calculus_bc', 6, topic_code,
  'cramapple-authored; new coverage 2026-08-21 -- these two topics had zero prior content (no brief, no explainer). Grounded in AP_CALCULUS_AB_BC_CED_FACT_PACK.md''s Unit 6 detail: the CED''s own scope language explicitly restricting 6.12 to linear, nonrepeating denominator factors (repeated linear factors and irreducible quadratics are out of scope even for BC), and the standard limit-based definition of an improper integral for 6.13. Both topics are BC-only. Mathematically verified: 6.12''s mini-example correctly identifies (x+2)^2 as a repeated linear factor outside scope, and gives a properly-scoped two-distinct-factor alternative; 6.13''s limit evaluates to 1, matching the coincidental direct-substitution shortcut, which is exactly the point being illustrated -- the shortcut is procedurally incomplete even when it happens to land on the right number. batch 2026-08-21-ap-calculus-bc-unit6-new-coverage; author=reviewer same session, no independent human review yet', 'published', now()
from brief_seed
on conflict (subject_key, topic_code) do update
set
  title = excluded.title,
  class_importance = excluded.class_importance,
  exam_importance = excluded.exam_importance,
  what_it_is = excluded.what_it_is,
  why_it_matters = excluded.why_it_matters,
  how_points_are_earned = excluded.how_points_are_earned,
  answer_move = excluded.answer_move,
  common_point_loss = excluded.common_point_loss,
  learn_more_path = excluded.learn_more_path,
  practice_subject_key = excluded.practice_subject_key,
  practice_unit_number = excluded.practice_unit_number,
  practice_topic_code = excluded.practice_topic_code,
  source_note = excluded.source_note,
  status = excluded.status,
  published_at = excluded.published_at;

with explainer_seed (
  topic_code, title, core_idea, what_students_need_to_understand,
  how_this_becomes_points, answer_move, mini_example_question, weak_answer,
  point_attaining_answer, common_point_loss, practice_bridge
) as (
  values
  ('6.12','Integrating Using Linear Partial Fractions',
   'Linear partial fraction decomposition is scoped by the CED to nonrepeating linear factors only -- a denominator with a repeated linear factor or an irreducible quadratic factor falls outside what this technique covers, even though BC students learn it.',
   'Before setting up A/(x-a) + B/(x-b), confirm the denominator factors into distinct, not repeated, linear factors, and confirm the numerator''s degree is already less than the denominator''s, or long division is needed first.',
   'Full credit requires the denominator correctly factored into distinct linear factors, the decomposition A/(x-a)+B/(x-b) set up explicitly, the constants solved for, and each resulting term integrated to a logarithm.',
   'Factor the denominator into distinct linear factors, set up A/(x-a)+B/(x-b), solve for A and B by clearing denominators and substituting convenient x-values, then integrate each term.',
   'A student is asked to integrate 1/((x-1)(x+2)^2) dx using linear partial fractions.',
   'This decomposes into A/(x-1) + B/(x+2), since both factors involve linear terms.',
   'This denominator is out of scope for this technique -- (x+2)^2 is a repeated linear factor, and the CED restricts linear partial fractions to nonrepeating linear factors only; a properly scoped example instead has two distinct linear factors, such as 1/((x-1)(x+2)) = A/(x-1) + B/(x+2), solved by clearing denominators to get 1 = A(x+2) + B(x-1), then substituting x=1 and x=-2 to find A and B separately.',
   'Attempting the technique on a repeated linear factor or an irreducible quadratic factor, which are both out of scope, or skipping long division when the numerator''s degree is too high.',
   'Before setting up a partial fraction decomposition, confirm every factor in the denominator is a distinct linear factor -- if any factor repeats or is an irreducible quadratic, this technique as scoped for the exam does not apply.'),
  ('6.13','Evaluating Improper Integrals',
   'An improper integral, with an infinite bound or a discontinuous integrand, is only defined as the limit of a proper definite integral as the problematic bound approaches infinity or the point of discontinuity -- a numeric answer without that limit step skips the actual definition.',
   'The limit must actually be evaluated and shown to exist as a finite value before the integral can be called convergent; if the limit is infinite or does not exist, the integral diverges, regardless of how the final expression looks.',
   'Full credit requires the improper integral rewritten explicitly as a limit of a proper integral, that limit evaluated, and the convergence conclusion (a finite value) or divergence conclusion stated based on the limit''s actual result.',
   'Rewrite the improper integral as lim(b -> value) of the definite integral from a to b, evaluate the resulting limit, and state convergence with a finite value or divergence based on that limit.',
   'A student integrates 1/x^2 from 1 to infinity and writes the answer as [-1/x] evaluated from 1 to infinity, substituting infinity directly to get 0 - (-1) = 1, without showing a limit step.',
   'This is fine, since plugging infinity directly into the antiderivative gives the same final answer.',
   'The final value of 1 happens to be correct here, but the setup skipped the required limit step -- the correct approach writes this as lim(b->infinity) of the integral from 1 to b of 1/x^2 dx, evaluates the antiderivative to get lim(b->infinity) (-1/b + 1) = 0 + 1 = 1; the limit must be shown explicitly, since for other integrands the same substitute-infinity-directly shortcut can produce an incorrect or undefined result instead of quietly working out.',
   'Substituting infinity directly into an antiderivative instead of taking an explicit limit, or failing to split an integral with an interior discontinuity into two separate improper integrals.',
   'Before evaluating any improper integral, rewrite it explicitly as a limit first, and only conclude convergence if that limit evaluates to an actual finite number.')
)
insert into app.topic_explainers (
  subject_key, unit_number, topic_code, title, core_idea,
  what_students_need_to_understand, how_this_becomes_points, answer_move,
  mini_example_question, weak_answer, point_attaining_answer,
  common_point_loss, practice_bridge, source_note, status, published_at
)
select
  'ap_calculus_bc', 6, topic_code, title, core_idea,
  what_students_need_to_understand, how_this_becomes_points, answer_move,
  mini_example_question, weak_answer, point_attaining_answer,
  common_point_loss, practice_bridge,
  'cramapple-authored; new coverage 2026-08-21 -- these two topics had zero prior content (no brief, no explainer). Grounded in AP_CALCULUS_AB_BC_CED_FACT_PACK.md''s Unit 6 detail: the CED''s own scope language explicitly restricting 6.12 to linear, nonrepeating denominator factors (repeated linear factors and irreducible quadratics are out of scope even for BC), and the standard limit-based definition of an improper integral for 6.13. Both topics are BC-only. Mathematically verified: 6.12''s mini-example correctly identifies (x+2)^2 as a repeated linear factor outside scope, and gives a properly-scoped two-distinct-factor alternative; 6.13''s limit evaluates to 1, matching the coincidental direct-substitution shortcut, which is exactly the point being illustrated -- the shortcut is procedurally incomplete even when it happens to land on the right number. batch 2026-08-21-ap-calculus-bc-unit6-new-coverage; author=reviewer same session, no independent human review yet', 'published', now()
from explainer_seed
on conflict (subject_key, topic_code) do update
set
  title = excluded.title,
  core_idea = excluded.core_idea,
  what_students_need_to_understand = excluded.what_students_need_to_understand,
  how_this_becomes_points = excluded.how_this_becomes_points,
  answer_move = excluded.answer_move,
  mini_example_question = excluded.mini_example_question,
  weak_answer = excluded.weak_answer,
  point_attaining_answer = excluded.point_attaining_answer,
  common_point_loss = excluded.common_point_loss,
  practice_bridge = excluded.practice_bridge,
  source_note = excluded.source_note,
  status = excluded.status,
  published_at = excluded.published_at;

do $$
declare
  v_briefs integer;
  v_explainers integer;
  v_core_matches integer;
begin
  select count(*) into v_briefs from app.topic_point_briefs
    where subject_key='ap_calculus_bc' and unit_number=6
      and topic_code in ('6.12','6.13') and status='published';
  select count(*) into v_explainers from app.topic_explainers
    where subject_key='ap_calculus_bc' and unit_number=6
      and topic_code in ('6.12','6.13') and status='published';
  if v_briefs <> 2 then
    raise exception 'expected 2 published AP Calculus BC Unit 6 new-coverage briefs, got %', v_briefs;
  end if;
  if v_explainers <> 2 then
    raise exception 'expected 2 published AP Calculus BC Unit 6 new-coverage explainers, got %', v_explainers;
  end if;

  select count(*) into v_core_matches
  from app.topic_point_briefs b
  join app.topic_explainers e on e.subject_key=b.subject_key and e.topic_code=b.topic_code
  where b.subject_key='ap_calculus_bc' and b.topic_code in ('6.12','6.13')
    and b.status='published' and e.status='published' and e.core_idea = b.what_it_is;
  if v_core_matches <> 0 then
    raise exception 'expected 0 explainers matching their brief verbatim, got %', v_core_matches;
  end if;
end $$;

commit;
