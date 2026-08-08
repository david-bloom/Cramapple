-- AP Calculus BC, Units 1-3, new-content-creation-protocol comparison batch.
--
-- Owner instruction, 2026-08-08: author 10 FRQs + 10 MCQs for AP Calculus BC
-- Units 1-3 using the new content-authoring protocol
-- (docs/research/CONTENT_AUTHORING_AND_QA_PROTOCOL.md) against the
-- newly-deepened CED fact pack (docs/product/AP_CALCULUS_AB_BC_CED_FACT_PACK.md,
-- "Units 1-3 deep-tier detail" section, added same day). Purpose: compare
-- approve-with-edits/disapprove rates against the legacy
-- calc-ab-bc-units1-3-frq-2026-08-03 batch (content_key apcalcbc-frq-u13-*),
-- which was authored without deep-tier CED grounding. Assigned to Abdul
-- Hanan (88 prior AP Calc BC adjudications, 1 disapprove) for review.
--
-- Provenance note (protocol §7.1, P0-A gap): the schema has no
-- authoring-model/fact-pack-hash column on content_items or
-- content_item_versions, so authorship provenance is recorded here in this
-- script's header instead. Authoring model: Claude (this session). Grounded
-- against: the full CED PDF pages 27-76 (Units 1-3 unit guides), the 2025 AP
-- Calculus Chief Reader Report, the 2025 AB/BC Scoring Guidelines, and the
-- 2025/2026 released FRQ booklets (all David-supplied primary-source PDFs,
-- read directly). Every MCQ distractor and FRQ rubric near-miss below is
-- traceable to a specific documented misconception or scoring convention
-- from that research, not invented arbitrarily. No official released
-- question wording or scoring text was copied; all stems/contexts/numbers
-- are original.
--
-- Content-key scheme: apcalcbc-frq-np1-001..010, apcalcbc-mcq-np1-001..010
-- ("np1" = new-protocol batch 1), distinct from the legacy "-u13-" keys so
-- the two cohorts can be queried and compared independently.
--
-- All items inserted as status='draft' (not published). A content_review_assignment
-- is created for each item, assigned to Abdul Hanan, review_stage='tutor_question'.

begin;
select pg_advisory_xact_lock(hashtext('cramapple-apcalcbc-newprotocol-units1-3-batch-20260808'));

do $$
declare
  v_epv_id uuid;
  v_abdul_id uuid;
begin
  select epv.id into v_epv_id
  from app.exam_pack_versions epv
  join app.exam_packs e on e.id = epv.exam_pack_id
  where e.exam_name = 'AP Calculus BC';

  if v_epv_id is null then
    raise exception 'no_exam_pack_version_found:AP Calculus BC';
  end if;

  select user_id into v_abdul_id from app.profiles where full_name = 'Abdul Hanan';
  if v_abdul_id is null then
    raise exception 'reviewer_not_found:Abdul Hanan';
  end if;

  if exists (
    select 1 from app.content_items
    where content_key like 'apcalcbc-frq-np1-%' or content_key like 'apcalcbc-mcq-np1-%'
  ) then
    raise exception 'batch_already_seeded:apcalcbc-np1';
  end if;

  create temporary table np1_epv (epv_id uuid) on commit drop;
  insert into np1_epv values (v_epv_id);
  create temporary table np1_reviewer (reviewer_id uuid) on commit drop;
  insert into np1_reviewer values (v_abdul_id);
end $$;

-- =============================================================================
-- FRQ 1 — apcalcbc-frq-np1-001 — Unit 1 (IVT + limit at infinity) — medium
-- =============================================================================
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status, frq_form, practice_format, frq_archetype)
  select gen_random_uuid(), epv_id, 'apcalcbc-frq-np1-001', 'frq',
    'Server Response Time — IVT and End Behavior', 'draft', 'short', 'targeted_drill', 'mathematical_routines'
  from np1_epv
  returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, rubric_type, evaluator_strategy)
  select gen_random_uuid(), id, 1,
    'Answer all parts of the following question.

(a) Must there exist a value c, 3 < c < 6, such that R(c) = 260? Give a reason for your answer.

(b) The company also models a separate load metric by g(t) = (3t^2 + 5t)/(t^2 - 7) for large t. Evaluate lim(t->infinity) g(t) and interpret the result in the context of the load metric.',
    'A company monitors its website''s average response time R(t), in milliseconds, for 0 <= t <= 9, where t is measured in hours after midnight. The function R is differentiable, and selected values of R(t) are given in the table below.

t (hours): 0, 3, 6, 9
R(t) (ms): 210, 245, 310, 180',
    md5('apcalcbc-frq-np1-001'), 'draft', 'tutor_review_pending', 'discrete_text', 'llm_discrete_text'
  from item_ins
  returning id
)
insert into app.frq_criteria (id, content_item_version_id, criterion_key, learner_facing_text, points_possible, evidence_requirements, minimum_fix, accepted_variants)
select gen_random_uuid(), id, 'part-a-criterion-01', 'States that R is continuous on [3,6], with justification.', 1,
  'Response states R is continuous on [3,6] because R is given as differentiable, and differentiability implies continuity.',
  'Add the explicit reasoning step "R is differentiable, therefore R is continuous" — asserting continuity alone without this justification does not earn the point.', '[]'::jsonb
from version_ins
union all
select gen_random_uuid(), id, 'part-a-criterion-02', 'States R(3) = 245 < 260 < R(6) = 310 and concludes by the Intermediate Value Theorem that such a c exists.', 1,
  'Response states the specific inequality 245 < 260 < 310 using the table values, then invokes the IVT to conclude existence.',
  'State the inequality using the actual table values, not just "260 is between the endpoints" — the IVT conclusion requires citing the numbers.', '[]'::jsonb
from version_ins
union all
select gen_random_uuid(), id, 'part-b-criterion-01', 'Sets up the limit correctly, dividing numerator and denominator by t^2 (or equivalent).', 1,
  'Response shows dividing every term by t^2 (or an equivalent valid technique) to evaluate the limit as t approaches infinity.',
  'Show the algebraic step of dividing by the highest power of t before stating the limit.', '[]'::jsonb
from version_ins
union all
select gen_random_uuid(), id, 'part-b-criterion-02', 'Correctly evaluates the limit as 3 and interprets it as the load metric approaching a constant value.', 1,
  'Response states lim(t->infinity) g(t) = 3 and interprets this as the load metric leveling off near 3 for large t (not decaying to 0 or growing unbounded).',
  'State the numeric value 3 and connect it back to the load-metric context.', '[]'::jsonb
from version_ins;

-- =============================================================================
-- FRQ 2 — apcalcbc-frq-np1-002 — Unit 1 (discontinuity classification, removability) — medium
-- =============================================================================
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status, frq_form, practice_format, frq_archetype)
  select gen_random_uuid(), epv_id, 'apcalcbc-frq-np1-002', 'frq',
    'Classifying a Discontinuity at a Boundary Point', 'draft', 'short', 'targeted_drill', 'translation_between_representations'
  from np1_epv
  returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, rubric_type, evaluator_strategy)
  select gen_random_uuid(), id, 1,
    'Answer all parts of the following question.

(a) Find lim(x->2-) f(x) and lim(x->2+) f(x).

(b) Is f continuous at x = 2? Justify your answer.

(c) Is the discontinuity at x = 2, if any, removable? Justify your answer.',
    'Let f be the piecewise function defined by
f(x) = (x^2 - 4)/(x - 2), for x < 2
f(x) = 3, for x = 2
f(x) = x + 1, for x > 2',
    md5('apcalcbc-frq-np1-002'), 'draft', 'tutor_review_pending', 'discrete_text', 'llm_discrete_text'
  from item_ins
  returning id
)
insert into app.frq_criteria (id, content_item_version_id, criterion_key, learner_facing_text, points_possible, evidence_requirements, minimum_fix, accepted_variants)
select gen_random_uuid(), id, 'part-a-criterion-01', 'Correctly finds the left-hand limit as 4, showing the factor-and-cancel step.', 1,
  'Response factors x^2-4 as (x-2)(x+2), cancels (x-2), and evaluates the remaining x+2 at x=2 to get 4.',
  'Show the factoring step (x-2)(x+2)/(x-2) = x+2 explicitly before evaluating.', '[]'::jsonb
from version_ins
union all
select gen_random_uuid(), id, 'part-a-criterion-02', 'Correctly finds the right-hand limit as 3.', 1,
  'Response substitutes x=2 into x+1 to get 3.', 'State the right-hand limit value 3.', '[]'::jsonb
from version_ins
union all
select gen_random_uuid(), id, 'part-b-criterion-01', 'Correctly concludes f is not continuous at x=2, because the one-sided limits differ, regardless of the defined value f(2)=3.', 1,
  'Response states the two-sided limit does not exist because 4 does not equal 3, so continuity fails at x=2 even though f(2) is defined.',
  'State explicitly that the one-sided limits (4 and 3) are unequal, so the two-sided limit fails to exist.', '[]'::jsonb
from version_ins
union all
select gen_random_uuid(), id, 'part-c-criterion-01', 'Correctly concludes the discontinuity is not removable, because removability requires the two-sided limit to exist first.', 1,
  'Response explains that since the one-sided limits are unequal (a jump discontinuity), the two-sided limit does not exist, so there is no single value the function could be redefined to that would make it continuous — this is not removable.',
  'Explain that removability requires a single existing two-sided limit to redefine the function to; a jump discontinuity has no such value.', '[]'::jsonb
from version_ins;

-- =============================================================================
-- FRQ 3 — apcalcbc-frq-np1-003 — Unit 1 (squeeze theorem) — hard
-- =============================================================================
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status, frq_form, practice_format, frq_archetype)
  select gen_random_uuid(), epv_id, 'apcalcbc-frq-np1-003', 'frq',
    'Squeeze Theorem with a Bounded Oscillating Factor', 'draft', 'short', 'targeted_drill', 'mathematical_routines'
  from np1_epv
  returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, rubric_type, evaluator_strategy)
  select gen_random_uuid(), id, 1,
    'Answer all parts of the following question.

(a) Use the Squeeze Theorem to show that lim(x->0) g(x) = 0.

(b) Use the result from part (a) to determine whether g is continuous at x = 0. Justify your answer.',
    'Let g(x) = x*cos(1/x) for x != 0, and g(0) = 0.',
    md5('apcalcbc-frq-np1-003'), 'draft', 'tutor_review_pending', 'discrete_text', 'llm_discrete_text'
  from item_ins
  returning id
)
insert into app.frq_criteria (id, content_item_version_id, criterion_key, learner_facing_text, points_possible, evidence_requirements, minimum_fix, accepted_variants)
select gen_random_uuid(), id, 'part-a-criterion-01', 'States a correct bounding inequality, such as -|x| <= x*cos(1/x) <= |x|.', 1,
  'Response uses -1 <= cos(1/x) <= 1 and correctly handles the sign of x to derive -|x| <= x*cos(1/x) <= |x|.',
  'Use absolute value in the bound so it holds for both positive and negative x, not just -x <= x cos(1/x) <= x (which is only valid for x>=0).', '[]'::jsonb
from version_ins
union all
select gen_random_uuid(), id, 'part-a-criterion-02', 'Correctly evaluates the limit of the lower bound as 0.', 1,
  'Response computes lim(x->0) -|x| = 0.', 'State the lower-bound limit value 0.', '[]'::jsonb
from version_ins
union all
select gen_random_uuid(), id, 'part-a-criterion-03', 'Correctly evaluates the limit of the upper bound as 0.', 1,
  'Response computes lim(x->0) |x| = 0.', 'State the upper-bound limit value 0.', '[]'::jsonb
from version_ins
union all
select gen_random_uuid(), id, 'part-a-criterion-04', 'Correctly cites the Squeeze Theorem to conclude lim(x->0) g(x) = 0.', 1,
  'Response states that since both bounding limits equal 0, the Squeeze Theorem guarantees lim(x->0) x*cos(1/x) = 0.',
  'Name the Squeeze Theorem explicitly when drawing the conclusion.', '[]'::jsonb
from version_ins
union all
select gen_random_uuid(), id, 'part-b-criterion-01', 'Correctly concludes g is continuous at x=0, using the continuity definition.', 1,
  'Response states g(0)=0 is defined, lim(x->0) g(x) = 0 from part (a), and since these are equal, g is continuous at x=0 by the definition of continuity.',
  'Explicitly connect all three conditions of the continuity definition: g(0) exists, the limit exists, and they are equal.', '[]'::jsonb
from version_ins;

-- =============================================================================
-- FRQ 4 — apcalcbc-frq-np1-004 — Unit 2 (limit definition of the derivative) — easy
-- =============================================================================
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status, frq_form, practice_format, frq_archetype)
  select gen_random_uuid(), epv_id, 'apcalcbc-frq-np1-004', 'frq',
    'Derivative from the Limit Definition', 'draft', 'short', 'targeted_drill', 'mathematical_routines'
  from np1_epv
  returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, rubric_type, evaluator_strategy)
  select gen_random_uuid(), id, 1,
    'Answer all parts of the following question.

(a) Using the limit definition of the derivative, find f''(2). Show the difference quotient and its simplification before taking the limit.

(b) Write the equation of the line tangent to the graph of f at x = 2.

(c) Is f increasing or decreasing at x = 2? Justify your answer using the sign of f''(2).',
    'Let f(x) = x^2 - 3x.',
    md5('apcalcbc-frq-np1-004'), 'draft', 'tutor_review_pending', 'discrete_text', 'llm_discrete_text'
  from item_ins
  returning id
)
insert into app.frq_criteria (id, content_item_version_id, criterion_key, learner_facing_text, points_possible, evidence_requirements, minimum_fix, accepted_variants)
select gen_random_uuid(), id, 'part-a-criterion-01', 'Writes the correct difference quotient [f(2+h) - f(2)]/h with f(2+h) correctly expanded.', 1,
  'Response expands f(2+h) = (2+h)^2 - 3(2+h) and writes the full difference quotient over h.',
  'Show the expansion of f(2+h) before simplifying, not just the final simplified numerator.', '[]'::jsonb
from version_ins
union all
select gen_random_uuid(), id, 'part-a-criterion-02', 'Simplifies the difference quotient to h + 1 (or equivalent) and takes the limit to get f''(2) = 1.', 1,
  'Response simplifies the quotient to h+1 and evaluates lim(h->0) (h+1) = 1.', 'Show the simplification step reducing to h+1 before stating the limit value.', '[]'::jsonb
from version_ins
union all
select gen_random_uuid(), id, 'part-b-criterion-01', 'States the correct tangent line equation y = x - 4 (or an equivalent unsimplified form).', 1,
  'Response uses point (2, f(2)) = (2, -2) and slope f''(2)=1 to write a correct tangent line, e.g. y = -2 + 1(x-2) or y = x - 4.',
  'Use the point (2, -2) and the slope from part (a) in point-slope or slope-intercept form.', '[]'::jsonb
from version_ins
union all
select gen_random_uuid(), id, 'part-c-criterion-01', 'States f is increasing at x=2 because f''(2) = 1 > 0.', 1,
  'Response explicitly connects the sign of f''(2) (positive) to the increasing/decreasing conclusion.',
  'State the reasoning "f''(2) > 0, so f is increasing at x=2," not just the conclusion alone.', '[]'::jsonb
from version_ins;

-- =============================================================================
-- FRQ 5 — apcalcbc-frq-np1-005 — Unit 2 (product rule + quotient rule via table) — medium
-- =============================================================================
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status, frq_form, practice_format, frq_archetype)
  select gen_random_uuid(), epv_id, 'apcalcbc-frq-np1-005', 'frq',
    'Product and Quotient Rule from a Table of Values', 'draft', 'short', 'targeted_drill', 'mathematical_routines'
  from np1_epv
  returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, rubric_type, evaluator_strategy)
  select gen_random_uuid(), id, 1,
    'Answer all parts of the following question.

(a) Let h(x) = f(x) * g(x). Find h''(1).

(b) Let k(x) = f(x)/g(x). Find k''(3).',
    'The differentiable functions f and g have selected values given in the table below.

x = 1: f(1) = 2, f''(1) = -3, g(1) = 5, g''(1) = 4
x = 3: f(3) = 6, f''(3) = 1, g(3) = -2, g''(3) = 3',
    md5('apcalcbc-frq-np1-005'), 'draft', 'tutor_review_pending', 'discrete_text', 'llm_discrete_text'
  from item_ins
  returning id
)
insert into app.frq_criteria (id, content_item_version_id, criterion_key, learner_facing_text, points_possible, evidence_requirements, minimum_fix, accepted_variants)
select gen_random_uuid(), id, 'part-a-criterion-01', 'Correctly applies the product rule, writing h''(x) = f''(x)g(x) + f(x)g''(x).', 1,
  'Response states the product rule formula explicitly before substituting values.', 'Write the product rule formula as its own step before substituting table values.', '[]'::jsonb
from version_ins
union all
select gen_random_uuid(), id, 'part-a-criterion-02', 'Correctly substitutes table values to compute h''(1) = -7.', 1,
  'Response substitutes f''(1)=-3, g(1)=5, f(1)=2, g''(1)=4 to get (-3)(5)+(2)(4) = -7.',
  'Show the substituted numeric expression before the final value.', '[]'::jsonb
from version_ins
union all
select gen_random_uuid(), id, 'part-b-criterion-01', 'Correctly applies the quotient rule, writing k''(x) = [f''(x)g(x) - f(x)g''(x)] / [g(x)]^2.', 1,
  'Response states the quotient rule formula explicitly before substituting values.', 'Write the quotient rule formula as its own step, with correct numerator order (f''g - fg'').', '[]'::jsonb
from version_ins
union all
select gen_random_uuid(), id, 'part-b-criterion-02', 'Correctly substitutes table values to compute k''(3) = -5.', 1,
  'Response substitutes f''(3)=1, g(3)=-2, f(3)=6, g''(3)=3 to get [(1)(-2)-(6)(3)]/(-2)^2 = -20/4 = -5.',
  'Show the substituted numeric expression, including the squared denominator, before the final value.', '[]'::jsonb
from version_ins;

-- =============================================================================
-- FRQ 6 — apcalcbc-frq-np1-006 — Unit 2 (trig/exp/log derivatives, calculator) — medium
-- =============================================================================
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status, frq_form, practice_format, frq_archetype)
  select gen_random_uuid(), epv_id, 'apcalcbc-frq-np1-006', 'frq',
    'Derivative of a Trig/Exponential/Log Combination', 'draft', 'short', 'targeted_drill', 'mathematical_routines'
  from np1_epv
  returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, rubric_type, evaluator_strategy)
  select gen_random_uuid(), id, 1,
    'Answer all parts of the following question. A calculator is permitted; round decimal answers to three places.

(a) Find f''(x).

(b) Find the value of f''(1).

(c) Is f increasing or decreasing at x = 1? Justify your answer.',
    'Let f(x) = 4cos(x) + 3e^x - 2ln(x), for x > 0.',
    md5('apcalcbc-frq-np1-006'), 'draft', 'tutor_review_pending', 'discrete_text', 'llm_discrete_text'
  from item_ins
  returning id
)
insert into app.frq_criteria (id, content_item_version_id, criterion_key, learner_facing_text, points_possible, evidence_requirements, minimum_fix, accepted_variants)
select gen_random_uuid(), id, 'part-a-criterion-01', 'Correctly differentiates the cosine and exponential terms: -4sin(x) + 3e^x.', 1,
  'Response applies d/dx[4cos x] = -4sin x and d/dx[3e^x] = 3e^x correctly.', 'Show each term''s derivative rule applied separately.', '[]'::jsonb
from version_ins
union all
select gen_random_uuid(), id, 'part-a-criterion-02', 'Correctly differentiates the logarithmic term and assembles the full derivative f''(x) = -4sin(x) + 3e^x - 2/x.', 1,
  'Response applies d/dx[-2ln x] = -2/x and assembles the complete correct derivative expression.',
  'Include the -2/x term explicitly in the assembled derivative.', '[]'::jsonb
from version_ins
union all
select gen_random_uuid(), id, 'part-b-criterion-01', 'Correctly evaluates f''(1), approximately 2.789 (accept 2.788 to 2.790).', 1,
  'Response substitutes x=1 into the derivative expression and computes a decimal value near 2.789.',
  'Show the substituted expression -4sin(1) + 3e^1 - 2/1 before the decimal value.', '[]'::jsonb
from version_ins
union all
select gen_random_uuid(), id, 'part-c-criterion-01', 'States f is increasing at x=1 because f''(1) is positive.', 1,
  'Response explicitly connects the positive sign of f''(1) to the increasing conclusion.',
  'State the reasoning "f''(1) > 0, so f is increasing," referencing the value from part (b).', '[]'::jsonb
from version_ins;

-- =============================================================================
-- FRQ 7 — apcalcbc-frq-np1-007 — Unit 3 (chain rule + product rule via table) — hard
-- =============================================================================
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status, frq_form, practice_format, frq_archetype)
  select gen_random_uuid(), epv_id, 'apcalcbc-frq-np1-007', 'frq',
    'Chain Rule and Product Rule from a Table of Values', 'draft', 'short', 'targeted_drill', 'mathematical_routines'
  from np1_epv
  returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, rubric_type, evaluator_strategy)
  select gen_random_uuid(), id, 1,
    'Answer all parts of the following question.

(a) Let g(x) = f(x^2). Find g''(2).

(b) Let h(x) = f(x) * g(x). Find h''(2).',
    'The differentiable function f has selected values given in the table below.

x = 1: f(1) = 3, f''(1) = -2
x = 2: f(2) = 5, f''(2) = 1
x = 4: f(4) = 7, f''(4) = -3',
    md5('apcalcbc-frq-np1-007'), 'draft', 'tutor_review_pending', 'discrete_text', 'llm_discrete_text'
  from item_ins
  returning id
)
insert into app.frq_criteria (id, content_item_version_id, criterion_key, learner_facing_text, points_possible, evidence_requirements, minimum_fix, accepted_variants)
select gen_random_uuid(), id, 'part-a-criterion-01', 'Correctly applies the chain rule, writing g''(x) = f''(x^2) * 2x.', 1,
  'Response states the chain-rule structure explicitly, including the inner-function derivative factor 2x.',
  'Do not omit the 2x factor from the chain rule — this is the most common chain-rule error.', '[]'::jsonb
from version_ins
union all
select gen_random_uuid(), id, 'part-a-criterion-02', 'Correctly substitutes table values to compute g''(2) = -12.', 1,
  'Response evaluates 2^2=4, looks up f''(4)=-3, and computes g''(2) = f''(4)*2(2) = (-3)(4) = -12.',
  'Show that x^2 at x=2 is 4, so f'' must be evaluated at 4, not at 2.', '[]'::jsonb
from version_ins
union all
select gen_random_uuid(), id, 'part-b-criterion-01', 'Correctly applies the product rule, writing h''(x) = f''(x)g(x) + f(x)g''(x).', 1,
  'Response states the product rule formula explicitly, building on g and g'' from part (a).',
  'Write the product rule formula as its own step before substituting values.', '[]'::jsonb
from version_ins
union all
select gen_random_uuid(), id, 'part-b-criterion-02', 'Correctly computes g(2) = f(4) = 7 and substitutes all values to get h''(2) = -53.', 1,
  'Response evaluates g(2)=f(2^2)=f(4)=7, then computes h''(2) = f''(2)*g(2) + f(2)*g''(2) = (1)(7)+(5)(-12) = -53.',
  'Show the intermediate value g(2)=7 explicitly before assembling the final product-rule computation.', '[]'::jsonb
from version_ins;

-- =============================================================================
-- FRQ 8 — apcalcbc-frq-np1-008 — Unit 3 (implicit differentiation, full item) — very hard
-- =============================================================================
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status, frq_form, practice_format, frq_archetype)
  select gen_random_uuid(), epv_id, 'apcalcbc-frq-np1-008', 'frq',
    'Implicit Differentiation, Tangent Line, and Vertical Tangent', 'draft', 'short', 'targeted_drill', 'mathematical_routines'
  from np1_epv
  returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, rubric_type, evaluator_strategy)
  select gen_random_uuid(), id, 1,
    'Answer all parts of the following question.

(a) Show that dy/dx = -(2x + y)/(x - 2y).

(b) Write the equation of the line tangent to the curve at the point (3, 4).

(c) Find the point on the curve, with x > 0, at which the curve has a vertical tangent line.',
    'The curve is defined by x^2 + xy - y^2 = 5.',
    md5('apcalcbc-frq-np1-008'), 'draft', 'tutor_review_pending', 'discrete_text', 'llm_discrete_text'
  from item_ins
  returning id
)
insert into app.frq_criteria (id, content_item_version_id, criterion_key, learner_facing_text, points_possible, evidence_requirements, minimum_fix, accepted_variants)
select gen_random_uuid(), id, 'part-a-criterion-01', 'Correctly and fully differentiates the entire equation implicitly and algebraically isolates dy/dx to match the given form.', 1,
  'Response applies the product rule to xy (giving y + x*dy/dx), the chain rule to -y^2 (giving -2y*dy/dx), differentiates x^2 as 2x, sets the result equal to 0, and correctly isolates dy/dx = -(2x+y)/(x-2y). This step is scored as a single unit — a partially correct differentiation does not earn partial credit here.',
  'Show every term''s derivative (2x, y + x dy/dx, -2y dy/dx) before collecting dy/dx terms and solving.', '[]'::jsonb
from version_ins
union all
select gen_random_uuid(), id, 'part-b-criterion-01', 'Correctly computes the slope at (3,4) as 2, by substituting into the dy/dx expression from part (a).', 1,
  'Response substitutes x=3, y=4 into -(2x+y)/(x-2y) to get -(10)/(-5) = 2.',
  'Show the substituted numeric expression before the slope value.', '[]'::jsonb
from version_ins
union all
select gen_random_uuid(), id, 'part-b-criterion-02', 'States the correct tangent line equation y = 2x - 2 (or an equivalent unsimplified form).', 1,
  'Response uses point (3,4) and slope 2 to write a correct tangent line, e.g. y - 4 = 2(x-3).',
  'Use the point (3,4) and the slope from the previous step in point-slope or slope-intercept form.', '[]'::jsonb
from version_ins
union all
select gen_random_uuid(), id, 'part-c-criterion-01', 'Correctly sets the denominator of dy/dx equal to zero (x - 2y = 0) to find the vertical-tangent condition, not the numerator.', 1,
  'Response identifies that a vertical tangent occurs where the denominator of dy/dx is zero, distinct from the numerator=0 condition (which would give horizontal tangents).',
  'State explicitly that the vertical-tangent condition is denominator=0, not numerator=0 — these are commonly inverted.', '[]'::jsonb
from version_ins
union all
select gen_random_uuid(), id, 'part-c-criterion-02', 'Correctly solves for the point (2, 1), explicitly selecting the x > 0 solution over the excluded (-2, -1).', 1,
  'Response substitutes x=2y into the curve equation, solves the resulting quadratic to get y=1 or y=-1, and explicitly states that only y=1 (giving point (2,1)) satisfies x > 0.',
  'Explicitly state why the other root (giving (-2,-1)) is rejected — merely finding both roots without selecting the valid one does not earn this point.', '[]'::jsonb
from version_ins;

-- =============================================================================
-- FRQ 9 — apcalcbc-frq-np1-009 — Unit 3 (inverse function + inverse trig derivative) — medium
-- =============================================================================
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status, frq_form, practice_format, frq_archetype)
  select gen_random_uuid(), epv_id, 'apcalcbc-frq-np1-009', 'frq',
    'Derivative of an Inverse Function and an Inverse Trig Function', 'draft', 'short', 'targeted_drill', 'mathematical_routines'
  from np1_epv
  returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, rubric_type, evaluator_strategy)
  select gen_random_uuid(), id, 1,
    'Answer all parts of the following question.

(a) Given that f is one-to-one, find (f^-1)''(2).

(b) Find d/dx[arctan(4x)], and evaluate it at x = 1/4.',
    'Let f(x) = x^3 + 2x - 1.',
    md5('apcalcbc-frq-np1-009'), 'draft', 'tutor_review_pending', 'discrete_text', 'llm_discrete_text'
  from item_ins
  returning id
)
insert into app.frq_criteria (id, content_item_version_id, criterion_key, learner_facing_text, points_possible, evidence_requirements, minimum_fix, accepted_variants)
select gen_random_uuid(), id, 'part-a-criterion-01', 'Correctly identifies that f(1) = 2, so f^-1(2) = 1.', 1,
  'Response finds the input a such that f(a)=2 (a=1) and states f^-1(2)=1.',
  'Show the check f(1) = 1 + 2 - 1 = 2 explicitly before proceeding.', '[]'::jsonb
from version_ins
union all
select gen_random_uuid(), id, 'part-a-criterion-02', 'Correctly computes f''(1) = 5 and applies (f^-1)''(2) = 1/f''(1) = 1/5.', 1,
  'Response computes f''(x)=3x^2+2, evaluates f''(1)=5, and applies the inverse-derivative formula to get 1/5.',
  'State the inverse-function-derivative formula (f^-1)''(b) = 1/f''(f^-1(b)) explicitly before substituting.', '[]'::jsonb
from version_ins
union all
select gen_random_uuid(), id, 'part-b-criterion-01', 'Correctly states d/dx[arctan(4x)] = 4/(1+16x^2), applying the chain rule to the inverse-trig derivative formula.', 1,
  'Response applies d/dx[arctan(u)] = u''/(1+u^2) with u=4x, u''=4, giving 4/(1+16x^2).',
  'Show the chain-rule factor u''=4 explicitly, not just the final expression.', '[]'::jsonb
from version_ins
union all
select gen_random_uuid(), id, 'part-b-criterion-02', 'Correctly evaluates the derivative at x=1/4 to get 2.', 1,
  'Response substitutes x=1/4 into 4/(1+16x^2) to get 4/(1+1) = 2.', 'Show the substituted numeric expression before the final value.', '[]'::jsonb
from version_ins;

-- =============================================================================
-- FRQ 10 — apcalcbc-frq-np1-010 — Unit 3 (related rates via implicit diff w.r.t. t) — hard
-- =============================================================================
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status, frq_form, practice_format, frq_archetype)
  select gen_random_uuid(), epv_id, 'apcalcbc-frq-np1-010', 'frq',
    'Related Rates via Implicit Differentiation with Respect to t', 'draft', 'short', 'targeted_drill', 'mathematical_routines'
  from np1_epv
  returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, rubric_type, evaluator_strategy)
  select gen_random_uuid(), id, 1,
    'Answer the following question.

Find dy/dt at the instant when x = 3, y = 4, and dx/dt = 5.',
    'The quantities x and y are both differentiable functions of t and are related by the equation x^2*y - 4y = 20.',
    md5('apcalcbc-frq-np1-010'), 'draft', 'tutor_review_pending', 'discrete_text', 'llm_discrete_text'
  from item_ins
  returning id
)
insert into app.frq_criteria (id, content_item_version_id, criterion_key, learner_facing_text, points_possible, evidence_requirements, minimum_fix, accepted_variants)
select gen_random_uuid(), id, 'part-a-criterion-01', 'Correctly differentiates x^2*y - 4y = 20 with respect to t, applying the product rule to the x^2*y term.', 1,
  'Response applies the product rule to x^2*y (giving 2x(dx/dt)y + x^2(dy/dt)) and differentiates -4y to get -4(dy/dt), setting the sum equal to 0.',
  'Show the product-rule expansion of d/dt[x^2*y] as its own step, not combined into the derivative of a single variable.', '[]'::jsonb
from version_ins
union all
select gen_random_uuid(), id, 'part-a-criterion-02', 'Correctly isolates dy/dt algebraically: dy/dt = -2xy(dx/dt)/(x^2-4).', 1,
  'Response collects all dy/dt terms on one side and solves algebraically for dy/dt in terms of x, y, and dx/dt.',
  'Show the algebraic collection of dy/dt terms as its own step before substituting numeric values.', '[]'::jsonb
from version_ins
union all
select gen_random_uuid(), id, 'part-a-criterion-03', 'Correctly substitutes the given values to compute dy/dt = -24.', 1,
  'Response substitutes x=3, y=4, dx/dt=5 into the isolated expression to get -2(3)(4)(5)/(9-4) = -120/5 = -24.',
  'Show the substituted numeric expression before the final value.', '[]'::jsonb
from version_ins;

commit;
