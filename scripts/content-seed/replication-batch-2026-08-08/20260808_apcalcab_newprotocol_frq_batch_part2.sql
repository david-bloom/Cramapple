-- AP Calculus AB, new-protocol replication batch 2 (np2) -- FRQs 5-10.
-- Continuation of 20260808_apcalcab_newprotocol_frq_batch.sql (items 1-4).
begin;

with epv as (select '826c8cf1-bc1b-4f2a-bd33-61a758e1487d'::uuid as epv_id),
item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status, frq_form, practice_format, frq_archetype)
  select gen_random_uuid(), epv_id, 'apcalcab-frq-np2-005', 'frq', 'Accumulation Function: FTC and Net Change', 'draft', 'short', 'targeted_drill', 'mathematical_routines' from epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, rubric_type, evaluator_strategy)
  select gen_random_uuid(), id, 1, 'Answer all parts of the following question.

(a) Find g''(x).

(b) Find the x-coordinate where g attains a local maximum, and justify your answer.

(c) Find g(2), the net change of the accumulated integral from t=1 to t=2.',
  'Let g(x) = the definite integral from 1 to x of (3 - t^2) dt, for all real x.',
  md5('apcalcab-frq-np2-005'), 'draft', 'tutor_review_pending', 'discrete_text', 'llm_discrete_text' from item_ins returning id
)
insert into app.frq_criteria (id, content_item_version_id, criterion_key, learner_facing_text, points_possible, evidence_requirements, minimum_fix, accepted_variants)
select gen_random_uuid(), id, 'part-a-criterion-01', 'States the Fundamental Theorem of Calculus form g''(x) = f(x).', 1, 'Response explicitly states g''(x)=f(x) by FTC before substituting.', 'State the FTC relationship as its own step.', '[]'::jsonb from version_ins
union all select gen_random_uuid(), id, 'part-a-criterion-02', 'Correctly evaluates g''(x) = 3 - x^2.', 1, 'Response substitutes the integrand to get 3-x^2.', 'Show the substituted integrand.', '[]'::jsonb from version_ins
union all select gen_random_uuid(), id, 'part-b-criterion-01', 'Correctly sets g''(x)=0 to find x = plus or minus the square root of 3.', 1, 'Response solves 3-x^2=0.', 'Show the equation-solving step.', '[]'::jsonb from version_ins
union all select gen_random_uuid(), id, 'part-b-criterion-02', 'Correctly justifies a local maximum at x = the square root of 3, using a sign change of g'' from positive to negative (First Derivative Test).', 1,
  'Response shows g''(x)>0 for x less than the square root of 3 and g''(x)<0 for x greater than it, concluding a local maximum.',
  'Show the sign analysis explicitly, not just the conclusion.', '[]'::jsonb from version_ins
union all select gen_random_uuid(), id, 'part-c-criterion-01', 'Sets up the correct antiderivative 3t - t^3/3 evaluated from 1 to 2.', 1, 'Response shows the antiderivative before evaluating.', 'Show the antiderivative as its own step.', '[]'::jsonb from version_ins
union all select gen_random_uuid(), id, 'part-c-criterion-02', 'Correctly evaluates g(2) = 2/3.', 1, 'Response evaluates (6-8/3)-(3-1/3) = 2/3.', 'Show the substituted numeric expression before the final value.', '[]'::jsonb from version_ins;

with epv as (select '826c8cf1-bc1b-4f2a-bd33-61a758e1487d'::uuid as epv_id),
item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status, frq_form, practice_format, frq_archetype)
  select gen_random_uuid(), epv_id, 'apcalcab-frq-np2-006', 'frq', 'Trapezoidal Sum from a Data Table', 'draft', 'short', 'targeted_drill', 'mathematical_routines' from epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, rubric_type, evaluator_strategy)
  select gen_random_uuid(), id, 1, 'Approximate the total distance traveled from t=0 to t=9 hours using a trapezoidal sum with the subintervals indicated by the table, and interpret the result with units.',
  'A vehicle''s speed v(t), in miles per hour, is recorded at selected times t, in hours.

t (hours): 0, 2, 5, 9
v(t) (mph): 3, 7, 12, 20',
  md5('apcalcab-frq-np2-006'), 'draft', 'tutor_review_pending', 'discrete_text', 'llm_discrete_text' from item_ins returning id
)
insert into app.frq_criteria (id, content_item_version_id, criterion_key, learner_facing_text, points_possible, evidence_requirements, minimum_fix, accepted_variants)
select gen_random_uuid(), id, 'criterion-01', 'Correctly sets up the trapezoidal sum using the three given subintervals: (2/2)(3+7) + (3/2)(7+12) + (4/2)(12+20).', 1,
  'Response shows each trapezoid''s width and endpoint-average pair explicitly, matching the unequal subinterval widths in the table.',
  'Show all three trapezoid terms with correct widths before combining.', '[]'::jsonb from version_ins
union all select gen_random_uuid(), id, 'criterion-02', 'Correctly evaluates the sum to 102.5.', 1, 'Response computes 10 + 28.5 + 64 = 102.5.', 'Show the three partial products before the total.', '[]'::jsonb from version_ins
union all select gen_random_uuid(), id, 'criterion-03', 'Correctly interprets the result as approximately 102.5 miles, the total distance traveled over the 9 hours.', 1, 'Response states the units (miles) and connects the value to total distance.', 'State the units and context explicitly.', '[]'::jsonb from version_ins;

with epv as (select '826c8cf1-bc1b-4f2a-bd33-61a758e1487d'::uuid as epv_id),
item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status, frq_form, practice_format, frq_archetype)
  select gen_random_uuid(), epv_id, 'apcalcab-frq-np2-007', 'frq', 'Separable Differential Equation with an Initial Condition', 'draft', 'short', 'targeted_drill', 'mathematical_routines' from epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, rubric_type, evaluator_strategy)
  select gen_random_uuid(), id, 1, 'Find the particular solution y = f(x) to the differential equation that satisfies the given initial condition.',
  'dy/dx = xy/3, and y(0) = 5.',
  md5('apcalcab-frq-np2-007'), 'draft', 'tutor_review_pending', 'discrete_text', 'llm_discrete_text' from item_ins returning id
)
insert into app.frq_criteria (id, content_item_version_id, criterion_key, learner_facing_text, points_possible, evidence_requirements, minimum_fix, accepted_variants)
select gen_random_uuid(), id, 'criterion-01', 'Correctly separates the variables and antidifferentiates both sides to get the general solution form ln|y| = x^2/6 + C.', 1,
  'Response separates dy/y = (x/3)dx and integrates both sides, including the constant of integration.',
  'Show the separation step and both antiderivatives explicitly; omitting the constant of integration blocks this point.', '[]'::jsonb from version_ins
union all select gen_random_uuid(), id, 'criterion-02', 'Correctly uses the initial condition y(0)=5 to find C = ln5.', 1, 'Response substitutes x=0, y=5 into the general solution to solve for C.', 'Show the substitution step.', '[]'::jsonb from version_ins
union all select gen_random_uuid(), id, 'criterion-03', 'Correctly solves explicitly for y to get y = 5e^(x^2/6).', 1, 'Response exponentiates and resolves the sign using the initial condition to state the final explicit solution.', 'State the final explicit form for y, not just the implicit ln form.', '[]'::jsonb from version_ins;

with epv as (select '826c8cf1-bc1b-4f2a-bd33-61a758e1487d'::uuid as epv_id),
item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status, frq_form, practice_format, frq_archetype)
  select gen_random_uuid(), epv_id, 'apcalcab-frq-np2-008', 'frq', 'Exponential Growth Model from a Differential Equation', 'draft', 'short', 'targeted_drill', 'mathematical_routines' from epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, rubric_type, evaluator_strategy)
  select gen_random_uuid(), id, 1, 'A calculator is permitted; round decimal answers to three places.

(a) Solve for P(t).

(b) Find P(10).

(c) Find the time t at which P reaches 5000.',
  'A population P satisfies dP/dt = 0.04P, with P(0) = 2000.',
  md5('apcalcab-frq-np2-008'), 'draft', 'tutor_review_pending', 'discrete_text', 'llm_discrete_text' from item_ins returning id
)
insert into app.frq_criteria (id, content_item_version_id, criterion_key, learner_facing_text, points_possible, evidence_requirements, minimum_fix, accepted_variants)
select gen_random_uuid(), id, 'part-a-criterion-01', 'Correctly states P(t) = 2000e^(0.04t), using the dP/dt=kP exponential model form.', 1,
  'Response recognizes dP/dt=kP has solution P(t)=P0*e^(kt) and substitutes P0=2000, k=0.04.', 'State the general exponential-model solution form before substituting values.', '[]'::jsonb from version_ins
union all select gen_random_uuid(), id, 'part-b-criterion-01', 'Correctly evaluates P(10) is approximately 2983.653.', 1, 'Response substitutes t=10 into P(t) and computes the decimal value.', 'Show the substituted expression 2000e^0.4 before the decimal value.', '[]'::jsonb from version_ins
union all select gen_random_uuid(), id, 'part-c-criterion-01', 'Correctly sets up the equation 2000e^(0.04t) = 5000.', 1, 'Response sets P(t) equal to 5000.', 'Show the equation as its own step.', '[]'::jsonb from version_ins
union all select gen_random_uuid(), id, 'part-c-criterion-02', 'Correctly solves to get t is approximately 22.907.', 1, 'Response isolates e^(0.04t)=2.5, takes ln, and divides by 0.04 to get t=ln(2.5)/0.04.', 'Show the algebraic isolation steps before the decimal value.', '[]'::jsonb from version_ins;

with epv as (select '826c8cf1-bc1b-4f2a-bd33-61a758e1487d'::uuid as epv_id),
item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status, frq_form, practice_format, frq_archetype)
  select gen_random_uuid(), epv_id, 'apcalcab-frq-np2-009', 'frq', 'Average Value vs. Average Rate of Change', 'draft', 'short', 'targeted_drill', 'mathematical_routines' from epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, rubric_type, evaluator_strategy)
  select gen_random_uuid(), id, 1, 'Answer all parts of the following question.

(a) Find the average value of r on [0, 2*pi].

(b) Find the average rate of change of r on [0, 2*pi].

(c) Explain why these two answers are different measures of the same function.',
  'Let r(t) = 4 + 3sin(t) model a flow rate, in liters per minute, for 0 <= t <= 2*pi.',
  md5('apcalcab-frq-np2-009'), 'draft', 'tutor_review_pending', 'discrete_text', 'llm_discrete_text' from item_ins returning id
)
insert into app.frq_criteria (id, content_item_version_id, criterion_key, learner_facing_text, points_possible, evidence_requirements, minimum_fix, accepted_variants)
select gen_random_uuid(), id, 'part-a-criterion-01', 'Correctly sets up the average value integral (1/(2*pi)) times the definite integral of r(t) from 0 to 2*pi.', 1, 'Response states the average value formula with correct bounds.', 'Write the average value formula as its own step.', '[]'::jsonb from version_ins
union all select gen_random_uuid(), id, 'part-a-criterion-02', 'Correctly evaluates the average value as 4.', 1, 'Response evaluates the integral and divides to get 4.', 'Show the antiderivative and evaluation before the final value.', '[]'::jsonb from version_ins
union all select gen_random_uuid(), id, 'part-b-criterion-01', 'Correctly computes the average rate of change as 0, using (r(2*pi)-r(0))/(2*pi).', 1, 'Response substitutes r(2*pi)=4 and r(0)=4 to get a difference of 0.', 'Show the substituted expression before the value.', '[]'::jsonb from version_ins
union all select gen_random_uuid(), id, 'part-c-criterion-01', 'Correctly explains that average value measures the mean height of r over the interval via integration, while average rate of change measures the net change in r divided by elapsed time -- two conceptually different measures, not the same quantity.', 1,
  'Response explicitly distinguishes the two concepts rather than conflating them.', 'State explicitly that average value and average rate of change answer different questions about the function.', '[]'::jsonb from version_ins;

with epv as (select '826c8cf1-bc1b-4f2a-bd33-61a758e1487d'::uuid as epv_id),
item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status, frq_form, practice_format, frq_archetype)
  select gen_random_uuid(), epv_id, 'apcalcab-frq-np2-010', 'frq', 'Area and Volume by the Washer Method About a Horizontal Line', 'draft', 'short', 'targeted_drill', 'mathematical_routines' from epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, rubric_type, evaluator_strategy)
  select gen_random_uuid(), id, 1, 'Answer all parts of the following question.

(a) Find the area of R.

(b) Write, but do not evaluate, an integral expression for the volume of the solid generated when R is revolved about the line y=-1.

(c) Evaluate the volume from part (b).',
  'Let R be the region bounded by y = the square root of x and y = x/2, for 0 <= x <= 4.',
  md5('apcalcab-frq-np2-010'), 'draft', 'tutor_review_pending', 'discrete_text', 'llm_discrete_text' from item_ins returning id
)
insert into app.frq_criteria (id, content_item_version_id, criterion_key, learner_facing_text, points_possible, evidence_requirements, minimum_fix, accepted_variants)
select gen_random_uuid(), id, 'part-a-criterion-01', 'Sets up the correct area integral: the definite integral from 0 to 4 of (the square root of x - x/2) dx.', 1, 'Response correctly identifies the square root of x as the upper curve on this interval.', 'Show the integrand with the correct top-minus-bottom order.', '[]'::jsonb from version_ins
union all select gen_random_uuid(), id, 'part-a-criterion-02', 'Correctly evaluates the area as 4/3.', 1, 'Response evaluates the antiderivative to get 4/3.', 'Show the antiderivative and evaluation before the final value.', '[]'::jsonb from version_ins
union all select gen_random_uuid(), id, 'part-b-criterion-01', 'Correctly sets up the washer-method volume integral with outer radius (the square root of x + 1) and inner radius (x/2 + 1): pi times the definite integral from 0 to 4 of [(the square root of x + 1)^2 - (x/2+1)^2] dx.', 1,
  'Response correctly identifies both radii relative to the line y=-1, independent of whether the expression is later evaluated correctly.',
  'Show both radius expressions explicitly, each shifted by the distance to y=-1.', '[]'::jsonb from version_ins
union all select gen_random_uuid(), id, 'part-c-criterion-01', 'Correctly evaluates the volume as 16*pi/3.', 1, 'Response expands and integrates the washer expression to get 16*pi/3.', 'Show the expanded integrand (2*the square root of x - x^2/4) before the final value.', '[]'::jsonb from version_ins;

commit;
