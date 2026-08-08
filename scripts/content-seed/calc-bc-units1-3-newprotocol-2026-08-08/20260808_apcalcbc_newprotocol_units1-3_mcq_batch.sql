-- AP Calculus BC, Units 1-3, new-content-creation-protocol comparison batch — MCQs.
-- Companion to 20260808_apcalcbc_newprotocol_units1-3_batch.sql (see that
-- file's header for provenance, grounding sources, and purpose). Every
-- distractor below is traceable to a specific documented misconception from
-- the 2025 Chief Reader Report or a standard, real error pattern confirmed
-- against the Scoring Guidelines' scoring-note language — not invented
-- arbitrarily.
--
-- Content-key scheme: apcalcbc-mcq-np1-001..010.
-- All items inserted as status='draft'. content_review_assignments created
-- in the companion assignment script (20260808_apcalcbc_newprotocol_assign_abdul.sql).

begin;
select pg_advisory_xact_lock(hashtext('cramapple-apcalcbc-newprotocol-units1-3-mcq-batch-20260808'));

do $$
declare
  v_epv_id uuid;
begin
  select epv.id into v_epv_id
  from app.exam_pack_versions epv
  join app.exam_packs e on e.id = epv.exam_pack_id
  where e.exam_name = 'AP Calculus BC';

  if v_epv_id is null then
    raise exception 'no_exam_pack_version_found:AP Calculus BC';
  end if;

  if exists (select 1 from app.content_items where content_key like 'apcalcbc-mcq-np1-%') then
    raise exception 'batch_already_seeded:apcalcbc-mcq-np1';
  end if;

  create temporary table np1_mcq_epv (epv_id uuid) on commit drop;
  insert into np1_mcq_epv values (v_epv_id);
end $$;

-- MCQ 1 — Unit 1 — IVT vs MVT/EVT/Squeeze theorem confusion — easy
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), epv_id, 'apcalcbc-mcq-np1-001', 'mcq', 'Existence Theorem Identification', 'draft'
  from np1_mcq_epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1,
    'Let f be a continuous function on [1, 5] with f(1) = -3 and f(5) = 9. Which theorem guarantees that there exists a value c in (1, 5) such that f(c) = 0?',
    md5('apcalcbc-mcq-np1-001'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Mean Value Theorem', false, 'The MVT relates the derivative to the average rate of change over an interval; it does not guarantee a specific function value between endpoints.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Extreme Value Theorem', false, 'The EVT guarantees an absolute maximum and minimum exist on a closed interval, not a specific intermediate value.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Intermediate Value Theorem', true, 'f is continuous on [1,5] and 0 is between f(1)=-3 and f(5)=9, so the IVT guarantees such a value c exists.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Squeeze Theorem', false, 'The Squeeze Theorem is used to evaluate limits by bounding a function between two others, not to guarantee function values on an interval.' from version_ins;

-- MCQ 2 — Unit 1 — end behavior / limit at infinity — medium
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), epv_id, 'apcalcbc-mcq-np1-002', 'mcq', 'End Behavior of a Growth Rate', 'draft'
  from np1_mcq_epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1,
    'A city''s population growth rate is modeled by P''(t) = 200t/(t+50) people per year, for t >= 0. What is lim(t->infinity) P''(t), and what does it represent?',
    md5('apcalcbc-mcq-np1-002'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '0; the growth rate approaches zero as time increases.', false, 'This is the value of P''(0), not the limit as t approaches infinity — evaluating at t=0 instead of examining long-run behavior is a common error.' from version_ins
union all select gen_random_uuid(), id, 'B', '200; the growth rate approaches 200 people per year as time increases.', true, 'Dividing numerator and denominator by t gives 200/(1+50/t), which approaches 200/1 = 200 as t approaches infinity.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Infinity; the growth rate increases without bound.', false, 'This ignores that the denominator grows at the same rate as the numerator (both degree 1 in t), so the ratio approaches a finite constant, not infinity.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The limit does not exist.', false, 'The limit does exist here because the degrees of the numerator and denominator match — this is not an oscillating or unbounded case.' from version_ins;

-- MCQ 3 — Unit 1 — limit evaluation via factoring, removable discontinuity — easy
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), epv_id, 'apcalcbc-mcq-np1-003', 'mcq', 'Limit at a Removable Discontinuity', 'draft'
  from np1_mcq_epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1,
    'What is lim(x->3) (x^2 - 2x - 3)/(x - 3)?',
    md5('apcalcbc-mcq-np1-003'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '0', false, 'This does not follow from factoring the expression; check the algebra: x^2-2x-3 factors as (x-3)(x+1).' from version_ins
union all select gen_random_uuid(), id, 'B', '1', false, 'This is the value at x+1 evaluated incorrectly; the correct simplified expression x+1 evaluated at x=3 gives 4, not 1.' from version_ins
union all select gen_random_uuid(), id, 'C', '4', true, 'Factoring gives (x-3)(x+1)/(x-3) = x+1 for x != 3, and the limit as x approaches 3 of x+1 is 4.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The limit does not exist because the function is undefined at x = 3.', false, 'The function being undefined at x=3 does not mean the limit fails to exist — the limit describes behavior near x=3, not at x=3 itself. This is a removable discontinuity where the limit exists even though the function is undefined there.' from version_ins;

-- MCQ 4 — Unit 2 — product rule "multiply the derivatives" misconception — medium
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), epv_id, 'apcalcbc-mcq-np1-004', 'mcq', 'Product Rule Application', 'draft'
  from np1_mcq_epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1,
    'If f(x) = x^2 * sin(x), what is f''(x)?',
    md5('apcalcbc-mcq-np1-004'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '2x * cos(x)', false, 'This multiplies the derivatives of each factor together (2x times cos x) instead of applying the product rule, which requires u''v + uv'' — a documented common error of treating differentiation as distributing over multiplication.' from version_ins
union all select gen_random_uuid(), id, 'B', '2x*sin(x) + x^2*cos(x)', true, 'The product rule f''=u''v+uv'' with u=x^2 and v=sin(x) gives 2x*sin(x) + x^2*cos(x).' from version_ins
union all select gen_random_uuid(), id, 'C', '2x*sin(x) - x^2*cos(x)', false, 'This has the correct terms but an incorrect sign on the second term; the product rule always adds the two terms, it never subtracts.' from version_ins
union all select gen_random_uuid(), id, 'D', 'x^2*cos(x)', false, 'This only differentiates the second factor and drops the first term of the product rule entirely (2x*sin(x)).' from version_ins;

-- MCQ 5 — Unit 2 — chain rule on exponential mistaken as product-rule pattern — medium
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), epv_id, 'apcalcbc-mcq-np1-005', 'mcq', 'Chain Rule on an Exponential Function', 'draft'
  from np1_mcq_epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1,
    'What is d/dx[e^(5x^2)]?',
    md5('apcalcbc-mcq-np1-005'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '10x', false, 'This drops the e^(5x^2) factor entirely, keeping only the derivative of the exponent.' from version_ins
union all select gen_random_uuid(), id, 'B', '10x * e^(5x^2)', true, 'By the chain rule, d/dx[e^u] = e^u * u'' with u=5x^2, u''=10x, giving 10x*e^(5x^2).' from version_ins
union all select gen_random_uuid(), id, 'C', '5x^2 * e^(5x^2)', false, 'This applies the pattern "derivative of e^u is u times e^u" instead of the correct e^u times u'' — a documented, common chain-rule/exponential-derivative confusion.' from version_ins
union all select gen_random_uuid(), id, 'D', 'e^(10x)', false, 'This incorrectly differentiates the exponent as if it changes the base of the exponential rather than being multiplied in as the chain-rule factor.' from version_ins;

-- MCQ 6 — Unit 2 — quotient rule sign error — medium
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), epv_id, 'apcalcbc-mcq-np1-006', 'mcq', 'Quotient Rule Evaluation', 'draft'
  from np1_mcq_epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1,
    'If f(x) = (3x - 1)/(x^2 + 2), what is f''(2)?',
    md5('apcalcbc-mcq-np1-006'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '-1/18', true, 'By the quotient rule, f''(x) = [3(x^2+2) - (3x-1)(2x)]/(x^2+2)^2. At x=2: [3(6) - 5(4)]/36 = (18-20)/36 = -2/36 = -1/18.' from version_ins
union all select gen_random_uuid(), id, 'B', '1/18', false, 'This has the correct magnitude but the wrong sign — check that the quotient rule numerator is u''v - uv'', not uv'' - u''v.' from version_ins
union all select gen_random_uuid(), id, 'C', '1/2', false, 'This differentiates only the numerator (getting 3) and divides by the original, un-squared denominator value (6) — the quotient rule was not applied.' from version_ins
union all select gen_random_uuid(), id, 'D', '-5/9', false, 'This does not follow from a correct application of the quotient rule to this function; recheck the numerator terms u''v and uv'' individually.' from version_ins;

-- MCQ 7 — Unit 3 — chain rule via table, forgetting inner-function derivative — hard
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), epv_id, 'apcalcbc-mcq-np1-007', 'mcq', 'Chain Rule from a Table of Values', 'draft'
  from np1_mcq_epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1,
    'The table gives values of f and f'' at x=1 and x=2: f(1)=4, f''(1)=6, f(2)=1, f''(2)=-3. If h(x) = f(x^2), what is h''(1)?',
    md5('apcalcbc-mcq-np1-007'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '6', false, 'This omits the chain-rule factor 2x (the derivative of the inner function x^2) — a common error of forgetting to differentiate the inner function.' from version_ins
union all select gen_random_uuid(), id, 'B', '12', true, 'By the chain rule, h''(x) = f''(x^2)*2x. At x=1, x^2=1, so h''(1) = f''(1)*2(1) = 6*2 = 12.' from version_ins
union all select gen_random_uuid(), id, 'C', '-6', false, 'This incorrectly uses f''(2) instead of f''(1) — at x=1, the inner function x^2 equals 1, not 2, so f'' must be evaluated at 1.' from version_ins
union all select gen_random_uuid(), id, 'D', '8', false, 'This incorrectly uses f(1)=4 (the function value) instead of f''(1)=6 (the derivative value) in the chain-rule computation.' from version_ins;

-- MCQ 8 — Unit 3 — implicit differentiation, vertical vs horizontal tangent inversion — hard
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), epv_id, 'apcalcbc-mcq-np1-008', 'mcq', 'Vertical Tangent on an Implicit Curve', 'draft'
  from np1_mcq_epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1,
    'For the curve defined by x^2 + y^2 - 6y = 7, at which point(s) does the curve have a vertical tangent line?',
    md5('apcalcbc-mcq-np1-008'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '(0, 7) and (0, -1)', false, 'These points come from setting the numerator of dy/dx equal to zero, which identifies horizontal tangents, not vertical ones — a common inversion of the vertical/horizontal tangent condition.' from version_ins
union all select gen_random_uuid(), id, 'B', '(4, 3) and (-4, 3)', true, 'Implicit differentiation gives dy/dx = -x/(y-3). A vertical tangent occurs where the denominator equals zero: y=3. Substituting into the curve equation gives x^2+9-18=7, so x^2=16, x=+-4.' from version_ins
union all select gen_random_uuid(), id, 'C', '(0, 3)', false, 'While y=3 is the correct condition for a vertical tangent, x=0 does not satisfy the curve equation at y=3 (0+9-18=-9, not 7).' from version_ins
union all select gen_random_uuid(), id, 'D', '(3, 4) and (3, -4)', false, 'This swaps the roles of x and y from the correct vertical-tangent points.' from version_ins;

-- MCQ 9 — Unit 3 — inverse function derivative, forgetting the reciprocal / wrong evaluation point — medium
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), epv_id, 'apcalcbc-mcq-np1-009', 'mcq', 'Derivative of an Inverse Function', 'draft'
  from np1_mcq_epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1,
    'Let g(x) = x^3 + x. Since g is increasing for all x, it has an inverse. What is (g^-1)''(2)?',
    md5('apcalcbc-mcq-np1-009'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '1/4', true, 'Since g(1)=2, g^-1(2)=1. g''(x)=3x^2+1, so g''(1)=4. By the inverse-derivative formula, (g^-1)''(2) = 1/g''(1) = 1/4.' from version_ins
union all select gen_random_uuid(), id, 'B', '4', false, 'This is g''(1) itself, without taking the reciprocal required by the inverse-function-derivative formula.' from version_ins
union all select gen_random_uuid(), id, 'C', '1/13', false, 'This evaluates g'' at x=2 (the output of g^-1) instead of at x=1 (the correct input, since g^-1(2)=1) — a common error of not first finding g^-1(2).' from version_ins
union all select gen_random_uuid(), id, 'D', '1', false, 'This is the value of g^-1(2), not its derivative — confusing the inverse function''s value with its rate of change.' from version_ins;

-- MCQ 10 — Unit 3 — implicit differentiation notation precision (dy vs dy/dx) — easy
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), epv_id, 'apcalcbc-mcq-np1-010', 'mcq', 'Notation in Implicit Differentiation', 'draft'
  from np1_mcq_epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1,
    'A student is asked to implicitly differentiate the equation x^2 + y^3 = 10 with respect to x. Which of the following is a correctly notated result?',
    md5('apcalcbc-mcq-np1-010'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '2x + 3y^2 dy = 0', false, 'This uses the differential "dy" where the derivative notation "dy/dx" is required — a documented notation error that costs credit even when the underlying calculus concept is understood.' from version_ins
union all select gen_random_uuid(), id, 'B', '2x + 3y^2 (dy/dx) = 0', true, 'This correctly applies the chain rule to y^3 using proper dy/dx notation, and correctly differentiates x^2 as 2x.' from version_ins
union all select gen_random_uuid(), id, 'C', '2x + 3y^2/dx = 0', false, 'This uses nonsensical mixed notation, dividing by dx alone rather than expressing the derivative as dy/dx.' from version_ins
union all select gen_random_uuid(), id, 'D', '2 + 3y^2 (dy/dx) = 0', false, 'This drops the x from the derivative of x^2 (which should be 2x, not 2) — a differentiation slip, not a notation issue.' from version_ins;

commit;
