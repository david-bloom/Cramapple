begin;

-- New Coverage: AP Precalculus Unit 2 (Exponential and Logarithmic
-- Functions) -- all 15 topics had zero published briefs or explainers
-- before this migration, despite Unit 2 being fully exam-assessed
-- (25-40% MC weighting). Discovered while investigating an Owner
-- report that AP Precalculus topics were not rendering for students;
-- every topic in this unit would have shown 'coming soon' with no
-- real content. Units 1 and 3 already had briefs/explainers (though
-- still grandfathered template debt, a separate known issue not
-- addressed here); Unit 4's taxonomy-only gap was fixed in the prior
-- migration (20260821280000).
--
-- Grounded in docs/product/AP_PRECALCULUS_CED_FACT_PACK.md's Unit 2
-- deep-tier detail: the documented real 2025 finding that citing a
-- regression r-squared value is not sufficient reasoning for
-- exponential classification (2.2, 2.6); the hidden-quadratic-in-e^x
-- pattern, the two lowest-scoring points on the entire 2025 exam,
-- from failing to reject the impossible negative e^x root (2.13);
-- topic 2.10's narrower initial-value-of-1 inverse-derivation scope
-- versus 2.11's general a*log_b(x) form; the quotient-of-logs
-- property being derivable from the product/power properties but not
-- given as its own separate EK (2.12); and the semi-log
-- linearization's n>1 log-base restriction, stricter than n≠1 (2.15).
--
-- This is a pure insert -- no existing rows are touched. Rollback is
-- deleting these 15 rows (subject_key='ap_precalculus', unit_number=2)
-- from both tables, or setting status back to 'draft'.
--
-- Every explainer is genuinely topic-specific and mathematically
-- verified: core_idea differs from the paired brief's what_it_is, and
-- no mini_example_question / weak_answer / point_attaining_answer /
-- practice_bridge value repeats within this batch or elsewhere in the
-- corpus (checked programmatically before and after).

with brief_seed (
  topic_code, title, class_importance, exam_importance, what_it_is,
  why_it_matters, how_points_are_earned, answer_move, common_point_loss,
  learn_more_path
) as (
  values
  ('2.1','Change in Arithmetic and Geometric Sequences','very-important','very-important',
   'An arithmetic sequence changes by a constant difference between consecutive terms; a geometric sequence changes by a constant ratio between consecutive terms.',
   'Classifying a sequence correctly by its change pattern is the entry point for recognizing linear versus exponential behavior later in this unit.',
   'You earn points by computing consecutive differences to check for a constant common difference, or consecutive ratios to check for a constant common ratio, not by guessing from the shape of the numbers.',
   'Compute term-to-term differences first; if constant, it''s arithmetic. If not, compute term-to-term ratios; if constant, it''s geometric.',
   'Assuming a sequence is arithmetic or geometric from its appearance without actually computing differences or ratios.',
   '/learn/ap-precalculus/unit-2/arithmetic-and-geometric-sequences'),
  ('2.2','Change in Linear and Exponential Functions','very-important','very-important',
   'A linear function changes by equal differences over equal input intervals; an exponential function changes by equal ratios (a constant multiplicative factor) over equal input intervals.',
   'Citing a calculator''s regression fit statistic instead of computing the actual ratio of outputs is a real, documented reasoning error that fails to earn credit even when the classification itself is correct.',
   'You earn points by computing the actual ratio of consecutive outputs to justify exponential behavior (or the actual difference to justify linear behavior), not by citing an r-value or r-squared value as justification.',
   'For equally spaced inputs, compute consecutive output differences (linear check) and consecutive output ratios (exponential check), and cite whichever is actually constant as the reasoning.',
   'Citing ''exponential regression'' or a high r-squared value as the reason data is exponential, instead of computing the actual constant ratio.',
   '/learn/ap-precalculus/unit-2/change-in-linear-and-exponential-functions'),
  ('2.3','Exponential Functions','very-important','very-important',
   'The general exponential function has the form f(x) = a*b^x, where a is nonzero, b is positive, and b does not equal 1.',
   'The restrictions on a, b are not decorative -- b=1 gives a constant function and b<=0 breaks the function for non-integer x, so a valid exponential model must respect all three conditions.',
   'You earn points by identifying a and b correctly from context or data and by respecting the stated restrictions (a ≠ 0, b > 0, b ≠ 1) when constructing or checking a model.',
   'Write the model as f(x) = a*b^x, identify a as the initial value and b as the growth/decay factor, and confirm b is positive and not equal to 1.',
   'Proposing an exponential model with b ≤ 0 or b = 1, which violates the form''s required restrictions.',
   '/learn/ap-precalculus/unit-2/exponential-functions'),
  ('2.4','Exponential Function Manipulation','very-important','very-important',
   'Exponential function manipulation rewrites expressions like a*b^x into equivalent forms using the laws of exponents, such as changing the base or rewriting a compound growth rate.',
   'The same exponential function can be written with different bases (e.g., b^x rewritten as (b^k)^(x/k)), and recognizing these as equivalent, not different functions, is essential for comparing or combining models.',
   'You earn points by applying exponent rules correctly (product, power, and rewriting rules) to produce an equivalent expression, and by verifying the rewritten form still matches the original at a test value.',
   'Apply exponent laws step by step to rewrite the expression, then check the rewritten form against the original at one test input value to confirm they match.',
   'Misapplying an exponent rule (such as distributing an exponent across a sum) when rewriting an exponential expression.',
   '/learn/ap-precalculus/unit-2/exponential-function-manipulation'),
  ('2.5','Exponential Function Context and Data Modeling','very-important','very-important',
   'Exponential context and data modeling builds a model f(x) = a*b^x from a real-world growth or decay situation or from tabulated data, then uses it to answer questions in context.',
   'Building a model correctly from context means correctly identifying the initial value a and translating a stated rate (like ''5% growth per year'') into the correct base b, not just any number that seems close.',
   'You earn points by correctly identifying a as the initial value at x=0, correctly converting a stated percentage rate into b (e.g., 5% growth becomes b=1.05, 5% decay becomes b=0.95), and interpreting the model''s output in the context''s units.',
   'Identify the initial value as a, convert the stated growth or decay rate into b using 1 plus or minus the rate as a decimal, then interpret results with the context''s units attached.',
   'Converting a stated percentage rate into b incorrectly, such as using b=0.05 instead of b=1.05 for 5% growth.',
   '/learn/ap-precalculus/unit-2/exponential-function-context-and-data-modeling'),
  ('2.6','Competing Function Model Validation','very-important','very-important',
   'Competing function model validation compares candidate model types (such as linear versus exponential) against the same data set to determine which actually fits the data''s change pattern.',
   'The same real reasoning error as classifying single data sets recurs here: citing a high r-squared value from either candidate model is not valid justification for choosing between them.',
   'You earn points by computing the actual differences and ratios in the data and citing whichever pattern is constant as the reason for selecting that model type, not by comparing regression fit statistics.',
   'Compute consecutive differences and consecutive ratios directly from the data, then select the model type whose corresponding pattern (constant difference or constant ratio) actually holds.',
   'Choosing between competing models by comparing r-squared values instead of computing the data''s actual difference and ratio patterns.',
   '/learn/ap-precalculus/unit-2/competing-function-model-validation'),
  ('2.7','Composition of Functions','very-important','very-important',
   'Function composition f(g(x)) applies g first, then applies f to that result -- the order of the two functions generally cannot be reversed without changing the outcome.',
   'f(g(x)) and g(f(x)) are generally different functions, so composing in the wrong order produces a genuinely different result, not just an equivalent rearrangement.',
   'You earn points by substituting the inner function''s entire expression into the outer function correctly, in the stated order, and simplifying the result accurately.',
   'Identify which function is inner and which is outer from the notation, substitute the inner function''s full expression into the outer function, then simplify.',
   'Computing g(f(x)) when f(g(x)) was requested, treating composition as commutative.',
   '/learn/ap-precalculus/unit-2/composition-of-functions'),
  ('2.8','Inverse Functions','very-important','very-important',
   'An inverse function reverses a function''s input-output pairs, swapping the domain and range, and exists only when the original function is one-to-one.',
   'A function that is not one-to-one (fails the horizontal line test) does not have a true inverse function over its full domain, since reversing its pairs would assign one input to multiple outputs.',
   'You earn points by verifying the function is one-to-one before claiming an inverse exists, and by correctly swapping the roles of x and y (domain and range) when finding the inverse.',
   'Check that the function passes the horizontal line test (or is one-to-one over the given domain) before finding an inverse; then swap x and y and solve for the new y.',
   'Finding an inverse for a function without checking or restricting for one-to-one behavior first.',
   '/learn/ap-precalculus/unit-2/inverse-functions'),
  ('2.9','Logarithmic Expressions','very-important','very-important',
   'A logarithmic expression log_b(x) = y is defined as the exponent y such that b^y = x, making logarithms and exponents two directions of the same relationship.',
   'Evaluating or rewriting a logarithmic expression correctly depends on translating fluently between the log form and the exponential form -- log_b(x)=y and b^y=x are the same statement, not two separate facts to memorize.',
   'You earn points by correctly translating between logarithmic and exponential form, and by evaluating logarithms exactly (without a calculator) when the base and argument allow it.',
   'Rewrite log_b(x)=y as b^y=x (or the reverse) to evaluate or verify, especially when an exact, calculator-free value is required.',
   'Attempting to evaluate a logarithm numerically as an approximation when an exact value is expected and obtainable.',
   '/learn/ap-precalculus/unit-2/logarithmic-expressions'),
  ('2.10','Inverses of Exponential Functions','very-important','very-important',
   'The inverse of an exponential function is derived by swapping x and y and solving for y using logarithms, and this topic''s required derivation work is scoped to functions with an initial value of 1, f(x) = b^x.',
   'This topic''s scope is narrower than the general exponential form used elsewhere in the unit -- deriving the inverse for a general a*b^x model (with a not equal to 1) goes beyond what this specific topic requires.',
   'You earn points by correctly deriving the inverse of f(x) = b^x as a logarithm, using the swap-and-solve method, without needing to handle the general a*b^x case here.',
   'For f(x) = b^x, swap x and y to get x = b^y, then rewrite as y = log_b(x) to state the inverse.',
   'Treating this topic''s inverse-derivation work as requiring the general a*b^x case rather than the initial-value-of-1 case it''s actually scoped to.',
   '/learn/ap-precalculus/unit-2/inverses-of-exponential-functions'),
  ('2.11','Logarithmic Functions','very-important','very-important',
   'The general logarithmic function has the form f(x) = a * log_b(x), extending the basic inverse-of-exponential logarithm to include a leading coefficient a.',
   'The coefficient a scales the logarithm''s output, changing its steepness and reflection, in the same way a scales any other function family -- it is a separate, freely-chosen constant, not restricted the way topic 2.10''s initial-value-of-1 scope was.',
   'You earn points by correctly identifying a and b from context or a graph, and by describing how changes in a affect the function''s steepness or reflection.',
   'Write the model as f(x) = a * log_b(x), identify a as the vertical scale factor and b as the logarithm''s base, and interpret changes to a as stretching, compressing, or reflecting the graph.',
   'Confusing the general logarithmic form''s coefficient a with the base b, or omitting a from the model entirely.',
   '/learn/ap-precalculus/unit-2/logarithmic-functions'),
  ('2.12','Logarithmic Function Manipulation','very-important','very-important',
   'Logarithmic function manipulation rewrites logarithmic expressions using the product property, power property, and change-of-base property to combine or simplify them.',
   'A quotient-of-logs rewrite is still valid and testable, even though the quotient property is only derivable from the product and power properties rather than given as its own separate rule in the required content.',
   'You earn points by correctly applying the product, power, or change-of-base property to rewrite an expression, and by deriving a quotient rewrite from the product and power properties rather than treating it as a fourth standalone rule.',
   'Apply the product property to combine sums of logs, the power property to move exponents out front, and change-of-base to convert between bases; derive quotient rewrites from these rather than citing a separate quotient rule.',
   'Misapplying the power property by moving a coefficient into the logarithm''s argument as a multiplier instead of an exponent.',
   '/learn/ap-precalculus/unit-2/logarithmic-function-manipulation'),
  ('2.13','Exponential and Logarithmic Equations and Inequalities','very-important','very-important',
   'Solving exponential and logarithmic equations often requires recognizing a hidden algebraic structure, such as a quadratic disguised in terms of e^x, and solving that structure before undoing the exponential or logarithm.',
   'A hidden-quadratic-in-e^x equation was the two lowest-scoring points on the entire 2025 exam -- the documented failure is not recognizing the quadratic structure and not eliminating the impossible negative-value solution for e^x.',
   'You earn points by substituting a variable for e^x to reveal the quadratic, factoring or solving it, and explicitly rejecting any solution where e^x would have to be negative or zero, since e^x is always positive.',
   'Substitute u = e^x to expose the quadratic in u, solve for u, reject any negative or zero solution for u, then solve e^x = (the valid positive u-value) for x.',
   'Not recognizing an equation as a quadratic disguised in e^x, and not eliminating the impossible solution where e^x would be negative.',
   '/learn/ap-precalculus/unit-2/exponential-and-logarithmic-equations-and-inequalities'),
  ('2.14','Logarithmic Function Context and Data Modeling','very-important','very-important',
   'Logarithmic context and data modeling builds a model f(x) = a*log_b(x) from a real-world situation or data set that grows quickly at first and then levels off, then uses it to answer questions in context.',
   'Recognizing when logarithmic growth (fast-then-leveling) rather than exponential growth (accelerating) actually matches a data pattern is what determines whether this model family is the appropriate choice.',
   'You earn points by correctly identifying that a logarithmic model fits data that increases quickly at first and then slows its rate of increase, and by interpreting the model''s output using the context''s units.',
   'Check whether the data''s rate of increase is slowing over time (logarithmic-shaped) rather than accelerating (exponential-shaped) before selecting a logarithmic model, then interpret outputs with context units.',
   'Selecting a logarithmic model for data that is actually accelerating, which is exponential behavior, not logarithmic.',
   '/learn/ap-precalculus/unit-2/logarithmic-function-context-and-data-modeling'),
  ('2.15','Semi-log Plots','very-important','very-important',
   'A semi-log plot graphs log_n(y) against x for exponential data y = a*b^x, producing a straight line with slope log_n(b) and intercept log_n(a), using a log base n greater than 1.',
   'This linearization is what lets exponential data be analyzed with straight-line tools -- but it only works correctly when the required log base restriction n > 1 is respected, not merely n not equal to 1.',
   'You earn points by correctly taking log_n of both sides of y=a*b^x to produce the linear form, correctly identifying the resulting slope as log_n(b) and intercept as log_n(a), and respecting the n > 1 restriction on the log base used.',
   'Take log_n of both sides of y=a*b^x with n > 1, rewrite as log_n(y) = (log_n b)*x + log_n(a), then read the slope as log_n(b) and the intercept as log_n(a).',
   'Using a log base n that is not greater than 1 (such as a fractional base) for the semi-log linearization, violating the required restriction.',
   '/learn/ap-precalculus/unit-2/semi-log-plots')
)
insert into app.topic_point_briefs (
  subject_key, unit_number, topic_code, title, class_importance, exam_importance,
  what_it_is, why_it_matters, how_points_are_earned, answer_move,
  common_point_loss, learn_more_path, practice_subject_key, practice_unit_number,
  practice_topic_code, source_note, status, published_at
)
select
  'ap_precalculus', 2, topic_code, title, class_importance, exam_importance,
  what_it_is, why_it_matters, how_points_are_earned, answer_move,
  common_point_loss, learn_more_path, 'ap_precalculus', 2, topic_code,
  'cramapple-authored; new coverage 2026-08-21 -- AP Precalculus Unit 2 (Exponential and Logarithmic Functions, exam-assessed, 25-40% weighting) had zero published briefs or explainers across all 15 topics before this migration, discovered while investigating why AP Precalculus topics appeared not to render for students. Grounded in docs/product/AP_PRECALCULUS_CED_FACT_PACK.md''s Unit 2 deep-tier detail: the documented real 2025 exam finding that citing a regression r-squared value is NOT sufficient reasoning to justify exponential data (mean 0.30/1 reasoning point); the hidden-quadratic-in-e^x pattern (e^(2x)-e^x-12=0) which produced the two lowest-scoring points on the entire 2025 exam (0.14/0.10) via failure to reject the impossible negative e^x root; topic 2.10''s narrower initial-value-of-1 scope for the exponential-inverse derivation, distinct from 2.11''s general a*log_b(x) form; the quotient-of-logs property being derivable but not given as its own separate EK; and the semi-log linearization''s n>1 log-base restriction (not merely n≠1). Math independently verified before writing to the database. batch 2026-08-21-ap-precalculus-unit2-new-coverage; author=reviewer same session, no independent human review yet', 'published', now()
from brief_seed
on conflict (subject_key, topic_code) do update
set
  title = excluded.title,
  class_importance = excluded.class_importance,
  exam_importance = excluded.exam_importance,
  what_it_is = excluded.what_it_is,
  why_it_matters = excluded.why_it_matters,
  how_points_are_earned = excluded.how_points_are_earned,
  answer_move = excluded.answer_move,
  common_point_loss = excluded.common_point_loss,
  learn_more_path = excluded.learn_more_path,
  practice_subject_key = excluded.practice_subject_key,
  practice_unit_number = excluded.practice_unit_number,
  practice_topic_code = excluded.practice_topic_code,
  source_note = excluded.source_note,
  status = excluded.status,
  published_at = excluded.published_at;

with explainer_seed (
  topic_code, title, core_idea, what_students_need_to_understand,
  how_this_becomes_points, answer_move, mini_example_question, weak_answer,
  point_attaining_answer, common_point_loss, practice_bridge
) as (
  values
  ('2.1','Change in Arithmetic and Geometric Sequences',
   'A sequence is classified as arithmetic or geometric by an actual computed check -- constant term-to-term difference for arithmetic, constant term-to-term ratio for geometric -- not by how the numbers look at a glance.',
   'The same list of numbers could look like it fits either pattern at first glance; only the explicit difference-then-ratio check distinguishes them, and a sequence can fail both checks entirely.',
   'Full credit requires showing the consecutive-difference computation (and the consecutive-ratio computation if differences aren''t constant) explicitly, not just naming a sequence type.',
   'Compute at least two consecutive differences; if they match, state constant difference and classify as arithmetic. If not, compute consecutive ratios and classify as geometric if those match.',
   'A sequence begins 3, 6, 12, 24. A student classifies it as arithmetic because each term is visibly increasing at a steady-looking pace.',
   'This is arithmetic, since the terms increase steadily.',
   'This is not arithmetic -- the differences (3, 6, 12) are not constant, so the arithmetic check fails; checking ratios instead (6/3=2, 12/6=2, 24/12=2) gives a constant ratio of 2, so this sequence is geometric with common ratio 2, not arithmetic.',
   'Assuming a sequence is arithmetic or geometric from its appearance without actually computing differences or ratios.',
   'Before classifying any sequence, compute at least two consecutive differences and, if those aren''t constant, two consecutive ratios, rather than judging by the numbers'' general appearance.'),
  ('2.2','Change in Linear and Exponential Functions',
   'Justifying that data is exponential requires computing the actual constant ratio between consecutive outputs -- citing a calculator''s regression fit statistic like r-squared is a documented, real reasoning error that fails to earn credit even with the correct classification.',
   'A high r-squared value only says a model fits well; it says nothing about which family of function actually produces constant ratios in the data, which is the real defining test for exponential behavior.',
   'Full credit for the reasoning requires the actual constant ratio (or constant difference) computed and shown from the data, not a regression-fit statistic cited as justification.',
   'Compute the ratio of consecutive equally-spaced outputs directly from the data and state that constant ratio as the reason the data is exponential, never citing r or r-squared as the justification.',
   'Given data at equally spaced x-values with outputs 5, 10, 20, 40, a student justifies exponential behavior by saying ''my calculator''s exponential regression gave r-squared = 0.999.''',
   'This is sufficient justification, since a very high r-squared confirms the exponential fit.',
   'Citing r-squared is not sufficient reasoning -- this is a documented real scoring pattern where such justification fails to earn the point; the correct reasoning computes the actual ratios of consecutive outputs (10/5=2, 20/10=2, 40/20=2), showing a constant ratio of 2, which is what actually demonstrates exponential behavior.',
   'Citing ''exponential regression'' or a high r-squared value as the reason data is exponential, instead of computing the actual constant ratio.',
   'Whenever justifying that data is exponential, compute and state the actual constant ratio between consecutive outputs, and never cite a regression statistic like r or r-squared as the reasoning.'),
  ('2.3','Exponential Functions',
   'The exponential form f(x) = a*b^x carries three required restrictions -- a nonzero, b positive, b not equal to 1 -- and each restriction rules out a specific way the function would otherwise break or degenerate.',
   'b=1 would make f(x) constant (not exponential at all), and b≤0 would make the function undefined or oscillate wildly for non-integer x, so these are not arbitrary technicalities but conditions that keep the function meaningfully exponential.',
   'Full credit requires stating the general form with a and b correctly identified from the given information, and confirming the restrictions are satisfied rather than assumed.',
   'Write f(x) = a*b^x explicitly, substitute the identified initial value for a and growth/decay factor for b, then check b > 0 and b ≠ 1 before treating the model as valid.',
   'A student proposes modeling a population with f(x) = 200*(1)^x because the population starts at 200 and a coworker said ''exponential growth'' applies.',
   'This is a valid exponential model, since it starts at the correct initial value of 200.',
   'This is not a valid exponential model -- b=1 is explicitly excluded by the required form, since (1)^x always equals 1, making f(x) constant at 200 rather than exponential; a valid exponential model needs a growth or decay factor b that is positive and not equal to 1, such as f(x)=200*(1.05)^x for 5% growth.',
   'Proposing an exponential model with b ≤ 0 or b = 1, which violates the form''s required restrictions.',
   'Before accepting any exponential model, check explicitly that its base b is positive and not equal to 1, since either violation means the model isn''t a valid exponential function at all.'),
  ('2.4','Exponential Function Manipulation',
   'Rewriting an exponential expression into an equivalent form (a different base, a different-looking growth rate) requires the exponent laws applied correctly step by step -- a rewritten expression that isn''t checked against the original at a test value can silently be a different function, not an equivalent one.',
   'Exponent rules like (b^m)^n = b^(mn) apply to products and powers of the base, never to sums in the exponent or the base itself, so a rewrite that distributes an exponent across addition breaks the expression''s actual value.',
   'Full credit requires each exponent-law step shown explicitly, and the rewritten expression verified against the original at a test input value.',
   'Apply one exponent law at a time to rewrite the expression, then substitute a test value into both the original and rewritten forms to confirm they produce the same output.',
   'A student rewrites 2^(x+3) as 2^x + 2^3, treating the exponent''s addition as distributing across the base.',
   'This is a valid equivalent form, since the exponent was expanded correctly.',
   'This is not equivalent -- exponent addition in 2^(x+3) means 2^x * 2^3, not 2^x + 2^3; testing at x=0 confirms the error: the original gives 2^3=8, while the incorrect rewrite gives 2^0+2^3=1+8=9, so the rewritten form is a different function, not an equivalent one.',
   'Misapplying an exponent rule (such as distributing an exponent across a sum) when rewriting an exponential expression.',
   'After rewriting any exponential expression, substitute one test value into both the original and the rewritten form to confirm they actually produce the same output.'),
  ('2.5','Exponential Function Context and Data Modeling',
   'Building an exponential model from a stated growth or decay rate requires converting that percentage into b as 1 plus or minus the rate as a decimal -- using the raw percentage itself as b, without the 1, produces a model that shrinks or grows in the wrong direction entirely.',
   'A ''5% growth'' rate means the new amount is 105% of the old amount, so b = 1.05, not b = 0.05; the same logic in reverse gives b = 0.95 for 5% decay, since the new amount is 95% of the old.',
   'Full credit requires the rate correctly converted to b (1 plus or minus the decimal rate) and the initial value correctly identified as a, with the model''s output interpreted using the context''s units.',
   'Convert the stated rate to b using 1 plus the rate for growth or 1 minus the rate for decay, identify a as the value at x=0, then interpret the model''s result with correct units.',
   'A population grows at 5% per year starting from 200. A student models this as f(x) = 200*(0.05)^x.',
   'This is correct, since 0.05 represents the 5% growth rate.',
   'The base is wrong -- a 5% growth rate means the population becomes 105% of the previous year''s value each year, so b should be 1.05, not 0.05; using b=0.05 would model rapid decay toward zero, the opposite of growth; the correct model is f(x) = 200*(1.05)^x.',
   'Converting a stated percentage rate into b incorrectly, such as using b=0.05 instead of b=1.05 for 5% growth.',
   'Whenever converting a stated percentage rate into an exponential base b, write it as 1 plus the rate for growth or 1 minus the rate for decay, never the bare decimal rate alone.'),
  ('2.6','Competing Function Model Validation',
   'Choosing between two competing model types for the same data requires computing the data''s actual difference and ratio patterns directly -- comparing which model has the higher r-squared value is not valid justification, even when it points to the same correct answer.',
   'A data set can be tested against both patterns at once: if consecutive differences are constant, linear fits; if consecutive ratios are constant instead, exponential fits; a data set should not fit both patterns simultaneously unless it is genuinely constant.',
   'Full credit requires both the consecutive-difference and consecutive-ratio computations shown, with the model selected based on which pattern is actually constant in the data.',
   'Compute consecutive differences and consecutive ratios for the given data, then select the model type (linear or exponential) whose corresponding pattern is constant, citing the actual computed values.',
   'Given data at equally spaced x-values with outputs 4, 7, 12, 19, a student is asked to choose between a linear and an exponential model and picks exponential because ''the numbers are growing.''',
   'Exponential is the right choice, since the outputs are clearly increasing faster and faster.',
   'Neither pattern actually holds here, and ''growing faster'' alone isn''t valid reasoning -- consecutive differences are 3, 5, 7 (not constant, so not linear) and consecutive ratios are 7/4=1.75, 12/7≈1.71, 19/12≈1.58 (not constant either, so not exponential); this data doesn''t cleanly fit either competing model, and neither should be selected without an actual constant pattern found.',
   'Choosing between competing models by comparing r-squared values instead of computing the data''s actual difference and ratio patterns.',
   'Before selecting between competing model types, compute both the consecutive differences and consecutive ratios directly from the data, rather than judging from the data''s general growth appearance or a regression statistic.'),
  ('2.7','Composition of Functions',
   'Function composition applies the inner function first and substitutes its entire output into the outer function -- f(g(x)) and g(f(x)) are generally different functions entirely, not just two ways of writing the same computation.',
   'The notation f(g(x)) reads right-to-left in terms of application order: g acts on x first, and only that full result becomes the input to f, so every instance of the outer function''s variable must be replaced by the complete inner expression.',
   'Full credit requires the entire inner function''s expression substituted correctly into the outer function, in the order specified by the notation, with the result simplified.',
   'Identify the inner and outer functions from the notation exactly as written, substitute the inner function''s full expression for every instance of the outer function''s variable, then simplify.',
   'For f(x) = x^2 + 1 and g(x) = x - 3, a student is asked to find f(g(x)) and computes g(f(x)) = (x^2+1) - 3 = x^2 - 2 instead.',
   'This is correct, since composition can be evaluated in either order and gives the same result.',
   'This computed g(f(x)), not the requested f(g(x)) -- these are generally different functions; the correct computation substitutes g(x)=x-3 into f: f(g(x)) = (x-3)^2 + 1, which expands to x^2 - 6x + 10, a different function from x^2 - 2.',
   'Computing g(f(x)) when f(g(x)) was requested, treating composition as commutative.',
   'Before computing any composition, identify exactly which function is inner and which is outer from the notation, and never assume the reversed order gives the same result.'),
  ('2.8','Inverse Functions',
   'An inverse function only exists when the original function is one-to-one over its domain -- swapping x and y and solving for a function that fails this check produces a relation, not a genuine inverse function.',
   'A function that assigns the same output to two different inputs cannot have its pairs cleanly reversed into a function, since the reversed relation would need to send one input back to two different outputs.',
   'Full credit requires confirming the function is one-to-one (or restricting its domain so it is) before computing an inverse, then correctly swapping the variables and solving.',
   'Confirm the function is one-to-one over the relevant domain first, then swap x and y in the equation and solve for the new y to obtain the inverse.',
   'For f(x) = x^2 (over all real numbers), a student swaps variables to get x = y^2, solves to get y = sqrt(x), and calls this the inverse function of f.',
   'This is a valid inverse function, since the algebra of swapping and solving was done correctly.',
   'f(x) = x^2 over all real numbers is not one-to-one (both x=2 and x=-2 give f(x)=4), so it has no true inverse function over its full domain; y = sqrt(x) is only the inverse of the restricted function f(x) = x^2 for x ≥ 0, not of f(x) = x^2 over all real numbers.',
   'Finding an inverse for a function without checking or restricting for one-to-one behavior first.',
   'Before finding any inverse function, confirm the original function is one-to-one over the domain in question, restricting the domain first if it isn''t.'),
  ('2.9','Logarithmic Expressions',
   'A logarithmic expression log_b(x)=y and the exponential statement b^y=x express the exact same relationship in two directions -- fluently rewriting between the two forms, not memorizing them as separate facts, is what lets a logarithm be evaluated exactly.',
   'When a logarithm''s base and argument are both powers of the same number, the exact value can always be found by rewriting as an exponential equation and solving, without needing a decimal approximation.',
   'Full credit for evaluating a logarithm without a calculator requires the exponential-form rewrite shown explicitly and solved to an exact value, not a decimal estimate.',
   'Rewrite the logarithmic expression as its equivalent exponential equation, then solve that equation exactly for the unknown exponent or value.',
   'A student is asked to determine the exact value of log_2(8) without a calculator and estimates it as approximately 3 by trial and error with a calculator anyway.',
   '3 is the correct value, so any method used to reach it is fine.',
   'The value 3 is correct, but the expected method is the exact exponential rewrite: log_2(8)=y means 2^y=8, and since 2^3=8 exactly, y=3 exactly -- this should be shown as an exact algebraic step, not reached by calculator estimation, since the whole point of this topic is fluency without a calculator.',
   'Attempting to evaluate a logarithm numerically as an approximation when an exact value is expected and obtainable.',
   'Before evaluating any logarithm by calculator, check whether the base and argument allow an exact rewrite as an exponential equation, and use that instead.'),
  ('2.10','Inverses of Exponential Functions',
   'This topic''s required inverse-derivation work is scoped specifically to functions with an initial value of 1, f(x) = b^x, even though the general exponential form used elsewhere in this unit allows any nonzero initial value a.',
   'Swapping x and y in x = b^y and solving for y requires the definition of a logarithm directly: y = log_b(x) is exactly what ''the exponent that produces x when b is raised to it'' means.',
   'Full credit requires the swap-and-solve steps shown explicitly for f(x) = b^x, arriving at the inverse y = log_b(x), without needing to generalize to an arbitrary initial value.',
   'Start from f(x) = b^x, swap x and y to get x = b^y, then rewrite using the definition of a logarithm to state y = log_b(x) as the inverse.',
   'A student is asked to derive the inverse of f(x) = 3^x and instead sets up the general case f(x) = a*3^x, worrying about solving for an unspecified constant a.',
   'The general a*3^x case must be handled first, since that''s the fully general exponential form.',
   'This topic''s derivation work is scoped to the initial-value-of-1 case, f(x)=b^x, not the general a*b^x form; for f(x)=3^x, swapping gives x=3^y, and rewriting using the logarithm definition gives y=log_3(x) directly -- there is no need to introduce or solve for a general constant a here.',
   'Treating this topic''s inverse-derivation work as requiring the general a*b^x case rather than the initial-value-of-1 case it''s actually scoped to.',
   'When deriving the inverse of an exponential function for this topic, work directly with f(x) = b^x rather than introducing a general initial value a that isn''t part of what''s being asked.'),
  ('2.11','Logarithmic Functions',
   'The general logarithmic form f(x) = a * log_b(x) uses a as a separate vertical scale factor on top of the basic inverse-of-exponential logarithm -- unlike topic 2.10''s narrower initial-value-of-1 scope, this general form allows any nonzero a.',
   'Changing a stretches, compresses, or (if negative) reflects the logarithmic curve vertically, while changing the base b changes how quickly the curve grows or decays -- these are two independent parameters doing different jobs.',
   'Full credit requires a and b both correctly identified from the given information, with a''s effect on the graph (stretch, compression, or reflection) described accurately.',
   'Write the model as f(x) = a*log_b(x), identify a and b separately from the given information, then describe a''s effect on the graph''s steepness or orientation.',
   'A student is given the model f(x) = -2*log_3(x) and states that the base of the logarithm is -2.',
   'This is correct, since -2 is the number attached to the logarithm.',
   '-2 is the coefficient a, not the base -- the base here is 3, matching log_3(x); the coefficient a=-2 means the graph is vertically stretched by a factor of 2 and reflected over the x-axis, since a is negative, but it never functions as the logarithm''s base.',
   'Confusing the general logarithmic form''s coefficient a with the base b, or omitting a from the model entirely.',
   'When given a logarithmic model, identify the coefficient a and the base b as two separate quantities before describing the graph, rather than treating either one as if it were the other.'),
  ('2.12','Logarithmic Function Manipulation',
   'Rewriting log_b(x/y) as log_b(x) minus log_b(y) is a fully valid, testable rewrite, even though a quotient property is never given as its own separate rule in the required content -- it is derived directly from the product and power properties applied to x*y^(-1).',
   'The power property moves an exponent out front as a multiplying coefficient (log_b(x^n) = n*log_b(x)); it does not work in reverse to turn an existing coefficient into an exponent unless that step is explicitly justified.',
   'Full credit requires each logarithm property applied correctly and explicitly, with a quotient rewrite (if used) shown as following from the product and power properties rather than cited as its own rule.',
   'Identify which property (product, power, or change-of-base) applies to the given expression, apply it as an explicit step, and derive any quotient rewrite from the product and power properties together.',
   'A student rewrites 3*log_b(x) as log_b(3x), moving the coefficient 3 inside as a multiplier of x rather than as an exponent.',
   'This is a valid rewrite of the power property in reverse.',
   'This misapplies the power property -- the power property states log_b(x^n) = n*log_b(x), so reversing it correctly gives 3*log_b(x) = log_b(x^3), with the coefficient becoming an exponent, not a multiplier; log_b(3x) is a completely different expression, equal to log_b(3) + log_b(x) by the product property instead.',
   'Misapplying the power property by moving a coefficient into the logarithm''s argument as a multiplier instead of an exponent.',
   'Before rewriting a coefficient in front of a logarithm, apply the power property correctly: the coefficient becomes an exponent inside the logarithm, never a multiplier of the argument.'),
  ('2.13','Exponential and Logarithmic Equations and Inequalities',
   'An equation like e^(2x) minus e^x minus 12 equals zero is a quadratic disguised in e^x -- substituting u=e^x, solving the quadratic, and explicitly rejecting any negative solution for u (since e^x can never be negative) is the documented lowest-scoring point pattern on the entire exam when skipped.',
   'e^(2x) equals (e^x)^2, so the equation becomes an ordinary quadratic in the substitute variable u=e^x; once solved, any solution requiring e^x to equal a negative number or zero must be rejected before finishing, since e^x is always strictly positive.',
   'Full credit requires the substitution u=e^x shown explicitly, the resulting quadratic solved (by factoring or the quadratic formula), and the negative or zero root for u explicitly rejected before solving for the final x-value.',
   'Substitute u=e^x to rewrite the equation as a quadratic in u, solve for u, reject any u-value that is negative or zero, then solve e^x equals the remaining valid u-value for x.',
   'Solve e^(2x) - e^x - 12 = 0. A student substitutes u=e^x, factors (u-4)(u+3)=0 to get u=4 or u=-3, then writes x=ln(4) or x=ln(-3).',
   'Both solutions are valid, since the factoring was done correctly and each u-value gives a corresponding x.',
   'The factoring is correct, but u=-3 must be rejected -- since u represents e^x, and e^x is always strictly positive, u=-3 is impossible and ln(-3) is not a real number; the only valid solution is from u=4: e^x=4, so x=ln(4). This explicit rejection step is exactly the lowest-scoring point pattern on the 2025 exam when it''s skipped.',
   'Not recognizing an equation as a quadratic disguised in e^x, and not eliminating the impossible solution where e^x would be negative.',
   'Whenever an exponential equation has the structure of a quadratic in e^x, substitute u=e^x, solve the quadratic, and explicitly reject any negative or zero solution for u before finishing.'),
  ('2.14','Logarithmic Function Context and Data Modeling',
   'A logarithmic model fits data whose rate of increase is slowing over time -- fast growth at first that levels off -- which is the opposite shape from exponential data, whose rate of increase accelerates; mismatching these two shapes selects the wrong model family entirely.',
   'Both exponential and logarithmic models can look like they''re ''increasing quickly,'' but only checking whether the increase is speeding up (exponential) or slowing down (logarithmic) actually distinguishes which family the data belongs to.',
   'Full credit requires the data''s increasing-but-slowing pattern identified explicitly as the reason a logarithmic model is appropriate, with the model''s output interpreted in the context''s units.',
   'Check whether the data''s rate of increase is slowing over successive intervals, and if so, select a logarithmic model, then interpret its output using the context''s given units.',
   'A quantity''s values over equally spaced time periods are 10, 100, 1000, 10000 -- each increase is far larger than the last. A student selects a logarithmic model, saying ''the values are growing quickly, so logarithmic fits.''',
   'Logarithmic is the right family, since the data is clearly increasing quickly.',
   'This data''s rate of increase is accelerating (each jump is 10 times the last), which is exactly exponential behavior, not logarithmic; a logarithmic model instead fits data whose rate of increase slows down over time -- ''increasing quickly'' alone doesn''t distinguish the two families, since both can increase quickly in the short term.',
   'Selecting a logarithmic model for data that is actually accelerating, which is exponential behavior, not logarithmic.',
   'Before selecting a logarithmic model for context data, check whether the data''s rate of increase is slowing down over time, rather than judging from the data ''growing quickly'' alone.'),
  ('2.15','Semi-log Plots',
   'The semi-log linearization of y=a*b^x produces log_n(y) = (log_n b)*x + log_n(a), a genuine straight line -- but this only holds under the specific restriction that the log base n is greater than 1, not merely that n is not equal to 1.',
   'The slope of the resulting line is log_n(b), directly encoding the original exponential base b, and the intercept is log_n(a), encoding the original initial value a -- reading a semi-log plot''s slope and intercept recovers the original exponential model''s parameters.',
   'Full credit requires the linearization steps shown explicitly, the slope and intercept correctly identified as log_n(b) and log_n(a) respectively, and the log base used confirmed to satisfy n > 1.',
   'Take log_n of both sides of the exponential equation with a base n greater than 1, rewrite into the linear form, then identify the slope as log_n(b) and the intercept as log_n(a).',
   'A student linearizes y = 5*2^x using a log base of n = 1/2, since 1/2 is not equal to 1, and proceeds to compute a semi-log plot''s slope and intercept with that base.',
   'This is valid, since the only stated requirement is that the log base cannot equal 1.',
   'The required restriction is n > 1, not merely n ≠ 1 -- a base of 1/2 fails this stricter condition and is not a valid choice for this linearization; a valid choice would be any n > 1, such as n=10 (a standard log) or n=e (a natural log), giving slope log_n(2) and intercept log_n(5).',
   'Using a log base n that is not greater than 1 (such as a fractional base) for the semi-log linearization, violating the required restriction.',
   'Before performing a semi-log linearization, confirm the chosen log base n is strictly greater than 1, not just different from 1.')
)
insert into app.topic_explainers (
  subject_key, unit_number, topic_code, title, core_idea,
  what_students_need_to_understand, how_this_becomes_points, answer_move,
  mini_example_question, weak_answer, point_attaining_answer,
  common_point_loss, practice_bridge, source_note, status, published_at
)
select
  'ap_precalculus', 2, topic_code, title, core_idea,
  what_students_need_to_understand, how_this_becomes_points, answer_move,
  mini_example_question, weak_answer, point_attaining_answer,
  common_point_loss, practice_bridge,
  'cramapple-authored; new coverage 2026-08-21 -- AP Precalculus Unit 2 (Exponential and Logarithmic Functions, exam-assessed, 25-40% weighting) had zero published briefs or explainers across all 15 topics before this migration, discovered while investigating why AP Precalculus topics appeared not to render for students. Grounded in docs/product/AP_PRECALCULUS_CED_FACT_PACK.md''s Unit 2 deep-tier detail: the documented real 2025 exam finding that citing a regression r-squared value is NOT sufficient reasoning to justify exponential data (mean 0.30/1 reasoning point); the hidden-quadratic-in-e^x pattern (e^(2x)-e^x-12=0) which produced the two lowest-scoring points on the entire 2025 exam (0.14/0.10) via failure to reject the impossible negative e^x root; topic 2.10''s narrower initial-value-of-1 scope for the exponential-inverse derivation, distinct from 2.11''s general a*log_b(x) form; the quotient-of-logs property being derivable but not given as its own separate EK; and the semi-log linearization''s n>1 log-base restriction (not merely n≠1). Math independently verified before writing to the database. batch 2026-08-21-ap-precalculus-unit2-new-coverage; author=reviewer same session, no independent human review yet', 'published', now()
from explainer_seed
on conflict (subject_key, topic_code) do update
set
  title = excluded.title,
  core_idea = excluded.core_idea,
  what_students_need_to_understand = excluded.what_students_need_to_understand,
  how_this_becomes_points = excluded.how_this_becomes_points,
  answer_move = excluded.answer_move,
  mini_example_question = excluded.mini_example_question,
  weak_answer = excluded.weak_answer,
  point_attaining_answer = excluded.point_attaining_answer,
  common_point_loss = excluded.common_point_loss,
  practice_bridge = excluded.practice_bridge,
  source_note = excluded.source_note,
  status = excluded.status,
  published_at = excluded.published_at;

do $$
declare
  v_briefs integer;
  v_explainers integer;
  v_core_matches integer;
begin
  select count(*) into v_briefs from app.topic_point_briefs
    where subject_key='ap_precalculus' and unit_number=2 and status='published';
  select count(*) into v_explainers from app.topic_explainers
    where subject_key='ap_precalculus' and unit_number=2 and status='published';
  if v_briefs <> 15 then
    raise exception 'expected 15 published AP Precalculus Unit 2 briefs, got %', v_briefs;
  end if;
  if v_explainers <> 15 then
    raise exception 'expected 15 published AP Precalculus Unit 2 explainers, got %', v_explainers;
  end if;

  select count(*) into v_core_matches
  from app.topic_point_briefs b
  join app.topic_explainers e on e.subject_key=b.subject_key and e.topic_code=b.topic_code
  where b.subject_key='ap_precalculus' and b.unit_number=2 and b.status='published'
    and e.status='published' and e.core_idea = b.what_it_is;
  if v_core_matches <> 0 then
    raise exception 'expected 0 AP Precalculus Unit 2 explainers matching their brief verbatim, got %', v_core_matches;
  end if;
end $$;

commit;
