-- AP Calculus AB, new-protocol replication batch 2 (np2) -- MCQs.
-- Content-key scheme: apcalcab-mcq-np2-001..010.
begin;

with epv as (select '826c8cf1-bc1b-4f2a-bd33-61a758e1487d'::uuid as epv_id),
item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), epv_id, 'apcalcab-mcq-np2-001', 'mcq', 'Related Rates: Sphere Volume', 'draft' from epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A spherical balloon is being inflated so that its radius increases at dr/dt = 2 cm/s. What is dV/dt when r = 3 cm? (V = (4/3)*pi*r^3)',
  md5('apcalcab-mcq-np2-001'), 'draft', 'tutor_review_pending', 'A' from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '72*pi', true, 'By the chain rule, dV/dt = 4*pi*r^2*(dr/dt). At r=3: 4*pi*9*2 = 72*pi.' from version_ins
union all select gen_random_uuid(), id, 'B', '24*pi', false, 'This differentiates V incorrectly as if dV/dr were 4*pi*r instead of 4*pi*r^2 -- the radius was not squared.' from version_ins
union all select gen_random_uuid(), id, 'C', '18*pi', false, 'This drops the factor of 4 from dV/dr=4*pi*r^2, using pi*r^2*(dr/dt) instead.' from version_ins
union all select gen_random_uuid(), id, 'D', '6*pi', false, 'This does not correctly apply the chain rule to the volume formula.' from version_ins;

with epv as (select '826c8cf1-bc1b-4f2a-bd33-61a758e1487d'::uuid as epv_id),
item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), epv_id, 'apcalcab-mcq-np2-002', 'mcq', 'Recognizing an Indeterminate Form for L''Hospital''s Rule', 'draft' from epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Which of the following limits is an indeterminate form (0/0 or infinity/infinity) to which L''Hospital''s Rule may be applied directly?

A. the limit as x approaches 0 of (e^x - 1)/x
B. the limit as x approaches infinity of (x - ln(x))
C. the limit as x approaches 3 of (x^2-9)/(x+3)
D. the limit as x approaches 0 of (1/x - 1/x^2)',
  md5('apcalcab-mcq-np2-002'), 'draft', 'tutor_review_pending', 'A' from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'the limit as x approaches 0 of (e^x - 1)/x', true, 'As x approaches 0, both e^x-1 and x approach 0, giving the 0/0 form to which L''Hospital''s Rule applies directly.' from version_ins
union all select gen_random_uuid(), id, 'B', 'the limit as x approaches infinity of (x - ln(x))', false, 'This is an infinity-minus-infinity form, which is explicitly outside the AP Calculus AB/BC scope for L''Hospital''s Rule -- only 0/0 and infinity/infinity are assessed.' from version_ins
union all select gen_random_uuid(), id, 'C', 'the limit as x approaches 3 of (x^2-9)/(x+3)', false, 'At x=3 the denominator is 6, not 0, so direct substitution works and this is not an indeterminate form.' from version_ins
union all select gen_random_uuid(), id, 'D', 'the limit as x approaches 0 of (1/x - 1/x^2)', false, 'This is an infinity-minus-infinity form before simplification, not a direct 0/0 or infinity/infinity ratio.' from version_ins;

with epv as (select '826c8cf1-bc1b-4f2a-bd33-61a758e1487d'::uuid as epv_id),
item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), epv_id, 'apcalcab-mcq-np2-003', 'mcq', 'What the Candidates Test Requires', 'draft' from epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Let h be continuous on [1,6] with h''(x)=0 only at x=3, and suppose h has a local minimum at x=3. Which additional information is required to determine whether x=3 gives the absolute minimum of h on [1,6]?',
  md5('apcalcab-mcq-np2-003'), 'draft', 'tutor_review_pending', 'B' from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The value of h''''(3)', false, 'The second derivative helps classify local behavior, which is already given -- it does not address the endpoints.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The values of h(1) and h(6)', true, 'Absolute extrema on a closed interval require the Candidates Test: comparing every critical point value against both endpoint values.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Whether h is differentiable at x=3', false, 'This is already established, since h''(3)=0 is given as a critical point.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The sign of h''(x) for x<1', false, 'x<1 is outside the domain [1,6] under consideration.' from version_ins;

with epv as (select '826c8cf1-bc1b-4f2a-bd33-61a758e1487d'::uuid as epv_id),
item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), epv_id, 'apcalcab-mcq-np2-004', 'mcq', 'FTC: Derivative of an Accumulation Function', 'draft' from epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Let g(x) = the definite integral from 2 to x of f(t) dt, where f is continuous. If f(5) = 7, what is g''(5)?',
  md5('apcalcab-mcq-np2-004'), 'draft', 'tutor_review_pending', 'A' from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '7', true, 'By the Fundamental Theorem of Calculus, g''(x)=f(x), so g''(5)=f(5)=7 directly.' from version_ins
union all select gen_random_uuid(), id, 'B', 'f(5) - f(2)', false, 'This confuses g''(x) with a difference-quotient-style expression -- a documented error of mistaking the derivative of an accumulation function for something involving the lower bound.' from version_ins
union all select gen_random_uuid(), id, 'C', '5', false, 'This is not derived from any correct application of the Fundamental Theorem of Calculus.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Cannot be determined without knowing f(2)', false, 'The value of f(2) is irrelevant to g''(5); the Fundamental Theorem gives g''(5)=f(5) directly.' from version_ins;

with epv as (select '826c8cf1-bc1b-4f2a-bd33-61a758e1487d'::uuid as epv_id),
item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), epv_id, 'apcalcab-mcq-np2-005', 'mcq', 'Right Riemann Sum from a Table', 'draft' from epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Using a right Riemann sum with the subintervals indicated by the table, approximate the definite integral from 0 to 4 of f(x) dx.

x: 0, 1, 3, 4
f(x): 2, 5, 9, 10',
  md5('apcalcab-mcq-np2-005'), 'draft', 'tutor_review_pending', 'A' from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '33', true, 'Right sum uses right-endpoint values: (1)(5)+(2)(9)+(1)(10) = 5+18+10 = 33.' from version_ins
union all select gen_random_uuid(), id, 'B', '21', false, 'This is the left Riemann sum, using left-endpoint values instead: (1)(2)+(2)(5)+(1)(9)=21.' from version_ins
union all select gen_random_uuid(), id, 'C', '27', false, 'This is the trapezoidal sum, not the requested right Riemann sum.' from version_ins
union all select gen_random_uuid(), id, 'D', '42', false, 'This does not correctly apply the subinterval widths given in the table.' from version_ins;

with epv as (select '826c8cf1-bc1b-4f2a-bd33-61a758e1487d'::uuid as epv_id),
item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), epv_id, 'apcalcab-mcq-np2-006', 'mcq', 'Separable Differential Equation Evaluation', 'draft' from epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'If dy/dx = 2xy and y(0) = 3, then y(1) = ?',
  md5('apcalcab-mcq-np2-006'), 'draft', 'tutor_review_pending', 'A' from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '3e', true, 'Separating variables gives ln|y|=x^2+C; y(0)=3 gives C=ln3, so y=3e^(x^2). At x=1, y=3e.' from version_ins
union all select gen_random_uuid(), id, 'B', '3e^2', false, 'This misapplies the exponent, effectively doubling the x^2 term incorrectly.' from version_ins
union all select gen_random_uuid(), id, 'C', 'e^3', false, 'This does not follow from the correct separation-of-variables solution.' from version_ins
union all select gen_random_uuid(), id, 'D', '6', false, 'This treats the differential equation as if y were constant during integration, producing a linear rather than exponential result.' from version_ins;

with epv as (select '826c8cf1-bc1b-4f2a-bd33-61a758e1487d'::uuid as epv_id),
item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), epv_id, 'apcalcab-mcq-np2-007', 'mcq', 'Average Value vs. Average Rate of Change', 'draft' from epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'For g(x) = x^2 on [0,6], what is the average value of g on this interval?',
  md5('apcalcab-mcq-np2-007'), 'draft', 'tutor_review_pending', 'A' from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '12', true, 'Average value = (1/6)*the definite integral from 0 to 6 of x^2 dx = (1/6)(72) = 12.' from version_ins
union all select gen_random_uuid(), id, 'B', '6', false, 'This is the average RATE of change, (g(6)-g(0))/6=36/6=6, not the average value -- a documented confusion between the two concepts.' from version_ins
union all select gen_random_uuid(), id, 'C', '36', false, 'This is simply g(6), the endpoint value, not the average value over the interval.' from version_ins
union all select gen_random_uuid(), id, 'D', '18', false, 'This does not follow from a correct average-value computation.' from version_ins;

with epv as (select '826c8cf1-bc1b-4f2a-bd33-61a758e1487d'::uuid as epv_id),
item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), epv_id, 'apcalcab-mcq-np2-008', 'mcq', 'Washer Method Setup', 'draft' from epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The region bounded by y=x^2 and y=4 is revolved about the x-axis. Which integral gives the volume of the resulting solid?',
  md5('apcalcab-mcq-np2-008'), 'draft', 'tutor_review_pending', 'A' from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'pi times the definite integral from -2 to 2 of (16 - x^4) dx', true, 'Outer radius 4, inner radius x^2; washer volume is pi*(4^2-(x^2)^2)=pi*(16-x^4), integrated over the intersection interval [-2,2].' from version_ins
union all select gen_random_uuid(), id, 'B', 'pi times the definite integral from -2 to 2 of (4-x^2)^2 dx', false, 'This subtracts the radii before squaring instead of squaring each radius separately and then subtracting -- a common washer-method error.' from version_ins
union all select gen_random_uuid(), id, 'C', 'pi times the definite integral from -2 to 2 of x^4 dx', false, 'This only accounts for the inner disk and omits the outer radius entirely.' from version_ins
union all select gen_random_uuid(), id, 'D', 'pi times the definite integral from -2 to 2 of (16 - x^2) dx', false, 'This fails to square the inner radius x^2, using the wrong power.' from version_ins;

with epv as (select '826c8cf1-bc1b-4f2a-bd33-61a758e1487d'::uuid as epv_id),
item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), epv_id, 'apcalcab-mcq-np2-009', 'mcq', 'Concavity from the Second Derivative', 'draft' from epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'If f''''(x) = (x-2)(x+1) for all x, on which interval is the graph of f concave up?',
  md5('apcalcab-mcq-np2-009'), 'draft', 'tutor_review_pending', 'A' from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'x<-1 or x>2', true, 'f''''(x)=(x-2)(x+1)>0 when both factors have the same sign, which occurs for x<-1 or x>2.' from version_ins
union all select gen_random_uuid(), id, 'B', '-1<x<2', false, 'This is the interval where f'''' is negative (concave down), the opposite of the correct answer.' from version_ins
union all select gen_random_uuid(), id, 'C', 'x>2 only', false, 'This omits the other branch of the sign analysis, x<-1.' from version_ins
union all select gen_random_uuid(), id, 'D', 'x<-1 only', false, 'This omits the other branch of the sign analysis, x>2.' from version_ins;

with epv as (select '826c8cf1-bc1b-4f2a-bd33-61a758e1487d'::uuid as epv_id),
item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), epv_id, 'apcalcab-mcq-np2-010', 'mcq', 'Linearization Overestimate vs. Underestimate', 'draft' from epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The function f satisfies f(3)=5, f''(3)=2, and f''''(x)<0 for all x near 3. Using the tangent line approximation at x=3, is the estimate L(3.2) an overestimate or underestimate of f(3.2)?',
  md5('apcalcab-mcq-np2-010'), 'draft', 'tutor_review_pending', 'A' from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Overestimate, because f is concave down and the tangent line lies above the graph near x=3', true, 'A concave-down function''s tangent line lies above its graph near the point of tangency, so the linear estimate overestimates the true value.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Underestimate, because f is concave down', false, 'Concave down implies the tangent line lies above the curve, giving an overestimate, not an underestimate.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Overestimate, because f is concave up', false, 'The problem states f'''' <0, which is concave down, not concave up.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Underestimate, because f is concave up', false, 'The problem states f'''' <0, which is concave down, not concave up, and concave down does not produce an underestimate.' from version_ins;

commit;
