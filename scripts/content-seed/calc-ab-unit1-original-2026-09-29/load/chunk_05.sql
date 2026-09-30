begin;
create temporary table u1n_epv (epv_id uuid) on commit drop;
create temporary table u1v_epv (epv_id uuid) on commit drop;
insert into u1n_epv select epv.id from app.exam_pack_versions epv join app.exam_packs e on e.id = epv.exam_pack_id where e.exam_name = 'AP Calculus AB';
insert into u1v_epv select epv_id from u1n_epv;
do $$ begin
  if (select count(*) from u1n_epv) <> 1 then raise exception 'exam pack version lookup failed'; end if;
  if exists (select 1 from app.content_items ci join u1n_epv on ci.exam_pack_version_id = u1n_epv.epv_id where ci.content_key = any (array['apcalcab-mcq-u1v-004-v1','apcalcab-mcq-u1v-004-v2','apcalcab-mcq-u1v-004-v3','apcalcab-mcq-u1v-005-v1','apcalcab-mcq-u1v-005-v2','apcalcab-mcq-u1v-005-v3','apcalcab-mcq-u1v-006-v1','apcalcab-mcq-u1v-006-v2','apcalcab-mcq-u1v-006-v3','apcalcab-mcq-u1v-007-v1','apcalcab-mcq-u1v-007-v2'])) then
    raise exception 'chunk already loaded';
  end if;
end $$;
-- MCQ variant 004-v1 of 004 | medium | Cost Function With a Shutdown Value
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), epv_id, 'apcalcab-mcq-u1v-004-v1', 'mcq', 'Cost Function With a Shutdown Value', 'draft' from u1v_epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A plant''s cost function is defined by

C(q) = 3q + 1 for q < 2
C(2) = 0
C(q) = q^2 + 3 for q > 2

What is lim(q->2) C(q)?', md5('apcalcab-mcq-u1v-004-v1'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '0', false, 'This is the value C(2). The limit depends only on the values of C near 2, not on the value at 2.' from version_ins
union all select gen_random_uuid(), id, 'B', '6', false, 'This evaluates 3q at q = 2 and drops the +1 from the left-hand piece. The left piece is 3q + 1, which equals 7 at q = 2.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The limit does not exist.', false, 'The limit would fail to exist if the one-sided limits differed. Here both equal 7, and the odd value C(2) = 0 does not affect the limit.' from version_ins
union all select gen_random_uuid(), id, 'D', '7', true, 'From the left, 3(2) + 1 = 7. From the right, 2^2 + 3 = 7. The one-sided limits agree, so the limit is 7, regardless of C(2).' from version_ins
;
-- MCQ variant 004-v2 of 004 | medium | Piecewise Temperature With Mismatched Sides
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), epv_id, 'apcalcab-mcq-u1v-004-v2', 'mcq', 'Piecewise Temperature With Mismatched Sides', 'draft' from u1v_epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The temperature of a metal part is defined by

T(t) = 2t + 1 for t < 1
T(1) = 5
T(t) = t^2 + 4 for t > 1

What is lim(t->1) T(t)?', md5('apcalcab-mcq-u1v-004-v2'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '5', false, 'This is T(1), and it also equals the right-hand limit. The two-sided limit requires the left-hand limit to match, and the left-hand limit is 3.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The limit does not exist.', true, 'From the left, 2(1) + 1 = 3. From the right, 1^2 + 4 = 5. The one-sided limits differ, so the two-sided limit does not exist, even though T(1) = 5.' from version_ins
union all select gen_random_uuid(), id, 'C', '3', false, 'This uses only the left-hand piece. A two-sided limit must also agree with the right-hand piece, which approaches 5.' from version_ins
union all select gen_random_uuid(), id, 'D', '4', false, 'This averages the one-sided limits 3 and 5. A limit is a single value approached from both sides; when the sides disagree, there is no such value.' from version_ins
;
-- MCQ variant 004-v3 of 004 | medium | Piecewise With a Radical and a Fraction
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), epv_id, 'apcalcab-mcq-u1v-004-v3', 'mcq', 'Piecewise With a Radical and a Fraction', 'draft' from u1v_epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A signal is defined by

g(x) = sqrt(x + 13) - 1 for x < 3
g(3) = -4
g(x) = (x^2 - 3)/2 for x > 3

What is lim(x->3) g(x)?', md5('apcalcab-mcq-u1v-004-v3'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The limit does not exist.', false, 'The limit would fail to exist if the one-sided limits differed. Here both equal 3, and g(3) = -4 does not affect the limit.' from version_ins
union all select gen_random_uuid(), id, 'B', '-4', false, 'This is the value g(3). The limit depends only on the values of g near 3, not on the value at 3.' from version_ins
union all select gen_random_uuid(), id, 'C', '4', false, 'This evaluates the radical sqrt(16) = 4 on the left piece but drops the -1. The left piece is sqrt(x + 13) - 1, which equals 3 at x = 3.' from version_ins
union all select gen_random_uuid(), id, 'D', '3', true, 'From the left, sqrt(3 + 13) - 1 = 4 - 1 = 3. From the right, (9 - 3)/2 = 3. The one-sided limits agree, so the limit is 3, regardless of g(3).' from version_ins
;
-- MCQ variant 005-v1 of 005 | medium | Voltage Table Approaching From Above
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), epv_id, 'apcalcab-mcq-u1v-005-v1', 'mcq', 'Voltage Table Approaching From Above', 'draft' from u1v_epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The table shows values of a function V near t = 5. The value V(5) is undefined.

t = 4.9: V(t) = -1.8
t = 4.99: V(t) = -1.98
t = 4.999: V(t) = -1.998
t = 5.001: V(t) = -2.002
t = 5.01: V(t) = -2.02
t = 5.1: V(t) = -2.2

Which of the following is the best estimate of lim(t->5) V(t)?', md5('apcalcab-mcq-u1v-005-v1'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The limit does not exist because V(5) is undefined.', false, 'A limit can exist even if the function is not defined at that point. What matters is the behavior of V on both sides of 5.' from version_ins
union all select gen_random_uuid(), id, 'B', '-2.2', false, 'This is the output at the sampled point t = 5.1, the farthest from 5 on the right. The values keep moving toward -2 as t gets closer to 5.' from version_ins
union all select gen_random_uuid(), id, 'C', '-1.998', false, 'This is the value at t = 4.999, one of the sampled points. The limit is the number the values approach, not one of the sampled outputs.' from version_ins
union all select gen_random_uuid(), id, 'D', '-2', true, 'From both sides the values of V(t) get closer to -2 as t gets closer to 5. The undefined value V(5) does not affect the limit.' from version_ins
;
-- MCQ variant 005-v2 of 005 | medium | Table Where the Function Value Differs
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), epv_id, 'apcalcab-mcq-u1v-005-v2', 'mcq', 'Table Where the Function Value Differs', 'draft' from u1v_epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The table shows values of a function f near x = 1. The function is defined at x = 1 with f(1) = 8.

x = 0.9: f(x) = 2.5
x = 0.99: f(x) = 2.95
x = 0.999: f(x) = 2.995
x = 1.001: f(x) = 3.005
x = 1.01: f(x) = 3.05
x = 1.1: f(x) = 3.5

Which of the following is the best estimate of lim(x->1) f(x)?', md5('apcalcab-mcq-u1v-005-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '5.5', false, 'This averages the limit-like value 3 with f(1) = 8. A limit is not a blend of the nearby values and the value at the point; it is the number the nearby values approach.' from version_ins
union all select gen_random_uuid(), id, 'B', '2.995', false, 'This is the value at x = 0.999, one of the sampled points. The limit is the number the values approach, not one of the sampled outputs.' from version_ins
union all select gen_random_uuid(), id, 'C', '8', false, 'This is the value f(1). The limit depends on the values of f near x = 1, which approach 3, not on the value at x = 1.' from version_ins
union all select gen_random_uuid(), id, 'D', '3', true, 'From both sides the values of f(x) get closer to 3 as x gets closer to 1. The value f(1) = 8 does not affect the limit.' from version_ins
;
-- MCQ variant 005-v3 of 005 | medium | Table With Values Changing Sign
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), epv_id, 'apcalcab-mcq-u1v-005-v3', 'mcq', 'Table With Values Changing Sign', 'draft' from u1v_epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The table shows the displacement d(x) of a spring, in millimeters, near x = 1.5. The value d(1.5) is undefined.

x = 1.4: d = -0.4
x = 1.49: d = -0.04
x = 1.499: d = -0.004
x = 1.501: d = 0.004
x = 1.51: d = 0.04
x = 1.6: d = 0.4

Which of the following is the best estimate of lim(x->1.5) d(x)?', md5('apcalcab-mcq-u1v-005-v3'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '0', true, 'From both sides the values of d(x) get closer to 0 as x gets closer to 1.5. Passing from negative to positive values is fine because both sides approach the same number, 0.' from version_ins
union all select gen_random_uuid(), id, 'B', '-0.004', false, 'This is the value at x = 1.499, one of the sampled points. The limit is the number the values approach, not one of the sampled outputs.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The limit does not exist because the values change sign.', false, 'Values on the two sides having opposite signs does not prevent a limit. What matters is whether both sides approach the same number, and both approach 0.' from version_ins
union all select gen_random_uuid(), id, 'D', '0.4', false, 'This is the output at x = 1.6, the farthest sampled point on the right. The values shrink toward 0 as x gets closer to 1.5.' from version_ins
;
-- MCQ variant 006-v1 of 006 | medium | Combining Two Sensor Limits
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), epv_id, 'apcalcab-mcq-u1v-006-v1', 'mcq', 'Combining Two Sensor Limits', 'draft' from u1v_epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Suppose lim(t->6) u(t) = -5 and lim(t->6) v(t) = 2. What is lim(t->6) [(u(t))^2 - 3v(t)] / [u(t) + 2v(t)]?', md5('apcalcab-mcq-u1v-006-v1'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '31', false, 'This treats (-5)^2 as -25, giving numerator -25 - 6 = -31 over -1. Squaring -5 gives +25, so the numerator''s limit is 25 - 6 = 19.' from version_ins
union all select gen_random_uuid(), id, 'B', '-19', true, 'The numerator approaches (-5)^2 - 3(2) = 25 - 6 = 19 and the denominator approaches -5 + 2(2) = -1. The denominator''s limit is not 0, so the quotient approaches 19/(-1) = -19.' from version_ins
union all select gen_random_uuid(), id, 'C', '-31', false, 'This changes the sign of the 3v term, computing 25 + 6 = 31 in the numerator. The numerator''s limit is 25 - 3(2) = 19.' from version_ins
union all select gen_random_uuid(), id, 'D', '-19/3', false, 'This uses u + 2v with v counted once, giving -5 + 2 = -3 in the denominator. The denominator''s limit is -5 + 2(2) = -1.' from version_ins
;
-- MCQ variant 006-v2 of 006 | medium | Cubes and Products of Limits
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), epv_id, 'apcalcab-mcq-u1v-006-v2', 'mcq', 'Cubes and Products of Limits', 'draft' from u1v_epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Two competing rates F(x) and G(x) satisfy lim(x->9) F(x) = -2 and lim(x->9) G(x) = 4. What is lim(x->9) [(F(x))^3 + 2F(x)G(x)] / [G(x) - F(x)]?', md5('apcalcab-mcq-u1v-006-v2'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '-4/3', false, 'This treats (-2)^3 as 8, giving numerator 8 - 16 = -8 over 6. Cubing -2 gives -8, so the numerator''s limit is -8 - 16 = -24.' from version_ins
union all select gen_random_uuid(), id, 'B', '-4', true, 'The numerator approaches (-2)^3 + 2(-2)(4) = -8 - 16 = -24 and the denominator approaches 4 - (-2) = 6. The denominator''s limit is not 0, so the quotient approaches -24/6 = -4.' from version_ins
union all select gen_random_uuid(), id, 'C', '-11/3', false, 'This replaces F cubed with 3F, computing -6 - 16 = -22 in the numerator. F cubed approaches (-2)^3 = -8, not 3(-2).' from version_ins
union all select gen_random_uuid(), id, 'D', '-12', false, 'This adds instead of subtracting in the denominator, using 4 + (-2) = 2. The denominator''s limit is G - F = 4 - (-2) = 6.' from version_ins
;
-- MCQ variant 006-v3 of 006 | medium | Supply and Demand Limits in a Quotient
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), epv_id, 'apcalcab-mcq-u1v-006-v3', 'mcq', 'Supply and Demand Limits in a Quotient', 'draft' from u1v_epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Suppose lim(p->10) S(p) = 3 and lim(p->10) D(p) = -5 for a supply function S and a demand function D. What is lim(p->10) (S(p) - D(p))^2 / (D(p) + 2S(p))?', md5('apcalcab-mcq-u1v-006-v3'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '-16', false, 'This treats (S - D)^2 as S^2 - D^2 = 9 - 25 = -16. Squaring a difference does not distribute; (3 + 5)^2 = 64.' from version_ins
union all select gen_random_uuid(), id, 'B', '4/11', false, 'This treats D as 5, ignoring its sign: (3 - 5)^2 = 4 over 5 + 6 = 11. The limit of D is -5, so S - D approaches 3 + 5 = 8.' from version_ins
union all select gen_random_uuid(), id, 'C', '64', true, 'The numerator approaches (3 - (-5))^2 = 8^2 = 64 and the denominator approaches -5 + 2(3) = 1. The denominator''s limit is not 0, so the quotient approaches 64/1 = 64.' from version_ins
union all select gen_random_uuid(), id, 'D', '-32', false, 'This uses D + S in the denominator, leaving out the factor 2 and giving -5 + 3 = -2. The denominator''s limit is -5 + 2(3) = 1.' from version_ins
;
-- MCQ variant 007-v1 of 007 | medium | Two Quantities Both Shrinking to Zero
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), epv_id, 'apcalcab-mcq-u1v-007-v1', 'mcq', 'Two Quantities Both Shrinking to Zero', 'draft' from u1v_epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Two chemical amounts A(t) and B(t) both approach 0 as t approaches 7, so lim(t->7) A(t) = 0 and lim(t->7) B(t) = 0. Which of the following is true about lim(t->7) A(t)/B(t)?', md5('apcalcab-mcq-u1v-007-v1'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'It is infinity, because the denominator approaches 0.', false, 'A denominator approaching 0 does not by itself make the quotient unbounded, because here the numerator also approaches 0. For A(t) = (t - 7)^3 and B(t) = t - 7, the quotient approaches 0, not infinity.' from version_ins
union all select gen_random_uuid(), id, 'B', 'It equals 0, because the numerator approaches 0.', false, 'The numerator approaching 0 does not force the quotient to 0, since the denominator also approaches 0. For A(t) = 3(t - 7) and B(t) = t - 7, the quotient approaches 3.' from version_ins
union all select gen_random_uuid(), id, 'C', 'It does not exist, because B(t) approaches 0.', false, 'The quotient often has a limit even when the denominator approaches 0. For A(t) = 3(t - 7) and B(t) = t - 7, the quotient equals 3 for t != 7.' from version_ins
union all select gen_random_uuid(), id, 'D', 'It cannot be determined from this information alone.', true, 'The quotient law for limits requires the denominator''s limit to be nonzero. With both limits 0, the ratio depends on the functions: A(t) = 3(t - 7) and B(t) = t - 7 give 3, while A(t) = (t - 7)^3 and B(t) = t - 7 give 0.' from version_ins
;
-- MCQ variant 007-v2 of 007 | medium | Evaluating a Classmate's Claim About 0/0
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), epv_id, 'apcalcab-mcq-u1v-007-v2', 'mcq', 'Evaluating a Classmate''s Claim About 0/0', 'draft' from u1v_epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Suppose lim(x->-3) f(x) = 0 and lim(x->-3) g(x) = 0. A classmate says that lim(x->-3) f(x)/g(x) must not exist because 0/0 is undefined. Which of the following best evaluates the claim?', md5('apcalcab-mcq-u1v-007-v2'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The claim is incorrect: the limit may exist (for example, f(x) = 5(x + 3) and g(x) = x + 3 give 5), so it cannot be determined without more information.', true, 'The quotient law for limits does not apply when the denominator''s limit is 0, so nothing is settled by the given limits alone. Some pairs give a finite limit, such as 5, and others do not.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The claim is incorrect: the limit must equal 0, because the numerator approaches 0.', false, 'The numerator approaching 0 does not force the ratio to 0. With f(x) = 5(x + 3) and g(x) = x + 3, the ratio approaches 5.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The claim is incorrect: the limit must equal 1, because both functions approach the same number.', false, 'Both approaching 0 does not make their ratio approach 1. With f(x) = 5(x + 3) and g(x) = x + 3, the ratio approaches 5, and other pairs give other values.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The claim is correct: dividing by a quantity that approaches 0 means the limit can never exist.', false, 'The limit of a quotient can exist even when the denominator approaches 0. For f(x) = 5(x + 3) and g(x) = x + 3, the quotient equals 5 for x != -3.' from version_ins
;

commit;
