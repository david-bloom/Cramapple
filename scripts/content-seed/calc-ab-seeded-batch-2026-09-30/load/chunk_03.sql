begin;
create temporary table epv (epv_id uuid) on commit drop;
insert into epv select epv.id from app.exam_pack_versions epv join app.exam_packs e on e.id = epv.exam_pack_id where e.exam_name = 'AP Calculus AB';
do $$ begin
  if (select count(*) from epv) <> 1 then raise exception 'exam pack version lookup failed'; end if;
  if exists (select 1 from app.content_items ci join epv on ci.exam_pack_version_id = epv.epv_id where ci.content_key = any (array['apcalcab-mcq-sv-005-v1','apcalcab-mcq-sv-005-v2','apcalcab-mcq-sv-007-v1','apcalcab-mcq-sv-007-v2','apcalcab-mcq-sv-030-v1','apcalcab-mcq-sv-030-v2','apcalcab-mcq-sv-008-v1','apcalcab-mcq-sv-008-v2'])) then
    raise exception 'chunk already loaded';
  end if;
end $$;
-- apcalcab-mcq-sv-005-v1 (seed apcalcab-mcq-005)
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), epv_id, 'apcalcab-mcq-sv-005-v1', 'mcq', 'Signal Decay With a Cosine Carrier', 'draft' from epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A signal is modeled by S(x) = e^(3x) cos x. What is S''(x)?', null, md5('apcalcab-mcq-sv-005-v1'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '3e^x cos(x)', false, 'Writes the derivative of e^(3x) as 3e^x, changing the exponent 3x to x, and omits the second product-rule term.' from version_ins
union all select gen_random_uuid(), id, 'B', '-3e^(3x) sin(x)', false, 'Multiplies the derivatives of the two factors, 3e^(3x) and -sin x, instead of applying the product rule.' from version_ins
union all select gen_random_uuid(), id, 'C', 'e^(3x)(3cos(x) - sin(x))', true, 'By the product rule with the chain rule on e^(3x): S''(x) = 3e^(3x) cos x + e^(3x)(-sin x) = e^(3x)(3 cos x - sin x).' from version_ins
union all select gen_random_uuid(), id, 'D', 'e^(3x)(cos(x) - 3sin(x))', false, 'Attaches the factor 3 to the wrong term: the 3 comes from differentiating e^(3x), which multiplies cos x, not sin x.' from version_ins
;
-- apcalcab-mcq-sv-005-v2 (seed apcalcab-mcq-005)
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), epv_id, 'apcalcab-mcq-sv-005-v2', 'mcq', 'Concentration Times a Decaying Exponential', 'draft' from epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A concentration is modeled by C(x) = x^2 e^(-x). What is C''(x)?', null, md5('apcalcab-mcq-sv-005-v2'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '2x e^(-x)', false, 'Omits the second product-rule term x^2(-e^(-x)).' from version_ins
union all select gen_random_uuid(), id, 'B', '-2x e^(-x)', false, 'Multiplies the derivatives of the two factors, 2x and -e^(-x), instead of applying the product rule.' from version_ins
union all select gen_random_uuid(), id, 'C', 'e^(-x)(2x - x^2)', true, 'By the product rule with the chain rule on e^(-x): C''(x) = 2x e^(-x) + x^2(-e^(-x)) = e^(-x)(2x - x^2).' from version_ins
union all select gen_random_uuid(), id, 'D', 'e^(-x)(2x + x^2)', false, 'Loses the negative sign from the chain rule on e^(-x) in the second product-rule term.' from version_ins
;
-- apcalcab-mcq-sv-007-v1 (seed apcalcab-mcq-007)
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), epv_id, 'apcalcab-mcq-sv-007-v1', 'mcq', 'Rate of a Radical Response', 'draft' from epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A response is modeled by R(x) = √(4x^2 + 9). What is R''(x)?', null, md5('apcalcab-mcq-sv-007-v1'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '1/(2√(4x^2+9))', false, 'Omits the inner derivative 8x.' from version_ins
union all select gen_random_uuid(), id, 'B', '2x/√(4x^2+9)', false, 'Differentiates the inner function 4x^2 as 4x instead of 8x, then simplifies (4x)/(2√(4x^2+9)).' from version_ins
union all select gen_random_uuid(), id, 'C', '8x√(4x^2+9)', false, 'Multiplies the inner derivative 8x by √(4x^2+9) instead of by the derivative of the square root, 1/(2√(4x^2+9)).' from version_ins
union all select gen_random_uuid(), id, 'D', '4x/√(4x^2+9)', true, 'By the chain rule, R''(x) = 1/(2√(4x^2+9)) times the inner derivative 8x, which simplifies to 4x/√(4x^2+9).' from version_ins
;
-- apcalcab-mcq-sv-007-v2 (seed apcalcab-mcq-007)
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), epv_id, 'apcalcab-mcq-sv-007-v2', 'mcq', 'Cube-Root Growth Index', 'draft' from epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'An index is modeled by G(x) = (1 + x^4)^(1/3). What is G''(x)?', null, md5('apcalcab-mcq-sv-007-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '4x^3(1+x^4)^(2/3)/3', false, 'Uses the exponent +2/3 instead of -2/3 after reducing the power.' from version_ins
union all select gen_random_uuid(), id, 'B', '1/(3(1+x^4)^(2/3))', false, 'Omits the inner derivative 4x^3.' from version_ins
union all select gen_random_uuid(), id, 'C', '4x^3/(3(1+x^4)^(1/3))', false, 'Negates the exponent 1/3 to -1/3 instead of reducing it by 1 to -2/3 when applying the power rule.' from version_ins
union all select gen_random_uuid(), id, 'D', '4x^3/(3(1+x^4)^(2/3))', true, 'By the chain rule, G''(x) = (1/3)(1+x^4)^(-2/3) times the inner derivative 4x^3, which is 4x^3/(3(1+x^4)^(2/3)).' from version_ins
;
-- apcalcab-mcq-sv-030-v1 (seed apcalcab-mcq-030)
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), epv_id, 'apcalcab-mcq-sv-030-v1', 'mcq', 'Slope on a Circular Boundary', 'draft' from epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The boundary of a circular field satisfies x^2 + y^2 = 169. What is dy/dx at the point (5, 12)?', null, md5('apcalcab-mcq-sv-030-v1'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '5/12', false, 'Drops the negative sign when solving for dy/dx.' from version_ins
union all select gen_random_uuid(), id, 'B', '12/5', false, 'Interchanges x and y and drops the negative sign.' from version_ins
union all select gen_random_uuid(), id, 'C', '-5/12', true, 'Differentiating implicitly gives 2x + 2y(dy/dx) = 0, so dy/dx = -x/y. At (5, 12) this is -5/12.' from version_ins
union all select gen_random_uuid(), id, 'D', '-12/5', false, 'Uses -y/x instead of -x/y, which is the reciprocal of the correct slope.' from version_ins
;
-- apcalcab-mcq-sv-030-v2 (seed apcalcab-mcq-030)
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), epv_id, 'apcalcab-mcq-sv-030-v2', 'mcq', 'Slope on a Circle at a Negative x-Value', 'draft' from epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A curve satisfies x^2 + y^2 = 50. What is dy/dx at the point (-1, 7)?', null, md5('apcalcab-mcq-sv-030-v2'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '7', false, 'Uses -y/x instead of -x/y: -7/(-1) = 7, the reciprocal of the correct slope.' from version_ins
union all select gen_random_uuid(), id, 'B', '1/7', true, 'Differentiating implicitly gives 2x + 2y(dy/dx) = 0, so dy/dx = -x/y. At (-1, 7) this is -(-1)/7 = 1/7.' from version_ins
union all select gen_random_uuid(), id, 'C', '-7', false, 'Uses y/x instead of -x/y.' from version_ins
union all select gen_random_uuid(), id, 'D', '-1/7', false, 'Substitutes x = -1 as if it were +1, giving -x/y = -1/7 instead of -(-1)/7 = 1/7.' from version_ins
;
-- apcalcab-mcq-sv-008-v1 (seed apcalcab-mcq-008)
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), epv_id, 'apcalcab-mcq-sv-008-v1', 'mcq', 'Slope on a Cross-Term Curve', 'draft' from epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A curve is given by x^2 + 3xy - y^2 = 9. What is dy/dx at the point (2, 1)?', null, md5('apcalcab-mcq-sv-008-v1'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '7/4', false, 'Loses the negative sign when moving 2x + 3y to the other side.' from version_ins
union all select gen_random_uuid(), id, 'B', '-4/7', false, 'Inverts the fraction, using -(3x - 2y)/(2x + 3y).' from version_ins
union all select gen_random_uuid(), id, 'C', '-7/4', true, 'Differentiating gives 2x + 3y + 3x(dy/dx) - 2y(dy/dx) = 0, so dy/dx = -(2x + 3y)/(3x - 2y). At (2, 1) this is -7/4.' from version_ins
union all select gen_random_uuid(), id, 'D', '7/2', false, 'Omits the term 3x(dy/dx) from the product rule on 3xy, leaving (2x + 3y)/(2y).' from version_ins
;
-- apcalcab-mcq-sv-008-v2 (seed apcalcab-mcq-008)
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), epv_id, 'apcalcab-mcq-sv-008-v2', 'mcq', 'Slope on a Conic With a Cross Term', 'draft' from epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A curve is given by 2x^2 - xy + y^2 = 8. What is dy/dx at the point (1, 3)?', null, md5('apcalcab-mcq-sv-008-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '-1/6', false, 'Omits the term -x(dy/dx) from the product rule on -xy, leaving 4x - y + 2y(dy/dx) = 0 and dy/dx = (y - 4x)/(2y).' from version_ins
union all select gen_random_uuid(), id, 'B', '1/5', false, 'Loses the sign when solving, giving (4x - y)/(2y - x).' from version_ins
union all select gen_random_uuid(), id, 'C', '-5', false, 'Inverts the fraction, using (2y - x)/(y - 4x).' from version_ins
union all select gen_random_uuid(), id, 'D', '-1/5', true, 'Differentiating gives 4x - y - x(dy/dx) + 2y(dy/dx) = 0, so dy/dx = (y - 4x)/(2y - x). At (1, 3) this is (3 - 4)/(6 - 1) = -1/5.' from version_ins
;
commit;
