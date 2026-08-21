begin;

-- Seed AP Statistics Unit 5 (Regression Analysis) topic point briefs and
-- Learn More explainers -- first coverage for this unit (0/5 published
-- before this migration). This closes out full topic-guide coverage for
-- AP Statistics (55/55 topics after this migration).
--
-- Grounded in docs/product/AP_STATISTICS_2027_CED_FACT_PACK.md Sec3 (topic
-- map) and Sec10 (Unit 5 deep-tier detail). Sec10 explicitly flags Unit 5 as
-- the thinnest unit for misconception data -- no CR Report or released FRQ
-- regression question was available in that pass -- so this batch grounds
-- in the CED's own EK/formula-sheet facts (r and slope/intercept are
-- technology-only per the CED, never a hand formula; the residual
-- sign/under-over-predict convention the fact pack calls out as easily
-- flipped; interpolation vs extrapolation; and EK 5.5.B.3's explicit
-- do-not-interpret-the-intercept pattern) rather than a documented exam
-- misconception, unlike the Unit 4 batches authored earlier the same day.
--
-- This is a pure insert -- no existing rows are touched, so rollback is
-- simply deleting these 5 (subject_key='ap_statistics', unit_number=5) rows
-- or setting their status back to 'draft'.
--
-- Every explainer is genuinely topic-specific (not generated-from-brief):
-- core_idea differs from the paired brief's what_it_is on every row, and no
-- mini_example_question / weak_answer / point_attaining_answer /
-- practice_bridge value repeats across the batch (verified programmatically
-- before migration).

with brief_seed (
  topic_code, title, class_importance, exam_importance, what_it_is,
  why_it_matters, how_points_are_earned, answer_move, common_point_loss,
  learn_more_path
) as (
  values
  ('5.1','Graphical Representations Between Two Quantitative Variables','somewhat-important','somewhat-important',
   'A scatterplot displays the relationship between an explanatory variable (x-axis) and a response variable (y-axis) for two quantitative variables measured on the same individuals.',
   'Correctly describing a scatterplot''s form, direction, strength, and unusual features is the entry point for every regression topic that follows in this unit.',
   'You earn points by naming all four description components together -- form, direction, strength, and unusual features -- not just one or two of them.',
   'Describe scatterplots in a fixed order: form (linear or non-linear), direction (positive or negative), strength (strong, moderate, or weak), then any unusual features such as clusters or outliers.',
   'Describing only strength or only direction without also naming form and checking for unusual features.',
   '/learn/ap-statistics/unit-5/scatterplots-for-two-quantitative-variables'),
  ('5.2','Correlation','very-important','very-important',
   'The correlation coefficient r measures the direction and strength of a linear relationship between two quantitative variables; r is unit-free and always between -1 and 1.',
   'r is the standard numeric summary of linear association, and it anchors two of the course''s most heavily tested reasoning traps: correlation is not causation, and a large |r| does not by itself confirm a linear model fits.',
   'You earn points by correctly interpreting r''s sign as direction and magnitude as strength, by treating r as technology-computed rather than hand-calculated, and by not treating a large |r| as proof the linear model fits without a residual-plot check.',
   'Interpret sign as direction and magnitude as strength, cite r as coming from technology, and state that even a strong r still requires a residual-plot check before concluding a linear model is the right one.',
   'Concluding causation from a strong correlation, or treating an r value close to 1 as sufficient evidence of a linear fit without checking a residual plot.',
   '/learn/ap-statistics/unit-5/correlation-coefficient-r'),
  ('5.3','Linear Regression Models','very-important','somewhat-important',
   'The linear regression equation y-hat = a + bx predicts a response value from an explanatory value, where a is the y-intercept and b is the slope.',
   'Whether a prediction from this equation is trustworthy depends on where the requested x-value falls relative to the data used to build the model, which is a separate judgment from computing y-hat itself.',
   'You earn points by stating whether a requested prediction is interpolation (inside the original data''s x-range, more reliable) or extrapolation (outside that range, less reliable), not just by computing y-hat.',
   'Locate the requested x-value against the original data''s range before trusting any prediction: inside the range is interpolation, outside the range is extrapolation and less reliable the further outside it falls.',
   'Treating any x-value as valid to plug into y-hat = a + bx without checking whether it falls inside or outside the original data''s range.',
   '/learn/ap-statistics/unit-5/linear-regression-models-and-extrapolation'),
  ('5.4','Residuals','very-important','very-important',
   'A residual equals the observed value minus the predicted value; a residual plot graphs residuals against predicted or explanatory values to check whether a linear model fits.',
   'A residual''s sign is easy to flip when interpreting it, and a residual plot''s shape -- not its r value -- is the real evidence for whether a straight-line model is appropriate.',
   'You earn points by computing residual as observed minus predicted (not the reverse), correctly labeling a positive residual as underpredicting and a negative residual as overpredicting, and reading curvature in a residual plot as evidence the linear model does not fit.',
   'Compute residual as observed minus predicted; a positive residual means the model underpredicted (actual was higher), a negative residual means the model overpredicted (actual was lower); patternless scatter in a residual plot supports the linear model, curvature argues against it.',
   'Correctly computing a residual''s numeric value but then mislabeling a negative residual as underpredicting or a positive residual as overpredicting.',
   '/learn/ap-statistics/unit-5/residuals-and-residual-plots'),
  ('5.5','Least-Squares Regression','very-important','very-important',
   'The least-squares regression line is the one line that minimizes the sum of squared residuals across all data points, and always passes through the point (x-bar, y-bar).',
   'Slope, intercept, and r-squared each have a specific interpretation that must be stated in context, and the y-intercept sometimes has no real-world meaning at all.',
   'You earn points by interpreting slope in context as a predicted change in y per one-unit increase in x, interpreting r-squared as the proportion of variation in y explained by the linear relationship with x, and recognizing when the y-intercept should not be interpreted.',
   'State the slope as a predicted increase or decrease in y for a one-unit increase in x, state r-squared as the proportion of variation in the response explained by the model, and check whether x = 0 is inside the data''s range and gives a realistic y-value before interpreting the intercept.',
   'Interpreting the y-intercept automatically without checking whether x = 0 falls inside the data''s range or produces a realistic value.',
   '/learn/ap-statistics/unit-5/least-squares-regression-and-r-squared')
)
insert into app.topic_point_briefs (
  subject_key, unit_number, topic_code, title, class_importance, exam_importance,
  what_it_is, why_it_matters, how_points_are_earned, answer_move,
  common_point_loss, learn_more_path, practice_subject_key, practice_unit_number,
  practice_topic_code, source_note, status, published_at
)
select
  'ap_statistics', 5, topic_code, title, class_importance, exam_importance,
  what_it_is, why_it_matters, how_points_are_earned, answer_move,
  common_point_loss, learn_more_path, 'ap_statistics', 5, topic_code,
  'cramapple-authored; grounded in AP_STATISTICS_2027_CED_FACT_PACK.md Sec3 topic map + Sec10 Unit 5 deep-tier detail (both sections UNREVIEWED pending Jill/Orly SME sign-off, per the fact pack''s own Sec9 note). Unit 5 misconception grounding is explicitly the thinnest of the five units per the fact pack (no CR-report or released-FRQ regression question was available in that pass); content here is grounded in the CED''s own EK/formula-sheet facts (technology-only r and slope/intercept, residual sign convention, interpolation/extrapolation, EK 5.5.B.3''s do-not-interpret-intercept pattern), not in a documented exam misconception. batch 2026-08-21-ap-statistics-unit5; author=reviewer same session, no independent human review yet', 'published', now()
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
  ('5.1','Graphical Representations Between Two Quantitative Variables',
   'A scatterplot''s four-part description -- form, direction, strength, unusual features -- is a fixed checklist, not a menu; a response naming only one or two of the four leaves points unclaimed even when the description given is accurate.',
   'Strong and weak describe how tightly points cluster around a pattern, not how many points there are or how large the values are -- strength is about scatter around the pattern, not sample size or magnitude.',
   'Full credit requires all four components named in a single description: form, direction, strength, and any unusual features, each addressed explicitly rather than implied.',
   'Write four short phrases -- form, direction, strength, unusual features -- and fill in each one before combining them into a single description sentence.',
   'A scatterplot of study hours (x) versus test score (y) shows points tightly clustered along an upward line, with one point far above the pattern. Describe the relationship.',
   'There''s a strong positive relationship.',
   'The relationship is linear, positive, and strong, with one unusual point -- a student scoring far higher than the pattern would predict for that number of study hours.',
   'Describing only strength or only direction without also naming form and checking for unusual features.',
   'Before describing any scatterplot, write four short phrases -- form, direction, strength, unusual features -- and fill in each one before combining them into a sentence.'),
  ('5.2','Correlation',
   'r is unit-free precisely so it can compare relationships measured in completely different units, but a large |r| only measures how closely points follow a straight line -- it never proves that line is the right model, and it never proves one variable causes the other.',
   'This course does not expect you to compute r by hand from raw data; the CED states r is calculated using technology, so a response should cite and interpret the technology-reported value rather than attempt a hand formula.',
   'Full credit for an r-interpretation question requires correct sign-as-direction and magnitude-as-strength language, sourced from technology, plus recognizing that r alone -- even close to 1 or -1 -- does not confirm linearity without a residual-plot check.',
   'State the sign as direction and the magnitude as strength, note the value came from technology, then explicitly separate the causation question from the linearity question rather than answering either from r alone.',
   'A study reports r = 0.91 between ice cream sales and drowning incidents across many cities. A student concludes that ice cream causes drowning. Evaluate this conclusion.',
   'The conclusion is correct, since r = 0.91 is a very strong correlation.',
   'The conclusion is not supported; a strong correlation only shows a strong linear association, not that one variable causes the other -- a third variable, such as hot weather driving both ice cream sales and swimming, likely explains the pattern.',
   'Concluding causation from a strong correlation, or treating an r value close to 1 as sufficient evidence of a linear fit without checking a residual plot.',
   'Whenever a correlation value is given, ask two separate questions before concluding anything: does this prove causation (no), and does this alone prove a linear model fits (no, check a residual plot).'),
  ('5.3','Linear Regression Models',
   'The regression equation only reliably predicts within the range of x-values actually used to build it -- predicting outside that range is a substantively different, less trustworthy activity than predicting inside it, even though the arithmetic looks identical either way.',
   'Whether a prediction is interpolation or extrapolation depends entirely on where the requested x-value sits relative to the data''s x-range, not on the model''s r or r-squared value -- a great-fitting model can still make an unreliable extrapolated prediction.',
   'Full credit for evaluating a prediction requires stating whether the requested x-value is inside or outside the original data''s range and naming interpolation or extrapolation accordingly, not just computing y-hat.',
   'Before computing or trusting y-hat, locate the requested x-value against the original data''s range and name the prediction as interpolation or extrapolation.',
   'A regression model is built from data with x-values (advertising spend) ranging from $10,000 to $50,000. A manager uses the model to predict sales at an advertising spend of $200,000. Evaluate this prediction.',
   'The prediction is valid since we can plug $200,000 into the equation.',
   'The prediction is an extrapolation, since $200,000 falls far outside the $10,000 to $50,000 range used to build the model, so the prediction is unreliable regardless of how well the model fits the original data.',
   'Treating any x-value as valid to plug into y-hat = a + bx without checking whether it falls inside or outside the original data''s range.',
   'Before trusting any regression prediction, locate the requested x-value against the original data''s range first -- inside is interpolation, outside is extrapolation.'),
  ('5.4','Residuals',
   'The sign of a residual is easy to flip in your head -- a positive residual means the actual value came in higher than predicted, so the model underpredicted, not that the model was somehow more correct or more positive.',
   'A residual plot showing patternless scatter around zero supports the linear model; a residual plot showing clear curvature is direct evidence the straight-line model is the wrong shape for this data, regardless of how large r is.',
   'Full credit requires computing residual as observed minus predicted (never predicted minus observed) and correctly reading a residual plot''s shape as the deciding evidence for whether a linear model is appropriate.',
   'Compute observed minus predicted first, then say the underpredicted-or-overpredicted conclusion out loud from that sign before writing it down, since this is exactly where the label gets flipped.',
   'A model predicts a house will sell for $310,000; it actually sells for $295,000. Find the residual and state what it means about the prediction.',
   'The residual is -15,000, so the model underpredicted the house''s value.',
   'The residual is 295,000 minus 310,000, which equals -15,000; a negative residual means the actual sale price came in below the predicted price, so the model overpredicted this house''s value.',
   'Correctly computing a residual''s numeric value but then mislabeling a negative residual as underpredicting or a positive residual as overpredicting.',
   'After computing any residual''s sign, say the underpredicted-or-overpredicted conclusion out loud before writing it down -- this is the exact spot the sign gets flipped.'),
  ('5.5','Least-Squares Regression',
   'The least-squares line is defined as the one specific line that minimizes the sum of squared residuals across every data point -- and unlike the slope, the y-intercept sometimes should not be interpreted at all, when x = 0 is far outside the data or a negative predicted y has no real meaning.',
   'r-squared is the proportion of the variation in the response variable explained by the linear relationship with the explanatory variable -- not the correlation coefficient itself, and not the proportion of individual points that fit exactly.',
   'Full credit requires slope interpreted in context using predicted-increase-or-decrease-in-y-for-a-one-unit-increase-in-x language, r-squared interpreted as proportion of variation explained, and explicit recognition of when the y-intercept has no real-world meaning rather than interpreting it automatically.',
   'Check whether x = 0 falls inside the data''s range and produces a realistic y-value before interpreting any y-intercept; if either check fails, state explicitly that it should not be interpreted.',
   'A least-squares regression predicts adult height from age in months for ages 24 to 60 months, with y-intercept a = 45 cm. Should this y-intercept be interpreted in context?',
   'Yes, a 45 cm intercept means a newborn at age 0 is predicted to be 45 cm tall.',
   'No, the y-intercept should not be interpreted here, because age = 0 is far outside the 24 to 60 month range the model was built from -- interpreting it would be extrapolation far beyond the data.',
   'Interpreting the y-intercept automatically without checking whether x = 0 falls inside the data''s range or produces a realistic value.',
   'Before interpreting any y-intercept, check whether x = 0 is inside the original data''s range and whether the resulting y-value is realistic -- if either check fails, say explicitly that the intercept should not be interpreted.')
)
insert into app.topic_explainers (
  subject_key, unit_number, topic_code, title, core_idea,
  what_students_need_to_understand, how_this_becomes_points, answer_move,
  mini_example_question, weak_answer, point_attaining_answer,
  common_point_loss, practice_bridge, source_note, status, published_at
)
select
  'ap_statistics', 5, topic_code, title, core_idea,
  what_students_need_to_understand, how_this_becomes_points, answer_move,
  mini_example_question, weak_answer, point_attaining_answer,
  common_point_loss, practice_bridge,
  'cramapple-authored; grounded in AP_STATISTICS_2027_CED_FACT_PACK.md Sec3 topic map + Sec10 Unit 5 deep-tier detail (both sections UNREVIEWED pending Jill/Orly SME sign-off, per the fact pack''s own Sec9 note). Unit 5 misconception grounding is explicitly the thinnest of the five units per the fact pack (no CR-report or released-FRQ regression question was available in that pass); content here is grounded in the CED''s own EK/formula-sheet facts (technology-only r and slope/intercept, residual sign convention, interpolation/extrapolation, EK 5.5.B.3''s do-not-interpret-intercept pattern), not in a documented exam misconception. batch 2026-08-21-ap-statistics-unit5; author=reviewer same session, no independent human review yet', 'published', now()
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
begin
  select count(*) into v_briefs from app.topic_point_briefs
    where subject_key='ap_statistics' and unit_number=5 and status='published';
  select count(*) into v_explainers from app.topic_explainers
    where subject_key='ap_statistics' and unit_number=5 and status='published';
  if v_briefs <> 5 then
    raise exception 'expected 5 published AP Statistics Unit 5 briefs, got %', v_briefs;
  end if;
  if v_explainers <> 5 then
    raise exception 'expected 5 published AP Statistics Unit 5 explainers, got %', v_explainers;
  end if;
end $$;

commit;
