begin;

-- Repair AP Calculus AB Unit 4 (Contextual Applications of Differentiation)
-- Learn More explainers. The 7 point briefs for this unit are already
-- hand-authored and correct (source_note = 'cramapple-authored') and are NOT
-- touched by this migration. All 7 explainers, however, were the
-- template-generated debt flagged in
-- docs/research/TOPIC_GUIDE_PROTOCOL_ASSESSMENT_2026_08_21.md: core_idea
-- byte-identical to the paired brief's what_it_is, and a meta-question
-- mini-example ("A calculus prompt asks you to justify a conclusion
-- involving <title>...") with a weak_answer shared across roughly 150 rows
-- corpus-wide.
--
-- This is a Repair under
-- docs/product/TOPIC_BRIEFS_AND_LEARN_MORE_PRODUCTION_PROTOCOL.md: before-
-- state for all 7 rows is captured at
-- docs/research/topic_guide_source_note_grandfather_2026_08_21/
-- ap_calculus_ab_unit4_explainer_before_state.json. Rollback is restoring
-- those 7 rows' field values from that file.
--
-- Every new explainer is genuinely topic-specific: core_idea differs from
-- the paired brief's what_it_is on every row, and no mini_example_question /
-- weak_answer / point_attaining_answer / practice_bridge value repeats
-- within this batch or anywhere else in the corpus (verified
-- programmatically before this migration, and reverified corpus-wide
-- after applying).

with explainer_updates (
  topic_code, core_idea, what_students_need_to_understand,
  how_this_becomes_points, answer_move, mini_example_question, weak_answer,
  point_attaining_answer, common_point_loss, practice_bridge
) as (
  values
  ('4.1',
   'Interpreting a derivative in context means translating a symbol like f''(a) into a sentence that names the changing quantity, the input it is changing with respect to, the specific input value, and the units -- the number alone earns nothing without that sentence.',
   'Graders read the sentence, not just the number: ''the derivative is 3'' earns no credit on its own, but ''the temperature is increasing at about 3 degrees per minute when t = 4'' does, because it names quantity, rate direction, input value, and units together.',
   'The scoring component checks for the four pieces together -- quantity, rate, input value, units -- so a response can compute f''(4) correctly and still lose the point by reporting just the number.',
   'Fill in the sentence frame completely: [quantity] is [increasing/decreasing] at [value] [units] per [units] when [input] = [value] -- never submit the bare number.',
   'A tank''s water depth is modeled by h(t) in feet, t in minutes. Given h''(6) = -0.4, interpret this value in context.',
   'h''(6) = -0.4.',
   'At t = 6 minutes, the water depth is decreasing at about 0.4 feet per minute -- naming the quantity, the input value, the direction, and the units together, not just the bare number.',
   'Reporting the derivative''s numeric value alone, without naming the quantity, its units, and the specific input it applies to.',
   'Practice by covering the answer and writing the full context sentence from just the symbol and its value before checking whether your sentence names all four required pieces.'),
  ('4.2',
   'Speed is the absolute value of velocity, so a negative velocity means motion in the negative direction, not a smaller speed -- and whether the object is speeding up or slowing down depends on comparing the signs of velocity and acceleration, not either one alone.',
   'The object speeds up when velocity and acceleration share the same sign (both positive or both negative) and slows down when they have opposite signs -- checking only acceleration''s sign, or only velocity''s sign, gives the wrong answer half the time.',
   'A motion question scores separately for computing the correct derivative value and for the sign-comparison reasoning that answers speeding-up-or-slowing-down -- a correct v(t) and a(t) with no sign comparison still loses the interpretation point.',
   'Compute v(t) and a(t) at the given time, then compare their signs: same sign means speeding up, opposite signs mean slowing down; never answer from acceleration''s sign alone.',
   'A particle has velocity v(3) = -5 and acceleration a(3) = -2. Is the particle speeding up or slowing down at t = 3?',
   'Slowing down, because acceleration is negative.',
   'Speeding up, because velocity and acceleration are both negative at t = 3 -- matching signs mean the speed is increasing, even though acceleration alone is negative.',
   'Deciding speeding-up-or-slowing-down from acceleration''s sign alone instead of comparing the signs of velocity and acceleration together.',
   'Before answering any speeding-up-or-slowing-down question, write both signs side by side and compare them -- never answer from a single sign.'),
  ('4.3',
   'Outside of motion, a derivative dy/dx is still a rate -- the skill is naming which quantity is the input and which is the output for that specific scenario, since the same symbol dV/dt means something different for a filling tank than for a shrinking ice cube.',
   'The independent variable is whatever the problem measures change against (usually time), and the dependent variable is whichever quantity is described as changing -- misreading which is which flips the entire rate''s meaning.',
   'Full credit requires correctly identifying both variables from the word problem and then reporting the rate with the problem''s own units, not just a bare number pulled from a derivative computation.',
   'Identify the dependent quantity (what''s changing) and the independent quantity (with respect to what), then state the rate using the problem''s own vocabulary and units, never bare symbols.',
   'A population P(t) of bacteria is measured in thousands, t in hours. Given P''(5) = 12, interpret this value in context.',
   'P''(5) = 12 thousand.',
   'At t = 5 hours, the bacteria population is increasing at about 12 thousand bacteria per hour -- naming the changing quantity, the specific time, the direction, and the units together, not the bare derivative value.',
   'Reporting a derivative''s value with only partial units, or without naming which quantity is changing and with respect to what.',
   'Before answering, identify which quantity is dependent and which is independent directly from the sentence describing the scenario -- do this before writing any derivative notation.'),
  ('4.4',
   'The relationship equation in a related-rates problem is not always a geometric formula like volume or the Pythagorean theorem -- recent released exams instead give an implicit curve equation and ask you to differentiate it with respect to time, exactly like implicit differentiation but with every variable now also a function of t.',
   'Citing the chain-rule identity dy/dt = (dy/dx)(dx/dt) by name is not enough to earn the differentiation point -- the identity has to be carried through to an actual computed numeric value, not just stated as a formula.',
   'The setup point tolerates at most one small error in differentiating the equation with respect to t, but the execution point strictly requires every term differentiated correctly (including any product-rule or chain-rule term) and carried through to a completed computation, not left as a cited formula.',
   'Differentiate the given relationship equation with respect to t, term by term, keeping d/dt on every variable; if a chain-rule identity applies, compute it through to a number rather than just naming it.',
   'Given the curve x^2 + 3xy = 20, with dx/dt = 2 at the point (2, 4), a student writes ''dy/dt = dy/dx times dx/dt'' and stops. Does this earn the differentiation point?',
   'Yes, citing the chain rule relationship is enough to show the method.',
   'No -- the identity has to be carried through to an actual numeric value for dy/dt using the given dx/dt, not merely stated; differentiating the full equation with respect to t and solving for dy/dt numerically is what earns the point.',
   'Naming or citing a chain-rule identity like dy/dt = (dy/dx)(dx/dt) without carrying it through to a completed numeric computation.',
   'Practice differentiating implicit curve equations with respect to t first, before moving to word problems -- this is now the more common exam pattern than geometric setups.'),
  ('4.5',
   'Carrying a related-rates setup through to a solved value means applying the product rule and chain rule correctly to every term of the equation, then substituting the snapshot values only after the derivative equation is fully formed -- substituting early loses the equation you need.',
   'A product like xy inside the original equation produces two separate d/dt terms after differentiating (one from each factor), and a term like ln y produces a chain-rule term (1/y)(dy/dt) -- missing either term is a common way to lose the execution point even with a correct overall setup.',
   'Full credit for the execution point requires every product-rule and chain-rule term present and correctly formed in the differentiated equation, evaluated with the snapshot values only after differentiation is complete -- an equation missing one required term loses the point even if the final numeric answer happens to look reasonable.',
   'Differentiate the full equation with respect to t first, making sure every product gets two terms and every chain-rule composition gets its own factor, then substitute the specific numeric values only after the derivative equation is complete.',
   'Given the curve 2xy + ln(y) = 8, at a moment where x = 1, y = 4, and dx/dt = 3, set up the differentiated equation to solve for dy/dt.',
   '2(dy/dt) + ln(dy/dt) = 0.',
   'Differentiating gives 2x(dy/dt) + 2y(dx/dt) + (1/y)(dy/dt) = 0, with both terms from the product 2xy and the chain-rule term from ln y present; substituting x=1, y=4, dx/dt=3 and solving for dy/dt gives the requested rate.',
   'Dropping one of the two product-rule terms from 2xy, or omitting the chain-rule factor 1/y from differentiating ln y.',
   'Before substituting any snapshot numbers, check that every product term produced two derivative terms and every composed function produced its own chain-rule factor.'),
  ('4.6',
   'The slope value f''(a) and the mechanics of building and evaluating the tangent-line approximation are scored as two separate points -- a wrong slope does not cost you the mechanics point if you carry that wrong slope through consistently to a final numeric approximation.',
   'Even if you compute f''(a) incorrectly, using that wrong value correctly inside L(x) = f(a) + f''(a)(x-a) and evaluating it to a concrete number still earns the mechanics point -- only leaving the expression unresolved, with no final numeric value, loses that point.',
   'Two separate scoring components exist: one for the correct slope value, one for correctly building and evaluating the linearization using whatever slope value you have -- an unresolved expression with a missing closing parenthesis or no boxed final number fails the mechanics point regardless of the slope.',
   'Compute f(a) and f''(a), build L(x) = f(a) + f''(a)(x-a), then substitute the nearby x-value and simplify all the way to one final number -- do this even if you are unsure your slope value is correct.',
   'A student believes f''(2) = 5 (the correct value is 3) but correctly builds L(1.9) = f(2) + 5(1.9-2) and evaluates it to a final number. Does this response earn any credit?',
   'No credit, since the slope value is wrong.',
   'The slope point is not earned, but the linearization-mechanics point is still earned, because the wrong slope was carried through consistently to a fully evaluated final numeric approximation.',
   'Leaving the linearization expression unresolved or missing a final numeric value, rather than an incorrect slope value itself.',
   'Always finish a linearization problem by simplifying to one final number, even when you suspect your slope might be wrong -- an unresolved expression loses points a wrong-but-complete answer would not.'),
  ('4.7',
   'L''Hospital''s Rule only applies to the two indeterminate forms 0/0 and infinity/infinity -- other indeterminate-looking forms like infinity minus infinity or 0 times infinity are outside this course''s scope and require an algebraic rewrite first, not a direct application of the rule.',
   'Writing an equals sign between a limit and 0/0 or infinity/infinity is a notation error, since 0/0 is a label describing the situation, not a value the limit equals -- verify the form in words, then apply the rule to the derivatives, never write lim f(x)/g(x) = 0/0 as if it were a computed answer.',
   'Points require both correctly identifying the indeterminate form as a labeled fact before applying the rule, and differentiating numerator and denominator separately (not with the quotient rule) -- skipping the verification step or misapplying quotient rule both cost points even if a final number is reached.',
   'Confirm the limit is exactly 0/0 or infinity/infinity by substitution first, state that verification in words, then differentiate the numerator and denominator separately (never using the quotient rule) and evaluate the new limit.',
   'Evaluate the limit as x approaches infinity of (e^x) / (x^2), and identify whether L''Hospital''s Rule applies.',
   'lim (e^x)/(x^2) = infinity/infinity, so apply the quotient rule to e^x and x^2.',
   'As x approaches infinity, e^x approaches infinity and x^2 approaches infinity, so this is the infinity/infinity indeterminate form; L''Hospital''s Rule applies, differentiating numerator and denominator separately (not the quotient rule) gives e^x / (2x), which is still infinity/infinity, so applying the rule again gives e^x / 2, which approaches infinity.',
   'Writing the indeterminate form with an equals sign as if it were a computed value, or applying the quotient rule instead of differentiating numerator and denominator separately.',
   'Before applying L''Hospital''s Rule, state in words that the limit is exactly 0/0 or infinity/infinity -- never write that label with an equals sign, and never reach for the quotient rule.')
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
  source_note = 'cramapple-authored; repaired 2026-08-21 replacing a template-generated explainer (previously source_note ''generated-from-brief:legacy; grandfathered-2026-08-21'') with topic-specific content grounded in AP_CALCULUS_AB_BC_CED_FACT_PACK.md Units 4-8 deep-tier detail (2025 Q6 Parts B and D scoring architecture, and the boxed L''Hospital''s Rule exclusion); repair reason: grandfathered explainer restated the paired brief and used a generic meta-question mini-example shared across ~150 corpus rows; batch 2026-08-21-ap-calculus-ab-unit4-explainer-repair; author=reviewer same session, no independent human review yet'
from explainer_updates u
where e.subject_key = 'ap_calculus_ab'
  and e.unit_number = 4
  and e.topic_code = u.topic_code;

do $$
declare
  v_repaired integer;
  v_core_matches integer;
begin
  select count(*) into v_repaired from app.topic_explainers
    where subject_key='ap_calculus_ab' and unit_number=4 and status='published'
      and source_note like 'cramapple-authored; repaired 2026-08-21%';
  if v_repaired <> 7 then
    raise exception 'expected 7 repaired AP Calculus AB Unit 4 explainers, got %', v_repaired;
  end if;

  select count(*) into v_core_matches
  from app.topic_point_briefs b
  join app.topic_explainers e on e.subject_key=b.subject_key and e.topic_code=b.topic_code
  where b.subject_key='ap_calculus_ab' and b.unit_number=4 and b.status='published'
    and e.status='published' and e.core_idea = b.what_it_is;
  if v_core_matches <> 0 then
    raise exception 'expected 0 AP Calculus AB Unit 4 explainers matching their brief verbatim, got %', v_core_matches;
  end if;
end $$;

commit;
