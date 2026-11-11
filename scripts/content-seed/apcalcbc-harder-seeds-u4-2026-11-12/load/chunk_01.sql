begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='3778d753-273a-403d-8f02-55dc64ec6a27' and content_key = any (array['apcalcbc-mcq-b4-h-4.1-a','apcalcbc-mcq-b4-sv-h-4.1-a-v1','apcalcbc-mcq-b4-sv-h-4.1-a-v2','apcalcbc-mcq-b4-sv-h-4.1-a-v3','apcalcbc-mcq-b4-h-4.1-b','apcalcbc-mcq-b4-sv-h-4.1-b-v1','apcalcbc-mcq-b4-sv-h-4.1-b-v2','apcalcbc-mcq-b4-sv-h-4.1-b-v3','apcalcbc-mcq-b4-h-4.2-a'])) then raise exception 'chunk 1 already loaded'; end if;
end $$;
-- apcalcbc-mcq-b4-h-4.1-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b4-h-4.1-a', 'mcq', 'interpret the derivative of a rate function in context, with units and sign, without confusing the rate with its own rat', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Water flows into a reservoir at a rate of F(t) thousand liters per hour, where t is the number of hours after midnight. At t = 6, F(6) = 4.2 and F′(6) = −0.5. Which statement is correct at t = 6?', null, md5('apcalcbc-mcq-b4-h-4.1-a'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The volume of water is decreasing at 0.5 thousand liters per hour.', false, 'This treats F′(6) as the rate of change of the volume, but F itself is the volume''s rate of change, so F′ is the rate at which the inflow rate is changing.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The volume of water is decreasing, because F′(6) is negative.', false, 'The sign of F′ shows whether the inflow rate is rising or falling, not whether the volume is rising; the volume rises because F(6) = 4.2 is positive.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The volume of water is increasing at 4.2 thousand liters per hour, and that rate of increase is decreasing at 0.5 thousand liters per hour per hour.', true, 'Correct: The volume V satisfies V′(t) = F(t), so V′(6) = 4.2 > 0 and the volume is increasing. Also V″(6) = F′(6) = −0.5, so the rate of increase is falling by 0.5 thousand liters per hour each hour.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The inflow rate will be exactly 3.7 thousand liters per hour at t = 7.', false, 'F′(6) is an instantaneous rate at t = 6, so multiplying it by one hour only approximates the change in F and does not give an exact value.' from version_ins;
-- apcalcbc-mcq-b4-sv-h-4.1-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b4-sv-h-4.1-a-v1', 'mcq', 'interpret the derivative of a rate function in context, with units and sign, without confusing the rate with its own rat (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Water leaves a lake through a dam at a rate of D(t) million gallons per day, where t is measured in days. At t = 10, D(10) = 3.0 and D′(10) = 0.4. Which statement is correct at t = 10?', null, md5('apcalcbc-mcq-b4-sv-h-4.1-a-v1'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The volume of the lake is increasing at 0.4 million gallons per day.', false, 'This reads D′(10) as the rate of change of the volume; the volume''s rate of change is −D(10), while D′ describes how the outflow rate itself is changing.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The volume of the lake is increasing at 3.0 million gallons per day, because D′(10) is positive.', false, 'A positive D′ means the outflow rate is rising, not that the lake is filling; water is leaving, so the volume decreases whenever D(10) is positive.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The volume of the lake is decreasing at 3.0 million gallons per day, and the outflow rate is increasing at 0.4 million gallons per day per day.', true, 'Correct: Volume V satisfies V′(t) = −D(t), so V′(10) = −3.0 and the volume is decreasing at 3.0 million gallons per day. D′(10) = 0.4 > 0 means the outflow rate is rising by 0.4 million gallons per day each day.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The outflow rate will be exactly 3.4 million gallons per day at t = 11.', false, 'D′(10) = 0.4 is an instantaneous rate at t = 10; adding it to D(10) for one full day is only an approximation, not an exact value.' from version_ins;
-- apcalcbc-mcq-b4-sv-h-4.1-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b4-sv-h-4.1-a-v2', 'mcq', 'interpret the derivative of a rate function in context, with units and sign, without confusing the rate with its own rat (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The rate at which customers enter a store is c(t) customers per minute, where t is the number of minutes after the store opens. At t = 20, c(20) = 6 and c′(20) = 0.3. Which statement is correct at t = 20?', null, md5('apcalcbc-mcq-b4-sv-h-4.1-a-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The number of customers who have entered is increasing at 0.3 customers per minute.', false, '0.3 is the value of c′(20), the rate at which the entry rate is changing; the number of customers who have entered changes at the entry rate c(20) = 6.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Customers are entering at 0.3 customers per minute at t = 20.', false, 'The entry rate at t = 20 is c(20) = 6 customers per minute; c′(20) = 0.3 has units of customers per minute per minute and measures how that rate is changing.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The entry rate will be exactly 6.3 customers per minute at t = 21.', false, 'The derivative is an instantaneous rate at t = 20, so using it over a full minute only approximates the new entry rate; it does not give an exact value.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The number of customers who have entered is increasing at 6 customers per minute, and that rate is increasing at 0.3 customers per minute per minute.', true, 'Correct: The count N of customers who have entered satisfies N′(t) = c(t), so N′(20) = 6 customers per minute. c′(20) = 0.3 > 0, so the entry rate itself is rising at 0.3 customers per minute each minute.' from version_ins;
-- apcalcbc-mcq-b4-sv-h-4.1-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b4-sv-h-4.1-a-v3', 'mcq', 'interpret the derivative of a rate function in context, with units and sign, without confusing the rate with its own rat (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Oil is pumped out of a storage tank at a rate of p(t) hundred barrels per hour, where t is measured in hours. At t = 3, p(3) = 5.5 and p′(3) = −0.8. Which statement is correct at t = 3?', null, md5('apcalcbc-mcq-b4-sv-h-4.1-a-v3'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The volume of oil is increasing at 0.8 hundred barrels per hour, because the pumping rate is falling.', false, 'A falling pumping rate means oil still leaves the tank, only more slowly; the volume keeps decreasing as long as p(3) is positive.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The volume of oil is decreasing at 5.5 hundred barrels per hour, and it is decreasing faster as time passes.', false, 'P′(3) is negative, so the pumping rate is shrinking; the volume''s rate of change −p(t) rises toward zero, which is a slowing decrease and not a faster one.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The pumping rate will be exactly 4.7 hundred barrels per hour at t = 4.', false, 'P′(3) = −0.8 is an instantaneous rate at t = 3, so applying it over one full hour gives only an approximation of p(4), not an exact value.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The volume of oil is decreasing at 5.5 hundred barrels per hour, and it is decreasing more slowly as time passes.', true, 'Correct: The volume V satisfies V′(t) = −p(t), so V′(3) = −5.5 (decreasing at 5.5). V″(3) = −p′(3) = 0.8 > 0, so V′ is rising toward zero and the decrease is slowing.' from version_ins;
-- apcalcbc-mcq-b4-h-4.1-b
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b4-h-4.1-b', 'mcq', 'estimate a derivative from a table with a symmetric difference quotient and interpret it as a rate with units, not as an', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The total cost, in dollars, of producing q units of a product is C(q). Selected values are given.
q | C(q)
400 | 1520
500 | 1800
600 | 2120
Using the table values at q = 400 and q = 600 to estimate the rate at which cost is changing at q = 500, which statement is correct?', null, md5('apcalcbc-mcq-b4-h-4.1-b'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The cost is changing at about $3.00 per unit, so each additional unit beyond 500 adds about $3.00 to the total cost.', true, 'Correct: C′(500) ≈ (C(600) − C(400))/(600 − 400) = (2120 − 1520)/200 = 3.00 dollars per unit.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The cost is changing at about $3.60 per unit, so each additional unit beyond 500 adds about $3.60 to the total cost.', false, '1800/500 = 3.60 is the average cost per unit of the first 500 units, which is not the rate at which total cost is changing at q = 500.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The cost is changing at about $600 per unit, so each additional unit beyond 500 adds about $600 to the total cost.', false, '600 is the change in cost over the whole interval from 400 to 600; it must be divided by the 200 units in that interval to give a rate per unit.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The cost is changing at about $1.50 per unit, so each additional unit beyond 500 adds about $1.50 to the total cost.', false, 'Dividing the 600 change in cost by 400 uses the lower input value rather than the width of the interval, which is 600 − 400 = 200.' from version_ins;
-- apcalcbc-mcq-b4-sv-h-4.1-b-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b4-sv-h-4.1-b-v1', 'mcq', 'estimate a derivative from a table with a symmetric difference quotient and interpret it as a rate with units, not as an (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A cup of coffee cools after it is poured. Its temperature, in degrees Fahrenheit, t minutes after pouring is T(t). Selected values are given.
t | T(t)
2 | 150
4 | 126
6 | 108
Using the table values at t = 2 and t = 6 to estimate the rate at which the temperature is changing at t = 4, which statement is correct?', null, md5('apcalcbc-mcq-b4-sv-h-4.1-b-v1'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The temperature is rising at about 10.5 degrees Fahrenheit per minute at t = 4.', false, 'The temperature drops from 150 to 108, so the difference quotient (108 − 150)/4 is negative; a positive rate would mean the coffee is warming up.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The temperature is falling at about 10.5 degrees Fahrenheit per minute at t = 4.', true, 'Correct: T′(4) ≈ (T(6) − T(2))/(6 − 2) = (108 − 150)/4 = −10.5 degrees Fahrenheit per minute.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The temperature is falling at about 42 degrees Fahrenheit per minute at t = 4.', false, '42 is the total drop in temperature over the four-minute interval from t = 2 to t = 6; it must be divided by 4 to give a rate per minute.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The temperature is falling at about 31.5 degrees Fahrenheit per minute at t = 4.', false, '126/4 = 31.5 divides the temperature by the time, which is a ratio of values and not the rate at which the temperature is changing.' from version_ins;
-- apcalcbc-mcq-b4-sv-h-4.1-b-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b4-sv-h-4.1-b-v2', 'mcq', 'estimate a derivative from a table with a symmetric difference quotient and interpret it as a rate with units, not as an (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A lake''s fish population, in thousands, is P(t), where t is the number of years since 2010. Selected values are given.
t | P(t)
0 | 84
5 | 90
10 | 98
Using the table values at t = 0 and t = 10 to estimate the rate at which the population is changing at t = 5, which statement is correct?', null, md5('apcalcbc-mcq-b4-sv-h-4.1-b-v2'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The population is growing at about 18 thousand fish per year in 2015.', false, '90/5 = 18 divides the population by the elapsed years, which is a ratio of values and not the rate at which the population is changing.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The population is growing at about 1.4 thousand fish per year in 2015.', true, 'Correct: P′(5) ≈ (P(10) − P(0))/(10 − 0) = (98 − 84)/10 = 1.4 thousand fish per year.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The population is growing at about 14 thousand fish per year in 2015.', false, '14 is the total change in population over the ten years from t = 0 to t = 10; it must be divided by 10 to give a rate per year.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The population is growing at about 2.8 thousand fish per year in 2015.', false, 'Dividing the 14 thousand change by 5 uses the distance from the middle point to one endpoint, but the two points used are 10 years apart.' from version_ins;
-- apcalcbc-mcq-b4-sv-h-4.1-b-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b4-sv-h-4.1-b-v3', 'mcq', 'estimate a derivative from a table with a symmetric difference quotient and interpret it as a rate with units, not as an (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The fuel in a vehicle''s tank, in gallons, t hours into a trip is G(t). Selected values are given.
t | G(t)
1 | 40
3 | 34
5 | 31
Using the table values at t = 1 and t = 5 to estimate the rate at which the fuel is changing at t = 3, which statement is correct?', null, md5('apcalcbc-mcq-b4-sv-h-4.1-b-v3'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The fuel is increasing at about 2.25 gallons per hour at t = 3.', false, 'The tank level falls from 40 to 31 gallons, so the difference quotient (31 − 40)/4 is negative; a positive rate would mean the tank is being filled.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The fuel is decreasing at about 11.3 gallons per hour at t = 3.', false, '34/3 is about 11.3 and divides the fuel level by the time elapsed, which is a ratio of values and not the rate at which the level is changing.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The fuel is decreasing at about 2.25 gallons per hour at t = 3.', true, 'Correct: G′(3) ≈ (G(5) − G(1))/(5 − 1) = (31 − 40)/4 = −2.25 gallons per hour.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The fuel is decreasing at about 9 gallons per hour at t = 3.', false, '9 is the total drop in fuel over the four-hour interval from t = 1 to t = 5; it must be divided by 4 to give a rate per hour.' from version_ins;
-- apcalcbc-mcq-b4-h-4.2-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b4-h-4.2-a', 'mcq', 'decide when a particle is speeding up by comparing the signs of velocity and acceleration, not either sign alone.', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A particle moves along the x-axis with velocity v(t) = t² − 5t + 4 for 0 ≤ t ≤ 6. On which time intervals is the particle speeding up?', null, md5('apcalcbc-mcq-b4-h-4.2-a'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '1 < t < 2.5 and 4 < t < 6', true, 'Correct: v = (t − 1)(t − 4) and a = 2t − 5. v and a are both negative on 1 < t < 2.5 and both positive on 4 < t < 6, so the particle speeds up exactly there.' from version_ins
union all select gen_random_uuid(), id, 'B', '0 < t < 1 and 4 < t < 6', false, 'These are the intervals where v is positive; speeding up needs v and a to share a sign, and on 0 < t < 1 the velocity is positive while a = 2t − 5 is negative, so the particle slows down.' from version_ins
union all select gen_random_uuid(), id, 'C', '2.5 < t < 6', false, 'This is where a is positive, but on 2.5 < t < 4 the velocity is negative while a is positive, so the particle is slowing down on that stretch.' from version_ins
union all select gen_random_uuid(), id, 'D', '1 < t < 4', false, 'This is where v is negative, meaning the particle moves left, but moving left is not the same as speeding up; on 2.5 < t < 4 the acceleration is positive, so it slows.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='3778d753-273a-403d-8f02-55dc64ec6a27' and content_key = any (array['apcalcbc-mcq-b4-h-4.1-a','apcalcbc-mcq-b4-sv-h-4.1-a-v1','apcalcbc-mcq-b4-sv-h-4.1-a-v2','apcalcbc-mcq-b4-sv-h-4.1-a-v3','apcalcbc-mcq-b4-h-4.1-b','apcalcbc-mcq-b4-sv-h-4.1-b-v1','apcalcbc-mcq-b4-sv-h-4.1-b-v2','apcalcbc-mcq-b4-sv-h-4.1-b-v3','apcalcbc-mcq-b4-h-4.2-a']) and status='draft')<>9 then raise exception 'chunk 1: expected 9 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='3778d753-273a-403d-8f02-55dc64ec6a27' and ci.content_key = any (array['apcalcbc-mcq-b4-h-4.1-a','apcalcbc-mcq-b4-sv-h-4.1-a-v1','apcalcbc-mcq-b4-sv-h-4.1-a-v2','apcalcbc-mcq-b4-sv-h-4.1-a-v3','apcalcbc-mcq-b4-h-4.1-b','apcalcbc-mcq-b4-sv-h-4.1-b-v1','apcalcbc-mcq-b4-sv-h-4.1-b-v2','apcalcbc-mcq-b4-sv-h-4.1-b-v3','apcalcbc-mcq-b4-h-4.2-a']))<>36 then raise exception 'chunk 1: expected 36 choices'; end if;
end $$;
commit;
