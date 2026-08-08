-- AP Calculus AB, new-protocol replication batch 2 (np2) -- FRQs.
-- Owner instruction: replicate the BC np1 zero-defect result with a fresh
-- batch, same protocol including hand verification, spanning AB Units 4-8
-- (the units researched in the 2026-08-08 CED deepening, distinct from the
-- BC np1 batch's Units 1-3 focus). Assigned to Abdul Hanan.
-- Content-key scheme: apcalcab-frq-np2-001..010.
begin;
select pg_advisory_xact_lock(hashtext('cramapple-apcalcab-np2-frq-20260808'));

with epv as (select '826c8cf1-bc1b-4f2a-bd33-61a758e1487d'::uuid as epv_id),
item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status, frq_form, practice_format, frq_archetype)
  select gen_random_uuid(), epv_id, 'apcalcab-frq-np2-001', 'frq', 'Related Rates via an Implicit Curve', 'draft', 'short', 'targeted_drill', 'mathematical_routines' from epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, rubric_type, evaluator_strategy)
  select gen_random_uuid(), id, 1, 'Answer the following question.

Find dy/dt at the instant when x = 2, y = 3, and dx/dt = 4.',
  'The quantities x and y are both differentiable functions of t and are related by the equation xy^2 - 3y = x^2 + 5.',
  md5('apcalcab-frq-np2-001'), 'draft', 'tutor_review_pending', 'discrete_text', 'llm_discrete_text' from item_ins returning id
)
insert into app.frq_criteria (id, content_item_version_id, criterion_key, learner_facing_text, points_possible, evidence_requirements, minimum_fix, accepted_variants)
select gen_random_uuid(), id, 'part-a-criterion-01', 'Correctly differentiates xy^2 - 3y = x^2 + 5 with respect to t, applying the product rule to xy^2.', 1,
  'Response applies the product rule to xy^2 (giving y^2(dx/dt) + 2xy(dy/dt)) and differentiates -3y to -3(dy/dt), setting the sum equal to 2x(dx/dt).',
  'Show the product-rule expansion of d/dt[xy^2] as its own step.', '[]'::jsonb from version_ins
union all select gen_random_uuid(), id, 'part-a-criterion-02', 'Correctly isolates dy/dt algebraically: dy/dt = (2x-y^2)(dx/dt)/(2xy-3).', 1,
  'Response collects all dy/dt terms on one side and solves algebraically for dy/dt.',
  'Show the algebraic collection of dy/dt terms as its own step before substituting numeric values.', '[]'::jsonb from version_ins
union all select gen_random_uuid(), id, 'part-a-criterion-03', 'Correctly substitutes the given values to compute dy/dt = -20/9.', 1,
  'Response substitutes x=2, y=3, dx/dt=4 into the isolated expression to get (4-9)(4)/(12-3) = -20/9.',
  'Show the substituted numeric expression before the final value.', '[]'::jsonb from version_ins;

with epv as (select '826c8cf1-bc1b-4f2a-bd33-61a758e1487d'::uuid as epv_id),
item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status, frq_form, practice_format, frq_archetype)
  select gen_random_uuid(), epv_id, 'apcalcab-frq-np2-002', 'frq', 'Linearization and Over/Under-Estimate Justification', 'draft', 'short', 'targeted_drill', 'mathematical_routines' from epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, rubric_type, evaluator_strategy)
  select gen_random_uuid(), id, 1, 'Answer all parts of the following question.

(a) Find f''(x) and f''(8).

(b) Write the linearization L(x) of f at x=8.

(c) Use L to approximate the cube root of 8.6, and state whether this approximation is an overestimate or underestimate of the actual value. Justify using concavity.',
  'Let f(x) = the cube root of x (x^(1/3)).',
  md5('apcalcab-frq-np2-002'), 'draft', 'tutor_review_pending', 'discrete_text', 'llm_discrete_text' from item_ins returning id
)
insert into app.frq_criteria (id, content_item_version_id, criterion_key, learner_facing_text, points_possible, evidence_requirements, minimum_fix, accepted_variants)
select gen_random_uuid(), id, 'part-a-criterion-01', 'Correctly finds f''(x) = (1/3)x^(-2/3).', 1, 'Response applies the power rule to x^(1/3).', 'Show the power-rule application as its own step.', '[]'::jsonb from version_ins
union all select gen_random_uuid(), id, 'part-a-criterion-02', 'Correctly evaluates f''(8) = 1/12.', 1, 'Response substitutes x=8 (8^(2/3)=4) to get (1/3)(1/4)=1/12.', 'Show 8^(2/3)=4 explicitly before the final value.', '[]'::jsonb from version_ins
union all select gen_random_uuid(), id, 'part-b-criterion-01', 'States the correct linearization L(x) = 2 + (1/12)(x-8).', 1, 'Response uses point (8,2) and slope 1/12 in point-slope or slope-intercept form.', 'Use the point (8,2) and the slope from part (a).', '[]'::jsonb from version_ins
union all select gen_random_uuid(), id, 'part-c-criterion-01', 'Correctly computes L(8.6) = 2.05.', 1, 'Response substitutes x=8.6 into L(x) to get 2+(1/12)(0.6)=2.05.', 'Show the substituted numeric expression before the value.', '[]'::jsonb from version_ins
union all select gen_random_uuid(), id, 'part-c-criterion-02', 'Correctly identifies the approximation as an overestimate, because f is concave down (f''''(x)<0) near x=8, so the tangent line lies above the curve.', 1,
  'Response states f is concave down near x=8 (f prime prime negative) and concludes the tangent-line approximation is an overestimate.',
  'State the concavity reasoning explicitly, not just the conclusion.', '[]'::jsonb from version_ins;

with epv as (select '826c8cf1-bc1b-4f2a-bd33-61a758e1487d'::uuid as epv_id),
item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status, frq_form, practice_format, frq_archetype)
  select gen_random_uuid(), epv_id, 'apcalcab-frq-np2-003', 'frq', 'Absolute Extrema via the Candidates Test', 'draft', 'short', 'targeted_drill', 'mathematical_routines' from epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, rubric_type, evaluator_strategy)
  select gen_random_uuid(), id, 1, 'Answer all parts of the following question.

(a) Find f''(x) and the critical points of f in [-1,3].

(b) Use the Candidates Test to find the absolute maximum and absolute minimum values of f on [-1,3].',
  'Let f(x) = x^4 - 8x^2 + 3.',
  md5('apcalcab-frq-np2-003'), 'draft', 'tutor_review_pending', 'discrete_text', 'llm_discrete_text' from item_ins returning id
)
insert into app.frq_criteria (id, content_item_version_id, criterion_key, learner_facing_text, points_possible, evidence_requirements, minimum_fix, accepted_variants)
select gen_random_uuid(), id, 'part-a-criterion-01', 'Correctly finds f''(x) = 4x^3 - 16x = 4x(x-2)(x+2).', 1, 'Response differentiates and factors correctly.', 'Show the factored form.', '[]'::jsonb from version_ins
union all select gen_random_uuid(), id, 'part-a-criterion-02', 'Correctly identifies the critical points in [-1,3] as x=0 and x=2 (x=-2 is outside the interval).', 1, 'Response sets f''(x)=0 and identifies only x=0, x=2 as being within [-1,3].', 'Explicitly exclude x=-2 as outside the given interval.', '[]'::jsonb from version_ins
union all select gen_random_uuid(), id, 'part-b-criterion-01', 'Evaluates f at every critical point AND both endpoints: f(-1)=-4, f(0)=3, f(2)=-13, f(3)=12.', 1, 'Response shows all four evaluations as a global argument, not a local-test shortcut.', 'Evaluate at all four points explicitly -- a local derivative-test argument alone does not earn this point.', '[]'::jsonb from version_ins
union all select gen_random_uuid(), id, 'part-b-criterion-02', 'Correctly states the absolute maximum is 12 at x=3.', 1, 'Response identifies the largest value among the four evaluations.', 'State both the value and the location.', '[]'::jsonb from version_ins
union all select gen_random_uuid(), id, 'part-b-criterion-03', 'Correctly states the absolute minimum is -13 at x=2.', 1, 'Response identifies the smallest value among the four evaluations.', 'State both the value and the location.', '[]'::jsonb from version_ins;

with epv as (select '826c8cf1-bc1b-4f2a-bd33-61a758e1487d'::uuid as epv_id),
item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status, frq_form, practice_format, frq_archetype)
  select gen_random_uuid(), epv_id, 'apcalcab-frq-np2-004', 'frq', 'Critical Point Without a Sign Change', 'draft', 'short', 'targeted_drill', 'mathematical_routines' from epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, rubric_type, evaluator_strategy)
  select gen_random_uuid(), id, 1, 'Answer all parts of the following question.

(a) Find the critical points of g.

(b) Determine the intervals on which g is increasing and decreasing, using a sign analysis of g''(x).

(c) Does g have a local extremum at x=4? Justify your answer.',
  'Let g be a function whose derivative is g''(x) = (x-1)(x-4)^2 for all real x.',
  md5('apcalcab-frq-np2-004'), 'draft', 'tutor_review_pending', 'discrete_text', 'llm_discrete_text' from item_ins returning id
)
insert into app.frq_criteria (id, content_item_version_id, criterion_key, learner_facing_text, points_possible, evidence_requirements, minimum_fix, accepted_variants)
select gen_random_uuid(), id, 'part-a-criterion-01', 'Correctly identifies the critical points as x=1 and x=4 (where g''(x)=0).', 1, 'Response sets (x-1)(x-4)^2=0 and finds x=1, x=4.', 'Show both critical points explicitly.', '[]'::jsonb from version_ins
union all select gen_random_uuid(), id, 'part-b-criterion-01', 'Correctly determines g''(x)<0 for x<1 and g''(x)>0 for x>1 (x != 4), noting (x-4)^2 does not change sign.', 1, 'Response performs a sign analysis using test points, recognizing the squared factor is always non-negative.', 'Show the sign analysis, noting that (x-4)^2 >= 0 always and does not affect the sign determined by (x-1).', '[]'::jsonb from version_ins
union all select gen_random_uuid(), id, 'part-b-criterion-02', 'Correctly concludes g is decreasing on (-infinity, 1) and increasing on (1, infinity).', 1, 'Response states the correct increasing/decreasing intervals based on the sign analysis.', 'State both intervals explicitly.', '[]'::jsonb from version_ins
union all select gen_random_uuid(), id, 'part-c-criterion-01', 'Correctly concludes g does NOT have a local extremum at x=4, because g''(x) does not change sign at x=4 (the squared factor touches zero without changing sign).', 1,
  'Response explains that although x=4 is a critical point, g is increasing on both sides of x=4 (no sign change in g''), so it is not a local extremum.',
  'State explicitly that a critical point is not automatically a local extremum unless the derivative changes sign there.', '[]'::jsonb from version_ins;

commit;
select 'AB FRQ 1-4 inserted' as status;
