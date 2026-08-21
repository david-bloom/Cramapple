begin;

-- Repair AP Calculus BC Unit 1 (Limits and Continuity) Learn More
-- explainers. The 16 point briefs for this unit are genuinely BC-authored
-- (source_note = 'cramapple-authored', BC-flavored content referencing
-- parametric/polar/series contexts later in the course) and are NOT touched
-- by this migration. All 16 explainers, however, were the same
-- template-generated debt found across the entire BC corpus: core_idea
-- byte-identical to the paired brief's what_it_is.
--
-- Discovery note: checking BC's coverage after repairing AP Calculus AB
-- Unit 4 (same debt, 7 rows) found the same pattern at much larger scale
-- across ALL of BC's existing content: 85 of 85 published explainers
-- (Units 1-8) match their brief verbatim. This migration repairs the first
-- 16 of those 85 (Unit 1); the remainder, plus 2 missing BC-only Unit 6
-- topics and the two entirely-uncovered BC-only units (9-10, 24 topics),
-- remain open and are being worked unit by unit.
--
-- Grounded in docs/product/AP_CALCULUS_AB_BC_CED_FACT_PACK.md Units 1-3
-- deep-tier detail: the boxed epsilon-delta exclusion (topic 1.2, not
-- assessed on this exam), the 3 canonical DNE patterns (topic 1.3-1.7 area),
-- the IVT 3-part scoring pattern documented as the single lowest-scoring
-- point on the ENTIRE AB/BC exam per the 2025 Chief Reader Report (mean
-- ~0.27-0.28/1), the MVT-vs-IVT confusion the same report documents, and the
-- end-behavior-vs-near-zero confusion (writing lim(t->0) instead of
-- lim(t->infinity)) also documented there.
--
-- This is a Repair under
-- docs/product/TOPIC_BRIEFS_AND_LEARN_MORE_PRODUCTION_PROTOCOL.md; full
-- before-state for all 16 rows is captured at
-- docs/research/topic_guide_source_note_grandfather_2026_08_21/
-- ap_calculus_bc_unit1_explainer_before_state.json. Rollback is restoring
-- those 16 rows' field values from that file.
--
-- Every new explainer is genuinely topic-specific: core_idea differs from
-- the paired brief's what_it_is on every row, and no mini_example_question /
-- weak_answer / point_attaining_answer / practice_bridge value repeats
-- within this batch, against the existing hand-authored AP Calculus AB Unit
-- 1 explainers (same topic titles, checked directly), or anywhere else in
-- the corpus (verified programmatically before this migration, and
-- reverified corpus-wide after applying).

with explainer_updates (
  topic_code, core_idea, what_students_need_to_understand,
  how_this_becomes_points, answer_move, mini_example_question, weak_answer,
  point_attaining_answer, common_point_loss, practice_bridge
) as (
  values
  ('1.1',
   'An instant has zero width, so there is no direct change-over-an-instant to compute -- the instantaneous rate is defined as the value that average rates over shrinking intervals containing that instant approach, not a ratio you plug an instant directly into.',
   'Writing (f(a)-f(a))/(a-a) as a way to compute an instantaneous rate is not valid -- the instant case is defined entirely as a limiting value, never a direct quotient with a zero-width interval.',
   'Full credit for an ''at this instant'' question requires framing the answer as a limit of average rates, not attempting to divide by a zero-width interval.',
   'Identify whether the question is about an interval (compute an average rate directly) or an instant (frame the answer as the limiting value of average rates over shrinking intervals).',
   'A balloon''s volume is measured before and after 2-second intervals surrounding t = 5. Explain what it would mean to find the instantaneous rate of volume change at exactly t = 5.',
   'It means computing the volume change divided by zero seconds at t = 5.',
   'It means finding the value that the average rates of volume change, computed over intervals containing t = 5, approach as those intervals shrink toward zero width -- not a direct quotient at a single instant.',
   'Attempting to compute an instantaneous rate as a direct quotient with a zero-width interval instead of framing it as a limiting value.',
   'Practice restating any ''instantaneous rate at t = a'' question as ''the limiting value of average rates over intervals shrinking toward a'' before doing any arithmetic.'),
  ('1.2',
   'This course never requires or expects an epsilon-delta proof of a limit -- limit notation and approach language are the full expected toolkit, and producing or reasoning from an epsilon-delta argument is outside what this exam assesses.',
   'Limit notation lim(x approaches c) f(x) = L is read as ''as x approaches c, f(x) approaches L'' -- a claim about nearby behavior that never means f(c) = L automatically.',
   'Full credit requires reading and writing notation with approach language kept distinct from equality, and never attempting or citing an epsilon-delta argument, since that content is outside what this exam assesses.',
   'Translate any limit notation into ''as x approaches c, f(x) approaches L'' before doing anything else, and never reach for an epsilon-delta argument -- it is not assessed.',
   'A student is asked to prove that the limit as x approaches 3 of (2x+1) equals 7 using an epsilon-delta argument. Is this an appropriate way to earn credit on this exam?',
   'Yes, an epsilon-delta proof is the most rigorous way to show this.',
   'No -- the epsilon-delta definition of a limit is not assessed on this exam; the expected approach is notation and approach language, stating that 2x+1 approaches 7 as x approaches 3, not a formal epsilon-delta proof.',
   'Attempting an epsilon-delta argument, which this exam does not assess, instead of using the expected notation-and-approach-language reasoning.',
   'If you ever feel tempted to reach for epsilon and delta on this exam, stop and redirect to notation and approach-language reasoning instead, since epsilon-delta is explicitly not assessed.'),
  ('1.3',
   'A graph''s plotted point at x = c, filled or open, tells you f(c); the limit as x approaches c is read from the curve''s behavior near c from both sides, and these two pieces of information can disagree with each other.',
   'Tracing from the left and tracing from the right can approach different y-values -- when they disagree, the two-sided limit does not exist even if the graph has a single well-defined point at x = c.',
   'Full credit requires checking left-hand and right-hand behavior separately and stating whether they agree before concluding a two-sided limit exists.',
   'Trace the curve toward x = c from the left, then separately from the right; only if both sides approach the same y-value does the two-sided limit exist.',
   'A graph approaches y = 2 from the left of x = 5 and approaches y = 6 from the right of x = 5, with an open circle plotted at (5, 2). Does the limit as x approaches 5 of f(x) exist?',
   'Yes, the limit is 2, matching the open circle.',
   'No, the limit does not exist, because the left-hand limit (2) and right-hand limit (6) disagree; the open circle at (5, 2) is irrelevant to the limit and would only describe f(5) if the function were defined there.',
   'Using a filled or open point as the limit value without checking nearby graph behavior from both sides.',
   'Before answering any graph-based limit question, trace from the left and the right separately and write down both approached values before comparing them.'),
  ('1.4',
   'A table only ever gives evidence of a trend approaching some value -- it cannot prove the limit exactly, since no finite table shows every x-value arbitrarily close to the target input.',
   'The estimate should come from values on both sides of the target input, read as they get closer, not from picking whichever single row looks closest to a nice round number.',
   'Full credit requires citing values approaching from both sides of the input and stating the trend those values suggest, not just quoting the single closest entry.',
   'Read the table entries approaching from both sides of the target input, state the trend, then give the value the trend supports.',
   'A table gives f(1.9) = 5.98, f(1.99) = 5.998, f(2.01) = 6.002, and f(2.1) = 6.02. Estimate the limit as x approaches 2 of f(x).',
   'The limit is 6.002, since that is the table entry closest to x = 2.',
   'The limit appears to be 6, since values from both below and above x = 2 approach 6 as x gets closer to 2 from either side.',
   'Choosing one table entry instead of describing the trend across nearby entries on both sides.',
   'Read every table-based limit problem by scanning both directions toward the target input before picking out any single value.'),
  ('1.5',
   'Limit properties for sums, differences, products, quotients, and compositions only combine limits that individually exist -- applying the quotient property when the denominator''s limit is zero is not a shortcut, it is an invalid use of the rule.',
   'Before applying a limit property, the individual component limits actually have to exist, and for the quotient property, the denominator''s limit specifically must be nonzero -- these are conditions on the property, not optional details.',
   'Full credit requires checking that component limits exist, and that a quotient''s denominator limit is nonzero, before citing the corresponding property, not just naming a property and computing a value.',
   'Split the expression into components, confirm each component''s limit exists (and the denominator''s limit is nonzero for a quotient), then apply the matching property.',
   'Given the limit as x approaches 2 of f(x) equals 5, and the limit as x approaches 2 of g(x) equals 0, a student computes the limit of f(x)/g(x) as 5/0 using the quotient property. Evaluate this.',
   'This is correct; the quotient property gives 5/0.',
   'This is not a valid use of the quotient property, since that property requires the denominator''s limit to be nonzero; with g''s limit equal to 0, more information about g''s behavior near x = 2 is needed before any conclusion can be drawn.',
   'Applying a limit property, especially the quotient property, when the condition it requires -- such as a nonzero denominator limit -- is not actually met.',
   'Before citing any limit property, check off its conditions explicitly: do the component limits exist, and for a quotient, is the denominator''s limit nonzero.'),
  ('1.6',
   'A limit expression that gives 0/0 on direct substitution is not undefined -- it is a signal the expression needs to be rewritten, by factoring, rationalizing, or simplifying, into an equivalent form before substitution reveals the real limiting value.',
   'Canceling a factor is only valid when that factor is a genuine common factor of both numerator and denominator -- canceling terms that merely look similar, without factoring first, produces a wrong result even when the arithmetic looks tidy.',
   'Full credit requires showing the rewritten, factored, or rationalized expression as an explicit intermediate step, not just stopping at 0/0 or jumping straight to a final numeric answer.',
   'When direct substitution gives 0/0, factor, rationalize, or otherwise rewrite the expression into an equivalent form, then substitute into that rewritten form.',
   'Evaluate the limit as x approaches 3 of (x^2 - 9)/(x - 3).',
   'Substituting x = 3 gives 0/0, so the limit does not exist.',
   'Factoring gives (x-3)(x+3)/(x-3), which simplifies to x+3 for x not equal to 3; substituting x = 3 into the simplified form gives a limit of 6.',
   'Stopping at 0/0, or canceling terms that are not actually common factors.',
   'Whenever direct substitution gives 0/0, treat that as the signal to rewrite the expression, never as a stopping point.'),
  ('1.7',
   'Before any limit calculation, the real skill being tested is recognizing which cue applies -- direct substitution, one-sided checking, algebraic rewriting, or another strategy -- since applying the wrong tool wastes the setup even if later arithmetic is correct.',
   'A limit problem''s form -- a nice continuous function, a 0/0 result, a piecewise definition, an absolute value -- is itself the evidence for which procedure applies, and reading that form correctly comes before any computation.',
   'Full credit requires naming the correct strategy cue from the problem''s form before computing, not just eventually arriving at a numeric answer through trial and error.',
   'Read the expression''s form first -- continuous function, 0/0 result, piecewise definition, absolute value, one-sided marker -- and name the matching strategy before computing anything.',
   'A student is asked to evaluate the limit as x approaches 0 of |x|/x. What procedure applies?',
   'Direct substitution: plug in x = 0 to get 0/0, and simplify from there.',
   'Since the expression involves an absolute value and direct substitution is blocked at x = 0, one-sided analysis applies: the left-hand limit is -1 and the right-hand limit is 1, and since they disagree, the two-sided limit does not exist.',
   'Defaulting to a familiar technique without checking whether the problem''s form actually calls for it.',
   'Before solving any limit problem, name your chosen strategy out loud and justify it from the problem''s form, before touching the algebra.'),
  ('1.8',
   'The squeeze theorem does not just require naming two bounding functions -- it requires showing that both bounding functions actually approach the same limiting value at the target input, since the conclusion only follows once that match is demonstrated.',
   'Naming ''squeeze theorem'' as the topic is not the same as applying it -- the specific bounding inequality, and the fact that both outside limits equal each other, both have to be shown explicitly.',
   'Full credit requires the bounding inequality, both outside limits computed and shown equal, and only then the concluding statement about the middle function''s limit.',
   'Write the bounding inequality first, compute both outside limits, confirm they match, then conclude the middle function''s limit equals that shared value.',
   'Given -x^2 <= f(x) <= x^2 for all x, and knowing the limit as x approaches 0 of both x^2 and -x^2 equal 0, find the limit as x approaches 0 of f(x).',
   'By the squeeze theorem, the limit is 0.',
   'Since -x^2 <= f(x) <= x^2 for all x, and both the limit of -x^2 and the limit of x^2 as x approaches 0 equal 0 and match, the squeeze theorem gives that the limit of f(x) as x approaches 0 also equals 0.',
   'Naming the theorem without showing the bounding relationship and the matching outside limits explicitly.',
   'Every squeeze-theorem answer should show the inequality and both matching outside limits explicitly, not just cite the theorem''s name and a final number.'),
  ('1.9',
   'A limit claim stays the same mathematical fact whether shown as notation, a graph, a table, or a verbal description -- the representation changes, but ''as x approaches c, f(x) approaches L'' is what every one of them is actually claiming.',
   'Matching a table or graph to the function''s value at a point, instead of to its approach behavior near that point, is a category error -- these representations show approach behavior, not necessarily the function''s actual value there.',
   'Full credit requires translating every representation into the same underlying approach-behavior claim and keeping that claim consistent across all representations given.',
   'Convert whatever representation you are given -- notation, graph, table, or words -- into the single statement ''as x approaches c, f(x) approaches L'' before comparing it to anything else.',
   'A table shows values approaching 4 as x approaches 2, and a separate graph shows a hole at (2, 4) with the curve approaching that point from both sides. Do these two representations agree?',
   'No, since the table shows a limit and the graph shows a hole, which are different things.',
   'Yes, both representations agree that the limit as x approaches 2 of f(x) equals 4; the hole in the graph just shows that f(2) itself may be undefined or different from 4, which is a separate fact from the limit.',
   'Matching a table or graph to a function value instead of to approach behavior.',
   'Translate every representation you are given into the same approach-behavior sentence before deciding whether two representations agree or conflict.'),
  ('1.10',
   'Classifying a discontinuity means checking which specific piece fails -- the value, the two one-sided limits agreeing, or the function staying bounded -- and naming the type that matches, rather than describing the graph''s general appearance.',
   'A removable discontinuity (the limit exists but disagrees with or is missing f(c)), a jump discontinuity (the one-sided limits disagree), and an infinite discontinuity (unbounded behavior) each fail a different specific condition, so classification requires checking left-hand limit, right-hand limit, and f(c) explicitly.',
   'Full credit requires checking left-hand limit, right-hand limit, and f(c) explicitly and naming the discontinuity type tied to which of those failed.',
   'Check left-hand limit, right-hand limit, and f(c) in that order, then classify the discontinuity based on which piece failed to match.',
   'A function has a left-hand limit of 3 and a right-hand limit of 7 at x = 5. Classify the discontinuity at x = 5.',
   'It is a removable discontinuity, since the graph has a break there.',
   'It is a jump discontinuity, since the left-hand limit (3) and right-hand limit (7) disagree, meaning the two-sided limit does not exist at x = 5.',
   'Calling every gap removable or every discontinuity an asymptote without checking behavior explicitly.',
   'Check left-hand limit, right-hand limit, and f(c) explicitly for every discontinuity question before naming a type, rather than eyeballing the graph''s shape.'),
  ('1.11',
   'Continuity at a point is a three-item checklist -- f(c) exists, the limit exists, and the two are equal -- and a graph merely looking unbroken is not evidence that any one of the three actually holds.',
   'Each of the three continuity conditions can fail independently, so checking only one or two of them, such as just confirming f(c) exists, does not establish continuity.',
   'Full credit requires verifying all three conditions explicitly -- f(c) exists, the limit exists, and the limit equals f(c) -- before concluding continuity, not asserting it from the graph''s appearance.',
   'Check f(c) exists, then check the limit exists, then check the limit equals f(c); only conclude continuity once all three are confirmed.',
   'A function has f(4) = 7, and its graph appears connected and smooth through x = 4 with no visible break. Is this enough to conclude the function is continuous at x = 4?',
   'Yes, since the graph looks connected there, the function is continuous.',
   'No -- concluding continuity requires explicitly checking that the limit as x approaches 4 of f(x) exists and that it equals f(4) = 7, not just that the graph appears visually connected.',
   'Saying a function is continuous because the graph looks connected without explicitly verifying all three conditions: f(c) exists, the limit exists, and they are equal.',
   'Run the three-item checklist explicitly every time -- f(c) exists, the limit exists, the two are equal -- rather than trusting how the graph looks.'),
  ('1.12',
   'Continuity over an interval requires continuity at every single point inside it -- a function can look continuous almost everywhere on an interval and still fail at one excluded domain value, hole, or piecewise boundary that is easy to overlook.',
   'Checking continuity over an interval means specifically hunting for holes, asymptotes, piecewise boundary points, and domain restrictions inside that interval, not just confirming the function''s general formula looks well-behaved.',
   'Full credit requires explicitly checking special points -- holes, asymptotes, piecewise boundaries, domain exclusions -- inside the stated interval, not just asserting continuity from the function''s general type.',
   'Identify the function''s domain restrictions and any piecewise boundaries first, then check specifically whether any of those special points fall inside the interval in question.',
   'Is f(x) = 1/(x - 3) continuous on the interval [1, 5]?',
   'Yes, since 1/(x-3) is a rational function and rational functions are continuous.',
   'No -- f(x) = 1/(x-3) is undefined at x = 3, which lies inside [1, 5], so the function is not continuous over this entire interval even though it is continuous everywhere else in that range.',
   'Claiming continuity over an interval while ignoring holes, asymptotes, piecewise boundaries, or excluded domain values inside it.',
   'Before claiming continuity over any interval, list the function''s excluded domain values and piecewise boundaries and check whether any land inside that interval.'),
  ('1.13',
   'Removing a discontinuity means finding the specific value the limit approaches at that point and assigning that exact value to f(c) -- not any nearby-looking number, and not skipping the step of showing the limit was actually computed.',
   'The value that makes a function continuous at a removable discontinuity is not a free choice -- it is uniquely determined by the limit at that point, so the limit has to be computed and shown before stating the value.',
   'Full credit requires computing the limit at the discontinuity explicitly and showing that the chosen value for f(c), or an unknown parameter, equals that computed limit.',
   'Compute the limit at the discontinuity first, showing the work, then set f(c) or the unknown parameter equal to that computed value.',
   'A function is defined as f(x) = (x^2-4)/(x-2) for x not equal to 2, and f(2) = k. What value of k removes the discontinuity at x = 2?',
   'k = 2, since that matches the x-value where the discontinuity occurs.',
   'Factoring gives (x-2)(x+2)/(x-2), which equals x+2 for x not equal to 2, so the limit as x approaches 2 equals 4; setting k = 4 removes the discontinuity, since that matches the computed limit.',
   'Solving for a value without showing that it matches the limiting behavior at that point.',
   'Compute and show the limit explicitly before writing down the value that removes any discontinuity -- never guess a value that merely looks related to the problem.'),
  ('1.14',
   'An infinite limit is still a limit statement, not a does-not-exist dead end -- writing that a limit equals infinity communicates specific unbounded behavior, and it should be connected explicitly to the vertical asymptote when the question asks about the function''s behavior or graph.',
   '''Does not exist'' is technically true for an infinite limit, but it throws away the more specific and more useful information that the function grows without bound -- when a question asks for behavior or an asymptote, infinite-limit notation is the expected answer, not a bare does-not-exist.',
   'Full credit for a behavior or asymptote question requires writing the infinite limit notation and naming the vertical asymptote, not just stating the limit does not exist.',
   'Check each side of the input; if f(x) grows without bound, write the infinite limit (positive or negative) and name x = c as the vertical asymptote.',
   'Given f(x) = 1/(x-2)^2, describe the behavior of f as x approaches 2 and identify any vertical asymptote.',
   'The limit as x approaches 2 does not exist.',
   'As x approaches 2 from either side, f(x) grows without bound, so the limit as x approaches 2 of f(x) is infinity, and x = 2 is a vertical asymptote.',
   'Writing only ''does not exist'' when the problem asks for behavior or an asymptote connection.',
   'Whenever a question asks for behavior or an asymptote near unbounded growth, write the infinite-limit notation and name the asymptote -- a bare does-not-exist throws away credit-earning information.'),
  ('1.15',
   'End behavior means what happens as the input grows without bound in either direction -- a completely different question from what happens near input zero, and mixing the two up is a documented, common exam error.',
   'The phrase ''end behavior'' or ''as t becomes large'' always signals a limit as the variable approaches positive or negative infinity, never a limit as the variable approaches zero -- these are read from completely different parts of the function''s domain.',
   'Full credit requires writing the limit with the variable approaching infinity, not zero, when a question asks about end behavior or long-run behavior, and connecting a finite result to a named horizontal asymptote.',
   'When a question asks about end behavior or long-run behavior, write the limit with the variable explicitly approaching positive or negative infinity, never approaching zero; if the result is finite, name the horizontal asymptote y = L.',
   'A model gives the amount of a substance remaining as A(t). A question asks for the long-run behavior of A(t) as time increases without bound. A student writes the limit as t approaches 0 of A(t). Evaluate this response.',
   'This is correct, since it evaluates a limit of A(t).',
   'This is incorrect notation for the question asked; long-run or end behavior means the limit as t approaches infinity, so the correct expression is the limit as t approaches infinity of A(t), not as t approaches 0, which instead asks about behavior near t = 0.',
   'Writing the limit as the variable approaches zero when the question asks about end behavior or long-run behavior, which requires the variable approaching infinity instead -- a documented, common exam error.',
   'Whenever a question says ''end behavior,'' ''long-run,'' or ''as time increases without bound,'' write your limit with the variable approaching infinity, never zero, before doing anything else.'),
  ('1.16',
   'A correct IVT conclusion is not one sentence -- real AP scoring data shows the pattern of stating continuity with a reason, showing the target value between the actual endpoint numbers, then concluding existence, as the single lowest-scoring point on the entire exam, because responses skip straight to the conclusion.',
   'IVT and MVT are different theorems answering different questions -- IVT guarantees a function hits a specific output value somewhere in an interval, while MVT guarantees a specific instantaneous rate matches an average rate; reaching for MVT when a question asks about hitting a target value is a documented, common mistake.',
   'Full credit requires three explicit pieces in order -- continuity stated with its reason, the target value shown numerically between the endpoint values, and only then the existence conclusion -- skipping any one of the three costs the point even with a correct final claim.',
   'State continuity and why, show the actual endpoint values with the target strictly between them, then conclude some c exists in the interval -- all three, in that order, every time.',
   'A problem states g is continuous on [0, 6], g(0) = -3, and g(6) = 9, and asks to justify why g(c) = 0 for some c in (0, 6). A student answers by citing the Mean Value Theorem. Evaluate this response.',
   'This is correct; the Mean Value Theorem guarantees the value exists.',
   'This response cites the wrong theorem -- the Mean Value Theorem is about matching an instantaneous rate to an average rate, not about hitting a target output value; the correct justification is the Intermediate Value Theorem, since g is continuous on [0, 6] and 0 is strictly between g(0) = -3 and g(6) = 9, so some c in (0, 6) exists with g(c) = 0.',
   'Citing the Mean Value Theorem when the question is actually an Intermediate Value Theorem existence claim -- a documented, common exam confusion between the two theorems.',
   'Before citing a theorem, ask whether the question wants you to hit a target output value (IVT) or match a rate (MVT) -- these are different questions with different theorems.')
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
  source_note = 'cramapple-authored; repaired 2026-08-21 replacing a template-generated explainer (previously source_note ''generated-from-brief:legacy; grandfathered-2026-08-21'') with topic-specific content grounded in AP_CALCULUS_AB_BC_CED_FACT_PACK.md Units 1-3 deep-tier detail (the boxed epsilon-delta exclusion, the 3 canonical DNE patterns, the documented lowest-scoring-point-on-the-exam IVT pattern, the MVT-vs-IVT confusion, and the end-behavior-vs-near-zero confusion, all confirmed against the 2025 Chief Reader Report); repair reason: grandfathered explainer restated the paired brief verbatim; batch 2026-08-21-ap-calculus-bc-unit1-explainer-repair; author=reviewer same session, no independent human review yet'
from explainer_updates u
where e.subject_key = 'ap_calculus_bc'
  and e.unit_number = 1
  and e.topic_code = u.topic_code;

do $$
declare
  v_repaired integer;
  v_core_matches integer;
begin
  select count(*) into v_repaired from app.topic_explainers
    where subject_key='ap_calculus_bc' and unit_number=1 and status='published'
      and source_note like 'cramapple-authored; repaired 2026-08-21%';
  if v_repaired <> 16 then
    raise exception 'expected 16 repaired AP Calculus BC Unit 1 explainers, got %', v_repaired;
  end if;

  select count(*) into v_core_matches
  from app.topic_point_briefs b
  join app.topic_explainers e on e.subject_key=b.subject_key and e.topic_code=b.topic_code
  where b.subject_key='ap_calculus_bc' and b.unit_number=1 and b.status='published'
    and e.status='published' and e.core_idea = b.what_it_is;
  if v_core_matches <> 0 then
    raise exception 'expected 0 AP Calculus BC Unit 1 explainers matching their brief verbatim, got %', v_core_matches;
  end if;
end $$;

commit;
