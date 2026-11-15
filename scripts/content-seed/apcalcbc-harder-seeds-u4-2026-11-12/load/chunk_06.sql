begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='3778d753-273a-403d-8f02-55dc64ec6a27' and content_key = any (array['apcalcbc-mcq-b4-sv-h-4.6-b-v1','apcalcbc-mcq-b4-sv-h-4.6-b-v2','apcalcbc-mcq-b4-sv-h-4.6-b-v3','apcalcbc-mcq-b4-h-4.7-a','apcalcbc-mcq-b4-sv-h-4.7-a-v1','apcalcbc-mcq-b4-sv-h-4.7-a-v2','apcalcbc-mcq-b4-sv-h-4.7-a-v3','apcalcbc-mcq-b4-h-4.7-b','apcalcbc-mcq-b4-sv-h-4.7-b-v1'])) then raise exception 'chunk 6 already loaded'; end if;
end $$;
-- apcalcbc-mcq-b4-sv-h-4.6-b-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b4-sv-h-4.6-b-v1', 'mcq', 'use a tangent-line model in reverse to estimate when a target value is reached, and use concavity to decide whether the  (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A tank is draining. At t = 5 minutes the volume is V(5) = 900 liters, and V′(5) = −30 liters per minute. V is concave up for t ≥ 5. The tangent line at t = 5 is used to estimate when the volume reaches 600 liters. Which statement is correct?', null, md5('apcalcbc-mcq-b4-sv-h-4.6-b-v1'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The tangent line gives t = 15 minutes, and the volume actually reaches 600 liters later than that.', true, 'Correct: L(t) = 900 − 30(t − 5) = 600 gives t = 15. Because V is concave up, V(t) ≥ L(t), so V(15) > 600 and the tank has not yet reached 600 at t = 15; the true time is later.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The tangent line gives t = 15 minutes, and the volume actually reaches 600 liters earlier than that.', false, 'V is concave up, so the graph lies above its tangent line; at t = 15 the true volume is still above 600, so the tank reaches 600 liters later.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The tangent line gives t = 10 minutes, and the volume actually reaches 600 liters later than that.', false, 'Solving 900 − 30(t − 5) = 600 gives t − 5 = 10; 10 is the elapsed time since t = 5, so 5 must be added to get t = 15.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The tangent line gives t = 30 minutes, and the volume actually reaches 600 liters earlier than that.', false, '900/30 = 30 divides the starting volume by the rate instead of dividing the 300-liter drop by the rate; the equation is 900 − 30(t − 5) = 600.' from version_ins;
-- apcalcbc-mcq-b4-sv-h-4.6-b-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b4-sv-h-4.6-b-v2', 'mcq', 'use a tangent-line model in reverse to estimate when a target value is reached, and use concavity to decide whether the  (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A town''s population is P(t) thousand people, t years after 2000. P(2) = 40 and P′(2) = 6, and P is concave down for t ≥ 2. The tangent line at t = 2 is used to estimate when the population reaches 70 thousand. Which statement is correct?', null, md5('apcalcbc-mcq-b4-sv-h-4.6-b-v2'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The tangent line gives t = 7, and the population actually reaches 70 thousand later than that.', true, 'Correct: L(t) = 40 + 6(t − 2) = 70 gives t = 7. Because P is concave down, P(t) ≤ L(t), so P(7) < 70 and the population has not yet reached 70 at t = 7; the true time is later.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The tangent line gives t = 7, and the population actually reaches 70 thousand earlier than that.', false, 'P is concave down, so the graph lies below its tangent line; at t = 7 the true population is still below 70, so it reaches 70 later.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The tangent line gives t = 5, and the population actually reaches 70 thousand later than that.', false, 'Solving 40 + 6(t − 2) = 70 gives t − 2 = 5; 5 is the elapsed time since t = 2, so 2 must be added to get t = 7.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The tangent line gives t = 11.7, and the population actually reaches 70 thousand earlier than that.', false, '70/6 ≈ 11.7 divides the target value by the rate instead of dividing the 30-thousand increase by the rate; the equation is 40 + 6(t − 2) = 70.' from version_ins;
-- apcalcbc-mcq-b4-sv-h-4.6-b-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b4-sv-h-4.6-b-v3', 'mcq', 'use a tangent-line model in reverse to estimate when a target value is reached, and use concavity to decide whether the  (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A company''s yearly revenue is R(t) million dollars, t years after launch. R(4) = 30 and R′(4) = 5, and R is concave up for t ≥ 4. The tangent line at t = 4 is used to estimate when revenue reaches 50 million dollars. Which statement is correct?', null, md5('apcalcbc-mcq-b4-sv-h-4.6-b-v3'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The tangent line gives t = 8, and revenue actually reaches 50 million dollars earlier than that.', true, 'Correct: L(t) = 30 + 5(t − 4) = 50 gives t = 8. Because R is concave up, R(t) ≥ L(t), so R(8) > 50 and revenue passed 50 million before t = 8; the true time is earlier.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The tangent line gives t = 8, and revenue actually reaches 50 million dollars later than that.', false, 'R is concave up, so the graph lies above its tangent line; at t = 8 the true revenue is already above 50, so it reached 50 earlier.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The tangent line gives t = 4, and revenue actually reaches 50 million dollars earlier than that.', false, 'Solving 30 + 5(t − 4) = 50 gives t − 4 = 4; 4 is the elapsed time since t = 4, so 4 must be added to get t = 8.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The tangent line gives t = 10, and revenue actually reaches 50 million dollars later than that.', false, '50/5 = 10 divides the target value by the rate instead of dividing the 20-million increase by the rate; the equation is 30 + 5(t − 4) = 50.' from version_ins;
-- apcalcbc-mcq-b4-h-4.7-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b4-h-4.7-a', 'mcq', 'decide whether L''Hôpital''s rule applies, then apply it correctly, including repeated applications and chain-rule factors', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Which of the following evaluations of a limit is completely correct?', null, md5('apcalcbc-mcq-b4-h-4.7-a'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'lim (x→0) cos x/(x + 1): by L′Hôpital''s rule this equals lim (−sin x)/1 = 0.', false, 'The form at x = 0 is 1/1, which is not indeterminate, so L′Hôpital''s rule does not apply; the limit is 1 by direct substitution.' from version_ins
union all select gen_random_uuid(), id, 'B', 'lim (x→0) (1 − cos 2x)/x²: by L′Hôpital''s rule twice, this equals lim 2sin 2x/(2x) = lim 4cos 2x/2 = 2.', true, 'Correct: 1 − cos 2x and x² both tend to 0, so the form is 0/0. One application gives 2sin 2x/(2x), still 0/0; a second gives 4cos 2x/2, which tends to 2. The other three evaluations misuse the rule or drop chain-rule factors.' from version_ins
union all select gen_random_uuid(), id, 'C', 'lim (x→∞) (x + sin x)/x: the quotient of derivatives, 1 + cos x, has no limit, so the original limit does not exist.', false, 'When the limit of the derivative quotient fails to exist, the rule gives no information; (x + sin x)/x = 1 + (sin x)/x, which tends to 1.' from version_ins
union all select gen_random_uuid(), id, 'D', 'lim (x→0) (e^(2x) − 1)/sin 3x: by L′Hôpital''s rule this equals lim e^(2x)/cos 3x = 1.', false, 'This drops the chain-rule factors: the derivatives are 2e^(2x) and 3cos 3x, so the limit is 2/3.' from version_ins;
-- apcalcbc-mcq-b4-sv-h-4.7-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b4-sv-h-4.7-a-v1', 'mcq', 'decide whether L''Hôpital''s rule applies, then apply it correctly, including repeated applications and chain-rule factors (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A student evaluates four limits using L′Hôpital''s rule or a related argument. Which evaluation is completely correct?', null, md5('apcalcbc-mcq-b4-sv-h-4.7-a-v1'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'lim (x→0) (x − sin x)/x³: by L′Hôpital''s rule repeatedly, this equals lim (1 − cos x)/(3x²) = lim sin x/(6x) = lim cos x/6 = 1/6.', true, 'Correct: x − sin x and x³ both tend to 0. Applying the rule three times gives (1 − cos x)/(3x²), then sin x/(6x), then cos x/6, which tends to 1/6. The other three evaluations misuse the rule or drop a chain-rule factor.' from version_ins
union all select gen_random_uuid(), id, 'B', 'lim (x→2) (x² + 1)/(x − 1): by L′Hôpital''s rule this equals lim 2x/1 = 4.', false, 'The form at x = 2 is 5/1, which is not indeterminate, so L′Hôpital''s rule does not apply; the limit is 5 by direct substitution.' from version_ins
union all select gen_random_uuid(), id, 'C', 'lim (x→∞) (2x − cos x)/x: the quotient of derivatives, 2 + sin x, has no limit, so the original limit does not exist.', false, 'When the limit of the derivative quotient fails to exist, the rule gives no information; (2x − cos x)/x = 2 − (cos x)/x, which tends to 2.' from version_ins
union all select gen_random_uuid(), id, 'D', 'lim (x→0) ln(1 + 4x)/x: by L′Hôpital''s rule this equals lim [1/(1 + 4x)]/1 = 1.', false, 'This drops the chain-rule factor 4: the derivative of ln(1 + 4x) is 4/(1 + 4x), so the limit is 4.' from version_ins;
-- apcalcbc-mcq-b4-sv-h-4.7-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b4-sv-h-4.7-a-v2', 'mcq', 'decide whether L''Hôpital''s rule applies, then apply it correctly, including repeated applications and chain-rule factors (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Four classmates each evaluate a limit and show their work. Which evaluation is completely correct?', null, md5('apcalcbc-mcq-b4-sv-h-4.7-a-v2'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'lim (x→0) (3 + 2x)/(1 + cos x): by L′Hôpital''s rule this equals lim 2/(−sin x), which is unbounded, so the limit does not exist.', false, 'The form at x = 0 is 3/2, which is not indeterminate, so L′Hôpital''s rule does not apply; the limit is 3/2 by direct substitution.' from version_ins
union all select gen_random_uuid(), id, 'B', 'lim (x→∞) (3x + sin 2x)/(x + 1): the quotient of derivatives, 3 + 2cos 2x, has no limit, so the original limit does not exist.', false, 'When the limit of the derivative quotient fails to exist, the rule gives no information; dividing top and bottom by x shows the limit is 3.' from version_ins
union all select gen_random_uuid(), id, 'C', 'lim (x→0) (e^x − 1 − x)/x²: by L′Hôpital''s rule twice, this equals lim (e^x − 1)/(2x) = lim e^x/2 = 1/2.', true, 'Correct: e^x − 1 − x and x² both tend to 0, so the form is 0/0. One application gives (e^x − 1)/(2x), still 0/0; a second gives e^x/2, which tends to 1/2. The other three evaluations misuse the rule or drop a chain-rule factor.' from version_ins
union all select gen_random_uuid(), id, 'D', 'lim (x→0) sin 5x/(2x): by L′Hôpital''s rule this equals lim cos 5x/2 = 1/2.', false, 'This drops the chain-rule factor 5: the derivative of sin 5x is 5cos 5x, so the limit is 5/2.' from version_ins;
-- apcalcbc-mcq-b4-sv-h-4.7-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b4-sv-h-4.7-a-v3', 'mcq', 'decide whether L''Hôpital''s rule applies, then apply it correctly, including repeated applications and chain-rule factors (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Exactly one of the following limit evaluations is fully correct. Which one is it?', null, md5('apcalcbc-mcq-b4-sv-h-4.7-a-v3'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'lim (x→∞) x²/e^(3x): by L′Hôpital''s rule twice, this equals lim 2x/(3e^(3x)) = lim 2/(9e^(3x)) = 0.', true, 'Correct: x² and e^(3x) both tend to ∞, so the form is ∞/∞. One application gives 2x/(3e^(3x)), still ∞/∞; a second gives 2/(9e^(3x)), which tends to 0. The other three evaluations misuse the rule or drop a chain-rule factor.' from version_ins
union all select gen_random_uuid(), id, 'B', 'lim (x→1) (x + 2)/(x² + 1): by L′Hôpital''s rule this equals lim 1/(2x) = 1/2.', false, 'The form at x = 1 is 3/2, which is not indeterminate, so L′Hôpital''s rule does not apply; the limit is 3/2 by direct substitution.' from version_ins
union all select gen_random_uuid(), id, 'C', 'lim (x→∞) (x − cos x)/(x + 3): the quotient of derivatives, 1 + sin x, has no limit, so the original limit does not exist.', false, 'When the limit of the derivative quotient fails to exist, the rule gives no information; dividing top and bottom by x shows the limit is 1.' from version_ins
union all select gen_random_uuid(), id, 'D', 'lim (x→0) (1 − cos 3x)/x²: by L′Hôpital''s rule twice, this equals lim 3sin 3x/(2x) = lim 3cos 3x/2 = 3/2.', false, 'The second application drops a chain-rule factor: the derivative of 3sin 3x is 9cos 3x, so the limit is 9/2.' from version_ins;
-- apcalcbc-mcq-b4-h-4.7-b
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b4-h-4.7-b', 'mcq', 'rewrite a 0·∞ or 1^∞ form with a logarithm or a quotient so that L''Hôpital''s rule can be used, then evaluate the limit.', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'What is lim (x→∞) (1 + 2/x)^(3x)?', null, md5('apcalcbc-mcq-b4-h-4.7-b'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '1', false, 'This treats 1^∞ as 1, but the base approaches 1 while the exponent grows without bound, which is an indeterminate form that must be resolved with a logarithm.' from version_ins
union all select gen_random_uuid(), id, 'B', 'e²', false, 'This finds lim x·ln(1 + 2/x) = 2 but forgets the factor 3 in the exponent; the log of the expression is 3x·ln(1 + 2/x), which tends to 6.' from version_ins
union all select gen_random_uuid(), id, 'C', 'e⁶', true, 'Correct: Let y = (1 + 2/x)^(3x). Then ln y = 3·ln(1 + 2/x)/(1/x), a 0/0 form. L′Hôpital''s rule gives 3·[(−2/x²)/(1 + 2/x)]/(−1/x²) = 6/(1 + 2/x), which tends to 6. So y → e⁶.' from version_ins
union all select gen_random_uuid(), id, 'D', '∞', false, 'This reasons that a base greater than 1 raised to an unbounded power must be unbounded, but the base 1 + 2/x approaches 1 so quickly that the product 3x·ln(1 + 2/x) stays finite.' from version_ins;
-- apcalcbc-mcq-b4-sv-h-4.7-b-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b4-sv-h-4.7-b-v1', 'mcq', 'rewrite a 0·∞ or 1^∞ form with a logarithm or a quotient so that L''Hôpital''s rule can be used, then evaluate the limit. (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'What is lim (x→∞) x(e^(1/x) − 1)?', null, md5('apcalcbc-mcq-b4-sv-h-4.7-b-v1'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '0', false, 'This takes the second factor to 0 and concludes the product is 0, but the first factor grows without bound, so this is a 0·∞ form that must be rewritten.' from version_ins
union all select gen_random_uuid(), id, 'B', '∞', false, 'This takes the first factor to ∞ and concludes the product is unbounded, ignoring that the second factor tends to 0; the 0·∞ form must be rewritten as a quotient.' from version_ins
union all select gen_random_uuid(), id, 'C', '−∞', false, 'This rewrites as (e^(1/x) − 1)/(1/x) and differentiates the numerator without the chain-rule factor −1/x², giving e^(1/x)/(−1/x²), which is unbounded negative.' from version_ins
union all select gen_random_uuid(), id, 'D', '1', true, 'Correct: Rewrite as (e^(1/x) − 1)/(1/x), a 0/0 form. L′Hôpital''s rule gives e^(1/x)(−1/x²)/(−1/x²) = e^(1/x), which tends to e⁰ = 1.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='3778d753-273a-403d-8f02-55dc64ec6a27' and content_key = any (array['apcalcbc-mcq-b4-sv-h-4.6-b-v1','apcalcbc-mcq-b4-sv-h-4.6-b-v2','apcalcbc-mcq-b4-sv-h-4.6-b-v3','apcalcbc-mcq-b4-h-4.7-a','apcalcbc-mcq-b4-sv-h-4.7-a-v1','apcalcbc-mcq-b4-sv-h-4.7-a-v2','apcalcbc-mcq-b4-sv-h-4.7-a-v3','apcalcbc-mcq-b4-h-4.7-b','apcalcbc-mcq-b4-sv-h-4.7-b-v1']) and status='draft')<>9 then raise exception 'chunk 6: expected 9 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='3778d753-273a-403d-8f02-55dc64ec6a27' and ci.content_key = any (array['apcalcbc-mcq-b4-sv-h-4.6-b-v1','apcalcbc-mcq-b4-sv-h-4.6-b-v2','apcalcbc-mcq-b4-sv-h-4.6-b-v3','apcalcbc-mcq-b4-h-4.7-a','apcalcbc-mcq-b4-sv-h-4.7-a-v1','apcalcbc-mcq-b4-sv-h-4.7-a-v2','apcalcbc-mcq-b4-sv-h-4.7-a-v3','apcalcbc-mcq-b4-h-4.7-b','apcalcbc-mcq-b4-sv-h-4.7-b-v1']))<>36 then raise exception 'chunk 6: expected 36 choices'; end if;
end $$;
commit;
