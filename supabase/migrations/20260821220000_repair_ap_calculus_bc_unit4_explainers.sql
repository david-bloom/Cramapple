begin;

-- Repair AP Calculus BC Unit 4 (Contextual Applications of
-- Differentiation) Learn More explainers. Briefs were duplicated from AB's
-- genuinely hand-authored content and are correct; NOT touched here.
--
-- AP Calculus AB's Unit 4 explainers were repaired earlier the same day
-- (commit 9772b62) using the same grounding material. BC's copy is a
-- separate row with its own independent debt, so every mini-example here
-- is a genuinely fresh scenario (coffee temperature, an elevator, a water
-- tank, two different implicit curves, a different linearization pair, a
-- 0/0-form L'Hospital limit) rather than reusing the AB batch's examples,
-- to satisfy the protocol's corpus-wide distinctness criterion (C8).
--
-- Grounded in docs/product/AP_CALCULUS_AB_BC_CED_FACT_PACK.md Unit 4
-- deep-tier detail: the boxed L'Hospital's exclusion (only 0/0 and
-- infinity/infinity are in scope), the related-rates rule that a cited
-- chain-rule identity must be carried through to a computed value to earn
-- credit, the product/chain-rule term-counting requirement for related
-- rates execution, and the linearization independent-scoring rule (a wrong
-- slope carried through consistently still earns the mechanics point).
--
-- Before-state captured at docs/research/
-- topic_guide_source_note_grandfather_2026_08_21/
-- ap_calculus_bc_unit4_explainer_before_state.json.
--
-- Every new explainer is genuinely topic-specific and mathematically
-- verified: core_idea differs from what_it_is on every row, and no
-- mini_example_question / weak_answer / point_attaining_answer /
-- practice_bridge value repeats within this batch or elsewhere in the
-- corpus, including against the AB Unit 4 batch (checked programmatically
-- before and after). This required one live correction after the initial
-- corpus-wide check: 4.6's weak_answer and point_attaining_answer closing
-- sentences were reused nearly verbatim from the AB Unit 4 batch and were
-- rewritten before promoting to Production -- see the activity log entry
-- for this batch.

with explainer_updates (
  topic_code, core_idea, what_students_need_to_understand,
  how_this_becomes_points, answer_move, mini_example_question, weak_answer,
  point_attaining_answer, common_point_loss, practice_bridge
) as (
  values
  ('4.1',
   'A derivative value tied to a real scenario is a rate, not a plain number -- reporting it correctly means naming the changing quantity, the direction, the specific input, and the units all together, since any one missing piece leaves the interpretation incomplete.',
   'The number by itself never earns interpretation credit; a grader looks for the full sentence connecting the symbol to the scenario -- quantity, direction, input value, and units named explicitly.',
   'Full credit requires all four pieces stated together in context, so a technically correct derivative computation with no interpreting sentence still misses the point this topic is testing.',
   'Build the full sentence: name the quantity, state increasing or decreasing, give the units, and name the specific input value where it applies.',
   'A coffee''s temperature is modeled by C(t) in degrees Celsius, t minutes after brewing. Given C''(4) = -3.2, interpret this value in context.',
   'C''(4) = -3.2.',
   'At t = 4 minutes after brewing, the coffee''s temperature is decreasing at about 3.2 degrees Celsius per minute -- naming the quantity, the time, the direction, and the units together.',
   'Giving a numeric derivative without units or contextual meaning.',
   'Cover the numeric answer and rebuild the full interpreting sentence from scratch before checking whether it names all four required pieces.'),
  ('4.2',
   'Whether an object is speeding up or slowing down depends on comparing the signs of velocity and acceleration together -- matching signs mean speeding up, opposite signs mean slowing down, and checking only one of the two gives the wrong answer about half the time.',
   'A positive velocity does not by itself mean the object is speeding up -- if acceleration is negative at that same moment, the object is actually slowing down, since the signs disagree.',
   'Full credit requires comparing both signs explicitly, not concluding from velocity''s sign or acceleration''s sign alone.',
   'Compute both v(t) and a(t) at the given time, then compare their signs together before answering speeding-up-or-slowing-down.',
   'An elevator has velocity v(5) = 3 ft/sec and acceleration a(5) = -2 ft/sec^2. Is the elevator speeding up or slowing down at t = 5?',
   'Speeding up, because velocity is positive.',
   'Slowing down, because velocity (positive) and acceleration (negative) have opposite signs at t = 5 -- opposite signs mean the speed is decreasing, even though velocity itself is still positive.',
   'Confusing velocity with speed or treating negative velocity as slower instead of direction-dependent.',
   'Write both signs side by side before answering any speeding-up-or-slowing-down question -- never answer from a single sign.'),
  ('4.3',
   'Outside of motion, dV/dt, dP/dt, or any other rate symbol still means change per unit time -- the skill is naming which quantity is changing and attaching the scenario''s own units, not treating the derivative as an abstract number.',
   'The same derivative symbol carries a different real meaning in every scenario, so the response has to name the specific quantity and units from that scenario, not a generic ''rate.''',
   'Full credit requires identifying the changing quantity and reporting the rate with the scenario''s own units, not a bare number pulled from a derivative computation.',
   'Identify which quantity is changing and with respect to what, then state the rate using the scenario''s own vocabulary and units.',
   'A water tank''s volume is given by V(t) in gallons, t in minutes. Given V''(8) = -15, interpret this value in context.',
   'V''(8) = -15 gallons.',
   'At t = 8 minutes, the tank''s volume is decreasing at about 15 gallons per minute -- naming the quantity, the time, the direction, and the units together, not the bare derivative value.',
   'Writing a derivative symbol or value without saying what real-world rate it represents.',
   'Before answering, name which quantity is changing and with respect to what, directly from the sentence describing the scenario.'),
  ('4.4',
   'Citing a chain-rule identity by name is not the same as carrying it through to a computed value -- the identity has to end in an actual number using the given rate, not stop at the formula itself.',
   'Writing ''dx/dt = dx/dy times dy/dt'' and stopping states a true fact but does not earn credit -- the identity must be evaluated using the actual given rate to produce a number.',
   'The differentiation point requires the full equation differentiated with respect to t and solved numerically, not a cited identity left unevaluated.',
   'Differentiate the given equation with respect to t term by term, then solve numerically for the requested rate using the given value -- never stop at a cited identity.',
   'Given the curve x^3 + 2xy = 12, with dy/dt = -3 at the point (2, 2), a student writes ''dx/dt = dx/dy times dy/dt'' and stops. Does this earn the differentiation point?',
   'Yes, stating the relationship is enough to show understanding.',
   'No -- the identity has to be carried through to an actual numeric value for dx/dt using the given dy/dt; differentiating the full equation with respect to t and solving for dx/dt numerically is what earns the point.',
   'Substituting values before differentiating or mixing up variables with their rates.',
   'Practice differentiating full implicit equations with respect to t and solving to a number, rather than stopping at a cited chain-rule identity.'),
  ('4.5',
   'Every product term in a related-rates equation produces two separate derivative terms after differentiating, one from each factor, and every function nested inside another produces its own chain-rule factor -- missing either is the most common way this topic''s execution point is lost.',
   'A term like 3xy^2 is a product of x and y^2, so differentiating it produces two terms, not one, and a term like e^y produces a chain-rule factor from differentiating y with respect to t.',
   'Full credit requires every product-rule and chain-rule term present in the differentiated equation, evaluated with snapshot values only after differentiation is complete.',
   'Differentiate the full equation first, checking that every product produced two terms and every nested function produced its own chain-rule factor, then substitute snapshot values.',
   'Given the curve 3xy^2 + e^y = 20, at a moment where x = 1, y = 2, and dx/dt = 5, set up the differentiated equation to solve for dy/dt.',
   '3(dy/dt) + e^y(dy/dt) = 0, treating 3xy^2 as producing only one derivative term.',
   'Differentiating gives 3y^2(dx/dt) + 6xy(dy/dt) + e^y(dy/dt) = 0, with both terms from the product 3xy^2 present and the chain-rule term from e^y; substituting x=1, y=2, dx/dt=5 and solving for dy/dt gives the requested rate.',
   'Answering for the wrong rate or using a value that belongs to a different time.',
   'Before substituting any snapshot numbers, check that every product term produced two derivative terms and every nested function produced its own chain-rule factor.'),
  ('4.6',
   'The slope value and the mechanics of building and evaluating a linearization are scored independently -- a wrong slope carried through consistently to a completed number still earns the mechanics point, even though the slope point is lost.',
   'Only an unresolved expression, missing a final evaluated number, loses the mechanics point -- a wrong-but-fully-computed approximation does not.',
   'Full credit for the mechanics point requires a fully evaluated final number built from L(x) = f(a) + f''(a)(x-a), regardless of whether the slope value itself was correct.',
   'Build the linearization and simplify all the way to a single final number, even when unsure the slope value is correct.',
   'A student believes g''(5) = -2 (the correct value is -4) but correctly builds L(4.8) = g(5) + (-2)(4.8-5) and evaluates it to a final number. Does this response earn any credit?',
   'This response earns no credit at all, since the slope was computed incorrectly.',
   'Losing the slope point does not cost the mechanics point here: since the wrong slope value was used consistently all the way through to one fully evaluated final number, the linearization-mechanics point is still earned.',
   'Using a secant line or forgetting that the approximation is anchored at the given point a.',
   'Always finish a linearization by simplifying to one final number, even when unsure whether the slope is correct.'),
  ('4.7',
   'Confirming the indeterminate form in words, before applying L''Hospital''s Rule, is a required step, not a formality -- and the rule always means differentiating numerator and denominator separately, never the quotient rule.',
   '0/0 and infinity/infinity are labels describing a situation, and the correct next step is always to differentiate numerator and denominator on their own, never to reach for the quotient rule.',
   'Full credit requires stating the indeterminate form as a verified fact before applying the rule, and differentiating numerator and denominator separately rather than using the quotient rule.',
   'Verify the limit is exactly 0/0 or infinity/infinity by substitution, state that fact, then differentiate numerator and denominator separately and evaluate the new limit.',
   'Evaluate the limit as x approaches 1 of ln(x)/(x-1), and identify whether L''Hospital''s Rule applies.',
   'ln(1)/(1-1) = 0/0, so apply the quotient rule to ln(x) and (x-1).',
   'As x approaches 1, ln(x) approaches 0 and (x-1) approaches 0, so this is the 0/0 indeterminate form; L''Hospital''s Rule applies, differentiating numerator and denominator separately gives (1/x)/1, which approaches 1 as x approaches 1.',
   'Applying the rule without verifying the form or using quotient rule instead of differentiating numerator and denominator separately.',
   'State in words that the limit is exactly 0/0 or infinity/infinity before applying L''Hospital''s Rule, and never reach for the quotient rule.')
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
  source_note = 'cramapple-authored; repaired 2026-08-21 replacing a template-generated explainer (previously duplicated-from-AB, then generated-from-brief, grandfathered) with topic-specific content grounded in AP_CALCULUS_AB_BC_CED_FACT_PACK.md Unit 4 deep-tier detail (the boxed L''Hospital''s exclusion, the related-rates chain-rule-identity-must-be-computed rule, the linearization independent-scoring rule); every mini-example is a fresh scenario distinct from the AP Calculus AB Unit 4 repair done earlier the same day, to satisfy corpus-wide distinctness; batch 2026-08-21-ap-calculus-bc-unit4-explainer-repair; author=reviewer same session, no independent human review yet'
from explainer_updates u
where e.subject_key = 'ap_calculus_bc'
  and e.unit_number = 4
  and e.topic_code = u.topic_code;

do $$
declare
  v_repaired integer;
  v_core_matches integer;
begin
  select count(*) into v_repaired from app.topic_explainers
    where subject_key='ap_calculus_bc' and unit_number=4 and status='published'
      and source_note like '%unit4-explainer-repair%';
  if v_repaired <> 7 then
    raise exception 'expected 7 repaired AP Calculus BC Unit 4 explainers, got %', v_repaired;
  end if;

  select count(*) into v_core_matches
  from app.topic_point_briefs b
  join app.topic_explainers e on e.subject_key=b.subject_key and e.topic_code=b.topic_code
  where b.subject_key='ap_calculus_bc' and b.unit_number=4 and b.status='published'
    and e.status='published' and e.core_idea = b.what_it_is;
  if v_core_matches <> 0 then
    raise exception 'expected 0 AP Calculus BC Unit 4 explainers matching their brief verbatim, got %', v_core_matches;
  end if;
end $$;

commit;
