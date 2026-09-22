begin;

-- Add AP Precalculus Unit 4 topic-guide pairs.
--
-- Unit 4 is course content but is not assessed on the AP Exam. These rows are
-- published so students can experience topic cards and Learn More content for
-- the complete course taxonomy, while exam_importance is intentionally
-- 'not-important' and the content avoids presenting Unit 4 as scored AP exam
-- practice.
--
-- Grounding: docs/product/AP_PRECALCULUS_CED_FACT_PACK.md course-and-exam
-- scope plus 20260821280000_ap_precalculus_unit4_taxonomy_topics_seed.sql,
-- which verified the 14 Unit 4 topic titles against the primary CED PDF.

with brief_seed (
  topic_code, title, class_importance, exam_importance, what_it_is,
  why_it_matters, how_points_are_earned, answer_move, common_point_loss,
  learn_more_path
) as (
  values
  ('4.1', 'Parametric Functions', 'very-important', 'not-important',
   'Parametric functions describe a curve by giving x and y separately as functions of a parameter, often time.',
   'This representation lets students track motion or paths that are awkward to describe with a single y=f(x) rule. Unit 4 is course content but not AP Exam assessed.',
   'You earn class and practice credit by evaluating both component functions at the same parameter value and interpreting the ordered pair as a point on the path.',
   'Use the parameter as the shared input for both x(t) and y(t), then report the resulting ordered pair or path behavior.',
   'Treating the parameter as if it were x itself instead of a shared input for both coordinates.',
   '/learn/ap-precalculus/unit-4/parametric-functions'),
  ('4.2', 'Parametric Functions Modeling Planar Motion', 'very-important', 'not-important',
   'Parametric motion models use x(t) and y(t) to describe horizontal and vertical position in a plane as time changes.',
   'Separate component functions make motion contexts easier to model because horizontal and vertical behavior can follow different rules. This is class content, not AP Exam-assessed content.',
   'You earn class and practice credit by connecting each component to its contextual unit and by interpreting position, direction, and time from the pair of functions.',
   'Identify what t measures, evaluate both coordinates at the same time, then interpret the point and motion in context.',
   'Mixing coordinates from different time values or ignoring the units attached to each component.',
   '/learn/ap-precalculus/unit-4/parametric-functions-modeling-planar-motion'),
  ('4.3', 'Parametric Functions and Rates of Change', 'somewhat-important', 'not-important',
   'Parametric rates of change compare how one quantity changes with respect to the parameter or how y changes relative to x over a parameter interval.',
   'The course treats these as average rates over intervals, not calculus derivatives. That keeps the reasoning inside Precalculus while still connecting motion and curve behavior.',
   'You earn class and practice credit by computing change in a component over change in parameter, or change in y over change in x, using the correct interval endpoints.',
   'Choose the two parameter values first; then compute the relevant difference quotient from x(t) and y(t).',
   'Using instantaneous derivative language or dividing by the wrong change quantity.',
   '/learn/ap-precalculus/unit-4/parametric-functions-and-rates-of-change'),
  ('4.4', 'Parametrically Defined Circles and Lines', 'somewhat-important', 'not-important',
   'Circles and lines can be represented parametrically by formulas that generate their x- and y-coordinates from a shared parameter.',
   'Parametric forms show direction, starting point, and speed along a familiar shape, not just the set of points in the shape.',
   'You earn class and practice credit by recognizing standard parameterizations, connecting them to center, radius, or direction, and checking how the parameter traces the curve.',
   'Match the component formulas to the shape, then use parameter values to confirm starting point and direction.',
   'Recognizing the geometric shape but ignoring how the parameter traces it.',
   '/learn/ap-precalculus/unit-4/parametrically-defined-circles-and-lines'),
  ('4.5', 'Implicitly Defined Functions', 'somewhat-important', 'not-important',
   'An implicitly defined relation gives x and y in one equation rather than solving explicitly for y as a function of x.',
   'Implicit forms are useful for curves such as circles or conics where solving for y can split the relation into multiple branches.',
   'You earn class and practice credit by identifying whether the relation defines y explicitly, implicitly, or not as a function over the full relation.',
   'Test whether a single x can lead to more than one y before claiming the relation is a function.',
   'Assuming every equation involving x and y can be treated as one explicit function y=f(x).',
   '/learn/ap-precalculus/unit-4/implicitly-defined-functions'),
  ('4.6', 'Conic Sections', 'somewhat-important', 'not-important',
   'Conic sections include circles, ellipses, parabolas, and hyperbolas, each with equation features that determine its graph.',
   'Recognizing conic structure helps students connect algebraic form to geometric features such as center, radius, axes, vertices, or asymptotes.',
   'You earn class and practice credit by identifying the conic type from its equation form and extracting the graph features that the question asks for.',
   'Rewrite the equation into a recognizable standard form before naming or graphing the conic.',
   'Naming a conic from one term without checking the full squared-variable structure.',
   '/learn/ap-precalculus/unit-4/conic-sections'),
  ('4.7', 'Parametrization of Implicitly Defined Functions', 'somewhat-important', 'not-important',
   'Parametrization rewrites an implicit relation as component functions x(t) and y(t) that trace the same curve.',
   'This links implicit and parametric representations, helping students choose whichever form makes a curve easier to evaluate, graph, or model.',
   'You earn class and practice credit by showing that the proposed x(t), y(t) satisfy the implicit equation and by stating any parameter restrictions.',
   'Substitute the parametric components into the implicit equation to verify that the curve is traced.',
   'Giving parametric formulas without checking that they actually satisfy the original relation.',
   '/learn/ap-precalculus/unit-4/parametrization-of-implicitly-defined-functions'),
  ('4.8', 'Vectors', 'very-important', 'not-important',
   'A vector has magnitude and direction, and can be represented by components that describe horizontal and vertical change.',
   'Vectors organize displacement, velocity, and forces in a way that keeps direction attached to size.',
   'You earn class and practice credit by computing components, magnitude, or direction correctly and interpreting the vector in context.',
   'Draw or list the components first; then use them to find magnitude, direction, or resultant vector.',
   'Treating a vector like a single unsigned length and losing its direction.',
   '/learn/ap-precalculus/unit-4/vectors'),
  ('4.9', 'Vector-Valued Functions', 'somewhat-important', 'not-important',
   'A vector-valued function outputs a vector, often giving position or motion as a function of a parameter.',
   'This combines functions and vectors so students can describe changing position, displacement, or direction over time.',
   'You earn class and practice credit by evaluating each component at the same input and interpreting the output vector or position in context.',
   'Evaluate all component functions at the same parameter value, then interpret the resulting vector with its direction and units.',
   'Evaluating components at different inputs or interpreting a vector output as only a scalar.',
   '/learn/ap-precalculus/unit-4/vector-valued-functions'),
  ('4.10', 'Matrices', 'very-important', 'not-important',
   'A matrix is a rectangular array of numbers that can represent data, coefficients, transformations, or systems.',
   'Matrices give students a compact way to organize multiple related quantities and perform operations on them systematically.',
   'You earn class and practice credit by identifying matrix dimensions, matching entries to their meaning, and carrying out valid matrix operations only when dimensions allow.',
   'Check the dimensions first; then decide whether the requested operation is defined.',
   'Trying to add or multiply matrices without checking compatible dimensions.',
   '/learn/ap-precalculus/unit-4/matrices'),
  ('4.11', 'The Inverse and Determinant of a Matrix', 'somewhat-important', 'not-important',
   'For a square matrix, the determinant helps decide whether an inverse exists; a nonzero determinant means the matrix is invertible.',
   'This connects algebraic matrix operations to whether a transformation or system can be reversed.',
   'You earn class and practice credit by computing a determinant, using it to decide invertibility, and applying the inverse only when it exists.',
   'Compute the determinant first for a square matrix; if it is nonzero, proceed with the inverse.',
   'Trying to invert a matrix with determinant zero or applying inverse rules to a non-square matrix.',
   '/learn/ap-precalculus/unit-4/inverse-and-determinant-of-a-matrix'),
  ('4.12', 'Linear Transformations and Matrices', 'somewhat-important', 'not-important',
   'A matrix can represent a linear transformation that maps input vectors to output vectors.',
   'This lets students connect algebraic multiplication to geometric effects such as scaling, reflection, rotation, shear, or projection.',
   'You earn class and practice credit by multiplying the matrix by an input vector and interpreting the output as the transformed vector.',
   'Apply the matrix to a simple input vector first, then describe the geometric effect from the outputs.',
   'Describing a transformation from matrix entries alone without testing what it does to vectors.',
   '/learn/ap-precalculus/unit-4/linear-transformations-and-matrices'),
  ('4.13', 'Matrices as Functions', 'somewhat-important', 'not-important',
   'A matrix can act like a function by taking an input vector and producing an output vector through matrix multiplication.',
   'Thinking of matrices as functions helps students compare domain, range, composition, and inverse ideas across algebraic and geometric settings.',
   'You earn class and practice credit by treating the input and output as vectors, applying multiplication in the correct order, and interpreting the mapping.',
   'Write the input vector with compatible dimensions and multiply in the order matrix times vector.',
   'Reversing multiplication order or expecting a scalar output from a vector input.',
   '/learn/ap-precalculus/unit-4/matrices-as-functions'),
  ('4.14', 'Matrices Modeling Contexts', 'somewhat-important', 'not-important',
   'Matrices can model contexts with many related quantities, such as transitions, weighted combinations, systems, or transformations.',
   'Context modeling asks students to assign meaning to rows, columns, entries, and outputs, not just perform arithmetic.',
   'You earn class and practice credit by defining what the matrix entries represent, using valid operations, and interpreting the resulting numbers in the original context.',
   'Label rows, columns, and units before multiplying or interpreting a matrix model.',
   'Computing a matrix product correctly but failing to say what the entries mean in context.',
   '/learn/ap-precalculus/unit-4/matrices-modeling-contexts')
)
insert into app.topic_point_briefs (
  subject_key, unit_number, topic_code, title, class_importance, exam_importance,
  what_it_is, why_it_matters, how_points_are_earned, answer_move,
  common_point_loss, learn_more_path, practice_subject_key, practice_unit_number,
  practice_topic_code, source_note, status, published_at
)
select
  'ap_precalculus', 4, topic_code, title, class_importance, exam_importance,
  what_it_is, why_it_matters, how_points_are_earned, answer_move,
  common_point_loss, learn_more_path, 'ap_precalculus', 4, topic_code,
  'cramapple-authored; new coverage 2026-08-26 for AP Precalculus Unit 4 Functions Involving Parameters, Vectors, and Matrices; grounded in AP_PRECALCULUS_CED_FACT_PACK.md course-and-exam scope plus the primary-source-verified Unit 4 taxonomy seed: Unit 4 is course content but not AP Exam assessed, so these guides support class learning and in-app practice without presenting Unit 4 as scored AP exam content; batch 2026-08-26-ap-precalculus-unit4-topic-guides; author=reviewer same session, no independent human review yet',
  'published', now()
from brief_seed
on conflict (subject_key, topic_code) do update
set
  unit_number = excluded.unit_number,
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
  published_at = coalesce(app.topic_point_briefs.published_at, excluded.published_at);

with explainer_seed (
  topic_code, title, core_idea, what_students_need_to_understand,
  how_this_becomes_points, answer_move, mini_example_question, weak_answer,
  point_attaining_answer, common_point_loss, practice_bridge
) as (
  values
  ('4.1', 'Parametric Functions',
   'A parametric curve is built from two coordinated outputs, x(t) and y(t), produced from the same parameter value.',
   'Students need to understand that the parameter orders the motion along the curve. The same geometric curve can be traced in different directions or speeds depending on how x and y depend on the parameter.',
   'Points come from evaluating both components consistently, describing direction as the parameter increases, and not forcing every curve into y=f(x) form.',
   'Use the parameter as the shared input for both x(t) and y(t), then report the resulting ordered pair or path behavior.',
   'If x(t)=t+1 and y(t)=t^2, what point corresponds to t=3?',
   'Use x=3, so the point is (3,9).',
   'Substitute t=3 into both components: x=4 and y=9, so the point is (4,9). The parameter is not automatically the x-coordinate.',
   'Treating the parameter as if it were x itself instead of a shared input for both coordinates.',
   'Treating the parameter as if it were x itself instead of a shared input for both coordinates.'),
  ('4.2', 'Parametric Functions Modeling Planar Motion',
   'Planar motion is naturally parametric because a moving object has two coordinates that change together over time.',
   'Students need to keep time as the organizing variable. A model can show where an object is, when it reaches a location, and how its horizontal and vertical positions change together.',
   'Points come from using a shared time input, attaching units, and explaining what the coordinate pair means in the situation.',
   'Identify what t measures, evaluate both coordinates at the same time, then interpret the point and motion in context.',
   'A drone has x(t) in meters east and y(t) in meters north. What does (x(5),y(5)) represent?',
   'It gives the drone speed at 5 seconds.',
   'It gives the drone position 5 seconds after the start, with x(5) meters east and y(5) meters north of the reference point.',
   'Mixing coordinates from different time values or ignoring the units attached to each component.',
   'Mixing coordinates from different time values or ignoring the units attached to each component.'),
  ('4.3', 'Parametric Functions and Rates of Change',
   'A parametric average rate depends on what is being compared: x versus t, y versus t, or y versus x.',
   'Students need to read the requested rate carefully. Average horizontal velocity uses change in x over change in t; average vertical velocity uses change in y over change in t; average slope along the path uses change in y over change in x.',
   'Points come from selecting the correct numerator and denominator and keeping the interval consistent across both components.',
   'Choose the two parameter values first; then compute the relevant difference quotient from x(t) and y(t).',
   'For t from 1 to 4, how would you find average change of y with respect to x?',
   'Compute (y(4)-y(1))/(4-1).',
   'Compute (y(4)-y(1))/(x(4)-x(1)), because the question asks for change in y relative to change in x, not change in y per unit time.',
   'Using instantaneous derivative language or dividing by the wrong change quantity.',
   'Using instantaneous derivative language or dividing by the wrong change quantity.'),
  ('4.4', 'Parametrically Defined Circles and Lines',
   'A parametric equation can describe both the shape and the traversal of a circle or line.',
   'Students need to separate the graph as a set of points from the way the parameter moves along it. For example, cosine and sine components can trace a circle, while linear components can trace a line.',
   'Points come from identifying the shape, center or direction vector when present, and the parameter interval or orientation.',
   'Match the component formulas to the shape, then use parameter values to confirm starting point and direction.',
   'What shape is suggested by x=2+3cos(t), y=-1+3sin(t)?',
   'A line because x and y both change with t.',
   'A circle centered at (2,-1) with radius 3, because the cosine and sine components share the same radius around a fixed center.',
   'Recognizing the geometric shape but ignoring how the parameter traces it.',
   'Recognizing the geometric shape but ignoring how the parameter traces it.'),
  ('4.5', 'Implicitly Defined Functions',
   'Implicit equations describe relationships between x and y without necessarily making y a single-valued output.',
   'Students need to know that a relation can be meaningful even when it is not a function over its whole domain. Some implicit relations become functions only after restricting to a branch.',
   'Points come from interpreting the relation accurately and recognizing when a domain or branch restriction is needed.',
   'Test whether a single x can lead to more than one y before claiming the relation is a function.',
   'Does x^2+y^2=25 define y as a single function of x over the whole circle?',
   'Yes, because y can be solved from the equation.',
   'No. Most x-values inside the circle correspond to two y-values, one above and one below the x-axis, so the whole circle is not one function y=f(x).',
   'Assuming every equation involving x and y can be treated as one explicit function y=f(x).',
   'Assuming every equation involving x and y can be treated as one explicit function y=f(x).'),
  ('4.6', 'Conic Sections',
   'Conic equations encode graph features through squared terms, signs, coefficients, and translations.',
   'Students need to complete squares or rearrange terms when necessary so the conic type and features are visible. The same visual family can look hidden until the equation is organized.',
   'Points come from standard-form rewriting, correct conic identification, and feature extraction rather than a label alone.',
   'Rewrite the equation into a recognizable standard form before naming or graphing the conic.',
   'What does x^2/9 + y^2/4 = 1 represent?',
   'A circle because both variables are squared.',
   'It is an ellipse centered at the origin, because the squared terms have different denominators and are added to equal 1.',
   'Naming a conic from one term without checking the full squared-variable structure.',
   'Naming a conic from one term without checking the full squared-variable structure.'),
  ('4.7', 'Parametrization of Implicitly Defined Functions',
   'A valid parametrization must generate points that satisfy the original implicit equation.',
   'Students need to verify parametrizations algebraically. For circles, sine and cosine are natural because sin^2(t)+cos^2(t)=1; for lines, a starting point plus a direction vector is natural.',
   'Points come from substitution checks and attention to whether the parameter interval traces the full curve or only part of it.',
   'Substitute the parametric components into the implicit equation to verify that the curve is traced.',
   'How can you check whether x=3cos(t), y=3sin(t) parametrizes x^2+y^2=9?',
   'It looks circular, so it works.',
   'Substitute: (3cos t)^2+(3sin t)^2=9(cos^2 t+sin^2 t)=9, so every generated point satisfies the circle equation.',
   'Giving parametric formulas without checking that they actually satisfy the original relation.',
   'Giving parametric formulas without checking that they actually satisfy the original relation.'),
  ('4.8', 'Vectors',
   'A vector is not just how far; it is how far in what direction.',
   'Students need to move between component form, graphical arrows, and contextual meaning. Adding vectors means combining corresponding components, not just adding magnitudes unless directions match.',
   'Points come from preserving direction, using components consistently, and attaching units when the vector models a context.',
   'Draw or list the components first; then use them to find magnitude, direction, or resultant vector.',
   'If a displacement vector is <3,-4>, what is its magnitude?',
   'The magnitude is -1 because 3 plus -4 is -1.',
   'The magnitude is sqrt(3^2+(-4)^2)=5. Magnitude is length, while the signs belong to the direction of the components.',
   'Treating a vector like a single unsigned length and losing its direction.',
   'Treating a vector like a single unsigned length and losing its direction.'),
  ('4.9', 'Vector-Valued Functions',
   'A vector-valued function packages component functions into one vector output.',
   'Students need to understand that the output may represent position, velocity, or another vector quantity depending on the context. The components must stay synchronized by the same input.',
   'Points come from component evaluation, vector notation, and contextual interpretation.',
   'Evaluate all component functions at the same parameter value, then interpret the resulting vector with its direction and units.',
   'For r(t)=<t^2,2t>, what is r(3)?',
   'It is 3 because t is 3.',
   'Evaluate both components: r(3)=<9,6>. The output is a vector, not a single scalar.',
   'Evaluating components at different inputs or interpreting a vector output as only a scalar.',
   'Evaluating components at different inputs or interpreting a vector output as only a scalar.'),
  ('4.10', 'Matrices',
   'Matrix operations depend on shape as much as on the entries.',
   'Students need to read dimensions as rows by columns and use them to decide whether addition, scalar multiplication, or matrix multiplication is valid. A correct-looking arithmetic answer is invalid if the operation is not defined.',
   'Points come from dimension checks, correct entry arithmetic, and clear interpretation of rows and columns.',
   'Check the dimensions first; then decide whether the requested operation is defined.',
   'Can a 2 by 3 matrix be added to a 3 by 2 matrix?',
   'Yes, because both contain six numbers.',
   'No. Matrix addition requires the same dimensions, and 2 by 3 is not the same shape as 3 by 2.',
   'Trying to add or multiply matrices without checking compatible dimensions.',
   'Trying to add or multiply matrices without checking compatible dimensions.'),
  ('4.11', 'The Inverse and Determinant of a Matrix',
   'Matrix inverses are reversal tools, and determinants tell whether that reversal is possible for square matrices.',
   'Students need to know that determinant zero means information collapses in a way that cannot be undone by an inverse. Non-square matrices are outside the ordinary square-matrix inverse rule.',
   'Points come from checking squareness, computing determinant accurately, and interpreting determinant zero correctly.',
   'Compute the determinant first for a square matrix; if it is nonzero, proceed with the inverse.',
   'A 2 by 2 matrix has determinant 0. Does it have an inverse?',
   'Yes, every matrix has an inverse if the entries are nonzero.',
   'No. A square matrix with determinant 0 is not invertible, so inverse-based solving or reversal is not valid.',
   'Trying to invert a matrix with determinant zero or applying inverse rules to a non-square matrix.',
   'Trying to invert a matrix with determinant zero or applying inverse rules to a non-square matrix.'),
  ('4.12', 'Linear Transformations and Matrices',
   'A linear transformation is understood by what it does to vectors, and a matrix is a compact rule for that action.',
   'Students need to connect columns or test vectors to geometric behavior. The image of basis vectors often reveals how the whole plane is transformed.',
   'Points come from correct matrix-vector multiplication and a grounded description of the resulting geometric effect.',
   'Apply the matrix to a simple input vector first, then describe the geometric effect from the outputs.',
   'If a matrix sends <1,0> to <2,0> and <0,1> to <0,3>, what basic effect does it have?',
   'It translates every point right and up.',
   'It scales horizontal components by 2 and vertical components by 3. Linear transformations represented by matrices do not add a fixed translation vector.',
   'Describing a transformation from matrix entries alone without testing what it does to vectors.',
   'Describing a transformation from matrix entries alone without testing what it does to vectors.'),
  ('4.13', 'Matrices as Functions',
   'A matrix function maps vectors to vectors when dimensions are compatible.',
   'Students need to view the matrix as a rule with a domain of allowable input vectors and a range of possible outputs. Composition of matrix functions depends on multiplication order.',
   'Points come from dimension compatibility, correct order, and input-output interpretation.',
   'Write the input vector with compatible dimensions and multiply in the order matrix times vector.',
   'If A is 2 by 3, what size input vector can A multiply on the right?',
   'A 2-entry vector, because A has 2 rows.',
   'A 3-entry column vector, because the inner dimensions must match in A times v. The output will have 2 entries.',
   'Reversing multiplication order or expecting a scalar output from a vector input.',
   'Reversing multiplication order or expecting a scalar output from a vector input.'),
  ('4.14', 'Matrices Modeling Contexts',
   'A matrix model is only useful when its entries and outputs are tied back to the situation being modeled.',
   'Students need to decide what each row, column, and vector entry means before doing operations. The same numeric matrix can mean different things in different contexts.',
   'Points come from a valid setup, compatible dimensions, correct calculation, and context-specific interpretation of the result.',
   'Label rows, columns, and units before multiplying or interpreting a matrix model.',
   'A transition matrix output is <40,60>. What should the answer include besides the numbers?',
   'Nothing; the vector is the final answer.',
   'It should state what 40 and 60 represent in the context, including categories and units or counts. Matrix results need interpretation, not just computation.',
   'Computing a matrix product correctly but failing to say what the entries mean in context.',
   'Computing a matrix product correctly but failing to say what the entries mean in context.')
)
insert into app.topic_explainers (
  subject_key, unit_number, topic_code, title, core_idea,
  what_students_need_to_understand, how_this_becomes_points, answer_move,
  mini_example_question, weak_answer, point_attaining_answer,
  common_point_loss, practice_bridge, status, source_note, published_at
)
select
  'ap_precalculus', 4, topic_code, title, core_idea,
  what_students_need_to_understand, how_this_becomes_points, answer_move,
  mini_example_question, weak_answer, point_attaining_answer,
  common_point_loss, practice_bridge, 'published',
  'cramapple-authored; new coverage 2026-08-26 for AP Precalculus Unit 4 Functions Involving Parameters, Vectors, and Matrices; grounded in AP_PRECALCULUS_CED_FACT_PACK.md course-and-exam scope plus the primary-source-verified Unit 4 taxonomy seed: Unit 4 is course content but not AP Exam assessed, so these guides support class learning and in-app practice without presenting Unit 4 as scored AP exam content; batch 2026-08-26-ap-precalculus-unit4-topic-guides; author=reviewer same session, no independent human review yet',
  now()
from explainer_seed
on conflict (subject_key, topic_code) do update
set
  unit_number = excluded.unit_number,
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
  status = excluded.status,
  source_note = excluded.source_note,
  published_at = coalesce(app.topic_explainers.published_at, excluded.published_at);

do $$
declare
  v_briefs integer;
  v_explainers integer;
  v_pairing_orphans integer;
  v_unit_mismatches integer;
  v_route_mismatches integer;
  v_core_matches integer;
  v_duplicate_explainer_fields integer;
begin
  select count(*) into v_briefs from app.topic_point_briefs where subject_key='ap_precalculus' and unit_number=4 and topic_code in ('4.1', '4.2', '4.3', '4.4', '4.5', '4.6', '4.7', '4.8', '4.9', '4.10', '4.11', '4.12', '4.13', '4.14') and status='published';
  if v_briefs <> 14 then raise exception 'expected 14 published AP Precalculus Unit 4 briefs, got %', v_briefs; end if;

  select count(*) into v_explainers from app.topic_explainers where subject_key='ap_precalculus' and unit_number=4 and topic_code in ('4.1', '4.2', '4.3', '4.4', '4.5', '4.6', '4.7', '4.8', '4.9', '4.10', '4.11', '4.12', '4.13', '4.14') and status='published';
  if v_explainers <> 14 then raise exception 'expected 14 published AP Precalculus Unit 4 explainers, got %', v_explainers; end if;

  select count(*) into v_pairing_orphans from (
    select b.subject_key,b.topic_code from app.topic_point_briefs b left join app.topic_explainers e on e.subject_key=b.subject_key and e.topic_code=b.topic_code and e.status='published' where b.subject_key='ap_precalculus' and b.unit_number=4 and b.topic_code in ('4.1', '4.2', '4.3', '4.4', '4.5', '4.6', '4.7', '4.8', '4.9', '4.10', '4.11', '4.12', '4.13', '4.14') and b.status='published' and e.topic_code is null
    union all
    select e.subject_key,e.topic_code from app.topic_explainers e left join app.topic_point_briefs b on b.subject_key=e.subject_key and b.topic_code=e.topic_code and b.status='published' where e.subject_key='ap_precalculus' and e.unit_number=4 and e.topic_code in ('4.1', '4.2', '4.3', '4.4', '4.5', '4.6', '4.7', '4.8', '4.9', '4.10', '4.11', '4.12', '4.13', '4.14') and e.status='published' and b.topic_code is null
  ) orphans;
  if v_pairing_orphans <> 0 then raise exception 'expected 0 AP Precalculus Unit 4 pairing orphans, got %', v_pairing_orphans; end if;

  select count(*) into v_unit_mismatches from app.topic_point_briefs b join app.topic_explainers e on e.subject_key=b.subject_key and e.topic_code=b.topic_code where b.subject_key='ap_precalculus' and b.topic_code in ('4.1', '4.2', '4.3', '4.4', '4.5', '4.6', '4.7', '4.8', '4.9', '4.10', '4.11', '4.12', '4.13', '4.14') and b.status='published' and e.status='published' and b.unit_number<>e.unit_number;
  if v_unit_mismatches <> 0 then raise exception 'expected 0 AP Precalculus Unit 4 unit mismatches, got %', v_unit_mismatches; end if;

  select count(*) into v_route_mismatches from app.topic_point_briefs b where b.subject_key='ap_precalculus' and b.unit_number=4 and b.topic_code in ('4.1', '4.2', '4.3', '4.4', '4.5', '4.6', '4.7', '4.8', '4.9', '4.10', '4.11', '4.12', '4.13', '4.14') and b.status='published' and (b.practice_subject_key<>b.subject_key or b.practice_unit_number<>b.unit_number or b.practice_topic_code<>b.topic_code or b.learn_more_path not like '/learn/ap-precalculus/unit-4/%');
  if v_route_mismatches <> 0 then raise exception 'expected 0 AP Precalculus Unit 4 route mismatches, got %', v_route_mismatches; end if;

  select count(*) into v_core_matches from app.topic_point_briefs b join app.topic_explainers e on e.subject_key=b.subject_key and e.topic_code=b.topic_code where b.subject_key='ap_precalculus' and b.topic_code in ('4.1', '4.2', '4.3', '4.4', '4.5', '4.6', '4.7', '4.8', '4.9', '4.10', '4.11', '4.12', '4.13', '4.14') and b.status='published' and e.status='published' and e.core_idea=b.what_it_is;
  if v_core_matches <> 0 then raise exception 'expected 0 AP Precalculus Unit 4 core_idea/what_it_is matches, got %', v_core_matches; end if;

  with new_explainers as (select topic_explainer_id, mini_example_question, weak_answer, point_attaining_answer, practice_bridge from app.topic_explainers where subject_key='ap_precalculus' and unit_number=4 and topic_code in ('4.1', '4.2', '4.3', '4.4', '4.5', '4.6', '4.7', '4.8', '4.9', '4.10', '4.11', '4.12', '4.13', '4.14') and status='published'),
  field_values as (select 'mini_example_question' field_name, mini_example_question value from new_explainers union all select 'weak_answer', weak_answer from new_explainers union all select 'point_attaining_answer', point_attaining_answer from new_explainers union all select 'practice_bridge', practice_bridge from new_explainers)
  select count(*) into v_duplicate_explainer_fields from field_values fv join app.topic_explainers e on (e.mini_example_question=fv.value or e.weak_answer=fv.value or e.point_attaining_answer=fv.value or e.practice_bridge=fv.value) where e.status='published' and not (e.subject_key='ap_precalculus' and e.unit_number=4 and e.topic_code in ('4.1', '4.2', '4.3', '4.4', '4.5', '4.6', '4.7', '4.8', '4.9', '4.10', '4.11', '4.12', '4.13', '4.14'));
  if v_duplicate_explainer_fields <> 0 then raise exception 'expected 0 AP Precalculus Unit 4 duplicate explainer fields, got %', v_duplicate_explainer_fields; end if;
end $$;

commit;
