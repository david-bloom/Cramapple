begin;

-- Repair AP Calculus BC Unit 5 (Analytical Applications of Differentiation)
-- Learn More explainers. Briefs were duplicated from AB's genuinely
-- hand-authored content and are correct; NOT touched here.
--
-- AP Calculus AB's Unit 5 explainers are still grandfathered debt as of
-- this batch (not yet repaired), so there is no AB Unit 5 hand-authored
-- batch to accidentally collide with the way BC/AB Unit 4 did.
--
-- Grounded in docs/product/AP_CALCULUS_AB_BC_CED_FACT_PACK.md Unit 5
-- deep-tier detail: the Candidates Test vs. a local First/Second
-- Derivative Test argument (a local test never justifies an absolute
-- extremum even with a correct final answer), the rule that presenting
-- only the critical x-value is not enough -- the derivative-setting work
-- must be shown, and the common f/f'/f'' graph-identification confusion.
--
-- Before-state captured at docs/research/
-- topic_guide_source_note_grandfather_2026_08_21/
-- ap_calculus_bc_unit5_explainer_before_state.json.
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
  ('5.1',
   'MVT does not just claim some c exists with a matching slope -- both hypotheses, continuity on the closed interval and differentiability on the open interval, have to be checked and stated, since the theorem simply does not apply without them.',
   'A function can be continuous everywhere on a closed interval and still fail the MVT hypothesis if it has even one non-differentiable point, such as a corner, inside the open interval.',
   'Full credit requires explicitly verifying both hypotheses before stating the conclusion, not just citing continuity and assuming differentiability follows.',
   'Check continuity on the closed interval and differentiability on the open interval as two separate, explicit conditions before applying MVT''s conclusion.',
   'f(x) = |x-2| is continuous on [0,4]. A student concludes MVT guarantees some c in (0,4) with f''(c) equal to the average rate of change over [0,4]. Evaluate this.',
   'Correct, since f is continuous on [0,4].',
   'Incorrect -- MVT also requires f to be differentiable on the open interval (0,4), and f(x) = |x-2| is not differentiable at x=2, a corner, which lies inside that interval, so MVT''s hypotheses are not fully met.',
   'Using the theorem without stating continuity on the closed interval and differentiability on the open interval.',
   'Before citing MVT''s conclusion, write out both hypotheses explicitly and check them against the specific function and interval given, not just the interval''s endpoints.'),
  ('5.2',
   'Presenting a critical point''s x-value alone, with no derivative-setting work shown, does not earn the point -- the work step or explicit critical-point language has to be visible, even when the value itself is correct.',
   'Critical-point credit is not about reaching the right number; it is about showing the equation f''(x)=0 (or identifying where f'' is undefined) as an explicit step before stating the value.',
   'Full credit requires the derivative-setting work shown as its own step, not just the resulting x-value presented on its own.',
   'Write the derivative, set it equal to zero (or note where it is undefined) as an explicit equation, then solve -- never present just the final x-value.',
   'A student writes ''x=4'' as the complete answer for finding the critical point of f(x) = (x-4)^2. Does this earn full credit?',
   'Yes, since x=4 is the correct critical point.',
   'No -- credit requires showing the derivative-setting work, f''(x) = 2(x-4) = 0, not just presenting the resulting x-value; a bare answer without that step does not earn the point even though x=4 is correct.',
   'Ignoring endpoints or calling every critical point a maximum or minimum.',
   'Never write a critical-point answer as a bare x-value -- always show the derivative equation being set to zero as its own visible step.'),
  ('5.3',
   'Increasing and decreasing behavior is described using the x-interval where f'' is positive or negative, never by naming the function''s output y-values -- these describe two different axes of the same graph.',
   'An increasing/decreasing conclusion is always stated as an x-interval, such as (2,5), because that is where the sign test was actually performed -- describing it by a range of y-values mixes up input and output.',
   'Full credit requires the conclusion stated as an x-interval matching the sign chart, not a range of function output values.',
   'State every increasing or decreasing conclusion as an x-interval taken directly from the sign chart for f'', never as a range of y-values.',
   'f''(x) > 0 on (2,5), so f is increasing there. A student states the conclusion as ''f is increasing from y=3 to y=10.''',
   'This is a correct way to describe the same increasing behavior.',
   'The conclusion should be stated using the x-interval where f'' is positive, (2,5), not by naming output y-values -- increasing and decreasing describe behavior over an x-interval, not a y-range.',
   'Using f-values instead of derivative signs to decide increasing or decreasing intervals.',
   'Build the sign chart for f'' first, then state every increasing/decreasing conclusion as the matching x-interval, never a y-value range.'),
  ('5.4',
   'f''(c)=0 only identifies a critical point -- classifying it as a local maximum or minimum requires checking that f'' actually changes sign on both sides of c, not just that it equals zero there.',
   'A critical point where f''(c)=0 could be a local max, a local min, or neither (if the sign does not change at all), so the sign-change check on both sides is not optional evidence, it is the entire justification.',
   'Full credit requires showing f''''s sign on both the left and right of the critical point, not just stating f''(c)=0 and naming an extremum type.',
   'Check f''''s sign just to the left and just to the right of the critical point before naming it a local maximum, local minimum, or neither.',
   'f''(3)=0 for some function f. A student concludes f has a local maximum at x=3 because the derivative is zero there.',
   'Correct, since f''(3)=0 identifies a local maximum.',
   'Incorrect as stated -- f''(3)=0 only identifies a critical point; classifying it as a local maximum requires checking that f'' changes from positive to negative on either side of x=3, which was never shown.',
   'Saying f''(c)=0 is enough to prove a maximum or minimum.',
   'Never stop at f''(c)=0 -- always check and state the sign of f'' on both sides before naming the type of extremum.'),
  ('5.5',
   'Justifying an absolute extremum with a local argument, the First or Second Derivative Test, does not earn the justification point even when the final numeric answer is correct -- only comparing values at every critical point and both endpoints, the Candidates Test, justifies a global claim.',
   'A local test can correctly identify a local maximum or minimum, but that is a fundamentally different claim from an absolute extremum on a closed interval, which requires comparing against every candidate, not just the immediate neighborhood of one point.',
   'The justification point for an absolute extremum requires the Candidates Test comparison explicitly shown; a correct local-test argument still earns the separate final-answer point, but never the justification point for a global claim.',
   'For an absolute extremum question, build a candidates table comparing f-values at every critical point and both endpoints -- never justify with a local sign-change argument alone.',
   'On the closed interval [0,6], a student finds a critical point at x=4, shows f'' changes from positive to negative there (a local max by the First Derivative Test), and concludes f has an absolute maximum at x=4. Evaluate this justification.',
   'Correct, since the sign change confirms a maximum.',
   'The final value may be correct, but the justification is not -- a local argument like the First Derivative Test never justifies an absolute extremum; only comparing f-values at every critical point and both endpoints earns the justification point, though the answer-value point can still be earned separately.',
   'Comparing derivative values instead of function values or omitting endpoints.',
   'Whenever a question asks for an absolute extremum, build the candidates table first -- a local-test sign change is never sufficient justification on its own.'),
  ('5.6',
   'Concavity is decided entirely by the sign of f'''', the second derivative -- checking f''''s own sign answers a different question, whether the function is increasing or decreasing, not whether it curves upward or downward.',
   'f'' positive or negative tells you increasing or decreasing; f'''' positive or negative tells you concave up or concave down -- these are two separate sign tests on two different functions, and swapping them answers the wrong question.',
   'Full credit for a concavity question requires the sign chart built from f'''', not f''.',
   'Before answering any concavity question, confirm you are building the sign chart from f'''', not f''.',
   'A student determines concavity by checking where f''(x) is positive or negative.',
   'This is correct, since f'' sign describes the shape of the curve.',
   'This is incorrect -- concavity is determined by the sign of f'''', the second derivative, not f''; f'' sign determines increasing or decreasing, a separate question from concavity.',
   'Using f'' sign to decide concavity instead of f'''' sign.',
   'Before answering, name out loud which derivative, first or second, the question is actually asking about.'),
  ('5.7',
   'When f''''(c)=0, the second derivative test is inconclusive, not negative -- it means this particular test cannot decide, not that no extremum exists, and a different method has to be used instead.',
   'An inconclusive result is a statement about the test''s limits, not about the function -- concluding ''no extremum'' from f''''(c)=0 replaces an honest ''I need another method'' with a claim the test never actually made.',
   'Full credit requires recognizing f''''(c)=0 as inconclusive and switching to the First Derivative Test, not treating it as evidence against an extremum.',
   'If f''''(c)=0 or is undefined, state that the second derivative test is inconclusive and switch to the First Derivative Test instead of concluding anything from f'''' alone.',
   'f''(2)=0 and f''''(2)=0 for some function f. A student concludes there is no local extremum at x=2 because the second derivative test failed.',
   'Correct, since f''''(2)=0 rules out a local extremum.',
   'Incorrect -- f''''(2)=0 makes the second derivative test inconclusive, not negative; it says nothing about whether an extremum exists, and the First Derivative Test would be needed to actually determine that.',
   'Using the test when f''''(c)=0 and treating an inconclusive result as a conclusion.',
   'Whenever f''''(c)=0 or is undefined, say ''inconclusive, switch methods'' out loud rather than drawing any conclusion from that result.'),
  ('5.8',
   'A sketch should only show what the derivative evidence actually supports -- gather the sign charts for f'' and f'''' first, and let those charts, not intuition about what a graph ''should'' look like, decide every feature drawn.',
   'Each graph feature, an extremum, an inflection point, a concavity change, needs its own piece of derivative evidence before it can be drawn -- a feature added from intuition without matching evidence is not supported by the given information.',
   'Full credit requires every sketched feature to be traceable to a specific piece of sign-chart evidence, not added because it looks reasonable.',
   'Build the sign charts for f'' and f'''' first, then sketch only the features those charts actually support.',
   'Given only that f''(x)>0 on (negative infinity, 2) and f''(x)<0 on (2, infinity), with no information about f'''', a student draws a graph with an inflection point at x=2.',
   'This is reasonable, since the derivative changes sign there.',
   'This is not supported -- an inflection point requires evidence about concavity from f'''', which was never given; the sign change in f'' alone only supports a local maximum at x=2, not an inflection point.',
   'Drawing a graph from intuition without tying features to derivative sign or second-derivative sign.',
   'Before drawing any feature, name the specific piece of derivative evidence, from f'' or from f'''', that supports it.'),
  ('5.9',
   'A graph of f'' is easy to mistake for a graph of f itself -- extrema and concavity of f are read from where the shown f'' graph crosses zero and how it behaves, not from the shape of that f'' graph as if it directly were f.',
   'If the graph shown is f'', then a zero crossing of that graph corresponds to a critical point of f, and whether f'' is increasing or decreasing there corresponds to concavity of f -- none of this is read the same way you would read a graph of f directly.',
   'Full credit requires correctly identifying which function''s graph is shown and translating its features into conclusions about the other function, rather than reading the shown graph as if it directly represented f.',
   'Before answering, confirm explicitly which function''s graph is shown, then translate its features (zeros, sign, increasing/decreasing) into what they say about the other function.',
   'A graph shown is the graph of f''(x), which crosses zero and changes from positive to negative at x=5. A student says the graph has a local maximum at x=5.',
   'Correct, since the graph changes direction at x=5.',
   'This confuses the two functions -- since the graph shown is f'', not f, the fact that f'' changes from positive to negative at x=5 means f, not the graph shown, has a local maximum at x=5; the shown graph itself simply crosses zero there.',
   'Confusing the graph of f with the graph of f'' when identifying extrema or concavity.',
   'Before reading any feature off a given graph, state explicitly which function, f, f'', or f'''', that graph represents.'),
  ('5.10',
   'An optimization objective has to be reduced to a single variable using the given constraint before any differentiation happens -- differentiating a two-variable expression, treating the other variable as if it were already constant, skips a required setup step.',
   'Writing an objective like Area = xy is not yet ready to differentiate; the constraint relating x and y has to be solved and substituted in first, producing a genuine one-variable function of x alone.',
   'Full credit requires the constraint substitution shown as its own step, producing a one-variable objective function, before any derivative is taken.',
   'Solve the constraint for one variable in terms of the other, substitute it into the objective, and confirm you have a genuine one-variable function before differentiating.',
   'A rectangle''s perimeter is 40. A student wants to maximize area, writes A = xy, then immediately differentiates with respect to x, treating y as an unrelated constant.',
   'This is valid, since area depends on both x and y.',
   'This skips a required step -- the perimeter constraint (2x+2y=40, so y=20-x) must be substituted in first, reducing A to the one-variable function A(x) = x(20-x), before differentiating.',
   'Differentiating before creating a valid one-variable objective function.',
   'Before differentiating any optimization setup, check explicitly that the objective is written as a function of one variable alone, using the constraint to eliminate the other.'),
  ('5.11',
   'Finding a critical point is not the end of an optimization problem -- the response still has to justify that the critical value is actually the requested maximum or minimum, and answer in context with units, not just report the numeric extremum.',
   'A correct critical point and a correct final number can still be an incomplete response if the justification step, comparing the critical value against endpoints or using a derivative test, is never shown.',
   'Full credit requires the justification comparison shown explicitly, plus the final answer stated in context with the requested variable and units.',
   'After finding the critical point, explicitly compare it against the domain''s endpoints (or apply a derivative test) before stating the final answer in context with units.',
   'A student sets up A(x) = x(20-x) on [0,20], finds the critical point x=10, and states the maximum area is 100 without further justification.',
   'This is complete, since the critical point and value are both correct.',
   'The value is correct, but the response is missing the justification step -- comparing A(10)=100 to the endpoint values A(0)=0 and A(20)=0 confirms x=10 gives the maximum, and this comparison must be shown, not just the final number.',
   'Finding a critical point but not proving it gives the requested maximum or minimum.',
   'Never state a final optimization answer without showing the comparison, against endpoints or via a derivative test, that proves it is actually the requested extremum.'),
  ('5.12',
   'A term like xy inside an implicit relation is a product of two factors that both depend on x, so differentiating it requires the product rule, producing a dy/dx term from the y-factor -- treating y as if it were an ordinary constant drops that required term entirely.',
   'Even outside a related-rates or tangent-line problem, any implicit relation involving both x and y needs the same chain-rule treatment on y-terms established in implicit differentiation -- behavior questions about implicit curves are not exempt from that rule.',
   'Full credit requires every product involving both x and y to produce its full product-rule expansion, including the dy/dx factor, not a shortcut that treats y as constant.',
   'Treat any term mixing x and y as a product requiring the product rule, and make sure the resulting dy/dx factor from the y-part is actually present before simplifying.',
   'For the curve x^2 + xy = 10, a student differentiates implicitly and writes 2x + y = 0, treating xy as if only its x-factor needed differentiating.',
   'This is correct; differentiating xy with respect to x gives y.',
   'This is incomplete -- xy is a product of two factors both depending on x, so the product rule applies: differentiating xy gives x(dy/dx) + y, not just y; the correct implicit differentiation is 2x + x(dy/dx) + y = 0.',
   'Trying to treat y as a constant or assuming the relation is already solved for y.',
   'Whenever an implicit relation has a term mixing x and y, write out the full product-rule expansion for that term before simplifying anything else.')
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
  source_note = 'cramapple-authored; repaired 2026-08-21 replacing a template-generated explainer (previously duplicated-from-AB, then generated-from-brief, grandfathered) with topic-specific content grounded in AP_CALCULUS_AB_BC_CED_FACT_PACK.md Unit 5 deep-tier detail (the Candidates-Test-vs-local-test scoring split, the critical-x-value-alone-is-not-enough rule requiring shown derivative-setting work, and the f/f''/f''''-graph-confusion pattern); AP Calculus AB''s Unit 5 explainers are still grandfathered debt as of this batch, so every mini-example here is checked only against the corpus-wide distinctness query, not against an AB Unit 5 repair that does not yet exist; batch 2026-08-21-ap-calculus-bc-unit5-explainer-repair; author=reviewer same session, no independent human review yet'
from explainer_updates u
where e.subject_key = 'ap_calculus_bc'
  and e.unit_number = 5
  and e.topic_code = u.topic_code;

do $$
declare
  v_repaired integer;
  v_core_matches integer;
begin
  select count(*) into v_repaired from app.topic_explainers
    where subject_key='ap_calculus_bc' and unit_number=5 and status='published'
      and source_note like '%unit5-explainer-repair%';
  if v_repaired <> 12 then
    raise exception 'expected 12 repaired AP Calculus BC Unit 5 explainers, got %', v_repaired;
  end if;

  select count(*) into v_core_matches
  from app.topic_point_briefs b
  join app.topic_explainers e on e.subject_key=b.subject_key and e.topic_code=b.topic_code
  where b.subject_key='ap_calculus_bc' and b.unit_number=5 and b.status='published'
    and e.status='published' and e.core_idea = b.what_it_is;
  if v_core_matches <> 0 then
    raise exception 'expected 0 AP Calculus BC Unit 5 explainers matching their brief verbatim, got %', v_core_matches;
  end if;
end $$;

commit;
