begin;

-- Repair AP Calculus AB Unit 5 (Analytical Applications of Differentiation)
-- Learn More explainers. The 12 point briefs for this unit are already
-- hand-authored and correct (each brief's what_it_is is genuinely
-- topic-specific, not boilerplate) and are NOT touched by this migration.
-- All 12 explainers, however, are the template-generated debt flagged in the
-- 2026-08-21 grandfathering pass: core_idea byte-identical to the paired
-- brief's what_it_is, and a meta-question mini-example ("A calculus prompt
-- asks you to justify a conclusion involving <title>...") with a
-- weak_answer ("I would write the final value or conclusion without
-- showing why it follows.") shared across roughly 150 rows corpus-wide.
--
-- Verified at the content level before authoring (per the lesson from the
-- earlier AP Calculus AB Unit 1 false start on this exact subject, where a
-- batch with the same grandfathered tag turned out to already be genuine
-- hand-authored content): a Step 0 query joined all 12 rows against their
-- paired briefs. All 12 showed core_idea = paired brief's what_it_is
-- (byte-for-byte), source_note = 'generated-from-brief:legacy;
-- grandfathered-2026-08-21' (not 'repaired'), and the identical boilerplate
-- weak_answer / meta-question mini_example_question template. No row was
-- excluded from this batch -- all 12 (5.1-5.12) are confirmed debt.
--
-- This is a Repair under
-- docs/product/TOPIC_BRIEFS_AND_LEARN_MORE_PRODUCTION_PROTOCOL.md.
-- Before-state was not separately captured as a standalone artifact for
-- this batch; rollback is restoring source_note to
-- 'generated-from-brief:legacy; grandfathered-2026-08-21' and the other 9
-- fields to the boilerplate template values documented above (identical in
-- shape to every other still-grandfathered row in the corpus).
--
-- Every new explainer is genuinely topic-specific: core_idea differs from
-- the paired brief's what_it_is on every row and grounds each topic in
-- docs/product/AP_CALCULUS_AB_BC_CED_FACT_PACK.md's Unit 5 section, which
-- is flagged there as the single highest-value unit in the whole fact pack
-- for scoring-architecture precision. Topics 5.1 (Mean Value Theorem
-- hypothesis-statement requirement), 5.2/5.4/5.5/5.7 (the Candidates Test
-- vs. local-test global-vs-local justification split, confirmed across
-- multiple real 2025 FRQ parts, including the documented near-miss of
-- presenting a critical x-value without the equation-setting step, and the
-- documented real student error of a numerically correct answer earning no
-- justification point because only a local argument was given) draw
-- directly on that fact-pack detail. Topics 5.3, 5.6, 5.8, 5.9, 5.10, 5.11,
-- and 5.12 do not have a named fact-pack misconception beyond the unit's
-- general precise-notation theme ("refer to f, f', and f'' by name, rather
-- than by 'it' or 'the function'"), so those seven rows are grounded
-- directly in each topic's own point brief common_point_loss language plus
-- an independently verified original calculus problem, per the protocol
-- (matching how AB Unit 3's 3.3-3.6 rows were handled). Every
-- mini_example_question / weak_answer / point_attaining_answer /
-- practice_bridge is an original, independently computed calculus problem,
-- verified against no other published row in the corpus before this
-- migration was applied.

with explainer_updates (
  topic_code, core_idea, what_students_need_to_understand,
  how_this_becomes_points, answer_move, mini_example_question, weak_answer,
  point_attaining_answer, common_point_loss, practice_bridge
) as (
  values
  ('5.1',
   'The Mean Value Theorem''s conclusion is only valid once both hypotheses are stated as explicit sentences -- continuity on the closed interval [a,b] and differentiability on the open interval (a,b) -- and a response that jumps straight to solving f''(c) equal to the secant slope without stating those conditions has skipped the justification step even if the numeric c-value it finds is correct.',
   'MVT guarantees at least one point c in (a,b) where the instantaneous rate f''(c) equals the average rate of change over [a,b], but that guarantee only holds under its two named hypotheses -- a function can fail to be differentiable at even one interior point and the guaranteed c may not exist, so the hypothesis check is not optional scaffolding, it is graded content.',
   'Credit requires an explicit statement that f is continuous on the closed interval and differentiable on the open interval (polynomials, and sums/products of familiar differentiable functions, justify this in one sentence), followed by computing the average rate of change and solving f''(c) equal to that value -- solving for c without ever stating the hypotheses does not earn the justification point.',
   'State continuity on [a,b] and differentiability on (a,b) first, compute the average rate of change (f(b)-f(a))/(b-a), then set f''(c) equal to that value and solve for c inside the open interval.',
   'Let f(x) = x^3 - 3x on [0,3]. Use the Mean Value Theorem to find all values of c guaranteed by the theorem.',
   'The average rate is (18-0)/3 = 6, and solving 3c^2-3=6 gives c = sqrt(3), reported with no mention of continuity or differentiability anywhere in the response.',
   'f is a polynomial, so it is continuous on [0,3] and differentiable on (0,3), satisfying MVT''s hypotheses. f(0)=0, f(3)=18, so the average rate is (18-0)/3=6. Setting f''(c)=3c^2-3=6 gives c^2=3, so c=sqrt(3), which lies in (0,3).',
   'Solving for the guaranteed c-value without ever stating the continuity-on-closed-interval and differentiability-on-open-interval hypotheses that make the theorem''s conclusion valid in the first place.',
   'Return to practice and write the continuity/differentiability sentence before computing any average rate, every single time.'),
  ('5.2',
   'The Extreme Value Theorem guarantees a global max and global min exist on a closed interval, but locating them is not the same step as finding critical points -- a documented near-miss is presenting a critical x-value with no equation-setting step or explicit critical-point language, and a separate common error is comparing only critical-point values while never evaluating the endpoints.',
   'Critical points occur only where f''(x)=0 or where f'' is undefined, and on a closed interval the global extrema are guaranteed by EVT to occur either at one of those critical points or at an endpoint -- a critical point is not automatically a local or global extremum until sign behavior or a value comparison confirms it.',
   'Credit requires showing the equation-setting work that produces each critical x-value (not just stating the value), then building a complete candidate list that includes both interior critical points and both endpoints before naming the global max and min.',
   'Solve f''(x)=0 and note where f'' is undefined to get every critical point, add both endpoints to the candidate list, then evaluate f at every candidate to identify the global extrema.',
   'Let f(x) = x^3 - 6x^2 + 5 on [-1,5]. Find the absolute maximum and absolute minimum values of f on this interval.',
   'f''(x)=3x^2-12x=0 gives critical points x=0 and x=4, and the response calls x=0 the maximum and x=4 the minimum without ever evaluating the endpoints x=-1 or x=5.',
   'f''(x)=3x^2-12x=3x(x-4)=0 gives critical points x=0 and x=4. Evaluating all candidates: f(-1)=-2, f(0)=5, f(4)=-27, f(5)=-20. The absolute maximum is 5 at x=0, and the absolute minimum is -27 at x=4.',
   'Reporting a critical x-value without showing the equation-setting step behind it, or building a candidate list from critical points alone and never evaluating the interval''s endpoints.',
   'Go back to practice and build a full endpoints-plus-critical-points candidate list before naming any extreme value.'),
  ('5.3',
   'Increasing and decreasing intervals are determined by the sign of f'' on a sign chart, never by directly comparing two f-values at chosen points -- comparing endpoint function values alone can look like it proves monotonic behavior while missing a dip or rise that happens strictly between them.',
   'A sign chart for f'' partitions the domain at critical points, and the sign of f'' on each resulting sub-interval (not the raw value of f) tells you whether f is increasing or decreasing there -- intervals are always reported using x-values, since increasing/decreasing describes behavior over a range of x, not a single y comparison.',
   'Credit requires testing the sign of f'' in each interval created by the critical points and reporting increasing/decreasing conclusions by x-interval -- comparing f-values at two isolated points instead of building the sign chart does not earn the point, even when the comparison happens to point the right direction.',
   'Find every critical point of f, build a sign chart for f'' using a test point in each resulting interval, then state increasing or decreasing using x-intervals, not y-value comparisons.',
   'Let f(x) = x^3 - 3x^2. Determine the intervals on which f is increasing and decreasing.',
   'Since f(3)=0 is greater than f(1)=-2, the response concludes f is increasing on [1,3], never checking that f actually dips between x=1 and x=2 before rising again.',
   'f''(x)=3x^2-6x=3x(x-2)=0 gives critical points x=0 and x=2. Testing f''(-1)=9>0, f''(1)=-3<0, f''(3)=9>0 gives the sign chart: f is increasing on (-infinity,0), decreasing on (0,2), and increasing on (2,infinity).',
   'Comparing raw f-values at two chosen x-values instead of building a sign chart from f'' -- a comparison of endpoints can be numerically consistent with the right conclusion while completely missing interior behavior.',
   'Back to practice: build the f'' sign chart before writing any increasing/decreasing conclusion, never skip straight to comparing values.'),
  ('5.4',
   'The First Derivative Test classifies a critical point only after checking that f'' actually changes sign around it -- f''(c)=0 alone proves the point is critical, not that it is a maximum or minimum, and treating f''(c)=0 as sufficient on its own is the single most common error on this topic.',
   'A local maximum requires f'' to change from positive to negative moving left to right through the critical point, and a local minimum requires the reverse (negative to positive) -- if f'' does not change sign there, the point is neither a local max nor a local min, no matter what f''(c) equals.',
   'Credit requires testing f'' on both sides of the critical point and showing the sign change (or lack of one) explicitly before naming the extremum -- stating f''(c)=0 and immediately naming a maximum or minimum without the two-sided sign check does not earn the point.',
   'Find each critical point, test the sign of f'' just to the left and just to the right of it, then name a local max only for a positive-to-negative change and a local min only for a negative-to-positive change.',
   'Let f(x) = x^3 - 3x^2 - 9x + 5. Use the First Derivative Test to classify each critical point.',
   'f''(-1)=0 and f''(3)=0, so the response reports x=-1 as a local maximum and x=3 as a local minimum without ever testing the sign of f'' on either side of those points.',
   'f''(x)=3x^2-6x-9=3(x-3)(x+1)=0 gives critical points x=-1 and x=3. Testing f''(-2)=15>0, f''(0)=-9<0, f''(4)=15>0 shows f'' changes from positive to negative at x=-1 (local max, f(-1)=10) and from negative to positive at x=3 (local min, f(3)=-22).',
   'Naming a critical point a maximum or minimum immediately after finding f''(c)=0, without ever showing the sign of f'' on both sides that actually justifies the classification.',
   'Return to practice and test both sides of every critical point before writing the word maximum or minimum.'),
  ('5.5',
   'The Candidates Test is a distinct global-extrema tool from the First and Second Derivative Tests, and real AP scoring treats them as non-interchangeable: a response that uses only a local sign-change argument to justify an absolute extremum does not earn the justification point even when the final numeric answer is correct -- it remains eligible only for the separate answer point, never the justification point.',
   'Absolute extrema on a closed interval are found by evaluating the original function (never the derivative) at every critical point in the domain and at both endpoints, then comparing that full set of function values -- a critical point''s local behavior, confirmed by a sign change in f'', says nothing by itself about how that value compares to the interval''s endpoints.',
   'Credit requires evaluating f at the complete candidate list (every interior critical point plus both endpoints) and comparing those values directly -- justifying the global extremum with a local-only argument, such as a First Derivative Test sign change with no endpoint comparison, does not earn the justification point.',
   'List every critical point in the domain plus both endpoints, evaluate the original function at each candidate, then select the largest value as the absolute maximum and the smallest as the absolute minimum.',
   'Let g(x) = x^4 - 8x^2 on [-1,3]. Use the Candidates Test to find the absolute maximum and absolute minimum values of g.',
   'g''(x)=4x(x-2)(x+2)=0 gives x=0 and x=2 as candidates in [-1,3]; testing g'' around x=2 shows a sign change from negative to positive, so the response concludes x=2 gives the absolute minimum using only that local sign-change argument, without ever evaluating the endpoints.',
   'Candidates are x=-1, 0, 2, 3 (critical points 0 and 2, both endpoints). g(-1)=-7, g(0)=0, g(2)=-16, g(3)=9. Comparing all four values: the absolute maximum is 9 at x=3, and the absolute minimum is -16 at x=2.',
   'Justifying an absolute extremum with only a local sign-change argument (First or Second Derivative Test) instead of building and comparing the full endpoints-plus-critical-points candidates table -- this blocks the justification point even when the numeric answer is correct.',
   'Go back to practice and build the full candidates table every time the question asks for an absolute extremum, never justify globally with a local test alone.'),
  ('5.6',
   'Concavity is governed by the sign of f'', never the sign of f'' -- a response that reuses the increasing/decreasing sign chart from f'' to answer a concavity question has tested the wrong derivative, since f'' sign describes slope direction, not whether that slope is itself increasing or decreasing.',
   'Concave up means the slope f'' is increasing, which happens exactly where f''>0; concave down means f'' is decreasing, exactly where f''<0 -- concavity is a statement about the second derivative''s sign, and confusing it with the first derivative''s sign produces a plausible-looking but structurally wrong sign chart.',
   'Credit requires building the sign chart from f'' specifically and translating that sign into concave up or concave down by interval -- a sign chart built from f'' instead of f'' does not earn the point even if the increasing/decreasing conclusions it produces are individually correct.',
   'Find f'', locate where it is zero or undefined, build a sign chart for f'' using test points, then report concave up where f''>0 and concave down where f''<0.',
   'Let h(x) = x^4 - 6x^2. Determine the intervals on which h is concave up and concave down.',
   'h''(x)=4x^3-12x, and the response tests the sign of h'' at x=-2,0,2 and reports those as the concavity intervals, never computing h'' at all.',
   'h''(x)=12x^2-12=12(x-1)(x+1). Testing h''(0)=-12<0 and h''(2)=36>0 gives: h is concave down on (-1,1) and concave up on (-infinity,-1) and (1,infinity).',
   'Building the sign chart from f'' (the increasing/decreasing test) instead of f'' (the concavity test) -- the two derivatives answer structurally different questions and are not interchangeable.',
   'Back to practice: before answering any concavity question, confirm the sign chart is built from f'', not f''.'),
  ('5.7',
   'The Second Derivative Test only applies when f''(c) is nonzero -- if f''(c)=0, the test is explicitly inconclusive, and treating that inconclusive result as if it still classified the point (rather than falling back to the First Derivative Test) is the topic''s most common error.',
   'When f''(c)=0 and f''(c)>0, c is a local minimum; when f''(c)<0, c is a local maximum -- but when f''(c)=0, the test gives no information at all, and the correct response is to abandon it and check the sign change of f'' directly instead of forcing a conclusion from an inconclusive result.',
   'Credit requires checking whether f''(c) is actually nonzero before applying the classification rule, and switching to the First Derivative Test when f''(c)=0 -- reporting a classification from an inconclusive f''(c)=0 result does not earn the point, regardless of whether the classification is coincidentally correct.',
   'Confirm f''(c)=0 first, then evaluate f''(c) -- classify using the sign of f''(c) only if it is nonzero, and fall back to the First Derivative Test if f''(c)=0.',
   'Let k(x) = x^4. Use the Second Derivative Test to classify the critical point at x=0, if the test applies.',
   'k''(0)=12(0)^2=0, and the response states that since f''(0) is not negative, x=0 must be a local minimum, treating the inconclusive result as if it still supported a conclusion.',
   'k''(x)=4x^3=0 gives the critical point x=0. k''(x)=12x^2, so k''(0)=0 and the Second Derivative Test is inconclusive. Falling back to the First Derivative Test: k''(x)=4x^3 is negative for x<0 and positive for x>0, so x=0 is a local minimum by that test instead.',
   'Reaching a classification directly from f''(c)=0 instead of recognizing the test is inconclusive there and switching to the First Derivative Test to actually justify the classification.',
   'Return to practice and check whether f''(c) is nonzero before ever naming a maximum or minimum from the Second Derivative Test.'),
  ('5.8',
   'A graph sketch of f is only as good as the derivative evidence behind it -- every increasing/decreasing interval, extremum, concavity interval, and inflection point drawn must trace back to an explicit sign chart for f'' and f'', not to what the curve intuitively looks like it should do.',
   'Sketching coordinates three separate pieces of derivative evidence at once: the sign of f'' locates increasing/decreasing intervals and extrema, the sign of f'' locates concavity intervals and inflection points, and the two sign charts must agree with each other everywhere the sketch is drawn.',
   'Credit requires annotating the sign charts for f'' and f'' before drawing, then producing a sketch whose increasing/decreasing behavior, extrema, concavity, and inflection points all match that annotated evidence -- a sketch produced from intuition, without a derivative sign chart behind each feature, does not earn the point.',
   'Build the f'' sign chart to mark increasing/decreasing intervals and extrema, build the f'' sign chart to mark concavity and inflection points, then sketch only the features that evidence supports.',
   'Let m(x) = -x^3 + 3x. Sketch the graph, labeling all local extrema and inflection points using derivative evidence.',
   'The response draws a smooth S-shaped curve through a few plotted points and labels a high point and low point by eye, without computing m''(x) or m''(x) anywhere to justify their locations.',
   'm''(x)=-3x^2+3=-3(x-1)(x+1). Testing m''(-2)=-9, m''(0)=3, m''(2)=-9 gives sign pattern negative-positive-negative, so m has a local min at x=-1 (m(-1)=-2) and a local max at x=1 (m(1)=2). m''(x)=-6x is positive for x<0 and negative for x>0, giving an inflection point at x=0 (m(0)=0), and the sketch is drawn to match exactly these labeled features.',
   'Drawing a graph from the general shape one expects rather than from an explicit f'' and f'' sign chart -- a sketch with no derivative evidence behind each labeled feature does not earn credit, even if it happens to look plausible.',
   'Go back to practice and write both sign charts out fully before drawing a single point of the sketch.'),
  ('5.9',
   'The CED''s own guidance for this unit is explicit: refer to f, f'', and f'' by name, never as "it" or "the function," because when a graph shown is of f'' itself, that graph''s own peaks and valleys are not the extrema of f -- they are the points where f''=0, which locate inflection points of f, not local maxima or minima of f.',
   'Extrema of f occur where the graph of f'' crosses zero (changes sign), while inflection points of f occur where the graph of f'' itself has a peak or valley (since that is where f'', the slope of f'', equals zero) -- confusing a feature of the f'' graph for a feature of the f graph produces a specific, predictable, and named misclassification.',
   'Credit requires identifying which graph is actually given (f, f'', or f'') and translating its features correctly into statements about f -- reading an extremum of the f'' graph itself as if it were an extremum of f, instead of correctly reading it as an inflection point of f, does not earn the point.',
   'Confirm which function''s graph is shown, then translate: zeros of f'' where it changes sign give extrema of f, and peaks/valleys of the f'' graph (zeros of f'') give inflection points of f.',
   'The graph of f''(x) = 4 - x^2 is given. Using this graph of f'', identify any local extrema and inflection points of f.',
   'Since the graph of f''(x)=4-x^2 has its own maximum at x=0, the response reports x=0 as a local maximum of f, never checking where f'' actually changes sign.',
   'f''(x)=4-x^2 changes sign from negative to positive at x=-2 (local min of f) and from positive to negative at x=2 (local max of f). f''(x)=-2x, so f''(0)=0 with f'' changing from positive to negative there, giving an inflection point of f at x=0 -- the peak of the given f'' graph corresponds to an inflection point of f, not an extremum of f.',
   'Reading a peak or valley of the graph actually shown (f'') as if it belonged to f itself, instead of correctly translating it into the feature it actually represents for f.',
   'Back to practice: before answering, write down in words which function''s graph is shown, then translate its features into statements about f explicitly.'),
  ('5.10',
   'An optimization setup is not complete until the quantity to be optimized is written as a function of exactly one variable, with any constraint already substituted in -- differentiating a two-variable expression like A=xy before using the constraint to eliminate one variable is the topic''s most common structural error.',
   'Optimization begins by naming every variable, writing the objective quantity''s formula (which usually starts with two or more variables), then using the given constraint to substitute and reduce that formula down to a single-variable function before any derivative work begins, and stating the domain that constraint implies.',
   'Credit requires defining variables, writing the objective as a function of one variable using the constraint, and stating the resulting domain -- differentiating an expression that still contains two independent variables, before the constraint has been substituted in, does not earn the setup point.',
   'Define the variables, write the objective quantity''s formula, use the constraint to substitute and reduce to one variable, then state the domain before differentiating.',
   'A rectangular garden uses an existing wall as one side, so only the other three sides need fencing, and exactly 40 feet of fencing is available. Set up the area as a one-variable function before differentiating.',
   'The response writes A=xy and immediately sets dA/dx=y+x(dy/dx)=0, differentiating the two-variable area formula directly instead of ever substituting the fencing constraint to eliminate y first.',
   'Let x be the width of each of the two fenced sides perpendicular to the wall and y be the length of the fenced side parallel to the wall. The fencing constraint is 2x+y=40, so y=40-2x. Substituting gives A(x)=x(40-2x)=40x-2x^2, with domain 0<x<20 -- only now is the function ready to differentiate.',
   'Differentiating an expression that still has two independent variables in it, before the given constraint has been used to reduce the objective to a genuine one-variable function.',
   'Go back to practice and write the reduced one-variable objective function and its domain before touching a derivative.'),
  ('5.11',
   'Finding a critical point of the objective function is not the same as proving it gives the requested maximum or minimum -- a response that solves f''(x)=0 and stops has found a candidate, not a justified answer, and AP credit for the conclusion requires the extra justification step plus a final answer stated in context with units.',
   'After the objective function and its domain are set up, solving f''(x)=0 gives candidate x-values, but a full solution still needs to justify that a specific candidate is the maximum or minimum (via the Second Derivative Test, endpoint comparison, or a sign chart) and then answer the original applied question in its own terms, not just report a bare x-value.',
   'Credit requires differentiating, solving for critical points, justifying which candidate gives the requested extremum, and then answering the actual applied question with correct units and variables -- stopping at the critical point without the justification and contextual answer steps does not earn the final answer point.',
   'Differentiate the objective function, solve f''(x)=0 for candidates, justify the extremum with a second-derivative or endpoint check, then answer the original question in context with units.',
   'Using A(x) = 40x - 2x^2 on the domain 0<x<20 from a fencing problem, find the maximum possible area and state it in context.',
   'A''(x)=40-4x=0 gives x=10, and the response reports "x=10" as the final answer, never confirming this is a maximum or computing the actual maximum area in square feet.',
   'A''(x)=40-4x=0 gives x=10. A''(x)=-4<0 confirms a maximum at x=10 (or comparing A(0)=0, A(20)=0, A(10)=200 confirms it directly). With x=10, y=40-2(10)=20, so the maximum possible area is 200 square feet, achieved when the fenced sides are 10 ft and 20 ft.',
   'Solving for the critical x-value and stopping there, without justifying that it actually produces the requested maximum or minimum and without answering the original applied question in its own context and units.',
   'Return to practice and finish every optimization problem with the justification step and a contextual answer, never a bare critical value.'),
  ('5.12',
   'Differentiating an implicit relation requires applying the chain rule to every y-term, attaching a dy/dx factor each time y is differentiated -- treating y as if it were a constant (differentiating y^2 to 0 instead of 2y*dy/dx) drops that factor entirely and produces a derivative that is not even structurally close to correct.',
   'An implicit relation like x^2+y^2=25 defines y as a function of x without ever solving for y explicitly, so differentiating it term by term still requires the chain rule on every y-containing term -- the relation''s slope, extrema, and concavity all depend on dy/dx being computed this way, not by first trying to isolate y.',
   'Credit requires applying the chain rule correctly to each y-term (producing a dy/dx factor every time), then solving algebraically for dy/dx -- differentiating a y-term as if y were a constant, or assuming the relation must first be solved explicitly for y, does not earn the differentiation point.',
   'Differentiate every term with respect to x, attach dy/dx via the chain rule wherever a y-expression was differentiated, then solve algebraically for dy/dx.',
   'For the circle x^2 + y^2 = 25, find dy/dx and determine the points where the tangent line is horizontal.',
   'Differentiating term by term, the response writes d/dx(y^2)=0 (treating y as a constant), giving 2x+0=0 and dy/dx=-2x, with no dy/dx factor ever appearing from the y^2 term.',
   'Differentiating implicitly: 2x + 2y*(dy/dx) = 0, so dy/dx = -x/y. A horizontal tangent requires dy/dx=0 with y defined, so x=0, giving the points (0,5) and (0,-5) on the circle.',
   'Differentiating a y-term as though y were a constant, which drops the required dy/dx chain-rule factor entirely, or assuming the relation needs to be solved explicitly for y before it can be differentiated at all.',
   'Back to practice: attach a dy/dx factor to every y-term before doing any algebra, never treat y as a constant.')
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
  source_note = 'cramapple-authored; repaired 2026-08-22 replacing a template-generated explainer (previously source_note ''generated-from-brief:legacy; grandfathered-2026-08-21'') with topic-specific content grounded in AP_CALCULUS_AB_BC_CED_FACT_PACK.md Unit 5 detail (the Mean Value Theorem hypothesis-statement requirement for topic 5.1, the Candidates Test vs. local-test global-vs-local justification split for topics 5.2/5.4/5.5/5.7, and independently verified, topic-specific calculus problems for topics 5.3/5.6/5.8/5.9/5.10/5.11/5.12 grounded in each brief''s own common_point_loss language); repair reason: grandfathered explainer restated the paired brief and used a generic meta-question mini-example shared across ~150 corpus rows; batch 2026-08-22-ap-calculus-ab-unit5-explainer-repair; author=reviewer same session, no independent human review yet'
from explainer_updates u
where e.subject_key = 'ap_calculus_ab'
  and e.unit_number = 5
  and e.topic_code = u.topic_code;

do $$
declare
  v_repaired integer;
  v_core_matches integer;
begin
  select count(*) into v_repaired from app.topic_explainers
    where subject_key='ap_calculus_ab' and unit_number=5 and status='published'
      and source_note like '%unit5-explainer-repair%';
  if v_repaired <> 12 then
    raise exception 'expected 12 repaired AP Calculus AB Unit 5 explainers, got %', v_repaired;
  end if;

  select count(*) into v_core_matches
  from app.topic_point_briefs b
  join app.topic_explainers e on e.subject_key=b.subject_key and e.topic_code=b.topic_code
  where b.subject_key='ap_calculus_ab' and b.unit_number=5 and b.status='published'
    and e.status='published' and e.core_idea = b.what_it_is;
  if v_core_matches <> 0 then
    raise exception 'expected 0 AP Calculus AB Unit 5 explainers matching their brief verbatim, got %', v_core_matches;
  end if;
end $$;

commit;
