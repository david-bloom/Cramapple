begin;

-- Add AP Calculus BC Unit 9 topic-guide pairs.
--
-- Grounding: docs/product/AP_CALCULUS_AB_BC_CED_FACT_PACK.md Unit 9
-- deep-tier detail. Unit 9 is BC-only and exam-assessed at 10-15%.
-- The fact pack flags 9.1-9.6 as lower-confidence than 9.7-9.9 because
-- recent released BC FRQs emphasize polar curves, while parametric and
-- vector-valued topics are grounded mainly in CED content and analogized
-- scoring architecture.

with brief_seed (
  topic_code, title, class_importance, exam_importance, what_it_is,
  why_it_matters, how_points_are_earned, answer_move, common_point_loss,
  learn_more_path
) as (
  values
  ('9.1', 'Defining and Differentiating Parametric Equations', 'very-important', 'very-important',
   'Parametric equations define x and y as functions of a parameter, and dy/dx is found as (dy/dt)/(dx/dt) when dx/dt is not zero.',
   'This is BC-only core content. It lets students analyze slopes of curves that are not easily written as y=f(x).',
   'You earn points by differentiating each component with respect to the parameter, forming (dy/dt)/(dx/dt), and checking dx/dt is not zero at the parameter value.',
   'Differentiate x(t) and y(t) separately first; then divide dy/dt by dx/dt only after confirming the denominator is nonzero.',
   'Treating dy/dx as dy/dt or dividing in the wrong order.',
   '/learn/ap-calculus-bc/unit-9/defining-and-differentiating-parametric-equations'),
  ('9.2', 'Second Derivatives of Parametric Equations', 'very-important', 'very-important',
   'The second derivative for a parametric curve differentiates dy/dx with respect to the parameter and then divides by dx/dt.',
   'The CED explicitly warns that dy/dx is in terms of the parameter, so students must be careful when finding d2y/dx2.',
   'You earn points by first finding dy/dx as a function of t, differentiating that expression with respect to t, and dividing by dx/dt.',
   'After finding dy/dx(t), compute d/dt of that expression, then divide by dx/dt.',
   'Differentiating dy/dx with respect to t and stopping before the second division by dx/dt.',
   '/learn/ap-calculus-bc/unit-9/second-derivatives-of-parametric-equations'),
  ('9.3', 'Arc Lengths of Parametric Curves', 'somewhat-important', 'very-important',
   'The length of a parametrically defined curve is found with a definite integral built from the rates of change of x and y with respect to the parameter.',
   'This extends arc length to curves traced by a parameter. The fact pack notes the CED states the definite-integral idea without making one notation form the only acceptable wording.',
   'You earn points by using the parameter interval, differentiating both components, and building a positive length accumulation from both component rates.',
   'Find dx/dt and dy/dt, combine their rates into the arc-length integrand, and integrate over the parameter interval.',
   'Using only one component rate or integrating displacement instead of path length.',
   '/learn/ap-calculus-bc/unit-9/arc-lengths-of-parametric-curves'),
  ('9.4', 'Defining and Differentiating Vector-Valued Functions', 'somewhat-important', 'very-important',
   'A vector-valued function outputs a vector, and differentiation extends real-valued derivative methods to each component.',
   'Vector-valued functions package position or other vector quantities, making component-level calculus essential for BC motion and geometry.',
   'You earn points by differentiating the component functions consistently and interpreting the derivative vector as the rate of change of the vector output.',
   'Differentiate each component with respect to the parameter and keep the result in vector form.',
   'Differentiating only one component or turning a vector derivative into a scalar without being asked.',
   '/learn/ap-calculus-bc/unit-9/defining-and-differentiating-vector-valued-functions'),
  ('9.5', 'Integrating Vector-Valued Functions', 'somewhat-important', 'very-important',
   'Integrating a vector-valued function extends integration methods to vector components, often producing displacement from a velocity vector.',
   'This topic connects accumulation to vector motion. A definite integral of velocity gives displacement, not total distance traveled.',
   'You earn points by integrating each component over the interval and interpreting the resulting vector as net change when the integrand is velocity.',
   'Integrate component by component, then interpret the vector result as displacement or accumulated vector change.',
   'Calling the integral of velocity total distance instead of displacement.',
   '/learn/ap-calculus-bc/unit-9/integrating-vector-valued-functions'),
  ('9.6', 'Motion Problems Using Parametric and Vector-Valued Functions', 'somewhat-important', 'very-important',
   'Parametric and vector-valued motion problems use position, velocity, acceleration, speed, displacement, and distance in component form.',
   'BC motion often asks students to connect vector quantities to particle behavior over time, where displacement and total distance are different.',
   'You earn points by identifying the requested quantity, using derivatives for velocity/acceleration, and using the correct integral for displacement or total distance.',
   'Name the quantity first: position, velocity, acceleration, displacement, speed, or distance; then choose derivative, vector integral, or speed integral accordingly.',
   'Using displacement when the question asks for total distance traveled, or vice versa.',
   '/learn/ap-calculus-bc/unit-9/motion-problems-using-parametric-and-vector-valued-functions'),
  ('9.7', 'Defining Polar Coordinates and Differentiating in Polar Form', 'very-important', 'very-important',
   'A polar curve gives radius r as a function of theta, and derivatives of r, x, and y with respect to theta help analyze the curve.',
   'The fact pack flags a real student gap: many students did not know or could not apply x(theta)=r(theta)cos(theta) in a BC polar FRQ.',
   'You earn points by using r(theta), x(theta)=r(theta)cos(theta), and y(theta)=r(theta)sin(theta) when needed, then applying derivative information to the curve.',
   'Translate polar to x and y when the question asks for rectangular position or horizontal/vertical behavior.',
   'Using r alone as x, or forgetting the cosine factor in x(theta).',
   '/learn/ap-calculus-bc/unit-9/defining-polar-coordinates-and-differentiating-in-polar-form'),
  ('9.8', 'Area of a Polar Region or the Area Bounded by a Single Polar Curve', 'very-important', 'very-important',
   'Polar area is found with a definite integral over theta that accumulates sector-like area swept by a polar curve.',
   'Polar area was a high-error BC scoring target; correct constants, limits, and evaluation all matter for the final answer.',
   'You earn points by identifying the correct theta bounds, using the polar area structure with r as a function of theta, and evaluating with the required constant included.',
   'Find the interval that traces the region once, set up the polar area integral with the correct constant, and evaluate carefully.',
   'Omitting the one-half constant or using bounds that trace the region more than once.',
   '/learn/ap-calculus-bc/unit-9/area-of-a-polar-region-or-single-polar-curve'),
  ('9.9', 'Area of the Region Bounded by Two Polar Curves', 'very-important', 'very-important',
   'The area between two polar curves uses outer radius squared minus inner radius squared over the theta interval where the region is traced.',
   'This extends the washer-style difference idea into polar form and requires careful intersection bounds and outer/inner identification.',
   'You earn points by solving for intersection angles, identifying which radius is outer on each interval, and integrating the polar area difference with the correct constant.',
   'Find theta bounds from intersections, test which curve is outside, and integrate one-half times outer squared minus inner squared.',
   'Subtracting radii instead of squared radii, or failing to split when outer and inner switch.',
   '/learn/ap-calculus-bc/unit-9/area-of-region-bounded-by-two-polar-curves')
)
insert into app.topic_point_briefs (
  subject_key, unit_number, topic_code, title, class_importance, exam_importance,
  what_it_is, why_it_matters, how_points_are_earned, answer_move,
  common_point_loss, learn_more_path, practice_subject_key, practice_unit_number,
  practice_topic_code, source_note, status, published_at
)
select
  'ap_calculus_bc', 9, topic_code, title, class_importance, exam_importance,
  what_it_is, why_it_matters, how_points_are_earned, answer_move,
  common_point_loss, learn_more_path, 'ap_calculus_bc', 9, topic_code,
  'cramapple-authored; new coverage 2026-08-26 for AP Calculus BC Unit 9 Parametric Equations, Polar Coordinates, and Vector-Valued Functions; grounded in AP_CALCULUS_AB_BC_CED_FACT_PACK.md Unit 9 deep-tier detail: BC-only 10-15% weighting, parametric derivative formulas, parametric arc length as definite integral, vector-valued derivative/integral extensions, planar motion displacement versus total distance, polar coordinate differentiation with r as a function of theta, polar area setup, and 2025 BC polar FRQ misconception evidence for x(theta)=r(theta)cos(theta), polar-area final-answer difficulty, and local-versus-global polar optimization justification; batch 2026-08-26-ap-calculus-bc-unit9-topic-guides; author=reviewer same session, no independent human review yet',
  'published', now()
from brief_seed
on conflict (subject_key, topic_code) do update
set
  unit_number = excluded.unit_number, title = excluded.title, class_importance = excluded.class_importance, exam_importance = excluded.exam_importance, what_it_is = excluded.what_it_is, why_it_matters = excluded.why_it_matters, how_points_are_earned = excluded.how_points_are_earned, answer_move = excluded.answer_move, common_point_loss = excluded.common_point_loss, learn_more_path = excluded.learn_more_path, practice_subject_key = excluded.practice_subject_key, practice_unit_number = excluded.practice_unit_number, practice_topic_code = excluded.practice_topic_code, source_note = excluded.source_note, status = excluded.status, published_at = coalesce(app.topic_point_briefs.published_at, excluded.published_at);

with explainer_seed (
  topic_code, title, core_idea, what_students_need_to_understand,
  how_this_becomes_points, answer_move, mini_example_question, weak_answer,
  point_attaining_answer, common_point_loss, practice_bridge
) as (
  values
  ('9.1', 'Defining and Differentiating Parametric Equations',
   'Parametric differentiation converts component rates into slope with respect to x by comparing y-change per parameter to x-change per parameter.',
   'Students need to keep the parameter visible until the end. A slope at a point on the curve is not just y prime of t; it is how y changes relative to x as t changes.',
   'Points come from component derivatives, correct quotient order, and the dx/dt nonzero condition.',
   'Differentiate x(t) and y(t) separately first; then divide dy/dt by dx/dt only after confirming the denominator is nonzero.',
   'If x(t)=t^2 and y(t)=t^3, what expression gives dy/dx when t is not zero?',
   'dy/dx is 3t^2 because y prime is the slope.',
   'dx/dt=2t and dy/dt=3t^2, so dy/dx=(3t^2)/(2t)=3t/2 for t not equal to 0.',
   'Treating dy/dx as dy/dt or dividing in the wrong order.',
   'Back in practice, write dx/dt and dy/dt on separate lines before forming dy/dx.'),
  ('9.2', 'Second Derivatives of Parametric Equations',
   'Parametric concavity requires one more conversion from parameter-change to x-change after differentiating the slope expression.',
   'Students need to avoid the tempting shortcut of treating d/dt(dy/dx) as the final second derivative. The formula has the extra division by dx/dt because the derivative requested is with respect to x.',
   'Points come from the sequence: slope, parameter derivative of slope, divide by dx/dt, then interpret sign if asked.',
   'After finding dy/dx(t), compute d/dt of that expression, then divide by dx/dt.',
   'A student finds d/dt(dy/dx)=6t and dx/dt=2. What is d2y/dx2?',
   'It is 6t because that is the derivative of the slope.',
   'It is (6t)/2=3t, because the parameter derivative of dy/dx must still be divided by dx/dt.',
   'Differentiating dy/dx with respect to t and stopping before the second division by dx/dt.',
   'Back in practice, circle the final divide-by-dx/dt step before interpreting concavity.'),
  ('9.3', 'Arc Lengths of Parametric Curves',
   'Parametric arc length accumulates tiny pieces of distance along the path, using both horizontal and vertical component rates.',
   'Students need to know that path length is not the same as net displacement. Both x and y component rates contribute to how fast the point moves along the curve.',
   'Points come from correct parameter bounds, component derivatives, a distance-rate integrand, and a definite integral.',
   'Find dx/dt and dy/dt, combine their rates into the arc-length integrand, and integrate over the parameter interval.',
   'Why is using only x prime of t usually not enough for parametric arc length?',
   'Because x controls the horizontal position, so it gives the whole length.',
   'Arc length depends on motion in both directions. The distance-rate expression must include both dx/dt and dy/dt so vertical change is not ignored.',
   'Using only one component rate or integrating displacement instead of path length.',
   'Back in practice, check that both component derivatives appear before evaluating an arc-length integral.'),
  ('9.4', 'Defining and Differentiating Vector-Valued Functions',
   'A vector-valued derivative describes how the whole vector output changes, component by component.',
   'Students need to preserve vector structure. The derivative may represent velocity when the vector-valued function is position, but the interpretation depends on context.',
   'Points come from component differentiation, vector notation, and context-specific interpretation.',
   'Differentiate each component with respect to the parameter and keep the result in vector form.',
   'If r(t)=<t^2, sin t>, what is r prime of t?',
   'It is 2t because that is the derivative of the first component.',
   'r prime of t is <2t, cos t>. Both components must be differentiated and kept as a vector.',
   'Differentiating only one component or turning a vector derivative into a scalar without being asked.',
   'Back in practice, leave angle brackets in place until a scalar such as speed or magnitude is requested.'),
  ('9.5', 'Integrating Vector-Valued Functions',
   'A vector-valued integral accumulates each component separately into one vector result.',
   'Students need to distinguish vector accumulation from scalar distance. The definite integral of a velocity vector gives net displacement; the integral of speed gives total distance.',
   'Points come from component integration, bounds, and the correct displacement-versus-distance interpretation.',
   'Integrate component by component, then interpret the vector result as displacement or accumulated vector change.',
   'A particle has velocity vector v(t). What does the definite integral of v(t) from a to b represent?',
   'It is total distance traveled because velocity describes motion.',
   'It is displacement, the net change in position vector. Total distance would require integrating speed, the magnitude of velocity.',
   'Calling the integral of velocity total distance instead of displacement.',
   'Back in practice, write vector integral equals displacement and speed integral equals distance.'),
  ('9.6', 'Motion Problems Using Parametric and Vector-Valued Functions',
   'Motion questions are mostly about matching the requested physical quantity to the correct calculus operation.',
   'Students need to read wording closely. Position is a vector, velocity is position derivative, acceleration is velocity derivative, displacement is net vector change, and total distance accumulates speed.',
   'Points come from choosing the right operation and interpreting the result with units and direction when appropriate.',
   'Name the quantity first: position, velocity, acceleration, displacement, speed, or distance; then choose derivative, vector integral, or speed integral accordingly.',
   'A particle returns to its starting point after moving around a curve. What is its displacement?',
   'Its displacement is the length of the curve it traveled.',
   'Its displacement is the zero vector because final position equals initial position. The total distance traveled is the path length, not displacement.',
   'Using displacement when the question asks for total distance traveled, or vice versa.',
   'Back in practice, underline whether the prompt asks for net change or total amount traveled.'),
  ('9.7', 'Defining Polar Coordinates and Differentiating in Polar Form',
   'Polar calculus tracks a curve through radius and angle, but x- and y-behavior often requires translating through cosine and sine.',
   'Students need to follow the CED convention r=f(theta) and use theta as the independent variable. Horizontal or vertical distance from an axis usually needs x(theta) or y(theta), not r by itself.',
   'Points come from correct polar-to-rectangular translation, derivative setup, and interpretation of the derivative information.',
   'Translate polar to x and y when the question asks for rectangular position or horizontal/vertical behavior.',
   'For r(theta)=2sin(theta), what expression gives x(theta)?',
   'x(theta)=2sin(theta), because r is the horizontal coordinate.',
   'x(theta)=r(theta)cos(theta)=2sin(theta)cos(theta). The radius alone is not the x-coordinate.',
   'Using r alone as x, or forgetting the cosine factor in x(theta).',
   'Back in practice, write x=r cos theta and y=r sin theta before any polar derivative or coordinate claim.'),
  ('9.8', 'Area of a Polar Region or the Area Bounded by a Single Polar Curve',
   'A polar area integral accumulates area swept as theta changes, not vertical rectangles or horizontal slices.',
   'Students need to choose bounds from the actual tracing of the curve and include the polar area constant. The correct setup can fail if the curve is traced twice or if the constant is missing.',
   'Points come from correct bounds, polar-area structure, the one-half factor, and evaluation.',
   'Find the interval that traces the region once, set up the polar area integral with the correct constant, and evaluate carefully.',
   'Why is a polar area setup not just the integral of r(theta) dtheta?',
   'Because r is the height of the region.',
   'Polar area accumulates sector area, so the setup uses one-half times r(theta)^2 integrated with respect to theta over the region.',
   'Omitting the one-half constant or using bounds that trace the region more than once.',
   'Back in practice, check both: traced once and one-half r squared.'),
  ('9.9', 'Area of the Region Bounded by Two Polar Curves',
   'Polar area between curves compares squared radii because sector area depends on radius squared.',
   'Students need to solve intersections in theta and test intervals. If the outside curve changes, the integral must be split just like top-bottom switching in rectangular area.',
   'Points come from intersection bounds, outer/inner order, squared radii, the one-half constant, and splitting when needed.',
   'Find theta bounds from intersections, test which curve is outside, and integrate one-half times outer squared minus inner squared.',
   'For two polar curves, why is the integrand not just r_outer-r_inner?',
   'Because area is the distance between the curves.',
   'Sector area depends on radius squared, so the polar difference setup uses one-half times (r_outer^2-r_inner^2), with correct theta bounds.',
   'Subtracting radii instead of squared radii, or failing to split when outer and inner switch.',
   'Back in practice, test an angle between intersections to decide outer and inner before writing the integral.')
)
insert into app.topic_explainers (
  subject_key, unit_number, topic_code, title, core_idea,
  what_students_need_to_understand, how_this_becomes_points, answer_move,
  mini_example_question, weak_answer, point_attaining_answer,
  common_point_loss, practice_bridge, status, source_note, published_at
)
select
  'ap_calculus_bc', 9, topic_code, title, core_idea,
  what_students_need_to_understand, how_this_becomes_points, answer_move,
  mini_example_question, weak_answer, point_attaining_answer,
  common_point_loss, practice_bridge, 'published',
  'cramapple-authored; new coverage 2026-08-26 for AP Calculus BC Unit 9 Parametric Equations, Polar Coordinates, and Vector-Valued Functions; grounded in AP_CALCULUS_AB_BC_CED_FACT_PACK.md Unit 9 deep-tier detail: BC-only 10-15% weighting, parametric derivative formulas, parametric arc length as definite integral, vector-valued derivative/integral extensions, planar motion displacement versus total distance, polar coordinate differentiation with r as a function of theta, polar area setup, and 2025 BC polar FRQ misconception evidence for x(theta)=r(theta)cos(theta), polar-area final-answer difficulty, and local-versus-global polar optimization justification; batch 2026-08-26-ap-calculus-bc-unit9-topic-guides; author=reviewer same session, no independent human review yet',
  now()
from explainer_seed
on conflict (subject_key, topic_code) do update
set
  unit_number = excluded.unit_number, title = excluded.title, core_idea = excluded.core_idea, what_students_need_to_understand = excluded.what_students_need_to_understand, how_this_becomes_points = excluded.how_this_becomes_points, answer_move = excluded.answer_move, mini_example_question = excluded.mini_example_question, weak_answer = excluded.weak_answer, point_attaining_answer = excluded.point_attaining_answer, common_point_loss = excluded.common_point_loss, practice_bridge = excluded.practice_bridge, status = excluded.status, source_note = excluded.source_note, published_at = coalesce(app.topic_explainers.published_at, excluded.published_at);

do $$
declare
  v_briefs integer; v_explainers integer; v_pairing_orphans integer;
  v_unit_mismatches integer; v_route_mismatches integer; v_core_matches integer;
  v_duplicate_explainer_fields integer;
begin
  select count(*) into v_briefs from app.topic_point_briefs where subject_key='ap_calculus_bc' and unit_number=9 and topic_code in ('9.1', '9.2', '9.3', '9.4', '9.5', '9.6', '9.7', '9.8', '9.9') and status='published';
  if v_briefs <> 9 then raise exception 'expected 9 published AP Calculus BC Unit 9 briefs, got %', v_briefs; end if;
  select count(*) into v_explainers from app.topic_explainers where subject_key='ap_calculus_bc' and unit_number=9 and topic_code in ('9.1', '9.2', '9.3', '9.4', '9.5', '9.6', '9.7', '9.8', '9.9') and status='published';
  if v_explainers <> 9 then raise exception 'expected 9 published AP Calculus BC Unit 9 explainers, got %', v_explainers; end if;
  select count(*) into v_pairing_orphans from (select b.subject_key,b.topic_code from app.topic_point_briefs b left join app.topic_explainers e on e.subject_key=b.subject_key and e.topic_code=b.topic_code and e.status='published' where b.subject_key='ap_calculus_bc' and b.unit_number=9 and b.topic_code in ('9.1', '9.2', '9.3', '9.4', '9.5', '9.6', '9.7', '9.8', '9.9') and b.status='published' and e.topic_code is null union all select e.subject_key,e.topic_code from app.topic_explainers e left join app.topic_point_briefs b on b.subject_key=e.subject_key and b.topic_code=e.topic_code and b.status='published' where e.subject_key='ap_calculus_bc' and e.unit_number=9 and e.topic_code in ('9.1', '9.2', '9.3', '9.4', '9.5', '9.6', '9.7', '9.8', '9.9') and e.status='published' and b.topic_code is null) orphans;
  if v_pairing_orphans <> 0 then raise exception 'expected 0 AP Calculus BC Unit 9 pairing orphans, got %', v_pairing_orphans; end if;
  select count(*) into v_unit_mismatches from app.topic_point_briefs b join app.topic_explainers e on e.subject_key=b.subject_key and e.topic_code=b.topic_code where b.subject_key='ap_calculus_bc' and b.topic_code in ('9.1', '9.2', '9.3', '9.4', '9.5', '9.6', '9.7', '9.8', '9.9') and b.status='published' and e.status='published' and b.unit_number<>e.unit_number;
  if v_unit_mismatches <> 0 then raise exception 'expected 0 AP Calculus BC Unit 9 unit mismatches, got %', v_unit_mismatches; end if;
  select count(*) into v_route_mismatches from app.topic_point_briefs b where b.subject_key='ap_calculus_bc' and b.unit_number=9 and b.topic_code in ('9.1', '9.2', '9.3', '9.4', '9.5', '9.6', '9.7', '9.8', '9.9') and b.status='published' and (b.practice_subject_key<>b.subject_key or b.practice_unit_number<>b.unit_number or b.practice_topic_code<>b.topic_code or b.learn_more_path not like '/learn/ap-calculus-bc/unit-9/%');
  if v_route_mismatches <> 0 then raise exception 'expected 0 AP Calculus BC Unit 9 route mismatches, got %', v_route_mismatches; end if;
  select count(*) into v_core_matches from app.topic_point_briefs b join app.topic_explainers e on e.subject_key=b.subject_key and e.topic_code=b.topic_code where b.subject_key='ap_calculus_bc' and b.topic_code in ('9.1', '9.2', '9.3', '9.4', '9.5', '9.6', '9.7', '9.8', '9.9') and b.status='published' and e.status='published' and e.core_idea=b.what_it_is;
  if v_core_matches <> 0 then raise exception 'expected 0 AP Calculus BC Unit 9 core_idea/what_it_is matches, got %', v_core_matches; end if;
  with new_explainers as (select topic_explainer_id, mini_example_question, weak_answer, point_attaining_answer, practice_bridge from app.topic_explainers where subject_key='ap_calculus_bc' and unit_number=9 and topic_code in ('9.1', '9.2', '9.3', '9.4', '9.5', '9.6', '9.7', '9.8', '9.9') and status='published'), field_values as (select 'mini_example_question' field_name, mini_example_question value from new_explainers union all select 'weak_answer', weak_answer from new_explainers union all select 'point_attaining_answer', point_attaining_answer from new_explainers union all select 'practice_bridge', practice_bridge from new_explainers) select count(*) into v_duplicate_explainer_fields from field_values fv join app.topic_explainers e on (e.mini_example_question=fv.value or e.weak_answer=fv.value or e.point_attaining_answer=fv.value or e.practice_bridge=fv.value) where e.status='published' and not (e.subject_key='ap_calculus_bc' and e.unit_number=9 and e.topic_code in ('9.1', '9.2', '9.3', '9.4', '9.5', '9.6', '9.7', '9.8', '9.9'));
  if v_duplicate_explainer_fields <> 0 then raise exception 'expected 0 AP Calculus BC Unit 9 duplicate explainer fields, got %', v_duplicate_explainer_fields; end if;
end $$;

commit;
