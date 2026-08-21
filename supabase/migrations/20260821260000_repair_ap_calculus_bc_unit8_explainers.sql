begin;

-- Repair AP Calculus BC Unit 8 (Applications of Integration) Learn More
-- explainers -- the final unit in this repair pass. Briefs were
-- duplicated from AB's genuinely hand-authored content and are correct;
-- NOT touched here. Topic 8.13 (Arc Length) is BC-only (moved, not
-- duplicated) but was also template-generated debt, so it is repaired
-- in this same batch.
--
-- AP Calculus AB's Unit 8 explainers are still grandfathered debt as of
-- this batch (not yet repaired), so there is no AB Unit 8 hand-authored
-- batch to accidentally collide with the way BC/AB Unit 4 did.
--
-- Grounded in docs/product/AP_CALCULUS_AB_BC_CED_FACT_PACK.md Unit 8
-- deep-tier detail: the documented real 2025 Q1 error computing average
-- rate of change instead of average value (scored 0/2); the stricter
-- antiderivative-leading-constant gatekeeping rule for motion problems
-- (2025 Q5 Part D), distinct from the more forgiving wrong-value-but-
-- consistent-process pattern in Units 4/5; the cross-part consistency/
-- follow-through scoring convention (a later part may import an earlier,
-- even wrong, value and still earn credit); the missing-constant-pi-
-- costs-exactly-one-point rule for volume setups; the self-correcting
-- reversed-difference-of-squares washer pattern; the documented real
-- 2025 Q2 washer error omitting the required constant shift for a
-- non-axis rotation line (0/3); and the boxed BC-only arc-length
-- exclusion with its own dedicated Enduring Understanding, CHA-6.
--
-- Before-state captured at docs/research/
-- topic_guide_source_note_grandfather_2026_08_21/
-- ap_calculus_bc_unit8_explainer_before_state.json.
--
-- Every new explainer is genuinely topic-specific and mathematically
-- verified: core_idea differs from what_it_is on every row, and no
-- mini_example_question / weak_answer / point_attaining_answer /
-- practice_bridge value repeats within this batch or elsewhere in the
-- corpus (checked programmatically before and after).

with explainer_updates (
  topic_code, core_idea, what_students_need_to_understand,
  how_this_becomes_points, answer_move, mini_example_question, weak_answer,
  point_attaining_answer, common_point_loss, practice_bridge
) as (
  values
  ('8.1',
   'Average value, (1/(b-a)) times the integral of f from a to b, is a genuinely different quantity from average rate of change, (f(b)-f(a))/(b-a) -- computing the second when the first was requested is a documented, real AP scoring error, not just an unfortunate name collision.',
   'Average rate of change only needs the two endpoint values of f; average value needs the entire integral of f across the interval, so a response using only f(a) and f(b) has not actually engaged with what average value asks for.',
   'Full credit requires the average-value formula, with the definite integral explicitly present, not the two-point slope formula between endpoints.',
   'Before computing, write out the average-value formula with the integral symbol present, confirming it is not the endpoint-slope formula for average rate of change.',
   'A tank''s water depth is C(t) on [0,4]. Asked for the average depth over [0,4], a student computes (C(4) - C(0)) / (4 - 0).',
   'This is correct, since dividing a change by the time interval gives the average.',
   'This computes the average rate of change, not the average value -- a real, documented AP scoring error; the average depth requires (1/4) times the integral from 0 to 4 of C(t) dt, which needs the accumulated depth across the whole interval, not just the two endpoint depths C(0) and C(4); this response would score 0 on an average-value part even with correct arithmetic, because it answers a different, related question.',
   'Confusing average value with slope between endpoints.',
   'Before computing an average-value question, check explicitly whether the formula involves an integral (average value) or just the two endpoint values (average rate of change).'),
  ('8.2',
   'When position is recovered from velocity by antidifferentiation, the antiderivative''s leading constant must be exactly correct -- a wrong constant carried through otherwise-clean arithmetic disqualifies the final position value outright, unlike some other units'' more forgiving wrong-value-but-consistent-process credit.',
   'This is a stricter rule than the linearization or related-rates follow-through pattern seen elsewhere: a motion problem''s antiderivative constant is treated as a correctness gate for the final answer, not just one input that can be wrong and still earn downstream credit.',
   'Full credit requires the antiderivative''s leading constant computed correctly (matching the actual antiderivative rule applied), since an incorrect constant blocks eligibility for the final position or displacement value even if every other step is executed cleanly.',
   'Differentiate the antiderivative back to check every leading constant is correct before using it to compute a final position or displacement value.',
   'A particle has velocity v(t) = 3t^2. A student finds position as s(t) = 2t^3 + s0 (using 2 instead of the correct coefficient 1) and continues the rest of the computation flawlessly.',
   'The final answer is still fine, since only one constant was off and everything else was done correctly.',
   'A wrong leading constant on the antiderivative is not a minor slip here -- the correct antiderivative of 3t^2 is t^3 + s0, not 2t^3 + s0; because the leading constant is wrong, the final position or displacement value is not eligible for credit, regardless of how cleanly the rest of the arithmetic is carried out afterward, which is a stricter rule than the wrong-value-but-consistent-process leniency seen in other topics.',
   'Reporting displacement when the question asks for total distance traveled.',
   'Before using any antiderivative for a motion problem''s final answer, differentiate it back to confirm every leading constant is exactly correct.'),
  ('8.3',
   'In a multi-part applied-context question, a later part is explicitly allowed to import a value computed in an earlier part -- even one that turned out to be numerically wrong -- and still earn full credit for that later part, as long as it is used consistently.',
   'This cross-part consistency rule means the accumulated-change setup in this topic does not need to be recomputed from scratch in a later part; using the previously established value or expression consistently is what earns credit, not re-deriving a fresh number.',
   'Full credit in a later part requires the earlier value or expression used consistently with correct accumulated-change logic, even when that earlier value was itself wrong, rather than penalizing the later part for an error that originated upstream.',
   'When a later part depends on an earlier accumulated-change result, reuse that earlier value or expression exactly as established, applying the correct final-amount logic on top of it.',
   'In part (b), a student correctly sets up but miscalculates the accumulated change as 12 (the correct value is 15). In part (c), asked for the final amount using an initial value of 20, the student writes 20 + 12 = 32.',
   'Part (c) should be marked wrong, since 32 is not the correct final amount.',
   'Part (c) can still earn full credit -- this is a documented, real AP scoring convention: a later part is permitted to import a value from an earlier part, even a wrong one, and receive credit for using it consistently; since 20 + 12 correctly applies the final-amount-equals-initial-plus-accumulated-change logic to the (wrong) value carried in from part (b), the error in part (b) does not have to cost points again in part (c).',
   'Forgetting the initial amount or attaching the rate''s units instead of the accumulated quantity''s units.',
   'When a later part depends on an earlier numeric result, check whether that earlier value is being used consistently and correctly, rather than assuming an earlier error automatically costs credit again downstream.'),
  ('8.4',
   'Finding the area between two x-functions requires the actual intersection x-values as the integration bounds, found by solving where the functions are equal -- guessing bounds from a rough sketch, rather than solving for them, risks integrating over the wrong interval entirely.',
   'Identifying which function is on top can change partway through the interval, so the bounds and the top-minus-bottom order both need to be confirmed by the functions'' actual values, not assumed from a quick visual impression.',
   'Full credit requires the intersection x-values solved explicitly as the bounds, and the top-minus-bottom subtraction order confirmed by checking function values (not just a sketch) before integrating.',
   'Solve explicitly for where the two functions are equal to get the bounds, verify which function is on top by testing a point, then integrate top minus bottom.',
   'For f(x) = x^2 and g(x) = 2x on [0,3], a student assumes the bounds are x=0 and x=3 from the given interval, without checking where the curves actually intersect.',
   'This is fine, since the given interval already tells you the bounds to use.',
   'The bounds must come from where the curves actually intersect, not just the stated interval endpoints -- solving x^2 = 2x gives x=0 and x=2, so the enclosed region is only between these two intersection points, not across the full [0,3] interval; using the interval''s endpoints instead of the solved intersection points integrates over the wrong region entirely.',
   'Reversing top and bottom or failing to split intervals when the top function changes.',
   'Before setting up any area-between-curves integral, solve explicitly for the intersection x-values rather than assuming the given interval''s endpoints are the correct bounds.'),
  ('8.5',
   'Area between curves as functions of y requires both curves rewritten with x isolated as a function of y, then the rightmost x-expression minus the leftmost x-expression integrated with respect to y -- relabeling an x-based setup instead skips the actual rewrite this setup requires.',
   'This topic is chosen specifically when solving for x in terms of y is easier or required (such as when a curve is not a function of x, like a sideways parabola); simply reusing an x-based setup with variable names swapped skips the genuine rewrite needed.',
   'Full credit requires each curve explicitly solved for x as a function of y, the rightmost minus leftmost x-expression identified by testing a value, and the integral taken with respect to y over the correct y-bounds.',
   'Solve each curve explicitly for x in terms of y, identify which expression is rightmost by testing a value, then integrate right minus left with respect to y.',
   'For the region bounded by x = y^2 and x = 4, a student sets up the integral as the integral of (top function minus bottom function) with respect to x, reusing the vertical-slice setup from topic 8.4.',
   'This is an equally valid way to set up the same area, since it is the same region either way.',
   'This region is naturally described by horizontal slices, since x = y^2 is not a function of x for the full curve; the correct setup solves each boundary for x in terms of y (x = 4 stays as is, x = y^2 stays as is) and integrates the rightmost expression (x=4) minus the leftmost expression (x=y^2) with respect to y, not a vertical top-minus-bottom setup, which would require splitting the parabola into two separate x-function branches unnecessarily.',
   'Using dx bounds or top-minus-bottom logic when the setup requires horizontal slices.',
   'Before choosing a vertical or horizontal slice setup, check whether both curves are naturally functions of x or of y, and use whichever setup avoids splitting a curve into unnecessary branches.'),
  ('8.6',
   'When two curves cross more than twice, the top-minus-bottom relationship can flip between intersection points -- the region has to be split at every intersection point, with the subtraction order re-checked on each resulting sub-interval, since a single subtraction order carried across the whole span will be wrong on at least one piece.',
   'Finding all the intersection points is itself part of the setup work being tested here, not just a preliminary step, since missing even one intersection point means missing the sub-interval where the top-bottom order changes.',
   'Full credit requires every intersection point identified as a boundary between sub-intervals, and the top-minus-bottom order re-verified (by testing a point) on each individual sub-interval before adding the separate integrals.',
   'Solve for every intersection point between the two curves, split the region at each one, verify the top-bottom order separately on each sub-interval, then add the resulting integrals.',
   'Two curves intersect at x = 0, x = 2, x = 4, and x = 6. A student splits the region only at x=4, treating [0,4] and [4,6] as the only two pieces, and uses one subtraction order across all of [0,4].',
   'This is a complete setup, since the region has been split at one of the intersection points.',
   'All four intersection points must be used as boundaries, not just one of them -- since the curves cross at x=0, 2, 4, and 6, there are three sub-intervals, [0,2], [2,4], and [4,6], and the top-bottom order can flip at x=2 as well as at x=4; using a single subtraction order across the whole span [0,4] misses the possible flip at x=2, so every solved intersection point must define its own sub-interval, each re-verified independently.',
   'Using one integral across the whole interval when the upper and lower functions switch.',
   'Before integrating, solve for every intersection point between the two curves and treat each one as a boundary between sub-intervals, re-checking the top-bottom order within each piece separately.'),
  ('8.7',
   'A cross-sectional slice''s area formula must use the actual base length taken from the region at that specific x (or y), and the resulting area expression is what gets integrated -- the differential itself is not what earns the structural-form point, so presence or absence of it in an intermediate expression is not what is being checked at this step.',
   'The setup earns its point for producing a genuine area expression, a base length squared for a square cross section or base times height for a rectangle, built from the region''s actual boundary functions, not from a memorized formula applied without reference to the specific region.',
   'Full credit requires the cross-section''s base length identified explicitly from the region''s boundary functions at each x, the resulting area formula (side squared for a square, base times height for a rectangle) written using that base length, and the integral of that area formula taken over the correct bounds.',
   'Identify the base length as a boundary-function expression at each x, square it (for a square) or multiply by height (for a rectangle) to get the area formula, then integrate that area expression over the region''s bounds.',
   'A solid''s base is the region between y = x^2 and y = 4, with square cross sections perpendicular to the x-axis. A student writes the cross-sectional area as (4 - x^2), the base length itself, without squaring it.',
   'This is correct, since (4 - x^2) is the base length of the square cross section.',
   'A square cross section''s area is the base length squared, not the base length itself -- since the base length here is (4 - x^2), the area of the square cross section is (4 - x^2)^2, and this squared expression is what gets integrated over the base''s x-bounds, not the unsquared base-length expression, which would compute a length, not an area.',
   'Integrating a length instead of an area or using the wrong side length for the cross section.',
   'After finding a cross section''s base length from the region''s boundary functions, apply the correct area formula for that shape (squaring for a square, or the shape-specific formula) before integrating, rather than integrating the base length itself.'),
  ('8.8',
   'Triangular and semicircular cross sections require substituting the region''s base length into the correct shape-specific area formula -- a semicircle''s radius is half the base, not the base itself -- so applying the wrong formula produces a structurally wrong integrand even with a correct base length.',
   'The shape named in the problem (isosceles right triangle, equilateral triangle, semicircle) determines which area formula applies; the base length from the region is only the input to that formula, and substituting it into the wrong formula breaks the setup regardless of how correctly the base length itself was found.',
   'Full credit requires the shape-specific area formula identified correctly for the named cross section, the region''s base length substituted correctly into that formula (using half the base as the radius for a semicircle), and the integral taken over the correct bounds.',
   'Identify the named cross-section shape first, write its area formula in terms of the base length (using half the base as radius for a semicircle), then substitute the region''s actual base-length expression.',
   'A solid has semicircular cross sections with diameter equal to (6 - x), perpendicular to the x-axis. A student writes the cross-sectional area as pi times (6-x)^2, treating the base length directly as the radius.',
   'This is correct, since (6-x) is the base length used in the area formula.',
   'For a semicircle, the radius is half the diameter, not the full base length -- since (6-x) is the diameter, the radius is (6-x)/2, so the correct cross-sectional area is (1/2)*pi*((6-x)/2)^2, not pi*(6-x)^2; using the full base length as if it were the radius overstates the area by using the wrong input to the semicircle formula.',
   'Using square cross-section area when the problem specifies triangles or semicircles.',
   'Before substituting into any cross-section area formula, confirm whether the region''s base length represents a diameter, a side length, or a radius for the specific shape named, since each shape''s formula expects a different one of these.'),
  ('8.9',
   'Omitting the constant pi from a disc-method volume integral costs exactly the one point tied to the limits-and-constant structure -- it does not disqualify the setup or integrand points, since those are scored on the radius and integrand structure being correct, independent of whether pi was ever written down.',
   'Volume setup is scored in separable pieces: identifying the correct radius (perpendicular to the axis of rotation) is one piece, and attaching the constant pi with the correct bounds is a separate piece, so a missing pi is a specific, isolated deduction rather than a sign the whole volume computation is wrong.',
   'Full credit requires the radius identified as the perpendicular distance from the axis of rotation to the curve, the integrand written as radius squared, and the constant pi included with the correct bounds as a separate, explicit component of the setup.',
   'Identify the radius perpendicular to the axis of rotation, write radius squared as the integrand, then attach pi and the correct bounds as the final structural piece.',
   'A region is revolved around the x-axis. A student correctly identifies the radius as f(x) and writes the volume as the integral from a to b of (f(x))^2 dx, omitting the constant pi.',
   'This entire volume setup is wrong because pi is missing.',
   'The radius and integrand structure here are both correct, and omitting pi costs specifically the constant/limits point, not the whole setup -- the correct volume is pi times the integral from a to b of (f(x))^2 dx; a missing pi is treated as an isolated deduction on the constant-and-bounds component of the score, not as evidence the radius or integrand identification was wrong.',
   'Using diameter as radius or choosing a radius parallel to the axis of rotation.',
   'After setting up any disc-method integral, check the constant pi and the bounds as their own separate step, since a missing pi is graded as its own specific deduction rather than invalidating a correctly identified radius.'),
  ('8.10',
   'When a region revolves around a non-coordinate line, the radius must be the distance between the curve and that specific rotation line, not the function value itself -- reusing the function value directly silently assumes the axis is y=0 or x=0.',
   'The radius-as-distance idea is the same geometric concept used for a coordinate-axis disc method, just generalized: subtract (or add) the shift amount to the function value to get the actual distance to the given rotation line before squaring it.',
   'Full credit requires the radius written explicitly as the distance from the curve to the stated rotation line (function value adjusted by the shift, not the function value alone) before it is squared inside the integral.',
   'Write the radius as the function value adjusted by the shift to the actual rotation line, confirm it as a distance, then square it inside the volume integral.',
   'A region under y = f(x), above y = 0, is revolved around the line y = -3. A student writes the radius as f(x), the same as if revolving around y=0.',
   'This is correct, since f(x) is still the height of the region being revolved.',
   'The radius must be the distance to the actual rotation line, y = -3, not just the function value -- since every point on the curve is now f(x) - (-3) = f(x) + 3 units from the line y=-3, the correct radius is f(x) + 3, not f(x) alone; using f(x) directly silently assumes the axis of rotation is y=0, which is not the case here.',
   'Using f(x) as the radius when the axis is shifted away from the coordinate axis.',
   'Whenever the axis of rotation is not a coordinate axis, write the radius explicitly as the function value adjusted by the shift to that specific line, before squaring it.'),
  ('8.11',
   'A washer''s R-squared-minus-r-squared form earns its own structural point separate from having correct radii -- an accidental r-squared-minus-R-squared reversal is self-correcting and still earns full credit once resolved, by a leading negative sign or by flipped bounds.',
   'The subtraction order (outer squared minus inner squared) and the specific radius values being correct are scored as genuinely separate components, so getting the radii right but reversing which one is squared-and-subtracted-from-which is a real, distinct error from having the wrong radius values entirely.',
   'Full credit requires the R-squared-minus-r-squared structural form present, the correct outer and inner radius expressions identified, and if the subtraction is accidentally reversed, that reversal explicitly resolved by a sign or by the integration bounds, not left as an unresolved negative volume.',
   'Identify the outer radius R and inner radius r explicitly, write R^2 - r^2 as the structural form, then confirm the result is resolved to a positive volume by sign or bounds if the subtraction was reversed.',
   'A washer setup has outer radius R = x+1 and inner radius r = x. A student writes the integrand as r^2 - R^2 = x^2 - (x+1)^2 and integrates it directly without resolving the resulting negative sign.',
   'This setup earns no credit, since the subtraction order is reversed.',
   'A reversed subtraction like this is self-correcting and can still earn full credit -- the structural form and the individual radius identifications are both correct here, just written in the reversed order; as long as the negative result is resolved, either by placing a leading negative sign in front of the integral or by flipping the integration bounds, the volume still comes out correctly, since the reversal is treated as a resolvable presentation issue, not a disqualifying structural error.',
   'Subtracting radii before squaring or reversing inner and outer radii.',
   'If a washer setup''s subtraction order comes out reversed, resolve it explicitly with a sign or flipped bounds rather than treating the reversal itself as disqualifying, since the radius identification underneath may still be entirely correct.'),
  ('8.12',
   'Revolving a region around a shifted (non-axis) line requires every radius to include that line''s constant shift -- omitting the shift breaks the washer integrand''s recognized R-squared-minus-r-squared pattern entirely, which is a documented, real scoring failure distinct from simply computing a wrong final numeric answer.',
   'This shift must be applied to both the outer and inner radii consistently, since both distances are being measured from the same shifted rotation line, not from the original coordinate axis the functions were originally defined against.',
   'Full credit requires both the outer and inner radii written as distances to the actual shifted rotation line (each function value adjusted by the same shift), preserving the recognized R-squared-minus-r-squared washer form.',
   'Adjust both the outer and inner function values by the same shift to the actual rotation line before squaring either one, preserving the R^2 - r^2 washer structure.',
   'A washer region between y=f(x) (outer) and y=g(x) (inner) is revolved around the line y=-2. A student writes the integrand as f(x)^2 - g(x)^2, without adjusting either radius for the shift to y=-2.',
   'This is correct, since the outer-minus-inner structure and the two function values are both right.',
   'This is a documented, real scoring failure -- omitting the required shift breaks the washer integrand''s recognized form entirely, not just the final value; since the axis is y=-2, both radii must be adjusted by that shift: the correct integrand is (f(x)+2)^2 - (g(x)+2)^2, not f(x)^2 - g(x)^2, since every point''s actual distance to the line y=-2 includes that +2 shift, and omitting it for even one of the two radii breaks the pattern the setup point is scored on.',
   'Forgetting to adjust radii for the shifted axis.',
   'Whenever revolving around a shifted line, apply the same constant adjustment to both the outer and inner radius before squaring either one, and check both radii were adjusted, not just one.'),
  ('8.13',
   'Arc length is BC-only content, carrying its own dedicated Enduring Understanding separate from the area-and-volume group the rest of this unit belongs to -- it is not an AB-eligible topic despite sharing the same unit as area and volume applications.',
   'The arc length integral, the integral of the square root of 1 plus the derivative squared, requires the derivative itself found first and squared inside the square root before integrating over the correct bounds -- treating the base function''s own value as part of the formula, rather than its derivative, produces a completely different (and wrong) integrand.',
   'Full credit requires the derivative found explicitly, squared inside the square-root expression sqrt(1 + (dy/dx)^2), and integrated over the correct interval, with the topic recognized as BC-only content.',
   'Find the derivative first, square it and add 1 inside a square root, then integrate that expression over the correct bounds.',
   'For y = x^2 on [0,2], a student sets up the arc length integral as the integral from 0 to 2 of sqrt(1 + (x^2)^2) dx, squaring the original function instead of its derivative.',
   'This is correct, since squaring the function itself inside the square root is the standard arc length pattern.',
   'The arc length formula requires the derivative squared, not the original function squared -- since dy/dx = 2x for y = x^2, the correct setup is the integral from 0 to 2 of sqrt(1 + (2x)^2) dx, not sqrt(1 + (x^2)^2) dx; using the function''s own value instead of its derivative produces an entirely different, incorrect integrand, and this topic itself is BC-only, not shared with AB.',
   'Using area under the curve instead of the arc length formula.',
   'Before setting up any arc length integral, find the derivative explicitly first, and confirm it (not the original function) is what gets squared inside the square root.')
)
update app.topic_explainers e
set
  core_idea = u.core_idea,
  what_students_need_to_understand = u.what_students_need_to_understand,
  how_this_becomes_points = u.how_this_becomes_points,
  answer_move = u.answer_move,
  mini_example_question = u.mini_example_question,
  weak_answer = u.weak_answer,
  point_attaining_answer = u.point_attaining_answer,
  common_point_loss = u.common_point_loss,
  practice_bridge = u.practice_bridge,
  source_note = 'cramapple-authored; repaired 2026-08-21 replacing a template-generated explainer (previously duplicated-from-AB, then generated-from-brief, grandfathered) with topic-specific content grounded in AP_CALCULUS_AB_BC_CED_FACT_PACK.md Unit 8 deep-tier detail (the documented real 2025 Q1 average-value-vs-average-rate-of-change error, the stricter antiderivative-leading-constant gatekeeping rule for motion problems, the cross-part consistency/follow-through scoring convention, the missing-pi-costs-exactly-one-point rule, the self-correcting reversed-difference-of-squares washer pattern, the documented real 2025 Q2 washer-missing-constant-shift error, and the boxed BC-only arc-length exclusion with its own dedicated Enduring Understanding CHA-6); AP Calculus AB''s Unit 8 explainers are still grandfathered debt as of this batch, so every mini-example here is checked only against the corpus-wide distinctness query, not against an AB Unit 8 repair that does not yet exist; batch 2026-08-21-ap-calculus-bc-unit8-explainer-repair; author=reviewer same session, no independent human review yet'
from explainer_updates u
where e.subject_key = 'ap_calculus_bc'
  and e.unit_number = 8
  and e.topic_code = u.topic_code;

do $$
declare
  v_repaired integer;
  v_core_matches integer;
begin
  select count(*) into v_repaired from app.topic_explainers
    where subject_key='ap_calculus_bc' and unit_number=8 and status='published'
      and source_note like '%unit8-explainer-repair%';
  if v_repaired <> 13 then
    raise exception 'expected 13 repaired AP Calculus BC Unit 8 explainers, got %', v_repaired;
  end if;

  select count(*) into v_core_matches
  from app.topic_point_briefs b
  join app.topic_explainers e on e.subject_key=b.subject_key and e.topic_code=b.topic_code
  where b.subject_key='ap_calculus_bc' and b.unit_number=8 and b.status='published'
    and e.status='published' and e.core_idea = b.what_it_is;
  if v_core_matches <> 0 then
    raise exception 'expected 0 AP Calculus BC Unit 8 explainers matching their brief verbatim, got %', v_core_matches;
  end if;
end $$;

commit;
