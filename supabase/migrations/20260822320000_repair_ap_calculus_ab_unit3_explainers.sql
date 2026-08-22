begin;

-- Repair AP Calculus AB Unit 3 (Differentiation: Composite, Implicit, and
-- Inverse Functions) Learn More explainers. The 6 point briefs for this
-- unit are already hand-authored and correct (each brief's what_it_is is
-- genuinely topic-specific, not boilerplate) and are NOT touched by this
-- migration. All 6 explainers, however, are the template-generated debt
-- flagged in the 2026-08-21 grandfathering pass: core_idea byte-identical
-- to the paired brief's what_it_is, and a meta-question mini-example ("A
-- calculus prompt asks you to justify a conclusion involving <title>...")
-- with a weak_answer ("I would write the final value or conclusion without
-- showing why it follows.") shared across roughly 150 rows corpus-wide.
--
-- Verified at the content level before authoring (per the lesson from the
-- earlier AP Calculus AB Unit 1 false start, where a batch with the same
-- grandfathered tag turned out to already be genuine hand-authored
-- content): all 6 rows in this batch showed core_idea = paired brief's
-- what_it_is (byte-for-byte), source_note containing
-- 'grandfathered-2026-08-21' and not 'repaired', and the identical
-- boilerplate weak_answer/mini_example_question template. No row was
-- excluded from this batch -- all 6 (3.1-3.6) are confirmed debt.
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
-- the paired brief's what_it_is on every row and adds a real, documented
-- fact from docs/product/AP_CALCULUS_AB_BC_CED_FACT_PACK.md's Unit 3
-- section -- the flagship-FRQ chain-rule-mechanics misconception for 3.1
-- (garbling e^u's chain-rule derivative into a product-rule-shaped
-- u*e^u pattern), the implicit-differentiation collected-coefficient
-- parenthesization error for 3.2 (one of the Chief Reader Report's five
-- documented errors for this topic), and mathematically verified,
-- genuinely topic-specific content for 3.3-3.6 (the corresponding-x-value
-- reciprocal-derivative rule for inverse functions, the inverse-trig
-- denominator-form distinctions, structure-selection across mixed
-- product/chain-rule expressions, and derivative-order tracking for
-- higher-order derivatives) -- Unit 3's fact-pack detail does not name a
-- specific documented misconception for topics 3.3-3.6 beyond what each
-- topic's own point brief already states, so those four rows are grounded
-- directly in the brief's own common_point_loss language plus an
-- independently verified original calculus problem, per the protocol.
-- Every mini_example_question / weak_answer / point_attaining_answer /
-- practice_bridge is an original, independently computed calculus
-- problem, verified against no other published row in the corpus before
-- this migration was applied.

with explainer_updates (
  topic_code, core_idea, what_students_need_to_understand,
  how_this_becomes_points, answer_move, mini_example_question, weak_answer,
  point_attaining_answer, common_point_loss, practice_bridge
) as (
  values
  ('3.1',
   'The chain rule requires two separate factors -- the outer function''s derivative evaluated at the inner expression, times the inner expression''s own derivative -- and a documented, reader-quoted error is garbling this into a product-rule-shaped pattern, e.g. differentiating e^u as u*e^u instead of the correct e^u*u''.',
   'A composite function''s derivative is never just the outer rule applied and left alone -- every layer of nesting (sin of something, e raised to something, a power of something) contributes its own multiplied derivative factor, and skipping or misidentifying the inner function is the single most common chain-rule failure mode.',
   'Credit requires both correctly differentiating the outer function at the inner expression and multiplying by the inner function''s derivative as a separate, visible factor -- a response that differentiates only the outer layer, or that folds the inner expression into the base instead of multiplying by its derivative, does not earn the point.',
   'Identify the inner expression first, differentiate the outer function leaving the inner expression untouched inside it, then multiply the whole thing by the inner expression''s own derivative.',
   'Differentiate f(x) = e^(x^2), showing which factor is the inner function before multiplying by its derivative.',
   'f''(x) = x^2 * e^(x^2), applying a product-rule-shaped pattern instead of the chain rule.',
   'With u = x^2, the outer function is e^u. f''(x) = e^u * u'' = e^(x^2) * 2x = 2x*e^(x^2), the inner derivative 2x carried through as a multiplied factor, not folded into the base.',
   'Differentiating e^u as u*e^u instead of e^u*u'' -- a documented, reader-quoted garbled pattern that looks like the product rule but drops the actual inner-derivative factor.',
   'Return to practice and circle the inner function on every composite before differentiating, every single time.'),
  ('3.2',
   'After implicitly differentiating both sides and collecting every dy/dx term, the coefficient multiplying dy/dx must be wrapped in parentheses before dividing -- a documented, reader-quoted error is dropping those parentheses (writing x + 3y^2*dy/dx = ... instead of (x + 3y^2)*dy/dx = ...), which changes what the expression actually means.',
   'Implicit differentiation applies d/dx to both sides of an equation relating x and y, attaching dy/dx to every term that differentiates a y-expression, then algebraically isolating dy/dx by factoring it out of every term it appears in -- that factoring step is where the parenthesization error happens.',
   'Credit requires differentiating every term correctly with dy/dx attached wherever a y-expression was differentiated, then correctly factoring dy/dx out of the collected terms with the remaining coefficient clearly grouped -- an ambiguous or missing parenthesization around that coefficient is treated as changing the expression, not as a stylistic slip.',
   'Differentiate term by term, attach dy/dx to every derivative of a y-expression, then explicitly parenthesize the full coefficient of dy/dx before dividing it out.',
   'For x^2 + xy + y^3 = 7, find dy/dx using implicit differentiation, writing the coefficient of dy/dx in parentheses before solving.',
   '2x + y + x*dy/dx + 3y^2*dy/dx = 0, so dy/dx = -(2x+y)/x + 3y^2, without parentheses around the collected coefficient.',
   'Differentiating both sides: 2x + (y + x*dy/dx) + 3y^2*dy/dx = 0. Collecting dy/dx terms: (x + 3y^2)*dy/dx = -(2x + y), so dy/dx = -(2x+y)/(x+3y^2), with the coefficient of dy/dx parenthesized before dividing.',
   'Omitting parentheses around the collected coefficient of dy/dx after gathering terms -- a documented, reader-quoted error that changes the meaning of the resulting expression even when every individual derivative was computed correctly.',
   'Go back to practice and rewrite every implicit-differentiation coefficient in parentheses before dividing, until it stops being optional.'),
  ('3.3',
   'An inverse function''s derivative at a point uses the reciprocal of the original function''s derivative, but evaluated at the original x-value that corresponds to the inverse''s input -- not at the inverse''s input value itself, which is the single most common error on this topic.',
   'Finding (f^-1)''(a) means first finding the x-value b such that f(b) = a, then computing 1/f''(b) -- the reciprocal is taken at b, the original input, never at a, the value that was just plugged into the inverse.',
   'Credit requires correctly identifying the original x-value that maps to the given inverse input before taking the reciprocal derivative -- evaluating f'' at the inverse''s input value instead of the corresponding original x-value produces a plausible-looking but wrong number and does not earn the point.',
   'Find the original x-value b with f(b) equal to the inverse''s input, then compute (f^-1)''(a) as 1 divided by f''(b), never 1 divided by f'' of the input itself.',
   'Let f(x) = x^3 + x + 1, and let g = f^{-1}. Given f(1) = 3, find g''(3).',
   'g''(3) = 1/f''(3) = 1/(3(3)^2+1) = 1/28, evaluating f'' at the inverse-input value instead of the corresponding original x-value.',
   'Since f(1) = 3, g(3) = 1. g''(3) = 1/f''(1). f''(x) = 3x^2 + 1, so f''(1) = 4, giving g''(3) = 1/4.',
   'Taking the reciprocal derivative at the inverse function''s input value (here, 3) instead of at the original x-value that actually maps to it (here, 1) -- or confusing f^{-1} itself with 1/f.',
   'Back to practice: before reporting an inverse-function derivative, write down the original x-value it corresponds to, not the inverse input.'),
  ('3.4',
   'Each inverse trig function has its own specific derivative denominator form -- arcsin uses sqrt(1-u^2), arctan uses 1+u^2, arcsec uses |u|*sqrt(u^2-1) -- and swapping one function''s denominator form for another''s is a documented, common error when the functions are not clearly distinguished before differentiating.',
   'Inverse trig derivatives are memorized templates, each paired with a specific algebraic denominator that must not be interchanged, and whenever the inverse trig function''s argument is not simply x, the chain rule contributes an extra multiplied factor on top of the template.',
   'Credit requires selecting the exact denominator form that matches the specific inverse trig function being differentiated, then multiplying by the inner derivative when the argument is not just x -- using the correct-looking but wrong function''s denominator form does not earn the point even if the chain-rule factor is otherwise handled correctly.',
   'Name the specific inverse trig function first, write its exact derivative template, then multiply by the derivative of its argument if that argument is not simply x.',
   'Find the derivative of f(x) = arctan(3x).',
   'f''(x) = 3/sqrt(1-9x^2), using the arcsine denominator form instead of the arctangent form.',
   'Using d/dx arctan(u) = u''/(1+u^2) with u = 3x, u'' = 3: f''(x) = 3/(1+(3x)^2) = 3/(1+9x^2).',
   'Substituting arcsine''s sqrt(1-u^2) denominator (or arcsecant''s |u|*sqrt(u^2-1) form) into an arctangent problem, or the reverse -- the three denominator forms are easy to cross once the specific function is not named first.',
   'Return to practice and drill the three inverse trig derivative denominators side by side until they stop blurring together.'),
  ('3.5',
   'Many derivative problems are not one clean rule but a structure combining rules -- a product of two nonconstant factors where one factor is itself a composite function -- and correctly picking the outer rule (product) while still forgetting to apply the inner rule (chain) to the nested factor is a common, specific hybrid error.',
   'Before differentiating, the expression''s outer structure must be named (sum, product, quotient, composition, or implicit relation), and once a rule like product rule is chosen, each factor still needs its own correct treatment -- a factor that is itself a composite function still needs the chain rule applied within the product-rule computation.',
   'Credit requires both selecting the correct outer rule for the expression''s overall structure and correctly applying any further rule required within that structure, such as a chain-rule factor nested inside one term of a product -- correctly starting a product rule but leaving a nested chain-rule factor out costs that inner factor''s point.',
   'Name the outer structure first, apply that rule''s form, and then check every individual factor or term for its own nested structure before finishing.',
   'Find the derivative of f(x) = x^2 sin(3x), naming which rules apply to which part before differentiating.',
   'f''(x) = 2x sin(3x) + x^2 cos(3x), applying the product rule correctly but forgetting the chain-rule factor of 3 on cos(3x).',
   'f''(x) = 2x*sin(3x) + x^2*3*cos(3x) = 2x*sin(3x) + 3x^2*cos(3x), the product rule applied to the two factors and the chain rule applied to sin(3x)''s inner 3x.',
   'Correctly identifying the outer product-rule structure but then treating the composite factor (here, sin(3x)) as if it needed no chain-rule factor of its own -- picking the right outer rule does not guarantee every nested factor gets its own correct treatment.',
   'Go back to practice and name every rule involved in a mixed expression -- product, quotient, chain -- before writing a single derivative.'),
  ('3.6',
   'A higher-order derivative is found by repeating the derivative operation on the previous result, one order at a time, and a common, specific error is losing track of which order was actually requested -- reporting f'' when f'''' was asked for, especially after substituting a value too early.',
   'Second and higher derivatives are computed by differentiating the immediately preceding derivative, not by differentiating the original function some fixed number of times all at once -- each intermediate result should be labeled by its order (f'', f'''', or the requested notation) before moving to the next step or substituting any value.',
   'Credit requires computing the correct order of derivative and correctly labeling or reporting the specific order the question asked for -- a numerically correct but mislabeled derivative (reporting the first derivative when the second was requested) does not earn the point for the requested quantity.',
   'Differentiate one order at a time, explicitly label each result by its order before continuing, and only substitute a value into the derivative order the question actually asked for.',
   'For f(x) = x^4 - 3x^3 + 2x, find f''''(x), the second derivative, not the first.',
   'f''''(x) = 4x^3 - 9x^2 + 2, reporting the first derivative when the second derivative was requested.',
   'f''(x) = 4x^3 - 9x^2 + 2, then f''''(x) = 12x^2 - 18x, each derivative labeled by order before substituting any value.',
   'Stopping at an intermediate derivative order and reporting it as the final answer, or substituting a numeric value before reaching the specific order the question asked for.',
   'Back to practice: underline which derivative order the question asks for before computing anything.')
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
  source_note = 'cramapple-authored; repaired 2026-08-22 replacing a template-generated explainer (previously source_note ''generated-from-brief:legacy; grandfathered-2026-08-21'') with topic-specific content grounded in AP_CALCULUS_AB_BC_CED_FACT_PACK.md Unit 3 detail (the chain-rule-mechanics e^u garbling misconception for topic 3.1, the implicit-differentiation collected-coefficient parenthesization error for topic 3.2, and independently verified, topic-specific calculus problems for topics 3.3-3.6 grounded in each brief''s own common_point_loss language); repair reason: grandfathered explainer restated the paired brief and used a generic meta-question mini-example shared across ~150 corpus rows; batch 2026-08-22-ap-calculus-ab-unit3-explainer-repair; author=reviewer same session, no independent human review yet'
from explainer_updates u
where e.subject_key = 'ap_calculus_ab'
  and e.unit_number = 3
  and e.topic_code = u.topic_code;

do $$
declare
  v_repaired integer;
  v_core_matches integer;
begin
  select count(*) into v_repaired from app.topic_explainers
    where subject_key='ap_calculus_ab' and unit_number=3 and status='published'
      and source_note like '%unit3-explainer-repair%';
  if v_repaired <> 6 then
    raise exception 'expected 6 repaired AP Calculus AB Unit 3 explainers, got %', v_repaired;
  end if;

  select count(*) into v_core_matches
  from app.topic_point_briefs b
  join app.topic_explainers e on e.subject_key=b.subject_key and e.topic_code=b.topic_code
  where b.subject_key='ap_calculus_ab' and b.unit_number=3 and b.status='published'
    and e.status='published' and e.core_idea = b.what_it_is;
  if v_core_matches <> 0 then
    raise exception 'expected 0 AP Calculus AB Unit 3 explainers matching their brief verbatim, got %', v_core_matches;
  end if;
end $$;

commit;
